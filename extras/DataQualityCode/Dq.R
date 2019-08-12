library(MethodEvaluation)
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "pdw",
                                                                server = Sys.getenv("PDW_SERVER"),
                                                                user = NULL,
                                                                password = NULL,
                                                                port = Sys.getenv("PDW_PORT"))

# The name of the database schema where the CDM data can be found:
cdmDbSchema <- "CDM_IBM_MDCR_V871.dbo"

# setwd("C:/Users/mschuemi/Git/TheBookOfOhdsi")

json <- readChar("extras/DataQualityCode/cohort.json", file.info("extras/DataQualityCode/cohort.json")$size)
sql <- readChar("extras/DataQualityCode/cohort.sql", file.info("extras/DataQualityCode/cohort.sql")$size)
checkCohortSourceCodes(connectionDetails,
                       cdmDatabaseSchema = cdmDbSchema,
                       cohortJson = json,
                       cohortSql = sql,
                       outputFile = "extras/DataQualityCode/output.html")



orphans <- findOrphanSourceCodes(connectionDetails,
                                 cdmDatabaseSchema = cdmDbSchema,
                                 conceptName = "Angioedema",
                                 conceptSynonyms = c("Angioneurotic edema",
                                                     "Giant hives",
                                                     "Giant urticaria",
                                                     "Periodic edema"))
