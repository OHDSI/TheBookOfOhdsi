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

The choice of model specifies, among others, the type of model. For example, we could use a logistic regression, which evaluates whether or not the outcome has occurred, and produces an odds ratio. A logistic regression assumes the time-at-risk is of the same length for both target and comparator, or irrelevant. Alternatively, we could choose a Poisson regression which estimates the incidence rate ratio, assuming a constant incidence rate. Often a Cox regression is used which considers time to first outcome to estimate the hazard ratio, assuming proportional hazards.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">The new-user cohort method inherently is a method for comparative effect estimation, comparing one treatment to another. It is difficult to use this method to compare a treatment against no treatment, since it is hard to define a group of unexposed people that is comparable with the exposed group. If one wants to use this design for direct effect estimation, the preferred way is to select a comparator treatment for the same indication as the exposure of interest, where the comparator treatment is believed to have no effect on the outcome. Unfortunately, such a comparator might not always be available. </div>\EndKnitrBlock{rmdimportant}

A key concern is that the patients receiving the target treatment may systematically differ from those receiving the comparator treatment. For example, suppose the target cohort is, on average, 60 years old, whereas the comparator cohort is on average 40 years old. Comparing target to comparator with respect to any age-related health outcome (e.g.  stroke) might then show substantial differences. An uninformed investigator might reach the conclusion there is a causal association between the target treatment and stroke as compared to the comparator. More prosaically or commonplace, the investigator might conclude that there exist target patients that experienced stroke that would not have done so had they received the comparator. This conclusion could well be entirely incorrect! Maybe those target patients disproportionately experienced stroke simply because they are older; maybe the target patients that experienced stroke might well have done so even if they had received the comparator. In this context, age is a “confounder”.

**Propensity scores**

In a randomized trial, a (virtual) coin toss assigns patients to their respective groups. Thus, by design, the probability that a patient receives the target treatment as against the comparator treatment does not relate in any way to patient characteristics such as age. The coin has no knowledge of the patient, and, what’s more, we know with certainty the exact probability that a patient receives the target exposure. As a consequence, and with increasing confidence as the number of patients in the trial increases, the two groups of patients essentially *cannot* differ systematically with respect to *any* patient characteristic. This guaranteed balance holds true for characteristics that the trial measured (such as age) as well as characteristics that the trial failed to measure.

For a given patient, the *propensity score* is the probability that that patient received the target treatment as against the comparator. [@rosenbaum_1983] In a balanced two-arm randomized trial, the propensity score is 0.5 for every patient. In a propensity score-matched observational study, we estimate the probability that each patient received the target treatment. This a straightforward predictive modeling application; we use logistic regression but many choices exist. Unlike in a standard randomized trial, different patients will have different probabilities of receiving the target treatment. The PS can be used in several ways, for example by matching target subjects to comparator subjects with similar PS, by stratifying the study population based on the PS, or by weighting subjects using Inverse Probability of Treatment Weighting (IPTW) derived from the PS. 

For example, suppose we use PS matching, and that Jan has a priori probability of 0.4 of receiving the target treatment and in fact receives the target treatment. If we can find a patient (named Jun) that also had an a priori probability of 0.4 of receiving the target treatment but in fact received the comparator, the comparison of Jan and Jun’s outcomes is like a mini-randomized trial, at least with respect to measured confounders. This comparison will yield an estimate of the Jan-Jun causal contrast that is as good as the one randomization would have produced. Estimation then proceeds as follows: for every patient that received the target, find one or more matched patients that received the comparator but had the same a priori probability of receiving the target. Compare the outcome for the target patient with the outcomes for the comparator patients within each of these matched groups. 

Propensity scoring controls for measured confounders. In fact, if treatment assignment is “strongly ignorable” given measured characteristics, propensity scoring will yield an unbiased estimate of the causal effect. “Strongly ignorable” essentially means that there are no unmeasured confounders. Unfortunately this is not a testable assumption. See Chapter \@ref(MethodValidity) on Method Validity for further discussion of this issue.  

**Variable selection**

In the past, PS were computed based on manually selected characteristics, and although the CohortMethod package can support such practices, we prefer the use of large-scale regularized regression using many generic characteristics. [@tian_2018] These characteristics include demographics, as well as all diagnoses, drug exposures, measurement, and medical procedures observed prior to and on the day of treatment initiation. A model typically involves 10,000 to 100,000 unique characteristics, which we fit using large-scale regularized regression [@suchard_2013] implemented in the [Cyclops](https://ohdsi.github.io/Cyclops/) package. In essence, we let the data appropriately weight the characteristics.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">We typically include the day of treatment initiation in the covariate capture window because many relevant data points such as the diagnosis leading to the treatment are recorded on that date. This does require us to explicitly exclude the target and comparator treatment from the set of covariates to prevent circular reasoning. </div>\EndKnitrBlock{rmdimportant}

**Caliper**

Since propensity scores fall on a continuum from 0 to 1, exact matching is rarely possible. Instead, the matching process finds patients that match the propensity score of a target patient(s) to within some tolerance known as a “caliper.” Following @austin_2011, we use a default of caliper of 0.2 standard deviations on the logit scale.

**Overlap: preference scores**

The propensity method requires that matching patients exist! As such, a key diagnostic shows the distribution of the propensity scores in the two groups. To facilitate interpretation, OHDSI tools plot a transformation of the propensity score called the “preference score” [@walker_2013]. The preference score adjusts for the market share of the two treatments. For example, if 10% of patients receive the target treatment (and 90% receive the comparator treatment), then patients with a preference score of 0.5 have a 10% probability of receiving the target treatment. Mathematically, the preference score is

$$\ln\left(\frac{F}{1-F}\right)=\ln\left(\frac{S}{1-S}\right)-\ln\left(\frac{P}{1-P}\right)$$

Where $F$ is the preference score, $S$ is the propensity score, and $P$ is the proportion of patients receiving the target treatment.

@walker_2013 discuss the concept of “empirical equipoise”. They accept drug pairs as emerging from empirical equipoise if at least half of the dispensings of each of the drugs are to patients with a preference score of between 0.3 and 0.7.

**Balance**

Good practice always checks that the propensity matching succeeded in creating balanced groups of patients. Figure Z shows the standard ATLAS output for checking balance. For each patient characteristic, this plots the A-B difference after matching against the A-B difference before matching. ATLAS measures the standardized difference between means. Some guidelines recommend an after-matching standardized difference upper bound of 0.1 [@rubin_2001].

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

The case-crossover [@maclure_1991] design evaluates whether the rate of exposure is different at the time of the outcome than at some predefined number of days prior to the outcome. It is trying to determine whether there is something special about the day the outcome occurred. Table \@ref(tab:ccrChoices) shows the choices that define a case-crossover question:

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

ACE inhibitors (ACEi) are widely used in patients with hypertension or ischemic heart disease, especially those with other comorbidities such as congestive heart failure, diabetes mellitus, or chronic kidney disease [@zaman_2002]. Angioedema, a serious and sometimes life-threatening adverse event that usually manifests as swelling of the lips, tongue, mouth, larynx, pharynx, or periorbital region, has been linked to the use of these medications [@sabroe_1997]. However, limited information is available about the absolute and relative risks for angioedema associated with the use of these medications. Existing evidence is primarily based on investigations of specific cohorts (eg, predominantly male veterans or Medicaid beneficiaries), whose findings may not be generalizable to other populations, or based on investigations with few events, which provide unstable risk estimates [@powers_2012]. Several observational studies compare ACEi to beta-blockers for the risk of angioedema [@magid_2010; @toh_2012], but beta-blockers are no longer recommend as first-line treatment of hypertension [@whelton_2018]. A viable alternative treatment could be thiazides or thiazide-like diuretics (THZ), which could be just as effective in managing hypertension and its associated risks such as acute myocardial infarction (AMI).

We will apply our population-level estimation framework to observational healthcare data to address the following comparative estimation question:

> What is the risk of angioedema and acute myocaridal infarction in new users of ACE inhibitors compared to new users of thiazide and thiazide-like diuretics?

### Target and comparator

We consider patients new-users if their first observed treatment for hypertension was monotherapy with any active ingredient in either the ACEi or THZ class. We define mono therapy as not starting on any other hypertension drug in the seven days following treatment initiation. We require patients to have at least one year of prior database observation before first exposure and a recorded hypertension diagnosis at or in the one-year preceding treatment initiation. 

### Outcome

We define angioedema as any occurrence of an angioedema diagnose code during an inpatient or ER visit, and require there to be no angioedema diagnosis recorded in the seven days prior. We define AMI as any occurrence of an AMI diagnose code during an inpatient or ER visit, and require there to be no AMI diagnosis record in the 180 days prior.

### Time-at-risk

We define time-at-risk to start on the day after treatment initiation, and stop when exposure stops, allowing for a 30-day gap between subsequent prescriptions.

### Model

We  fit a PS model using the default set of covariates, which includes demographics, conditions, drugs, procedures, measurements, observations, and several comorbidity scores. We exclude ACEi and THZ from the covariates. We perform variable-ratio matching [@rassen_2012] and condition the Cox regression on the matched sets.

### Study summary

Table: (\#tab:aceChoices) Main design choices four our comparative cohort study.

| Choice            | Value                                                    |
|:----------------- |:-------------------------------------------------------- |
| Target cohort     | New users of ACE inhibitors as first-line monotherapy for hypertension. |
| Comparator cohort | New users of thiazides or thiazide-like diuretics as first-line monotherapy for hypertension. |
| Outcome cohort    | Angioedema or acute myocardial infarction. |
| Time-at-risk      | Starting the day after treatment initiation, stopping when exposure stops. |
| Model             | Cox proportional hazards model using variable ratio matching. |


## Implementation the study using ATLAS

Here we demonstrate how this study can be implemented using the Estimation tool in ATLAS. Click on ![](images/PopulationLevelEstimation/estimation.png) in the left bar of ATLAS, and create a new estimation study. Make sure to give the study an easy-to-recognize name. you can save the study design at any time by clicking the ![](images/PopulationLevelEstimation/save.png) button.

In the Estimation design tool, there are three sections: Comparisons, Analysis Settings, and Evaluation Settings. We can specify multiple comparisons and multiple analysis settings, and ATLAS will execute all combinations of these as separate analyses. Here we discuss each section:

### Comparative cohort settings {#ComparisonSettings}

A study can have one or more comparisons. Click on 'Add Comparison', which will open a new dialog. Click on ![](images/PopulationLevelEstimation/open.png) to the select the target and  comparator cohorts. By clicking on "Add Outcome" we can add our two outcome cohorts. We assume the cohorts have already been created as described in Chapter \@ref(Cohorts). When done, the dialog should look like Figure \@ref(fig:comparisons).

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/comparisons.png" alt="The comparison dialog" width="100%" />
<p class="caption">(\#fig:comparisons)The comparison dialog</p>
</div>

Note that we can select multiple outcomes for a target-comparator pair. Each outcome will be treated independently, and will basically result in separate analysis.

**Negative control outcomes**

We should also include a set of negative control outcomes. These are outcomes that are not believed to be caused by either the target or the comparator. Negative controls are discussed in more detail in Chapter \@ref(MethodValidity). Here we assume a concept set has already been created and can simply be selected. The negative control concept set should contain a concept per negative control, and not include descendants. Figure \@ref(fig:ncConceptSet) shows the negative control concept set used for this study.

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/ncConceptSet.png" alt="Negative Control concept set." width="100%" />
<p class="caption">(\#fig:ncConceptSet)Negative Control concept set.</p>
</div>

**Concepts to include**

When selecting concept to include, you can specify which covariates you would like to include in your propensity score model. When specifying covariates here, all other covariates (aside from those you specified) are left out. We usually want to include all baseline covariates, letting the regularized regression build a model that balances all covariates. You might want to specify particular covariates when you are replicating an existing study that manually picked a small number of covariates. These inclusions can be specified in this comparison section or in the analysis section. The option in the analysis section of whether or not to include descendants will apply also here in the comparison section.

**Concepts to exclude**

Rather than specifying which concepts to include, we can instead specify concepts to *exclude*. When we submit a concept set in this field, we use every covariate except for those that we submitted. When using the default set of covariates, which includes all drugs and procedures occurring on the day of treatment initiation, we must exclude the target and comparator treatment, and any concepts that are directly related to these. For example, if the target exposure is an injectable, we should not only exclude the drug, but also the injection procedure from the propensity model. In this example, the covariates we want to exclude are ACEi and THZ. Figure \@ref(fig:covsToExclude) shows we select a concept set that includes all these concepts. 

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/covsToExclude.png" alt="The concept set defining the concepts to exclude. Note that no descendantsa have been included. We will specify to include these at analysis time in the Analysis settings." width="100%" />
<p class="caption">(\#fig:covsToExclude)The concept set defining the concepts to exclude. Note that no descendantsa have been included. We will specify to include these at analysis time in the Analysis settings.</p>
</div>

Often we want to include or exclude concepts **and their descendants**. We could specify the concept set to include descendant concepts. However, for various reasons it might be more efficient to not include descendant in the concept set, but rather automatically add them by setting the 'Should descendant concepts be added' option to *yes* in the Covariate Settings section of the Analysis settings that will be discussed later.

After selecting the negative controls and covariates to exclude, the comparisons dialog should look like Figure \@ref(fig:comparisons2).

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/comparisons2.png" alt="The comparison window showing concept sets for negative controls and concepts to exclude." width="100%" />
<p class="caption">(\#fig:comparisons2)The comparison window showing concept sets for negative controls and concepts to exclude.</p>
</div>

### Effect estimation analysis settings

After closing the comparisons dialog you can click on 'Add Analysis Settings'. In the box labeled 'Analysis Name', give the analysis a unique name that is easy to remember and locate in the future. For example, we could set the name to "Propensity score matching". 

**Study population**

There are a wide range of options to specify the study population; the set of subjects that will enter the analysis. Many of these overlap with options available when designing the target and comparator cohorts. One  reason for using the options in Estimation instead of in the cohort definition is re-usability: We can define the target, comparator, and outcome cohorts completely independently, and add dependencies between these at a later point in time. For example, if we wish to remove people who had the outcome before treatment initiation, we could do so in the definitions of the target and comparator cohort, but then we would need to create separate cohorts for every outcome! Instead, we can choose to have people with prior outcomes be removed in the analysis settings, and now we can reuse our target and comparator cohorts for our two outcomes of interest (as well as our negative control outcomes).

The **study start and end dates** can be used to limit the analyses to a specific period. The study end date also truncates risk windows, meaning no outcomes beyond the study end date will be considered. One reason for selecting a study start date might be that one of the drugs being studied is new and did not exist in an earlier time. Adjusting for this can also be done by answering “yes” to the question '**Restrict the analysis to the period when both exposures are observed?**'. Another reason to adjust study start and end dates might be that medical practice changed over time (e.g., due to a drug warning) and we are only interested in the time where medicine was practiced a specific way.

The option '**Should only the first exposure per subject be included?**' can be used to restrict to the first exposure per patient. Often this is already done in the cohort definition, as is the case in this example. Similarly, the option '**The minimum required continuous observation time prior to index date for a person to be included in the cohort**' is often already set in the cohort definition, and can therefore be left at 0 here. Having observed time (as defined in the OBSERVATION_PERIOD table) before the index date ensures that there is sufficient information about the patient to calculate a propensity score, and is also often used to ensure the patient is truly a new user, and therefore was not exposed before. 

'**Remove subjects that are in both the target and comparator cohort?**' defines, together with the option '**If a subject is in multiple cohorts, should time-at-risk be censored when the new time-at-risk starts to prevent overlap?**' what happens when a subject is in both target and comparator cohort. The first setting has three choices:

- '**Keep All**' indicating to keep the subjects in both cohorts. With this option it might be possible to double-count subjects and outcomes.
- '**Keep First**' indicating to keep the subject in the first cohort that occurred.
- '**Remove All**' indicating to remove the subject from both cohorts.

If the options 'Keep all' or 'keep first' are selected, we may wish to censor the time when a person is in both cohorts. This is illustrated in Figure \@ref(fig:tar). By default, the time-at-risk is defined relative to the cohort start and end date. In this example, the time-at-risk starts one day after cohort entry, and stops at cohort start. In this case, without censoring the time-at-risk for the two cohorts overlap. This is especially problematic if we choose to keep all, because any outcome that occurs during this overlap (as shown) will be counted twice. If we choose to censor, the first cohort's time-at-risk ends when the second cohort's time-at-risk starts. 

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/tar.png" alt="Time-at-risk (TAR) for subjects who are in both cohorts, assuming time-at-risk starts the day after treatment initiation, and stops at exposure end." width="80%" />
<p class="caption">(\#fig:tar)Time-at-risk (TAR) for subjects who are in both cohorts, assuming time-at-risk starts the day after treatment initiation, and stops at exposure end.</p>
</div>

We can choose to **remove subjects that have the outcome prior to the risk window start**, because often a second outcome occurrence is the continuation of the first one. For instance, when someone develops heart failure, a second occurrence is more likely, and it is likely that the heart failure never fully resolved in between. On the other hand, some outcomes are episodic, and it would be expected for patients to have more than one independent occurrence, like an upper respiratory infection. If do choose to remove people that had the outcome before, we can select **how many days we should look back when identifying prior outcomes**.

Our choices for our example study are shown in Figure \@ref(fig:studyPopulation). Because our target and comparator cohort definitions already restrict to the first exposure and require observation time prior to treatment initiation, we do not apply these criteria here.

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/studyPopulation.png" alt="Study population settings.." width="100%" />
<p class="caption">(\#fig:studyPopulation)Study population settings..</p>
</div>
 
**Covariate settings**

Here we specify the covariates to construct. These covariates are typically used in the propensity model, but can also be included in the outcome model. If we **click to view details** of our covariate settings, we can select which sets of covariates to construct. However, the recommendation is to use the default set, which constructs covariates for demographics, all conditions, drugs, procedures, measurements, etc. 

We can modify the set of covariates by specifying concepts to **include** and/or **exclude**. These settings are the same as the ones found in Section \@ref(ComparisonSettings) on comparison settings. The reason why they can be found in two places is because sometimes these settings are related to a specific comparison, as is the case here because we wish to exclude the drugs we are comparing, and sometimes the settings are related to a specific analysis, for example when we wish to use the same covariates used in another study we are trying to replicate. When executing an analysis for a specific comparison using specific analysis setings, the OHDSI tools will take the union of these sets.

The choice to **add descendants to include or exclude** affects this union of the two settings. So in this example we specified only the ingredients to exclude when definining the comparisons. Here we set 'Should descendant concepts be added to the list of excluded concepts?` to 'Yes' to also add all descendants.

Figure \@ref(fig:covariateSettings) shows our choices for this study. Note that we have selected to add descendants to the concept to exclude, which we defined in the comparison settings in Figure \@ref(fig:comparisons2).  

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/covariateSettings.png" alt="Covariate settings." width="100%" />
<p class="caption">(\#fig:covariateSettings)Covariate settings.</p>
</div>

**Time at risk**

Time-at-risk is defined relative to the start and end dates of our target and comparator cohorts. In our example, we had set the cohort start date to start on treatment initiation, and cohort end date when exposure stops (for at least 30 days). We set the start of time-at-risk to 1 day after cohort start, so 1 day after treatment initation. A reason to set the time-at-risk start to be later than the cohort start is because we may want to exclude outcome events that occur on the day of treatment initiation as we do not believe it biologically plausible they can be caused by the drug.

We set the end of the time-at-risk to the cohort end, so when exposure stops. We could choose to set the end date later if for example we believe events closely following treatment end may still be attributable to the exposure. In the extreme we could set the time-at-risk end to a large number of days (e.g. 99999) after the cohort end date, meaning we will effectively follow up subjects until observation end. Such a design is sometimes referred to as an *intent-to-treat* design.

A patient with 0 days at risk adds no information, so the **minimum days at risk** is normally set at 1 day. If there is a known latency for the side effect, then this may be increased to get a more informative proportion. It can also be used to create a cohort more similar to that of a randomized trial it is being compared to (e.g., all the patients in the randomized trial were observed for at least N days).

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">A golden rule in designing a cohort study is to never use information that falls after the cohort start date to define the study population, as this may introduce bias. For example, if we require everyone to have at least a year of time-at-risk, we will likely have limited our analyses to those who tolerate the treatment well. This setting should therefore be used with extreme care.</div>\EndKnitrBlock{rmdimportant}

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/timeAtRisk.png" alt="Time-at-risk settings." width="100%" />
<p class="caption">(\#fig:timeAtRisk)Time-at-risk settings.</p>
</div>

**Propensity score adjustment**

We can opt to **trim** the study population, removing people with extreme PS values. We can choose to remove the top and bottom percentage, or we can remove subjects whose preference score [@walker_2013] falls outside the range we prespecify. Trimming the cohorts is generally not recommended because it requires discarding observations, which reduces statistical power. It may be desirable to trim in some cases, for example when using IPTW.  

In addition to, or instead of trimming, we can choose to **stratify** or **match** on the propensity score. When stratifying we need to specifiy the **number of strata** and whether to select the strata based on the target, comparator, or entire study population. When matching we need to specify the **maximum number of people from the comparator group to match to each person in the target group**. Typical values are 1 for one-on-one matching, or a large number (e.g. 100) for variable ratio matching. We also need to specify the **caliper**: the maximum allowed difference between propensity scores to allow a match. The caliper can be defined on difference **caliper scales**:

* **The propensity score scale**: the PS itself
* **The standardized scale**: in standard deviations of the PS distributions
* **The standardized logit scale**: in standard deviations of the PS distributions after the logit transformation to make the PS more normally distributed. 

In case of doubt, we suggest using the default values.

Fitting large-scale propensity models can be computationally expensive, so we may want to restrict the data used to fit the model to just a sample of the data. By default the maximum size of the target and comparator cohort is set to 250,000. In most studies this limit will not be reached. It is also unlikely that more data will lead to a better model. Note that althoug a sample of the data may be used to fit the model, the model will be used to compute PS for the entire population.



Test each covariate for correlation with the target assignment? If any covariate has an unusually high correlation (either positive or negative), this will throw an error.

This avoids lengthy calculation of a propensity model only to discover complete separation. Finding very high univariate correlation allows you to review the covariate to determine why it has high correlation and whether it should be dropped.

If an error occurs, should the function stop? Else, the two cohorts will be assumed to be perfectly separable.

Yes, stop, as there is normally no sense in carrying out the calculations and not have a usable result due to perfect separation.


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





