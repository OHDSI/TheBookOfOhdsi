--- 
title: "The Book of OHDSI"
author: "Observational Health Data Sciences and Informatics"
date: "2019-11-11"
classoption: 11pt      
geometry:
- paperheight=10in 
- paperwidth=7in
- margin=1in
- inner=1in
- outer=0.65in
- top=0.8in
- bottom=0.8in
mainfont: Times New Roman
bibliography:
- book.bib
- packages.bib
description: A book about the Observational Health Data Sciences and Informatics (OHDSI). It described the OHDSI community, open standards and open source software.
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

<img src="images/Cover/Cover.png" width="250" height="375" alt="Cover image" align="right" style="margin: 0 1em 0 1em" /> This is a book about the Observational Health Data Sciences and Informatics (OHDSI) collaborative. The OHDSI community wrote the book to serve as a central knowledge repository for all things OHDSI. The Book is a living document, community-maintained through open-source development tools, and evolves continuously. The online version, available for free at [http://book.ohdsi.org](http://book.ohdsi.org), always represents the latest version. A physical copy of the book is available from [Amazon](https://www.amazon.com/OHDSI-Observational-Health-Sciences-Informatics/dp/1088855199) at cost price.

## Goals of this Book {-}

This book aims to be a central knowledge repository for OHDSI, and it focuses on describing the OHDSI community, OHDSI data standards, and OHDSI tools. It is intended both for both OHDSI newcomers and veterans alike, and aims to be practical, providing the necessary theory and subsequent instructions on how to do things. After reading this book you will understand what OHDSI is, and how you can join the journey. You will learn what the common data model and standard vocabularies are, and how they can be used to standardize an observational healthcare database. You will learn the three main use cases for these data: characterization, population-level estimation, and patient-level prediction. You will read about OHDSI's open-source tools that support all three activities and how to use those tools. Chapters on data quality, clinical validity, software validity, and method validity will explain how to establish the quality of the generated evidence. Lastly, you will learn how to use the OHDSI tools to execute these studies in a distributed research network.

## Structure of the Book {-}

This book is organized in five major sections: 

I) The OHDSI Community
II) Uniform data representation
III) Data Analytics
IV) Evidence Quality
V) OHDSI Studies

Each section has multiple chapters, and, as appropriate, each chapter follows the sequence: Introduction, Theory, Practice, Summary, and Exercises. 

## Contributors {-}

Each chapter lists one or more chapter leads. These are the people who lead the writing of the chapter. However, there are many others that have contributed to the book, whom we would like to acknowledge here:


------------------  -----------------  ---------------------
Hamed Abedtash      Mustafa Ascha      Mark Beno            
Clair Blacketer     David Blatt        Brian Christian      
Gino Cloft          Frank DeFalco      Sara Dempster        
Jon Duke            Sergio Eslava      Clark Evans          
Thomas Falconer     George Hripcsak    Vojtech Huser        
Mark Khayter        Greg Klebanov      Kristin Kostka       
Bob Lanese          Wanda Lattimore    Chun Li              
David Madigan       Sindhoosha Malay   Harry Menegay        
Akihiko Nishimura   Ellen Palmer       Nirav Patil          
Jose Posada         Nicole Pratt       Dani Prieto-Alhambra 
Christian Reich     Jenna Reps         Peter Rijnbeek       
Patrick Ryan        Craig Sachson      Izzy Saridakis       
Paola Saroufim      Martijn Schuemie   Sarah Seager         
Anthony Sena        Chan Seng You      Sunah Song           
Matt Spotnitz       Marc Suchard       Joel Swerdel         
Devin Tian          Don Torok          Kees van Bochove     
Mui Van Zandt       Erica Voss         Kristin Waite        
Mike Warfe          Jamie Weaver       James Wiggins        
Andrew Williams     Chan You Seng                           
------------------  -----------------  ---------------------

## Software Versions {-}

A large part of this book is about the open-source software of OHDSI, and this software will evolve over time. Although the developers do their best to offer a consistent and stable experience to the users, it is inevitable that over time improvements to the software will render some of the instructions in this book outdated. The community will update the online version of the book to reflect those changes, and new editions of the hard copy will be released over time. For reference, these are the version numbers of the software used in this version of the book:

- ACHILLES: version 1.6.6
- ATLAS: version 2.7.3
- EUNOMIA: version 1.0.0
- Methods Library packages: see Table \@ref(tab:packageVersions)


Table: (\#tab:packageVersions)Versions of packages in the Methods Library used in this book.

Package                    Version 
-------------------------  --------
CaseControl                1.6.0   
CaseCrossover              1.1.0   
CohortMethod               3.1.0   
Cyclops                    2.0.2   
DatabaseConnector          2.4.1   
EmpiricalCalibration       2.0.0   
EvidenceSynthesis          0.0.4   
FeatureExtraction          2.2.4   
MethodEvaluation           1.1.0   
ParallelLogger             1.1.0   
PatientLevelPrediction     3.0.6   
SelfControlledCaseSeries   1.4.0   
SelfControlledCohort       1.5.0   
SqlRender                  1.6.2   

## License {-}

This book is licensed under the [Creative Commons Zero v1.0 Universal license](http://creativecommons.org/publicdomain/zero/1.0/).

![](images/Preface/cc0.png)

## How the Book Is Developed {-}

The book is written in [RMarkdown](https://rmarkdown.rstudio.com) using the [bookdown](https://bookdown.org) package. The online version is automatically rebuilt from the source repository at [https://github.com/OHDSI/TheBookOfOhdsi](https://github.com/OHDSI/TheBookOfOhdsi) through the continuous integration system ["travis"](http://travis-ci.org/). At regular intervals a snapshot is taken of the state of the book and marked as an "edition." These editions will be available as physical copies from Amazon.

