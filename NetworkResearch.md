# OHDSI Network Research {#NetworkResearch}

*Chapter leads: Kristin Kostka, Greg Klebanov & Sara Dempster*

The mission of OHDSI is to generate high-quality evidence through observational research. A primary way this is accomplished is through collaborative research studies. In prior chapters we discussed how the OHDSI community has authored standards and tools to facilitate high-quality, reproducible research, including OMOP Standardized Vocabularies, the Common Data Model (CDM), analytical methods packages, ATLAS and the study steps (Chapter \@ref(StudySteps)) to run a retrospective database study. OHDSI network studies represent the culmination of a transparent, consistent and reproducible way to conduct research across a large number of geographically dispersed data. In this chapter we will discuss what constitutes an OHDSI network study, how to run a network study and discuss enabling technologies such as the ARACHNE Research Network.

##  OHDSI as a Research Network

\index{research network}

The OHDSI research network is an international collaboration of researchers seeking to advance observational data research in healthcare. Today, the network consists of over 100 databases standardized to the OMOP common data model, collectively representing over 1 billion patient records.  OHDSI is an open network, inviting healthcare institutions across the globe with patient-level data to join the network by converting data to the OMOP CDM and participating in network research studies. As data conversions are complete, collaborators are invited to report site information in the Data Network census maintained by the [OHDSI Program Manager](mailto:contact@ohdsi.org). Each OHDSI network site participates voluntarily. There are no hard obligations. Each site opts-in to each respective network study. In each study, data remains at the site behind a firewall.  No patient-level data pooling occurs across network sites. **Only aggregate results are shared.**

\BeginKnitrBlock{rmdimportant}
**Benefits of a Data Owner Joining the OHDSI Network**

- **Access to free tools:** OHDSI publishes free, open source tools for data characterization and standardized analytics (e.g. browsing the clinical concepts, defining and characterizing cohorts, running Population-Level Estimation and Patient-Level Prediction studies).
- **Participate in a premier research community:** Author and publish network research, collaborate with leaders across various disciplines and stakeholder groups.
- **Opportunity to benchmark care:** Network studies can enable clinical characterization and quality improvement benchmarks across data partners.

\EndKnitrBlock{rmdimportant}

## OHDSI Network Studies

\index{network study}

In the prior chapter (Chapter \@ref(StudySteps)), we discussed general design considerations for running a study using the CDM.  In general, a study may be conducted on a single CDM or on multiple CDMs. It can be run within a single institution’s CDM data or across many institutions. In this section we will discuss why you may want to expand your analyses across multiple institutions into a network study.

### Motivations for Conducting an OHDSI Network Study

A typical use case for observational studies is to examine the comparative effectiveness or safety of a treatment in a “real world” setting.  More specifically, you may aim to replicate a clinical trial in a post-market setting to address concerns about generalizability of findings from a clinical trial.  In other scenarios, you may want to run a study comparing two treatments that have never been compared in a clinical trial because one treatment is being used off-label.  Or you may need to study a rare post-market safety outcome that a clinical trial was underpowered to observe. To address these research questions, it may not be sufficient to run a single observational study in one or even two databases at your site because you are getting an answer that is meaningful in the context of a particular group of patients only.

The results of an observational study can be influenced by many factors that vary by the location of the data source such as adherence, genetic diversity, or environmental factors, overall health status: factors that may not have been possible to vary in the context of a clinical trial even if one exists for your same study question. A typical motivation to run an observational study in a network is therefore to increase the diversity of data sources and potentially study populations to understand how well the results generalize.  In other words, can the study findings be replicated across multiple sites or do they differ and if they differ, can any insights be gleaned as to why?

Network studies, therefore, offer the opportunity to investigate the effects of “real world” factors on observational studies’ findings by examining a broad array of settings and data sources.

### Definition of an OHDSI Network Study

\BeginKnitrBlock{rmdimportant}
**When is a study considered a *network* study?** An OHDSI study becomes an OHDSI network study when it is run across multiple CDMs at different institutions.
\EndKnitrBlock{rmdimportant}
The OHDSI approach to network research uses the OMOP CDM and standardized tools and study packages which fully specify all parameters for running a study. OHDSI standardized analytics are designed specifically to reduce artifacts and improve the efficiency and scalability of network studies.

Network studies are an important part of the OHDSI research community. However, there is no mandate that an OHDSI study be packaged and shared across the entire OHDSI network. You may still conduct research using the OMOP CDM and OHDSI methods library within a single institution or limit a research study to only select institutions. These research contributions are equally important to the community. It is at the discretion of each investigator whether a study is designed to run on a single database, conduct a study across a limited set of partners or open the study to full participation the OHDSI network. This chapter intends to speak to the open-to-all network studies that the OHDSI community conducts.

**Elements of an *Open* OHDSI Network Study:**
When conducting an open OHDSI network study, you are committing to fully transparent research. There are a few components that make OHDSI research unique. This includes:

- All documentation, study code and subsequent results are made publicly available on the OHDSI GitHub.
- Investigators must create and publish a public study protocol detailing the scope and intent of the analysis to be performed.
- Investigators must create a study package (typically with R or SQL) with code that is CDM compliant.
- Investigators are encouraged to attend OHDSI Community Calls to promote and recruit collaborators for their OHDSI network study.
- At the end of the analysis, aggregate study results are made available in the OHDSI GitHub.
- Where possible, investigators are encouraged to publish study R Shiny Applications to [data.ohdsi.org](http://data.ohdsi.org).

In the next section we will talk about how to create your own network study as well as the unique design and logistical considerations for implementing a network study.

### Design Considerations for an OHDSI Network Study

\index{design considerations for network research}

Designing a study to run across the OHDSI network requires a paradigm shift in how you design and assemble your study code. Ordinarily, you may design a study with a target data set in mind. In doing so, you may write code relative to what you know to be true in the data you are utilizing for your analysis. For example, if you were assembling an angioedema cohort you may opt to pick only concept codes for angioedema that are represented in your CDM. This may be problematic if your data are in a specific care setting (e.g. primary care, ambulatory settings) or specific to a region (e.g. US-centric). Your code selections might be biasing your cohort definition.

In an OHDSI network study, you are no longer designing and building a study package just for your data. You are building a study package to be run across multiple sites across the globe. You will never see the underlying data for participating sites outside of your own institution. OHDSI network studies only share results files. Your study package can only collect what data that is available in the domains of the CDM. You will need an exhaustive approach to concept set creation to represent the diversity of care settings that observational health data are captured. OHDSI study packages often use the same cohort definition across all sites. This means that you must think holistically to avoid biasing a cohort definition to only represent a subset of eligible data (e.g. claims-centric data or EHR-specific data) in the network. You are encouraged to write an exhaustive cohort definition that can be ported across multiple CDMs. OHDSI study packages use the same set of parameterized code across all sites -- with only minor customizations for connecting into the database layer and storing local results. Later on, we will discuss the implications for interpreting clinical findings from diverse datasets.

In addition to clinical coding variation, you will need to design anticipating variations in the local technical infrastructure. Your study code will no longer be running in a single technical environment. Each OHDSI network site makes its own independent choice of database layer. This means that you cannot hard-code a study package to a specific database dialect. The study code needs to be parameterized to a type of SQL that can be easily modified to the operators in that dialect. Fortunately, the OHDSI Community has solutions such as ATLAS, [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/), and [SqlRender](https://ohdsi.github.io/SqlRender/) to help you generalize your study package for CDM compliance across different database dialects. OHDSI investigators are encouraged to solicit help from other network study sites to test and validate the study package can be executed in different environments. When coding errors come up, OHDSI Researchers can utilize the [OHDSI Forums](http://forums.ohdsi.org) to discuss and debug packages.

### Logistical Considerations for an OHDSI Network Study

\index{logistics of network research}

OHDSI is an open science community, and the OHDSI central coordinating center provides a community infrastructure to allow its collaborators to lead and participate in community research.  Every OHDSI network study requires a lead investigator, and that can be any collaborator across the OHDSI community.  OHDSI network studies require coordination between the lead investigator, collaborating researchers, and participating network data partners. Each site must perform its own due diligence to ensure the study protocol is approved and authorized to be executed on the local CDM, if requred. Data analysts may need to enlist assistance from the local IT team to enable appropriate permissions to run the study. The size and scope of the study team at each site will be a function of the size and complexity of the proposed network study as well as the maturity of the site’s adoption of the OMOP CDM and OHDSI tool stack.  The level of experience that a site has with running an OHDSI network study will also impact the personnel required.

For each study, site start-up activities may include:

- Registering the study with the Institutional Review Board (or equivalent), if required
- Receiving Institutional Review Board approval to execute the study, if required
- Receiving database level permissions to read/write a schema to the approved CDM
- Ensuring configuration of a functional RStudio environment to execute the study package
- Reviewing the study code for any technical anomalies
- Working with a local IT team to permit and install any dependent R packages needed to execute the package within technical constraints

\BeginKnitrBlock{rmdimportant}
**Data Quality and Network Studies:** As discussed in Chapter \@ref(ExtractTransformLoad), quality control is a fundamental and iterative piece of the ETL process. This should be done regularly outside of the network study process. For a network study, a study lead may ask to review participating site's data quality reports or design custom SQL queries to understand potential variation in contributing data sources. For more detail on the data quality efforts going on within OHDSI, please see Chapter \@ref(DataQuality).
\EndKnitrBlock{rmdimportant}

Each site will have a local data analyst who executes the study package. This individual must review the output of the study package to ensure no sensitive information is transmitted, although all the data in CDM had been already de-identified. When you are using pre-built OHDSI methods such as Population-Level Effect Estimation (PLE) and Patient Level Prediction (PLP), there are configurable settings for the minimum cell count for a given analysis. The data analyst is required to review these thresholds and ensure it follows local governance policies.

When sharing study results, the data analyst must comply with all local governance policies, inclusive of method of results transmission and adhering to approval processes for external publication of results. **OHDSI network studies do not share patient-level data.** In other words, patient level data from different sites is never pooled in a central environment. Study packages create results files designed to be aggregate results (e.g. summary statistics, point-estimates, diagnostic plots, etc.) and do not share patient-level information. Many organizations do not require data sharing agreements be executed between the participating study team members. However, depending on the institutions involved and the data sources, it may be necessary to have more formal data sharing agreements in place and signed by specific study team members. If you are a data owner interested in participating in network studies, you are encouraged to consult your local governance team to understand what policies are in place and must be fulfilled to join OHDSI community studies.

## Running an OHDSI Network Study

\index{running network research}

Running an OHDSI Network Study has three general distinct stages:

- Study design and feasibility
- Study execution
- Results dissemination and publication

### Study Design and Feasibility

The study feasibility stage *(or the pre-study stage)* defines a study question and describes the process to answer this question via the study protocol. This stage focuses on assessing the feasibility of executing the study protocol across participating sites.

The outcome of the feasibility stage is the generation of a finalized protocol and study package that is published ready for network execution. The formal protocol will detail the study team, including the designated study lead (often the corresponding author for publication purposes), and information on the timeline for the study. The protocol is a critical component for additional network sites to review, approve and execute the full study package on their CDM data. A protocol must include information on study population, the methods being used, how the results will be stored and analyzed as well as how the study results will be disseminated after completion (e.g. a publication, presentation at scientific conference, etc.).

The feasibility stage is not a well-defined process. It is a series of activities that are highly dependent on the type of study proposed. At a minimum, the study lead will spend time identifying relevant network sites that contain the targeted patient population(s) with required drug exposure, procedure information, condition or demographics information. Where possible, the study lead should provisionally use their own CDM to design the target cohorts. However, there is no requirement that a study lead have access to a live OMOP CDM with real patient data to run a network study. The study lead may design their target cohort definition using synthetic data (e.g. CMS Synthetic Public Use Files, SyntheticMass from Mitre or Synthea) and ask collaborators at OHDSI network sites to help with validating the feasibility of this cohort. Feasibility activities may include asking collaborators to create and characterize cohorts using JSON files of cohort definitions from ATLAS or testing study R packages and running initial diagnostics as discussed in Chapter \@ref(StudySteps). At the same time, the study lead may need to initiate any organization-specific processes to approve an OHDSI study at the organizing institution, if required – such internal Institutional Review Board approval. It is the responsibility of the study lead to complete these organization-specific activities during the feasibility phase.

### Study Execution

After completing feasibility exercises, the study advances to the execution phase. This period represents when OHDSI network sites can opt-in to participate in the analysis. This phase is when the design and logistical considerations we discussed become most important.

A study will move to execution when the study lead reaches out to the OHDSI community to formally announce a new OHDSI network study and formally begins recruiting participating sites. The study lead will publish the study protocol to the OHDSI GitHub. The study lead will announce the study on the weekly OHDSI Community Call and [OHDSI Forum](http://forums.ohdsi.org), inviting participating centers and collaborators.  As sites opt-in to participate, a study lead will communicate directly with each site and provide information on the GitHub repository where the study protocol and code are published as well as instructions on how to execute the study package. Ideally, a network study will be performed in parallel by all sites, so the final results are shared concurrently ensuring that no site’s team members are biased by knowledge of another team’s findings.

At each site, the study team will ensure the study follows institutional procedures for receiving approval to participate in the study, execute the package and share results externally. This will likely include receiving Institutional Review Board (IRB) exemption or approval or equivalent for the specified protocol. When the study is approved to run, the site data scientists/statisticians will follow the study lead’s instructions to access the OHDSI study package and generate results in the standardized format following OHDSI guidelines. Each participating site will follow internal institutional processes regarding data sharing rules. Sites should not share results unless approval or exemption is obtained from IRB or other institutional approval processes.

The study lead will be responsible for communicating how they want to receive results (e.g. via SFTP or a secure Amazon S3 bucket) and the time-frame for turning around results. Sites may specify if the method of transmission is out of compliance with internal protocol and a workaround may be developed accordingly.

During the execution phase, the collective study team (inclusive of the study lead and participating site teams) may iterate on results, if reasonable adjustments are required. If the scope and extent of the protocol evolve beyond what is approved, it is the responsibility of the participating site to communicate this to their organization by working with the study lead to update the protocol then resubmit the protocol for review and re-approval by the local IRB.

It is ultimately the responsibility of the study lead and any supporting data scientist/statistician to perform the aggregation of results across centers and perform meta-analysis, as appropriate. The OHDSI community has validated methodologies to aggregate results files shared from multiple network sites into a single answer. The [EvidenceSynthesis](https://github.com/OHDSI/EvidenceSynthesis) package is a freely available R package containing routines for combining evidence and diagnostics across multiple sources, such as multiple data sites in a distributed study. This includes functions for performing meta-analysis and forest plots.

The study lead will need to monitor site participation and help eliminate barriers in executing the package by regularly checking in with participating sites. Study execution is not one-size-fits-all at each site. There may be challenges related to the database layer (e.g. access rights / schema permissions) or analytics tool in their environment (e.g. unable to install required packages, unable to access databases through R, etc.). The participating site will be in the driver’s seat and will communicate what barriers exist to executing the study. It is ultimately the discretion of the participating site to enlist appropriate resources to help resolve issues encountered in their local CDM.

While OHDSI studies can be executed rapidly, it is advised to allow for a reasonable amount of time for all participating sites to execute the study and receive appropriate approvals to publish results. Newer OHDSI network sites may find the first network study they participate in to be longer than normal as they work through issues with environment configuration such as database permissions or analytics library updates. Support is available from the OHDSI Community. Issues can be posted to the [OHDSI Forum](http://forums.ohdsi.org) as they are encountered.

A study lead should set study milestones in the protocol and communicate anticipated closure date in advance to assist with managing the overall study timeline. If the timeline is not adhered to, it is the responsibility of the study lead to inform participating sites of updates to the study schedule and manage the overall progress of study execution.

### Results Dissemination and Publication

During the results dissemination and publication phase, the study lead will collaborate with other participants on various administrative tasks, such as manuscript development and optimizing data visualizations. Once the study is executed and results are stored centrally for the study lead to further analyze. The study lead is responsible for the creation and dissemination of full study results (e.g. a Shiny Application) for review by participating centers. If the study lead is using an OHDSI study skeleton, either generated by Atlas or manually modified from the GitHub code, the Shiny Application will be automatically created. In the event a study lead is creating custom code, the study lead may use the OHDSI Forum to ask for help to create their own Shiny Application for their study package.

\BeginKnitrBlock{rmdimportant}
Not sure where to publish your OHDSI network study? Consult JANE (Journal/Author Name Estimator), a tool which takes your abstract and scans publications for relevance and fit.[^janeUrl]

\EndKnitrBlock{rmdimportant}

[^janeUrl]: http://jane.biosemantics.org/

As manuscripts are written, each participating collaborator is encouraged to review and ensure the output follows external publication processes. At a minimum, the participating site should designate a publication lead -- this individual will ensure that internal processes are adhered to during the manuscript preparation and submission. The choice of which journal to submit a study to is at the discretion of the study lead, though should be the results of collaborative discussion at the onset of a study.  All co-authors on OHDSI studies are expected to satisfy ICMJE authorship guidelines.[^icmjeUrl] The presentation of results may occur in any forum of their choosing (e.g. an OHDSI Symposium, another academic proceeding or in a journal publication).  Researchers are also invited to present OHDSI Network Studies on weekly OHDSI community calls and at OHDSI Symposia across the globe.

[^icmjeUrl]: http://www.icmje.org/recommendations/browse/roles-and-responsibilities/defining-the-role-of-authors-and-contributors.html

## Forward Looking: Using Network Study Automation

\index{arachne}

The current network study process is manual -- with study team members using various mechanisms (including Wiki, GitHub and email) to collaborate on study design, sharing code and results. This process is not consistent and scalable and to solve that issue, the OHDSI community is actively working to systemize study processes.

\begin{figure}[h]

{\centering \includegraphics[width=0.9\linewidth]{images/NetworkStudies/ARACHNE} 

}

\caption{The ARACHNE Network Study Process.}(\#fig:arachne)
\end{figure}

ARACHNE is a platform that is designed to streamline and automate the process of conducting network studies. ARACHNE uses OHDSI standards and establishes a consistent, transparent, secure and compliant observational research process across multiple organizations. ARACHNE standardizes the communication protocol to access the data and exchange analysis results, while enabling authentication and authorization for restricted content. It brings participating organizations - data providers, investigators, sponsors and data scientists - into a single collaborative study team and facilitates an end-to-end observational study coordination. The tool enables the creation of a complete, standards-based R, Python and SQL execution environment including approval workflows controlled by the data custodian.

ARACHNE is built to provide a seamless integration with other OHDSI tools, including ACHILLES reports and an ability to import ATLAS design artifacts, create self-contained packages and automatically execute those across multiple sites. The future vision is to eventually enable multiple networks to be linked together for the purpose of conducting research not only between organizations within a single network, but also between organizations across multiple networks.

\begin{figure}[h]

{\centering \includegraphics[width=0.9\linewidth]{images/NetworkStudies/ARACHNENON} 

}

\caption{The ARACHNE Network of Networks.}(\#fig:arachneNon)
\end{figure}

## Best Practice for OHDSI Network Studies

\index{best practice for network research}

As you are conducting a network study, the OHDSI community is available to assist you in ensuring you adhere to best practice for OHDSI Network studies.

**Study Design and Feasibility:** When running a network study, make sure that you are not biasing your study design to a single type of data. The task of harmonizing the cohort definitions to represent consistent populations across all the sites may be more or less involved depending on the how heterogeneous the data types are and how carefully the study site followed all standardized conventions for converting data to the OMOP CDM. The reason that this is so critical is the need to control differences in data capture, representation and transformation across network sites versus those that are clinically meaningful. In particular, for comparative effectiveness studies, challenges can arise in ensuring concordant exposure cohorts and outcome cohort definitions across the sites. For example, drug exposure information can come from various data sources which may vary in their potential for misclassification. A pharmacy dispensing claim from a health insurance plan may be adjudicated meaning that when there is a claim for a medication, there is a very good chance that the person filled the prescription order. However, a prescription order entered into an EHR may be all that is available, without linkage to other data to determine whether the order was dispensed or consumed.  There may be a time gap between the record of a physician writing a prescription order, the time when the pharmacist dispensed the prescription, the time when the patient picked up their medication at the pharmacy, and the time when the patient actually consumed her first pill.  This measurement error can potentially bias results across any analytic use case. Thus, it is important to perform study feasibility to evaluate the appropriateness of database participation when developing the study protocol.

**Study Execution:** Where possible, study leads are encouraged to utilize ATLAS, the OHDSI Methods Library and OHDSI Study Skeletons to create study code that used standardized analytics packages as much as possible. Study code should always be in a CDM compliant, database layer agnostic way using OHDSI packages. Be sure to parameterize all functions and variables (e.g. do not hard database connection, local hard drive path, assume a certain operating system). When recruiting participating sites, a study lead should ensure that each network site is CDM compliant and regularly updates the OMOP standardized vocabularies. A study lead should perform due diligence to ensure with each network site has performed and documented data quality checks on their CDM (e.g. ensuring ETL has followed THEMIS business rules and conventions, correct data was placed into correct CDM tables and fields). Each data analyst is advised to update their local R packages to the latest OHDSI package versions before executing the study package.

**Results and dissemination:** A study lead should ensure each site follows local governance rules before results are shared. Open, reproducible science means that everything that is designed and executed becomes available. OHDSI Network studies are fully transparent with all documentation and subsequent results published to the OHDSI GitHub repository or the data.ohdsi.org R Shiny server. As you prepare your manuscript, the study lead should review the principles of the OMOP CDM and Standardized Vocabularies to ensure the journal understands how data can vary across OHDSI network sites. For example, if you are performing a network study that uses claims databases and EHRs, you may be asked by journal reviewers to explain how the integrity of the cohort definition was maintained across multiple data types. A reviewer may want to understand how the OMOP observation period (as discussed in Chapter \@ref(CommonDataModel) compares to an eligibility file – a file that exists in claims databases to attribute when a person is and is not covered by an insurance provider. This is inherently asking to focus on an artifactual element of the databases themselves and focuses on the ETL of how the CDM transforms the records into observations. In this case, the network study lead may find it helpful to reference how the OMOP CDM OBSERVATION PERIOD is created and describe how observations are created using the encounters in the source system. The manuscript discussion may need to acknowledge the limitations of how EHR data, unlike claims data which reflects all paid encounters for that period of time they are covered, it does not record when a person sees a provider who uses a different EHR of record and thus, breaks in observation periods may occur because of the person seeks care from an out-of-EHR provider. This is an artifact of how data exists in the system it is captured in. It is not a clinically meaningful difference but may confuse those who are unfamiliar with how OMOP derives the observation period table. It is worth explaining in the discussion section to clarify this unfamiliar convention. Similarly, a study lead may find it useful to describe the terminology service provided by the OMOP standard vocabularies enables a clinical concept to be the same across wherever it is captured. There are always decisions made in mapping of source codes to standard concepts however THEMIS conventions and CDM quality checks can help provide information on where information should go and how well a database adhered to that principle.

## Summary

\BeginKnitrBlock{rmdsummary}
- An OHDSI study becomes an OHDSI Network study when it is run across multiple CDMs at different institutions.
- OHDSI network studies are open to all. Anyone can lead a network study. Anyone with an OMOP compliant database may opt to participate and contribute results.
- Need help running a network study? Consult with the OHDSI Study Nurture Committee to help design and execute your study.
- **Sharing is caring.** All study documentation, code and results are published on the OHDSI GitHub or in an R Shiny application. Study leads are invited to present their research at OHDSI events.

\EndKnitrBlock{rmdsummary}
