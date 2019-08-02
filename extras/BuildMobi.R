setwd("C:/Users/mschuemi/git/TheBookOfOhdsi")

# kindlegen crashes if background images are used in the stylesheet, so using alternative css:
bookdown::render_book("index.Rmd", "bookdown::epub_book", output_options = list(stylesheet = "styleForMobi.css"))

# Requires kindlegen to be installed:
bookdown::kindlegen(exec = "c:/temp/kindlegen/kindlegen.exe")