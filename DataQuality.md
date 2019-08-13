# Data Quality {#DataQuality}


*Chapter leads: Martijn Schuemie, Vojtech Huser & Andrew Williams* 

Most of the data used for observational healthcare research were not collected for research purposes. For example, electronic health records (EHRs) aim to capture the information needed to support the care of patients, and adminstrative claims are collected to provide a grounds for allocating costs to payers. Many have questioned whether it is appropriate to use such data for clinical research, with @vanDerLei_1991 even stating that "Data shall be used only for the purpose for which they were collected". The concern is that because the data was not collected for the research that we would like to do, it is not guaranteed to have sufficient quality. If the quality of the data is poor (garbage in), then the quality of the result of research using that data must be poor as well (garbage out). An important aspect of observational healthcare research therefore deals with assessing data quality, aiming to answer the question:

> Are the data of sufficient quality for our research purposes?

We can define data quality (DQ) as [@roebuck_2012]: \index{data quality}

> The state of completeness, validity, consistency, timeliness and accuracy that makes data appropriate for a specific use.

Note that it is unlikely that our data are perfect, but they may be good enough for our purposes. 

DQ cannot be observed directly, but methodology has been developed to assess it. Two types of DQ assessments can be distinguished [@weiskopf_methods_2013]: assessments to evaluate DQ in general, and assessments to evaluate DQ in the context of a specific study.

In this chapter we will first review possible sources of DQ problems, after which we'll discuss the theory of general and study-specific DQ assessments, followed by a step-by-step description of how these assessments can be performed using the OHDSI tools.

## Sources of data quality problems

There are many threats to the quality of the data, starting as noted in Chapter \@ref(EvidenceQuality) when the doctor records her or his thoughts. @dasu_2003 distinguish the following steps in the lifecycle of data, recommending DQ be integrated in each step. They refer to this as the DQ continuum:

1. **Data gathering and integration**. Possible problems include fallible manual entry, biases (e.g. upcoding in claims), erroneous joining of tables in an EHR, and replacing missing values with default ones. 
2. **Data storage and knowledge sharing**. Potential problems are lack of documentation of the data model, and lack of meta-data.
3. **Data analysis**. Problems can include incorrect data transformations, incorrect data interpretation, and use of inapproriate methodology. 
4. **Data publishing**. When publishing data for downstream use.

Often the data we use has already been collected and integrated, so there is little we can do to improve step 1. We do have ways to check the DQ produced by this step as will be discussed in subsequent sections in this chapter. 

Similarly, we often receive the data in a specific form, so we have little influence over part of step 2. However, in OHDSI we convert all our observational data to the Common Data Model (CDM), and we do have ownership over this process. Some have expressed concerns that this specific step can degrade DQ. But because we control this process, we can build stringent safeguards to preserve DQ as discussed later in Section x. Several investigations [@defalco_2013;@makadia_2014;@matcho_2014;@voss_2015;@voss_2015b;@hripcsak_2018] have shown that when properly executed, little to no error is introduced when converting to the CDM. In fact, having a well-documented data model that is shared by a large community facilitates data storage in unambiguous and clear manner.

Step 3 (data analysis) also falls under our control. In OHDSI, we tend to not use the term DQ for the quality issues during this step, but rather the terms *clinical validity*, *software validity* and *method validity*, which are discussed at length in Chapters \@ref(ClinicalValidity), \@ref(SoftwareValidity), and \@ref(MethodValidity), respectively.

## Data quality in general

We can ask the question whether our data is fit for the general purpose of observational research. @kahn_harmonized_2016 define such generic DQ as consisting of three components: 

1. **Conformance**: Do data values adhere to do specified standard and formats? Three subtypes are identified:
   - **Value**: Are recorded data elements in agreement with the specified formats? For example, are all provider medical specialties valid specialties? 
   - **Relational**: Is the recorded data in agreement with specified relational constraints? For example, does the provider_id in a DRUG_EXPOSURE data have a corresponding record in the PROVIDER table?
   - **Computation**: Do computations on the data yield the intended results? For example, is BMI computed from height and weight equal to the verbatim BMI recorded in the data?
2. **Completeness**: Are data values present? For example, do all persons have a known gender?
3. **Plausibility**: Are data values believable? Three subtypes are defined:
    - **Uniqueness**: For example, does each person_id occur only once in the PERSON table?
    - **Atemporal**: Do values, distributions, or densities agree with expected values? For example, is the prevalence of diabetes implied by the data in line with the known prevalence?
    - **Temporal**: Are changes in values in line with expectations? For example, are immunization sequences in line with recommendations?
    
    \index{data quality!conformance} \index{data quality!completeness} \index{data quality!plausibility}

Each component can be evaluated in two ways:

* **Verification** focuses on model and data constraints and does not rely on external reference. 
* **Validation** focuses on data expectations that are derived from comparison to a relative gold standard and uses external knowledge. 

\index{data quality!verification} \index{data quality!validation}

### Data quality checks

Kahn introduces the term *data quality check* (sometimes refered to as a *data quality rule*) that tests whether data conform to a given requirement (e.g., flagging an implausible age of 141 of a patient, potentially due to incorrect birth year or missing death event). We can implement such checks in sofware, creating automated DQ tools. One such tool is [ACHILLES](https://github.com/OHDSI/Achilles) (Automated Characterization of Health Information at Large-scale Longitudinal Evidence Systems) [@huser_methods_2018]. ACHILLES is a software tool that not only executes a wide array of DQ checks, it also provides characterization and visualization of a database conforming to the CDM. As such, it can be used to evaluate DQ in a network of databases [@huser_multisite_2016]. ACHILLES is available as a stand-alone tool, and is also integrated into ATLAS as the "Data Sources" function. \index{data quality!data quality check} \index{ACHILLES}

ACHILLES pre-computes over 170 data characterization analyses, with each analysis having an analysis ID and a short description of the analysis, for example, “715: Distribution of days_supply by drug_concept_id” or “506: Distribution of age at death by gender”. The results of these analyses are stored in a database, and can be accessed by a web viewer or by ATLAS. Based on these analyses, a battery of DQ tests is performed know as "*ACHILLES Heel*". These checks are categorized as "*error*", "*warning*", or "*notification*". Errors are DQ issues that should not be present, constituting violations of some fundamental principles that must be resolved before the data can be used for research. Warnings indicate something is likely wrong although a closer investigation is needed to make a definite dermination. Notifications hint add odd characteristics that should be explored, but fall within the range of what is expected. Table \@ref(tab:heelExamples) show some example rules. \index{ACHILLES!Heel}

Table: (\#tab:heelExamples) Example data quality rules in ACHILLES Heel.

|Type       | Description                                       |
|:--------- |:--------------------------------------------------|
| Error     | Age > 150 years                                   |
| Error     | A condition_concept_id refers to a concept that is not in the CONDITION domain |
| Warning   | The rate of occurrence for a specific concept_id changes more than 100% from one month to the next |
| Warning   | A presciption has a days_supply > 180             |
| Notification | The number of patients without any visit exceeds a predefined threshold |
| Notification | There is no weight data in the MEASUREMENT table        | 


\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">ACHILLES and ACHILLES Heel are executed against the data in the CDM. DQ issues identified this way may be due to the conversion to the CDM, but may also reflect DQ issues already present in the source data. If the conversion is at fault, it is usually within our control to remedy the problem, but if the underlying data is at fault the only course of action may be to delete the offending records.
</div>\EndKnitrBlock{rmdimportant}

### ETL unit tests

The ETL (Extract-Transform-Load) process by which data is converted to the CDM is often quite complex, and with that complexity comes the danger of making mistakes that may go unnoticed. Moreover, as time goes by the source data model may change, or the CDM may be updated, making it necessary to modify the ETL process. Changes to a process as complicated as an ETL can have unintended consequences, requiring all aspects of the ETL to be reconsidered and reviewed. 

To make sure the ETL does what it is supposed to do, and continues to do so, it is highly recommended to construct a set of unit tests. A unit test is a small piece of code that automatically checks a single aspect. The Rabbit-in-a-Hat tool described in Chapter \@ref(ExtractTransformLoad) can create a unit test framework that makes writing such unit tests easier. This framework is a collection of R functions created specifically for the source database and target CDM version of the ETL. Some of these functions are for creating fake data entries that adhere to the source data schema, while other functions can be used to specify expectations on the data in the CDM format. Here is an example unit test:


```r
source("Framework.R")
declareTest(101, "Person gender mappings")
add_enrollment(member_id = "M000000102", gender_of_member = "male")
add_enrollment(member_id = "M000000103", gender_of_member = "female")
expect_person(person_id = 102, gender_concept_id = 8507
expect_person(person_id = 103, gender_concept_id = 8532)
```

In this example, the framework generated by Rabbit-in-a-Hat is sourced, loading the functions that are used in the remainder of the code. We then declare we will start testing person gender mappings. The source schema has an ENROLLMENT table, and we use the add_enrollment function created by Rabbit-in-a-Hat to create two entries with different values for the member_id and gender_of_member fields. Note that the ENROLLMENT table has many other fields, and if we do not provide explicit values for these other fields the add_enrollemnt function will assign default values (the most prevalent values as observed in the White Rabbit scan report). Finally, we specify the expectation that after the ETL two entries should exist in the PERSON table, with various expected values.

Similar unit tests can be created for all other logic in an ETL, typically resulting in hundreds of tests. When we are done defining the test, we can use the framework to generate two sets of SQL statements, one to create the fake source data, and one to create the tests on the ETL-ed data:


```r
insertSql <- generateInsertSql(databaseSchema = "source_schema")
testSql <- generateTestSql(databaseSchema = "cdm_test_schema")
```

The overall process is depiced in Figure \@ref(fig:testFramework).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/DataQuality/testFramework} 

}

\caption{Unit testing an ETL (Extract-Transform-Load) process using the Rabbit-in-a-Hat testing framework.}(\#fig:testFramework)
\end{figure}

The test SQL returns a table that will look like Table \@ref(tab:exampleTestResults). In this table we see that we passed the two tests we defined earlier.

Table: (\#tab:exampleTestResults) Example ETL unit test results.

| ID    | Description            | Status |
|:-----:|:---------------------- |:------:|
| 101   | Person gender mappings | PASS   |
| 101   | Person gender mappings | PASS   |

The power of these unit tests is that we can easily rerun them any time the ETL process is changed. 

## Study-specific checks

The chapter has so far focused on general DQ checks. Such checks are executed regardless of the single research question context. However, we also recommend performing study-specific DQ assessments.

Some of these assessments can take the form of DQ rules that are specifically relevant for the study. For example, we may want to impose a rule that at least 90% of the records for our exposure of interest specifies the length of exposure. 

A standard assessment is to review the concepts that are most relevant for the study in ACHILLES. Sudden changes over time in the rate with which a code is observed may hint at DQ problems. Some examples will be discussed later in this chapter.

Another assessment is to review the prevalence and changes in prevalence over time of the cohorts used in the study, and see whether these agree with expectations based on external clinical knowledge. For example, exposure of a new drug should be absent before introduction to the market, and will likely increase over time after introduction. Similarly, the prevalence of outcomes should be in line with what is know of the prevalence of the condition in the population. If a study is executed across a network of databases, we can compare the prevalences of cohorts across databases. If a cohort is highly prevalent in one database (compared to the other cohorts in the study), but is missing in another database, there might be a DQ issue. Note  that such an assessment overlaps with the notion of *clinical validity*, as discussed in Chapter \@ref(ClinicalValidity); We may find unexpected prevalences in some databases not because of DQ issues, but because our cohort definition is not truly capturing the health state we are interested in.

### Checking mappings

One possible source of error that falls under our control is the mapping of source codes to Standard Concepts. The mappings in the Vocabulary are meticulously crafted, and errors in the mapping that are noted by members of the community are reported in the Vocabulary issue tracker [^vocabIssueTrackerUrl] and fixed in future releases. Nevertheless, it is impossible to completely check all mappings by hand, and errors likely still exist. When performing a study, we therefore recommend reviewing the mappings for those concepts most relevant to the study. Fortunately, this can be achieved quite easily because in the CDM we store not only the Standard concepts, but also the source codes. We can review both the source codes that do map to the concepts used in the study, as well as those that do not.

[^vocabIssueTrackerUrl]: https://github.com/OHDSI/Vocabulary-v5.0/issues

One way to review the source codes that do map is to use the `checkCohortSourceCodes` function in the [MethodEvaluation](https://ohdsi.github.io/MethodEvaluation/) R package. This function uses a cohort definition as created by ATLAS as input, and for each concept set used in the cohort definition it checks which source codes map to the concepts in the set. It also computes the prevalences of these codes over time to help identify temporal issues associated with specific source codes. The example output in Figure \@ref(fig:sourceCodes) shows a (partial) breakdown of a concept set called 'Depressive disorder'. The most prevalent concept in this concept set in the database of interest is concept  [440383](http://athena.ohdsi.org/search-terms/terms/440383) ("Depressive disorder"). We see that three source codes in the database map to this concept: ICD-9 code 3.11, and ICD-10 codes F32.8 and F32.89. On the left we see that the concept as a whole first shows a gradual increase over time, but then shows a sharp drop. If we look at the individual codes, we see that this drop can be explained by the fact that the ICD-9 code stops being used at the time of the drop. Even though this is the same time the ICD-10 codes start being used, the combined prevalence of the ICD-10 codes is much smaller than that of the ICD-9 code. This specific example was due to the fact that the ICD-19 code F32.9 (""Major depressive disorder, single episode, unspecified") should also have mapped to the concept. This problem has since been resolved in the Vocabulary.

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{images/DataQuality/sourceCodes} 

}

\caption{Example output of he checkCohortSourceCodes function. }(\#fig:sourceCodes)
\end{figure}

Even though the previous example demonstrates a chance finding of a source code that was not mapped, in general identifying missing mapings is more difficult than checking mappings that are present. It requires knowing which source codes should map but don't. A semi-automated way to perform this assessment is to use the `findOrphanSourceCodes` function in the [MethodEvaluation](https://ohdsi.github.io/MethodEvaluation/) R package. This function allows one to search the vocabulary for source codes using a simple text search, and it checks whether these source codes map to a specific concept, or to one of the descendants of that concept. The resulting set of source codes is subsequently restricted to only those that appear in the CDM database at hand. For example, in a study concerning gangrene the concept "Gangrenous disorder" ([439928](http://athena.ohdsi.org/search-terms/terms/439928)) was used. Several terms, including "gangrene", were used to search the descriptions in the CONCEPT and SOURCE_TO_CONCEPT_MAP tables to identify source codes.  Figure \@ref(fig:missingMapping) show that the ICD-10 code J85.0 ("Gangrene and necrosis of lung") was only mapped to concept [4324261](http://athena.ohdsi.org/search-terms/terms/4324261) ("Pulmanory necrosis"), which is not a descendant of "Gangrenous disorder". Note that this issue has been reported and is now fixed.

\begin{figure}

{\centering \includegraphics[width=0.6\linewidth]{images/DataQuality/missingMapping} 

}

\caption{Example orphan source code. }(\#fig:missingMapping)
\end{figure}

## ACHILLES in practice {#achillesInPractice}

Here we will demonstrate how to run ACHILLES against a database in the CDM format. 

We first need to tell R how to connect to the server. ACHILLES uses the [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/) package, which provides a function called `createConnectionDetails`. Type `?createConnectionDetails` for the specific settings required for the various database management systems (DBMS). For example, one might connect to a PostgreSQL database using this code:


```r
library(Achilles)
connDetails <- createConnectionDetails(dbms = "postgresql",
                                       server = "localhost/ohdsi",
                                       user = "joe",
                                       password = "supersecret")

cdmDbSchema <- "my_cdm_data"
cdmVersion <- "5.3.0"
```

The last two lines define the `cdmDbSchema` variable, as well as the CDM version. We will use these later to tell R where the data in CDM format live, and what version CDM is used. Note that for Microsoft SQL Server, database schemas need to specify both the database and the schema, so for example `cdmDbSchema <- "my_cdm_data.dbo"`.

Next, we run ACHILLES:


```r
result <- achilles(connectionDetails,
                   cdmDatabaseSchema = cdmDbSchema,
                   resultsDatabaseSchema = cdmDbSchema,
                   sourceName = "My database",
                   cdmVersion = cdmVersion)
```

This function will create several tables in the `resultsDatabaseSchema`, which here we've set to the same database schema as the CDM data. 

We can extract the results of ACHILLES Heel from that database using:


```r
heel <- fetchAchillesHeelResults(connectionDetails,
                         resultsDatabaseSchema = cdmDatabaseSchema)

head(heel)
```
|ANALYSIS_ID|ACHILLES_HEEL_WARNING|RULE_ID|RECORD_COUNT|
|:--:|:-------------------------------------- |:--:|:---|
118|ERROR: 118-Number of observation periods with invalid person_id; count (n=2649) should not be > 0| 1| 2649|
410|ERROR: 410-Number of condition occurrence records outside valid observation period; count (n=85) should not be > 0| 1| 85|
413|ERROR: 413-Number of condition occurrence records with invalid visit_id; count (n=64717) should not be > 0| 1|64717|
610|ERROR: 610-Number of procedure occurrence records outside valid observation period; count (n=15) should not be > 0| 1| 15|
613|ERROR: 613-Number of procedure occurrence records with invalid visit_id; count (n=36819) should not be > 0| 1|36819|
710|ERROR: 710-Number of drug exposure records outside valid observation period; count (n=80) should not be > 0| 1| 80|

In this case, ACHILLES Heel has revealed several serious errors that will need to be fixed. We can also view the ACHILLES database characterization. This can be done by pointing ATLAS to the ACHILLES results databases, or by exporting the ACHILLES results to a set of JSON files:


```r
exportToJson(connectionDetails,
             cdmDatabaseSchema = cdmDatabaseSchema,
             resultsDatabaseSchema = cdmDatabaseSchema,
             outputPath = "achillesOut")
```

The JSON files will be written to the achillesOut subfolder, and can be used together with the AchillesWeb web application to explore the results. For example, Figure \@ref(fig:achillesDataDensity) shows the ACHILLES data density plot. This plot shows that the bulk of the data starts in 2005. However, there also appear to be a few records from around 1961, which is likely an error in the data.

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{images/DataQuality/achillesDataDensity} 

}

\caption{The data density plot in the ACHILLES web viewer.}(\#fig:achillesDataDensity)
\end{figure}

Another example is shown in Figure \@ref(fig:achillesCodeChange), revealing a sudden change in the prevalence of a diabetes diagnosis code. This change coincides with changes in the reimbursement rules in this specific country, leading to more diagnoses but probably not a true increase in prevalence in the underlying population. 

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{images/DataQuality/achillesCodeChange} 

}

\caption{Monthly rate of diabetes coded in the ACHILLES web viewer.}(\#fig:achillesCodeChange)
\end{figure}

## Study-specific checks in practice

Next, we will execute several checks specifically for the angioedema cohort definition provided in Appendix \@ref(Angioedema). We will assume the connection details have been set as described in Section \@ref(achillesInPractice), and that the cohort definition JSON and SQL of the cohort definition have been saved in the files "cohort.json" and "cohort.sql", respectively. The JSON and SQL can be obtained from the Export tab in the ATLAS cohort definition function.


```r
library(MethodEvaluation)
json <- readChar("cohort.json", file.info("cohort.json")$size)
sql <- readChar("cohort.sql", file.info("cohort.sql")$size)
checkCohortSourceCodes(connectionDetails,
                       cdmDatabaseSchema = cdmDbSchema,
                       cohortJson = json,
                       cohortSql = sql,
                       outputFile = "output.html")
```


We can open the output file in a web browser as shown in Figure \@ref(fig:sourceCodesAngioedema). Here we see that the angioedema cohort definition has two conceot sets: "Inpatient or ER visit", and "Angioedema". In this example database the visits were found through database-specific codes "ER" and "IP", that are not in the Vocabulary. We also see that angioedema is found through one ICD-9 and two ICD-10 codes. We clearly see the point in time of the cutover between the two coding systems when we look at the sparklines for the individual codes, but for the concept set as a whole there is no discontinuity at that time.

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{images/DataQuality/sourceCodesAngioedema} 

}

\caption{Source codes used in the angioedema cohort definition.}(\#fig:sourceCodesAngioedema)
\end{figure}

Additionally, we can search for orphan source codes. Here we look for the Standard Concept "Angioedema", and look for any codes and concepts that have "Angioedema" or any of the synonyms we provide as part of their name:


```r
orphans <- findOrphanSourceCodes(connectionDetails,
                                 cdmDatabaseSchema = cdmDbSchema,
                                 conceptName = "Angioedema",
                                 conceptSynonyms = c("Angioneurotic edema",
                                                     "Giant hives",
                                                     "Giant urticaria",
                                                     "Periodic edema"))
View(orphans)
```
|code              |description                                                            |vocabularyId | overallCount|
|:-----------------|:----------------------------------------------------------------------|:------------|------------:|
|T78.3XXS          |Angioneurotic edema, sequela                                           |ICD10CM      |          508|
|10002425          |Angioedemas                                                            |MedDRA       |            0|
|148774            |Angioneurotic Edema of Larynx                                          |CIEL         |            0|
|402383003         |Idiopathic urticaria and/or angioedema                                 |SNOMED       |            0|
|232437009         |Angioneurotic edema of larynx                                          |SNOMED       |            0|
|10002472          |Angioneurotic edema, not elsewhere classified                          |MedDRA       |            0|

The only potential orphan found that is actually used in the data is "Angioneurotic edema, sequela", which is not supposed to map to angioedema. This analyis therefore did not reveal any missing codes.

## Summary

\BeginKnitrBlock{rmdsummary}<div class="rmdsummary">- Most observational healthcare data were not collected for research.

- We must therefore assess whether the data are of sufficient quality for our purposes.

- We can assess data quality for the purpose of research in general, and in the context of a specific study.

- Some aspects of data quality can be assessed automatically through large sets of predefined rules, for example those in ACHILLES Heel.

- Other tools exist to evaluate the mapping of codes relevant for a particular study.
</div>\EndKnitrBlock{rmdsummary}

## Exercises

**Prerequisites**

For these exercises we assume R, R-Studio and Java have been installed as described in Section \@ref(installR). Also required are the [SqlRender](https://ohdsi.github.io/SqlRender/), [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/), [ACHILLES](https://github.com/OHDSI/Achilles),  and [Eunomia](https://ohdsi.github.io/Eunomia/) packages, which can be installed using:


```r
install.packages(c("SqlRender", "DatabaseConnector", "devtools"))
devtools::install_github("ohdsi/Achilles")
devtools::install_github("ohdsi/Eunomia")
```

The Eunomia package provides a simulated dataset in the CDM that will run inside your local R session. The connection details can be obtained using:


```r
connectionDetails <- Eunomia::getEunomiaConnectionDetails()
```

The CDM database schema is "main".

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:exerciseRunAchilles"><strong>(\#exr:exerciseRunAchilles) </strong></span>Execute ACHILLES against the Eunomia database.
</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:exerciseViewHeel"><strong>(\#exr:exerciseViewHeel) </strong></span>Extract the ACHILLES Heel list of issues.
</div>\EndKnitrBlock{exercise}

Suggested answers can be found in Appendix \@ref(DataQualityanswers).
