# (PART) Data Analytics {-} 

# Data Analytics Use Cases {#DataAnalyticsUseCases}

*Chapter lead: David Madigan*

The OHDSI collaboration focuses on generating reliable evidence from real-world healthcare data, typically in the form of claims databases or electronic health record databases. The use cases that OHDSI focuses on fall into three major categories:

- Characterization
- Population-level estimation
- Patient-level prediction

We describe these in detail below. Note, for all the use cases, the evidence we generate inherits the limitations of the data; we discuss these limitations at length in the book section on Evidence Quality (Chapters \@ref(EvidenceQuality) - \@ref(MethodValidity))

## Characterization

Characterization attempts to answer the question

> What happened to them?

We can use the data to provide answers to questions about the characteristics of the persons in a cohort or the entire database, the practice of healthcare, and study how these things change over time.

The data can provide answers to questions like:

- For patients newly diagnosed with atrial fibrillation, how many receive a prescription for warfarin?
- What is the average age of patients who undergo hip arthroplasty?
- What is the incidence rate of pneumonia in patients over 65 years old?

More specifically, if your question is:

- How many patients...?
- How often does...?
- What proportion ofpatients...?
- What is the distribution of values for lab...?
- What are the HbA1c levels for patients with...?
- What are the [lab values] for patients...?
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
- Comorbidity profile
- Treatment pathways
- Line of therapy

Then you’re probably asking for:
- **Clinical characterization**


## Population-level estimation

To a limited extent, the data can support causal inferences about the effects of healthcare interventions, answering the question

> What are the causal effects?

We would like to understand causal effects to understand consequences of actions. For example, if we decide to take some treatment, how does that change what happens to us in the future?

The data can provide answers to questions like:

- For patients newly diagnosed with atrial fibrillation, in the first year after therapy initiation, does warfarin cause more major bleeds than dabigatran? 
- Does the causal effect of metformin on diarrhea vary by age?

More specifically, if your question is:

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

Then you’re probably asking for:
- **Population-level effect estimation**

## Patient-Level prediction

Based on the collected patient health histories in the database, we can make patient-level predictions about future health events, answering the question 

> What will happen to me?

The data can provide answers to questions like: 

- For a specific patient newly diagnosed with major depressive disorder, what is the probability the patient will attempt suicide in the first year following diagnosis?
- For a specific patient newly diagnosed with atrial fibrillation, in the first year after therapy initiation with warfarin, what is the probability the patient suffers an ischemic stroke?

More specifically, if your question is:

- What is the chance that this patient will...?
- Who are candidates for...?

And the desired output is:
- Probability for an individual
- Prediction model
- High/low risk groups
- Probabilistic phenotype

Then you’re probably asking for:
- **Patient-level prediction**

Population-level estimation and patient-level prediction overlap to a certain extent. For example, an important use case for prediction is to predict an outcome for a specific patient had drug A been prescribed and also predict the same outcome had drug B been prescribed. Let's assume that in reality only one of these drugs is prescribed (say drug A) so we get to see whether the outcome following treatment with A actually occurs. Since drug B was not prescribed, the outcome following treatment B, while predictable, is "counterfactual" since it is not ever observed. Each of these prediction tasks falls under patient-level prediction. However, the difference between (or ratio of) the two outcomes is a unit-level *causal* effect, and should be estimated using causal effect estimation methods instead.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">People have a natural tendency to erroneously interpret predictive models as if they are causal models. But a predictive model can only show correlation, never causation. For example, diabetic drug use might be a strong predictor for myocardial infarction (MI) because diabetes is a strong risk factor for MI. However, that does not mean that stopping the diabetic drugs will prevent MI!</div>\EndKnitrBlock{rmdimportant}

## Frame research question in OHDSI-speak

You now know from the previous step what OHDSI framework best suits your research question. Depending on the study objectives, an OHDSI-compliant research question should be structured in a way that explicitly describes the target population, the output(s) of interest, and analysis method (if applicable). 

The list below provides OHDSI-speak template and example questions for different study categories as the best practice to formulate research questions. The subsequent chapters will explain the analytical methods to run your study.

|Study Category|Template Question|Example|
|:--|:--|:--|
|Disease onset and progression|Amongst patients who are newly diagnosed with **[insert the disease of interest]**, which patients will go on to have **[another disease or related complication]** within **[time horizon from diagnosis]**?|Among newly diagnosed **AFib** patients, which patients will go onto to have **ischemic stroke** in next **3 years**? Among newly diagnosed **Melonoma**, which patients will go onto to have **brain cancer** in next **6 months**?|
|Treatment choice|Amongst patients with **[indicated disease]** who are treated with either **[treatment 1]** or **[treatment 2]**, which patients were treated with **[treatment 1] (on day 0)**?|Among **AFib** patients who took either **warfarin** or **dabigatran**, which patients got warfarin?   (as defined for propensity score model)|
|Treatment response|Amongst patients who are new users of **[insert the chronically-used drug of interest]**, which patients will **[insert desired effect]** in **[time window]**?|Which patients with **T2DM** who start **metformin** stay on **metformin** after **3 years**?|
|Treatment safety|Amongst patients who are new users of **[insert the drug of interest]**, which patients will experience **[insert your favorite known adverse event from the drug profile]** within **[time horizon following exposure start]**?|Among new users of **warfarin**, which patients will have **GI bleeding** in **1 year**?|
|Treatment adherence|Amongst patients who are new users of **[insert the chronically-used drug of interest]**, which patients will achieve **[adherence metric threshold]** at **[time horizon]**?|Which patients with **T2DM** who start on **metformin** will achieve **>=80% proportion of days covered** at **1 year**?|
|Comparative effectiveness|To compare the risk of **[Insert the outcome of interest]** between **[Insert the target exposure]** and **[Insert the comparator cohort]**, we will estimate the population-level effect of exposure on the **[Insert the metric of analysis model here: hazards for Cox/ odds for logistic / rate ratio for Poisson]** of the outcome during the period from **[Insert the time-at-risk start: e.g. 1 day after exposure start]** to **[Insert the time-at-risk end: e.g. 30 days after exposure end]**.|To compare the risk of **angioedema** between new users of **levetiracetam** and new users of **phenytoin**, we will estimate the population-level effect of exposure on the **hazards** of the outcome during the period from **1 day after exposure start** to **0 days after exposure end**.|

## Example of a Study in OHDSI-speak

You’re a researcher interested in studying the effects of ACE inhibitor monotherapy vs. thiazide diuretic monotherapy on the outcomes of acute myocardial infarction and angioedema as first-line treatment for hypertension. You understand that based on the OHDSI literature, you are asking a population-level effect estimation question but first, you need to do some homework on how to characterize this particular treatment of interest.

### Characterization Questions
Acute myocardial infarction is a cardiovascular complication that can occur in patients with high blood pressure, so effective treatment for hypertension should reduce the risk. Angioedema is a known side effect of ACE inhibitors, which is rare but potentially serious.  You start by creating [Cohorts] for the exposures of interest (new users of ACE inhibitors and new users of thiazide diuretics). You perform a [Characterization] analysis to summarize baseline characteristics of these exposure populations, including demographics, comorbid conditions, and concomitant medications.  You perform another characterization analysis to estimate the incidence of selected outcomes within these exposure populations.  Here, you ask ‘how often does 1) acute myocardial infarction and 2) angioedema occur during the period of exposure to ACE inhibitors and thiazide diuretics?’   These characterizations allow us to assess the feasibility of conducting a [PopulationLevelEstimation], to evaluate whether the two treatment groups are comparable, and to identify ‘risk factors’ that might predict which treatment choice that patients made.  

### Population-Level Estimation Question
The population-level effect estimation study estimates the relative risk of ACE inhibitor vs, thiazide use for the outcomes of AMI and angioedema.  Here, you further evaluate through study diagnostics and negative controls whether we can produce a reliable estimate of the average treatment effect.

Independent of whether there is a causal effect of the exposures, you are also interested in trying to determine which patients are at highest risk of the outcomes.  (This is a patient-level prediction problem).  Here, you develop a prediction model that evaluates:  amongst the patients who are new users of ACE inhibitors, which patients are at highest risk of developing acute myocardial infarction during the 1 year after starting treatment.  The model allows us to predict, for a patient who has just been prescribed ACE for the first time, based on events observed from their medical history, what is the chance that they will experience AMI in the next 1 year.

### More real example questions

In this section, we provide more real examples of questions as they have been submitted to the community. We have also reframed them to the OHDSI-speak format (if needed) and mapped them to OHDSI analytic frameworks:

|Unframed question we’ve heard from potential researchers|Reframed Question in OHDSI-speak _(italics denote additions to the original question for clarification)_|OHDSI Framework|
|:--|:--|:--|
|Among patients addicted to opioids, what is the proportion of patients taking benzos concurrently?|Amongst opioid-addicted patients, how many patients did concurrently use benzodiazepines _any time over the last 5 years of data_?|Clinical characterization|
|Among patients newly diagnosed with cancer, how many received guideline-concordant care?|Amongst newly diagnosed cancer patients, how many patients did receive guideline-concordant care _over the last 5 years of data_?|Clinical characterization|
|Among patients diagnosed with pneumonia, who develops ocular retinopathy within 2 years?|Amongst patients who are _newly_ diagnosed with pneumonia, which patients will develop ocular retinopathy after 2 years?|Patient-level prediction|
|Among Patients with an ICD9/10 for psoriasis over the last 5 years, how many presented with major adverse cardiovascular events (e.g., heart attack, stroke, MI, atrial fibrillation)?  What were the red cell distribution width (RDW) values for these patients?|Amongst diagnosed patients with psoriasis over the last 5 years _of data_, how many patients experienced major cardiovascular adverse events _any time during the study period_? Amongst diagnosed patients with psoriasis over the last 5 years of data, what were _max-min range, median, IQR, mean, and SD_ of red cell distribution width (RDW) values _any time during the study period_?|Clinical characterization|
|How many patients had a shoulder arthroscopy in the last year?|How many patients did undergo arthroscopy _procedure_ in the last year?|Clinical characterization|
|Among patients with neuro-degenerative Parkinson's disease, onset age 65 or older, how many subsequently suffered from brain stroke or dementia?|Amongst patients diagnosed with neurodegenerative Parkinson’s disease who were 65 years or older at onset, how many patients experienced brain stroke or dementia _after diagnosis_?|Clinical characterization|
|What are the rates of chemotherapy-induced neutropenia and subsequent chemotherapy withdrawal in patients taking cisplatin?|Amongst patients who take cisplatin, what is the rate of developing chemotherapy-induced neutropenia _per 1,000 patient per year over the last 2 years of data_?|Clinical characterization|
|Among outpatients, how many presented with ADHD were taking Ritalin for the last 6 months?|Amongst admitted patients in ambulatory setting _over the last year of data_, how many ADHD patients did use Ritalin within the last 6 months _prior to last visit_?|Clinical characterization|


## Limitations of observational research

There are many important healthcare questions for which OHDSI databases cannot provide answers. These include:

- Causal effects of interventions compared to placebo. Sometimes it is possible to consider the causal effect of a treatment as compared with non-treatment but not placebo treatment.
- Anything related to over-the-counter medications.
- Many outcomes and other variables are sparsely recorded if at all. These include mortality, behavioral outcomes, lifestyle, and socioeconomic status.
- Since patients tend to encounter the healthcare system only when they are unwell, measurement of the benefits of treatments can prove elusive.

### Missing data

Missingness in OHDSI databases presents subtle challenges. A health event (e.g., prescription, laboratory value, etc.) that should be recorded in a database, but isn't, is "missing." The statistics literature distinguishes between types of missingness such as "missing completely at random," "missing at random," and "missing not at random" and methods of increasing complexity attempt to address these types. @perkins2017principled provide a useful introduction to this topic.

## Summary

\BeginKnitrBlock{rmdsummary}<div class="rmdsummary">- In observational research we distinguish three large categories of uses cases.

- **Characterization aims** to answer the questions "What happened to them?"

- **Population-level estimation** attempts to answer the question "What are the causal effects?"

- **Patient-level prediction** tries to answer "What will happen to me?"

- Prediction models are not causal models; There is no reason to believe that intervening on a strong predictor will impact the outcome.
</div>\EndKnitrBlock{rmdsummary}

