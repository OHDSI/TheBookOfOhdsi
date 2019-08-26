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

# Turn implicit subsubsections into explicit ones ----------------------------
rmdFiles <- list.files(pattern = ".*Rmd")

convertSubsubsection <- function(rmdFile) {
  rmd <- readChar(rmdFile, file.info(rmdFile)$size)
  matches <- gregexpr("\n\\*\\*[^*\n]*\\*\\*[ \t]*[\r]", rmd)
  headers <- regmatches(rmd, matches)[[1]]
  if (length(headers) > 0) {
    for (header in headers) {
      newHeader   <- gsub("\n\\*\\*", "\n#### ", gsub("\\*\\*[ \t]*[\r]", " {-}\r", header))
      rmd <- gsub(header, newHeader, rmd, fixed = TRUE)
    }
    sink(rmdFile)
    rmd <- gsub("\r", "", rmd)
    cat(rmd)
    sink()
  }
}
lapply(rmdFiles, convertSubsubsection)

# Fix header capitalization --------------------------------------------------
ignoreWords <- c("in", "the", "a", "an", "of", "for", "and", "to", "into", "from", "xSpec", "xSens", "on", "this")

fixWordCapitalization <- function(word) {
  if (word %in% ignoreWords) {
    return(word)
  } else {
    return(paste0(toupper(substr(word, 1, 1)), substr(word, 2, nchar(word))))
  }
}

fixSingleHeader <- function(header) {
  words <- strsplit(header, " ")[[1]]
  words <- sapply(words, fixWordCapitalization)
  header <- paste(words, collapse = " ")
  words <- strsplit(header, "-")[[1]]
  if (length(words) > 1) {
    words <- sapply(words, fixWordCapitalization)
    header <- paste(words, collapse = "-")
  }
  return(header)
}

rmdFiles <- list.files(pattern = ".*Rmd")

fixHeaderCapitalization <- function(rmdFile) {
  print(rmdFile)
  rmd <- readChar(rmdFile, file.info(rmdFile)$size)
  matches <- gregexpr("\n(##|###)[^\r\n]*[\r]", rmd)
  headers <- regmatches(rmd, matches)[[1]]
  if (length(headers) > 0) {
    for (header in headers) {
      newHeader   <- fixSingleHeader(header)
      rmd <- gsub(header, newHeader, rmd, fixed = TRUE)
    }
    sink(rmdFile)
    rmd <- gsub("\r", "", rmd)
    cat(rmd)
    sink()
  }
}
lapply(rmdFiles, fixHeaderCapitalization)




