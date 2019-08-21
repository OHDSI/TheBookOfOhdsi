# OHDSI Network Research {#NetworkResearch}

Contributors: Greg Klebanov, Kristin Kostka & Vojtech Huser

The mission of OHDSI is to generate high-quality evidence through observational research. A primary way this is accomplished is through collaborative research studies. In prior chapters we discussed how the OHDSI community has authored standards and tools to facilitate high-quality, reproducible research, including Standardized Vocabularies , the Common Data Model (CDM) , analytical methods packages, ATLAS and the study steps (Chapter\@ref(StudySteps)) to run a retrospective database study. OHDSI Network Studies represent the culmination of a transparent, consistent and reproducible way to conduct research across a large number of geographically dispersed data. In this chapter we will discuss what constitutes an OHDSI network study, how to run a network study and discuss enabling technologies such as the ARACHNE Research Network.

## What is the OHDSI Research Network?

The OHDSI Research Network is an international collaboration of researchers seeking to advance observational data research in healthcare. Today, the network consists of over 1.2 billion patient records (~650 million de-duplicated patient records) in the OMOP CDM. This includes more than 200 researchers and 82 observational health databases across 17 countries with regional central coordinating centers housed at Columbia University (USA), Erasmus Medical Center (Europe) and Ajou University (South Korea). The OHDSI community continues to grow rapidly across Europe (in collaboration with the IMI EHDEN project), Central America (e.g. Argentina, Brazil, Colombia), and Asia (e.g. China, Japan, Singapore). 

OHDSI is open network, inviting healthcare institutions across the globe with active patient data to join the network and convert data to the OMOP CDM. As OMOP data conversions are complete, collaborators are invited to report site information in the Data Network census maintained by the OHDSI Program Manager (beaton@ohdsi.org). Each OHDSI network site participates voluntarily. There are no hard obligations. Each site opts-in to each respective network study. In each study, data remains at the site behind a firewall.  No data pooling across network sites. Only aggregate results are shared.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">#### Benefits of Joining the OHDSI Network {-}
Unlock the power of institutional data: Transforming institutional EHR data in the OMOP Common Data Model enables clinical research on populations of your patients, something EHR systems don’t support.
Access to free tools: OHDSI publishes free, open source tools for data characterization and analytics (e.g. browsing the clinical concepts, defining and characterizing cohorts, running Population-Level Estimation and Patient-Level Prediction studies).
Participate in a premier research community: Author and publish network research, gain access to eminent leaders in global real-world evidence community.
Buildout Quality Benchmarks: Network can validate quality improvement benchmarks against other institutions (e.g. On average how long does it take to get an appendectomy discharged?)</div>\EndKnitrBlock{rmdimportant}

## What is an OHDSI Network Study? 

In the study steps chapter (Chapter\@ref(StudySteps)), we discussed the steps to execute a retrospective database study using the OMOP CDM. A study may be conducted on a single OMOP CDM or on multiple OMOP CDMs. It can be conducted within a single institution’s OMOP CDM data or across many institutions. There is no requirement that an OHDSI research study package be shared across the entire OMOP network. In fact, there may be legitimate instances when a study protocol is written for specific clinical practice that cannot be generalized to the entirety of the network. The principal investigator of each OHDSI research study will determine which, if any, sites they would like to include in an analysis.

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">**When is a study considered a network study?** An OHDSI research project becomes a network study when it is published and shared for execution across the OHDSI community. 

Elements of a Network Study:
- Must have a protocol (a description of the analysis to be performed)
- Must have a study code package designed for the OMOP CDM
- Must be executed across two or more network sites (not just 2 or more databases at a single site)
- Encouraged to publish all documentation on GitHub
- At the end of the analysis, the results are made available in Github or other public repository (e.g. a Shiny Application)</div>\EndKnitrBlock{rmdimportant}

## Executing an OHDSI Network Study

Conducting an OHDSI Network Study requires a substantial amount of preparation to ensure success. 

>”You’ll never walk alone in your OHDSI journey.” - Peter Rijnbeek

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">**New to Network Studies?** The OHDSI Study Nurture Committee is a resource for you as you navigate your journey. This committee helps train and guide researchers to complete OHDSI Studies including how to effectively use OHDSI tools, providing guidance to the OHDSI study design for increase reproducibility and reliability and assisting with helping study investigators recruit data partners to run study packages.</div>\EndKnitrBlock{rmdimportant}

Running an OHDSI Network Study has three distinct stages:

- Study Feasibility and Design
- Study Execution
- Results Dissemination and Publication

### Study Feasibility and Design

The study feasibility stage *(pre-study stage)* is focused on supporting a definition of a study and a creation of the study protocol, *e.g. undertaking activities to make sure the study is feasible to be executed as described in the formal protocol.* 

The feasibility stage does not have a well-defined process but rather is driven by various supporting activities, including identification and enrollment of relevant databases that contain the targeted patient population with required drug exposure, procedure information, condition or demographics information through data characterization, validating and agreeing on target analytical methods and algorithms. These activities may involve sharing JSON files of cohort definitions from ATLAS and provisional test of study R packages. A study lead may have enough data to do this inside their own organization or may opt for support from other OHDSI network sites.

The outcome of the feasibility stage is generation of a final protocol as well as a list of target collaborators. The formal protocol will detail the study team, including the designated study lead (often the corresponding author for publication purposes), and information on the timeline for the study. The protocol is a critical component for additional network sites to review, approve and execute the study package on their OMOP CDM data. A protocol must include information on study population, the methods being used, how the results will be stored and analyzed as well as how the study results will be disseminated after completion (e.g. a publication, a poster, etc).

### Study Execution

After completing feasibility, a study advances to the execution phase. The key activities in executing a network study include the following:

- The study lead formally initiates a new OHDSI network study with the OHDSI Coordinating Center. *In tandem, this may include undertaking other organization-specific processes to approve an OHDSI study.* 
- The study lead publishes the study protocol to the OHDSI GitHub.
- The study lead announces the study on the OHDSI Community Call and OHDSI Forum, inviting participating centers and collaborators. 
- Study participating organizations assemble teams within each site, assign study roles (e.g. data analyst(s) executing the study package, site leadership reviewing the study design and manuscript).
- The data scientist/statisticians for the study lead will use a study protocol to design study analyses and generate study code. 
- The data scientist/statisticians will conduct a feasibility test of study code within their own environment. The package will be shared to 1-2 network sites for additional validation.
- The data scientist/statistician will publish the validated study code in the OHDSI GitHub for execution at participating sites.
- Site data scientists/statisticians access the OHDSI study package and generate results in the standardized format following OHDSI guidelines. Each participating site will follow internal institutional processes regarding data sharing rules. **Sites should not share results unless approval is obtained from IRB or other institutional approval processes.**
- Data scientist/statisticians and Study Lead collect and review the analysis execution results. 
- Iterate steps 5-7, if reasonable adjustments required. 
- Collaboratively finalize study results. Study lead disseminates study results (e.g. a Shiny Application).
- Study lead formally closes the study out with OHDSI Coordinating Center.

While OHDSI processes can be executed rapidly, it is advised to allow for a few weeks to months for all participating sites to execute the study and receive appropriate approvals to publish results. A study leads should set study milestones and anticipated closure date in advance to assist with managing the overall study timeline.

### Results Dissemination and Publication

During this stage, the study lead will collaborate with other sites on various administrative tasks, such as manuscript development and optimizing data visualizations. 

\BeginKnitrBlock{rmdimportant}<div class="rmdimportant">Not sure where to publish your OHDSI network study? Consult JANE (Journal/Author Name Estimator), a tool which takes your abstract and scans publications for relevance and fit (http://jane.biosemantics.org/).</div>\EndKnitrBlock{rmdimportant}

Researchers are also invited to present OHDSI Network Studies on weekly OHDSI community calls and at OHDSI Symposiums across the globe.

## Types of Network Studies

The network studies can be of different types - ranging from simple characterization questions to more advanced predictive studies. A large number of studies conducted today are focused on epidemiology and drug efficacy and safety and thus carry different type of characterization analyses such as patient population characterization, incidence rates of certain outcomes/conditions, comparative drug effectiveness comparison, prevalence of disease and similar. However, more and more studies cary predictive nature including the probability of an outcome for a certain type of a patient (personalized medicine).

## Forward Looking: Using Network Study Automation

The current network study process is manual and rudimentary - with study team members using various mechanisms (including Wiki, GitHub and email) to collaborate on study design, share code and results. This process is not consistent and scalable and to solve that issue, the OHDSI community is actively working to systemize study processes. The ARACHNE Research Network platform is a community-driven solution to streamline and automate the process of network studies. 

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
 
## Best Practices for Network Research

There are multiple best practices that study teams should be following while executing the network study:

- Make sure that study questions can be supported by data available. Perform study feasibility to identify the best databases.
- Write code in generic way and parametrize all functions and variables e.g. do not hard database connection, local hard drive path, assume a certain operating system.
- Ensure the target databases have required OMOP CDM version and OMOP Standardized Vocabularies.
- Ensure the target database ETL has followed THEMIS business rules and conventions and correct data was placed into correct CDM tables and fields.
- Do not tweak the study code to get desired results

## Example: LEGEND - Hypertension

To be added.
