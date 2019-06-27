--- 
title: "The Book of OHDSI"
author: "Observational Health Data Science and Informatics"
date: "2019-06-27"
output:
  bookdown::pdf_book:
  - latex_engine: xelatex
  - keep_tex: yes
  - includes:
      in_header: preamble.tex   
classoption: 11pt      
geometry:
- paperheight=10in 
- paperwidth=7in
- margin=1in
- left=0.6in
- right=0.6in
- top=1in
- bottom=0.6in
mainfont: Times New Roman
bibliography:
- book.bib
- packages.bib
description: This is a minimal example of using the bookdown package to write a book.
  The output format for this example is bookdown::gitbook.
documentclass: book
favicon: images/favicon.ico
github-repo: OHDSI/TheBookOfOhdsi
link-citations: yes
cover-image: images/Cover/Cover.png
site: bookdown::bookdown_site
biblio-style: apalike
url: https://ohdsi.github.io/TheBookOfOhdsi/
---



# Preface {-}

<img src="images/Cover/Cover.png" width="250" height="375" alt="Cover image" align="right" style="margin: 0 1em 0 1em" /> This is a book about OHDSI, and is currently very much under development. 

The book is written in [RMarkdown](https://rmarkdown.rstudio.com) with [bookdown](https://bookdown.org). It is automatically rebuilt from [source](https://github.com/OHDSI/TheBookOfOhdsi) by [travis](http://travis-ci.org/). 

## Goals of this book {-}

This book aims to be a central knowledge repository for OHDSI, and focuses on describing the OHDSI community, data standards, and tools. It is intended both for those new to OHDSI and veterans alike, and aims to be practical, providing the necessary theory and subsequent instructions on how to do things. After reading this book you will understand what OHDSI is, and how you can join the journey. You will learn what the common data model and standard vocabularies are, and how they can be used to standard an observational healthcare database. You will learn there are three main uses cases for these data: characterization, population-level estimation, and patient-level prediction, and that all three activities are supported by OHDSI's open source tools, and how to use them. You will learn how to establish the quality of the generated evidence through data quality, clinical validity, software validity, and method validity. Lastly, you will learn how these tools can be used to execute these studies in a distributed research network.

## Structure of the book {-}

This book is organizes in five major sections: (I) The OHDSI Community, (II) Uniform data representation, (III) Data Analytics, (IV) Evidence Quality, and (V) OHDSI Studies. Each section has multiple chapters, and each chapter aims to follow the following main outline: Introduction, Theory, Practice, Excercises. 
