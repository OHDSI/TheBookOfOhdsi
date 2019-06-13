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

#' Run CohortMethod package
#'
#' @details
#' Run the CohortMethod package, which implements the comparative cohort design.
#'
#' @param connectionDetails    An object of type \code{connectionDetails} as created using the
#'                             \code{\link[DatabaseConnector]{createConnectionDetails}} function in the
#'                             DatabaseConnector package.
#' @param cdmDatabaseSchema    Schema name where your patient-level data in OMOP CDM format resides.
#'                             Note that for SQL Server, this should include both the database and
#'                             schema name, for example 'cdm_data.dbo'.
#' @param cohortDatabaseSchema Schema name where intermediate data can be stored. You will need to have
#'                             write priviliges in this schema. Note that for SQL Server, this should
#'                             include both the database and schema name, for example 'cdm_data.dbo'.
#' @param cohortTable          The name of the table that will be created in the work database schema.
#'                             This table will hold the exposure and outcome cohorts used in this
#'                             study.
#' @param oracleTempSchema     Should be used in Oracle to specify a schema where the user has write
#'                             priviliges for storing temporary tables.
#' @param outputFolder         Name of local folder where the results were generated; make sure to use forward slashes
#'                             (/). Do not use a folder on a network drive since this greatly impacts
#'                             performance.
#' @param maxCores             How many parallel cores should be used? If more cores are made available
#'                             this can speed up the analyses.
#'
#' @export
runCohortMethod <- function(connectionDetails,
                            cdmDatabaseSchema,
                            cohortDatabaseSchema,
                            cohortTable,
                            oracleTempSchema,
                            outputFolder,
                            maxCores) {
  cmOutputFolder <- file.path(outputFolder, "cmOutput")
  if (!file.exists(cmOutputFolder)) {
    dir.create(cmOutputFolder)
  }
  cmAnalysisListFile <- system.file("settings",
                                    "cmAnalysisList.json",
                                    package = "CohortMethodAceiVsThz")
  cmAnalysisList <- CohortMethod::loadCmAnalysisList(cmAnalysisListFile)
  tcosList <- createTcos(outputFolder = outputFolder)
  outcomesOfInterest <- getOutcomesOfInterest()
  results <- CohortMethod::runCmAnalyses(connectionDetails = connectionDetails,
                                         cdmDatabaseSchema = cdmDatabaseSchema,
                                         exposureDatabaseSchema = cohortDatabaseSchema,
                                         exposureTable = cohortTable,
                                         outcomeDatabaseSchema = cohortDatabaseSchema,
                                         outcomeTable = cohortTable,
                                         outputFolder = cmOutputFolder,
                                         oracleTempSchema = oracleTempSchema,
                                         cmAnalysisList = cmAnalysisList,
                                         targetComparatorOutcomesList = tcosList,
                                         getDbCohortMethodDataThreads = min(3, maxCores),
                                         createStudyPopThreads = min(3, maxCores),
                                         createPsThreads = max(1, round(maxCores/10)),
                                         psCvThreads = min(10, maxCores),
                                         trimMatchStratifyThreads = min(10, maxCores),
                                         fitOutcomeModelThreads = max(1, round(maxCores/4)),
                                         outcomeCvThreads = min(4, maxCores),
                                         refitPsForEveryOutcome = FALSE,
                                         outcomeIdsOfInterest = outcomesOfInterest)
  
  ParallelLogger::logInfo("Summarizing results")
  analysisSummary <- CohortMethod::summarizeAnalyses(referenceTable = results, 
                                                     outputFolder = cmOutputFolder)
  analysisSummary <- addCohortNames(analysisSummary, "targetId", "targetName")
  analysisSummary <- addCohortNames(analysisSummary, "comparatorId", "comparatorName")
  analysisSummary <- addCohortNames(analysisSummary, "outcomeId", "outcomeName")
  analysisSummary <- addAnalysisDescription(analysisSummary, "analysisId", "analysisDescription")
  write.csv(analysisSummary, file.path(outputFolder, "analysisSummary.csv"), row.names = FALSE)
  
  ParallelLogger::logInfo("Computing covariate balance") 
  balanceFolder <- file.path(outputFolder, "balance")
  if (!file.exists(balanceFolder)) {
    dir.create(balanceFolder)
  }
  subset <- results[results$outcomeId %in% outcomesOfInterest,]
  subset <- subset[subset$strataFile != "", ]
  if (nrow(subset) > 0) {
    subset <- split(subset, seq(nrow(subset)))
    cluster <- ParallelLogger::makeCluster(min(3, maxCores))
    ParallelLogger::clusterApply(cluster, subset, computeCovariateBalance, cmOutputFolder = cmOutputFolder, balanceFolder = balanceFolder)
    ParallelLogger::stopCluster(cluster)
  }
}

computeCovariateBalance <- function(row, cmOutputFolder, balanceFolder) {
  outputFileName <- file.path(balanceFolder,
                              sprintf("bal_t%s_c%s_o%s_a%s.rds", row$targetId, row$comparatorId, row$outcomeId, row$analysisId))
  if (!file.exists(outputFileName)) {
    ParallelLogger::logTrace("Creating covariate balance file ", outputFileName)
    cohortMethodDataFolder <- file.path(cmOutputFolder, row$cohortMethodDataFolder)
    cohortMethodData <- CohortMethod::loadCohortMethodData(cohortMethodDataFolder)
    strataFile <- file.path(cmOutputFolder, row$strataFile)
    strata <- readRDS(strataFile)
    balance <- CohortMethod::computeCovariateBalance(population = strata, cohortMethodData = cohortMethodData)
    saveRDS(balance, outputFileName)
  }
}

addAnalysisDescription <- function(data, IdColumnName = "analysisId", nameColumnName = "analysisDescription") {
  cmAnalysisListFile <- system.file("settings",
                                    "cmAnalysisList.json",
                                    package = "CohortMethodAceiVsThz")
  cmAnalysisList <- CohortMethod::loadCmAnalysisList(cmAnalysisListFile)
  idToName <- lapply(cmAnalysisList, function(x) data.frame(analysisId = x$analysisId, description = as.character(x$description)))
  idToName <- do.call("rbind", idToName)
  names(idToName)[1] <- IdColumnName
  names(idToName)[2] <- nameColumnName
  data <- merge(data, idToName, all.x = TRUE)
  # Change order of columns:
  idCol <- which(colnames(data) == IdColumnName)
  if (idCol < ncol(data) - 1) {
    data <- data[, c(1:idCol, ncol(data) , (idCol+1):(ncol(data)-1))]
  }
  return(data)
}

createTcos <- function(outputFolder) {
  pathToCsv <- system.file("settings", "TcosOfInterest.csv", package = "CohortMethodAceiVsThz")
  tcosOfInterest <- read.csv(pathToCsv, stringsAsFactors = FALSE)
  allControls <- getAllControls(outputFolder)
  tcs <- unique(rbind(tcosOfInterest[, c("targetId", "comparatorId")],
                      allControls[, c("targetId", "comparatorId")]))
  createTco <- function(i) {
    targetId <- tcs$targetId[i]
    comparatorId <- tcs$comparatorId[i]
    outcomeIds <- as.character(tcosOfInterest$outcomeIds[tcosOfInterest$targetId == targetId & tcosOfInterest$comparatorId == comparatorId])
    outcomeIds <- as.numeric(strsplit(outcomeIds, split = ";")[[1]])
    outcomeIds <- c(outcomeIds, allControls$outcomeId[allControls$targetId == targetId & allControls$comparatorId == comparatorId])
    excludeConceptIds <- as.character(tcosOfInterest$excludedCovariateConceptIds[tcosOfInterest$targetId == targetId & tcosOfInterest$comparatorId == comparatorId])
    if (length(excludeConceptIds) == 1 && is.na(excludeConceptIds)) {
      excludeConceptIds <- c()
    } else if (length(excludeConceptIds) > 0) {
      excludeConceptIds <- as.numeric(strsplit(excludeConceptIds, split = ";")[[1]])
    }
    includeConceptIds <- as.character(tcosOfInterest$includedCovariateConceptIds[tcosOfInterest$targetId == targetId & tcosOfInterest$comparatorId == comparatorId])
    if (length(includeConceptIds) == 1 && is.na(includeConceptIds)) {
      includeConceptIds <- c()
    } else if (length(includeConceptIds) > 0) {
      includeConceptIds <- as.numeric(strsplit(excludeConceptIds, split = ";")[[1]])
    }
    tco <- CohortMethod::createTargetComparatorOutcomes(targetId = targetId,
                                                        comparatorId = comparatorId,
                                                        outcomeIds = outcomeIds,
                                                        excludedCovariateConceptIds = excludeConceptIds,
                                                        includedCovariateConceptIds = includeConceptIds)
    return(tco)
  }
  tcosList <- lapply(1:nrow(tcs), createTco)
  return(tcosList)
}

getOutcomesOfInterest <- function() {
  pathToCsv <- system.file("settings", "TcosOfInterest.csv", package = "CohortMethodAceiVsThz")
  tcosOfInterest <- read.csv(pathToCsv, stringsAsFactors = FALSE) 
  outcomeIds <- as.character(tcosOfInterest$outcomeIds)
  outcomeIds <- do.call("c", (strsplit(outcomeIds, split = ";")))
  outcomeIds <- unique(as.numeric(outcomeIds))
  return(outcomeIds)
}

getAllControls <- function(outputFolder) {
  allControlsFile <- file.path(outputFolder, "AllControls.csv")
  if (file.exists(allControlsFile)) {
    # Positive controls must have been synthesized. Include both positive and negative controls.
    allControls <- read.csv(allControlsFile)
  } else {
    # Include only negative controls
    pathToCsv <- system.file("settings", "NegativeControls.csv", package = "CohortMethodAceiVsThz")
    allControls <- read.csv(pathToCsv)
    allControls$oldOutcomeId <- allControls$outcomeId
    allControls$targetEffectSize <- rep(1, nrow(allControls))
  }
  return(allControls)
}