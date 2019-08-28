# (APPENDIX) Appendix {-}

# Glossary {#Glossary}

ACHILLES
: A database-level characterization report.

ARACHNE
: The OHDSI platform that is being developed to allow the orchestration and execution of federated network studies.

ATLAS
: A web-based application that is installed on participating sites to support the design and execution of observational analyses to generate real world evidence from patient level clinical data.

Bias
: The expected value of the error (the difference between the true value and the estimated value).

Boolean
: Variable that has only two values (true or false). 

Care site
: A uniquely identified institutional (physical or organizational) unit where healthcare delivery is practiced (office, ward, hospital, clinic, etc.).

Case control
: A type of retrospective study design for population-level effect estimation. Case-control studies match "cases" with the target outcome to "controls" without the target outcome. Then they look back in time and compare the odds of exposure in the cases and the controls. 

Causal effect
: What population-level estimation concerns itself with. One definition equates a "causal effect" as the average of the "unit-level causal effects" in a target population. The unit-level causal effect is the contrast between the outcome had an individual been exposed and the outcome had that individual not been exposed (or been exposed to A as against B). 

Characterization
: Descriptive study of a cohort or entire database. See Chapter \@ref(Characterization).

Claims data
: Data generated for the purpose of billing a health insurance company.

Clinical trial
: Interventional clinical study.

Cohort
: A set of persons who satisfy one or more inclusion criteria for a duration of time. See Chapter \@ref(Cohorts).

Concept
: A term (with a code) defined in a medical terminology (e.g., SNOMED CT). See Chapter \@ref(StandardizedVocabularies).

Concept set
: A concept set is an expression representing a list of concepts that can be used as a reusable component in various analyses. See Chapter \@ref(Cohorts).

Common Data Model (CDM)
: A convention for representing healthcare data that allows portability of analysis (the same analysis unmodified can be executed on multiple datasets). See Chapter \@ref(CommonDataModel).

Comparative Effectiveness
: A comparison of the effects of two different exposures on an outcome of interest. See Chapter \@ref(PopulationLevelEstimation).

Condition
: A diagnosis, a sign, or a symptom, which is either observed by a provider or reported by the patient.

Confounding
: Confounding is a distortion (inaccuracy) in the estimated measure of association that occurs when the primary exposure of interest is mixed up with some other factor that is associated with the outcome.

Covariate
: Data element (e.g., weight) that is used in a statistical model as independent variable.

Data quality
: The state of completeness, validity, consistency, timeliness and accuracy that makes data appropriate for a specific use.

Device
: A foreign physical object or instrument which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).

Drug
: A Drug is a biochemical substance formulated in such a way that when administered to a Person it will exert a certain physiological effect. Drugs include prescription and over-the-counter medicines, vaccines, and large-molecule biologic therapies. Radiological devices ingested or applied locally do not count as Drugs.

Domain
: A Domain defines the set of allowable Concepts for the standardized fields in the CDM tables. For example, the "Condition" Domain contains Concepts that describe a condition of a patient, and these Concepts can only be stored in the condition_concept_id field of the CONDITION_OCCURRENCE and CONDITION_ERA tables.

Electronic Health Record (EHR)
: Data generated during course of care and recorded in an electronic system. 

Epidemiology
: The study of the distribution, patterns and determinants of health and disease conditions in defined populations.

Evidence-based medicine
: The use of empirical and scientific evidence in making decisions about the care of individual patients.  

ETL (Extract-Transform-Load)
: The process of converting data from one format to another, for example from a source format to the CDM. See Chapter \@ref(ExtractTransformLoad).

Matching
: Many population-level effect estimation approaches attempt to identify the causal effects of exposures by comparing outcomes in exposed patients to those same outcomes in unexposed patients (or exposed to A versus B). Since these two patient groups might differ in ways other than exposure, "matching" attempts to create exposed and unexposed patient groups that are as similar as possible at least with respect to measured patient characteristics.

Measurement
: A structured value (numerical or categorical) obtained through systematic and standardized examination or testing of a person or person's sample. 

Measurement error
: Occurs when a recorded measurement (e.g., blood pressure, patient age, duration of treatment) differs from the corresponding true measurement.

Metadata
: A set of data that describes and gives information about other data and includes descriptive metadata, structural metadata, administrative metadata, reference metadata and statistical metadata.

Methods Library
: A set of R packages developed by the OHDSI community for performing  observational studies.

Model misspecification
: Many OHDSI methods employ statistical models such as proportional hazards regression or random forests. Insofar as the mechanism that generated the data deviate from the assumed model, the model is "misspecified." 

Negative control
: An exposure-outcome pair where the exposure is believed to not cause or prevent the outcome. Can be used to assess whether effect estimation methods produce results in line with the truth. See Chapter \@ref(MethodValidity).

Observation
: A clinical fact about a Person obtained in the context of examination, questioning or a procedure.

Observation period
: The span of time for which a person is at-risk to have clinical events recorded within the source systems, even if no events in fact are recorded (healthy patient with no healthcare interactions).

Observational study
: A study where the researcher has no control over the intervention. 

OHDSI SQL
: A SQL dialect that can be automatically translated to various other SQL dialects using the SqlRender R package. OHDSI SQL is mostly a subset of SQL Server SQL, but allows for additional parameterization. See Chapter \@ref(SqlAndR).

Open science
: The movement to make scientific research (including publications, data, physical samples, and software) and its dissemination accessible to all levels of an inquiring society, amateur or professional. See Chapter \@ref(OpenScience).

Outcome
: An observation that provides a focal point for an analysis. For example, a patient-level predictive model might predict the outcome "stroke." Or a population-level estimation might estimate the causal effect of a drug on the outcome "headache."

Patient-level prediction
: Development and application of predictive models to produce patient-specific probabilities for experiencing some future outcome based on baseline characteristics.

Phenotype
: A description of physical characteristics. This includes visible characteristics like your weight and hair color, but also your overall health, your disease history, and your behavior.

Population-level estimation
: A study into causal effects. Estimates an average (population-level) effect size.

Positive control
: An exposure-outcome pair where the exposure is believed to cause or prevent the outcome. Can be used to assess whether effect estimation methods produce results in line with the truth. See Chapter \@ref(MethodValidity).

Procedure
: Activity or process ordered by, or carried out by, a healthcare provider on the patient to have a diagnostic or therapeutic purpose. 

Propensity score (PS)
: a single metric used in population-level estimation to balance populations in order to mimic randomization between two treatment groups in an observational study.  The PS represents the probability of a patient receiving a treatment of interest as a function of a set of observed baseline covariates. It is most often calculated using a logistic regression model where the binary outcome is set to one for the group receiving the target treatment of interest and to zero for the comparator treatment. See Chapter \@ref(PopulationLevelEstimation). 

Protocol
: A human readable document that fully specifies the design of a study.

Rabbit-in-a-Hat
: An interactive software tool to help define the ETL from source format to CDM. Uses the database profile generated by White Rabbit as input. See Chapter 7.

Selection bias
: A bias that occurs when the set of patients in your data deviates from the patients in the population in ways that distort statistical analyses.

Self-controlled designs
: Study designs that compare outcomes during different exposures within the same patient.

Sensitivity analysis
: A variant of the main analysis used in a study to asses the impact of an analysis choice over which uncertainty exists.

SNOMED
: A systematically organized computer processable collection of medical terms providing codes, terms, synonyms and definitions used in clinical documentation and reporting.

Study diagnostics
: Set of analytical steps where the goal is to determine whether a given analytical approach can be used (is valid) for answering a given research question. See Chapter \@ref(MethodValidity).

Study package
: A computer-executable program that fully executes the study. See Chapter \@ref(SoftwareValidity).

Source code
: A code used in a source database. For example an ICD-10 code.

Standard Concept
: A concept that is designated as valid concept and allowed to appear in the CDM. 

THEMIS
: OHDSI workgroup that addresses target data format that is of higher granularity and detail with respect to CDM model specifications. 

Visit
: The span of time a person continuously receives medical services from one or more providers at a care site in a given setting within the health care system. 

Vocabulary
: A list of words and often phrases, usually arranged alphabetically and defined or translated. See Chapter \@ref(StandardizedVocabularies).

White Rabbit
: A software tool for profiling a database before defining the ETL to the CDM. See Chapter \@ref(ExtractTransformLoad).


