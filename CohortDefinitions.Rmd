# Cohort definitions {#CohortDefinitions}

This Appendix contains cohort definitions used throughout the book.

## ACE inhibitors {#AceInhibitors}

#### Initial Event Cohort {-}

People having any of the following:

* a drug exposure of *ACE inhibitors* (Table \@ref(tab:aceInhibitors)) for the first time in the person's history

with continuous observation of at least 365 days prior and 0 days after event index date, and limit initial events to: all events per person.

Limit qualifying cohort to: all events per person.

#### End Date Strategy {-}

Custom Drug Era Exit Criteria
This strategy creates a drug era from the codes found in the specified concept set. If the index event is found within an era, the cohort end date will use the era's end date. Otherwise, it will use the observation period end date that contains the index event.

Use the era end date of *ACE inhibitors* (Table \@ref(tab:aceInhibitors))

* allowing 30 days between exposures
* adding 0 days after exposure end

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 30 days. 

#### Concept Set Definitions {-}

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


##  New users of ACE inhibitors monotherapy {#AceInhibitorsMono}

#### Initial Event Cohort {-}

People having any of the following:

* a drug exposure of *ACE inhibitors* (Table \@ref(tab:aceInhibitorsMono)) for the first time in the person's history

with continuous observation of at least 365 days prior and 0 days after event index date, and limit initial events to: earliest event per person.

#### Inclusion Rules {-}

Inclusion Criteria #1: has hypertension diagnosis in 1 yr prior to treatment

Having all of the following criteria:

* at least 1 occurrences of a condition occurrence of *Hypertensive disorder* (Table \@ref(tab:hypertensionAceMono)) where event starts between 365 days Before and 0 days After index start date

Inclusion Criteria #2: Has no prior antihypertensive drug exposures in medical history

Having all of the following criteria:

* exactly 0 occurrences of a drug exposure of *Hypertension drugs* (Table \@ref(tab:htnDrugsAceMono)) where event starts between all days Before and 1 days Before index start date

Inclusion Criteria #3: Is only taking ACE as monotherapy, with no concomitant combination treatments

Having all of the following criteria:

* exactly 1 distinct occurrences of a drug era of *Hypertension drugs* (Table \@ref(tab:htnDrugsAceMono)) where event starts between 0 days Before and 7 days After index start date

Limit qualifying cohort to: earliest event per person.

#### End Date Strategy {-}

Custom Drug Era Exit Criteria. 
This strategy creates a drug era from the codes found in the specified concept set. If the index event is found within an era, the cohort end date will use the era's end date. Otherwise, it will use the observation period end date that contains the index event.

Use the era end date of *ACE inhibitors* (Table \@ref(tab:aceInhibitorsMono))

* allowing 30 days between exposures
* adding 0 days after exposure end

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 0 days. 

#### Concept Set Definitions {-}

Table: (\#tab:aceInhibitorsMono) ACE inhibitors

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

Table: (\#tab:hypertensionAceMono) Hypertensive disorder

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 316866 | Hypertensive disorder | NO | YES | NO |

Table: (\#tab:htnDrugsAceMono) Hypertension drugs

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 904542 | Triamterene | NO | YES | NO |
| 907013 | Metolazone | NO | YES | NO |
| 932745 | Bumetanide | NO | YES | NO |
| 942350 | torsemide | NO | YES | NO |
| 956874 | Furosemide | NO | YES | NO |
| 970250 | Spironolactone | NO | YES | NO |
| 974166 | Hydrochlorothiazide | NO | YES | NO |
| 978555 | Indapamide | NO | YES | NO |
| 991382 | Amiloride | NO | YES | NO |
| 1305447 | Methyldopa | NO | YES | NO |
| 1307046 | Metoprolol | NO | YES | NO |
| 1307863 | Verapamil | NO | YES | NO |
| 1308216 | Lisinopril | NO | YES | NO |
| 1308842 | valsartan | NO | YES | NO |
| 1309068 | Minoxidil | NO | YES | NO |
| 1309799 | eplerenone | NO | YES | NO |
| 1310756 | moexipril | NO | YES | NO |
| 1313200 | Nadolol | NO | YES | NO |
| 1314002 | Atenolol | NO | YES | NO |
| 1314577 | nebivolol | NO | YES | NO |
| 1317640 | telmisartan | NO | YES | NO |
| 1317967 | aliskiren | NO | YES | NO |
| 1318137 | Nicardipine | NO | YES | NO |
| 1318853 | Nifedipine | NO | YES | NO |
| 1319880 | Nisoldipine | NO | YES | NO |
| 1319998 | Acebutolol | NO | YES | NO |
| 1322081 | Betaxolol | NO | YES | NO |
| 1326012 | Isradipine | NO | YES | NO |
| 1327978 | Penbutolol | NO | YES | NO |
| 1328165 | Diltiazem | NO | YES | NO |
| 1331235 | quinapril | NO | YES | NO |
| 1332418 | Amlodipine | NO | YES | NO |
| 1334456 | Ramipril | NO | YES | NO |
| 1335471 | benazepril | NO | YES | NO |
| 1338005 | Bisoprolol | NO | YES | NO |
| 1340128 | Captopril | NO | YES | NO |
| 1341238 | Terazosin | NO | YES | NO |
| 1341927 | Enalapril | NO | YES | NO |
| 1342439 | trandolapril | NO | YES | NO |
| 1344965 | Guanfacine | NO | YES | NO |
| 1345858 | Pindolol | NO | YES | NO |
| 1346686 | eprosartan | NO | YES | NO |
| 1346823 | carvedilol | NO | YES | NO |
| 1347384 | irbesartan | NO | YES | NO |
| 1350489 | Prazosin | NO | YES | NO |
| 1351557 | candesartan | NO | YES | NO |
| 1353766 | Propranolol | NO | YES | NO |
| 1353776 | Felodipine | NO | YES | NO |
| 1363053 | Doxazosin | NO | YES | NO |
| 1363749 | Fosinopril | NO | YES | NO |
| 1367500 | Losartan | NO | YES | NO |
| 1373225 | Perindopril | NO | YES | NO |
| 1373928 | Hydralazine | NO | YES | NO |
| 1386957 | Labetalol | NO | YES | NO |
| 1395058 | Chlorthalidone | NO | YES | NO |
| 1398937 | Clonidine | NO | YES | NO |
| 40226742 | olmesartan | NO | YES | NO |
| 40235485 | azilsartan | NO | YES | NO |


## Acute myocardial infarction (AMI) {#Ami}

#### Initial Event Cohort {-}

People having any of the following: 

* a condition occurrence of *Acute myocardial Infarction* (Table \@ref(tab:ami))

with continuous observation of at least 0 days prior and 0 days after event index date, and limit initial events to: all events per person.

For people matching the Primary Events, include: Having any of the following criteria:

* at least 1 occurrences of a visit occurrence of *Inpatient or ER visit* (Table \@ref(tab:inpatientOrErAmi))  where event starts between all days Before and 0 days After index start date and event ends between 0 days Before and all days After index start date

Limit cohort of initial events to: all events per person.

Limit qualifying cohort to: all events per person.

#### End Date Strategy {-}

Date Offset Exit Criteria. 
This cohort defintion end date will be the index event's start date plus 7 days

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 180 days. 

#### Concept Set Definitions {-}

Table: (\#tab:ami) Inpatient or ER visit

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 314666 | Old myocardial infarction | YES | YES | NO |
| 4329847 | Myocardial infarction | NO | YES | NO |

Table: (\#tab:inpatientOrErAmi) Inpatient or ER visit

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 262 | Emergency Room and Inpatient Visit | NO | YES | NO |
| 9201 | Inpatient Visit | NO | YES | NO |
| 9203 | Emergency Room Visit | NO | YES | NO |


## Angioedema {#Angioedema}

#### Initial Event Cohort {-}

People having any of the following: 

* a condition occurrence of *Angioedema* (Table \@ref(tab:angioedema)) 

with continuous observation of at least 0 days prior and 0 days after event index date, and limit initial events to: all events per person.

For people matching the Primary Events, include:
Having any of the following criteria:

* at least 1 occurrences of a visit occurrence of *Inpatient or ER visit* (Table \@ref(tab:inpatientOrEr))  where event starts between all days Before and 0 days After index start date and event ends between 0 days Before and all days After index start date

Limit cohort of initial events to: all events per person.

Limit qualifying cohort to: all events per person.

#### End Date Strategy {-}

This cohort defintion end date will be the index event's start date plus 7 days

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 30 days. 

#### Concept Set Definitions {-}

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


## New users of Thiazide-like diuretics monotherapy {#ThiazidesMono}

#### Initial Event Cohort {-}

People having any of the following:

* a drug exposure of *Thiazide or thiazide-like diuretic* (Table \@ref(tab:thiazidesMono)) for the first time in the person's history

with continuous observation of at least 365 days prior and 0 days after event index date, and limit initial events to: earliest event per person.

#### Inclusion Rules {-}

Inclusion Criteria #1: has hypertension diagnosis in 1 yr prior to treatment

Having all of the following criteria:

* at least 1 occurrences of a condition occurrence of *Hypertensive disorder* (Table \@ref(tab:hypertensionThzMono)) where event starts between 365 days Before and 0 days After index start date

Inclusion Criteria #2: Has no prior antihypertensive drug exposures in medical history

Having all of the following criteria:

* exactly 0 occurrences of a drug exposure of *Hypertension drugs* (Table \@ref(tab:htnDrugsThzMono)) where event starts between all days Before and 1 days Before index start date

Inclusion Criteria #3: Is only taking ACE as monotherapy, with no concomitant combination treatments

Having all of the following criteria:

* exactly 1 distinct occurrences of a drug era of *Hypertension drugs* (Table \@ref(tab:htnDrugsThzMono)) where event starts between 0 days Before and 7 days After index start date

Limit qualifying cohort to: earliest event per person.

#### End Date Strategy {-}

Custom Drug Era Exit Criteria. 
This strategy creates a drug era from the codes found in the specified concept set. If the index event is found within an era, the cohort end date will use the era's end date. Otherwise, it will use the observation period end date that contains the index event.

Use the era end date of *Thiazide or thiazide-like diuretic* (Table \@ref(tab:thiazidesMono))

* allowing 30 days between exposures
* adding 0 days after exposure end

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 0 days. 

#### Concept Set Definitions {-}

Table: (\#tab:thiazidesMono) Thiazide or thiazide-like diuretic

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 907013 | Metolazone | NO | YES | NO |
| 974166 | Hydrochlorothiazide | NO | YES | NO |
| 978555 | Indapamide | NO | YES | NO |
| 1395058 | Chlorthalidone | NO | YES | NO |

Table: (\#tab:hypertensionThzMono) Hypertensive disorder

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 316866 | Hypertensive disorder | NO | YES | NO |

Table: (\#tab:htnDrugsThzMono) Hypertension drugs

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 904542 | Triamterene | NO | YES | NO |
| 907013 | Metolazone | NO | YES | NO |
| 932745 | Bumetanide | NO | YES | NO |
| 942350 | torsemide | NO | YES | NO |
| 956874 | Furosemide | NO | YES | NO |
| 970250 | Spironolactone | NO | YES | NO |
| 974166 | Hydrochlorothiazide | NO | YES | NO |
| 978555 | Indapamide | NO | YES | NO |
| 991382 | Amiloride | NO | YES | NO |
| 1305447 | Methyldopa | NO | YES | NO |
| 1307046 | Metoprolol | NO | YES | NO |
| 1307863 | Verapamil | NO | YES | NO |
| 1308216 | Lisinopril | NO | YES | NO |
| 1308842 | valsartan | NO | YES | NO |
| 1309068 | Minoxidil | NO | YES | NO |
| 1309799 | eplerenone | NO | YES | NO |
| 1310756 | moexipril | NO | YES | NO |
| 1313200 | Nadolol | NO | YES | NO |
| 1314002 | Atenolol | NO | YES | NO |
| 1314577 | nebivolol | NO | YES | NO |
| 1317640 | telmisartan | NO | YES | NO |
| 1317967 | aliskiren | NO | YES | NO |
| 1318137 | Nicardipine | NO | YES | NO |
| 1318853 | Nifedipine | NO | YES | NO |
| 1319880 | Nisoldipine | NO | YES | NO |
| 1319998 | Acebutolol | NO | YES | NO |
| 1322081 | Betaxolol | NO | YES | NO |
| 1326012 | Isradipine | NO | YES | NO |
| 1327978 | Penbutolol | NO | YES | NO |
| 1328165 | Diltiazem | NO | YES | NO |
| 1331235 | quinapril | NO | YES | NO |
| 1332418 | Amlodipine | NO | YES | NO |
| 1334456 | Ramipril | NO | YES | NO |
| 1335471 | benazepril | NO | YES | NO |
| 1338005 | Bisoprolol | NO | YES | NO |
| 1340128 | Captopril | NO | YES | NO |
| 1341238 | Terazosin | NO | YES | NO |
| 1341927 | Enalapril | NO | YES | NO |
| 1342439 | trandolapril | NO | YES | NO |
| 1344965 | Guanfacine | NO | YES | NO |
| 1345858 | Pindolol | NO | YES | NO |
| 1346686 | eprosartan | NO | YES | NO |
| 1346823 | carvedilol | NO | YES | NO |
| 1347384 | irbesartan | NO | YES | NO |
| 1350489 | Prazosin | NO | YES | NO |
| 1351557 | candesartan | NO | YES | NO |
| 1353766 | Propranolol | NO | YES | NO |
| 1353776 | Felodipine | NO | YES | NO |
| 1363053 | Doxazosin | NO | YES | NO |
| 1363749 | Fosinopril | NO | YES | NO |
| 1367500 | Losartan | NO | YES | NO |
| 1373225 | Perindopril | NO | YES | NO |
| 1373928 | Hydralazine | NO | YES | NO |
| 1386957 | Labetalol | NO | YES | NO |
| 1395058 | Chlorthalidone | NO | YES | NO |
| 1398937 | Clonidine | NO | YES | NO |
| 40226742 | olmesartan | NO | YES | NO |
| 40235485 | azilsartan | NO | YES | NO |

## Patients initiating first-line therapy for hypertension {#HTN1yrFO}

#### Initial Event Cohort {-}

People having any of the following: 

* a drug exposure of *First-line hypertension drugs* (Table \@ref(tab:HTN1yrFO1stLine)) for the first time in the person's history

with continuous observation of at least 365 days prior and 365 days after event index date, and limit initial events to: earliest event per person.

#### Inclusion Rules {-}

Having all of the following criteria:

* exactly 0 occurrences of a drug exposure of *Hypertension drugs* (Table \@ref(tab:HTN1yrFODrugs)) where event starts between all days Before and 1 days Before index start date
* and at least 1 occurrences of a condition occurrence of *Hypertensive disorder* (Table \@ref(tab:HTN1yrFOHypertensiveDisorder)) where event starts between 365 days Before and 0 days After index start date

Limit cohort of initial events to: earliest event per person.
Limit qualifying cohort to: earliest event per person.

#### End Date Strategy {-}

No end date strategy selected. By default, the cohort end date will be the end of the observation period that contains the index event.

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 0 days. 

#### Concept Set Definitions {-}

Table: (\#tab:HTN1yrFO1stLine) First-line hypertension drugs

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 907013 | Metolazone | NO | YES | NO | 
| 974166 | Hydrochlorothiazide | NO | YES | NO | 
| 978555 | Indapamide | NO | YES | NO | 
| 1307863 | Verapamil | NO | YES | NO | 
| 1308216 | Lisinopril | NO | YES | NO | 
| 1308842 | valsartan | NO | YES | NO | 
| 1310756 | moexipril | NO | YES | NO | 
| 1317640 | telmisartan | NO | YES | NO | 
| 1318137 | Nicardipine | NO | YES | NO | 
| 1318853 | Nifedipine | NO | YES | NO | 
| 1319880 | Nisoldipine | NO | YES | NO | 
| 1326012 | Isradipine | NO | YES | NO | 
| 1328165 | Diltiazem | NO | YES | NO | 
| 1331235 | quinapril | NO | YES | NO | 
| 1332418 | Amlodipine | NO | YES | NO | 
| 1334456 | Ramipril | NO | YES | NO | 
| 1335471 | benazepril | NO | YES | NO | 
| 1340128 | Captopril | NO | YES | NO | 
| 1341927 | Enalapril | NO | YES | NO | 
| 1342439 | trandolapril | NO | YES | NO | 
| 1346686 | eprosartan | NO | YES | NO | 
| 1347384 | irbesartan | NO | YES | NO | 
| 1351557 | candesartan | NO | YES | NO | 
| 1353776 | Felodipine | NO | YES | NO | 
| 1363749 | Fosinopril | NO | YES | NO | 
| 1367500 | Losartan | NO | YES | NO | 
| 1373225 | Perindopril | NO | YES | NO | 
| 1395058 | Chlorthalidone | NO | YES | NO | 
| 40226742 | olmesartan | NO | YES | NO | 
| 40235485 | azilsartan | NO | YES | NO | 


Table: (\#tab:HTN1yrFODrugs) Hypertension drugs

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 904542 | Triamterene | NO | YES | NO | 
| 907013 | Metolazone | NO | YES | NO | 
| 932745 | Bumetanide | NO | YES | NO | 
| 942350 | torsemide | NO | YES | NO | 
| 956874 | Furosemide | NO | YES | NO | 
| 970250 | Spironolactone | NO | YES | NO | 
| 974166 | Hydrochlorothiazide | NO | YES | NO | 
| 978555 | Indapamide | NO | YES | NO | 
| 991382 | Amiloride | NO | YES | NO | 
| 1305447 | Methyldopa | NO | YES | NO | 
| 1307046 | Metoprolol | NO | YES | NO | 
| 1307863 | Verapamil | NO | YES | NO | 
| 1308216 | Lisinopril | NO | YES | NO | 
| 1308842 | valsartan | NO | YES | NO | 
| 1309068 | Minoxidil | NO | YES | NO | 
| 1309799 | eplerenone | NO | YES | NO | 
| 1310756 | moexipril | NO | YES | NO | 
| 1313200 | Nadolol | NO | YES | NO | 
| 1314002 | Atenolol | NO | YES | NO | 
| 1314577 | nebivolol | NO | YES | NO | 
| 1317640 | telmisartan | NO | YES | NO | 
| 1317967 | aliskiren | NO | YES | NO | 
| 1318137 | Nicardipine | NO | YES | NO | 
| 1318853 | Nifedipine | NO | YES | NO | 
| 1319880 | Nisoldipine | NO | YES | NO | 
| 1319998 | Acebutolol | NO | YES | NO | 
| 1322081 | Betaxolol | NO | YES | NO | 
| 1326012 | Isradipine | NO | YES | NO | 
| 1327978 | Penbutolol | NO | YES | NO | 
| 1328165 | Diltiazem | NO | YES | NO | 
| 1331235 | quinapril | NO | YES | NO | 
| 1332418 | Amlodipine | NO | YES | NO | 
| 1334456 | Ramipril | NO | YES | NO | 
| 1335471 | benazepril | NO | YES | NO | 
| 1338005 | Bisoprolol | NO | YES | NO | 
| 1340128 | Captopril | NO | YES | NO | 
| 1341238 | Terazosin | NO | YES | NO | 
| 1341927 | Enalapril | NO | YES | NO | 
| 1342439 | trandolapril | NO | YES | NO | 
| 1344965 | Guanfacine | NO | YES | NO | 
| 1345858 | Pindolol | NO | YES | NO | 
| 1346686 | eprosartan | NO | YES | NO | 
| 1346823 | carvedilol | NO | YES | NO | 
| 1347384 | irbesartan | NO | YES | NO | 
| 1350489 | Prazosin | NO | YES | NO | 
| 1351557 | candesartan | NO | YES | NO | 
| 1353766 | Propranolol | NO | YES | NO | 
| 1353776 | Felodipine | NO | YES | NO | 
| 1363053 | Doxazosin | NO | YES | NO | 
| 1363749 | Fosinopril | NO | YES | NO | 
| 1367500 | Losartan | NO | YES | NO | 
| 1373225 | Perindopril | NO | YES | NO | 
| 1373928 | Hydralazine | NO | YES | NO | 
| 1386957 | Labetalol | NO | YES | NO | 
| 1395058 | Chlorthalidone | NO | YES | NO | 
| 1398937 | Clonidine | NO | YES | NO | 
| 40226742 | olmesartan | NO | YES | NO | 
| 40235485 | azilsartan | NO | YES | NO | 


Table: (\#tab:HTN1yrFOHypertensiveDisorder) Hypertensive disorder

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 316866 | Hypertensive disorder | NO	| YES	| NO |

## Patients initiating first-line therapy for hypertension with >3 yr follow-up {#HTN3yrFO}

Same as *cohort definition \@ref(HTN1yrFO)* but with continuous observation of at least 365 days prior and **1095 days** after event index date

## ACE inhibitor use {#ACEiUse}

#### Initial Event Cohort {-}

People having any of the following:

* a drug exposure of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE))

with continuous observation of at least 0 days prior and 0 days after event index date, and limit initial events to: all events per person.

Limit qualifying cohort to: all events per person.

#### End Date Strategy {-}

This strategy creates a drug era from the codes found in the specified concept set. If the index event is found within an era, the cohort end date will use the era's end date. Otherwise, it will use the observation period end date that contains the index event.

Use the era end date of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE))

* allowing 30 days between exposures
* adding 0 days after exposure end

#### Cohort Collapse Strategy {-}

Collapse cohort by era with a gap size of 30 days. 

#### Concept Set Definitions {-}

Table: (\#tab:ACEiUseACE) ACE inhibitors

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

## Angiotensin receptor blocker (ARB) use {#ARBUse}

Same as *cohort definition \@ref(ACEiUse)* with *Angiotensin Receptor Blockers (ARBs)* (Table \@ref(tab:ARBUseARBs)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:ARBUseARBs) Angiotensin Receptor Blockers (ARBs)

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 1308842 | valsartan | NO | YES | NO | 
| 1317640 | telmisartan | NO | YES | NO | 
| 1346686 | eprosartan | NO | YES | NO | 
| 1347384 | irbesartan | NO | YES | NO | 
| 1351557 | candesartan | NO | YES | NO | 
| 1367500 | Losartan | NO | YES | NO | 
| 40226742 | olmesartan | NO | YES | NO | 
| 40235485 | azilsartan | NO | YES | NO | 

## Thiazide or thiazide-like diuretic use {#THZUse}

Same as *cohort definition \@ref(ACEiUse)* with *Thiazide or thiazide-like diuretic* (Table \@ref(tab:THZUseTHZ)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:THZUseTHZ) Thiazide or thiazide-like diuretic

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 907013 | Metolazone | NO | YES | NO | 
| 974166 | Hydrochlorothiazide | NO | YES | NO | 
| 978555 | Indapamide | NO | YES | NO | 
| 1395058 | Chlorthalidone | NO | YES | NO | 

## dihydropyridine Calcium Channel Blocker (dCCB) use {#dCCBUse}

Same as *cohort definition \@ref(ACEiUse)* with *dihydropyridine Calcium Channel Blocker (dCCB)* (Table \@ref(tab:dCCBUsedCBB)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:dCCBUsedCBB) Dihydropyridine Calcium channel blockers (dCCB)

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 1318137 | Nicardipine | NO | YES | NO | 
| 1318853 | Nifedipine | NO | YES | NO | 
| 1319880 | Nisoldipine | NO | YES | NO | 
| 1326012 | Isradipine | NO | YES | NO | 
| 1332418 | Amlodipine | NO | YES | NO | 
| 1353776 | Felodipine | NO | YES | NO | 

## non-dihydropyridine Calcium Channel Blocker (ndCCB) use {#ndCCBUse}

Same as *cohort definition \@ref(ACEiUse)* with *non-dihydropyridine Calcium channel blockers (ndCCB)* (Table \@ref(tab:ndCCBUsendCCB)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:ndCCBUsendCCB) non-dihydropyridine Calcium channel blockers (ndCCB)

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 1307863 | Verapamil | NO | YES | NO | 
| 1328165 | Diltiazem | NO | YES | NO | 

## beta blocker use {#BBUse}

Same as *cohort definition \@ref(ACEiUse)* with *Beta blockers* (Table \@ref(tab:BBUseBB)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:BBUseBB) Beta blockers

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 1307046 | Metoprolol | NO | YES | NO | 
| 1313200 | Nadolol | NO | YES | NO | 
| 1314002 | Atenolol | NO | YES | NO | 
| 1314577 | nebivolol | NO | YES | NO | 
| 1319998 | Acebutolol | NO | YES | NO | 
| 1322081 | Betaxolol | NO | YES | NO | 
| 1327978 | Penbutolol | NO | YES | NO | 
| 1338005 | Bisoprolol | NO | YES | NO | 
| 1345858 | Pindolol | NO | YES | NO | 
| 1346823 | carvedilol | NO | YES | NO | 
| 1353766 | Propranolol | NO | YES | NO | 
| 1386957 | Labetalol | NO | YES | NO | 

## Diuretic-loop use {#DLoopUse}

Same as *cohort definition \@ref(ACEiUse)* with *Diuretics - Loop* (Table \@ref(tab:DLoopUseDLoops)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:DLoopUseDLoops) Diuretics - Loop

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 932745 | Bumetanide | NO | YES | NO | 
| 942350 | torsemide | NO | YES | NO | 
| 956874 | Furosemide | NO | YES | NO | 

## Diuretic-potassium sparing use {#DPUse}

Same as *cohort definition \@ref(ACEiUse)* with *Diuretics - potassium sparing* (Table \@ref(tab:DPUseDPs)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:DPUseDPs) Diuretics - potassium sparing

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 904542 | Triamterene | NO | YES | NO | 
| 991382 | Amiloride | NO | YES | NO | 

## alpha-1 blocker use {#A1BUse}

Same as *cohort definition \@ref(ACEiUse)* with *Alpha-1 blocker* (Table \@ref(tab:A1BUseA1Bs)) in place of *ACE inhibitors* (Table \@ref(tab:ACEiUseACE)). 

#### Concept Set Definitions {-}

Table: (\#tab:A1BUseA1Bs) Alpha-1 blocker

| Concept Id | Concept Name | Excluded | Descendants | Mapped |
| ---------- |:------------ | -------- | ----------- | ------ |
| 1341238 | Terazosin | NO | YES | NO | 
| 1350489 | Prazosin | NO | YES | NO | 
| 1363053 | Doxazosin | NO | YES | NO | 
