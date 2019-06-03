

# Contributing to The Book of OHDSI

First, thanks for contributing! 

These guidelines are meant to help you contribute to The Book of OHDSI, [which you can view here](ohdsi.github.io/TheBookOfOhdsi). The book is meant to provide step by step instructions on how to run a study using OHDSI tools. Throughout the book, we will use hypertension as a disease of interest. 

# Guidelines

## Chapter structure

In general, chapters will follow this outline: 
	Introduction
	Theory
	Practice
	Advanced Topics (as appropriate)
	Exercises

Each chapter has one or more leaders who take final responsibility for chapter content, review, and editing. **However**, each chapter can have many contributors. 

## Workflow

- Use RStudio to write in rmarkdown files.   
- Make pull request to github repo   
- When your pull request is accepted, the book is automatically updated on the site  

## Keep in mind

- [There is a cheat sheet for you to get started with markdown](https://raw.githubusercontent.com/OHDSI/TheBookOfOhdsi/master/extras/CheatSheet.pdf)  
- Hyperlinks should show the actual URL, so that a printed copy would still have a readable link.   
- Tables and figures should be designed with small screens in mind.   
- Keep filename extensions in lower case, so 'figure.png', not 'figure.PNG'.  
- Only use alphanumeric characters in labels. So not ```{r figure_1} but ```{r figure1}.  
- Tables and lists only render correctly if they have an empty line in front of them.  
- Extra rows in the book.bib file (not used in the text) are not a problem.  

# Book outline

[Preface](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/index.Rmd):

Part I: The OHDSI Community
[Mission, vision, values](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/MissionVisionValues.Rmd)
[Collaborators](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/Collaborators.Rmd)
[Open Science](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/OpenScience.Rmd)
[Where to begin](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/WhereToBegin.Rmd)

Part II: Uniform Data Representation
[Common Data Model](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/CommonDataModel.Rmd)
[Standardized Vocabularies](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/StandardizedVocabularies.Rmd)
[Extract Transform Load](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/ExtractTransformLoad.Rmd)

Part III: Data Analytics
[Data Analytics Use cases](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/DataAnalyticsUseCases.Rmd)
[OHDSI Analytics Tools]()
[SQL and R](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/SqlAndR.Rmd)
[Building cohorts](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/Cohorts.Rmd)
[Cohort characterization](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/Characterization.Rmd)
[Population-level Estimation](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/PopulationLevelEstimation.Rmd)
[Patient-level Prediction](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/PatientLevelPrediction.Rmd)

Part IV: Evidence Quality
[Evidence Quality](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/EvidenceQuality.Rmd)
[Data Quality](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/DataQuality.Rmd)
[Clinical Validity](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/ClinicalValidity.Rmd)
[Software Validity](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/SoftwareValidity.Rmd)
[Method Validity](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/MethodValidity.Rmd)

Part V: OHDSI Studies
[Study Steps](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/StudySteps.Rmd)
[OHDSI Network Research](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/NetworkResearch.Rmd)

[Appendix](https://github.com/OHDSI/TheBookOfOhdsi/blob/master/Appendix.Rmd)


# Our Pledge

[**Adapted from a gist by PurpleBooth**](https://gist.github.com/PurpleBooth/b24679402957c63ec426)

In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to making participation in our project and our community a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.
Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language  
- Being respectful of differing viewpoints and experiences  
- Gracefully accepting constructive criticism  
- Focusing on what is best for the community  
- Showing empathy towards other community members  

# Examples of unacceptable behavior by participants include:

The use of sexualized language or imagery and unwelcome sexual attention or advances
Trolling, insulting/derogatory comments, and personal or political attacks

# Public or private harassment

Publishing others' private information, such as a physical or electronic address, without explicit permission

Other conduct which could reasonably be considered inappropriate in a professional setting

# Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable behavior and are expected to take appropriate and fair corrective action in response to any instances of unacceptable behavior.

Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct, or to ban temporarily or permanently any contributor for other behaviors that they deem inappropriate, threatening, offensive, or harmful.
Scope

This Code of Conduct applies both within project spaces and in public spaces when an individual is representing the project or its community. Examples of representing a project or community include using an official project e-mail address, posting via an official social media account, or acting as an appointed representative at an online or offline event. Representation of a project may be further defined and clarified by project maintainers.

# Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by contacting the project team at [INSERT EMAIL ADDRESS]. All complaints will be reviewed and investigated and will result in a response that is deemed necessary and appropriate to the circumstances. The project team is obligated to maintain confidentiality with regard to the reporter of an incident. Further details of specific enforcement policies may be posted separately.
                                        Project maintainers who do not follow or enforce the Code of Conduct in good faith may face temporary or permanent repercussions as determined by other members of the project's leadership.
                                        
# Attribution

This Code of Conduct is adapted from the Contributor Covenant, version 1.4, available at http://contributor-covenant.org/version/1/

