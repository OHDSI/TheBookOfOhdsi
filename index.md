--- 
title: "The Book of OHDSI"
author: "Observational Health Data Science and Informatics"
date: "2019-08-13"
classoption: 11pt      
geometry:
- paperheight=10in 
- paperwidth=7in
- margin=1in
- inner=0.75in
- outer=0.45in
- top=0.7in
- bottom=0.65in
mainfont: Times New Roman
bibliography:
- book.bib
- packages.bib
description: A book about the Observational Health Data Science and Informatics (OHDS). It described the OHDSI community, open standards and open source software.
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

This book aims to be a central knowledge repository for OHDSI, and focuses on describing the OHDSI community, data standards, and tools. It is intended both for those new to OHDSI and veterans alike, and aims to be practical, providing the necessary theory and subsequent instructions on how to do things. After reading this book you will understand what OHDSI is, and how you can join the journey. You will learn what the common data model and standard vocabularies are, and how they can be used to standardize an observational healthcare database. You will learn there are three main use cases for these data: characterization, population-level estimation, and patient-level prediction, and that all three activities are supported by OHDSI's open source tools, and how to use them. You will learn how to establish the quality of the generated evidence through data quality, clinical validity, software validity, and method validity. Lastly, you will learn how these tools can be used to execute these studies in a distributed research network.

## Structure of the book {-}

This book is organized in five major sections: 

I) The OHDSI Community
II) Uniform data representation
III) Data Analytics
IV) Evidence Quality
V) OHDSI Studies

Each section has multiple chapters, and each chapter aims to follow the following main outline: Introduction, Theory, Practice, Excercises. 

## Contributors {-}

TODO: make list of contributors complete

Each chapter lists one or more chapter leads. These are the people who lead the writing of the chapters. However, there are many others that have contributed to the book, whom we would like to acknowledge here:


\begin{tabular}{l|l|l}
\hline
Hamed Abedtash & Mustafa Ascha & Mark Beno\\
\hline
Clair Blacketer & David Blatt & Brian Christian\\
\hline
Gino Cloft & Frank DeFalco & Sara Dempster\\
\hline
Jon Duke & Sergio Eslava & Clark Evans\\
\hline
Thomas Falconer & George Hripcsak & Vojtech Huser\\
\hline
Mark Khayter & Greg Klebanov & Kristin Kostka\\
\hline
Bob Lanese & Wanda Lattimore & Chun Li\\
\hline
David Madigan & Sindhoosha Malay & Harry Menegay\\
\hline
Akihiko Nishimura & Ellen Palmer & Nirav Patil\\
\hline
Jose Posada & Nicole Pratt & Dani Prieto-Alhambra\\
\hline
Christian Reich & Jenna Reps & Peter Rijnbeek\\
\hline
Patrick Ryan & Craig Sachson & Izzy Saridakis\\
\hline
Paula Saroufim & Martijn Schuemie & Sarah Seager\\
\hline
Anthony Sena & Chan Seng You & Sunah Song\\
\hline
Matt Spotnitz & Marc Suchard & Joel Swerdel\\
\hline
Devin Tian & Don Torok & Kees van Bochove\\
\hline
Mui Van Zandt & Erica Voss & Kristin Waite\\
\hline
Mike Warfe & Jamie Weaver & James Wiggins\\
\hline
Andrew Williams & Chan You Seng & \\
\hline
\end{tabular}

