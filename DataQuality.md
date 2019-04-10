# (PART) Evidence Quality {-} 

# Data Quality {#DataQuality}

## Introduction

Kahn et al. define data quality as consisting of three components: (1) conformance (do data values adhere to do specified standard and formats?; subtypes: value, relational and computational conformance);  (2) completeness (are data values present?); and (3) plausibility (are data values believable?; subtypes uniqueness, atemporal; temporal) [@kahn_harmonized_2016]

| Term         | Subtype                   | Definition |
|--------------|---------------------------|------------|
| Conformance  | Value                     |            |
|              | Relational                |            |
|              | Computational             |            |
| Completeness | n/a (no subtypes defined) |            |
| Plausibility | Uniqueness                |            |
|              | Atemporal                 |            |
|              | Temporal                  |            |

Kahn introduces the term *data quality check* (sometimes refered to as data quality rule) that tests whether data conform to a given requirement (e.g., implausible age of 141 of a patient (due to incorrect birth year or missing death event)). In support of checks, he also defines *data quality measure* (sometimes refered to as pre-computed analysis) as data analysis that  supports evaluation of a check. For example, distribution of days of supply by drug concept. 

Two types of DQ checks can be distinguished[@weiskopf_methods_2013]

* general checks
* study-specific checks

From the point of researcher analyzing the data, the desired situation is that data is free from erros that could have been prevented. *ETL data errors* are errors introduced during extract-tranform-load proces. A special type of ETL data error is *mapping error* that results from incorrect mapping of the data from the source terminology (e.g., Korean national drug terminology) into the target data model's standard terminology (e.g., RxNorm and RxNorm Extension).  A *source data error* is an error that is already present in the source data due to various cuases (e.g., human typo during data entry).

Data quality can also be seen as a component in a larger effort refered to as *evidence quality* or *evidence validation*. Data quality would fall in this framework under *data validation*.

## Achilles Heel tool

Since 2014, a component of the OHDSI Achilles tool called Heel was used to check data quality.[@huser_methods_2018]

### Precomputed Analyses

In support of data characterization, Achilles tool pre-computes number of data analyses. Each pre-computed analysis has an analysis ID and a short description of the analysis. For example, “715: Distribution of days_supply by drug_concept_id” or “506: Distribution of age at death by gender”. List of all pre-computed analyses (for Achilles version 1.6.3) as available at https://github.com/OHDSI/Achilles/blob/v1.6.3/inst/csv/achilles/achilles_analysis_details.csv 

Achilles has more than 170 pre-computed analysis that support not only data quality checks but also general data characterization (outside data quality context) such as data density visualizations. The pre-computations are largely guided by the CDM relational database schema and analyze most terminology-based data columns, such as condition_concept_id or place_of_service_concept_id. Pre-computations results are stored in table ACHILLES_RESULTS and ACHILLES_RESULTS_DIST.

### Example DQ rule



### Overview of existing DQ Heel checks

Achilles developers maintain a list of all DQ checks in an overview file. For version 1.6.3, this overview is available here https://github.com/OHDSI/Achilles/blob/v1.6.3/inst/csv/heel/heel_rules_all.csv Each DQ check has a rule_id.

Checks are classified into CDM conformance checks and DQ checks.


## Study-specific checks

The chapter has so far focused on general DQ checks. For example, if a study used HbA1c measurement, additional data checking is warranted.




