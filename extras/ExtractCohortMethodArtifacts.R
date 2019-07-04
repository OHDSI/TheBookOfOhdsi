library(CohortMethod)

outputFolder <- "s:/CohortMethodAceiVsThz"

cmFolder <- file.path(outputFolder, "cmOutput")
exportFolder <- file.path(outputFolder, "export")
omr <- readRDS(file.path(cmFolder, "outcomeModelReference.rds"))

# CohortMethodData -----------------------------
cmData <- loadCohortMethodData(file.path(cmFolder,omr$cohortMethodDataFolder[1]), )
cmData

summary(cmData)

# Attrtion, power -----------------------------------
studyPop <- readRDS(file.path(cmFolder,omr$studyPopFile[omr$outcomeId == 1770712]), )
getAttritionTable(studyPop)

matchedPop <- readRDS(file.path(cmFolder,omr$strataFile[omr$outcomeId == 1770712]), )
CohortMethod::drawAttritionDiagram(matchedPop, fileName = file.path(outputFolder, "attrition.png"))

computeMdrr(matchedPop)

plotFollowUpDistribution(matchedPop, targetLabel = "ACE inhibitors", comparatorLabel = "Thiazides and thiazide-like diuretics", fileName = file.path(outputFolder, "followUp.png"))


# Propensity model and scores --------------------------
ps <- readRDS(file.path(cmFolder,omr$psFile[omr$outcomeId == 1770712]), )
computePsAuc(ps)
CohortMethod::plotPs(ps,
                     targetLabel = "ACE inhibitors",
                     comparatorLabel = "Thiazides and thiazide-like diuretics",
                     showCountsLabel = TRUE,
                     fileName = file.path(outputFolder, "ps.png"))

model <- getPsModel(ps, cmData)
model <- model[1:10, ]
writeLines(paste("|", round(model$coefficient, 2), "|", model$covariateName, "|"))

# Balance ---------------------------------------------
balance <- readRDS(file.path(outputFolder, "balance", "bal_t1770710_c1770711_o1770712_a1.rds"))
CohortMethod::plotCovariateBalanceScatterPlot(balance, showCovariateCountLabel = TRUE, showMaxLabel = TRUE, fileName = file.path(outputFolder, "balance.png"))

# Outcome model, KM plot ----------------------------------------
om <- readRDS(file.path(cmFolder,omr$outcomeModelFile[omr$outcomeId == 1770712]), )
om

CohortMethod::plotKaplanMeier(matchedPop, targetLabel = "ACE inhibitors", comparatorLabel = "Thiazides and thiazide-like diuretics", fileName = file.path(outputFolder, "kmPlot.png"))

# All estimates -------------------------------------------------
summ <- summarizeAnalyses(omr, outputFolder = cmFolder)
# Drop positive controls:
summ <- summ[summ$outcomeId < 10000 | summ$outcomeId >= 20000, ]
head(summ)


# Empirical evaluation -------------------------------------------
library(MethodEvaluation)
estimates <- read.csv(file.path(exportFolder, "cohort_method_result.csv"))
ncs <- read.csv(file.path(exportFolder, "negative_control_outcome.csv"))
pcs <- read.csv(file.path(exportFolder, "positive_control_outcome.csv"))
controls <- data.frame(outcome_id = c(ncs$outcome_id, pcs$outcome_id),
                       trueLogRr = c(rep(0, nrow(ncs)), log(pcs$effect_size)))
controlEstimates <- merge(controls, estimates, all.x = TRUE)
plotControls(logRr = controlEstimates$log_rr,
             ci95Lb = controlEstimates$ci_95_lb,
             ci95Ub = controlEstimates$ci_95_ub,
             trueLogRr = controlEstimates$trueLogRr,
             estimateType = "hazard ratio",
             fileName = file.path(outputFolder, "controls.png"))

metrics <- computeMetrics(logRr = controlEstimates$log_rr,
                          ci95Lb = controlEstimates$ci_95_lb,
                          ci95Ub = controlEstimates$ci_95_ub,
                          trueLogRr = controlEstimates$trueLogRr)
writeLines(paste("|", names(metrics), "|", round(metrics, 2), "|"))

# Empirical calibration -------------------
library(EmpiricalCalibration)
colnames(estimates) <- SqlRender::snakeCaseToCamelCase(colnames(estimates))
ncEstimates <- estimates[estimates$outcomeId %in% ncs$outcome_id, ]
oiEstimates <- estimates[estimates$outcomeId %in% c(1770712, 1770713), ]
plotCalibrationEffect(logRrNegatives = ncEstimates$logRr,
                      seLogRrNegatives = ncEstimates$seLogRr,
                      logRrPositives = oiEstimates$logRr,
                      seLogRrPositives = oiEstimates$seLogRr,
                      showCis = TRUE,
                      fileName = file.path(outputFolder, "pValueCal.png"))

null <- fitNull(logRr = ncEstimates$logRr,
                seLogRr = ncEstimates$seLogRr)
calibrateP(null,
           logRr = oiEstimates$logRr,
           seLogRr = oiEstimates$seLogRr)
oiEstimates$p

idx <- estimates$outcomeId %in% c(1770712, 1770713)
sprintf("%.2f (%.2f - %.2f)", estimates$rr[idx], estimates$ci95Lb[idx], estimates$ci95Ub[idx])
sprintf("%.2f (%.2f - %.2f)", estimates$calibratedRr[idx], estimates$calibratedCi95Lb[idx], estimates$calibratedCi95Ub[idx])

# Database heterogeneity --------------------------

library(DatabaseConnector)

connectionDetails <- createConnectionDetails(dbms = "postgresql",
                                             server = paste(Sys.getenv("legendServer"),
                                                            Sys.getenv("legendDatabase"),
                                                            sep = "/"),
                                             port = Sys.getenv("legendPort"),
                                             user = Sys.getenv("legendUser"),
                                             password = Sys.getenv("legendPw"),
                                             schema = Sys.getenv("legendSchema"))
connection <- connect(connectionDetails)
ami <- 2
angioedema <- 32
ace <- 1
thz <- 15
databaseId <- "MDCD"

sql <- "SELECT * FROM cohort_method_result
WHERE target_id = @target_id
AND comparator_id = @comparator_id
AND outcome_id IN (@outcome_ids)
AND database_id != 'Meta-analysis'
AND database_id != 'CUMC'
AND database_id != 'NHIS_NSC'
AND analysis_id IN (1,3);"
legendEst <- renderTranslateQuerySql(connection, sql,
                                     target_id = ace,
                                     comparator_id = thz,
                                     outcome_ids = c(ami, angioedema),
                                     snakeCaseToCamelCase = TRUE)
disconnect(connection)

legendEst <- legendEst[(legendEst$analysisId == 1) | (legendEst$analysisId == 3 & legendEst$databaseId != databaseId), ]

mdcdEst <- read.csv(file.path(exportFolder, "cohort_method_result.csv"))
colnames(mdcdEst) <- SqlRender::snakeCaseToCamelCase(colnames(mdcdEst))
mdcdEst$outcomeId[mdcdEst$outcomeId == 1770712] <- angioedema
mdcdEst$outcomeId[mdcdEst$outcomeId == 1770713] <- ami
mdcdEst$analysisId <- 3
est <- rbind(legendEst, mdcdEst)
est <- est[order(est$databaseId), ]

subset <- est[est$analysisId == 3 & est$outcomeId == angioedema, ]
EvidenceSynthesis::plotMetaAnalysisForest(logRr = subset$logRr,
                                          logLb95Ci = log(subset$ci95Lb),
                                          logUb95Ci = log(subset$ci95Ub),
                                          labels = subset$databaseId,
                                          xLabel = "Hazard ratio",
                                          fileName = file.path(outputFolder, "forest.png"))

EvidenceSynthesis::plotMetaAnalysisForest(logRr = subset$calibratedLogRr,
                                          logLb95Ci = log(subset$calibratedCi95Lb),
                                          logUb95Ci = log(subset$calibratedCi95Ub),
                                          labels = subset$databaseId,
                                          xLabel = "Hazard ratio",
                                          fileName = file.path(outputFolder, "forestCal.png"))

subset <- est[est$analysisId == 1 & est$databaseId == databaseId, ]
subset$calibratedCi95Ub <- exp(subset$calibratedLogRr + (subset$calibratedLogRr - log(subset$calibratedCi95Lb)))

sprintf("%.2f (%.2f - %.2f)", subset$rr, subset$ci95Lb, subset$ci95Ub)
sprintf("%.2f (%.2f - %.2f)", subset$calibratedRr, subset$calibratedCi95Lb, subset$calibratedCi95Ub)

