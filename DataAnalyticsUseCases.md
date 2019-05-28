# (PART) Data Analytics {-} 

# Data Analytics Use Cases {#DataAnalyticsUseCases}

* Introduction

The OHDSI collaboration focuses on generating reliable evidence from real-world healthcare data, typically in the form of claims databases or electronic health record databases. The use cases that OHDSI focuses on fall into three major buckets and we describe these below. Note, for all the use cases, the evidence we generate inherits the limitations of the data; we discuss these limitations at length in Chapters X, Y, and Z. 

* Theory

1. Population characterization

We can use the data to provide answers to questions about the charateristics of the patients in each database, the practice of healthcare, and study how these things change over time.

The data can provide answers to questions like:
- for patients newly diagnosed with atrial fibrillation, how many receive a prescription for warfarin?
- what is the average age of patients who undergo hip arthoplasty?

2. Population-level estimation

To a limited extent, the data can support causal inferences about the effects of healthcare interventions. 

The data can provide answers to questions like:
- for patients newly diagnosed with atrial fibrillation, in the first year after therapy initiation, does warfarin cause more major bleeds than dabigatran? 
- Does the causal effect of metformin on diarrhea vary by age?

3. Patient-Level prediction

Based on the collected patient health histories in the database, we can make patient-level predictions about future health events. 
- for a specific patient newly diagnosed with atrial fibrillation, in the first year after therapy initiation with warfarin, what is the probability the patient suffers an ischemic stroke?

These tasks overlap to a certain extent. For example, an important use-case for prediction is to predict an outcome for a specific patient had drug A been prescribed and also predict the same outcome had drug B been prescribed. Let's assume that in reality only one of these drugs is prescribed (say drug A) so we get to see whether the outcome following treatment with A actually occurs. Since drug B was not prescribed, the outcome following treatment B, while predictable, is "counterfactual" since it is not ever observed. Each of these prediction tasks falls under patient-level prediction. However, the difference between (or ratio of) the two outcomes is a unit-level *causal* effect.


There are many important healthcare questions for which OHDSI databases cannot provide answers. These include:

- Causal effects of interventions compared to placebo. Sometimes it is possible to consider the causal effect of a treatment as compared with non-treatment but not placebo tretamernt.
- Anything related to over-the-counter medications
- Many outcomes are sparsely recorded if at all. These include mortality, behavioral outcomes, lifestyle, and socioeconmic status.
- Since patients tend to encounter the healthcare system when they are unwell, measurement of the benefits of treatments can prove elusive.

Missingness in OHDSI databases presents subtle challenges. A health event (e.g., prescription, laboratory value, etc.) that should be recorded in a database, but isn't, is "missing." The statistics literature distinguishes between types of missingness such as "missing completely at random," "missing at random," and "missing not at random" and methods of increasing complexity attempt to address these types. @perkins2017principled provide a use introduction to this topic.

What use cases are often observed? Drug safety, Drug utilization, etc.

* Practice
