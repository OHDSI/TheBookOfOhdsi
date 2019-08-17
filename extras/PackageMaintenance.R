


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
