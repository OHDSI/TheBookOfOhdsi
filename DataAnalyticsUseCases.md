# (PART) Data Analytics {-}

# Data Analytics Use Cases {#DataAnalyticsUseCases}

*Chapter lead: David Madigan*

The OHDSI collaboration focuses on generating reliable evidence from real-world healthcare data, typically in the form of claims databases or electronic health record databases. The use cases that OHDSI focuses on fall into three major categories:

- Characterization
- Population-level estimation
- Patient-level prediction

We describe these in detail below. Note, for all the use cases, the evidence we generate inherits the limitations of the data; we discuss these limitations at length in the book section on Evidence Quality (Chapters \@ref(EvidenceQuality) - \@ref(MethodValidity))

## Characterization

\index{characterization}

Characterization attempts to answer the question

> What happened to them?

We can use the data to provide answers to questions about the characteristics of the persons in a cohort or the entire database, the practice of healthcare, and study how these things change over time.

The data can provide answers to questions like:

- For patients newly diagnosed with atrial fibrillation, how many receive a prescription for warfarin?
- What is the average age of patients who undergo hip arthroplasty?
- What is the incidence rate of pneumonia in patients over 65 years old?

Typical characterization questions are formulated as:

- How many patients...?
- How often does...?
- What proportion of patients...?
- What is the distribution of values for lab...?
- What are the HbA1c levels for patients with...?
- What are the lab values for patients...?
- What is the median length of exposure for patients on....?
- What are the trends over time in...?
- What are other drugs that these patients are using?
- What are concomitant therapies?
- Do we have enough cases of...?
- Would it be feasible to study X...?
- What are the demographics of...?
- What are the risk factors of...? (if identifying a specific risk factor, maybe estimation, not prediction)
- What are the predictors of...?

And the desired output is:

- Count or percentage
- Averages
- Descriptive statistics
- Incidence rate
- Prevalence
- Cohort
- Rule-based phenotype
- Drug utilization
- Disease natural history
- Adherence
- Co-morbidity profile
- Treatment pathways
- Line of therapy

## Population-Level Estimation

\index{population-level estimation}

To a limited extent, the data can support causal inferences about the effects of healthcare interventions, answering the question

> What are the causal effects?

We would like to understand causal effects to understand consequences of actions. For example, if we decide to take some treatment, how does that change what happens to us in the future?

The data can provide answers to questions like:

- For patients newly diagnosed with atrial fibrillation, in the first year after therapy initiation, does warfarin cause more major bleeds than dabigatran?
- Does the causal effect of metformin on diarrhea vary by age?

Typical population-level effect estimation questions are formulated as:

- What is the effect of...?
- What if I do intervention...?
- Which treatment works better?
- What is the risk of X on Y?
- What is the time-to-event of...?

And the desired output is:

- Relative risk
- Hazards ratio
- Odds ratio
- Average treatment effect
- Causal effect
- Association
- Correlation
- Safety surveillance
- Comparative effectiveness

## Patient-Level Prediction

\index{patient-level prediction}

Based on the collected patient health histories in the database, we can make patient-level predictions about future health events, answering the question

> What will happen to me?

The data can provide answers to questions like:

- For a specific patient newly diagnosed with major depressive disorder, what is the probability the patient will attempt suicide in the first year following diagnosis?
- For a specific patient newly diagnosed with atrial fibrillation, in the first year after therapy initiation with warfarin, what is the probability the patient suffers an ischemic stroke?

Typical patient-level prediction questions are formulated as:

- What is the chance that this patient will...?
- Who are candidates for...?

And the desired output is:

- Probability for an individual
- Prediction model
- High/low risk groups
- Probabilistic phenotype

Population-level estimation and patient-level prediction overlap to a certain extent. For example, an important use case for prediction is to predict an outcome for a specific patient had drug A been prescribed and also predict the same outcome had drug B been prescribed. Let's assume that in reality only one of these drugs is prescribed (say drug A) so we get to see whether the outcome following treatment with A actually occurs. Since drug B was not prescribed, the outcome following treatment B, while predictable, is "counterfactual" since it is not ever observed. Each of these prediction tasks falls under patient-level prediction. However, the difference between (or ratio of) the two outcomes is a unit-level *causal* effect, and should be estimated using causal effect estimation methods instead.

\BeginKnitrBlock{rmdimportant}
People have a natural tendency to erroneously interpret predictive models as if they are causal models. But a predictive model can only show correlation, never causation. For example, diabetic drug use might be a strong predictor for myocardial infarction (MI) because diabetes is a strong risk factor for MI. However, that does not mean that stopping the diabetic drugs will prevent MI!
\EndKnitrBlock{rmdimportant}

## Example Use Cases in Hypertension

You’re a researcher interested in studying the effects of ACE inhibitor monotherapy vs. thiazide diuretic monotherapy on the outcomes of acute myocardial infarction and angioedema as first-line treatment for hypertension. You understand that based on the OHDSI literature, you are asking a population-level effect estimation question but first, you need to do some homework on how to characterize this particular treatment of interest.

### Characterization Questions

Acute myocardial infarction is a cardiovascular complication that can occur in patients with high blood pressure, so effective treatment for hypertension should reduce the risk. Angioedema is a known side effect of ACE inhibitors, which is rare but potentially serious.  You start by creating cohorts (see Chapter \@ref(Cohorts))  for the exposures of interest (new users of ACE inhibitors and new users of thiazide diuretics). You perform a characterization (see Chapter \@ref(Characterization)) analysis to summarize baseline characteristics of these exposure populations, including demographics, co morbid conditions, and concomitant medications.  You perform another characterization analysis to estimate the incidence of selected outcomes within these exposure populations.  Here, you ask ‘how often does 1) acute myocardial infarction and 2) angioedema occur during the period of exposure to ACE inhibitors and thiazide diuretics?’ These characterizations allow us to assess the feasibility of conducting a population-level estimation study, to evaluate whether the two treatment groups are comparable, and to identify ‘risk factors’ that might predict which treatment choice that patients made.

### Population-Level Estimation Question

The population-level effect estimation study (see Chapter \@ref(PopulationLevelEstimation)) estimates the relative risk of ACE inhibitor vs, thiazide use for the outcomes of AMI and angioedema.  Here, you further evaluate through study diagnostics and negative controls whether we can produce a reliable estimate of the average treatment effect.

### Patient-Level Prediction Question

Independent of whether there is a causal effect of the exposures, you are also interested in trying to determine which patients are at highest risk of the outcomes. This is a patient-level prediction problem (see Chapter \@ref(PatientLevelPrediction)). Here, you develop a prediction model that evaluates: amongst the patients who are new users of ACE inhibitors, which patients are at highest risk of developing acute myocardial infarction during the 1 year after starting treatment. The model allows us to predict, for a patient who has just been prescribed ACE for the first time, based on events observed from their medical history, what is the chance that they will experience AMI in the next 1 year.

## Limitations of Observational Research

\index{limitations of observational research}

There are many important healthcare questions for which OHDSI databases cannot provide answers. These include:

- Causal effects of interventions compared to placebo. Sometimes it is possible to consider the causal effect of a treatment as compared with non-treatment but not placebo treatment.
- Anything related to over-the-counter medications.
- Many outcomes and other variables are sparsely recorded if at all. These include mortality, behavioral outcomes, lifestyle, and socioeconomic status.
- Since patients tend to encounter the healthcare system only when they are unwell, measurement of the benefits of treatments can prove elusive.

### Erroneous Data

Clinical data recorded in OHDSI databases can deviate from clinical reality. For example, a patient's record may include a code for myocardial infarction even though the patient never experienced a myocardial infarction. Similarly, a lab value may be erroneous or an incorrect code for a procedure may appear in the database. Chapters \@ref(DataQuality) and \@ref(ClinicalValidity) discuss several of these issues and good practice aims to identify and correct for as many of these kinds of issues as possible. Nonetheless, erroneous data inevitably persist to some extent and can undermine the validity of subsequent analyses. An extensive literature focuses on adjustment of statistical inferences to account for errors-in-data - see, for example, @fuller2009measurement.

### Missing Data

\index{missing data}

Missingness in OHDSI databases presents subtle challenges. A health event (e.g., prescription, laboratory value, etc.) that should be recorded in a database, but isn't, is "missing." The statistics literature distinguishes between types of missingness such as "missing completely at random," "missing at random," and "missing not at random" and methods of increasing complexity attempt to address these types. @perkins2017principled provide a useful introduction to this topic.

## Summary

\BeginKnitrBlock{rmdsummary}
- In observational research we distinguish three large categories of uses cases.

- **Characterization** aims to answer the questions "What happened to them?"

- **Population-level estimation** attempts to answer the question "What are the causal effects?"

- **Patient-level prediction** tries to answer "What will happen to me?"

- Prediction models are not causal models; There is no reason to believe that intervening on a strong predictor will impact the outcome.

- There are questions that cannot be answered using observational healthcare data.

\EndKnitrBlock{rmdsummary}

## Exercises

\BeginKnitrBlock{exercise}
<span class="exercise" id="exr:exerciseUseCases1"><strong>(\#exr:exerciseUseCases1) </strong></span>Which use case categories do these questions belong to?

1. Compute the rate of gastrointestinal (GI) bleeding in patients recently exposed to NSAIDs.

2. Compute the probability that a specific patient experiences a GI bleed in the next year, based on their baseline characteristics.

3. Estimate the increased risk of GI bleeding due to diclofenac compared to celecoxib.

\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}
<span class="exercise" id="exr:exerciseUseCases2"><strong>(\#exr:exerciseUseCases2) </strong></span>You wish to estimate the increased risk of GI bleeding due to diclofenac compared to no exposure (placebo). Can this be done using observational healthcare data?

\EndKnitrBlock{exercise}

Suggested answers can be found in Appendix \@ref(UseCasesanswers).
