# OHDSI Analytics Tools {#OhdsiAnalyticsTools}

*Chapter leads: Martijn Schuemie & Frank DeFalco*

OHDSI offers a wide range of open source tools to support various data-analytics use cases on observational patient-level data. What these tools have in common is that they can all interact with one or more databases using the Common Data Model (CDM). Furthermore, these tools standardize the analytics for various use cases; Rather than having to start from scratch, an analysis can be implemented by filling in standard templates. This makes performing analysis easier, and also improves reproducibility and transparency. For example, there appear to be a near-infinite number of ways to compute an incidence rate, but these can be specified in the OHDSI tools with a few choices, and anyone making those same choices will compute incidence rates the same way. 

In this chapter we first describe various ways in which we can choose to implement an analysis, and what strategies the analysis can employ. We then review the various OHDSI tools and how they fit the various use cases.

## Analysis implementation {#analysisImplementation}

Figure \@ref(fig:implementations) shows the various ways in which we can choose to implement a study against a database using the CDM. \index{analysis implementation}

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/implementations.png" alt="Different ways to implement an analysis against data in the CDM." width="90%" />
<p class="caption">(\#fig:implementations)Different ways to implement an analysis against data in the CDM.</p>
</div>

We may choose to write our analysis as custom code, and not make use of any of the tools OHDSI has to offer. One could write a de novo analysis in R, SAS, or any other language. This provides the maximum flexibility, and may in fact be the only option if the specific analysis is not supported by any of our tools. However, this path requires a lot of technical skill, time, and effort, and as the analysis increases in complexity it becomes harder to avoid errors in the code.

An alternative is to develop the analysis in R, and make use of the packages in the [OHDSI Methods Library](https://ohdsi.github.io/MethodsLibrary/). At a minimum, one could use the [SqlRender](https://ohdsi.github.io/SqlRender/) and [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/) packages described in more detail in Chapter \@ref(SqlAndR) that allow the same code to be executed on various database platforms, such as PostgreSQL, SQL Server, and Oracle. Other packages such as [CohortMethod](https://ohdsi.github.io/CohortMethod/) and [PatientLevelPrediction](https://ohdsi.github.io/PatientLevelPrediction/) offer R functions for advanced analytics against the CDM that can be called on in one's code. This still requires a lot of technical expertise, but by re-using the validated components of the Methods Library we can be more efficient and error-free than when using completely custom code.

The third approach relies on our interactive analysis platform [ATLAS](https://github.com/OHDSI/Atlas/wiki), a web-based tool that allows non-programmers to perform a wide range of analyses efficiently. ATLAS makes use of the Methods Libraries but provides a simple, point and click interface to design analyses and in many cases generate the necessary R code to run the analysis.  The pace of development can vary between the Methods Libraries and ATLAS which can lead to limited options in the ATLAS interface where the underlying libraries have more flexibility. 

ATLAS and the Methods Library are not independent. Some of the more complicated analytics that can be invoked in ATLAS are executed through calls to the packages in the Methods Library. Similarly, cohorts used in the Methods Library are often designed in ATLAS.

## Analysis strategy

More or less independently of how we choose to implement our analysis is the strategy that our analytics takes in answering specific questions. Figure \@ref(fig:strategies) highlights three strategies that are employed in OHDSI.

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/strategies.png" alt="Strategies for generating evidence for (clinical) questions." width="90%" />
<p class="caption">(\#fig:strategies)Strategies for generating evidence for (clinical) questions.</p>
</div>

The first strategy views every analysis as a single individual study. The analysis must be pre-specified in a protocol, implemented as code, executed against the data, after which the result can be compiled and interpreted. For every question, all steps must be repeated. An example of such an analysis is the OHDSI study into the risk of angioedema associated with levetiracetam compared with phenytoin. [@duke_2017] Here, a protocol was first written, analysis code using the OHDSI Methods Library was developed and executed across the OHDSI network, and results were compiled and disseminated in a journal publication.

The second strategy develops an application that allows users to answer a specific class of questions in real time or near-real time. Once the application has been developed, users can interactively define queries, submit them, and view the results. An example of this strategy is the cohort definition and generation tool in ATLAS. This tool allows users to specify cohort definitions of varying complexity, and execute the definition against a database to see how many people meet the various inclusion and exclusion criteria. 

The third strategy similarly focuses on a class of questions, but then attempts to exhaustively generate all the evidence for the questions within the class. Users can then explore the evidence as needed through a variety of interfaces. One example is the OHDSI study into the effects of depression treatments [@schuemie_2018b]. In this study all depression treatments are compared for a large set of outcomes of interest across four large observational databases. The full set of results, including 17,718 empirically calibrated hazard ratios along with extensive study diagnostics, is available in an interactive web app [^systematicEvidenceUrl].

[^systematicEvidenceUrl]: http://data.ohdsi.org/SystematicEvidence/

## ATLAS

ATLAS is a free, publicaly available, web-based tool developed by the OHDSI community that facilitates the design and execution of analyses on standardized, patient-level, observational data in the CDM format.  ATLAS is deployed as a web application in combination with the OHDSI WebAPI and is typically hosted on Apache Tomcat.  Performing real time analyses requires access to the patient-level data in the CDM and is therefore typically installed behind an organization's firewall. However, there is also a public ATLAS [^atlasUrl], and although this ATLAS instance only has access to a small simulated datasets, it can still be used for many purposes including testing and training. For example, it is possible to fully define an effect estimation or prediction study using the public instance of ATLAS, and automatically generate the R code for executing the study. That code can then be run in any environment with an available CDM without needing to install ATLAS and the WebAPI. \index{ATLAS} 

[^atlasUrl]: http://www.ohdsi.org/web/atlas


<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/atlas.png" alt="ATLAS user interface." width="100%" />
<p class="caption">(\#fig:atlas)ATLAS user interface.</p>
</div>

A screenshot of ATLAS is provided in Figure \@ref(fig:atlas). On the left is a navigation bar showing the various functions provided by ATLAS:

Data Sources \index{ATLAS!Data Sources} \index{Achilles|see {ATLAS!data sources}}
: Data sources provides the capability review descriptive, standardized reporting for each of the data sources that you have configured within your Atlas platform. This feature uses the large-scale analytics strategy: all descriptives have been pre-computed. Data sources is discussed in Chapter \@ref(Characterization).

Vocabulary Search \index{ATLAS!vocabulary search} 
: Atlas provides the ability to search and explore the OMOP standardized vocabulary to understand what concepts exist within those vocabularies and how to apply those concepts in your standardized analysis against your data sources. This feature is discussed in Chapter \@ref(StandardizedVocabularies).

Concept Sets \index{ATLAS!concept sets} \index{concept sets|see {ATLAS!concept sets}}
: Concept sets provides the ability to create collections of logical expressions that can be used to identify a set of concepts to be used throughout your standardized analyses.  Concept sets provide more sophistication than a simple list of codes or values.  A concept set is comprised of multiple concepts from the standardized vocabulary in combination with logical indicators that allow a user to specify that they are interested in including or excluding related concepts in the vocabulary hierarchy.  Searching the vocabulary, identifying the set of concepts, and specifying the logic to be used to resolve a concept set provides a powerful mechanism for defining the often obscure medical language used in analysis plans.  These concept sets can be saved within ATLAS and then used throughout your analysis as part of cohort definitions or analysis specifications.

Cohort Definitions \index{ATLAS!cohort definitions}
: Cohort definitions is the ability to construct a set of persons who satisfy one or more criteria for a duration of time and these cohorts can then serve as the basis of inputs for all of your subsequent analyses. This feature is discussed in Chapter \@ref(Cohorts).

Characterizations \index{ATLAS!cohort characterization}
: Characterizations is an analytic capability that allows you to look at one or more cohorts that you've defined and to summarize characteristics about those patient populations. This feature uses the real-time query strategy, and is discussed in Chapter \@ref(Characterization).

Cohort Pathways \index{ATLAS!cohort pathways}
: Cohort pathways is an analytic tool that allows you to look at the sequence of clinical events that occur within one or more populations. This feature uses the real-time query strategy, and is discussed in Chapter \@ref(Characterization).

Incidence Rates \index{ATLAS!incidence rates}
: Incidence rates is a tool that allows you to estimate the incidence of outcomes within target populations of interest. This feature uses the real-time query strategy, and is discussed in Chapter \@ref(Characterization).

Profiles \index{ATLAS!profiles}
: Profiles is a tool that allows you to explore an individual patients longitudinal observational data to summarize what is going on within a given individual. This feature uses the real-time query strategy.

Population Level Estimation \index{ATLAS!population level estimation}
: Estimation is a capability to allow you to define a population level effect estimation study using a comparative cohort design whereby comparisons between one or more target and comparator cohorts can be explored for a series of outcomes. This feature can be said to implement the real-time query strategy, as no coding is required, and is discussed in Chapter \@ref(PopulationLevelEstimation).

Patient Level Prediction \index{ATLAS!patient level prediction}
: Prediction is a capability to allow you to apply machine learning algorithms to conduct patient level prediction analyses whereby you can predict an outcome within any given target exposures. This feature can be said to implement the real-time query strategy, as no coding is required, and is discussed in Chapter \@ref(PatientLevelPrediction).

Jobs \index{ATLAS!jobs}
: Select the Jobs menu item to explore the state of processes that are running through the WebAPI. Jobs are often long running processes such as generating a cohort or computing cohort characterization reports. 

Configuration \index{ATLAS!configuration}
: Select the Configuration menu item to review the data sources that have been configured in the source configuration section. 

Feedback \index{ATLAS!feedback}
: The Feedback link will take you to the issue log for Atlas so that you can log a new issue or to search through existing issues. If you have ideas for new features or enhancements, this is also a place note these for the development community.

### Security
ATLAS and the WebAPI provide a granular security model to control access to features or data sources within the overall platform.  The security system is built leveraging the Apache Shiro library.  Additional information on the security system can be found in the online [WebAPI security wiki](https://github.com/OHDSI/WebAPI/wiki/Security-Configuration). \index{ATLAS!security}

### Documentation 
Documentation for ATLAS can be found online in the [ATLAS Github repository wiki](https://github.com/OHDSI/ATLAS/wiki).  This wiki includes information on the various application features as well as links to online video tutorials.  \index{ATLAS!documentation}

### How to install
Installation of ATLAS is done in combination with the OHDSI WebAPI.  Installation guides for each component are available online in the [ATLAS Github repository Setup Guide](https://github.com/OHDSI/Atlas/wiki/Atlas-Setup-Guide) and [WebAPI Github repository Installation Guide](https://github.com/OHDSI/WebAPI/wiki/WebAPI-Installation-Guide). \index{ATLAS!installation}

## Methods Library

The [OHDSI Methods Library](https://ohdsi.github.io/MethodsLibrary/) is the collection of open source R packages show in Figure \@ref(fig:methodsLibrary). \index{methods library}

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/methodsLibrary.png" alt="Packages in the OHDSI Methods Library." width="100%" />
<p class="caption">(\#fig:methodsLibrary)Packages in the OHDSI Methods Library.</p>
</div>

The packages offer R functions that together can be used to perform an observation study from data to estimates and supporting statistics, figures, and tables. The packages interact directly with observational data in the CDM, and can be used simply to provide cross-platform compatibility to completely custom analyses as described in Chapter \@ref(SqlAndR), or can provide advanced standardized analytics for population characterization (Chapter \@ref(Characterization)), population-level causal effect estimation (Chapter \@ref(PopulationLevelEstimation)), and patient-level prediction (Chapter \@ref(PatientLevelPrediction)). The Methods Library supports best practices for use of observational data as learned from previous and ongoing research, such as transparency, reproducibility, as well as measuring of the operating characteristics of methods in a particular context and subsequent empirical calibration of estimates produced by the methods. 

The Methods Library has already been used in many published clinical studies [@boland_2017; @duke_2017; @ramcharran_2017; @weinstein_2017; @wang_2017; @ryan_2017; @ryan_2018; @vashisht_2018; @yuan_2018; @johnston_2019], as well as methodological studies [@schuemie_2014; @schuemie_2016; @reps2018; @tian_2018; @schuemie_2018; @schuemie_2018b; @reps_2019]. Great care is taken to ensure the validity of the Methods Library, as described in Chapter \@ref(SoftwareValidity).

### Support for large-scale analytics

One key feature incorporated in all packages is the ability to efficiently run many analyses. For example, when performing population-level estimation, the CohortMethod package allows for computing effect-size estimates for many exposures and outcomes, using various analysis settings, and the package will automatically choose the optimal path to compute all the required artifacts. Steps that can be re-used, such as extraction of covariates, or fitting a propensity model, will be executed only once. Where possible, computations will take place in parallel to maximize the use of computational resources.

This feature allows for large-scale analytics, answering many questions at once, and is also essential for including control hypotheses (e.g. negative controls) to measure the operating characteristics of our methods, and perform empirical calibration as described in Chapter \@ref(MethodValidity). \index{control hypotheses} 

### Support for big data {#BigDataSupport}

The Methods Library is also designed to run against very large databases and be able to perform computations involving large amounts of data. This achieved in three ways:

1. Most data manipulation is performed on the database server. An analysis usually only requires a small fraction of the entire data in the database, and the Methods Library, through the SqlRender and DatabaseConnector packages, allows for advanced operations to be performed on the server to preprocess and extract the relevant data.
2. Large local data objects are stored in a memory-efficient manner. For the data that is downloaded to the local machine, the Methods Library uses the [ff](https://cran.r-project.org/web/packages/ff) package to store and work with large data objects. This allows us to work with data much larger than fits in memory.
3. High-performance computing is applied where needed. For example, the [Cyclops](https://ohdsi.github.io/Cyclops/) package implements a highly efficient regression engine that is used throughout the Methods Library to perform large-scale regressions (large number of variables, large number of observations) that would not be possible to fit otherwise.

### Documentation

R provides a standard way of documenting package. Each package has a *package manual* that documents every function and data set in the package. All package manuals are available online through the Methods Library website [^methodsLibraryUrl], through the package GitHub repositories, and for those packages available through CRAN they can be found in CRAN. Furthermore, from within R the package manual can be consulted by using the question mark. For example, after loading the DatabaseConnector package, typing the command `?connect` brings up the documentation on the "connect" function.

[^methodsLibraryUrl]: https://ohdsi.github.io/MethodsLibrary

In addition to the package manual, many packages provide *vignettes*. Vignettes are long-form documentation that describe how a package can be used to perform certain tasks. For example, one vignette [^vignetteUrl] describes how to perform multiple analyses efficiently using the CohortMethod package. Vignettes can also be found through the Methods Library website , through the package GitHub repositories, and for those packages available through CRAN they can be found in CRAN. \index{vignette}

[^vignetteUrl]: https://ohdsi.github.io/CohortMethod/articles/MultipleAnalyses.html

###  System requirements

Two computing environments are relevant when discussing the system requirements: The database server, and the analytics workstation. \index{system requirements}

The database server must hold the observational healthcare data in CDM format. The Methods Library supports a wide array of database management systems including traditional database systems (PostgreSQL, Microsoft SQL Server, and Oracle), parallel data warehouses (Microsoft APS, IBM Netezza, and Amazon RedShift), as well as Big Data platforms (Hadoop through Impala, and Google BigQuery). 

The analytics workstation is where the Methods Library is installed and run. This can either be a local machine, such as someone's laptop, or a remote server running RStudio Server. In all cases the requirements are that R is installed, preferably together with RStudio. The Methods Library also requires that Java is installed. The analytics workstation should also be able to connect to the database server, specifically, any firewall between them should have the database server access ports opened the the workstation. Some of the analytics can be computationally intensive, so having multiple processing cores and ample memory can help speed up the analyses. We recommend having at least four cores and 16 gigabytes of memory.

### How to install {#installR}

Here are the steps for installing the required environment to run the OHDSI R packages. Four things needs to be installed: \index{R!installation}

1. **R** is a statistical computing environment. It comes with a basic user interface that is primarily a command-line interface.
2. **RTools** is a set of programs that is required on Windows to build R packages from source.
3. **RStudio** is an IDE (Integrated Development Environment) that makes R easier to use. It includes a code editor, debugging and visualization tools. Please use it to obtain a nice R experience.
4. **Java** is a computing environment that is needed to run some of the components in the OHDSI R packages, for example those needed to connect to a database.

Below we describe how to install each of these in a Windows environment.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">In Windows, both R and Java come in 32-bit and 64-bits architectures. If you install R in both architectures, you **must** also install Java in both architectures. It is recommended to only install the 64-bit version of R.</div>\EndKnitrBlock{rmdimportant}

#### Installing R {-}

1. Go to [https://cran.r-project.org/](https://cran.r-project.org/), click on "Download R for Windows", then "base", then click the Download link indicated in Figure \@ref(fig:downloadR).  

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/downloadR.png" alt="Downloading R from CRAN." width="100%" />
<p class="caption">(\#fig:downloadR)Downloading R from CRAN.</p>
</div>

2. After the download has completed, run the installer. Use the default options everywhere, with two exceptions: First, it is better not to install into program files. Instead, just make R a subfolder of your C drive as shown in Figure \@ref(fig:rDestination). Second, to avoid problems due to differing architectures between R and Java, disable the 32-bit architecture as shown in Figure \@ref(fig:no32Bits).

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/rDestination.png" alt="Settings the destination folder for R." width="80%" />
<p class="caption">(\#fig:rDestination)Settings the destination folder for R.</p>
</div>

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/no32Bits.png" alt="Disabling the 32-bit version of R." width="80%" />
<p class="caption">(\#fig:no32Bits)Disabling the 32-bit version of R.</p>
</div>

Once completed, you should be able to select R from your Start Menu. 

#### Installing RTools {-}

1. Go to [https://cran.r-project.org/](https://cran.r-project.org/), click on "Download R for Windows", then "Rtools", and select the very latest version of RTools to download.

2. After downloading has completed run the installer. Select the default options everywhere.

#### Installing RStudio {-}

1. Go to [https://www.rstudio.com/](https://www.rstudio.com/), select "Download RStudio" (or the "Download" button under "RStudio"), opt for the free version, and download the installer for Windows as shown in Figure \@ref(fig:downloadRStudio).

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/downloadRStudio.png" alt="Downloading RStudio." width="100%" />
<p class="caption">(\#fig:downloadRStudio)Downloading RStudio.</p>
</div>

2. After downloading, start the installer, and use the default options everywhere.

#### Installing Java {-}

1. Go to [https://java.com/en/download/manual.jsp](https://java.com/en/download/manual.jsp), and select the Windows 64-bit installer as shown in Figure \@ref(fig:downloadJava). If you also installed the 32-bit version of R, you *must* also install the other (32-bit) version of Java.


<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/downloadJava.png" alt="Downloading Java." width="100%" />
<p class="caption">(\#fig:downloadJava)Downloading Java.</p>
</div>

2. After downloading just run the installer.

#### Verifying the installation {-}

You should now be ready to go, but we should make sure. Start RStudio, and type


```r
install.packages("SqlRender")
library(SqlRender)
translate("SELECT TOP 10 * FROM person;", "postgresql")
```

```
## [1] "SELECT  * FROM person LIMIT 10;"
```

This function uses Java, so if all goes well we know both R and Java have been installed correctly!

Another test is to see if source packages can be built. Run the following R code to install the `CohortMethod` package from the OHDSI GitHub repository:

```r
install.packages("drat")
drat::addRepo("OHDSI")
install.packages("CohortMethod")
```


## Deployment strategies

Deploying the entire OHDSI tool stack, including ATLAS and the Methods Library, in an organization is a daunting task. There are many components with dependencies that have to be considered, and configurations to set. For this reason, two initiatives have developed integrated deployment strategies that allow the entire stack to be installed as one package, using some forms of virtualization: Broadsea and Amazon Web Services (AWS).  \index{tools deployment}

### Broadsea

BroadSea[^broadseaUrl] uses Docker container technology[^dockerUrl]. The OHDSI tools are packaged along with dependencies into a single portable binary file called a Docker Image. This image can then be run on a Docker engine service, creating a virtual machine with all the software installed and ready to run. Docker engines are available for most operating systems, including Microsoft Windows, MacOS, and Linux. The Broadsea Docker image contains the main OHDSI tools, including the Methods Library and ATLAS. \index{tools deployment!Broadsea}

[^broadseaUrl]: https://github.com/OHDSI/Broadsea
[^dockerUrl]: https://www.docker.com/

### Amazon AWS

Amazon has prepared two environments that can be instantiated in the AWS cloud computing environment with a click of the button: OHDSI-in-a-Box[^ohdsiInaBoxUrl] and OHDSIonAWS[^ohdsiOnAwsUrl]. \index{tools deployment!Amazon AWS}

OHDSI-in-a-Box is specifically created as a learning environment, and is used in most of the tutorials provided by the OHDSI community. It includes many OHDSI tools, sample data sets, RStudio and other supporting software in a single, low cost Windows virtual machine.  A PostgreSQL database is used to store the CDM and also to store the intermediary results from ATLAS. The OMOP CDM data mapping and ETL tools are also included in OHDSI-in-a-Box. The architecture for OHDSI-in-a-Box is depicted in Figure \@ref(fig:ohdsiinaboxDiagram).

[^ohdsiInaBoxUrl]: https://github.com/OHDSI/OHDSI-in-a-Box

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/OHDSI-in-a-BoxDiagram.png" alt="The Amazon Web Services architecure for OHDSI-in-a-Box." width="100%" />
<p class="caption">(\#fig:ohdsiinaboxDiagram)The Amazon Web Services architecure for OHDSI-in-a-Box.</p>
</div>

OHDSIonAWS is a reference architecture for enterprise class, multi-user, scalable and fault tolerant OHDSI environments that can be used by organizations to perform their data analytics. It includes several sample datasets and can also automatically load your organization's real healthcare data. The data is placed in the Amazon Redshift database platform, which is supported by the OHDSI tools. Intermediary results of ATLAS are stored in a PostgreSQL database. On the front end, users have access to ATLAS and to RStudio through a web interface (leveraging RStudio Server). In RStudio the OHDSI Methods Library has already been installed, and can be used to connect to the databases. The automation to deploy OHDSIonAWS is open-source, and can be customized to include your organization's management tools and best practices.  The architecture for OHDSIonAWS is depicted in Figure \@ref(fig:ohdsionawsDiagram).

[^ohdsiOnAwsUrl]: https://github.com/OHDSI/OHDSIonAWS

<div class="figure" style="text-align: center">
<img src="images/OhdsiAnalyticsTools/OHDSIonAWSDiagram.png" alt="The Amazon Web Services architecure for OHDSIonAWS." width="100%" />
<p class="caption">(\#fig:ohdsionawsDiagram)The Amazon Web Services architecure for OHDSIonAWS.</p>
</div>

## Summary

\BeginKnitrBlock{rmdsummary}<div class="rmdsummary">- TODO: add
</div>\EndKnitrBlock{rmdsummary}

## Exercises

Todo



