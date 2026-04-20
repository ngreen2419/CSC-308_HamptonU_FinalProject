# Income vs. Cost of Living Analysis — U.S. States

This project analyzes the relationship between household income and cost of living across all 50 U.S. states using publicly available data. Three R scripts are included, each producing a standalone visualization.

---

## Data Sources

| File | Source | Description |
|---|---|---|
| `2024.csv` | U.S. Census Bureau — ACS Table S1901 | Median household income estimates by state (2024) |
| `CostOfLiving_2026.csv` | Missouri Economic Research and Information Center (MERIC) | Statewide cost of living estimates (2026) |

Both files should be placed in the same directory as the R scripts before running.

---

## Scripts

### 1. `cost_of_living_chart.R`
Produces a horizontal bar chart of the total annual cost of living for each state, sorted from lowest to highest.

- **Input:** `CostOfLiving_2026.csv`
- **Key variable:** `CostOfLiving` — total annual expenditures per state (USD)
- **Output:** Bar chart with dollar-formatted axis labels and value labels on each bar
- **Color scale:** Light blue (low cost) → Dark blue (high cost)

---

### 2. `median_income_chart.R`
Produces a horizontal bar chart of estimated median household income for each state, sorted from lowest to highest.

- **Input:** `2024.csv` (skips header row 1)
- **Key variable:** `Income` — median household income per state (USD)
- **Preprocessing:** Removes the national "United States" aggregate row
- **Output:** Bar chart with dollar-formatted axis labels and value labels on each bar
- **Color scale:** Light blue (low income) → Dark blue (high income)

---

### 3. `affordability_index.R`
Merges both datasets and calculates an Affordability Index for each state. This is the primary analytical output of the project.

- **Input:** `CostOfLiving_2026.csv` and `2024.csv`
- **Key variable:** `AffordabilityIndex = Income / CostOfLiving`
- **Interpretation:**
  - A value **above 1.0** means average income exceeds the cost of living
  - A value **below 1.0** means average income does not fully cover the cost of living
- **Output:** Bar chart sorted by Affordability Index with a red dashed reference line at 1.0
- **Color scale:** Tomato red (low affordability) → Steel blue (high affordability)
- **Note:** A mismatch check is run before merging. If any state names differ between the two CSVs, a warning is printed to the console listing the affected states.

---

## Affordability Index Definition

```
Affordability Index = Median Household Income / Total Cost of Living
```

This index is distinct from MERIC's own cost of living index, which uses a U.S. average baseline of 100 to compare relative costs across states. The Affordability Index here directly measures how well income covers living costs in dollar terms.

---

## Requirements

- R (version 4.0 or higher recommended)
- `ggplot2` package

Install ggplot2 if needed:
```r
install.packages("ggplot2")
```

---

## Project Structure

```
your-project/
│
├── 2024.csv                      # ACS income data
├── CostOfLiving_2026.csv         # MERIC cost of living data
│
├── cost_of_living_chart.R        # Script 1 — Cost of living bar chart
├── median_income_chart.R         # Script 2 — Median income bar chart
├── affordability_index.R         # Script 3 — Affordability Index chart
└── README.md                     # This file
```
