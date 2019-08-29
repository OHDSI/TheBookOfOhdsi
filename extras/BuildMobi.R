setwd("C:/Users/mschuemi/git/TheBookOfOhdsi")

# kindlegen crashes if background images are used in the stylesheet, so using alternative css:
bookdown::render_book("index.Rmd", "bookdown::epub_book", output_options = list(stylesheet = "styleForMobi.css"))

# PanDoc created dead links for references to figures, tables, chapters, and sections.
# Better to delete those links:

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

# Requires kindlegen to be installed:
bookdown::kindlegen(exec = "c:/temp/kindlegen/kindlegen.exe")
