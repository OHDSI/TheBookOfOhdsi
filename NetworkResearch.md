# OHDSI Network Research {#NetworkResearch}

Chapter Leads: Kristin Kostka, Sara Dempster, Greg Klebanov

The mission of OHDSI is to generate high-quality evidence through observational research. A primary way this is accomplished is through collaborative research studies. In prior chapters we discussed how the OHDSI community has authored standards and tools to facilitate high-quality, reproducible research, including Standardized Vocabularies ,the Common Data Model (CDM) ,analytical methods packages, ATLAS and the study steps (Chapter\@ref(StudySteps)) to run a retrospective database study. OHDSI Network Studies represent the culmination of a transparent, consistent and reproducible way to conduct research across a large number of geographically dispersed data. In this chapter we will discuss what constitutes an OHDSI network study, how to run a network study and discuss enabling technologies such as the ARACHNE Research Network.

##  OHDSI Research Network

The OHDSI Research Network is an international collaboration of researchers seeking to advance observational data research in healthcare. Today, the network consists of over 1.2 billion patient records (~650 million de-duplicated patient records) in the CDM. This includes more than 220 researchers and 82 observational health databases across 17 countries with regional central coordinating centers housed at Columbia University (USA), Erasmus Medical Center (Europe) and Ajou University (South Korea). The OHDSI community continues to grow rapidly across Europe (in collaboration with the IMI EHDEN project), Central America (e.g. Argentina, Brazil, Colombia), and Asia (e.g. China, Japan, Singapore). 

OHDSI is an open network, inviting healthcare institutions across the globe with active patient data to join the network and convert data to the CDM. As data conversions are complete, collaborators are invited to report site information in the Data Network census maintained by the [OHDSI Program Manager](mailto:beaton@ohdsi.org). Each OHDSI network site participates voluntarily. There are no hard obligations. Each site opts-in to each respective network study. In each study, data remains at the site behind a firewall.  No data pooling across network sites. Only aggregate results are shared.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">**Benefits of a Data Owner Joining the OHDSI Network**
- **Access to free tools:** OHDSI publishes free, open source tools for data characterization and analytics (e.g. browsing the clinical concepts, defining and characterizing cohorts, running Population-Level Estimation and Patient-Level Prediction studies).
- **Participate in a premier research community:** Author and publish network research, gain access to eminent leaders in global real-world evidence community.
- **Opportunity to buildout care benchmarks:** Network can validate quality improvement benchmarks against other institutions *(e.g. On average how long does it take to get an appendectomy discharged?)*
</div>\EndKnitrBlock{rmdimportant}

## Defining an OHDSI Network Study

In the prior chapter (Chapter \@ref(StudySteps)), we discussed general design considerations for running a study using the CDM.  In general, a study may be conducted on a single CDM or on multiple CDMs. It can be run within a single institution’s CDM data or across many institutions. 
In this chapter we will discuss the considerations when an OHDSI study evolves to become a study run across the OHDSI network.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">**When is a study considered a *network* study?** An OHDSI study becomes an OHDSI Network study when it is run across multiple CDMs at different institutions.</div>\EndKnitrBlock{rmdimportant}

Network studies are an important part of the OHDSI research community. However, there is no mandate that an OHDSI study be packaged and shared across the entire OHDSI network. It is at the discretion of each investigator whether a study is designed to run on a single institution's CDM or across multiple CDMs across the OHDSI network. In  limited instances, network studies may be semi-private in scope -- with invitation to collaborate targeted to specific research interests or data requirements that not all sites can fulfill. This chapter is intended to speak to the open network research that the OHDSI community conducts.

**Elements of an Open OHDSI Network Study:**
When conducting an open OHDSI Network study, there are a few components that make OHDSI research unique. This includes:

- All documentation, study code and subsequent results are made publicly available on the OHDSI GitHub.
- Investigators must create and publish a public study protocol detailing the scope and intent of the analysis to be performed.
- Investigators must create a study package (typically with R or SQL) with code that is CDM compliant
- Investigators are encouraged to attend OHDSI Community Calls to promote and recruit sites for their OHDSI network study.
- At the conclusion of the analysis, aggregate study results are made available in the OHDSI GitHub.
- Where possible, investigators are encouraged to publish study R Shiny Applications to [data.ohdsi.org](http://data.ohdsi.org).

In the next section we will talk about how to create your own network study.

### Design Considerations for an OHDSI Network Study

Designing a study to run across the OHDSI Network requires a paradigm shift in how you design and assemble your study code. Ordinarily, you may design a study with a target data set in mind. In doing so, you may write code relative to what you know to be true in the data you are utilizing for your analysis. For example, if you were assembling an angioedema cohort you may opt to pick only concept codes for angioedema that are represented in your CDM. This may be problematic if your data are in a specific care setting (e.g. primary care, ambulatory settings) or specific to a region (e.g. US-centric). You might be biasing your cohort definition.

In an OHDSI Network Study, you are no longer designing and building a study package just for your data. You are building a study package to be run across multiple sites across the globe. You will never see the underlying data; OHDSI network studies only share results files. Your study package must be assembled on the principles of what data can be captured in the domains of the CDM and err towards an exhaustive approach to concept set creation to represent the diversity of care settings that observational health data are captured in. OHDSI study packages use the same cohort definition across all sites. This means that you must think holistically to avoid biasing a cohort definition to only represent a subset of eligible data (e.g. claims-centric data or EHR-specific data) in the network. You are encouraged to write an exhaustive cohort definition that can be ported across multiple CDMs. You **should never** be modifying the cohort definition for each site. OHDSI study packages are intended to be the same set of code run across all sites -- with only minor customizations for connecting into the database layer and where to store your local results.

In addition to clinical coding variation, you have to anticipate technical variations as well. Your study code will no longer be running in a single technical environment. Each OHDSI Network site makes its own independent choice of database layer. Luckily, the OHDSI Community has solutions such as ATLAS, [DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/), and [SqlRender](https://ohdsi.github.io/SqlRender/) to help you generalize your study package for CDM compliance across different database dialects. OHDSI investigators are encouraged to solicit help from other network study sites to test and validate the study package can be executed in different environments. When coding errors come up, OHDSI Researchers can utilize the [OHDSI Forums](http://forums.ohdsi.org) to discuss and debug packages.

### Logistical Considerations for an OHDSI Network Study

OHDSI Network Studies require coordination between the lead investigator with participating network sites. Each site must perform its own due diligence to ensure the study protocol is approved and authorized to be executed on the local CDM. Data analysts may need to enlist assistance from the local IT team to enable appropriate permissions to run the study.

Site start-up activities may include:

- Registering the study with the Institutional Review Board (or equivalent)
- Receiving Institutional Review Board approval to execute the study
- Receiving database level permissions to read/write a schema to the approved CDM
- Ensuring a functional R Studio environment to execute the study package
- Reviewing the study code for any technical anomalies
- Working with a local IT team to permit and install any dependent R packages needed to execute the package within technical constraints

Each site will have a local data analyst who executes the study package. This individual must review the output of the study package to scrutinize the results to ensure no sensitive information is transmitted. When you using pre-built OHDSI methods such as Population Level Estimation and Patient-Level Prediction, there are configurable settings around the minimum cell count for the analysis performed. The data analyst is required to review these thresholds and ensure it is in compliance with local governance considerations.

When sharing study results, the data analyst must comply with all local governance policies, inclusive of method of results transmission and adhering to approval processes for external publication of results. OHDSI Network studies do not move data. Study packages create results files designed to be aggregate (e.g. point-estimates, diagnostic plots, etc) and do not share patient-level information. As such, most organizations do not require data sharing agreements be executed between the study team members. If you are a data owner interested in participating in network studies, you are strongly encouraged to consult your local governance team to understand what policies are in place and must be fulfilled in order to join OHDSI community studies.

The OHDSI community has validated methodologies to aggregate results files shared from multiple network sites into a single answer. The [EvidenceSynthesis](https://github.com/OHDSI/EvidenceSynthesis) package is a freely available R package containing routines for combining evidence and diagnostics across multiple sources, such as multiple data sites in a distributed study. This includes functions for performing meta-analysis and forest plots.

## Running an OHDSI Network Study

Running an OHDSI Network Study has three distinct stages:

- Study Feasibility and Design
- Study Execution
- Results Dissemination and Publication

### Study Feasibility and Design

The study feasibility stage *(pre-study stage)* is focused on supporting a definition of a study and a creation of the study protocol. These activities make sure the study is feasible to be executed as described in the formal protocol.

The feasibility stage does not have a well-defined process but rather is driven by various supporting activities, including identifying relevant network sites that contain the targeted patient population with required drug exposure, procedure information, condition or demographics information. A study lead may have enough data to do this inside their own organization and may opt for support from other OHDSI network sites. This can include asking collaborators to execute data characterization activities such as JSON files of cohort definitions from ATLAS and provisionally test of study R packages. 

The outcome of the feasibility stage is generation of a finalized protocol and study package that is ready for network dissemination. The formal protocol will detail the study team, including the designated study lead (often the corresponding author for publication purposes), and information on the timeline for the study. The protocol is a critical component for additional network sites to review, approve and execute the full study package on their CDM data. A protocol must include information on study population, the methods being used, how the results will be stored and analyzed as well as how the study results will be disseminated after completion (e.g. a publication, a poster, etc).

### Study Execution

After completing feasibility exercises, the study advances to the execution phase. This phase is when the design and logistical considerations we discussed become most important.

The key activities in executing a network study include the following:

- The study lead formally initiates a new OHDSI network study with the OHDSI Coordinating Center. In tandem, this will likely include undertaking other organization-specific processes to approve an OHDSI study at the organizing institution.
- The study lead publishes the study protocol to the OHDSI GitHub.
- The study lead announces the study on the OHDSI Community Call and OHDSI Forum, inviting participating centers and collaborators. 
- The data scientist/statisticians for the study lead will use a study protocol to design study analyses and create the study code. 
- The data scientist/statisticians will conduct a feasibility test of study code within their own environment. It is encouraged to share the package across to 1-2 network sites for additional validation.
- The data scientist/statistician will publish the validated study code in the OHDSI GitHub for execution at participating sites.
- Participating sites will undergo their own institutional processes to receive IRB approval to execute the study.
- Site data scientists/statisticians will access the OHDSI study package and generate results in the standardized format following OHDSI guidelines. Each participating site will follow internal institutional processes regarding data sharing rules. Sites should not share results unless approval is obtained from IRB or other institutional approval processes.
- Data scientist/statisticians and Study Lead collect and review the analysis execution results. 
- Study teams may iterate on results, if reasonable adjustments are required. 
- Study lead and their data scientist/statisticians will perform a meta analysis to aggregate study results across centers. 
- Study lead will disseminate study results (e.g. a Shiny Application) for review.
- Study lead will work with contributing sites to co-author a manuscript or other presentation showcasing the results of the study.


While OHDSI studies can be executed rapidly, it is advised to allow for a few weeks to several months for all participating sites to execute the study and receive appropriate approvals to publish results. A study leads should set study milestones in the protocol and communicate anticipated closure date in advance to assist with managing the overall study timeline.

### Results Dissemination and Publication

During this stage, the study lead will collaborate with other sites on various administrative tasks, such as manuscript development and optimizing data visualizations. 

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">Not sure where to publish your OHDSI network study? Consult JANE (Journal/Author Name Estimator), a tool which takes your abstract and scans publications for relevance and fit (http://jane.biosemantics.org/).</div>\EndKnitrBlock{rmdimportant}

Researchers are also invited to present OHDSI Network Studies on weekly OHDSI community calls and at OHDSI Symposiums across the globe.


## Forward Looking: Using Network Study Automation

The current network study process is manual - with study team members using various mechanisms (including Wiki, GitHub and email) to collaborate on study design, sharing code and results. This process is not consistent and scalable and to solve that issue, the OHDSI community is actively working to systemize study processes. The ARACHNE Research Network platform is a community-driven solution to streamline and automate the process of network studies. 

<div class="figure">
<img src="images/NetworkStudies/ARACHNE.png" alt="The ARACHNE Network Study Process." width="100%" />
<p class="caption">(\#fig:arachne)The ARACHNE Network Study Process.</p>
</div>

The ARACHNE Platform includes multiple core components:

- The **ARACHNE Data Catalog** where different network participants register and maintain information about data sets available for network research
- The **Study Workflow Manager** that allows study teams to orchestrate and end to end network study process. The ARACHNE Research Network platform It is taking full advantage of OHDSI standards and establishes a consistent, transparent, secure and compliant observational research process, across multiple organizations. ARACHNE standardizes the communication protocol to access the data and exchange analysis results, while enabling authentication and authorization for restricted content. It brings participating organizations - data providers, investigators, sponsors and data scientists - into a single collaborative study team and facilitates an end-to-end observational study. The tool enables the creation of a complete, standards-based R, Python and SQL execution environment including approval workflows controlled by the data custodian.
 
ARACHNE is built to provide a seamless integration with other OHDSI tools, including ACHILLES reports and an ability to import ATLAS design artefacts, create self-contained packages and automatically execute those across multiple sites. The future vision is to eventually enable multiple networks to be linked together for the purpose of conducting research not only between organizations within a single network, but also between organizations across multiple networks. 

<div class="figure">
<img src="images/NetworkStudies/ARACHNENON.png" alt="The ARACHNE Network of Networks." width="100%" />
<p class="caption">(\#fig:arachneNon)The ARACHNE Network of Networks.</p>
</div>
 
## Summary

\BeginKnitrBlock{rmdsummary}<div class="rmdsummary">- An OHDSI study becomes an OHDSI Network study when it is run across multiple CDMs at different institutions.
- When running a network study, make sure that you are not biasing your study design to a single type of data.
- Perform study feasibility to identify the best databases.
- Write study code in CDM compliant, database layer agnostic way using OHDSI packages. Be sure to parametrize all functions and variables (e.g. do not hard database connection, local hard drive path, assume a certain operating system).
- When recruiting participating sites, ensure that each network site is CDM compliant and regularly updates the Standardized Vocabularies. Ensure with each network site has performed and documented Data Quality checks on their CDM (e.g. ensuring ETL has followed THEMIS business rules and conventions, correct data was placed into correct CDM tables and fields).
- Encourage each data analyst updates their local R packages to the latest OHDSI package versions before executing the study.
- Ensure each site is in compliance with local governance rules before results are shared.
</div>\EndKnitrBlock{rmdsummary}
