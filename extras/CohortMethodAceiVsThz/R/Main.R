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

#' Execute the Study
#'
#' @details
#' This function executes the CohortMethodAceiVsThz Study.
#' 
#' The \code{createCohorts}, \code{synthesizePositiveControls}, \code{runAnalyses}, and \code{runDiagnostics} arguments
#' are intended to be used to run parts of the full study at a time, but none of the parts are considerd to be optional.
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
#' @param outputFolder         Name of local folder to place results; make sure to use forward slashes
#'                             (/). Do not use a folder on a network drive since this greatly impacts
#'                             performance.
#' @param databaseId           A short string for identifying the database (e.g.
#'                             'Synpuf').
#' @param databaseName         The full name of the database (e.g. 'Medicare Claims
#'                             Synthetic Public Use Files (SynPUFs)').
#' @param databaseDescription  A short description (several sentences) of the database.
#' @param createCohorts        Create the cohortTable table with the exposure and outcome cohorts?
#' @param synthesizePositiveControls  Should positive controls be synthesized?
#' @param runAnalyses          Perform the cohort method analyses?
#' @param runDiagnostics       Compute study diagnostics?
#' @param packageResults       Should results be packaged for later sharing?     
#' @param maxCores             How many parallel cores should be used? If more cores are made available
#'                             this can speed up the analyses.
#' @param minCellCount         The minimum number of subjects contributing to a count before it can be included 
#'                             in packaged results.
#'
#' @examples
#' \dontrun{
#' connectionDetails <- createConnectionDetails(dbms = "postgresql",
#'                                              user = "joe",
#'                                              password = "secret",
#'                                              server = "myserver")
#'
#' execute(connectionDetails,
#'         cdmDatabaseSchema = "cdm_data",
#'         cohortDatabaseSchema = "study_results",
#'         cohortTable = "cohort",
#'         oracleTempSchema = NULL,
#'         outputFolder = "c:/temp/study_results",
#'         maxCores = 4)
#' }
#'
#' @export
execute <- function(connectionDetails,
                    cdmDatabaseSchema,
                    cohortDatabaseSchema = cdmDatabaseSchema,
                    cohortTable = "cohort",
                    oracleTempSchema = cohortDatabaseSchema,
                    outputFolder,
                    databaseId = "Unknown",
                    databaseName = "Unknown",
                    databaseDescription = "Unknown",
                    createCohorts = TRUE,
                    synthesizePositiveControls = TRUE,
                    runAnalyses = TRUE,
                    runDiagnostics = TRUE,
                    packageResults = TRUE,
                    maxCores = 4,
                    minCellCount= 5) {
  if (!file.exists(outputFolder))
    dir.create(outputFolder, recursive = TRUE)
  if (!is.null(getOption("fftempdir")) && !file.exists(getOption("fftempdir"))) {
    warning("fftempdir '", getOption("fftempdir"), "' not found. Attempting to create folder")
    dir.create(getOption("fftempdir"), recursive = TRUE)
  }
  
  ParallelLogger::addDefaultFileLogger(file.path(outputFolder, "log.txt"))
  
  if (createCohorts) {
    ParallelLogger::logInfo("Creating exposure and outcome cohorts")
    createCohorts(connectionDetails = connectionDetails,
                  cdmDatabaseSchema = cdmDatabaseSchema,
                  cohortDatabaseSchema = cohortDatabaseSchema,
                  cohortTable = cohortTable,
                  oracleTempSchema = oracleTempSchema,
                  outputFolder = outputFolder)
  }
  
  # Set doPositiveControlSynthesis to FALSE if you don't want to use synthetic positive controls:
  doPositiveControlSynthesis = FALSE
  if (doPositiveControlSynthesis) {
    if (synthesizePositiveControls) {
      ParallelLogger::logInfo("Synthesizing positive controls")
      synthesizePositiveControls(connectionDetails = connectionDetails,
                                 cdmDatabaseSchema = cdmDatabaseSchema,
                                 cohortDatabaseSchema = cohortDatabaseSchema,
                                 cohortTable = cohortTable,
                                 oracleTempSchema = oracleTempSchema,
                                 outputFolder = outputFolder,
                                 maxCores = maxCores)
    }
  }
  
  if (runAnalyses) {
    ParallelLogger::logInfo("Running CohortMethod analyses")
    runCohortMethod(connectionDetails = connectionDetails,
                    cdmDatabaseSchema = cdmDatabaseSchema,
                    cohortDatabaseSchema = cohortDatabaseSchema,
                    cohortTable = cohortTable,
                    oracleTempSchema = oracleTempSchema,
                    outputFolder = outputFolder,
                    maxCores = maxCores)
  }
  
  if (runDiagnostics) {
    ParallelLogger::logInfo("Running diagnostics")
    generateDiagnostics(outputFolder = outputFolder,
                        maxCores = maxCores)
  }
  
  if (packageResults) {
    ParallelLogger::logInfo("Packaging results")
    exportResults(outputFolder = outputFolder,
                  databaseId = databaseId,
                  databaseName = databaseName,
                  databaseDescription = databaseDescription,
                  minCellCount = minCellCount,
                  maxCores = maxCores)
  }
  
  invisible(NULL)
}
