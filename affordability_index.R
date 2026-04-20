# ============================================================
# Affordability Index by State
# Income / Cost of Living
# ============================================================

library(ggplot2)
options(scipen = 999)

# ------------------------------------------------------------
# Load & Clean Cost of Living Data
# ------------------------------------------------------------
cost_data <- read.csv("CostOfLiving_2026.csv")
clean_cost <- cost_data[, c("State", "Cost.Of.Living..2026.")]
colnames(clean_cost) <- c("State", "CostOfLiving")
clean_cost$CostOfLiving <- as.numeric(gsub(",", "", clean_cost$CostOfLiving))
clean_cost <- clean_cost[!is.na(clean_cost$CostOfLiving), ]

# ------------------------------------------------------------
# Load & Clean Income Data
# ------------------------------------------------------------
data <- read.csv("2024.csv", skip = 1)
clean_data <- data[, c("Geographic.Area.Name", "Estimate..Households..Median.income..dollars.")]
colnames(clean_data) <- c("State", "Income")
clean_data$Income <- as.numeric(gsub(",", "", clean_data$Income))
clean_data <- clean_data[clean_data$State != "United States", ]
clean_data <- clean_data[!is.na(clean_data$Income), ]

# ------------------------------------------------------------
# Merge Datasets & Calculate Affordability Index
# ------------------------------------------------------------

# Check for mismatched state names before merging
mismatches <- setdiff(clean_data$State, clean_cost$State)
if (length(mismatches) > 0) {
  message("Warning: The following states did not match and will be dropped: ",
          paste(mismatches, collapse = ", "))
}

merged <- merge(clean_data, clean_cost, by = "State")
merged$AffordabilityIndex <- merged$Income / merged$CostOfLiving

# ------------------------------------------------------------
# Plot
# ------------------------------------------------------------
ggplot(merged, aes(x = reorder(State, AffordabilityIndex), y = AffordabilityIndex, fill = AffordabilityIndex)) +
  geom_col(width = 0.7) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red", linewidth = 0.5) +
  geom_text(aes(label = round(AffordabilityIndex, 2)),
            hjust = -0.1, size = 2.2) +
  coord_flip() +
  labs(
    title    = "Affordability Index by State",
    subtitle = "Red dashed line = 1.0 (Income fully covers Cost of Living)",
    x        = "State",
    y        = "Affordability Index (Income \u00f7 Cost of Living)"
  ) +
  scale_fill_gradient(low = "tomato", high = "steelblue") +
  scale_y_continuous(expand = c(0, 0.1)) +
  theme_minimal() +
  theme(
    axis.text.y        = element_text(size = 5),
    axis.text.x        = element_text(size = 10),
    plot.title         = element_text(size = 14, face = "bold"),
    plot.subtitle      = element_text(size = 9, color = "gray40"),
    plot.margin        = margin(20, 50, 20, 60),
    panel.grid.major.y = element_blank(),
    legend.position    = "none"
  )
