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

Similarly, we often receive the data in a specific form, so we have little influence over part of step 2. However, in OHDSI we convert all our observational data to the Common Data Model (CDM), and we do have ownership over this process. Some have expressed concerns that this specific step can regrade DQ. But because we control this process, we can build stringent safeguards to preserve DQ as discussed later in Section x. Several investigations [@defalco_2013;@makadia_2014;@matcho_2014;@voss_2015;@voss_2015b;@hripcsak_2018] have shown that when properly executed, little to no error is introduced when converting to the CDM. In fact, having a well-documented data model that is shared by a large community facilitates data storage in unambiguous and clear manner.

Step 3 (data analysis) also falls under our control. In OHDSI, we tend to not use the term DQ for the quality issues during this step, but rather the tersm *clinical validity*, *software validity* and *method validity*, which are discussed at length in Chapters \@ref(ClinicalValidity), \@ref(SoftwareValidity), and \@ref(MethodValidity), respectively.

## Data quality in general

We can ask the question whether our data is fit for the generic purpose of observational research. @kahn_harmonized_2016 define such generic DQ as consisting of three components: 

1. **Conformance**: Do data values adhere to do specified standard and formats? Three subtypes are identified:
   - **Value**: Are recorded data elements in agreement with the specified formats? For example, are all provider medical specialties valid specialties? 
   - **Relational**: Is the recorded data in agreement with specified relational constraints? For example, is the provider_id in a DRUG_EXPOSURE data present in the PROVIDER table?
   - **Computation**: Do computations on the data yield the intended results? For example, is BMI computed from height and weight equal to the verbatim BMI recorded in the data?
2. **Completeness**: Are data values present? For example, do all persons have a known gender?
3. **Plausibility**: Are data values believable? Three subtypes are defined:
    - **Uniqueness**: For example, does each person_id occur only once in the PERSON table?
    - **Atemporal**: Do values, distributions, or densities agree with expected values? For example, is the prevalence of diabetes in line with the known prevalence?
    - **Temporal**: Are changes in values in line with expectations? For example, are immunization sequences in line with recommendations?
    
    \index{data quality!conformance} \index{data quality!completeness} \index{data quality!plausibility}

Each component can be evaluated in two ways:

* **Verification** focuses on model and data constraints and does not rely on external reference. 
* **Validation** focuses on data expectations that are derived from comparison to a relative gold standard and uses external knowledge. 

\index{data quality!verification} \index{data quality!validation}

### Data quality checks

Kahn introduces the term *data quality check* (sometimes refered to as data quality rule) that tests whether data conform to a given requirement (e.g., implausible age of 141 of a patient, potentially due to incorrect birth year or missing death event). We can implement such checks in sofware, creating automated DQ tools. One such tool is [ACHILLES](https://github.com/OHDSI/Achilles) (Automated Characterization of Health Information at Large-scale Longitudinal Evidence Systems) [@huser_methods_2018]. ACHILLES is a software tool that not only executes a wide array of DQ checks, it also provides characterization and visualization of a database conforming to the CDM. As such, it can be used to evaluate DQ in a network of databases [@huser_multisite_2016]. ACHILLES is available as a stand-alone tool, and is also integrated into ATLAS as the "Data Sources" function. \index{data quality!data quality check} \index{ACHILLES}

ACHILLES pre-computes over 170 data characterization analyses, with each analysis having an analysis ID and a short description of the analysis, for example, “715: Distribution of days_supply by drug_concept_id” or “506: Distribution of age at death by gender”. The results of these analyses are stored in a database, and can be accessed by a web viewer or by ATLAS. Based on these analyses, a battery of DQ tests is performed know as "ACHILLES Heel". These checks are categorized as "*error*", "*warning*", or "*notification*". Errors are DQ issues that should not be present, constituting violations of some fundamental principles that must be resolved before the data can be used for research. Warnings indicate something is likely wrong although a closer investigation is needed to make a definite dermination. Notifications hint add odd characteristics that should be explored, but fall within the range of what is expected. Table \@ref(tab:heelExamples) show some example rules. \index{ACHILLES!Heel}

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

The ETL (Extract-Transform-Load) process by which data is converted to the CDM is often quite complex, and with that complexity comes the danger of making mistakes that may go unnoticed. 

Figure \@ref(fig:testFramework) shows

<div class="figure" style="text-align: center">
<img src="images/DataQuality/testFramework.png" alt="Unit testing an ETL (Extract-Transform-Load) process." width="90%" />
<p class="caption">(\#fig:testFramework)Unit testing an ETL (Extract-Transform-Load) process.</p>
</div>

## Study-specific checks

The chapter has so far focused on general DQ checks. Such checks are executed regardless of the single research question context. The assumption is that a researcher would formulate additional DQ checks that are required for a specific research question.

We use case studies to demostrate study-specific checks.

### Outcomes 

For an international analysis, part of OHDSI study diagnostics (for a give dataset) may involve checking whether coding practices (that are country specific) affect a cohort definition. A stringent cohort definition may lead to zero cohort size in one (or multiple dataesets). 


### Laboratory data


A diabetes study may utilize HbA1c measurement. A 2018 OHDSI study (https://www.ncbi.nlm.nih.gov/pubmed/30646124) defined a cohort 'HbA1c8Moderate' (see https://github.com/rohit43/DiabetesTxPath/blob/master/inst/settings/CohortsToCreate.csv)



## ETL unit testing

Extract Transform Load (ETL) process that transforms data from source (in EHR system or claims sys) to target (OMOP CDM) can contain errors. Unit testing of ETL code allows for preventing coding errors in ETL to cause data errors.

### Unit testing framwork in Rabbit-in-a-Hat

OHDSI tool Rabbit-in-a-Hat includes an ETL unit testing framwork. This framework defines an a set of function for each table in the source schema and a set of functions for each table in target OMOP CDM schema. Detailed description is available at https://www.ohdsi.org/web/wiki/doku.php?id=documentation:software:whiterabbit:test_framework. 

