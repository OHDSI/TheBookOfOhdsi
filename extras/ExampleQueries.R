library(DatabaseConnector)
connectionDetails <- createConnectionDetails(dbms = "pdw",
                                             server = Sys.getenv("PDW_SERVER"),
                                             user = NULL,
                                             password = NULL,
                                             port = Sys.getenv("PDW_PORT"))
cdmDbSchema <- "cdm_ibm_mdcd_v872.dbo"
cohortDbSchema <- "scratch.dbo"
cohortTable <- "mschuemi_book_example"
conn <- connect(connectionDetails)

sql <- "SELECT COUNT(*) AS person_count FROM @cdm.person;"
renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)


sql <- "SELECT AVG(DATEDIFF(DAY, observation_period_start_date, observation_period_end_date) / 365.25) AS num_years
FROM @cdm.observation_period;"
renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)

sql <- "SELECT MAX(YEAR(observation_period_end_date) -
                   year_of_birth) AS max_age
FROM @cdm.person
INNER JOIN @cdm.observation_period
ON person.person_id = observation_period.person_id;"
renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)

sql <- "WITH age
AS (
	SELECT age,
		ROW_NUMBER() OVER (
			ORDER BY age
			) order_nr
	FROM (
		SELECT YEAR(observation_period_start_date) - year_of_birth AS age
		FROM @cdm.person
		INNER JOIN @cdm.observation_period
			ON person.person_id = observation_period.person_id
		) age_computed
	)
SELECT MIN(age) AS min_age,
	MIN(CASE
			WHEN order_nr < .25 * n
				THEN 9999
			ELSE age
			END) AS q25_age,
	MIN(CASE
			WHEN order_nr < .50 * n
				THEN 9999
			ELSE age
			END) AS median_age,
	MIN(CASE
			WHEN order_nr < .75 * n
				THEN 9999
			ELSE age
			END) AS q75_age,
	MAX(age) AS max_age
FROM age
CROSS JOIN (
	SELECT COUNT(*) AS n
	FROM age
	) population_size;"

renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)


library(DatabaseConnector)
sql <- "SELECT YEAR(observation_period_start_date) -
               year_of_birth AS age
FROM @cdm.person
INNER JOIN @cdm.observation_period
ON person.person_id = observation_period.person_id;"
age <- renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)
quantile(age[, 1], c(0, 0.25, 0.5, 0.75, 1))


sql <- "SELECT TOP 10 condition_source_value,
  COUNT(*) AS code_count
FROM @cdm.condition_occurrence
GROUP BY condition_source_value
ORDER BY -COUNT(*);"
renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)

sql <- "SELECT COUNT(*) AS subject_count,
  concept_name
FROM @cdm.person
INNER JOIN @cdm.concept
  ON person.gender_concept_id = concept.concept_id
GROUP BY concept_name;"
renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)

sql <- "SELECT COUNT(*) AS prescription_count
FROM @cdm.drug_exposure
INNER JOIN @cdm.concept_ancestor
  ON drug_concept_id = descendant_concept_id
INNER JOIN @cdm.concept ingredient
  ON ancestor_concept_id = ingredient.concept_id
WHERE ingredient.concept_name = 'Ibuprofen'
  AND ingredient.concept_class_id = 'Ingredient'
  AND ingredient.standard_concept = 'S';"
renderTranslateQuerySql(conn, sql, cdm = cdmDbSchema)


# Example study ----------------------------------------

sql <- "DROP TABLE @cohort_db_schema.@cohort_table;"
renderTranslateExecuteSql(conn, sql,
                          cohort_db_schema = cohortDbSchema,
                          cohort_table = cohortTable)

sql <- "
CREATE TABLE @cohort_db_schema.@cohort_table (
  cohort_definition_id INT,
  cohort_start_date DATE,
	cohort_end_date DATE,
	subject_id BIGINT
	);
"
renderTranslateExecuteSql(conn, sql,
                          cohort_db_schema = cohortDbSchema,
                          cohort_table = cohortTable)

sql <- "
INSERT INTO @cohort_db_schema.@cohort_table (
  cohort_definition_id,
  cohort_start_date,
  cohort_end_date,
  subject_id
)
SELECT 1 AS cohort_definition_id,
  cohort_start_date,
  cohort_end_date,
  subject_id
FROM (
  SELECT MIN(drug_exposure_start_date) AS cohort_start_date,
    MIN(drug_exposure_end_date) AS cohort_end_date,
    person_id AS subject_id
  FROM @cdm_db_schema.drug_exposure
  INNER JOIN @cdm_db_schema.concept_ancestor
    ON drug_concept_id = descendant_concept_id
  WHERE ancestor_concept_id IN (1335471, 1340128, 1341927,
    1363749, 1308216, 1310756, 1373225, 1331235, 1334456,
    1342439) -- ACE inhibitors
  GROUP BY person_id
) first_exposure
INNER JOIN @cdm_db_schema.observation_period
  ON subject_id = person_id
    AND observation_period_start_date < cohort_start_date
    AND observation_period_end_date > cohort_start_date
WHERE DATEDIFF(DAY,
               observation_period_start_date,
               cohort_start_date) >= 365;
"

renderTranslateExecuteSql(conn, sql,
                          cohort_db_schema = cohortDbSchema,
                          cohort_table = cohortTable,
                          cdm_db_schema = cdmDbSchema)


sql <- "
INSERT INTO @cohort_db_schema.@cohort_table (
cohort_definition_id,
cohort_start_date,
cohort_end_date,
subject_id
)
SELECT 2 AS cohort_definition_id,
  cohort_start_date,
  cohort_end_date,
  subject_id
FROM (
  SELECT DISTINCT person_id AS subject_id,
    condition_start_date AS cohort_start_date,
    condition_end_date AS cohort_end_date
  FROM @cdm_db_schema.condition_occurrence
  INNER JOIN @cdm_db_schema.concept_ancestor
    ON condition_concept_id = descendant_concept_id
  WHERE ancestor_concept_id = 432791 -- Angioedema
) distinct_occurrence
INNER JOIN @cdm_db_schema.visit_occurrence
  ON subject_id = person_id
  AND visit_start_date <= cohort_start_date
  AND visit_end_date >= cohort_start_date
WHERE visit_concept_id IN (262, 9203,
    9201) -- Inpatient or ER;
"

renderTranslateExecuteSql(conn, sql,
                          cohort_db_schema = cohortDbSchema,
                          cohort_table = cohortTable,
                          cdm_db_schema = cdmDbSchema)


sql <- "
WITH tar AS (
  SELECT concept_name AS gender,
    FLOOR((YEAR(cohort_start_date) -
          year_of_birth) / 10) AS age,
    subject_id,
    cohort_start_date,
    CASE WHEN DATEADD(DAY, 7, cohort_start_date) >
      observation_period_end_date
    THEN observation_period_end_date
    ELSE DATEADD(DAY, 7, cohort_start_date)
    END AS cohort_end_date
  FROM @cohort_db_schema.@cohort_table
  INNER JOIN @cdm_db_schema.observation_period
    ON subject_id = observation_period.person_id
      AND observation_period_start_date < cohort_start_date
      AND observation_period_end_date > cohort_start_date
  INNER JOIN @cdm_db_schema.person
    ON subject_id = person.person_id
  INNER JOIN @cdm_db_schema.concept
    ON gender_concept_id = concept_id
  WHERE cohort_definition_id = 1 -- Exposure
)
SELECT days.gender,
    days.age,
    days,
    CASE WHEN events IS NULL THEN 0 ELSE events END AS events
FROM (
  SELECT gender,
    age,
    SUM(DATEDIFF(DAY, cohort_start_date,
      cohort_end_date)) AS days
  FROM tar
  GROUP BY gender,
    age
) days
LEFT JOIN (
  SELECT gender,
      age,
      COUNT(*) AS events
  FROM tar
  INNER JOIN @cohort_db_schema.@cohort_table angioedema
    ON tar.subject_id = angioedema.subject_id
      AND tar.cohort_start_date <= angioedema.cohort_start_date
      AND tar.cohort_end_date >= angioedema.cohort_start_date
  WHERE cohort_definition_id = 2 -- Outcome
  GROUP BY gender,
    age
) events
ON days.gender = events.gender
  AND days.age = events.age;
"

results <- renderTranslateQuerySql(conn, sql,
                                   cohort_db_schema = cohortDbSchema,
                                   cohort_table = cohortTable,
                                   cdm_db_schema = cdmDbSchema,
                                   snakeCaseToCamelCase = TRUE)

results$ir <- 1000 * results$events / results$days / 7
results$age <- results$age * 10
format(results$ir, scientific = FALSE)

library(ggplot2)
ggplot(results, aes(x = age, y = ir, group = gender, color = gender)) +
  geom_line() +
  xlab("Age") +
  ylab("Incidence (per 1,000 patient weeks)")



ggsave(filename = "c:/temp/ir.png", width = 5.5, height = 3.5, dpi = 300)

disconnect(conn)



bookdown::preview_chapter("SqlAndR.Rmd")
