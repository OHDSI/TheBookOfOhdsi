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

#' Prepare results for the Evidence Explorer Shiny app.
#'
#' @param resultsZipFile  Path to a zip file containing results from a study executed by this package.
#' @param dataFolder      A folder where the data files for the Evidence Explorer app will be stored.
#'
#' @examples
#'
#' \dontrun{
#' # Add results from three databases to the Shiny app data folder:
#' prepareForEvidenceExplorer("ResultsMDCD.zip", "/shinyData")
#' prepareForEvidenceExplorer("ResultsMDCR.zip", "/shinyData")
#' prepareForEvidenceExplorer("ResultsCCAE.zip", "/shinyData")
#'
#' # Launch the Shiny app:
#' launchEvidenceExplorer("/shinyData")
#' }
#'
#' @export
prepareForEvidenceExplorer <- function(resultsZipFile, dataFolder) {
  # resultsZipFile <- "c:/temp/ResultsMDCD.zip"
  # dataFolder <- "c:/temp/shinyData"
  if (!file.exists(dataFolder)) {
    dir.create(dataFolder, recursive = TRUE)
  }
  tempFolder <- tempdir()
  on.exit(unlink(tempFolder, recursive = TRUE))
  utils::unzip(resultsZipFile, exdir = tempFolder)
  databaseFileName <- file.path(tempFolder, "database.csv")
  if (!file.exists(databaseFileName)) {
    stop("Cannot find file database.csv in zip file")
  }
  databaseId <- read.csv(databaseFileName, stringsAsFactors = FALSE)$database_id
  splittableTables <- c("covariate_balance", "preference_score_dist", "kaplan_meier_dist")

  processSubet <- function(subset, tableName) {
    targetId <- subset$target_id[1]
    comparatorId <- subset$comparator_id[1]
    fileName <- sprintf("%s_t%s_c%s_%s.rds", tableName, targetId, comparatorId, databaseId)
    saveRDS(subset, file.path(dataFolder, fileName))
  }

  processFile <- function(file) {
    tableName <- gsub(".csv$", "", file)
    table <- read.csv(file.path(tempFolder, file))
    if (tableName %in% splittableTables) {
      subsets <- split(table, list(table$target_id, table$comparator_id))
      plyr::l_ply(subsets, processSubet, tableName = tableName)
    } else {
      saveRDS(table, file.path(dataFolder, sprintf("%s_%s.rds", tableName, databaseId)))
    }
  }

  files <- list.files(tempFolder, ".*.csv")
  plyr::l_ply(files, processFile, .progress = "text")
}


#' Launch the SqlRender Developer Shiny app
#'
#' @param dataFolder   A folder where the data files for the Evidence Explorer app will be stored. Use the
#'                     \code{\link{prepareForEvidenceExplorer}} to populate this folder.
#' @param blind        Should the user be blinded to the main results?
#' @param launch.browser    Should the app be launched in your default browser, or in a Shiny window.
#'                          Note: copying to clipboard will not work in a Shiny window.
#'
#' @details
#' Launches a Shiny app that allows the user to explore the evidence
#'
#' @export
launchEvidenceExplorer <- function(dataFolder, blind = TRUE, launch.browser = TRUE) {
  ensure_installed("DT")
  appDir <- system.file("shiny", "EvidenceExplorer", package = "CohortMethodAceiVsThz")
  .GlobalEnv$shinySettings <- list(dataFolder = dataFolder, blind = blind)
  on.exit(rm(shinySettings, envir=.GlobalEnv))
  shiny::runApp(appDir)
}

# Borrowed from remotes: https://github.com/r-lib/remotes/blob/ba7a5a4abd8258c52cb156e7b26bb4bf47a79f0b/R/utils.r#L44
is_installed <- function (pkg, version = 0) {
  installed_version <- tryCatch(utils::packageVersion(pkg),
                                error = function(e) NA)
  !is.na(installed_version) && installed_version >= version
}

# Borrowed and adapted from remotes: https://github.com/r-lib/remotes/blob/ba7a5a4abd8258c52cb156e7b26bb4bf47a79f0b/R/utils.r#L74
ensure_installed <- function(pkg) {
  if (!is_installed(pkg)) {
    msg <- paste0(sQuote(pkg), " must be installed for this functionality.")
    if (interactive()) {
      message(msg, "\nWould you like to install it?")
      if (menu(c("Yes", "No")) == 1) {
        install.packages(pkg)
      } else {
        stop(msg, call. = FALSE)
      }
    } else {
      stop(msg, call. = FALSE)
    }
  }
}
