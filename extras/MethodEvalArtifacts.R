# Fetch data from Shiny app:

exportFolder <- "C:/Users/mschuemi/git/ShinyDeploy/MethodEvalViewer/data"
shinySettings <- list(exportFolder = "C:/Users/mschuemi/git/ShinyDeploy/MethodEvalViewer/data")
source("C:/Users/mschuemi/git/ShinyDeploy/MethodEvalViewer/global.R")
# calibrated <- "Calibrated"
# metric = "Mean precision"

calibrated <- "Uncalibrated"
calibrated <- "Calibrated"
metric = "Coverage"

computeMetrics <- function(forEval, metric = "Mean precision") {
  if (metric == "AUC")
    y <- round(pROC::auc(pROC::roc(forEval$targetEffectSize > 1, forEval$logRr, algorithm = 3)), 2)
  else if (metric == "Coverage")
    y <- round(mean(forEval$ci95Lb < forEval$trueEffectSize & forEval$ci95Ub > forEval$trueEffectSize), 2)
  else if (metric == "Mean precision")
    y <- round(-1 + exp(mean(log(1 + (1/(forEval$seLogRr^2))))), 2)
  else if (metric == "Mean squared error (MSE)")
    y <- round(mean((forEval$logRr - log(forEval$trueEffectSize))^2), 2)
  else if (metric == "Type I error")
    y <- round(mean(forEval$p[forEval$targetEffectSize == 1] < 0.05), 2)
  else if (metric == "Type II error")
    y <- round(mean(forEval$p[forEval$targetEffectSize > 1] >= 0.05), 2)
  else if (metric == "Non-estimable")
    y <- round(mean(forEval$seLogRr >= 99), 2)
  return(data.frame(database = forEval$database[1],
                    method = forEval$method[1],
                    analysisId = forEval$analysisId[1],
                    stratum = forEval$stratum[1],
                    y = y))
}
subset <- estimates[!is.na(estimates$mdrrTarget) & estimates$mdrrTarget <= 1.25, ]
if (calibrated == "Calibrated") {
  subset$logRr <- subset$calLogRr
  subset$seLogRr <- subset$calSeLogRr
  subset$ci95Lb <- subset$calCi95Lb
  subset$ci95Ub <- subset$calCi95Ub
  subset$p <- subset$calP
}

groups <- split(subset, paste(subset$method, subset$analysisId, subset$database, subset$stratum))
metrics <- lapply(groups, computeMetrics, metric = metric)
metrics <- do.call("rbind", metrics)
strataSubset <- strata[strata != "All"]
strataSubset <- data.frame(stratum = strataSubset,
                           x = 1:length(strataSubset),
                           stringsAsFactors = FALSE)
metrics <- merge(metrics, strataSubset)
methods <- unique(metrics$method)
methods <- methods[order(methods)]
n <- length(methods)
methods <- data.frame(method = methods,
                      offsetX = ((1:n / (n + 1)) - ((n + 1) / 2) / (n + 1)))
metrics <- merge(metrics, methods)
metrics$x <- metrics$x + metrics$offsetX
metrics$stratum <- as.character(metrics$stratum)
metrics$stratum[metrics$stratum == "Inflammatory Bowel Disease"] <- "IBD"
metrics$stratum[metrics$stratum == "Acute pancreatitis"] <- "Acute\npancreatitis"
metrics$stratum[metrics$stratum == "Ciprofloxacin"] <- "Cipro-\nfloxacin"
metrics$stratum[metrics$stratum == "GI bleeding"] <- "GI\nbleeding"
strataSubset$stratum <- as.character(strataSubset$stratum)
strataSubset$stratum[strataSubset$stratum == "Inflammatory Bowel Disease"] <- "IBD"
strataSubset$stratum[strataSubset$stratum == "Acute pancreatitis"] <- "Acute\npancreatitis"
strataSubset$stratum[strataSubset$stratum == "Ciprofloxacin"] <- "Cipro-\nfloxacin"
strataSubset$stratum[strataSubset$stratum == "GI bleeding"] <- "GI\nbleeding"
metrics$method <- as.character(metrics$method)
metrics$method[metrics$method == "CaseControl"] <- "Case-control"
metrics$method[metrics$method == "CaseCrossover"] <- "Case-crossover"
metrics$method[metrics$method == "CohortMethod"] <- "Cohort method"
metrics$method[metrics$method == "SelfControlledCaseSeries"] <- "SCCS"
metrics$method[metrics$method == "SelfControlledCohort"] <- "Self-controlled cohort"
metrics <- metrics[metrics$y != 0, ]

fiveColors <- c(
  "#781C86",
  "#83BA70",
  "#D3AE4E",
  "#547BD3",
  "#DF4327"
)


yLabel <- paste0(metric, if (calibrated == "Calibrated") " after empirical calibration" else "")
point <- scales::format_format(big.mark = " ", decimal.mark = ".", scientific = FALSE)
percent <- scales::percent
plot <- ggplot2::ggplot(metrics, ggplot2::aes(x = x, y = y, color = method)) +
  ggplot2::geom_vline(xintercept = 0.5 + 0:(nrow(strataSubset) - 1), colour = "#CCCCCC") +
  ggplot2::geom_hline(yintercept = 0.95, linetype = "dashed") +
  ggplot2::geom_point(size = 2.5, alpha = 0.5, shape = 16) +
  ggplot2::scale_colour_manual(values = fiveColors) +
  ggplot2::scale_x_continuous(breaks = strataSubset$x, labels = strataSubset$stratum) +
  ggplot2::facet_grid(database~., scales = "free_y") +
  # ggplot2::guides(color = ggplot2::guide_legend(nrow = 2, byrow = TRUE)) +
  ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                 panel.background = ggplot2::element_blank(),
                 panel.grid.major.x = ggplot2::element_blank(),
                 panel.grid.major.y = ggplot2::element_line(colour = "#CCCCCC"),
                 axis.ticks = ggplot2::element_blank(),
                 axis.title.x = ggplot2::element_blank(),
                 panel.spacing = ggplot2::unit(1, "lines"),
                 legend.position = "top",
                 legend.title = ggplot2::element_blank())
if (metric %in% c("Mean precision", "Mean squared error (MSE)")) {
  plot <- plot + ggplot2::scale_y_log10(yLabel, labels = point)
} else if (metric %in% c("Coverage")) {
  plot <- plot + ggplot2::scale_y_continuous(yLabel, labels = percent)
} else {
  plot <- plot + ggplot2::scale_y_continuous(yLabel, labels = point)
}

ggplot2::ggsave(filename = file.path("images", "MethodValidity", "methodEval.png"), plot = plot, width = 6.5, height = 6, dpi = 300)
