# Where to begin {#WhereToBegin}

*Chapter leads: Hamed Abedtash and Krista Kostka*

> “A journey of a thousand miles begins with a single step.” - Lao Tzu


The OHDSI community represents a mosaic of stakeholders across academia, industry and government-entities. Our work benefits a range of individuals and organizations, including patients, providers, and researchers, as well as health care systems, industry, and government agencies. This benefit is achieved by improving both the quality of healthcare data analytics as well as the usefulness of healthcare data to these stakeholders. We believe observational research is a field which benefits greatly from disruptive thinking. We actively seek and encourage fresh methodological approaches in our work. 

## Joining the Journey
Everyone is welcome to actively participate in OHDSI, whether you are a patient, a health professional, a researcher, or someone who simply believes in our cause. OHDSI maintains an inclusive membership model. To become an OHDSI collaborator requires no membership fee. Collaboration is as simple as raising a hand to be included in the yearly OHDSI membership count. Involvement is entirely at-will. A collaborator can have any level of contribution within the community, ranging from someone who attends weekly community calls to leading network studies or OHDSI working groups. Collaborators do not have to be data holders to be considered active members of the community. The OHDSI community aims to serve data holders, researchers, health care providers and patients & consumers alike. A record of collaborator profiles are maintained and periodically updated on the OHDSI website. Membership is fostered via OHDSI community calls, workgroups and regional chapters.

### OHDSI Community Calls
OHDSI Community Calls are a weekly forum to spotlight ongoing activity within the OHDSI community. Held every Tuesday from 12-1pm ET, these teleconferences are a time for the OHDSI community to come together to share recent developments and recognize the accomplishments of individual collaborators, working groups and the community as a whole. Each week’s meeting is recorded, and presentations are archived in the OHDSI website resources. 

All OHDSI Collaborators are welcome to participate in this weekly teleconference and encouraged to propose topics for community discussion. OHDSI Community Calls can be a forum to share research findings, present and seek feedback for active works-in-progress, demonstrate open-source software tools under development, debate community best practices for data modeling and analytics, and brainstorm future collaborative opportunities for grants/publications/conference workshops. If you are a Collaborator with a topic for an upcoming OHDSI Collaborator meeting, you are invited to post your thoughts on the OHDSI Forums.

As a newcomer to the OHDSI community, it’s highly encouraged to add this call to your calendar to get acquainted with what’s happening across the OHDSI network. Newcomers are invited to introduce themselves on their first call and tell the community about themselves, their background and what brought them to OHDSI. If you’d like to join an OHDSI call, please contact Maura Beaton (beaton@ohdsi.org) for the latest dial-in details or consult the OHDSI wiki (https://www.ohdsi.org/web/wiki/doku.php?id=projects:ohdsi_community). Community call topics vary from week-to-week. Consult the OHDSI Weekly Digest on the OHDSI forum for more information on weekly presentation topics.

### OHDSI Workgroups
OHDSI has a variety of ongoing projects lead by workgroup teams. Each workgroup has its own leadership team which determine the project’s objectives, goals and artefacts to be contributed to the community. Workgroup participation is open to all who have an interest in contributing to the project objectives and goals. Workgroups may be long-standing, strategic objectives or short-term projects to accomplish a specific need in the community. Workgroup meeting cadence is determined by the project leadership and will vary from group to group. A list of the active workgroups is maintained on the OHDSI Wiki (https://www.ohdsi.org/web/wiki/doku.php?id=projects:overview). 

`**May update to include a graphic of the workgroups by use case**`

### OHDSI Regional Chapters
An OHDSI regional chapter represents a group of OHDSI collaborators located in a geographic area who wish to hold local networking events and meetings to address problems specific to their geographic location. Today, OHDSI regional chapters include OHDSI in Europe (https://www.ohdsi-europe.org/), OHDSI in South Korea (http://forums.ohdsi.org/c/For-collaborators-wishing-to-communicate-in-Korean) and OHDSI in China (https://ohdsichina.org/). If you would like to set-up an OHDSI regional chapter in your region, you may do so by following the OHDSI regional chapter process outlined on the OHDSI website (https://www.ohdsi.org/who-we-are/regional-chapters).

### OHDSI Research Network
Many OHDSI collaborators are interested in converting their data into the OMOP Common Data Model. The OHDSI research network represents a diverse, global community of observational databases that have undergone [[ETL]] processes to become OMOP compliant. If your journey in the OHDSI community includes transforming data, there are numerous community resources available to aid you in your journey including [[tutorials]] on the OMOP CDM and Vocabularies, freely available tools to assist with conversion [[ETL chapter reference]] and workgroups targeting specific domains or types of data conversions. OHDSI collaborators are encouraged to utilize the OHDSI forum to discuss and troubleshoot challenges that arise during CDM conversions.

## Navigating Your Odyssey in OHDSI
As discussed in the previous section, there are many ways to begin your journey in the OHDSI community. Collaborators often find the journey from initial interest in OHDSI to actively contributing to be as circuitous as Homer’s Odyssey. For those interested in running OHDSI research studies, the simplest way to navigate your path forward is to learn how to speak in “OHDSI” terms.

### How to Translate Your Research Question into an OHDSI Framework
The OHDSI community has a wide range of standardized analytic tools depending on the type of question you are formulating. In the following chapters, we will discuss the intricacies of these frameworks as well as the open source tools and code available to conduct these analyses. In this section, we will briefly discuss how to take your question and reframe it in OHDSI-speak, what analytical methods and tools are appropriate for data analysis, and where you can find the resources within the OHDSI community.

#### Step 1: Identify the proper framework

Before formulating your research question for execution on OHDSI platform, it is important to understand which OHDSI framework suits the objectives of research question, whether it is a “clinical characterization”, “population-level estimation”, or “patient-level prediction”. Clinical characterization provides answers to “What happened to them” questions, population-level estimation responses to “What are the causal effects” question, and population-level estimation answers “What will happen to me” question. To learn more about the OHDSI use cases, please refer to Chapter \@ref(DataAnalyticsUseCases). 

Once you understand the relationship between OHDSI framework and different study types you will be using, you can then further refine your question into OHDSI-speak. THere are examples of study categories that correspond to each OHDSI framework:


- **Clinical characterization**
    - Disease natural history
    - Incidence rate
    - Prevalence
    - Treatment utilization
    - Treatment pathway
    - Quality improvement
- **Population-level effect estimation**
    - Safety surveillance
    - Effect estimation
    - Comparative effectiveness
- **Patient-level prediction**
    - Precision Medicine
    - Disease onset and progression
    - Treatment choice
    - Disease interception
    - Treatment response
    - Treatment safety
    - Treatment adherence

Many people start with a simple characterization (e.g., how many people have angioedema? How often does a patient receive ACE inhibitors?). Even if you are thinking about an estimation or prediction question, you’ll probably want to start with preliminary characterization analyses to understand your target and outcome cohorts. In fact, estimation and prediction studies produce characterization results as part of their standardized outputs.

The tool below also provides a crosswalk of the type of question with a desired output you may be formulating to what OHDSI framework may be most appropriate for that question. 

- If your question is:
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
- And the desired output is:
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
- Then you’re probably asking for:
    - **Clinical characterization**


- If your question is:
    - What is the effect of...?
    - What if I do [intervention]...?
    - Which treatment works better?
    - What is the risk of X on Y?
    - What is the time-to-event of...?
- And the desired output is:
    - Relative risk
    - Hazards ratio
    - Odds ratio
    - Average treatment effect
    - Causal effect
    - Association
    - Correlation
    - Safety surveillance
    - Comparative effectiveness
- Then you’re probably asking for:
    - **Population-level effect estimation**


- If your question is:
    - What is the chance that this patient will...?
    - Who are candidates for...?
- And the desired output is:
    - Probability for an individual
    - Prediction model
    - High/low risk groups
    - Probabilistic phenotype
- Then you’re probably asking for:
    - **Patient-level prediction**

#### Step 2: Frame research question in OHDSI-speak

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

### Example of a Study in OHDSI-speak

You’re a researcher interested in studying the effects of ACE inhibitor monotherapy vs. thiazide diuretic monotherapy on the outcomes of acute myocardial infarction and angioedema as first-line treatment for hypertension. You understand that based on the OHDSI literature, you are asking a population-level effect estimation question but first, you need to do some homework on how to characterize this particular treatment of interest.

#### Characterization Questions
Acute myocardial infarction is a cardiovascular complication that can occur in patients with high blood pressure, so effective treatment for hypertension should reduce the risk. Angioedema is a known side effect of ACE inhibitors, which is rare but potentially serious.  You start by creating [[cohorts]] for the exposures of interest (new users of ACE inhibitors and new users of thiazide diuretics). You perform a [[characterization analysis]] to summarize baseline characteristics of these exposure populations, including demographics, comorbid conditions, and concomitant medications.  You perform another characterization analysis to estimate the incidence of selected outcomes within these exposure populations.  Here, you ask ‘how often does 1) acute myocardial infarction and 2) angioedema occur during the period of exposure to ACE inhibitors and thiazide diuretics?’   These characterizations allow us to assess the feasibility of conducting a [[population-level effect estimation]], to evaluate whether the two treatment groups are comparable, and to identify ‘risk factors’ that might predict which treatment choice that patients made.  

#### Population-Level Estimation Question
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

# Summary
`**add if needed**`

