writeLines("Post-processing Epub")

if (system.file(package = "DatabaseConnector") == '') install.packages("DatabaseConnector")

# Unpackage Epub -----------------------------------------------------------------------------------
writeLines("- Unpackaging Epub")
tempFolder <- tempfile()
unzip(file.path("_book", "TheBookOfOhdsi.epub"), exdir = tempFolder)

# Remove dead links -----------------------------------------------------------------------------------
htmlFiles <- list.files(path = file.path(tempFolder, "EPUB", "text"), pattern = ".*xhtml", full.names = TRUE)

removeDeadLinks <- function(htmlFile) {
  writeLines(paste("-Dropping dead links in", htmlFile))
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
dummy <- lapply(htmlFiles, removeDeadLinks)

# Center cover image ---------------------------------------------------------------------------------
writeLines("- Centering cover image")
unlink(file.path(tempFolder, "EPUB", "text", "cover.xhtml"))
file.copy(file.path("extras", "Cover", "epubCover.xhtml"), file.path(tempFolder, "EPUB", "text", "cover.xhtml"))

# Repackage Epub -----------------------------------------------------------------------------------
writeLines("- Repackaging Epub")
DatabaseConnector::createZipFile(zipFile = file.path("_book", "TheBookOfOhdsi.epub"),
                                 files = tempFolder,
                                 rootFolder = tempFolder)
unlink(tempFolder)
writeLines("Done post-processing Epub")
