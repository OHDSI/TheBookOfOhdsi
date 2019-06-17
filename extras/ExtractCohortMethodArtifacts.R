library(CohortMethod)

outputFolder <- "s:/CohortMethodAceiVsThz"

cmFolder <- file.path(outputFolder, "cmOutput")
omr <- readRDS(file.path(cmFolder, "outcomeModelReference.rds"))

cmData <- loadCohortMethodData(file.path(cmFolder,omr$cohortMethodDataFolder[1]), )
cmData

summary(cmData)

studyPop <- readRDS(file.path(cmFolder,omr$studyPopFile[omr$outcomeId == 1770712]), )
getAttritionTable(studyPop)

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

matchedPop <- readRDS(file.path(cmFolder,omr$strataFile[omr$outcomeId == 1770712]), )
CohortMethod::drawAttritionDiagram(matchedPop, fileName = file.path(outputFolder, "attrition.png"))

computeMdrr(matchedPop)

plotFollowUpDistribution(matchedPop, targetLabel = "ACE inhibitors", comparatorLabel = "Thiazides and thiazide-like diuretics", fileName = file.path(outputFolder, "followUp.png"))

om <- readRDS(file.path(cmFolder,omr$outcomeModelFile[omr$outcomeId == 1770712]), )
om

CohortMethod::plotKaplanMeier(matchedPop, targetLabel = "ACE inhibitors", comparatorLabel = "Thiazides and thiazide-like diuretics", fileName = file.path(outputFolder, "kmPlot.png"))

balance <- readRDS(file.path(outputFolder, "balance", "bal_t1770710_c1770711_o1770712_a1.rds"))
CohortMethod::plotCovariateBalanceScatterPlot(balance, showCovariateCountLabel = TRUE, showMaxLabel = TRUE, fileName = file.path(outputFolder, "balance.png"))
