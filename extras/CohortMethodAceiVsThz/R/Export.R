# Copyright 2018 Observational Health Data Sciences and Informatics
#
# This file is part of CohortMethodAceiVsThz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Export all results to tables
#'
#' @description
#' Outputs all results to a folder called 'export', and zips them.
#'
#' @param outputFolder          Name of local folder to place results; make sure to use forward slashes
#'                              (/). Do not use a folder on a network drive since this greatly impacts
#'                              performance.
#' @param databaseId            A short string for identifying the database (e.g. 'Synpuf').
#' @param databaseName          The full name of the database.
#' @param databaseDescription   A short description (several sentences) of the database.
#' @param minCellCount          The minimum cell count for fields contains person counts or fractions.
#' @param maxCores              How many parallel cores should be used? If more cores are made
#'                              available this can speed up the analyses.
#'
#' @export
exportResults <- function(outputFolder,
                          databaseId,
                          databaseName,
                          databaseDescription,
                          minCellCount = 5,
                          maxCores) {
  exportFolder <- file.path(outputFolder, "export")
  if (!file.exists(exportFolder)) {
    dir.create(exportFolder, recursive = TRUE)
  }
  
  exportAnalyses(outputFolder = outputFolder,
                 exportFolder = exportFolder)
  
  exportExposures(outputFolder = outputFolder,
                  exportFolder = exportFolder)
  
  exportOutcomes(outputFolder = outputFolder,
                 exportFolder = exportFolder)
  
  exportMetadata(outputFolder = outputFolder,
                 exportFolder = exportFolder,
                 databaseId = databaseId,
                 databaseName = databaseName,
                 databaseDescription = databaseDescription,
                 minCellCount = minCellCount)
  
  exportMainResults(outputFolder = outputFolder,
                    exportFolder = exportFolder,
                    databaseId = databaseId,
                    minCellCount = minCellCount,
                    maxCores = maxCores)
  
  exportDiagnostics(outputFolder = outputFolder,
                    exportFolder = exportFolder,
                    databaseId = databaseId,
                    minCellCount = minCellCount,
                    maxCores = maxCores)
  
  # Add all to zip file -------------------------------------------------------------------------------
  ParallelLogger::logInfo("Adding results to zip file")
  zipName <- file.path(exportFolder, paste0("Results", databaseId, ".zip"))
  files <- list.files(exportFolder, pattern = ".*\\.csv$")
  oldWd <- setwd(exportFolder)
  on.exit(setwd(oldWd))
  DatabaseConnector::createZipFile(zipFile = zipName, files = files)
  ParallelLogger::logInfo("Results are ready for sharing at:", zipName)
}

exportAnalyses <- function(outputFolder, exportFolder) {
  ParallelLogger::logInfo("Exporting analyses")
  ParallelLogger::logInfo("- cohort_method_analysis table")
  
  tempFileName <- tempfile()
  
  cmAnalysisListFile <- system.file("settings",
                                    "cmAnalysisList.json",
                                    package = "CohortMethodAceiVsThz")
  cmAnalysisList <- CohortMethod::loadCmAnalysisList(cmAnalysisListFile)
  cmAnalysisToRow <- function(cmAnalysis) {
    ParallelLogger::saveSettingsToJson(cmAnalysis, tempFileName)
    row <- data.frame(analysisId = cmAnalysis$analysisId,
                      description = cmAnalysis$description,
                      definition = readChar(tempFileName, file.info(tempFileName)$size))
    return(row)
  }
  cohortMethodAnalysis <- lapply(cmAnalysisList, cmAnalysisToRow)
  cohortMethodAnalysis <- do.call("rbind", cohortMethodAnalysis)
  cohortMethodAnalysis <- unique(cohortMethodAnalysis)
  unlink(tempFileName)
  colnames(cohortMethodAnalysis) <- SqlRender::camelCaseToSnakeCase(colnames(cohortMethodAnalysis))
  fileName <- file.path(exportFolder, "cohort_method_analysis.csv")
  write.csv(cohortMethodAnalysis, fileName, row.names = FALSE)
  
  
  ParallelLogger::logInfo("- covariate_analysis table")
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  getCovariateAnalyses <- function(cmDataFolder) {
    cmData <- CohortMethod::loadCohortMethodData(file.path(outputFolder, "cmOutput", cmDataFolder), readOnly = TRUE)
    covariateAnalysis <- ff::as.ram(cmData$analysisRef)
    covariateAnalysis <- covariateAnalysis[, c("analysisId", "analysisName")]
    return(covariateAnalysis)
  }
  covariateAnalysis <- lapply(unique(reference$cohortMethodDataFolder), getCovariateAnalyses)
  covariateAnalysis <- do.call("rbind", covariateAnalysis)
  covariateAnalysis <- unique(covariateAnalysis)
  colnames(covariateAnalysis) <- c("covariate_analysis_id", "covariate_analysis_name")
  fileName <- file.path(exportFolder, "covariate_analysis.csv")
  write.csv(covariateAnalysis, fileName, row.names = FALSE)
}

exportExposures <- function(outputFolder, exportFolder) {
  ParallelLogger::logInfo("Exporting exposures")
  ParallelLogger::logInfo("- exposure_of_interest table")
  pathToCsv <- system.file("settings", "TcosOfInterest.csv", package = "CohortMethodAceiVsThz")
  tcosOfInterest <- read.csv(pathToCsv, stringsAsFactors = FALSE)
  pathToCsv <- system.file("settings", "CohortsToCreate.csv", package = "CohortMethodAceiVsThz")
  cohortsToCreate <- read.csv(pathToCsv)
  createExposureRow <- function(exposureId) {
    atlasName <- as.character(cohortsToCreate$atlasName[cohortsToCreate$cohortId == exposureId])
    name <- as.character(cohortsToCreate$name[cohortsToCreate$cohortId == exposureId])
    cohortFileName <- system.file("cohorts", paste0(name, ".json"), package = "CohortMethodAceiVsThz")
    definition <- readChar(cohortFileName, file.info(cohortFileName)$size)
    return(data.frame(exposureId = exposureId,
                      exposureName = atlasName,
                      definition = definition))
  }
  exposuresOfInterest <- unique(c(tcosOfInterest$targetId, tcosOfInterest$comparatorId))
  exposureOfInterest <- lapply(exposuresOfInterest, createExposureRow)
  exposureOfInterest <- do.call("rbind", exposureOfInterest)
  colnames(exposureOfInterest) <- SqlRender::camelCaseToSnakeCase(colnames(exposureOfInterest))
  fileName <- file.path(exportFolder, "exposure_of_interest.csv")
  write.csv(exposureOfInterest, fileName, row.names = FALSE)
}

exportOutcomes <- function(outputFolder, exportFolder) {
  ParallelLogger::logInfo("Exporting outcomes")
  ParallelLogger::logInfo("- outcome_of_interest table")
  pathToCsv <- system.file("settings", "CohortsToCreate.csv", package = "CohortMethodAceiVsThz")
  cohortsToCreate <- read.csv(pathToCsv)
  createOutcomeRow <- function(outcomeId) {
    atlasName <- as.character(cohortsToCreate$atlasName[cohortsToCreate$cohortId == outcomeId])
    name <- as.character(cohortsToCreate$name[cohortsToCreate$cohortId == outcomeId])
    cohortFileName <- system.file("cohorts", paste0(name, ".json"), package = "CohortMethodAceiVsThz")
    definition <- readChar(cohortFileName, file.info(cohortFileName)$size)
    return(data.frame(outcomeId = outcomeId,
                      outcomeName = atlasName,
                      definition = definition))
  }
  outcomesOfInterest <- getOutcomesOfInterest()
  outcomeOfInterest <- lapply(outcomesOfInterest, createOutcomeRow)
  outcomeOfInterest <- do.call("rbind", outcomeOfInterest)
  colnames(outcomeOfInterest) <- SqlRender::camelCaseToSnakeCase(colnames(outcomeOfInterest))
  fileName <- file.path(exportFolder, "outcome_of_interest.csv")
  write.csv(outcomeOfInterest, fileName, row.names = FALSE) 
  
  
  ParallelLogger::logInfo("- negative_control_outcome table")
  pathToCsv <- system.file("settings", "NegativeControls.csv", package = "CohortMethodAceiVsThz")
  negativeControls <- read.csv(pathToCsv)
  negativeControls <- negativeControls[tolower(negativeControls$type) == "outcome", ]
  negativeControls <- negativeControls[, c("outcomeId", "outcomeName")]
  colnames(negativeControls) <- SqlRender::camelCaseToSnakeCase(colnames(negativeControls))
  fileName <- file.path(exportFolder, "negative_control_outcome.csv")
  write.csv(negativeControls, fileName, row.names = FALSE)
  
  
  synthesisSummaryFile <- file.path(outputFolder, "SynthesisSummary.csv")
  if (file.exists(synthesisSummaryFile)) {
    positiveControls <- read.csv(synthesisSummaryFile, stringsAsFactors = FALSE)
    pathToCsv <- system.file("settings", "NegativeControls.csv", package = "CohortMethodAceiVsThz")
    negativeControls <- read.csv(pathToCsv)
    positiveControls <- merge(positiveControls,
                              negativeControls[, c("outcomeId", "outcomeName")])
    positiveControls$outcomeName <- paste0(positiveControls$outcomeName,
                                           ", RR = ",
                                           positiveControls$targetEffectSize)
    positiveControls <- positiveControls[, c("newOutcomeId",
                                             "outcomeName",
                                             "exposureId",
                                             "outcomeId",
                                             "targetEffectSize")]
    colnames(positiveControls) <- c("outcomeId",
                                    "outcomeName",
                                    "exposureId",
                                    "negativeControlId",
                                    "effectSize")
    colnames(positiveControls) <- SqlRender::camelCaseToSnakeCase(colnames(positiveControls))
    fileName <- file.path(exportFolder, "positive_control_outcome.csv")
    write.csv(positiveControls, fileName, row.names = FALSE)
  }
}

exportMetadata <- function(outputFolder,
                           exportFolder,
                           databaseId,
                           databaseName,
                           databaseDescription,
                           minCellCount) {
  ParallelLogger::logInfo("Exporting metadata")
  
  getInfo <- function(row) {
    cmData <- CohortMethod::loadCohortMethodData(file.path(outputFolder, "cmOutput", row$cohortMethodDataFolder), skipCovariates = TRUE)
    info <- data.frame(targetId = row$targetId,
                       comparatorId = row$comparatorId,
                       targetMinDate = min(cmData$cohorts$cohortStartDate[cmData$cohorts$treatment == 1]),
                       targetMaxDate = max(cmData$cohorts$cohortStartDate[cmData$cohorts$treatment == 1]),
                       comparatorMinDate = min(cmData$cohorts$cohortStartDate[cmData$cohorts$treatment == 0]),
                       comparatorMaxDate = max(cmData$cohorts$cohortStartDate[cmData$cohorts$treatment == 0]))
    info$comparisonMinDate <- min(info$targetMinDate, info$comparatorMinDate)
    info$comparisonMaxDate <- min(info$targetMaxDate, info$comparatorMaxDate)
    return(info)
  }
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  reference <- unique(reference[, c("targetId", "comparatorId", "cohortMethodDataFolder")])
  reference <- split(reference, reference$cohortMethodDataFolder)
  info <- lapply(reference, getInfo)
  info <- do.call("rbind", info)
  
  
  ParallelLogger::logInfo("- database table")
  database <- data.frame(database_id = databaseId,
                         database_name = databaseName,
                         description = databaseDescription,
                         is_meta_analysis = 0)
  fileName <- file.path(exportFolder, "database.csv")
  write.csv(database, fileName, row.names = FALSE)
  
  
  ParallelLogger::logInfo("- exposure_summary table")
  minDates <- rbind(data.frame(exposureId = info$targetId,
                                   minDate = info$targetMinDate),
                        data.frame(exposureId = info$comparatorId,
                                   minDate = info$comparatorMinDate))
  minDates <- aggregate(minDate ~ exposureId, minDates, min)
  maxDates <- rbind(data.frame(exposureId = info$targetId,
                               maxDate = info$targetMaxDate),
                    data.frame(exposureId = info$comparatorId,
                               maxDate = info$comparatorMaxDate))
  maxDates <- aggregate(maxDate ~ exposureId, maxDates, max)
  exposureSummary <- merge(minDates, maxDates)
  exposureSummary$databaseId <- databaseId
  colnames(exposureSummary) <- SqlRender::camelCaseToSnakeCase(colnames(exposureSummary))
  fileName <- file.path(exportFolder, "exposure_summary.csv")
  write.csv(exposureSummary, fileName, row.names = FALSE)
  
  ParallelLogger::logInfo("- comparison_summary table")
  minDates <- aggregate(comparisonMinDate ~ targetId + comparatorId, info, min)
  maxDates <- aggregate(comparisonMaxDate ~ targetId + comparatorId, info, max)
  comparisonSummary <- merge(minDates, maxDates)
  comparisonSummary$databaseId <- databaseId
  colnames(comparisonSummary)[colnames(comparisonSummary) == "comparisonMinDate"] <- "minDate"
  colnames(comparisonSummary)[colnames(comparisonSummary) == "comparisonMaxDate"] <- "maxDate"
  colnames(comparisonSummary) <- SqlRender::camelCaseToSnakeCase(colnames(comparisonSummary))
  fileName <- file.path(exportFolder, "comparison_summary.csv")
  write.csv(comparisonSummary, fileName, row.names = FALSE)
  
  
  ParallelLogger::logInfo("- attrition table")
  fileName <- file.path(exportFolder, "attrition.csv")
  if (file.exists(fileName)) {
    unlink(fileName)
  }
  outcomesOfInterest <- getOutcomesOfInterest()
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  reference <- reference[reference$outcomeId %in% outcomesOfInterest, ]
  first <- !file.exists(fileName)
  pb <- txtProgressBar(style = 3)
  for (i in 1:nrow(reference)) {
    outcomeModel <- readRDS(file.path(outputFolder,
                                      "cmOutput",
                                      reference$outcomeModelFile[i]))
    attrition <- outcomeModel$attrition[, c("description", "targetPersons", "comparatorPersons")]
    attrition$sequenceNumber <- 1:nrow(attrition)
    attrition1 <- attrition[, c("sequenceNumber", "description", "targetPersons")]
    colnames(attrition1)[3] <- "subjects"
    attrition1$exposureId <- reference$targetId[i]
    attrition2 <- attrition[, c("sequenceNumber", "description", "comparatorPersons")]
    colnames(attrition2)[3] <- "subjects"
    attrition2$exposureId <- reference$comparatorId[i]
    attrition <- rbind(attrition1, attrition2)
    attrition$targetId <- reference$targetId[i]
    attrition$comparatorId <- reference$comparatorId[i]
    attrition$analysisId <- reference$analysisId[i]
    attrition$outcomeId <- reference$outcomeId[i]
    attrition$databaseId <- databaseId
    attrition <- attrition[, c("databaseId",
                               "exposureId",
                               "targetId",
                               "comparatorId",
                               "outcomeId",
                               "analysisId",
                               "sequenceNumber",
                               "description",
                               "subjects")]
    attrition <- enforceMinCellValue(attrition, "subjects", minCellCount, silent = TRUE)
    
    colnames(attrition) <- SqlRender::camelCaseToSnakeCase(colnames(attrition))
    write.table(x = attrition,
                file = fileName,
                row.names = FALSE,
                col.names = first,
                sep = ",",
                dec = ".",
                qmethod = "double",
                append = !first)
    first <- FALSE
    if (i%%100 == 10) {
      setTxtProgressBar(pb, i/nrow(reference))
    }
  }
  setTxtProgressBar(pb, 1)
  close(pb)
  
  
  ParallelLogger::logInfo("- covariate table")
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  getCovariates <- function(cmDataFolder) {
    cmData <- CohortMethod::loadCohortMethodData(file.path(outputFolder, "cmOutput", cmDataFolder), readOnly = TRUE)
    covariateRef <- ff::as.ram(cmData$covariateRef)
    covariateRef <- covariateRef[, c("covariateId", "covariateName", "analysisId")]
    colnames(covariateRef) <- c("covariateId", "covariateName", "covariateAnalysisId")
    return(covariateRef)
  }
  covariates <- lapply(unique(reference$cohortMethodDataFolder), getCovariates)
  covariates <- do.call("rbind", covariates)
  covariates <- unique(covariates)
  covariates$databaseId <- databaseId
  colnames(covariates) <- SqlRender::camelCaseToSnakeCase(colnames(covariates))
  fileName <- file.path(exportFolder, "covariate.csv")
  write.csv(covariates, fileName, row.names = FALSE)
  rm(covariates)  # Free up memory
  
  
  ParallelLogger::logInfo("- cm_follow_up_dist table")
  getResult <- function(i) {
    if (reference$strataFile[i] == "") {
      strataPop <- readRDS(file.path(outputFolder,
                                     "cmOutput",
                                     reference$studyPopFile[i]))
    } else {
      strataPop <- readRDS(file.path(outputFolder,
                                     "cmOutput",
                                     reference$strataFile[i]))
    }
   
    targetDist <- quantile(strataPop$survivalTime[strataPop$treatment == 1],
                           c(0, 0.1, 0.25, 0.5, 0.85, 0.9, 1))
    comparatorDist <- quantile(strataPop$survivalTime[strataPop$treatment == 0],
                               c(0, 0.1, 0.25, 0.5, 0.85, 0.9, 1))
    row <- data.frame(target_id = reference$targetId[i],
                      comparator_id = reference$comparatorId[i],
                      outcome_id = reference$outcomeId[i],
                      analysis_id = reference$analysisId[i],
                      target_min_days = targetDist[1],
                      target_p10_days = targetDist[2],
                      target_p25_days = targetDist[3],
                      target_median_days = targetDist[4],
                      target_p75_days = targetDist[5],
                      target_p90_days = targetDist[6],
                      target_max_days = targetDist[7],
                      comparator_min_days = comparatorDist[1],
                      comparator_p10_days = comparatorDist[2],
                      comparator_p25_days = comparatorDist[3],
                      comparator_median_days = comparatorDist[4],
                      comparator_p75_days = comparatorDist[5],
                      comparator_p90_days = comparatorDist[6],
                      comparator_max_days = comparatorDist[7])
    return(row)
  }
  outcomesOfInterest <- getOutcomesOfInterest()
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  reference <- reference[reference$outcomeId %in% outcomesOfInterest, ]
  results <- plyr::llply(1:nrow(reference), getResult, .progress = "text")
  results <- do.call("rbind", results)
  results$database_id <- databaseId
  fileName <- file.path(exportFolder, "cm_follow_up_dist.csv")
  write.csv(results, fileName, row.names = FALSE)
  rm(results)  # Free up memory
}

enforceMinCellValue <- function(data, fieldName, minValues, silent = FALSE) {
  toCensor <- !is.na(data[, fieldName]) & data[, fieldName] < minValues & data[, fieldName] != 0
  if (!silent) {
    percent <- round(100 * sum(toCensor)/nrow(data), 1)
    ParallelLogger::logInfo("   censoring ",
                            sum(toCensor),
                            " values (",
                            percent,
                            "%) from ",
                            fieldName,
                            " because value below minimum")
  }
  if (length(minValues) == 1) {
    data[toCensor, fieldName] <- -minValues
  } else {
    data[toCensor, fieldName] <- -minValues[toCensor]
  }
  return(data)
}


exportMainResults <- function(outputFolder,
                              exportFolder,
                              databaseId,
                              minCellCount,
                              maxCores) {
  ParallelLogger::logInfo("Exporting main results")
  
  
  ParallelLogger::logInfo("- cohort_method_result table")
  analysesSum <- read.csv(file.path(outputFolder, "analysisSummary.csv"))
  allControls <- getAllControls(outputFolder)
  ParallelLogger::logInfo("  Performing empirical calibration on main effects")
  cluster <- ParallelLogger::makeCluster(min(4, maxCores))
  subsets <- split(analysesSum,
                   paste(analysesSum$targetId, analysesSum$comparatorId, analysesSum$analysisId))
  rm(analysesSum)  # Free up memory
  results <- ParallelLogger::clusterApply(cluster,
                                          subsets,
                                          calibrate,
                                          allControls = allControls)
  ParallelLogger::stopCluster(cluster)
  rm(subsets)  # Free up memory
  results <- do.call("rbind", results)
  results$databaseId <- databaseId
  results <- enforceMinCellValue(results, "targetSubjects", minCellCount)
  results <- enforceMinCellValue(results, "comparatorSubjects", minCellCount)
  results <- enforceMinCellValue(results, "targetOutcomes", minCellCount)
  results <- enforceMinCellValue(results, "comparatorOutcomes", minCellCount)
  colnames(results) <- SqlRender::camelCaseToSnakeCase(colnames(results))
  fileName <- file.path(exportFolder, "cohort_method_result.csv")
  write.csv(results, fileName, row.names = FALSE)
  rm(results)  # Free up memory
  
  ParallelLogger::logInfo("- cm_interaction_result table")
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  loadInteractionsFromOutcomeModel <- function(i) {
    outcomeModel <- readRDS(file.path(outputFolder,
                                      "cmOutput",
                                      reference$outcomeModelFile[i]))
    if (!is.null(outcomeModel$subgroupCounts)) {
      rows <- data.frame(targetId = reference$targetId[i],
                         comparatorId = reference$comparatorId[i],
                         outcomeId = reference$outcomeId[i],
                         analysisId = reference$analysisId[i],
                         interactionCovariateId = outcomeModel$subgroupCounts$subgroupCovariateId,
                         rrr = NA,
                         ci95Lb = NA,
                         ci95Ub = NA,
                         p = NA,
                         i2 = NA,
                         logRrr = NA,
                         seLogRrr = NA,
                         targetSubjects = outcomeModel$subgroupCounts$targetPersons,
                         comparatorSubjects = outcomeModel$subgroupCounts$comparatorPersons,
                         targetDays = outcomeModel$subgroupCounts$targetDays,
                         comparatorDays = outcomeModel$subgroupCounts$comparatorDays,
                         targetOutcomes = outcomeModel$subgroupCounts$targetOutcomes,
                         comparatorOutcomes = outcomeModel$subgroupCounts$comparatorOutcomes)
      if (!is.null(outcomeModel$outcomeModelInteractionEstimates)) {
        idx <- match(outcomeModel$outcomeModelInteractionEstimates$covariateId,
                     rows$interactionCovariateId)
        rows$rrr[idx] <- exp(outcomeModel$outcomeModelInteractionEstimates$logRr)
        rows$ci95Lb[idx] <- exp(outcomeModel$outcomeModelInteractionEstimates$logLb95)
        rows$ci95Ub[idx] <- exp(outcomeModel$outcomeModelInteractionEstimates$logUb95)
        rows$logRrr[idx] <- outcomeModel$outcomeModelInteractionEstimates$logRr
        rows$seLogRrr[idx] <- outcomeModel$outcomeModelInteractionEstimates$seLogRr
        z <- rows$logRrr[idx]/rows$seLogRrr[idx]
        rows$p[idx] <- 2 * pmin(pnorm(z), 1 - pnorm(z))
      }
      return(rows)
    } else {
      return(NULL)
    }
    
  }
  interactions <- plyr::llply(1:nrow(reference),
                              loadInteractionsFromOutcomeModel,
                              .progress = "text")
  interactions <- do.call("rbind", interactions)
  if (!is.null(interactions)) {
    ParallelLogger::logInfo("  Performing empirical calibration on interaction effects")
    allControls <- getAllControls(outputFolder)
    negativeControls <- allControls[allControls$targetEffectSize == 1, ]
    cluster <- ParallelLogger::makeCluster(min(4, maxCores))
    subsets <- split(interactions,
                     paste(interactions$targetId, interactions$comparatorId, interactions$analysisId))
    interactions <- ParallelLogger::clusterApply(cluster,
                                                 subsets,
                                                 calibrateInteractions,
                                                 negativeControls = negativeControls)
    ParallelLogger::stopCluster(cluster)
    rm(subsets)  # Free up memory
    interactions <- do.call("rbind", interactions)
    interactions$databaseId <- databaseId
    
    interactions <- enforceMinCellValue(interactions, "targetSubjects", minCellCount)
    interactions <- enforceMinCellValue(interactions, "comparatorSubjects", minCellCount)
    interactions <- enforceMinCellValue(interactions, "targetOutcomes", minCellCount)
    interactions <- enforceMinCellValue(interactions, "comparatorOutcomes", minCellCount)
    colnames(interactions) <- SqlRender::camelCaseToSnakeCase(colnames(interactions))
    fileName <- file.path(exportFolder, "cm_interaction_result.csv")
    write.csv(interactions, fileName, row.names = FALSE)
    rm(interactions)  # Free up memory
  }
}

calibrate <- function(subset, allControls) {
  ncs <- subset[subset$outcomeId %in% allControls$outcomeId[allControls$targetEffectSize == 1], ]
  ncs <- ncs[!is.na(ncs$seLogRr), ]
  if (nrow(ncs) > 5) {
    null <- EmpiricalCalibration::fitMcmcNull(ncs$logRr, ncs$seLogRr)
    calibratedP <- EmpiricalCalibration::calibrateP(null = null,
                                                    logRr = subset$logRr,
                                                    seLogRr = subset$seLogRr)
    subset$calibratedP <- calibratedP$p
  } else {
    subset$calibratedP <- rep(NA, nrow(subset))
  }
  pcs <- subset[subset$outcomeId %in% allControls$outcomeId[allControls$targetEffectSize != 1], ]
  pcs <- pcs[!is.na(pcs$seLogRr), ]
  if (nrow(pcs) > 5) {
    controls <- merge(subset, allControls[, c("targetId", "comparatorId", "outcomeId", "targetEffectSize")])
    model <- EmpiricalCalibration::fitSystematicErrorModel(logRr = controls$logRr,
                                                           seLogRr = controls$seLogRr,
                                                           trueLogRr = log(controls$targetEffectSize),
                                                           estimateCovarianceMatrix = FALSE)
    calibratedCi <- EmpiricalCalibration::calibrateConfidenceInterval(logRr = subset$logRr,
                                                                      seLogRr = subset$seLogRr,
                                                                      model = model)
    subset$calibratedRr <- exp(calibratedCi$logRr)
    subset$calibratedCi95Lb <- exp(calibratedCi$logLb95Rr)
    subset$calibratedCi95Ub <- exp(calibratedCi$logUb95Rr)
    subset$calibratedLogRr <- calibratedCi$logRr
    subset$calibratedSeLogRr <- calibratedCi$seLogRr
  } else {
    subset$calibratedRr <- rep(NA, nrow(subset))
    subset$calibratedCi95Lb <- rep(NA, nrow(subset))
    subset$calibratedCi95Ub <- rep(NA, nrow(subset))
    subset$calibratedLogRr <- rep(NA, nrow(subset))
    subset$calibratedSeLogRr <- rep(NA, nrow(subset))
  }
  subset$i2 <- rep(NA, nrow(subset))
  subset <- subset[, c("targetId",
                       "comparatorId",
                       "outcomeId",
                       "analysisId",
                       "rr",
                       "ci95lb",
                       "ci95ub",
                       "p",
                       "i2",
                       "logRr",
                       "seLogRr",
                       "target",
                       "comparator",
                       "targetDays",
                       "comparatorDays",
                       "eventsTarget",
                       "eventsComparator",
                       "calibratedP",
                       "calibratedRr",
                       "calibratedCi95Lb",
                       "calibratedCi95Ub",
                       "calibratedLogRr",
                       "calibratedSeLogRr")]
  colnames(subset) <- c("targetId",
                        "comparatorId",
                        "outcomeId",
                        "analysisId",
                        "rr",
                        "ci95Lb",
                        "ci95Ub",
                        "p",
                        "i2",
                        "logRr",
                        "seLogRr",
                        "targetSubjects",
                        "comparatorSubjects",
                        "targetDays",
                        "comparatorDays",
                        "targetOutcomes",
                        "comparatorOutcomes",
                        "calibratedP",
                        "calibratedRr",
                        "calibratedCi95Lb",
                        "calibratedCi95Ub",
                        "calibratedLogRr",
                        "calibratedSeLogRr")
  return(subset)
}

calibrateInteractions <- function(subset, negativeControls) {
  ncs <- subset[subset$outcomeId %in% negativeControls$outcomeId, ]
  ncs <- ncs[!is.na(ncs$seLogRr), ]
  if (nrow(ncs) > 5) {
    null <- EmpiricalCalibration::fitMcmcNull(ncs$logRr, ncs$seLogRr)
    calibratedP <- EmpiricalCalibration::calibrateP(null = null,
                                                    logRr = subset$logRr,
                                                    seLogRr = subset$seLogRr)
    subset$calibratedP <- calibratedP$p
  } else {
    subset$calibratedP <- rep(NA, nrow(subset))
  }
  return(subset)
}


exportDiagnostics <- function(outputFolder,
                              exportFolder,
                              databaseId,
                              minCellCount,
                              maxCores) {
  ParallelLogger::logInfo("Exporting diagnostics")
  ParallelLogger::logInfo("- covariate_balance table")
  fileName <- file.path(exportFolder, "covariate_balance.csv")
  if (file.exists(fileName)) {
    unlink(fileName)
  }
  first <- TRUE
  balanceFolder <- file.path(outputFolder, "balance")
  files <- list.files(balanceFolder, pattern = "bal_.*.rds", full.names = TRUE)
  pb <- txtProgressBar(style = 3)
  for (i in 1:length(files)) {
    ids <- gsub("^.*bal_t", "", files[i])
    targetId <- as.numeric(gsub("_c.*", "", ids))
    ids <- gsub("^.*_c", "", ids)
    comparatorId <- as.numeric(gsub("_[aso].*$", "", ids))
    if (grepl("_s", ids)) {
      subgroupId <- as.numeric(gsub("^.*_s", "", gsub("_a[0-9]*.rds", "", ids)))
    } else {
      subgroupId <- NA
    }
    if (grepl("_o", ids)) {
      outcomeId <- as.numeric(gsub("^.*_o", "", gsub("_a[0-9]*.rds", "", ids)))
    } else {
      outcomeId <- NA
    }
    ids <- gsub("^.*_a", "", ids)
    analysisId <- as.numeric(gsub(".rds", "", ids))
    balance <- readRDS(files[i])
    inferredTargetBeforeSize <- mean(balance$beforeMatchingSumTarget/balance$beforeMatchingMeanTarget,
                                     na.rm = TRUE)
    inferredComparatorBeforeSize <- mean(balance$beforeMatchingSumComparator/balance$beforeMatchingMeanComparator,
                                         na.rm = TRUE)
    inferredTargetAfterSize <- mean(balance$afterMatchingSumTarget/balance$afterMatchingMeanTarget,
                                    na.rm = TRUE)
    inferredComparatorAfterSize <- mean(balance$afterMatchingSumComparator/balance$afterMatchingMeanComparator,
                                        na.rm = TRUE)
    
    balance$databaseId <- databaseId
    balance$targetId <- targetId
    balance$comparatorId <- comparatorId
    balance$outcomeId <- outcomeId
    balance$analysisId <- analysisId
    balance$interactionCovariateId <- subgroupId
    balance <- balance[, c("databaseId",
                           "targetId",
                           "comparatorId",
                           "outcomeId",
                           "analysisId",
                           "interactionCovariateId",
                           "covariateId",
                           "beforeMatchingMeanTarget",
                           "beforeMatchingMeanComparator",
                           "beforeMatchingStdDiff",
                           "afterMatchingMeanTarget",
                           "afterMatchingMeanComparator",
                           "afterMatchingStdDiff")]
    colnames(balance) <- c("databaseId",
                           "targetId",
                           "comparatorId",
                           "outcomeId",
                           "analysisId",
                           "interactionCovariateId",
                           "covariateId",
                           "targetMeanBefore",
                           "comparatorMeanBefore",
                           "stdDiffBefore",
                           "targetMeanAfter",
                           "comparatorMeanAfter",
                           "stdDiffAfter")
    balance$targetMeanBefore[is.na(balance$targetMeanBefore)] <- 0
    balance$comparatorMeanBefore[is.na(balance$comparatorMeanBefore)] <- 0
    balance$stdDiffBefore <- round(balance$stdDiffBefore, 3)
    balance$targetMeanAfter[is.na(balance$targetMeanAfter)] <- 0
    balance$comparatorMeanAfter[is.na(balance$comparatorMeanAfter)] <- 0
    balance$stdDiffAfter <- round(balance$stdDiffAfter, 3)
    balance <- enforceMinCellValue(balance,
                                   "targetMeanBefore",
                                   minCellCount/inferredTargetBeforeSize,
                                   TRUE)
    balance <- enforceMinCellValue(balance,
                                   "comparatorMeanBefore",
                                   minCellCount/inferredComparatorBeforeSize,
                                   TRUE)
    balance <- enforceMinCellValue(balance,
                                   "targetMeanAfter",
                                   minCellCount/inferredTargetAfterSize,
                                   TRUE)
    balance <- enforceMinCellValue(balance,
                                   "comparatorMeanAfter",
                                   minCellCount/inferredComparatorAfterSize,
                                   TRUE)
    balance$targetMeanBefore <- round(balance$targetMeanBefore, 3)
    balance$comparatorMeanBefore <- round(balance$comparatorMeanBefore, 3)
    balance$targetMeanAfter <- round(balance$targetMeanAfter, 3)
    balance$comparatorMeanAfter <- round(balance$comparatorMeanAfter, 3)
    balance <- balance[balance$targetMeanBefore != 0 & balance$comparatorMeanBefore != 0 & balance$targetMeanAfter !=
                         0 & balance$comparatorMeanAfter != 0 & balance$stdDiffBefore != 0 & balance$stdDiffAfter !=
                         0, ]
    balance <- balance[!is.na(balance$targetId), ]
    colnames(balance) <- SqlRender::camelCaseToSnakeCase(colnames(balance))
    write.table(x = balance,
                file = fileName,
                row.names = FALSE,
                col.names = first,
                sep = ",",
                dec = ".",
                qmethod = "double",
                append = !first)
    first <- FALSE
    setTxtProgressBar(pb, i/length(files))
  }
  close(pb)
  
  ParallelLogger::logInfo("- preference_score_dist table")
  preparePlot <- function(i, reference) {
    psFileName <- file.path(outputFolder,
                            "cmOutput",
                            reference$sharedPsFile[i])
    if (file.exists(psFileName)) {
      ps <- readRDS(psFileName)
      if (min(ps$propensityScore) < max(ps$propensityScore)) {
        ps <- CohortMethod:::computePreferenceScore(ps)
        
        d1 <- density(ps$preferenceScore[ps$treatment == 1], from = 0, to = 1, n = 100)
        d0 <- density(ps$preferenceScore[ps$treatment == 0], from = 0, to = 1, n = 100)
        
        result <- data.frame(databaseId = databaseId,
                             targetId = reference$targetId[i],
                             comparatorId = reference$comparatorId[i],
                             preferenceScore = d1$x,
                             targetDensity = d1$y,
                             comparatorDensity = d0$y)
        return(result)
      }
    }
    return(NULL)
  }
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  reference <- reference[order(reference$sharedPsFile), ]
  reference <- reference[!duplicated(reference$sharedPsFile), ]
  reference <- reference[reference$sharedPsFile != "", ]
  data <- plyr::llply(1:nrow(reference),
                      preparePlot,
                      reference = reference,
                      .progress = "text")
  data <- do.call("rbind", data)
  fileName <- file.path(exportFolder, "preference_score_dist.csv")
  colnames(data) <- SqlRender::camelCaseToSnakeCase(colnames(data))
  write.csv(data, fileName, row.names = FALSE)
  
  
  ParallelLogger::logInfo("- propensity_model table")
  getPsModel <- function(i, reference) {
    psFileName <- file.path(outputFolder,
                            "cmOutput",
                            reference$sharedPsFile[i])
    if (file.exists(psFileName)) {
      ps <- readRDS(psFileName)
      metaData <- attr(ps, "metaData")
      if (is.null(metaData$psError)) {
        cmDataFile <- file.path(outputFolder,
                                "cmOutput",
                                reference$cohortMethodDataFolder[i])
        cmData <- CohortMethod::loadCohortMethodData(cmDataFile)
        model <- CohortMethod::getPsModel(ps, cmData)
        model$covariateId[is.na(model$covariateId)] <- 0
        ff::close.ffdf(cmData$covariates)
        ff::close.ffdf(cmData$covariateRef)
        ff::close.ffdf(cmData$analysisRef)
        model$databaseId <- databaseId
        model$targetId <- reference$targetId[i]
        model$comparatorId <- reference$comparatorId[i]
        model <- model[, c("databaseId", "targetId", "comparatorId", "covariateId", "coefficient")]
        return(model)
      }
    }
    return(NULL)
  }
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  reference <- reference[order(reference$sharedPsFile), ]
  reference <- reference[!duplicated(reference$sharedPsFile), ]
  reference <- reference[reference$sharedPsFile != "", ]
  data <- plyr::llply(1:nrow(reference),
                      getPsModel,
                      reference = reference,
                      .progress = "text")
  data <- do.call("rbind", data)
  fileName <- file.path(exportFolder, "propensity_model.csv")
  colnames(data) <- SqlRender::camelCaseToSnakeCase(colnames(data))
  write.csv(data, fileName, row.names = FALSE)
  
  
  ParallelLogger::logInfo("- kaplan_meier_dist table")
  ParallelLogger::logInfo("  Computing KM curves")
  reference <- readRDS(file.path(outputFolder, "cmOutput", "outcomeModelReference.rds"))
  outcomesOfInterest <- getOutcomesOfInterest()
  reference <- reference[reference$outcomeId %in% outcomesOfInterest, ]
  reference <- reference[, c("strataFile",
                             "studyPopFile",
                             "targetId",
                             "comparatorId",
                             "outcomeId",
                             "analysisId")]
  tempFolder <- file.path(exportFolder, "temp")
  if (!file.exists(tempFolder)) {
    dir.create(tempFolder)
  }
  cluster <- ParallelLogger::makeCluster(min(4, maxCores))
  tasks <- split(reference, seq(nrow(reference)))
  ParallelLogger::clusterApply(cluster,
                               tasks,
                               prepareKm,
                               outputFolder = outputFolder,
                               tempFolder = tempFolder,
                               databaseId = databaseId,
                               minCellCount = minCellCount)
  ParallelLogger::stopCluster(cluster)
  ParallelLogger::logInfo("  Writing to single csv file")
  saveKmToCsv <- function(file, first, outputFile) {
    data <- readRDS(file)
    colnames(data) <- SqlRender::camelCaseToSnakeCase(colnames(data))
    write.table(x = data,
                file = outputFile,
                row.names = FALSE,
                col.names = first,
                sep = ",",
                dec = ".",
                qmethod = "double",
                append = !first)
  }
  outputFile <- file.path(exportFolder, "kaplan_meier_dist.csv")
  files <- list.files(tempFolder, "km_.*.rds", full.names = TRUE)
  saveKmToCsv(files[1], first = TRUE, outputFile = outputFile)
  if (length(files) > 1) {
    plyr::l_ply(files[2:length(files)], saveKmToCsv, first = FALSE, outputFile = outputFile, .progress = "text")
  }  
  unlink(tempFolder, recursive = TRUE)
}

prepareKm <- function(task,
                      outputFolder,
                      tempFolder,
                      databaseId,
                      minCellCount) {
  ParallelLogger::logTrace("Preparing KM plot for target ",
                           task$targetId,
                           ", comparator ",
                           task$comparatorId,
                           ", outcome ",
                           task$outcomeId,
                           ", analysis ",
                           task$analysisId)
  outputFileName <- file.path(tempFolder, sprintf("km_t%s_c%s_o%s_a%s.rds",
                                                  task$targetId,
                                                  task$comparatorId,
                                                  task$outcomeId,
                                                  task$analysisId))
  if (file.exists(outputFileName)) {
    return(NULL)
  }
  popFile <- task$strataFile
  if (popFile == "") {
    popFile <- task$studyPopFile
  }
  population <- readRDS(file.path(outputFolder,
                                  "cmOutput",
                                  popFile))
  if (nrow(population) == 0) {
    # Can happen when matching and treatment is predictable
    return(NULL)
  }
  data <- prepareKaplanMeier(population)
  if (is.null(data)) {
    # No shared strata
    return(NULL)
  }
  data$targetId <- task$targetId
  data$comparatorId <- task$comparatorId
  data$outcomeId <- task$outcomeId
  data$analysisId <- task$analysisId
  data$databaseId <- databaseId
  data <- enforceMinCellValue(data, "targetAtRisk", minCellCount)
  data <- enforceMinCellValue(data, "comparatorAtRisk", minCellCount)
  saveRDS(data, outputFileName)
}

prepareKaplanMeier <- function(population) {
  dataCutoff <- 0.9
  population$y <- 0
  population$y[population$outcomeCount != 0] <- 1
  if (is.null(population$stratumId) || length(unique(population$stratumId)) == nrow(population)/2) {
    sv <- survival::survfit(survival::Surv(survivalTime, y) ~ treatment, population, conf.int = TRUE)
    idx <- summary(sv, censored = T)$strata == "treatment=1"
    survTarget <- data.frame(time = sv$time[idx],
                             targetSurvival = sv$surv[idx],
                             targetSurvivalLb = sv$lower[idx],
                             targetSurvivalUb = sv$upper[idx])
    idx <- summary(sv, censored = T)$strata == "treatment=0"
    survComparator <- data.frame(time = sv$time[idx],
                                 comparatorSurvival = sv$surv[idx],
                                 comparatorSurvivalLb = sv$lower[idx],
                                 comparatorSurvivalUb = sv$upper[idx])
    data <- merge(survTarget, survComparator, all = TRUE)
  } else {
    population$stratumSizeT <- 1
    strataSizesT <- aggregate(stratumSizeT ~ stratumId, population[population$treatment == 1, ], sum)
    if (max(strataSizesT$stratumSizeT) == 1) {
      # variable ratio matching: use propensity score to compute IPTW
      if (is.null(population$propensityScore)) {
        stop("Variable ratio matching detected, but no propensity score found")
      }
      weights <- aggregate(propensityScore ~ stratumId, population, mean)
      if (max(weights$propensityScore) > 0.99999) {
        return(NULL)
      }
      weights$weight <- weights$propensityScore / (1 - weights$propensityScore)
    } else {
      # stratification: infer probability of treatment from subject counts
      strataSizesC <- aggregate(stratumSizeT ~ stratumId, population[population$treatment == 0, ], sum)
      colnames(strataSizesC)[2] <- "stratumSizeC"
      weights <- merge(strataSizesT, strataSizesC)
      if (nrow(weights) == 0) {
        warning("No shared strata between target and comparator")
        return(NULL)
      }
      weights$weight <- weights$stratumSizeT/weights$stratumSizeC
    }
    population <- merge(population, weights[, c("stratumId", "weight")])
    population$weight[population$treatment == 1] <- 1
    idx <- population$treatment == 1
    survTarget <- CohortMethod:::adjustedKm(weight = population$weight[idx],
                                            time = population$survivalTime[idx],
                                            y = population$y[idx])
    survTarget$targetSurvivalUb <- survTarget$s^exp(qnorm(0.975)/log(survTarget$s) * sqrt(survTarget$var)/survTarget$s)
    survTarget$targetSurvivalLb <- survTarget$s^exp(qnorm(0.025)/log(survTarget$s) * sqrt(survTarget$var)/survTarget$s)
    survTarget$targetSurvivalLb[survTarget$s > 0.9999] <- survTarget$s[survTarget$s > 0.9999]
    survTarget$targetSurvival <- survTarget$s
    survTarget$s <- NULL
    survTarget$var <- NULL
    idx <- population$treatment == 0
    survComparator <- CohortMethod:::adjustedKm(weight = population$weight[idx],
                                                time = population$survivalTime[idx],
                                                y = population$y[idx])
    survComparator$comparatorSurvivalUb <- survComparator$s^exp(qnorm(0.975)/log(survComparator$s) *
                                                                  sqrt(survComparator$var)/survComparator$s)
    survComparator$comparatorSurvivalLb <- survComparator$s^exp(qnorm(0.025)/log(survComparator$s) *
                                                                  sqrt(survComparator$var)/survComparator$s)
    survComparator$comparatorSurvivalLb[survComparator$s > 0.9999] <- survComparator$s[survComparator$s >
                                                                                         0.9999]
    survComparator$comparatorSurvival <- survComparator$s
    survComparator$s <- NULL
    survComparator$var <- NULL
    data <- merge(survTarget, survComparator, all = TRUE)
  }
  data <- data[, c("time", "targetSurvival", "targetSurvivalLb", "targetSurvivalUb", "comparatorSurvival", "comparatorSurvivalLb", "comparatorSurvivalUb")]
  cutoff <- quantile(population$survivalTime, dataCutoff)
  data <- data[data$time <= cutoff, ]
  if (cutoff <= 300) {
    xBreaks <- seq(0, cutoff, by = 50)
  } else if (cutoff <= 600) {
    xBreaks <- seq(0, cutoff, by = 100)
  } else {
    xBreaks <- seq(0, cutoff, by = 250)
  }
  
  targetAtRisk <- c()
  comparatorAtRisk <- c()
  for (xBreak in xBreaks) {
    targetAtRisk <- c(targetAtRisk,
                      sum(population$treatment == 1 & population$survivalTime >= xBreak))
    comparatorAtRisk <- c(comparatorAtRisk,
                          sum(population$treatment == 0 & population$survivalTime >=
                                xBreak))
  }
  data <- merge(data, data.frame(time = xBreaks,
                                 targetAtRisk = targetAtRisk,
                                 comparatorAtRisk = comparatorAtRisk), all = TRUE)
  if (is.na(data$targetSurvival[1])) {
    data$targetSurvival[1] <- 1
    data$targetSurvivalUb[1] <- 1
    data$targetSurvivalLb[1] <- 1
  }
  if (is.na(data$comparatorSurvival[1])) {
    data$comparatorSurvival[1] <- 1
    data$comparatorSurvivalUb[1] <- 1
    data$comparatorSurvivalLb[1] <- 1
  }
  idx <- which(is.na(data$targetSurvival))
  while (length(idx) > 0) {
    data$targetSurvival[idx] <- data$targetSurvival[idx - 1]
    data$targetSurvivalLb[idx] <- data$targetSurvivalLb[idx - 1]
    data$targetSurvivalUb[idx] <- data$targetSurvivalUb[idx - 1]
    idx <- which(is.na(data$targetSurvival))
  }
  idx <- which(is.na(data$comparatorSurvival))
  while (length(idx) > 0) {
    data$comparatorSurvival[idx] <- data$comparatorSurvival[idx - 1]
    data$comparatorSurvivalLb[idx] <- data$comparatorSurvivalLb[idx - 1]
    data$comparatorSurvivalUb[idx] <- data$comparatorSurvivalUb[idx - 1]
    idx <- which(is.na(data$comparatorSurvival))
  }
  data$targetSurvival <- round(data$targetSurvival, 4)
  data$targetSurvivalLb <- round(data$targetSurvivalLb, 4)
  data$targetSurvivalUb <- round(data$targetSurvivalUb, 4)
  data$comparatorSurvival <- round(data$comparatorSurvival, 4)
  data$comparatorSurvivalLb <- round(data$comparatorSurvivalLb, 4)
  data$comparatorSurvivalUb <- round(data$comparatorSurvivalUb, 4)
  
  # Remove duplicate (except time) entries:
  data <- data[order(data$time), ]
  data <- data[!duplicated(data[, -1]), ]
  return(data)
}
