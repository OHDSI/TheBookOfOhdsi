# Population-level estimation {#PopulationLevelEstimation}

*Chapter leads: Martijn Schuemie, David Madigan & Marc Suchard*

Observational healthcare data, such as administrative claims and electronic health records, offer opportunities to generate real-world evidence about the effect of treatments that can meaningfully improve the lives of patients. In this chapter we focus on population-level effect estimation, that is, the estimation of average causal effects of medical interventions on specific health outcomes of interest. In what follows, we consider two different estimation tasks:

- **Direct effect estimation**: estimating the effect of an exposure on the risk of an outcome, as compared to no exposure.
- **Comparative effect estimation**: estimation the effect of one exposure (the target exposure) on the risk of an outcome, as compared to another exposure (the comparator exposure).

In both cases, the patient-level causal effect contrasts a factual outcome, i.e., what happened to the exposed patient, with a counterfactual outcome, i.e., what would have happened had the exposure not occurred (direct) or had a different exposure occurred (comparative). Since any one patient reveals only the factual outcome (the fundamental problem of causal inference), the various effect estimation methods employ analytic devices to shed light on the counterfactual outcomes.

Use-cases for population-level effect estimation include treatment selection, safety surveillance, and comparative effectiveness. Methods can test specific hypotheses one-at-a-time (e.g. ‘signal evaluation’) or explore multiple-hypotheses-at-once (e.g. ‘signal detection’). In all cases, the objective remains the same: to produce a high-quality estimate of the causal effect. 

## Study designs

Several different study designs can be used to estimate treatment effects. The main difference between these is how they construct the (unobserved) counterfactual. Below is a brief discussion of the most commonly used designs, all of which are implemented as R packages in the OHDSI Methods Library.

### Cohort method


<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/cohortMethod.png" alt="The new-user cohort design. Subjects observed to initiate the target treatment are compared to those initiating the comparator treatment. To adjust for differences between the two treatment groups several adjustment strategies can be used, such as stratification, matching, or weighting by the propensity score, or by adding baseline characateristcs to the outcome model. The chararacteristics included in the propensity model or outcome model are captured prior to treatment initiation." width="90%" />
<p class="caption">(\#fig:cohortMethod)The new-user cohort design. Subjects observed to initiate the target treatment are compared to those initiating the comparator treatment. To adjust for differences between the two treatment groups several adjustment strategies can be used, such as stratification, matching, or weighting by the propensity score, or by adding baseline characateristcs to the outcome model. The chararacteristics included in the propensity model or outcome model are captured prior to treatment initiation.</p>
</div>

The new-user cohort method attempts to emulate a randomized clinical trial [@hernan_2016]. Subjects that are observed to initiate one treatment (the target) are compared to subjects initiating another treatment (the comparator) and are followed for a specific amount of time following treatment initiation, for example the time they stay on the treatment. We can specify the questions we wish to answer in a cohort study by making five choices:

| Choice | Description |
| ------ | ----------- |
| Target cohort | A cohort representing the target treatment |
| Comparator cohort | A cohort representing the comparator treatment |
| Outcome cohort | A cohort representing the outcome of interest |
| Time-at-risk | At what time (often relative to the target and comparator cohort start and end dates) do we consider the risk of the outcome? |
| Model | What type of outcome model should be used |

One example of an outcome model to choose is a logistic regression, which evaluates whether or not the outcome has occurred, and produces an odds ratio. A logistic regression assumes the time-at-risk is of the same length for both target and comparator, or irrelevant. Alternatively, we could choose a Poisson regression which estimates the incidence rate ratio, assuming a constant incidence rate. Often a Cox regression is used which considers time to first outcome to estimate the hazard ratio, assuming proportional hazards.

One crucial difference with a randomized trial is that there is no randomization, and therefore there might be systematic differences between the target and comparator populations. Without adjusting for these differences, estimates are likely to be confounded. A popular mechanism for adjusting for confounding is the use of Propensity Scores (PS). The PS is the probability of a subject receiving one treatment instead of the other, conditional on baseline characteristics. [@rosenbaum_1983] First, a model – typically a logistic regression – is fitted using the observed treatment assignments (target or comparator), then the model is used to produce the PS for each subject. In the past, PS were computed based on manually selected characteristics, and although the CohortMethod package can support such practices, we prefer the use of large-scale regularized regression using many generic characteristics. [@tian_2018] These characteristics include demographics, as well as all diagnoses, drug exposures, measurement, and medical procedures observed prior to treatment initiation, and exclude the target and comparator treatment. A model typically involves 10,000 to 100,000 unique characteristics. The PS can be used in several ways, for example by stratifying the study population based on the PS, by matching target subjects to comparator subjects with similar PS, or by weighting subjects using Inverse Probability of Treatment Weighting (IPTW) derived from the PS. 
Another strategy for adjusting for differences between the two groups is to include additional variables in the outcome model. One major limitation of this approach is that whereas there often is a wealth of data to fit a propensity model, with thousands of people in both treatment groups, the outcomes we study tend to be somewhat rare, causing a paucity of data when trying to fit elaborate models with the outcome as dependent variable. One approach is to use both a PS and add the same variables that were used in the propensity model in the outcome model, thus adjusting for the same variables twice, but in different ways.
The new-user cohort method inherently is a method for comparative effect estimation, comparing one treatment to another. It is difficult to use this method to compare a treatment against no treatment, since it is hard to define a group of unexposed people that is comparable with the exposed group. If one wants to use this design for direct effect estimation, the preferred way is to select a comparator treatment for the same indication as the exposure of interest, where the comparator treatment is believed to have no effect on the outcome. Unfortunately, such a comparator might not always be available. In our gold standard, the comparators were specifically selected to have no effect, so we can also evaluate the cohort method’s performance for direct effect estimation.


### Self-controlled cohort

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/selfControlledCohort.png" alt="The self-controlled cohort design. The rate of outcomes during exposure to the target is compared to the rate of outcomes in the time pre-exposure." width="90%" />
<p class="caption">(\#fig:scc)The self-controlled cohort design. The rate of outcomes during exposure to the target is compared to the rate of outcomes in the time pre-exposure.</p>
</div>

The self-controlled cohort (SCC) design [@ryan_2013] compares the rate of outcomes during exposure to the rate of outcomes in the time just prior to the exposure. The following three choices define a self-controlled cohort question:

| Choice | Description |
| ------ | ----------- |
| Target cohort | A cohort representing the treatment |
| Outcome cohort | A cohort representing the outcome of interest |
| Time-at-risk | At what time (often relative to the target cohort start and end dates) do we consider the risk of the outcome? |

Because the same subject that make up the exposed group are also used as the control group, no adjustment for between-person differences need to be made. However, the method is vulnerable to other differences, such as differences between different time periods. 

### Case-control

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/caseControl.png" alt="The case-control design. Subjects with the outcome (‘cases’) are compared to subjects without the outcome (‘controls’) in terms of their exposure status. Often, cases and controls are matched on various characteristics such as age and sex." width="90%" />
<p class="caption">(\#fig:caseControl)The case-control design. Subjects with the outcome (‘cases’) are compared to subjects without the outcome (‘controls’) in terms of their exposure status. Often, cases and controls are matched on various characteristics such as age and sex.</p>
</div>

Case-control [@vandenbroucke_2012] studies consider the question “are persons with a specific disease outcome exposed more frequently to a specific agent than those without the disease?” Thus, the central idea is to compare “cases”, i.e., subjects that experience the outcome of interest with “controls”, i.e., subjects that did not experience the outcome of interest. These choices define a case-control question:

| Choice | Description |
| ------ | ----------- |
| Outcome cohort | A cohort representing the cases (the outcome of interest) |
| Target cohort | A cohort representing the treatment |
| [Nesting cohort] | Optinally, a cohort defining the subpopulation from which cases and controls are drawn |
| Time-at-risk | At what time (often relative to the index date) do we consider exposure status? |

Often, one matches controls to cases based on characteristics such as age and sex to make them more comparable. Another widespread practice is to nest the analysis within a specific subgroup of people, for example people that have all been diagnosed with one of the indications of the exposure of interest. 

### Case-crossover

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/caseCrossover.png" alt="The case-crossover design. The time around the outcome is compared to a control date set at a predefined interval prior to the outcome date." width="90%" />
<p class="caption">(\#fig:caseCrossover)The case-crossover design. The time around the outcome is compared to a control date set at a predefined interval prior to the outcome date.</p>
</div>

The case-crossover [@maclure_1991] design evaluates whether the rate of exposure is different at the time of the outcome than at some predefined number of days prior to the outcome. It is trying to determine whether there is something special about the day the outcome occurred. These choices define a case-crosover question:

| Choice | Description |
| ------ | ----------- |
| Outcome cohort | A cohort representing the cases (the outcome of interest) |
| Target cohort | A cohort representing the treatment |
| Time-at-risk | At what time (often relative to the index date) do we consider exposure status? |

Since cases serve as their own control, it is a self-controlled design, and should therefore be robust to confounding due to between-person differences. One concern is that, because the outcome date is always later than the control date, the method will be positively biased if the overall frequency of exposure increases over time (or negatively biased if there is a decrease). To address this, the case-time-control design [@suissa_1995] was developed, which adds matched controls to the case-crossover design to adjust for exposure trends.

### Self-controlled case series

<div class="figure" style="text-align: center">
<img src="images/PopulationLevelEstimation/selfControlledCaseSeries.png" alt="The Self-Controlled Case Series design. The rate of outcomes during exposure is compared to the rate of outcomes when not exposed." width="90%" />
<p class="caption">(\#fig:selfControlledCaseSeries)The Self-Controlled Case Series design. The rate of outcomes during exposure is compared to the rate of outcomes when not exposed.</p>
</div>

The Self-Controlled Case Series (SCCS) design [@farrington_1995,whitaker_2006] compares the rate of outcomes during exposure to the rate of outcomes during all unexposed time, both before, between, and after exposures. It is a Poisson regression that is conditioned on the person. Thus, it seeks to answer the question: “Given that a patient has the outcome, is the outcome more likely during exposed time compared to non-exposed time?”. These choices define an SCCS question:

| Choice | Description |
| ------ | ----------- |
| Target cohort | A cohort representing the treatment |
| Outcome cohort | A cohort representing the outcome of interest |
| Time-at-risk | At what time (often relative to the target cohort start and end dates) do we consider the risk of the outcome? |

Like other self-controlled designs, the SCCS is robust to confounding due to between-person differences, but vulnerable to confounding due to time-varying effects. Several adjustments are possible to attempt to account for these, for example by including age and season. A special variant of the SCCS includes not just the exposure of interest, but all other exposures to drugs recorded in the database [@simpson_2013], potentially adding thousands of additional variables to the model. L1-regularization using cross-validation to select the regularization hyperparameter is applied to the coefficients of all exposures except the exposure of interest.


One important assumption underlying the SCCS is that the observation period end is independent of the date of the outcome. Because for some outcomes, especially ones that can be fatal such as stroke, this assumption can be violated an extension to the SCCS has been developed that corrects for any such dependency. [@farrington_2011]


## Cohort study implementation

Describe case study: risk of angioedema and AMI in new users of ACE inhibitors compared to new users of thiazide and thiazide-like diuretics


### Implementation using ATLAS


### Implementation using R


## Advanced topics

Best practices: http://www.ohdsi.org/web/wiki/doku.php?id=development:best_practices_estimation 

Negative and positive controls, empirical calibration


## Excercises





