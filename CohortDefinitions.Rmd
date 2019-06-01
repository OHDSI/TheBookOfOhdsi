# Cohort definitions {#CohortDefinitions}

This Appendix contains cohort definitions used throughout the book.

## ACE inhibitors {#AceInhibitors}

**Initial Event Cohort**

People having any of the following:

* a drug exposure of *ACE inhibitors* (Table \@ref(tab:aceInhibitors)) for the first time in the person's history

with continuous observation of at least 365 days prior and 0 days after event index date, and limit initial events to: all events per person.

Limit qualifying cohort to: all events per person.

**End Date Strategy**

Custom Drug Era Exit Criteria
This strategy creates a drug era from the codes found in the specified concept set. If the index event is found within an era, the cohort end date will use the era's end date. Otherwise, it will use the observation period end date that contains the index event.

Use the era end date of *ACE inhibitors* (Table \@ref(tab:aceInhibitors))

* allowing 30 days between exposures
* adding 0 days after exposure end

**Cohort Collapse Strategy**

Collapse cohort by era with a gap size of 30 days. 

**Concept Set Definitions**

Table: (\#tab:aceInhibitors) ACE inhibitors

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 1308216 | Lisinopril | NO | YES | NO |
| 1310756 | moexipril | NO | YES | NO |
| 1331235 | quinapril | NO | YES | NO |
| 1334456 | Ramipril | NO | YES | NO |
| 1335471 | benazepril | NO | YES | NO |
| 1340128 | Captopril | NO | YES | NO |
| 1341927 | Enalapril | NO | YES | NO |
| 1342439 | trandolapril | NO | YES | NO |
| 1363749 | Fosinopril | NO | YES | NO |
| 1373225 | Perindopril | NO | YES | NO |


## Angioedema {#Angioedema}

**Initial Event Cohort**

People having any of the following: 

* a condition occurrence of *Angioedema* (Table \@ref(tab:angioedema)) 

with continuous observation of at least 0 days prior and 0 days after event index date, and limit initial events to: all events per person.

For people matching the Primary Events, include:
Having any of the following criteria:

* at least 1 occurrences of a visit occurrence of *Inpatient or ER visit* (Table \@ref(tab:inpatientOrEr))  where event starts between all days Before and 0 days After index start date and event ends between 0 days Before and all days After index start date

Limit cohort of initial events to: all events per person.

Limit qualifying cohort to: all events per person.

**End Date Strategy**

This cohort defintion end date will be the index event's start date plus 7 days

**Cohort Collapse Strategy**

Collapse cohort by era with a gap size of 30 days. 

**Concept Set Definitions**

Table: (\#tab:angioedema) Angioedema

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 432791 | Angioedema | NO | YES | NO |

Table: (\#tab:inpatientOrEr) Inpatient or ER visit

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 262 | Emergency Room and Inpatient Visit | NO | YES | NO |
| 9201 | Inpatient Visit | NO | YES | NO |
| 9203 | Emergency Room Visit | NO | YES | NO |

