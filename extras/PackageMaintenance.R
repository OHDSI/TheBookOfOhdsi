# Remove orphan images ---------------------------------------------------------

rmdFiles <- list.files(pattern = ".*Rmd")

getImageRefs <- function(rmdFile) {
  rmd <- readChar(rmdFile, file.info(rmdFile)$size)
  matches <- gregexpr("images[^'\")]*\\.(png|PNG|jpg|JPG)", rmd)
  imageRefs <- regmatches(rmd, matches)[[1]]
  return(imageRefs)
}
imageRefs <- lapply(rmdFiles, getImageRefs)
imageRefs <- do.call(c, imageRefs)
imageRefs <- unique(imageRefs)
imageRefs <- c(imageRefs, file.path("images", "important.png"), file.path("images", "summary.png"))

images <- list.files("images", ".*\\.(png|PNG|jpg|JPG)", recursive = TRUE)
images <- file.path("images", images)

toDelete <- images[!(images %in% imageRefs)]
toDelete

unlink(toDelete)

# Fetch current software versions -----------------------------------------------

packages <- c("CohortMethod",
              "SelfControlledCaseSeries",
              "SelfControlledCohort",
              "CaseControl",
              "CaseCrossover",
              "PatientLevelPrediction",
              "EmpiricalCalibration",
              "MethodEvaluation",
              "EvidenceSynthesis",
              "DatabaseConnector",
              "SqlRender",
              "Cyclops",
              "ParallelLogger",
              "FeatureExtraction")

getPackageVersion <- function(package) {
  url <- sprintf("https://raw.githubusercontent.com/OHDSI/%s/master/DESCRIPTION", package)
  description <- httr::GET(url)
  description <- httr::content(description)
  matches <- gregexpr("Version:[^\n]*\n", description)
  version <- regmatches(description, matches)[[1]]
  version <- gsub("Version:[ \t]*", "", version)
  version <- gsub("[ \t]*\r?\n", "", version)
  return(version)
}

versions <- sapply(packages, getPackageVersion)
packageVersions <- data.frame(package = packages, version = versions)
write.csv(packageVersions, "PackageVersions.csv", row.names = FALSE)
