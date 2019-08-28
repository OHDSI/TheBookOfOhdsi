if (system.file(package = "DatabaseConnector") == '') install.packages("DatabaseConnector")

tempFolder <- tempfile()
unzip(file.path("_book", "TheBookOfOhdsi.epub"), exdir = tempFolder)

htmlFiles <- list.files(path = file.path(tempFolder, "EPUB", "text"), pattern = ".*xhtml", full.names = TRUE)

removeDeadLinks <- function(htmlFile) {
  print(htmlFile)
  html <- readChar(htmlFile, file.info(htmlFile)$size)
  matches <- gregexpr("<a href=\"#[^\"]*\">[^<]+</a>", html)
  links <- regmatches(html, matches)[[1]]
  if (length(links) > 0) {
    for (link in links) {
      noLink   <- gsub("<a [^>]*>", "", gsub("</a>", "", link))
      html <- gsub(link, noLink, html, fixed = TRUE)
    }
    sink(htmlFile)
    html <- gsub("\r", "", html)
    cat(html)
    sink()
  }
}
lapply(htmlFiles, removeDeadLinks)

DatabaseConnector::createZipFile(zipFile = file.path("_book", "TheBookOfOhdsi.epub"),
                                 files = tempFolder,
                                 rootFolder = tempFolder)
unlink(tempFolder)
