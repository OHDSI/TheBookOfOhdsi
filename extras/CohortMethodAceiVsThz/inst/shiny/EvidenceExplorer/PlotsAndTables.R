createTitle <- function(tcoDbs) {
  tcoDbs$targetName <- exposures$exposureName[match(tcoDbs$targetId, exposures$exposureId)]
  tcoDbs$comparatorName <- exposures$exposureName[match(tcoDbs$comparatorId, exposures$exposureId)]
  tcoDbs$outcomeName <- outcomes$outcomeName[match(tcoDbs$outcomeId, outcomes$outcomeId)]
  tcoDbs$indicationId <- exposures$indicationId[match(tcoDbs$targetId, exposures$exposureId)]

  titles <- paste(tcoDbs$outcomeName,
                  "risk in new-users of",
                  uncapitalize(tcoDbs$targetName),
                  "versus",
                  uncapitalize(tcoDbs$comparatorName),
                  "for",
                  uncapitalize(tcoDbs$indicationId),
                  "in the",
                  tcoDbs$databaseId,
                  "database")
  return(titles)
}

createAuthors <- function() {
  authors <- paste0(
    "Martijn J. Schuemie", ", ",
    "Patrick B. Ryan", ", ",
    "Seng Chan You", ", ",
    "Nicole Pratt", ", ",
    "David Madigan", ", ",
    "George Hripcsak", " and ",
    "Marc A. Suchard"
  )
}




createAbstract <- function(tcoDb) {
  
  targetName <- uncapitalize(exposures$exposureName[match(tcoDb$targetId, exposures$exposureId)])
  comparatorName <- uncapitalize(exposures$exposureName[match(tcoDb$comparatorId, exposures$exposureId)])
  outcomeName <- uncapitalize(outcomes$outcomeName[match(tcoDb$outcomeId, outcomes$outcomeId)])
  indicationId <- uncapitalize(exposures$indicationId[match(tcoDb$targetId, exposures$exposureId)])
  
  results <- getMainResults(connection,
                            targetIds = tcoDb$targetId,
                            comparatorIds = tcoDb$comparatorId,
                            outcomeIds = tcoDb$outcomeId,
                            databaseIds = tcoDb$databaseId)
  
  studyPeriod <- getStudyPeriod(connection = connection,
                                targetId = tcoDb$targetId,
                                comparatorId = tcoDb$comparatorId,
                                databaseId = tcoDb$databaseId)  
  
  writeAbstract(outcomeName, targetName, comparatorName, tcoDb$databaseId, studyPeriod, results)
}

writeAbstract <- function(outcomeName,
                           targetName,
                           comparatorName,
                           databaseId,
                           studyPeriod,
                           mainResults) {
  
  minYear <- substr(studyPeriod$minDate, 1, 4)
  maxYear <- substr(studyPeriod$maxDate, 1, 4)
  
  abstract <- paste0(
    "We conduct a large-scale study on the incidence of ", outcomeName, " among new users of ", targetName, " and ", comparatorName, " from ", minYear, " to ", maxYear, " in the ", databaseId, " database.  ",
    "Outcomes of interest are estimates of the hazard ratio (HR) for incident events between comparable new users under on-treatment and intent-to-treat risk window assumptions.  ",
    "Secondary analyses entertain possible clinically relevant subgroup interaction with the HR.  ",
    "We identify ", mainResults[1, "targetSubjects"], " ", targetName, " and ", mainResults[1, "comparatorSubjects"], " ", comparatorName, " patients for the on-treatment design, totaling ", round(mainResults[1, "targetDays"] / 365.24), " and ", round(mainResults[1, "comparatorDays"] / 365.24), " patient-years of observation, and ", mainResults[1, "targetOutcomes"], " and ", mainResults[1, "comparatorOutcomes"], " events respectively.  ",
    "We control for measured confounding using propensity score trimming and stratification or matching based on an expansive propensity score model that includes all measured patient features before treatment initiation.  ",
    "We account for unmeasured confounding using negative and positive controls to estimate and adjust for residual systematic bias in the study design and data source, providing calibrated confidence intervals and p-values.  ",
    "In terms of ", outcomeName, ", ", targetName, " has a ", judgeHazardRatio(mainResults[1, "calibratedCi95Lb"], mainResults[1, "calibratedCi95Ub"]), 
    " risk as compared to ", comparatorName, " [HR: ", prettyHr(mainResults[1, "calibratedRr"]), ", 95% confidence interval (CI) ", 
    prettyHr(mainResults[1, "calibratedCi95Lb"]), " - ", prettyHr(mainResults[1, "calibratedCi95Ub"]), "]."
  )

  abstract
}

prepareFollowUpDistTable <- function(followUpDist) {
  targetRow <- data.frame(Cohort = "Target",
                          Min = followUpDist$targetMinDays,
                          P10 = followUpDist$targetP10Days,
                          P25 = followUpDist$targetP25Days,
                          Median = followUpDist$targetMedianDays,
                          P75 = followUpDist$targetP75Days,
                          P90 = followUpDist$targetP90Days,
                          Max = followUpDist$targetMaxDays)
  comparatorRow <- data.frame(Cohort = "Comparator",
                              Min = followUpDist$comparatorMinDays,
                              P10 = followUpDist$comparatorP10Days,
                              P25 = followUpDist$comparatorP25Days,
                              Median = followUpDist$comparatorMedianDays,
                              P75 = followUpDist$comparatorP75Days,
                              P90 = followUpDist$comparatorP90Days,
                              Max = followUpDist$comparatorMaxDays)
  table <- rbind(targetRow, comparatorRow)
  table$Min <- formatC(table$Min, big.mark = ",", format = "d")
  table$P10 <- formatC(table$P10, big.mark = ",", format = "d")
  table$P25 <- formatC(table$P25, big.mark = ",", format = "d")
  table$Median <- formatC(table$Median, big.mark = ",", format = "d")
  table$P75 <- formatC(table$P75, big.mark = ",", format = "d")
  table$P90 <- formatC(table$P90, big.mark = ",", format = "d")
  table$Max <- formatC(table$Max, big.mark = ",", format = "d")
  return(table)
}

prepareMainResultsTable <- function(mainResults, analyses) {
  table <- mainResults
  table$hr <- sprintf("%.2f (%.2f - %.2f)", mainResults$rr, mainResults$ci95Lb, mainResults$ci95Ub)
  table$p <- sprintf("%.2f", table$p)
  table$calHr <- sprintf("%.2f (%.2f - %.2f)",
                         mainResults$calibratedRr,
                         mainResults$calibratedCi95Lb,
                         mainResults$calibratedCi95Ub)
  table$calibratedP <- sprintf("%.2f", table$calibratedP)
  table <- merge(table, analyses)
  table <- table[, c("description", "hr", "p", "calHr", "calibratedP")]
  colnames(table) <- c("Analysis", "HR (95% CI)", "P", "Cal. HR (95% CI)", "Cal. p")
  return(table)
}

preparePowerTable <- function(mainResults, analyses) {
  table <- merge(mainResults, analyses)
  alpha <- 0.05
  power <- 0.8
  z1MinAlpha <- qnorm(1 - alpha/2)
  zBeta <- -qnorm(1 - power)
  pA <- table$targetSubjects/(table$targetSubjects + table$comparatorSubjects)
  pB <- 1 - pA
  totalEvents <- abs(table$targetOutcomes) + (table$comparatorOutcomes)
  table$mdrr <- exp(sqrt((zBeta + z1MinAlpha)^2/(totalEvents * pA * pB)))
  table$targetYears <- table$targetDays/365.25
  table$comparatorYears <- table$comparatorDays/365.25
  table$targetIr <- 1000 * table$targetOutcomes/table$targetYears
  table$comparatorIr <- 1000 * table$comparatorOutcomes/table$comparatorYears
  table <- table[, c("description",
                     "targetSubjects",
                     "comparatorSubjects",
                     "targetYears",
                     "comparatorYears",
                     "targetOutcomes",
                     "comparatorOutcomes",
                     "targetIr",
                     "comparatorIr",
                     "mdrr")]
  table$targetSubjects <- formatC(table$targetSubjects, big.mark = ",", format = "d")
  table$comparatorSubjects <- formatC(table$comparatorSubjects, big.mark = ",", format = "d")
  table$targetYears <- formatC(table$targetYears, big.mark = ",", format = "d")
  table$comparatorYears <- formatC(table$comparatorYears, big.mark = ",", format = "d")
  table$targetOutcomes <- formatC(table$targetOutcomes, big.mark = ",", format = "d")
  table$comparatorOutcomes <- formatC(table$comparatorOutcomes, big.mark = ",", format = "d")
  table$targetIr <- sprintf("%.2f", table$targetIr)
  table$comparatorIr <- sprintf("%.2f", table$comparatorIr)
  table$mdrr <- sprintf("%.2f", table$mdrr)
  table$targetSubjects <- gsub("^-", "<", table$targetSubjects)
  table$comparatorSubjects <- gsub("^-", "<", table$comparatorSubjects)
  table$targetOutcomes <- gsub("^-", "<", table$targetOutcomes)
  table$comparatorOutcomes <- gsub("^-", "<", table$comparatorOutcomes)
  table$targetIr <- gsub("^-", "<", table$targetIr)
  table$comparatorIr <- gsub("^-", "<", table$comparatorIr)
  idx <- (table$targetOutcomes < 0 | table$comparatorOutcomes < 0)
  table$mdrr[idx] <- paste0(">", table$mdrr[idx])
  return(table)
}


prepareSubgroupTable <- function(subgroupResults, output = "latex") {
  rnd <- function(x) {
    ifelse(x > 10, sprintf("%.1f", x), sprintf("%.2f", x))
  }
  
  subgroupResults$hrr <- paste0(rnd(subgroupResults$rrr),
                                " (",
                                rnd(subgroupResults$ci95Lb),
                                " - ",
                                rnd(subgroupResults$ci95Ub),
                                ")")

  subgroupResults$hrr[is.na(subgroupResults$rrr)] <- ""
  subgroupResults$p <- sprintf("%.2f", subgroupResults$p)
  subgroupResults$p[subgroupResults$p == "NA"] <- ""
  subgroupResults$calibratedP <- sprintf("%.2f", subgroupResults$calibratedP)
  subgroupResults$calibratedP[subgroupResults$calibratedP == "NA"] <- ""
  
  if (any(grepl("on-treatment", subgroupResults$analysisDescription)) && 
      any(grepl("intent-to-treat", subgroupResults$analysisDescription))) {
    idx <- grepl("on-treatment", subgroupResults$analysisDescription)
    onTreatment <- subgroupResults[idx, c("interactionCovariateName",
                                          "targetSubjects",
                                          "comparatorSubjects",
                                          "hrr",
                                          "p",
                                          "calibratedP")]
    itt <- subgroupResults[!idx, c("interactionCovariateName", "hrr", "p", "calibratedP")]
    colnames(onTreatment)[4:6] <- paste("onTreatment", colnames(onTreatment)[4:6], sep = "_")
    colnames(itt)[2:4] <- paste("itt", colnames(itt)[2:4], sep = "_")
    table <- merge(onTreatment, itt)
  } else {
    table <- subgroupResults[, c("interactionCovariateName",
                                 "targetSubjects",
                                 "comparatorSubjects",
                                 "hrr",
                                 "p",
                                 "calibratedP")]
  } 
  table$interactionCovariateName <- gsub("Subgroup: ", "", table$interactionCovariateName)
  if (output == "latex") {
    table$interactionCovariateName <- gsub(">=", "$\\\\ge$ ", table$interactionCovariateName)
  }
  table$targetSubjects <- formatC(table$targetSubjects, big.mark = ",", format = "d")
  table$targetSubjects <- gsub("^-", "<", table$targetSubjects)
  table$comparatorSubjects <- formatC(table$comparatorSubjects, big.mark = ",", format = "d")
  table$comparatorSubjects <- gsub("^-", "<", table$comparatorSubjects)
  table$comparatorSubjects <- gsub("^<", "$<$", table$comparatorSubjects)
  return(table)
}

prepareTable1 <- function(balance,
                          beforeLabel = "Before stratification",
                          afterLabel = "After stratification",
                          targetLabel = "Target",
                          comparatorLabel = "Comparator",
                          percentDigits = 1,
                          stdDiffDigits = 2,
                          output = "latex",
                          pathToCsv = "Table1Specs.csv") {
  if (output == "latex") {
    space <- " "
  } else {
    space <- "&nbsp;"
  }
  specifications <- read.csv(pathToCsv, stringsAsFactors = FALSE)

  fixCase <- function(label) {
    idx <- (toupper(label) == label)
    if (any(idx)) {
      label[idx] <- paste0(substr(label[idx], 1, 1),
                           tolower(substr(label[idx], 2, nchar(label[idx]))))
    }
    return(label)
  }

  formatPercent <- function(x) {
    result <- format(round(100 * x, percentDigits), digits = percentDigits + 1, justify = "right")
    result <- gsub("^-", "<", result)
    result <- gsub("NA", "", result)
    result <- gsub(" ", space, result)
    return(result)
  }

  formatStdDiff <- function(x) {
    result <- format(round(x, stdDiffDigits), digits = stdDiffDigits + 1, justify = "right")
    result <- gsub("NA", "", result)
    result <- gsub(" ", space, result)
    return(result)
  }

  resultsTable <- data.frame()
  for (i in 1:nrow(specifications)) {
    if (specifications$analysisId[i] == "") {
      resultsTable <- rbind(resultsTable,
                            data.frame(Characteristic = specifications$label[i], value = ""))
    } else {
      idx <- balance$analysisId == specifications$analysisId[i]
      if (any(idx)) {
        if (specifications$covariateIds[i] != "") {
          covariateIds <- as.numeric(strsplit(specifications$covariateIds[i], ";")[[1]])
          idx <- balance$covariateId %in% covariateIds
        } else {
          covariateIds <- NULL
        }
        if (any(idx)) {
          balanceSubset <- balance[idx, ]
          if (is.null(covariateIds)) {
          balanceSubset <- balanceSubset[order(balanceSubset$covariateId), ]
          } else {
          balanceSubset <- merge(balanceSubset, data.frame(covariateId = covariateIds,
                                                           rn = 1:length(covariateIds)))
          balanceSubset <- balanceSubset[order(balanceSubset$rn, balanceSubset$covariateId), ]
          }
          balanceSubset$covariateName <- fixCase(gsub("^.*: ", "", balanceSubset$covariateName))
          if (specifications$covariateIds[i] == "" || length(covariateIds) > 1) {
          resultsTable <- rbind(resultsTable, data.frame(Characteristic = specifications$label[i],
                                                         beforeMatchingMeanTreated = NA,
                                                         beforeMatchingMeanComparator = NA,
                                                         beforeMatchingStdDiff = NA,
                                                         afterMatchingMeanTreated = NA,
                                                         afterMatchingMeanComparator = NA,
                                                         afterMatchingStdDiff = NA,
                                                         stringsAsFactors = FALSE))
          resultsTable <- rbind(resultsTable, data.frame(Characteristic = paste0(space,
                                                                                 space,
                                                                                 space,
                                                                                 space,
                                                                                 balanceSubset$covariateName),
                                                         beforeMatchingMeanTreated = balanceSubset$beforeMatchingMeanTreated,
                                                         beforeMatchingMeanComparator = balanceSubset$beforeMatchingMeanComparator,
                                                         beforeMatchingStdDiff = balanceSubset$beforeMatchingStdDiff,
                                                         afterMatchingMeanTreated = balanceSubset$afterMatchingMeanTreated,
                                                         afterMatchingMeanComparator = balanceSubset$afterMatchingMeanComparator,
                                                         afterMatchingStdDiff = balanceSubset$afterMatchingStdDiff,
                                                         stringsAsFactors = FALSE))
          } else {
          resultsTable <- rbind(resultsTable, data.frame(Characteristic = specifications$label[i],
                                                         beforeMatchingMeanTreated = balanceSubset$beforeMatchingMeanTreated,
                                                         beforeMatchingMeanComparator = balanceSubset$beforeMatchingMeanComparator,
                                                         beforeMatchingStdDiff = balanceSubset$beforeMatchingStdDiff,
                                                         afterMatchingMeanTreated = balanceSubset$afterMatchingMeanTreated,
                                                         afterMatchingMeanComparator = balanceSubset$afterMatchingMeanComparator,
                                                         afterMatchingStdDiff = balanceSubset$afterMatchingStdDiff,
                                                         stringsAsFactors = FALSE))
          }
        }
      }
    }
  }
  resultsTable$beforeMatchingMeanTreated <- formatPercent(resultsTable$beforeMatchingMeanTreated)
  resultsTable$beforeMatchingMeanComparator <- formatPercent(resultsTable$beforeMatchingMeanComparator)
  resultsTable$beforeMatchingStdDiff <- formatStdDiff(resultsTable$beforeMatchingStdDiff)
  resultsTable$afterMatchingMeanTreated <- formatPercent(resultsTable$afterMatchingMeanTreated)
  resultsTable$afterMatchingMeanComparator <- formatPercent(resultsTable$afterMatchingMeanComparator)
  resultsTable$afterMatchingStdDiff <- formatStdDiff(resultsTable$afterMatchingStdDiff)

  headerRow <- as.data.frame(t(rep("", ncol(resultsTable))))
  colnames(headerRow) <- colnames(resultsTable)
  headerRow$beforeMatchingMeanTreated <- targetLabel
  headerRow$beforeMatchingMeanComparator <- comparatorLabel
  headerRow$afterMatchingMeanTreated <- targetLabel
  headerRow$afterMatchingMeanComparator <- comparatorLabel

  subHeaderRow <- as.data.frame(t(rep("", ncol(resultsTable))))
  colnames(subHeaderRow) <- colnames(resultsTable)
  subHeaderRow$Characteristic <- "Characteristic"
  subHeaderRow$beforeMatchingMeanTreated <- "%"
  subHeaderRow$beforeMatchingMeanComparator <- "%"
  subHeaderRow$beforeMatchingStdDiff <- "Std. diff"
  subHeaderRow$afterMatchingMeanTreated <- "%"
  subHeaderRow$afterMatchingMeanComparator <- "%"
  subHeaderRow$afterMatchingStdDiff <- "Std. diff"

  resultsTable <- rbind(headerRow, subHeaderRow, resultsTable)

  colnames(resultsTable) <- rep("", ncol(resultsTable))
  colnames(resultsTable)[2] <- beforeLabel
  colnames(resultsTable)[5] <- afterLabel
  return(resultsTable)
}

plotPs <- function(ps, targetName, comparatorName) {
  ps <- rbind(data.frame(x = ps$preferenceScore, y = ps$targetDensity, group = targetName),
              data.frame(x = ps$preferenceScore, y = ps$comparatorDensity, group = comparatorName))
  ps$group <- factor(ps$group, levels = c(as.character(targetName), as.character(comparatorName)))
  theme <- ggplot2::element_text(colour = "#000000", size = 12, margin = ggplot2::margin(0, 0.5, 0, 0.1, "cm"))
  plot <- ggplot2::ggplot(ps,
                          ggplot2::aes(x = x, y = y, color = group, group = group, fill = group)) +
          ggplot2::geom_density(stat = "identity") +
          ggplot2::scale_fill_manual(values = c(rgb(0.8, 0, 0, alpha = 0.5),
                                                rgb(0, 0, 0.8, alpha = 0.5))) +
          ggplot2::scale_color_manual(values = c(rgb(0.8, 0, 0, alpha = 0.5),
                                                 rgb(0, 0, 0.8, alpha = 0.5))) +
          ggplot2::scale_x_continuous("Preference score", limits = c(0, 1)) +
          ggplot2::scale_y_continuous("Density") +
          ggplot2::theme(legend.title = ggplot2::element_blank(),
                         panel.grid.major = ggplot2::element_blank(),
                         panel.grid.minor = ggplot2::element_blank(),
                         legend.position = "top",
                         legend.text = theme,
                         axis.text = theme,
                         axis.title = theme)
  return(plot)
}

plotAllPs <- function(ps) {
  ps <- rbind(data.frame(targetName = ps$targetName,
                         comparatorName = ps$comparatorName,
                         x = ps$preferenceScore, 
                         y = ps$targetDensity, 
                         group = "Target"),
              data.frame(targetName = ps$targetName,
                         comparatorName = ps$comparatorName,
                         x = ps$preferenceScore, 
                         y = ps$comparatorDensity, 
                         group = "Comparator"))
  ps$group <- factor(ps$group, levels = c("Target", "Comparator"))
  plot <- ggplot2::ggplot(ps, ggplot2::aes(x = x, y = y, color = group, group = group, fill = group)) +
    ggplot2::geom_density(stat = "identity") +
    ggplot2::scale_fill_manual(values = c(rgb(0.8, 0, 0, alpha = 0.5), rgb(0, 0, 0.8, alpha = 0.5))) +
    ggplot2::scale_color_manual(values = c(rgb(0.8, 0, 0, alpha = 0.5), rgb(0, 0, 0.8, alpha = 0.5))) +
    ggplot2::scale_x_continuous("Preference score", limits = c(0, 1)) +
    ggplot2::scale_y_continuous("Density") +
    ggplot2::facet_grid(targetName ~ comparatorName) +
    ggplot2::theme(legend.title = ggplot2::element_blank(),
          axis.title.x = ggplot2::element_blank(),
          axis.text.x = ggplot2::element_blank(),
          axis.ticks.x = ggplot2::element_blank(),
          axis.title.y = ggplot2::element_blank(),
          axis.text.y = ggplot2::element_blank(),
          axis.ticks.y = ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          strip.text.x = ggplot2::element_text(size = 12, angle = 90, vjust = 0),
          strip.text.y = ggplot2::element_text(size = 12, angle = 0, hjust = 0),
          panel.spacing = ggplot2::unit(0.1, "lines"),
          legend.position = "none")
  return(plot)
}


plotCovariateBalanceScatterPlot <- function(balance, beforeLabel = "Before stratification", afterLabel = "After stratification") {
  limits <- c(min(c(balance$absBeforeMatchingStdDiff, balance$absAfterMatchingStdDiff),
                  na.rm = TRUE),
              max(c(balance$absBeforeMatchingStdDiff, balance$absAfterMatchingStdDiff),
                  na.rm = TRUE))
  theme <- ggplot2::element_text(colour = "#000000", size = 12)
  plot <- ggplot2::ggplot(balance, ggplot2::aes(x = absBeforeMatchingStdDiff, y = absAfterMatchingStdDiff)) +
    ggplot2::geom_point(color = rgb(0, 0, 0.8, alpha = 0.3), shape = 16, size = 2) +
    ggplot2::geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    ggplot2::geom_hline(yintercept = 0) +
    ggplot2::geom_vline(xintercept = 0) +
    ggplot2::scale_x_continuous(beforeLabel, limits = limits) +
    ggplot2::scale_y_continuous(afterLabel, limits = limits) +
    ggplot2::theme(text = theme)
  
  return(plot)
}

plotKaplanMeier <- function(kaplanMeier, targetName, comparatorName) {
  data <- rbind(data.frame(time = kaplanMeier$time,
                           s = kaplanMeier$targetSurvival,
                           lower = kaplanMeier$targetSurvivalLb,
                           upper = kaplanMeier$targetSurvivalUb,
                           strata = paste0(" ", targetName, "    ")),
                data.frame(time = kaplanMeier$time,
                           s = kaplanMeier$comparatorSurvival,
                           lower = kaplanMeier$comparatorSurvivalLb,
                           upper = kaplanMeier$comparatorSurvivalUb,
                           strata = paste0(" ", comparatorName)))

  xlims <- c(-max(data$time)/40, max(data$time))
  ylims <- c(min(data$lower), 1)
  xLabel <- "Time in days"
  yLabel <- "Survival probability"
  xBreaks <- kaplanMeier$time[!is.na(kaplanMeier$targetAtRisk)]
  plot <- ggplot2::ggplot(data, ggplot2::aes(x = time,
                                             y = s,
                                             color = strata,
                                             fill = strata,
                                             ymin = lower,
                                             ymax = upper)) +
          ggplot2::geom_ribbon(color = rgb(0, 0, 0, alpha = 0)) +
          ggplot2::geom_step(size = 1) +
          ggplot2::scale_color_manual(values = c(rgb(0.8, 0, 0, alpha = 0.8),
                                                 rgb(0, 0, 0.8, alpha = 0.8))) +
          ggplot2::scale_fill_manual(values = c(rgb(0.8, 0, 0, alpha = 0.3),
                                                rgb(0, 0, 0.8, alpha = 0.3))) +
          ggplot2::scale_x_continuous(xLabel, limits = xlims, breaks = xBreaks) +
          ggplot2::scale_y_continuous(yLabel, limits = ylims) +
          ggplot2::theme(legend.title = ggplot2::element_blank(),
                         legend.position = "top",
                         legend.key.size = ggplot2::unit(1, "lines"),
                         plot.title = ggplot2::element_text(hjust = 0.5)) +
          ggplot2::theme(axis.title.y = ggplot2::element_text(vjust = -10))

  targetAtRisk <- kaplanMeier$targetAtRisk[!is.na(kaplanMeier$targetAtRisk)]
  comparatorAtRisk <- kaplanMeier$comparatorAtRisk[!is.na(kaplanMeier$comparatorAtRisk)]
  labels <- data.frame(x = c(0, xBreaks, xBreaks),
                       y = as.factor(c("Number at risk",
                                       rep(targetName, length(xBreaks)),
                                       rep(comparatorName, length(xBreaks)))),
                       label = c("",
                                 formatC(targetAtRisk, big.mark = ",", mode = "integer"),
                                 formatC(comparatorAtRisk, big.mark = ",", mode = "integer")))
  labels$y <- factor(labels$y, levels = c(comparatorName, targetName, "Number at risk"))
  dataTable <- ggplot2::ggplot(labels, ggplot2::aes(x = x, y = y, label = label)) + ggplot2::geom_text(size = 3.5, vjust = 0.5) + ggplot2::scale_x_continuous(xLabel,
                                                                                                                                                              limits = xlims,
                                                                                                                                                              breaks = xBreaks) + ggplot2::theme(panel.grid.major = ggplot2::element_blank(),
                                                                                                                                                                                                                         panel.grid.minor = ggplot2::element_blank(),
                                                                                                                                                                                                                         legend.position = "none",
                                                                                                                                                                                                                         panel.border = ggplot2::element_blank(),
                                                                                                                                                                                                                         panel.background = ggplot2::element_blank(),
                                                                                                                                                                                                                         axis.text.x = ggplot2::element_text(color = "white"),
                                                                                                                                                                                                                         axis.title.x = ggplot2::element_text(color = "white"),
                                                                                                                                                                                                                         axis.title.y = ggplot2::element_blank(),
                                                                                                                                                                                                                         axis.ticks = ggplot2::element_line(color = "white"))
  plots <- list(plot, dataTable)
  grobs <- widths <- list()
  for (i in 1:length(plots)) {
    grobs[[i]] <- ggplot2::ggplotGrob(plots[[i]])
    widths[[i]] <- grobs[[i]]$widths[2:5]
  }
  maxwidth <- do.call(grid::unit.pmax, widths)
  for (i in 1:length(grobs)) {
    grobs[[i]]$widths[2:5] <- as.list(maxwidth)
  }
  plot <- gridExtra::grid.arrange(grobs[[1]], grobs[[2]], heights = c(400, 100))
  return(plot)
}

judgeCoverage <- function(values) {
  ifelse(any(values < 0.9), "poor", "acceptable")
}

getCoverage <- function(controlResults) {
  d <- rbind(data.frame(yGroup = "Uncalibrated",
                        logRr = controlResults$logRr,
                        seLogRr = controlResults$seLogRr,
                        ci95Lb = controlResults$ci95Lb,
                        ci95Ub = controlResults$ci95Ub,
                        trueRr = controlResults$effectSize),
             data.frame(yGroup = "Calibrated",
                        logRr = controlResults$calibratedLogRr,
                        seLogRr = controlResults$calibratedSeLogRr,
                        ci95Lb = controlResults$calibratedCi95Lb,
                        ci95Ub = controlResults$calibratedCi95Ub,
                        trueRr = controlResults$effectSize))
  d <- d[!is.na(d$logRr), ]
  d <- d[!is.na(d$ci95Lb), ]
  d <- d[!is.na(d$ci95Ub), ]
  if (nrow(d) == 0) {
    return(NULL)
  }

  d$Group <- as.factor(d$trueRr)
  d$Significant <- d$ci95Lb > d$trueRr | d$ci95Ub < d$trueRr

  temp2 <- aggregate(Significant ~ Group + yGroup, data = d, mean)
  temp2$coverage <- (1 - temp2$Significant)

  data.frame(true = temp2$Group, group = temp2$yGroup, coverage = temp2$coverage)
}

plotScatter <- function(controlResults) {
  size <- 2
  labelY <- 0.7
  d <- rbind(data.frame(yGroup = "Uncalibrated",
                        logRr = controlResults$logRr,
                        seLogRr = controlResults$seLogRr,
                        ci95Lb = controlResults$ci95Lb,
                        ci95Ub = controlResults$ci95Ub,
                        trueRr = controlResults$effectSize),
             data.frame(yGroup = "Calibrated",
                        logRr = controlResults$calibratedLogRr,
                        seLogRr = controlResults$calibratedSeLogRr,
                        ci95Lb = controlResults$calibratedCi95Lb,
                        ci95Ub = controlResults$calibratedCi95Ub,
                        trueRr = controlResults$effectSize))
  d <- d[!is.na(d$logRr), ]
  d <- d[!is.na(d$ci95Lb), ]
  d <- d[!is.na(d$ci95Ub), ]
  if (nrow(d) == 0) {
    return(NULL)
  }
  d$Group <- as.factor(d$trueRr)
  d$Significant <- d$ci95Lb > d$trueRr | d$ci95Ub < d$trueRr
  temp1 <- aggregate(Significant ~ Group + yGroup, data = d, length)
  temp2 <- aggregate(Significant ~ Group + yGroup, data = d, mean)
  temp1$nLabel <- paste0(formatC(temp1$Significant, big.mark = ","), " estimates")
  temp1$Significant <- NULL

  temp2$meanLabel <- paste0(formatC(100 * (1 - temp2$Significant), digits = 1, format = "f"),
                            "% of CIs include ",
                            temp2$Group)
  temp2$Significant <- NULL
  dd <- merge(temp1, temp2)
  dd$tes <- as.numeric(as.character(dd$Group))

  breaks <- c(0.1, 0.25, 0.5, 1, 2, 4, 6, 8, 10)
  theme <- ggplot2::element_text(colour = "#000000", size = 12)
  themeRA <- ggplot2::element_text(colour = "#000000", size = 12, hjust = 1)
  themeLA <- ggplot2::element_text(colour = "#000000", size = 12, hjust = 0)

  d$Group <- paste("True hazard ratio =", d$Group)
  dd$Group <- paste("True hazard ratio =", dd$Group)
  alpha <- 1 - min(0.95 * (nrow(d)/nrow(dd)/50000)^0.1, 0.95)
  plot <- ggplot2::ggplot(d, ggplot2::aes(x = logRr, y = seLogRr), environment = environment()) +
          ggplot2::geom_vline(xintercept = log(breaks), colour = "#AAAAAA", lty = 1, size = 0.5) +
          ggplot2::geom_abline(ggplot2::aes(intercept = (-log(tes))/qnorm(0.025), slope = 1/qnorm(0.025)),
                               colour = rgb(0.8, 0, 0),
                               linetype = "dashed",
                               size = 1,
                               alpha = 0.5,
                               data = dd) +
          ggplot2::geom_abline(ggplot2::aes(intercept = (-log(tes))/qnorm(0.975), slope = 1/qnorm(0.975)),
                               colour = rgb(0.8, 0, 0),
                               linetype = "dashed",
                               size = 1,
                               alpha = 0.5,
                               data = dd) +
          ggplot2::geom_point(size = size,
                              color = rgb(0, 0, 0, alpha = 0.05),
                              alpha = alpha,
                              shape = 16) +
          ggplot2::geom_hline(yintercept = 0) +
          ggplot2::geom_label(x = log(0.15),
                              y = 0.9,
                              alpha = 1,
                              hjust = "left",
                              ggplot2::aes(label = nLabel),
                              size = 5,
                              data = dd) +
          ggplot2::geom_label(x = log(0.15),
                              y = labelY,
                              alpha = 1,
                              hjust = "left",
                              ggplot2::aes(label = meanLabel),
                              size = 5,
                              data = dd) +
          ggplot2::scale_x_continuous("Hazard ratio",
                                      limits = log(c(0.1, 10)),
                                      breaks = log(breaks),
                                      labels = breaks) +
          ggplot2::scale_y_continuous("Standard Error", limits = c(0, 1)) +
          ggplot2::facet_grid(yGroup ~ Group) +
          ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                         panel.background = ggplot2::element_blank(),
                         panel.grid.major = ggplot2::element_blank(),
                         axis.ticks = ggplot2::element_blank(),
                         axis.text.y = themeRA,
                         axis.text.x = theme,
                         axis.title = theme,
                         legend.key = ggplot2::element_blank(),
                         strip.text.x = theme,
                         strip.text.y = theme,
                         strip.background = ggplot2::element_blank(),
                         legend.position = "none")

  return(plot)
}

plotLargeScatter <- function(d, xLabel) {
  d$Significant <- d$ci95Lb > 1 | d$ci95Ub < 1
  
  oneRow <- data.frame(nLabel = paste0(formatC(nrow(d), big.mark = ","), " estimates"),
                       meanLabel = paste0(formatC(100 *
                                                    mean(!d$Significant, na.rm = TRUE), digits = 1, format = "f"), "% of CIs includes 1"))
  
  breaks <- c(0.1, 0.25, 0.5, 1, 2, 4, 6, 8, 10)
  theme <- ggplot2::element_text(colour = "#000000", size = 12)
  themeRA <- ggplot2::element_text(colour = "#000000", size = 12, hjust = 1)
  themeLA <- ggplot2::element_text(colour = "#000000", size = 12, hjust = 0)
  
  alpha <- 1 - min(0.95 * (nrow(d)/50000)^0.1, 0.95)
  plot <- ggplot2::ggplot(d, ggplot2::aes(x = logRr, y = seLogRr)) +
    ggplot2::geom_vline(xintercept = log(breaks), colour = "#AAAAAA", lty = 1, size = 0.5) +
    ggplot2::geom_abline(ggplot2::aes(intercept = 0, slope = 1/qnorm(0.025)),
                         colour = rgb(0.8, 0, 0),
                         linetype = "dashed",
                         size = 1,
                         alpha = 0.5) +
    ggplot2::geom_abline(ggplot2::aes(intercept = 0, slope = 1/qnorm(0.975)),
                         colour = rgb(0.8, 0, 0),
                         linetype = "dashed",
                         size = 1,
                         alpha = 0.5) +
    ggplot2::geom_point(size = 2, color = rgb(0, 0, 0, alpha = 0.05), alpha = alpha, shape = 16) +
    ggplot2::geom_hline(yintercept = 0) +
    ggplot2::geom_label(x = log(0.11),
                        y = 1,
                        alpha = 1,
                        hjust = "left",
                        ggplot2::aes(label = nLabel),
                        size = 5,
                        data = oneRow) +
    ggplot2::geom_label(x = log(0.11),
                        y = 0.935,
                        alpha = 1,
                        hjust = "left",
                        ggplot2::aes(label = meanLabel),
                        size = 5,
                        data = oneRow) +
    ggplot2::scale_x_continuous(xLabel, limits = log(c(0.1,
                                                       10)), breaks = log(breaks), labels = breaks) +
    ggplot2::scale_y_continuous("Standard Error", limits = c(0, 1)) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                   panel.background = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   axis.text.y = themeRA,
                   axis.text.x = theme,
                   axis.title = theme,
                   legend.key = ggplot2::element_blank(),
                   strip.text.x = theme,
                   strip.background = ggplot2::element_blank(),
                   legend.position = "none")
  return(plot)
}



drawAttritionDiagram <- function(attrition,
                                 targetLabel = "Target",
                                 comparatorLabel = "Comparator") {
  addStep <- function(data, attrition, row) {
    label <- paste(strwrap(as.character(attrition$description[row]), width = 30), collapse = "\n")
    data$leftBoxText[length(data$leftBoxText) + 1] <- label
    data$rightBoxText[length(data$rightBoxText) + 1] <- paste(targetLabel,
                                                              ": n = ",
                                                              data$currentTarget - attrition$targetPersons[row],
                                                              "\n",
                                                              comparatorLabel,
                                                              ": n = ",
                                                              data$currentComparator - attrition$comparatorPersons[row],
                                                              sep = "")
    data$currentTarget <- attrition$targetPersons[row]
    data$currentComparator <- attrition$comparatorPersons[row]
    return(data)
  }
  data <- list(leftBoxText = c(paste("Exposed:\n",
                                     targetLabel,
                                     ": n = ",
                                     attrition$targetPersons[1],
                                     "\n",
                                     comparatorLabel,
                                     ": n = ",
                                     attrition$comparatorPersons[1],
                                     sep = "")), rightBoxText = c(""), currentTarget = attrition$targetPersons[1], currentComparator = attrition$comparatorPersons[1])
  for (i in 2:nrow(attrition)) {
    data <- addStep(data, attrition, i)
  }


  data$leftBoxText[length(data$leftBoxText) + 1] <- paste("Study population:\n",
                                                          targetLabel,
                                                          ": n = ",
                                                          data$currentTarget,
                                                          "\n",
                                                          comparatorLabel,
                                                          ": n = ",
                                                          data$currentComparator,
                                                          sep = "")
  leftBoxText <- data$leftBoxText
  rightBoxText <- data$rightBoxText
  nSteps <- length(leftBoxText)

  boxHeight <- (1/nSteps) - 0.03
  boxWidth <- 0.45
  shadowOffset <- 0.01
  arrowLength <- 0.01
  x <- function(x) {
    return(0.25 + ((x - 1)/2))
  }
  y <- function(y) {
    return(1 - (y - 0.5) * (1/nSteps))
  }

  downArrow <- function(p, x1, y1, x2, y2) {
    p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x1, y = y1, xend = x2, yend = y2))
    p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                       y = y2,
                                                       xend = x2 + arrowLength,
                                                       yend = y2 + arrowLength))
    p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                       y = y2,
                                                       xend = x2 - arrowLength,
                                                       yend = y2 + arrowLength))
    return(p)
  }
  rightArrow <- function(p, x1, y1, x2, y2) {
    p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x1, y = y1, xend = x2, yend = y2))
    p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                       y = y2,
                                                       xend = x2 - arrowLength,
                                                       yend = y2 + arrowLength))
    p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                       y = y2,
                                                       xend = x2 - arrowLength,
                                                       yend = y2 - arrowLength))
    return(p)
  }
  box <- function(p, x, y) {
    p <- p + ggplot2::geom_rect(ggplot2::aes_string(xmin = x - (boxWidth/2) + shadowOffset,
                                                    ymin = y - (boxHeight/2) - shadowOffset,
                                                    xmax = x + (boxWidth/2) + shadowOffset,
                                                    ymax = y + (boxHeight/2) - shadowOffset), fill = rgb(0,
                                                                                                         0,
                                                                                                         0,
                                                                                                         alpha = 0.2))
    p <- p + ggplot2::geom_rect(ggplot2::aes_string(xmin = x - (boxWidth/2),
                                                    ymin = y - (boxHeight/2),
                                                    xmax = x + (boxWidth/2),
                                                    ymax = y + (boxHeight/2)), fill = rgb(0.94,
                                                                                          0.94,
                                                                                          0.94), color = "black")
    return(p)
  }
  label <- function(p, x, y, text, hjust = 0) {
    p <- p + ggplot2::geom_text(ggplot2::aes_string(x = x, y = y, label = paste("\"", text, "\"",
                                                                                sep = "")),
                                hjust = hjust,
                                size = 3.7)
    return(p)
  }

  p <- ggplot2::ggplot()
  for (i in 2:nSteps - 1) {
    p <- downArrow(p, x(1), y(i) - (boxHeight/2), x(1), y(i + 1) + (boxHeight/2))
    p <- label(p, x(1) + 0.02, y(i + 0.5), "Y")
  }
  for (i in 2:(nSteps - 1)) {
    p <- rightArrow(p, x(1) + boxWidth/2, y(i), x(2) - boxWidth/2, y(i))
    p <- label(p, x(1.5), y(i) - 0.02, "N", 0.5)
  }
  for (i in 1:nSteps) {
    p <- box(p, x(1), y(i))
  }
  for (i in 2:(nSteps - 1)) {
    p <- box(p, x(2), y(i))
  }
  for (i in 1:nSteps) {
    p <- label(p, x(1) - boxWidth/2 + 0.02, y(i), text = leftBoxText[i])
  }
  for (i in 2:(nSteps - 1)) {
    p <- label(p, x(2) - boxWidth/2 + 0.02, y(i), text = rightBoxText[i])
  }
  p <- p + ggplot2::theme(legend.position = "none",
                          plot.background = ggplot2::element_blank(),
                          panel.grid.major = ggplot2::element_blank(),
                          panel.grid.minor = ggplot2::element_blank(),
                          panel.border = ggplot2::element_blank(),
                          panel.background = ggplot2::element_blank(),
                          axis.text = ggplot2::element_blank(),
                          axis.title = ggplot2::element_blank(),
                          axis.ticks = ggplot2::element_blank())

  return(p)
}

judgeHazardRatio <- function(hrLower, hrUpper) {
  nonZeroHazardRatio(hrLower, hrUpper, c("lower", "higher", "similar"))
}

nonZeroHazardRatio <- function(hrLower, hrUpper, terms) {
  if (hrUpper < 1) {
    return(terms[1])
  } else if (hrLower > 1) {
    return(terms[2])
  } else {
    return(terms[3])
  }
}

judgeEffectiveness <- function(hrLower, hrUpper) {
  nonZeroHazardRatio(hrLower, hrUpper, c("less", "more", "as"))
}

prettyHr <- function(x) {
  result <- sprintf("%.2f", x)
  result[is.na(x) | x > 100] <- "NA"
  return(result)
}

goodPropensityScore <- function(value) {
  return(value > 1)
}

goodSystematicBias <- function(value) {
  return(value > 1)
}

judgePropensityScore <- function(ps, bias) {
  paste0(" ",
         ifelse(goodPropensityScore(ps), "substantial", "inadequate"),
         " control of measured confounding by propensity score adjustment, and ",
         ifelse(goodSystematicBias(bias), "minimal", "non-negligible"),
         " residual systematic bias through negative and positive control experiments",
         ifelse(goodPropensityScore(ps) && goodSystematicBias(bias),
                ", lending credibility to our effect estimates",
                ""))
}

uncapitalize <- function(x) {
  if (is.character(x)) {
    substr(x, 1, 1) <- tolower(substr(x, 1, 1))
  }
  x
}

capitalize <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

createDocument <- function(targetId,
                           comparatorId,
                           outcomeId,
                           databaseId,
                           indicationId,
                           outputFile,
                           template = "template.Rnw",
                           workingDirectory = "temp",
                           emptyWorkingDirectory = TRUE) {
  
  if (missing(outputFile)) {
    stop("Must provide an output file name")
  }
  
  currentDirectory <- getwd()
  on.exit(setwd(currentDirectory))
  
  input <- file(template, "r")
  
  name <- paste0("paper_", targetId, "_", comparatorId, "_", outcomeId, "_", databaseId)
  
  if (!dir.exists(workingDirectory)) {
    dir.create(workingDirectory)
  }
  
  workingDirectory <- file.path(workingDirectory, name)
  
  if (!dir.exists(workingDirectory)) {
    dir.create(workingDirectory)
  }
  
  if (is.null(setwd(workingDirectory))) {
    stop(paste0("Unable to change directory into: ", workingDirectory))
  }
  
  system(paste0("cp ", file.path(currentDirectory, "pnas-new.cls"), " ."))
  system(paste0("cp ", file.path(currentDirectory, "widetext.sty"), " ."))
  system(paste0("cp ", file.path(currentDirectory, "pnasresearcharticle.sty"), " ."))
  system(paste0("cp ", file.path(currentDirectory, "Sweave.sty"), " ."))
  
  texName <- paste0(name, ".Rnw")
  output <- file(texName, "w")
  
  while (TRUE) {
    line <- readLines(input, n = 1)
    if (length(line) == 0) {
      break
    }
    line <- sub("DATABASE_ID_TAG", paste0("\"", databaseId, "\""), line)
    line <- sub("TARGET_ID_TAG", targetId, line)
    line <- sub("COMPARATOR_ID_TAG", comparatorId, line)
    line <- sub("OUTCOME_ID_TAG", outcomeId, line)
    line <- sub("INDICATION_ID_TAG", indicationId, line)
    line <- sub("CURRENT_DIRECTORY", currentDirectory, line)
    writeLines(line, output)
  }
  close(input)
  close(output)
  
  Sweave(texName)
  system(paste0("pdflatex ", name))
  system(paste0("pdflatex ", name))
  
  # Save result
  workingName <- file.path(workingDirectory, name)
  workingName <- paste0(workingName, ".pdf")
  
  setwd(currentDirectory)
  
  system(paste0("cp ", workingName, " ", outputFile))
  
  if (emptyWorkingDirectory) {
    # deleteName = file.path(workingDirectory, "*")
    # system(paste0("rm ", deleteName))
    unlink(workingDirectory, recursive = TRUE)
  }
  
  invisible(outputFile)
}

