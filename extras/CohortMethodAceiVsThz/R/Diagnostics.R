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

#' Generate diagnostics
#'
#' @details
#' This function generates analyses diagnostics. Requires the study to be executed first.
#'
#' @param outputFolder         Name of local folder where the results were generated; make sure to use forward slashes
#'                             (/). Do not use a folder on a network drive since this greatly impacts
#'                             performance.
#' @param maxCores              How many parallel cores should be used? If more cores are made
#'                              available this can speed up the analyses.
#'
#' @export
generateDiagnostics <- function(outputFolder, maxCores) {
  cmOutputFolder <- file.path(outputFolder, "cmOutput")
  diagnosticsFolder <- file.path(outputFolder, "diagnostics")
  if (!file.exists(diagnosticsFolder)) {
    dir.create(diagnosticsFolder)
  }
  reference <- readRDS(file.path(cmOutputFolder, "outcomeModelReference.rds"))
  reference <- addCohortNames(reference, "targetId", "targetName")
  reference <- addCohortNames(reference, "comparatorId", "comparatorName")
  reference <- addCohortNames(reference, "outcomeId", "outcomeName")
  reference <- addAnalysisDescription(reference, "analysisId", "analysisDescription")
  analysisSummary <- read.csv(file.path(outputFolder, "analysisSummary.csv"))
  reference <- merge(reference, analysisSummary[, c("targetId", "comparatorId", "outcomeId", "analysisId", "logRr", "seLogRr")])
  allControls <- getAllControls(outputFolder)
  subsets <- split(reference, list(reference$targetId, reference$comparatorId, reference$analysisId))
  # subset <- subsets[[1]]
  cluster <- ParallelLogger::makeCluster(min(4, maxCores))
  ParallelLogger::clusterApply(cluster = cluster, 
                               x = subsets, 
                               fun = createDiagnosticsForSubset, 
                               allControls = allControls, 
                               outputFolder = outputFolder, 
                               cmOutputFolder = cmOutputFolder, 
                               diagnosticsFolder = diagnosticsFolder)
  ParallelLogger::stopCluster(cluster)
}

createDiagnosticsForSubset <- function(subset, allControls, outputFolder, cmOutputFolder, diagnosticsFolder) {
  targetId <- subset$targetId[1]
  comparatorId <- subset$comparatorId[1]
  analysisId <- subset$analysisId[1]
  ParallelLogger::logTrace("Generating diagnostics for target ", targetId, ", comparator ", comparatorId, ", analysis ", analysisId)
  ParallelLogger::logDebug("Subset has ", nrow(subset)," entries with ", sum(!is.na(subset$seLogRr)), " valid estimates")
  title <- paste(paste(subset$targetName[1], subset$comparatorName[1], sep = " - "), 
                 subset$analysisDescription[1], sep = "\n")
  controlSubset <- merge(subset,
                         allControls[, c("targetId", "comparatorId", "outcomeId", "oldOutcomeId", "targetEffectSize")])
  
  # Empirical calibration ----------------------------------------------------------------------------------
  
  # Negative controls
  negControlSubset <- controlSubset[controlSubset$targetEffectSize == 1, ]
  validNcs <- sum(!is.na(negControlSubset$seLogRr))
  ParallelLogger::logDebug("Subset has ", validNcs, " valid negative control estimates")
  if (validNcs >= 5) {
    null <- EmpiricalCalibration::fitMcmcNull(negControlSubset$logRr, negControlSubset$seLogRr)
    fileName <-  file.path(diagnosticsFolder, paste0("nullDistribution_a", analysisId, "_t", targetId, "_c", comparatorId, ".png"))
    EmpiricalCalibration::plotCalibrationEffect(logRrNegatives = negControlSubset$logRr,
                                                seLogRrNegatives = negControlSubset$seLogRr,
                                                null = null,
                                                showCis = TRUE,
                                                title = title,
                                                fileName = fileName)
  } else {
    null <- NULL
  }
  
  # Positive and negative controls
  validPcs <- sum(!is.na(controlSubset$seLogRr[controlSubset$targetEffectSize != 1]))
  ParallelLogger::logDebug("Subset has ", validPcs, " valid positive control estimates")
  if (validPcs >= 10) {
    model <- EmpiricalCalibration::fitSystematicErrorModel(logRr = controlSubset$logRr, 
                                                           seLogRr = controlSubset$seLogRr, 
                                                           trueLogRr = log(controlSubset$targetEffectSize), 
                                                           estimateCovarianceMatrix = FALSE)
    
    fileName <-  file.path(diagnosticsFolder, paste0("controls_a", analysisId, "_t", targetId, "_c", comparatorId, ".png"))
    EmpiricalCalibration::plotCiCalibrationEffect(logRr = controlSubset$logRr, 
                                                  seLogRr = controlSubset$seLogRr, 
                                                  trueLogRr = log(controlSubset$targetEffectSize),
                                                  model = model,
                                                  title = title,
                                                  fileName = fileName)
    
    fileName <-  file.path(diagnosticsFolder, paste0("ciCoverage_a", analysisId, "_t", targetId, "_c", comparatorId, ".png"))
    evaluation <- EmpiricalCalibration::evaluateCiCalibration(logRr = controlSubset$logRr, 
                                                              seLogRr = controlSubset$seLogRr, 
                                                              trueLogRr = log(controlSubset$targetEffectSize),
                                                              crossValidationGroup = controlSubset$oldOutcomeId)
    EmpiricalCalibration::plotCiCoverage(evaluation = evaluation,
                                         title = title,
                                         fileName = fileName)
  } 
  
  # Statistical power --------------------------------------------------------------------------------------
  outcomeIdsOfInterest <- subset$outcomeId[!(subset$outcomeId %in% controlSubset$outcomeId)]
  mdrrs <- data.frame()
  for (outcomeId in outcomeIdsOfInterest) {
    strataFile <- subset$strataFile[subset$outcomeId == outcomeId]
    if (strataFile == "") {
      strataFile <- subset$studyPopFile[subset$outcomeId == outcomeId]
    }
    population <- readRDS(file.path(cmOutputFolder, strataFile))
    modelFile <- subset$outcomeModelFile[subset$outcomeId == outcomeId]
    model <- readRDS(file.path(cmOutputFolder, modelFile))
    mdrr <- CohortMethod::computeMdrr(population = population, 
                                      alpha = 0.05, 
                                      power = 0.8, 
                                      twoSided = TRUE, 
                                      modelType =  model$outcomeModelType)
    
    mdrr$outcomeId <- outcomeId
    mdrr$outcomeName <- subset$outcomeName[subset$outcomeId == outcomeId]
    mdrrs <- rbind(mdrrs, mdrr)
  }
  mdrrs$analysisId <- analysisId
  mdrrs$analysisDescription <- subset$analysisDescription[1]
  mdrrs$targetId <- targetId
  mdrrs$targetName <- subset$targetName[1]
  mdrrs$comparatorId <- comparatorId
  mdrrs$comparatorName <- subset$comparatorName[1]
  fileName <-  file.path(diagnosticsFolder, paste0("mdrr_a", analysisId, "_t", targetId, "_c", comparatorId, ".csv"))
  write.csv(mdrrs, fileName, row.names = FALSE)
  
  # Covariate balance --------------------------------------------------------------------------------------
  outcomeIdsOfInterest <- subset$outcomeId[!(subset$outcomeId %in% controlSubset$outcomeId)]
  outcomeId = outcomeIdsOfInterest[1]
  for (outcomeId in outcomeIdsOfInterest) {
    balanceFileName <- file.path(outputFolder,
                                 "balance",
                                 sprintf("bal_t%s_c%s_o%s_a%s.rds", targetId, comparatorId, outcomeId, analysisId))
    if (file.exists(balanceFileName)) {
      balance <- readRDS(balanceFileName)
      fileName = file.path(diagnosticsFolder, 
                           sprintf("bal_t%s_c%s_o%s_a%s.csv", targetId, comparatorId, outcomeId, analysisId))
      write.csv(balance, fileName, row.names = FALSE)
      
      outcomeTitle <- paste(paste(subset$targetName[1], subset$comparatorName[1], sep = " - "), 
                            subset$outcomeName[subset$outcomeId == outcomeId], 
                            subset$analysisDescription[1], sep = "\n")
      fileName = file.path(diagnosticsFolder, 
                           sprintf("balanceScatter_t%s_c%s_o%s_a%s.png", targetId, comparatorId, outcomeId, analysisId))
      balanceScatterPlot <- CohortMethod::plotCovariateBalanceScatterPlot(balance = balance,
                                                                          beforeLabel = "Before PS adjustment",
                                                                          afterLabel =  "After PS adjustment",
                                                                          showCovariateCountLabel = TRUE,
                                                                          showMaxLabel = TRUE,
                                                                          title = outcomeTitle,
                                                                          fileName = fileName)
      
      fileName = file.path(diagnosticsFolder, 
                           sprintf("balanceTop_t%s_c%s_o%s_a%s.png", targetId, comparatorId, outcomeId, analysisId))
      balanceTopPlot <- CohortMethod::plotCovariateBalanceOfTopVariables(balance = balance,
                                                                         beforeLabel = "Before PS adjustment",
                                                                         afterLabel =  "After PS adjustment",
                                                                         title = outcomeTitle,
                                                                         fileName = fileName)
    }
  }
  # Propensity score distribution --------------------------------------------------------------------------
  psFile <- subset$sharedPsFile[1]
  if (psFile != "") {
    ps <- readRDS(file.path(cmOutputFolder, psFile))
    fileName <-  file.path(diagnosticsFolder, paste0("ps_a", analysisId, "_t", targetId, "_c", comparatorId, ".png"))
    CohortMethod::plotPs(data = ps,
                         targetLabel = subset$targetName[1],
                         comparatorLabel = subset$comparatorName[1],
                         showCountsLabel = TRUE,
                         showAucLabel = TRUE,
                         showEquiposeLabel = TRUE,
                         title = subset$analysisDescription[1],
                         fileName = fileName)
  }
}
