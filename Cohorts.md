# Building the building blocks: cohorts {#Cohorts}

*Lead: Kristin Kostka*

Cohorts are used throughout OHDSI analytical tools and network studies as the primary building blocks for running high quality, systematic research. Cohort definitions vary from study to study depending on the research question of interest. Each cohort definition provides a specific way to represent a person with a condition or exposure using data in an observational health database. Thus, cohorts are an important component in documenting the methods of an observational research study. 

The chapter serves to explain what is meant by creating and sharing cohort definitions, the methods for developing cohorts, and how to build your own cohorts using ATLAS (for a detailed discussion on OHDSI Analytics Tools see Chapter \@ref(OhdsiAnalyticsTools)).

## Theory

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">**OHDSI Cohort:** set of persons who satisfy one or more inclusion criteria for a duration of time
**OHDSI Cohort Definition:** the description of inclusion criteria used for identifying a particular cohort</div>\EndKnitrBlock{rmdimportant}

In many peer-reviewed scientific manuscripts, a cohort is suggested to be analogous to a codeset of specific clinical codes (e.g. ICD-9/ICD-10, NDC, HCPCS, etc). While codesets are an important piece in assembling a cohort, a cohort definition is not simply a codeset. A cohort definition requires logic for how to use the codeset for the criteria. A well documented cohort specifies how a patient enters a cohort, a patient exits a cohort and any additional inclusion criteria that impacts how to observe a patient’s time-at-risk. 

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">The term *cohort* is often interchanged with the term phenotype. The term *phenotype* is applied to patient characteristics inferred from electronic health record (EHR) data [@Hripcsak7329]. The goal is to draw conclusions about a target concept based on raw EHR data, claims data, or other clinically relevant data. Thus, a *cohort* is a set of persons who satisfy one or more inclusion criteria (a phenotype) for a duration of time. A cohort in itself is not a phenotype but a phenotype can be used to create a cohort.</div>\EndKnitrBlock{rmdimportant}

There are two main approaches to constructing a cohort: **1) rules-based design** or **2) probabilistic design**. A rules-based cohort design relies heavily on the domain expertise of the individual designing the cohort to use their knowledge of the therapeutic area of interest to build rules for cohort inclusion criteria. Conversely, a probabilistic design mines already available data to identify and qualify potential cohort membership through machine-suggested patterns. The next sections will discuss these approaches in further detail.

### Rules-based cohort design

A rules-based OHDSI cohort definition begins with clinical expertise explicitly stating one or more inclusion criteria (e.g. “people with angioedema”) in a specific duration of time (e.g. “who developed this condition within the last 6 months”). 

When creating a cohort definition, you need to ask yourself the following questions:

- *What initial event(s) define cohort entry?*
- *What inclusion criteria are applied to the initial events?*
- *What defines a person’s cohort exit?*

To visualize the importance of these criteria, think of how this information comes together in a person’s timeline (Figure . The OBSERVATION_PERIOD table creates the window for which we see the person in the data.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/cohort-build} 

}

\caption{Cohort Creation}(\#fig:cohortBuild)
\end{figure}

*Cohort entry criteria:* The cohort entry event can be one or many clinical attributes which dictate an individual patient’s eligibility to be included in a cohort. Events are recorded time-stamped observations for the persons, such as drug exposures, conditions, procedures, measurements and visits. The event index date is set to be equal to the event start date. Initial events defined by a domain,concept set, as well as any domain-specific attributes. We will discuss these in detail in the further section. 

*Inclusion criteria:* The qualifying cohort will be defined as all persons who have an initial event and satisfy all qualifying inclusion criteria. Each inclusion criterion is defined by domain(s), concept set(s), domain-specific attributes, and the temporal logic relative to initial events. Each qualifying inclusion criterion can be evaluated to determine the impact of the criteria on the attrition of persons from the initial cohort.

*Cohort exit criteria:* The cohort exit event signifies when a person no longer qualifies for cohort membership. Cohort exit can be defined in multiple ways such as the end of the observation period, a fixed time interval relative to the initial entry event, the last event in a sequence of related observations (e.g. persistent drug exposure) or through other censoring of observation period. Cohort exit strategy will impact whether a person can belong to the cohort multiple times during different time intervals.

*Time-at-risk:* In order to interpret risk of a specific outcome, which will be defined as a separate cohort definition, it is necessary to know the length of time that applies. A time-at-risk criteria states the period of time in which the cohort must be in the data following the cohort entry criteria. The time-at-risk will vary based on whether you’re observing an acute/short term trend or a chronic/long term trend.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/cohort-TAR} 

}

\caption{Time-at-Risk Construction}(\#fig:cohortTar)
\end{figure}

In traditional study design, we would categorize time-at-risk for ‘on treatment’ as the entirety of the time between when a person meets cohort entry through the cohort exit criteria. An ‘intent-to-treat’ design would include the entire time period between cohort start and observation period end (e.g. when the person leaves the data for some reason cuh as switching physicians, insurance carriers, etc).

The use of these criteria may present a number of unique nuances to an OHDSI cohort including:

- One person may belong to multiple cohorts
- One person may belong to the same cohort for multiple different time periods
- One person may not belong to the same cohort multiple times during the same period of time
- A cohort may have zero or more members

Throughout the Book of OHDSI, we will detail how to address these consequences in your overall study design. In each respective methodology, we will discuss how you can configure a methods package to address how one person shows up in multiple cohorts being studied.

### Probabilistic cohort design using APHRODITE

Rules-based cohort design are a popular method for assembling cohort definitions. However, assembling necessary expert consensus to create a study cohort can be prohibitively time consuming. Probabilistic cohort design is an alternative, machine-driven method to expedite the selection of cohort attributes. In this method, supervised learning allows a phenotyping algorithm to learn from a set of labeled examples (cases) of what attributes contribute to cohort membership. This algorithm can then be used to better ascertain the defining characteristics of a phenotype and what trade offs occur in overall study accuracy when choosing to modify phenotype criteria.

To apply this approach on OMOP data, OHDSI community researchers created Automated PHenotype Routine for Observational Definition, Identification, Training and Evaluation (APHRODITE), an R-package cohort building framework that combines the ability of learning from imperfectly labeled data and the Anchor learning framework for improving selected features in the phenotype models, for use with the OHDSI/OMOP CDM [@Banda2017APHRODITE]. [APHRODITE](https://github.com/OHDSI/Aphrodite) is an open-source package (https://github.com/OHDSI/Aphrodite) available for use which provides the OHDSI data network to the ability to start building electronic phenotype models that leverage machine learning techniques and go beyond traditional rule based approaches to cohort building. 

## Phenotype Algorithm Evaluation

When you build a cohort, you may start from your own knowledgebase or you may choose to look at how other studies specify a similar cohort definition. A literature review of over 33 studies found significant heterogeneity in phenotype algorithms used, validation methods, and results [@Rubbo2015phenotypes]. In general, the validation of a rules-based cohort definition or probabilistic algorithm can be thought of as a test of the proposed cohort compared to some form of “gold standard” reference (e.g. manual chart review of cases). Making this comparison is best understood in a tabular view (Figure \@ref(fig:cohortPpv)).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/cohort-PPV} 

}

\caption{Algorithm Evaluation}(\#fig:cohortPpv)
\end{figure}

OHDSI researchers encourage to perform a complete evaluation of the phenotype algorithm (i.e., determining sensitivity, specificity, and positive predictive value (PPV) [@Swerdel2019phevaluator].  For a complete validation of an algorithm, we need to calculate:

$$
Sensitivity = \frac{True\ positives}{True\ positives+False\ negatives }
$$

$$
Specificity = \frac{True\ negatives}{True\ negatives+False\ positives }
$$

$$
Positive\ preditive\ value = \frac{True\ positives}{True\ positives+False\ positives }
$$

This framework continues to be utilized across cohort definition research to evaluate the utility of reuse of cohorts across different electronic health data. The PheValuator tool [@Swerdel2019phevaluator] is a recent addition to the OHDSI Community that provides a standard method to efficiently estimate a complete phentoype algorithm evaluation.

## OHDSI Gold Standard Phenotype Library

To further assist the community in the inventory and overall evaluation of existing cohort definitions and algorithms, the OHDSI Gold Standard Phenotype Library (GSPL) Workgroup was formed. The purpose of the GSPL workgroup is to provide additional leadership to the development of community-backed cohort libraries from rules-based and probabilistic methods. The GSPL enable members of the OHDSI community to find, evaluate, and utilize community-validated cohort definitions for research and other activities. These “gold standard” definitions will reside in a library, the entries of which are held to specific standards of design and evaluation. For additional information related to the GSPL, consult the OHDSI workgroup page (https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:gold-library-wg). Research within this workgroup includes APHRODITE [@Banda2017APHRODITE] and the PheValuator tool [@Swerdel2019phevaluator] , discussed in the prior section, as well as work done to share the Electronic Medical Records and Genomics [eMERGE](https://emerge.mc.vanderbilt.edu/) [Phenotype Library](https://phekb.org/phenotypes) across the OHDSI network [@Hripcsak2019eMERGE]. If phenotype curation is your interest, consider contributing to this workgroup.

## Practice

Now that we've covered the basics, it's time to put your cohort building skills to the test. *Note: If you've gotten lost on your OHDSI journey and not sure where to start, you can always return to Where to Begin ((Chapter \@ref(WhereToBegin)) to recall the way to translate a research question into an OHDSI standard analytics approach.*

When you are building a cohort, you should consider which of these is more important to you: *finding all the eligible patients?* **vs.** *Getting only the ones you are confident about?* 

Your strategy to construct your cohort will depend on your the clinical stringency of how your expert consensus defines the disease. This is to say, the right cohort design will depend on the question you’re trying to answer. You may opt to build a cohort definition that: uses everything you can get, uses the lowest common denominator so you can share it across OHDSI sites or is a compromise of the two. It is ultimately at the researcher’s discretion what threshold of stringency is necessary to adequately study the cohort of interest.

We begin to practice our cohort skills by putting together a cohort definition using a rules-based approach. In this example, we want to find *patients who initiate ACE inhibitors monotherapy as first-line treatments for hypertension* 

Recall, the components of building a cohort include:

- **Domain**: A Domain defines the set of allowable Concepts for the standardized fields in the CDM tables (refer to Chapter \@ref(CommonDataModel)). (Ex:  Condition, Drug, Procedure, Measurement)
- **Concept set**: An expression that defines one or more concepts encompassing a clinical entity of interest (Ex: Concepts for type II diabetes,  concepts for antidiabetic drugs)
- **Domain-specific attribute**:  Ex:  DRUG_EXPOSURE: Days supply;  MEASUREMENT:  value_as_number, high_range
- **Temporal logic**:  the time intervals within which the relationship between an inclusion criteria and an event is evaluated (Ex: Indicated condition must occur during 365d prior to or on exposure start)

As you are building your cohort definition, you may find it helpful to think of OMOP domains analogous to building blocks (see Figure \@ref(fig:cohortLegos) that represent cohort attributes. You can always refer to the Common Data Model chapter (Chapter \@ref(CommonDataModel)) for help.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{images/Cohorts/cohort-legos} 

}

\caption{Building Blocks of Cohorts}(\#fig:cohortLegos)
\end{figure}

With this context in mind, we are now going to build our cohort. As we go through this exercise, we will approach building our cohort similar to standard attrition chart. Figure \@ref(fig:CohortPractice) shows the logical framework for how we want to build this cohort.
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/CohortPractice} 

}

\caption{Logical Diagram of Intended Cohort}(\#fig:CohortPractice)
\end{figure}

You can build a cohort in the user interface of ATLAS or you can write a query directly against your OMOP CDM. We will briefly discuss both in this chapter.

### Using ATLAS

We can build a cohort using the ATLAS interface. To begin in ATLAS, click on the 'Cohort Definition' module (located on the left hand panel fifth selection from the top as seen in Figure \@ref(fig:ATLAScohort)).

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{images/Cohorts/ATLAS-cohort} 

}

\caption{Navigating to ATLAS Cohort Definition module}(\#fig:ATLAScohort)
\end{figure}

When the module loads, click on the blue botton on the right that says 'New Cohort' (Figure \@ref(fig:ATLASnewcohort).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-newcohort} 

}

\caption{Navigating to ATLAS New Cohort button}(\#fig:ATLASnewcohort)
\end{figure}

The next screen you will see will be an empty cohort definition. Figure \@ref(fig:ATLASdefineacohort) shows what you will see on your screen.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-defineacohort} 

}

\caption{New Cohort Definition}(\#fig:ATLASdefineacohort)
\end{figure}

Before you do anything else, you are encouraged to change the name of the cohort from *New Cohort Definition* to your own unique name for this cohort. You may opt for a name like *New users of ACE inhibitors as first-line monotherapy for hypertension*.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">ATLAS will not allow two cohorts to have the same exact names. ATLAS will give you a pop-up error message if you choose a name already used by another ATLAS cohort.</div>\EndKnitrBlock{rmdimportant}
Once you have chosen a name, you can save the cohort by clicking the green floppy-disk icon. Now we can proceed with defining the initial cohort event. You will click to add to 'Add an Initial Event'. You now have to pick which domain you are building a criteria around. You may ask yourself, *how do I know which domain is the initial cohort event?* Let's figure that out.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-initialevent} 

}

\caption{Adding an Initial Event}(\#fig:ATLASinitialevent)
\end{figure}

As we see in Figure \@ref(fig:ATLASinitialevent), ATLAS provides descriptions below each criteria to help you. If we were building a CONDITION_OCCURRENCE based criteria, our question would be looking for patients with a specific diagnosis. If we were building a DRUG_EXPOSURE based criteria, our question would be looking for patients with a specific drug or drug class. Since we want to find *patients who initiate ACE inhibitors monotherapy as first-line treatments for hypertension*, we want to choose a DRUG_EXPOSURE criteria. You may say, *but we also care about hypertension as a diagnosis*. You are correct. Hypertension is another criteria we will build. However, eligibility to enter this cohort is predicated on being a new-user of ACE inhibitor monotherapy. The diagnosis of hypertension is what we call an *additional qualifying criteria*. We will return to this once we build this criteria. We will click to add a DRUG_EXPOSURE criteria (Figure \@ref(fig:ATLASdrugexposure)).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-drugexposure} 

}

\caption{Building a Drug Exposure Criteria}(\#fig:ATLASdrugexposure)
\end{figure}

The screen will update with your selected criteria but you are not done yet. You now need to tell ATLAS which concept set you want to associate with this DRUG_EXPOSURE criteria. You will need to click the down arrow to open the dialogue box to import a concept set (Figure \@ref(fig:ATLASimportconcept).
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-importaconcept} 

}

\caption{Specifying a Concept Set - Step 1}(\#fig:ATLASimportconcept)
\end{figure}

**Scenario 1: You have not built a concept set.** If you have not assembled your concept sets to retrieve to apply to your criteria, you will need to do this before you move forward. At a very basic level, this will require you to utilize the *Search* function to find and choose the concepts you would like to specify. You can refer back to (see Chapter \@ref(StandardizedVocabularies)) on how to navigate the OMOP vocabularies to find clinical concepts of interest. This chapter will not focus on the assembly of concept sets. You are encouraged to utilize the [OHDSI Resources](https://www.ohdsi.org/resources/) to find ATLAS tutorials that can help you understand how to search and build a concept set.


**Scenario 2: You have already built a concept set.** If you have already created a concept set and saved it in ATLAS, you can click to *'Import a Concept Set'* where you will be prompted to find your concept in the concept set repository of your ATLAS (Figure \@ref(fig:ATLASfindyourconcept)).
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-findingyourconcept} 

}

\caption{Specifying a Concept Set - Step 2}(\#fig:ATLASfindyourconcept)
\end{figure}

In the above example, the user typed in the name given to this concept set *'ace inhibitors'* in the right hand search. This shortened the concept set list to only concepts with matching names. From there, the user can click on the row of the concept set to select it. *(Note: the dialogue box will disappear once you have selected a concept set.)* You are not done **yet**. Your question is looking for new users or the first time in someone's history they are exposed to ACE inhibitors. You need to specify this by clicking to *'Add attribute'*  (Figure \@ref(fig:ATLASfirstexposure)).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-firstexposure} 

}

\caption{Adding Attribute to Initial Criteria - Step 1}(\#fig:ATLASfirstexposure)
\end{figure}

You will want to select the *First Exposure Criteria*  (Figure \@ref(fig:ATLASfirsttimeever)). From there, the window will automatically close. Notice, you could specify other attributes of a criteria you build. You could specify an attribute of age at occurrence, the date of occurrence, gender or other attributes related to the drug. Criteria available for selection will look different for each domain.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-firsttimeever} 

}

\caption{Adding Attribute to Initial Criteria - Step 2}(\#fig:ATLASfirsttimeever)
\end{figure}

Once selected, this additional attribute will show up in the same box as the initial criteria. 
\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">The current design of ATLAS may confuse some. Despite its apperance, the red X is not intended to mean "No". It is an actionable feature to allow the user to delete the criteria. If you click the red X, this criteria will go away. Thus, you need to leave the criteria with the red X to keep the criteria active.</div>\EndKnitrBlock{rmdimportant}

Now you have built an initial qualifying event. To ensure you are capturing the first exposure, you will want to add a lookback window to know that you are looking at enogh of the patient's histroy to know what comes first. You can do this by adjusting the continuous observation drop downs. You could also click the box and type in a value to these windows. To ensure this is the first exposure in the patient's history, we add a lookback of 365 days. The lookback window is the discretion of your study team. You may choose differently in other cohorts. This creates, as best as we are able, a minimum period of time we see the patient to ensure we are capturing the first record. We then also opt limit it to the earliest event per person (Figure \@ref(fig:ATLASlookback)).


\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-lookback} 

}

\caption{Adjusting the Observation Period}(\#fig:ATLASlookback)
\end{figure}

By now, you may be confused. *Why do I add a first ever criteria in addition to limit to the earliest event?* You can think about this logically by thinking about assembling patient timelines.

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/EarliestEventExplained} 

}

\caption{Patient Eligibility by Criteria Applied}(\#fig:EarliestEventExplained)
\end{figure}

In Figure \@ref(fig:EarliestEventExplained), each line represents a single patient that may be eligible to join the cohort. The filled in stars represent a time the patient fulfills the specified criteria. As additional criteria is applied, you may see some stars are a lighter shade. This means that these patients have other records that satisfy the criteria but there is another record that proceeds that. By the time we get to the last criteria, we are looking at the cumulative view of patients who have ACE inhibitors for the first time and have 365 days prior to the first time occurrence. This means that if we limit to the earliest event, it must fulfil **all** three criteria (drug exposure, first time in patient's history and lookback window) and it is the earliest occurrence of all three critera being met. If that still feels confusing, you are not alone. This is one of the most challenging features of ATLAS that tends to trip up researchers. When you are building your own cohorts, you may opt to engage the Researchers section of the [OHDSI Forum](http://forums.ohdsi.org) to get a second opinion on how to construct your cohort logic. 

Once we have specified a cohort entry event, you could proceed to one of two places to add your additional qualifying events: *Restrict Initial Events* and *Inclusion Criteria*. The fundamental difference between these two options is what interim information you want ATLAS to serve back to you. If you add additional qualifying criteria into the Cohort Entry Event box by selecting *Restrict Initial Events*, when you choose to generate a count in ATLAS, you will only get back the number of people who meet ALL of these criteria. If you opt to add criteria into the *Inclusion Criteria*, you will get an attrition chart to show you how many patients are lost by applying additional inclusion criteria. It is highly encouraged to utilize the Inclusion Criteria section so you can understand the impact of each rule on the overall success of the cohort definition. You may find a certian inclusion criteria severely limits the number of people who end up in the cohort. You may choose to relax this criteria to get a larger cohort. This will ultimately be at the discretion of the expert consensus assembling this cohort.

You will now want to click 'New Inclusion Criteria' to add a subsequent piece of logic about membership to this cohort. The functionality in this section is identical to the way we discussed building cohort criteria above. You may specific the criteria and add specific attributes. Our first additional criteria is to subset the cohort to only patients: *With at least 1 occurrence of hypertension disorder between 365 and 0 days after index date (first initiation of an ACE inhibitor)*. Now check your logic against Figure \@ref(fig:ATLASIC1).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-IC1} 

}

\caption{Additional Inclusion Criteria 1}(\#fig:ATLASIC1)
\end{figure}

You will then want to add another criteria to look for patients: *with exactly 0 occurrences of hypertension drugs all days before and 1 day before index start date (no exposure to HT drugs before an ACE inhibitor)*. Now check your logic against Figure \@ref(fig:ATLASIC2).

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-IC2} 

}

\caption{Additional Inclusion Criteria 2}(\#fig:ATLASIC2)
\end{figure}

You may be confused why "having no occurrences" is coded as "exactly 0 occurrences." This is a nuance of how ATLAS consumes knowledge. ATLAS only consumes inclusion criteria. You must use logical operators to indicate when you want the absence of a specific attribute such as: "Exactly 0." Over time you will become more familiar with the logical operators available in ATLAS criteria. 

Lastly, you will want to add your another criteria to look for patients: *with exactly 1 occurrence of hypertension drugs between 0 days before and 7 days after index start date AND can only start one HT drug (an ACE inhibitor)*  Now check your logic against Figure \@ref(fig:ATLASIC3).
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-IC3} 

}

\caption{Additional Inclusion Criteria 3}(\#fig:ATLASIC3)
\end{figure}

You have now added all of your qualifying inclusion criteria. You must now specify your cohort exit criteria. You will ask yourself, *when are people no longer eligible to be included in this cohort?"* In this cohort, we are following new-users of a drug exposure. We want to look at continuous observation period as it relates to the drug exposure. As such, the exit criteria is specified to follow for the entirety of the continuous drug exposure. If there is a subsequent break in the drug exposure, the patient will exit the cohort at this time. We do this  as we cannot determine what happened to the person during the break in the drug exposure. We can also set a criteria on the persistence window to specify an "allowable" gap between drug exposures. In this case, our experts leading this study concluded that a maximum of 30 days between exposure records is allowable when inferring the era of persistence exposure. 

*Why are gaps allowed?* In some data sets, we see only portions of clinical interactions. Drug exposures, in particular, may represent a dispense of a prescription that can cover a certain period of time. Thus, we allow a certain amount of time between drug exposures as we know the patiet may logically still have access to the initial drug exposure because the unit of dispense exceeded one day. 

We can configure this by selecting the Event will persist *until the end of a drug exposure*. We then will add our persistence window and append the concept set for ACE inhibitors. Now check your logic against Figure \@ref(fig:ATLAScohortexit).
\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{images/Cohorts/ATLAS-cohortexit} 

}

\caption{Cohort Exit Criteria}(\#fig:ATLAScohortexit)
\end{figure}

In the case of this cohort, there are no other censoring events. However, you may build other cohorts where you need to specify this criteria. You would proceed similarly to the way we have added other attributes to this cohort definition. You have now successfully finished creating your cohort. Congratulations! Building a cohort is the most important building block of answering a question in the OHDSI tools. You can now use the Export tab to share your cohort definiton to other collaborators in the form of code or JSON files to load into ATLAS. For more information on how to utilize ATLAS, you can always return to [OHDSI Resources](https://www.ohdsi.org/resources/) to find short videos on basic cohort building tasks in ATLAS.


### Cohort Building at the Database Layer Using SQL

While it is encouraged to use the OHDSI analytical tools to build and share cohorts, you may not have an instance of ATLAS available in your local environment. If you do not have ATLAS, you can still build a cohort. You may query a database directly using your preferred SQL dialect. A detailed discussion of how to write SQL against the OMOP CDM is available in Chapter \@ref(SqlAndR)). As you become more familiar with OHDSI code, you are encouraged to utilize [SQL Render](https://github.com/OHDSI/SqlRender) to render parameterized SQL. SQL Render will easily translate your query into other SQL dialects. This makes it a lot easier to share cohort definition across other OHDSI network sites. Even without ATLAS, you can work with other OHDSI collaborators who use ATLAS to create their cohort definition. Cohorts built in ATLAS can also be exported into your preferred SQL dialect. 

## Summary

\BeginKnitrBlock{rmdsummary}<div class="rmdsummary">- An **OHDSI cohort** is set of persons who satisfy one or more inclusion criteria for a duration of time.
- The **OHDSI Cohort Definition** is the description of inclusion criteria used for identifying a particular cohort.
- Building a cohort is a fundamental piece of using the OHDSI Analytics Tools.
- There are two major approachs to building a cohort (rules-based vs probabilistic).
- The OHDSI community has a variety of resources available to support you as you're building your own cohorts including short videos of ATLAS functionality, a ready-to-use probabilistic machine-learning package (APHRODITE) to run on your OMOP CDM and even a freely available tool to evaluate the sensitivity and specificity of your cohort (PheValuator).
</div>\EndKnitrBlock{rmdsummary}

### Exercises
(Need help on syntax for how we format these... can you point me to a good example of an exercise in the BoO?)
