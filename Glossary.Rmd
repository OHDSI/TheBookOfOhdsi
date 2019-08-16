# (APPENDIX) Appendix {-}

# Glossary {#Glossary}

Cohort
A cohort is a list of PERSON_IDs with start and end date. It is stored in a study specific cohort table or a CDM specified cohort table can also be used. Cohort can be represented as .json file. It is used for import and export but not during an analysis. OHDSI tools use SQL so Atlas also generates a .sql file that creates the cohort during analysis.

Parametized SQL code
An SQL code that allows for use of parameters. Parameters are prefixed with @. Such code has to be "rendered". Synonym: OHDSI SQL code.
