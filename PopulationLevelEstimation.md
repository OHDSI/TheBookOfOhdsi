# Population-level estimation {#PopulationLevelEstimation}

*Chapter leads: Martijn Schuemie, David Madigan & Marc Suchard*

Observational healthcare data, such as administrative claims and electronic health records, offer opportunities to generate real-world evidence about the effect of treatments that can meaningfully improve the lives of patients. In this chapter we focus on population-level effect estimation, that is, the estimation of average causal effects of medical interventions on specific health outcomes of interest. In what follows, we consider two different estimation tasks:

- **Direct effect estimation**: estimating the effect of an exposure on the risk of an outcome, as compared to no exposure.
- **Comparative effect estimation**: estimation the effect of one exposure (the target exposure) on the risk of an outcome, as compared to another exposure (the comparator exposure).

In both cases, the patient-level causal effect contrasts a factual outcome, i.e., what happened to the exposed patient, with a counterfactual outcome, i.e., what would have happened had the exposure not occurred (direct) or had a different exposure occurred (comparative). Since any one patient reveals only the factual outcome (the fundamental problem of causal inference), the various effect estimation methods employ analytic devices to shed light on the counterfactual outcomes.

Use-cases for population-level effect estimation include treatment selection, safety surveillance, and comparative effectiveness. Methods can test specific hypotheses one-at-a-time (e.g. ‘signal evaluation’) or explore multiple-hypotheses-at-once (e.g. ‘signal detection’). In all cases, the objective remains the same: to produce a high-quality estimate of the causal effect. 

## Study designs

Several different study designs can be used to estimate treatment effects. The main difference between these is how they construct the (unobserved) counterfactual. Below is a brief discussion of the most commonly used designs, all of which are implemented as R packages in the [OHDSI Methods Library](https://ohdsi.github.io/MethodsLibrary/).

### Cohort method

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/cohortMethod.png" alt="The new-user cohort design. Subjects observed to initiate the target treatment are compared to those initiating the comparator treatment. To adjust for differences between the two treatment groups several adjustment strategies can be used, such as stratification, matching, or weighting by the propensity score, or by adding baseline characateristcs to the outcome model. The chararacteristics included in the propensity model or outcome model are captured prior to treatment initiation." width="90%" />
<p class="caption">(\#fig:cohortMethod)The new-user cohort design. Subjects observed to initiate the target treatment are compared to those initiating the comparator treatment. To adjust for differences between the two treatment groups several adjustment strategies can be used, such as stratification, matching, or weighting by the propensity score, or by adding baseline characateristcs to the outcome model. The chararacteristics included in the propensity model or outcome model are captured prior to treatment initiation.</p>
</div>

The new-user cohort method attempts to emulate a randomized clinical trial [@hernan_2016]. Subjects that are observed to initiate one treatment (the target) are compared to subjects initiating another treatment (the comparator) and are followed for a specific amount of time following treatment initiation, for example the time they stay on the treatment. We can specify the questions we wish to answer in a cohort study by making the five choices highlighted in Table \@ref(tab:cmChoices).

Table: (\#tab:cmChoices) Main design choices in a comparative cohort design.

| Choice            | Description                                              |
|:----------------- |:-------------------------------------------------------- |
| Target cohort     | A cohort representing the target treatment               |
| Comparator cohort | A cohort representing the comparator treatment           |
| Outcome cohort    | A cohort representing the outcome of interest            |
| Time-at-risk      | At what time (often relative to the target and comparator cohort start and end dates) do we consider the risk of the outcome?  |
| Model             | The model used to estimate the effect while adjusting for differences between the target and comparator  |

The choice of model specifies, amongst others, the type of model. For example, we could use a logistic regression, which evaluates whether or not the outcome has occurred, and produces an odds ratio. A logistic regression assumes the time-at-risk is of the same length for both target and comparator, or irrelevant. Alternatively, we could choose a Poisson regression which estimates the incidence rate ratio, assuming a constant incidence rate. Often a Cox regression is used which considers time to first outcome to estimate the hazard ratio, assuming proportional hazards.

One crucial difference with a randomized trial is that there is no randomization, and therefore there might be systematic differences between the target and comparator populations. Without adjusting for these differences, estimates are likely to be confounded. A popular mechanism for adjusting for confounding is the use of Propensity Scores (PS). The PS is the probability of a subject receiving one treatment instead of the other, conditional on baseline characteristics. [@rosenbaum_1983] First, a model – typically a logistic regression – is fitted using the observed treatment assignments (target or comparator), then the model is used to produce the PS for each subject. In the past, PS were computed based on manually selected characteristics, and although the CohortMethod package can support such practices, we prefer the use of large-scale regularized regression using many generic characteristics. [@tian_2018] These characteristics include demographics, as well as all diagnoses, drug exposures, measurement, and medical procedures observed prior to treatment initiation, and exclude the target and comparator treatment. A model typically involves 10,000 to 100,000 unique characteristics. The PS can be used in several ways, for example by stratifying the study population based on the PS, by matching target subjects to comparator subjects with similar PS, or by weighting subjects using Inverse Probability of Treatment Weighting (IPTW) derived from the PS. 
Another strategy for adjusting for differences between the two groups is to include additional variables in the outcome model. One major limitation of this approach is that whereas there often is a wealth of data to fit a propensity model, with thousands of people in both treatment groups, the outcomes we study tend to be somewhat rare, causing a paucity of data when trying to fit elaborate models with the outcome as dependent variable. One approach is to use both a PS and add the same variables that were used in the propensity model in the outcome model, thus adjusting for the same variables twice, but in different ways.
The new-user cohort method inherently is a method for comparative effect estimation, comparing one treatment to another. It is difficult to use this method to compare a treatment against no treatment, since it is hard to define a group of unexposed people that is comparable with the exposed group. If one wants to use this design for direct effect estimation, the preferred way is to select a comparator treatment for the same indication as the exposure of interest, where the comparator treatment is believed to have no effect on the outcome. Unfortunately, such a comparator might not always be available. 

### Self-controlled cohort

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/selfControlledCohort.png" alt="The self-controlled cohort design. The rate of outcomes during exposure to the target is compared to the rate of outcomes in the time pre-exposure." width="90%" />
<p class="caption">(\#fig:scc)The self-controlled cohort design. The rate of outcomes during exposure to the target is compared to the rate of outcomes in the time pre-exposure.</p>
</div>

The self-controlled cohort (SCC) design [@ryan_2013] compares the rate of outcomes during exposure to the rate of outcomes in the time just prior to the exposure. The  four choices shown in Table \@ref(tab:sccChoices) define a self-controlled cohort question.

Table: (\#tab:sccChoices) Main design choices in a self-controlled cohort design.

| Choice            | Description                                              |
|:----------------- |:-------------------------------------------------------- |
| Target cohort     | A cohort representing the treatment                      |
| Outcome cohort    | A cohort representing the outcome of interest            |
| Time-at-risk      | At what time (often relative to the target cohort start and end dates) do we consider the risk of the outcome?  |
| Control time      | The time period used as the control time                 |

Because the same subject that make up the exposed group are also used as the control group, no adjustment for between-person differences need to be made. However, the method is vulnerable to other differences, such as differences between different time periods. 

### Case-control

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/caseControl.png" alt="The case-control design. Subjects with the outcome (‘cases’) are compared to subjects without the outcome (‘controls’) in terms of their exposure status. Often, cases and controls are matched on various characteristics such as age and sex." width="90%" />
<p class="caption">(\#fig:caseControl)The case-control design. Subjects with the outcome (‘cases’) are compared to subjects without the outcome (‘controls’) in terms of their exposure status. Often, cases and controls are matched on various characteristics such as age and sex.</p>
</div>

Case-control [@vandenbroucke_2012] studies consider the question “are persons with a specific disease outcome exposed more frequently to a specific agent than those without the disease?” Thus, the central idea is to compare “cases”, i.e., subjects that experience the outcome of interest with “controls”, i.e., subjects that did not experience the outcome of interest. The choices in Table \@ref(tab:ccChoices) define a case-control question.

Table: (\#tab:ccChoices) Main design choices in a case-control design.

| Choice            | Description                                               |
|:----------------- |:--------------------------------------------------------- |
| Outcome cohort    | A cohort representing the cases (the outcome of interest) |
| Control selection | A strategy for selecting controls and their index date    |
| Target cohort     | A cohort representing the treatment                       |
| [Nesting cohort]  | Optionally, a cohort defining the subpopulation from which cases and controls are drawn  |
| Time-at-risk      | At what time (often relative to the index date) do we consider exposure status?  |

Often, one matches controls to cases based on characteristics such as age and sex to make them more comparable. Another widespread practice is to nest the analysis within a specific subgroup of people, for example people that have all been diagnosed with one of the indications of the exposure of interest. 

### Case-crossover

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/caseCrossover.png" alt="The case-crossover design. The time around the outcome is compared to a control date set at a predefined interval prior to the outcome date." width="90%" />
<p class="caption">(\#fig:caseCrossover)The case-crossover design. The time around the outcome is compared to a control date set at a predefined interval prior to the outcome date.</p>
</div>

The case-crossover [@maclure_1991] design evaluates whether the rate of exposure is different at the time of the outcome than at some predefined number of days prior to the outcome. It is trying to determine whether there is something special about the day the outcome occurred. Table \@ref(tab:ccrChoices) shows the choices that define a case-crosover question:

Table: (\#tab:ccrChoices) Main design choices in a case-crossover design.

| Choice            | Description                                              |
|:----------------- |:-------------------------------------------------------- |
| Outcome cohort    | A cohort representing the cases (the outcome of interest)  |
| Target cohort     | A cohort representing the treatment  |
| Time-at-risk      | At what time (often relative to the index date) do we consider exposure status?  |
| Control time      | The time period used as the control time                 |

Since cases serve as their own control, it is a self-controlled design, and should therefore be robust to confounding due to between-person differences. One concern is that, because the outcome date is always later than the control date, the method will be positively biased if the overall frequency of exposure increases over time (or negatively biased if there is a decrease). To address this, the case-time-control design [@suissa_1995] was developed, which adds matched controls to the case-crossover design to adjust for exposure trends.

### Self-controlled case series

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/selfControlledCaseSeries.png" alt="The Self-Controlled Case Series design. The rate of outcomes during exposure is compared to the rate of outcomes when not exposed." width="90%" />
<p class="caption">(\#fig:selfControlledCaseSeries)The Self-Controlled Case Series design. The rate of outcomes during exposure is compared to the rate of outcomes when not exposed.</p>
</div>

The Self-Controlled Case Series (SCCS) design [@farrington_1995,whitaker_2006] compares the rate of outcomes during exposure to the rate of outcomes during all unexposed time, both before, between, and after exposures. It is a Poisson regression that is conditioned on the person. Thus, it seeks to answer the question: “Given that a patient has the outcome, is the outcome more likely during exposed time compared to non-exposed time?”. The choices in Table \@ref(tab:sccsChoices) define an SCCS question.

Table: (\#tab:sccsChoices) Main design choices in a self-controlled case series design.

| Choice            | Description                                              |
|:----------------- |:-------------------------------------------------------- |
| Target cohort     | A cohort representing the treatment                      |
| Outcome cohort    | A cohort representing the outcome of interest            |
| Time-at-risk      | At what time (often relative to the target cohort start and end dates) do we consider the risk of the outcome?  |
| Model             | The model to estimate the effect, including any adjustments for time-varying confounders |

Like other self-controlled designs, the SCCS is robust to confounding due to between-person differences, but vulnerable to confounding due to time-varying effects. Several adjustments are possible to attempt to account for these, for example by including age and season. A special variant of the SCCS includes not just the exposure of interest, but all other exposures to drugs recorded in the database [@simpson_2013], potentially adding thousands of additional variables to the model. L1-regularization using cross-validation to select the regularization hyperparameter is applied to the coefficients of all exposures except the exposure of interest.

One important assumption underlying the SCCS is that the observation period end is independent of the date of the outcome. Because for some outcomes, especially ones that can be fatal such as stroke, this assumption can be violated an extension to the SCCS has been developed that corrects for any such dependency. [@farrington_2011]


## Designing a hypertension study



### Problem definition

ACE inhibitors are widely used in patients with hypertension or ischemic heart disease, especially those with other comorbidities such as congestive heart failure, diabetes mellitus, or chronic kidney disease [@zaman_2002]. Angioedema, a serious and sometimes life-threatening adverse event that usually manifests as swelling of the lips, tongue, mouth, larynx, pharynx, or periorbital region, has been linked to the use of these medications [@sabroe_1997]. However, limited information is available about the absolute and relative risks for angioedema associated with the use of these medications. Existing evidence is primarily based on investigations of specific cohorts (eg, predominantly male veterans or Medicaid beneficiaries), whose findings may not be generalizable to other populations, or based on investigations with few events, which provide unstable risk estimates [@powers_2012]. Several observational studies compare ACE inhibitors to beta-blockers for the risk of angioedema [@magid_2010; @toh_2012], but beta-blockers are no longer recommend as first-line treatment of hypertension [@whelton_2018]. A viable alternative treatment could be thiazides or thiazide-like diuretics, which could be just as effective in managing hypertension and its associated risks such as acute myocardial infarction.

We will apply our population-level estimation framework to observational healthcare data to address the following comparative estimation question:

> What is the risk of angioedema and acute myocaridal infarction in new users of ACE inhibitors compared to new users of thiazide and thiazide-like diuretics?

### Target and comparator

Focus on first-line mono-therapy

### Outcome

Angioedema and AMI

### Time-at-risk

### Model

### Study summary

Table: (\#tab:aceChoices) Main design choices four our comparative cohort study.

| Choice            | Value                                                    |
|:----------------- |:-------------------------------------------------------- |
| Target cohort     |                                                          |
| Comparator cohort |                                                          |
| Outcome cohort    |                                                          |
| Time-at-risk      |                                                          |
| Model             |                                                          |


## Implementation the study using ATLAS

SPECIFICATION

Comparative Cohort Settings


### Specifying the comparisons

> Comparative Cohort Settings 

> +Add Comparison   			

Click on ![](images/PopulationLevelEstimation/image20-half.png). The window in Figure \@ref(fig:comparisons) should appear. Then click on ![](images/PopulationLevelEstimation/image2-half.png) to add cohorts to target, comparator and outcome cohort. 

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/image5.png" alt="The comparison window." width="100%" />
<p class="caption">(\#fig:comparisons)The comparison window.</p>
</div>

> Comparison: Add or update the target, comparator, outcome(s) cohorts and negative control outcomes

When specifying T, C, and O, note that you can select as many T, C, and O cohorts as you like--this means that you can do many comparisons simultaneously. Additional outcomes will appear in the table below the ![](images/PopulationLevelEstimation/image11.png) button. These will be listed in a table with ID and Name columns displayed. Many entries can be displayed in this table.

> Choose your negative control outcomes 

Pick concept sets you want to include by clicking on ![](images/PopulationLevelEstimation/image2-half.png). Search for the negative control concept sets you previously built as discused in Chapter \@ref(MethodValidity).

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/image3.png" alt="Negative control outcomes selection window." width="100%" />
<p class="caption">(\#fig:negControls)Negative control outcomes selection window.</p>
</div>

Note: The negative controls concept IDs included in the concept set do not include their descendants. Figure \@ref(fig:ncConceptSet) shows the negative control concept set used in this example.

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/image14.png" alt="Negative Control concept set." width="100%" />
<p class="caption">(\#fig:ncConceptSet)Negative Control concept set.</p>
</div>

> What concepts do you want to include in baseline covariates in the propensity score model? (Leave blank if you want to include everything)

Here, you can specify exactly which covariates you would like to include in your propensity score model. When specifying covariates *here*, all other covariates (aside from those you specified) are left out. We usually want to include all baseline covariates, letting the LASSO regression build a model that balances all covariates. You might want to specify particular covariates when you are replicating an existing study that manually picked a small number of covariates. These inclusions can be specified in this comparison section or in the analysis section. The option in the analysis section of whether or not to include descendants will apply also here in the comparison section.
 
> What concepts do you want to exclude from baseline covariates in the propensity score model? (Leave blank if you want to include everything)

Rather than specifying which covariates to include, we can instead specify covariates to *exclude*. When we submit a list of concept IDs in this field, we use every covariate except for those that we submitted. We will want to exclude covariates that are very highly correlated with the exposures or else the propensity model will separate the two groups nearly perfectly, making a comparison impossible. These exclusions can be specified in this comparison section or in the analysis section. Exclusions may be comparison specific (exposure drugs), so it often makes sense to specify them here. The option in the analysis section of whether or not to include descendants will apply also here in the comparison section.

In this example, the covariates we want to exclude are ACE inhibitors and thiazides or thiazide diuretic. Figure \@ref(fig:covsToExclude) shows we select a concept set that includes all these concepts. 

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/image8.png" alt="Covariate selection window with exclusion concepts." width="100%" />
<p class="caption">(\#fig:covsToExclude)Covariate selection window with exclusion concepts.</p>
</div>

Often we want to include or exclude concepts **and their descendants**. We could specify the concept set to include descendant concepts. However, for various reasons it might be more efficient to not include descendant in the concept set, but rather automatically add them by setting the 'Should descendant concepts be added' option to *yes* in the Covariate Settings section of the Analysis settings that will be discussed later.

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/image14.png" alt="The concept set defining the concepts to exclude. Note that no descendantsa have been included. We will specify to include these at analysis time in the Analysis settings." width="100%" />
<p class="caption">(\#fig:covsConceptSet)The concept set defining the concepts to exclude. Note that no descendantsa have been included. We will specify to include these at analysis time in the Analysis settings.</p>
</div>

## Implementation the study using R

Now we have completely designed our study we have to implement the study. This will be done using the [CohortMethod](https://ohdsi.github.io/CohortMethod/) package to execute our study. It extracts the necessary data from a database in the CDM and can use a large set of covariates for the propensity model. 

### Cohort instantiation

We first need to instantiate the target and outcome cohorts. Instantiating cohorts is described in Chapter \@ref(Cohorts). The Appendix provides the full definitions of the target (Appendix \@ref(AceInhibitors)) and outcome (Appendix \@ref(Angioedema)) cohorts. In this example we will assume the ACE inhibitors cohort has ID 1, and the angioedema cohort has ID 2.

### Data extraction

We first need to tell R how to connect to the server. [`CohortMethod`](https://ohdsi.github.io/CohortMethod/) uses the [`DatabaseConnector`](https://ohdsi.github.io/DatabaseConnector/) package, which provides a function called `createConnectionDetails`. Type `?createConnectionDetails` for the specific settings required for the various database management systems (DBMS). For example, one might connect to a PostgreSQL database using this code:


```r
library(PatientLevelPrediction)
connDetails <- createConnectionDetails(dbms = "postgresql",
                                       server = "localhost/ohdsi",
                                       user = "joe",
                                       password = "supersecret")

cdmDbSchema <- "my_cdm_data"
cohortsDbSchema <- "scratch"
cohortsDbTable <- "my_cohorts"
cdmVersion <- "5"
```

The last four lines define the `cdmDbSchema`, `cohortsDbSchema`, and `cohortsDbTable` variables, as well as the CDM version. We will use these later to tell R where the data in CDM format live, where the cohorts of interest have been created, and what version CDM is used. Note that for Microsoft SQL Server, database schemas need to specify both the database and the schema, so for example `cdmDbSchema <- "my_cdm_data.dbo"`.

### Specifying the analyses

## Excercises





