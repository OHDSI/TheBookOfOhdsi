library(DatabaseConnector)
connectionDetails <- createConnectionDetails(dbms = "pdw",
                                             server = Sys.getenv("PDW_SERVER"),
                                             user = NULL,
                                             password = NULL,
                                             port = Sys.getenv("PDW_PORT"))
cdmDatabaseSchema <- "cdm_ibm_mdcd_v872.dbo"
conn <- connect(connectionDetails)

sql <- "SELECT COUNT(*) AS person_count FROM @cdm.person;"
renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)


sql <- "SELECT AVG(DATEDIFF(DAY, observation_period_start_date, observation_period_end_date) / 365.25) AS num_years
FROM @cdm.observation_period;"
renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)

sql <- "SELECT MAX(YEAR(observation_period_end_date) -
                   year_of_birth) AS max_age
FROM @cdm.person
INNER JOIN @cdm.observation_period
ON person.person_id = observation_period.person_id;"
renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)

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

renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)


library(DatabaseConnector)
sql <- "SELECT YEAR(observation_period_start_date) -
               year_of_birth AS age
FROM @cdm.person
INNER JOIN @cdm.observation_period
ON person.person_id = observation_period.person_id;"
age <- renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)
quantile(age[, 1], c(0, 0.25, 0.5, 0.75, 1))


sql <- "SELECT TOP 10 condition_source_value,
  COUNT(*) AS code_count
FROM @cdm.condition_occurrence
GROUP BY condition_source_value
ORDER BY -COUNT(*);"
renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)

sql <- "SELECT COUNT(*) AS subject_count,
  concept_name
FROM @cdm.person
INNER JOIN @cdm.concept
  ON person.gender_concept_id = concept.concept_id
GROUP BY concept_name;"
renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)

sql <- "SELECT COUNT(*) AS prescription_count
FROM @cdm.drug_exposure
INNER JOIN @cdm.concept_ancestor
  ON drug_concept_id = descendant_concept_id
INNER JOIN @cdm.concept ingredient
  ON ancestor_concept_id = ingredient.concept_id
WHERE ingredient.concept_name = 'Ibuprofen'
  AND ingredient.concept_class_id = 'Ingredient'
  AND ingredient.standard_concept = 'S';"
renderTranslateQuerySql(conn, sql, cdm = cdmDatabaseSchema)


disconnect(conn)



bookdown::preview_chapter("SqlAndR.Rmd")
