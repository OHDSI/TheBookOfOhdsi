# (PART) Evidence Quality {-}

# Evidence Quality {#EvidenceQuality}

*Chapter leads: Patrick Ryan & Jon Duke*

\index{evidence quality}

## Attributes of Reliable Evidence

Before embarking on any journey, it can be helpful to envision what the ideal destination might look like. To support our journey from data to evidence, we highlight desired attributes that can underlie what makes evidence quality reliable. 


\begin{figure}

{\centering \includegraphics[width=1\linewidth]{images/EvidenceQuality/reliableevidenceattributes} 

}

\caption{Desired attributes of reliable evidence}(\#fig:attributesOfEvidence)
\end{figure}

Reliable evidence should be **repeatable**, meaning that researchers should expect to produce identical results when applying the same analysis to the same data for any given question. Implicit in this minimum requirement is the notion that evidence is the result of the execution of a defined process with a specified input, and should be free of manual intervention of post-hoc decision-making along the way. More ideally, reliable evidence should be **reproducible** such that a different researcher should be able to perform the same task of executing a given analysis on a given database and expect to produce an identical result as the first researcher. Reproducibility requires that the process is fully-specified, generally in both human-readable and computer-executable form such that no study decisions are left to the discretion of the investigator. The most efficient solution to achieve repeatability and reproducibility is to use standardized analytics routines that have defined inputs and outputs, and apply these procedures against version-controlled databases.

We are more likely to be confident that our evidence is reliable if it can be shown to be **replicable**, such that the same question addressed using the identical analysis against similar data yield similar results. For example, evidence generated from an analysis against an administative claims database from one large private insurer may be strengthened if replicated on claims data from a different insurer. In the context of population-level effect estimation, this attribute aligns well with Sir Austin Bradford Hill's causal viewpoint on consistency, "Has it been repeatedly observed by different persons, in different places, circumstances and times?...whether chance is the explanation or wehther a true hazard has been revealed may sometimes be answered only by a repetition of the circumstances and the observations." [@hill_1965] In the context of patient-level prediction, replicability highlights the value of external validation and the ability to evaluate performance of a model that was trained on one database by observing its discriminative accuracy and calibration when applied to a different database. In circumstances where identical analyses are performed against different databases and still show consistently similar results, we have further gain confidence that our evidence is **generalizable**. A key value of the OHDSI research network is the diversity represented by different populations, geographies and data capture processes. @madigan_2013 showed that effect estimates can be sensitive to choice of data. Recognizing that each data source carries with it inherent limitations and unique biases that limit our confidence in singular findings, there is tremendous power in observing similar patterns across heterogeneous datasets because it greatly diminishes the likelihood that source-specific biases alone can explain the findings. When network studies show consistent population-level effect estimates across multiple claims and EHR databases across US, Europe and Asia, they should be recognized as stronger evidence about the medical intervention that can have a broader scope to impact medical decision-making. 

Reliable evidence should be **robust**, meaning that the findings should not be overly sensitive to the subjective choices that can be made within an analysis. If there are alternative statistical methods that can be considered potentially reasonable for a given study, then it can provide reassurance to see that the different methods yield similar results, or conversely can give caution if discordant results are uncovered. [@madigan2013design] For population-level effect estimation, sensitivity analyses can include high-level study design choice, such as whether to apply a comparative cohort or self-controlled case series design, or can focus on analytical considerations embedded within a design, such as whether to perform propensity score matching, stratfication or weighting as a confounding adjustment strategy within the comparative cohort framework.  

Last, but potentially most important, evidence should be **calibrated**. It is not sufficient to have an evidence generating system that produces answers to unknown questions if the performance of that system cannot be verified. A closed system should be expected to have known operating characteristics, which should be able to measured and communicated as context for interpreting any results that the system produces. Statistical artifacts should be able to be empirically demonstrated to have well-defined properties, such as a 95% confidence interval having 95% coverage probability or a cohort with a predicted probability of 10% having a observed proportion of events in 10% of the population. An observational study should always be accompanied by study diagnostics that test assumptions around the design, methods, and data. These diagnostics should be centered on evaluating the primary threats to study validity: selection bias, confounding, and measurement error. Negative controls have been shown to be a powerful tool for identifying and mitigating systematic error in observational studies. [@schuemie_2016; @schuemie_2018; @schuemie_2018b]


## Understanding Evidence Quality

But how do we know if the results of a study are reliable enough? Can they be trusted for use in clinical settings? What about in regulatory decision-making? Can they serve as a foundation for future research? Each time a new study is published or disseminated, readers must consider these questions, regardless of whether the work was a randomized controlled trial, an observational study, or another type of analysis. \index{evidence quality} \index{regulatory decision-making}

One of the concerns that is often raised around observational studies and the use of "real world data" is the topic of data quality. [@botsis2010secondary; @hersh2013caveats; @sherman2016real] Commonly noted is that data used in observational research were not originally gathered for research purposes and thus may suffer from incomplete or inaccurate data capture as well as inherent biases. These concerns have given rise to a growing body of research around how to measure, characterize, and ideally improve data quality. [@kahn2012pragmatic; @liaw2013towards; @weiskopf_2013] The OHDSI community is a strong advocate of such research and community members have led and participated in many studies looking at data quality in the OMOP CDM and the OHDSI network. [@huser_multisite_2016; @kahn_transparent_2015; @callahan2017comparison; @yoon_2016] \index{data quality} \index{community}

Given the findings of the past decade in this area, it has become apparent that data quality is not perfect and never will be. This notion is nicely reflected in this quote from Dr. Clem McDonald, a pioneer in the field of medical informatics:


> Loss of fidelity begins with the movement of data from the doctor’s brain to the medical record. \index{Clem McDonald}


Thus, as a community we must ask the question -- *given imperfect data, how can we achieve reliable evidence?* 
 
The answer rests in looking holistically at "evidence quality": examining the entire journey from data to evidence, identifying each of the components that make up the evidence generation process, determining how to build confidence in the quality of each component, and transparently communicating what has been learned each step along the way. Evidence quality considers not only the quality of observational data but also the validity of the methods, software, and clinical definitions used in our observational analyses. \index{community} \index{reliable evidence}

In the following chapters, we will explore four components of evidence quality listed in Table \@ref(tab:evidenceQuality).

Table: (\#tab:evidenceQuality) The four components of evidence quality.

| Component of Evidence Quality | What it Measures                                                          |
|--------------------------------|-------------------------------------------------------------------------------------------------------------------|
| [Data Quality](DataQuality.html)         | Are the data completely captured with plausible values in a manner that is conformant to agreed-upon structure and conventions? |
| [Clinical Validity](ClinicalValidity.html)       | To what extent does the analysis conducted match the clinical intention?                          |
| [Software Validity](SoftwareValidity.html)       | Can we trust that the process transforming and analyzing the data does what it is supposed to do?                |
| [Method Validity](MethodValidity.html)       | Is the methodology appropriate for the question, given the strengths and weaknesses of the data?              |

## Communicating Evidence Quality

An important aspect of evidence quality is the ability to express the uncertainty that arises along the journey from data to evidence. The overarching goal of OHDSI's work around evidence quality is to produce confidence in health care decision-makers that the evidence generated by OHDSI -- while undoubtedly imperfect in many ways -- has been consistently measured for its weaknesses and strengths and that this information has been communicated in a rigorous and open manner.

## Summary

\BeginKnitrBlock{rmdsummary}<div class="rmdsummary">- The evidence we generate should be **repeatable**, **reproducible**, **replicable**, **generalizable**, **robust**, and **calibrated**.

- Evidence quality considers more than just data quality when answering whether evidence is reliable:
    - Data Quality
    - Clinical Validity
    - Software Validity
    - Method Validity

- When communicating evidence, we should express the uncertainty arising from the various challenges to evidence quality.
</div>\EndKnitrBlock{rmdsummary}













