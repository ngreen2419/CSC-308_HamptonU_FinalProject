library(ggplot2)
library(dplyr)

options(scipen = 999)

# -----------------------------
# 1. LOAD INCOME DATA
# -----------------------------
income_data <- read.csv("2024(1).csv", skip = 1)

clean_income <- income_data[, c("Geographic.Area.Name", "Estimate..Households..Median.income..dollars.")]
colnames(clean_income) <- c("State", "Income")

clean_income$Income <- as.numeric(gsub(",", "", clean_income$Income))
clean_income <- clean_income[clean_income$State != "United States", ]

# -----------------------------
# 2. LOAD COST OF LIVING DATA
# -----------------------------
cost_data <- read.csv("CostOfLiving_2026.csv")

clean_cost <- cost_data[, c("State", "Cost.Of.Living..2026.")]
colnames(clean_cost) <- c("State", "CostOfLiving")

clean_cost$CostOfLiving <- as.numeric(gsub(",", "", clean_cost$CostOfLiving))

# -----------------------------
# 3. LOAD CAREER DATA
# -----------------------------
# If your file opens as one column, this method fixes it
career_state_raw <- read.csv("career_state.csv.csv", header = FALSE, stringsAsFactors = FALSE)
career_state <- read.csv(text = career_state_raw$V1, header = TRUE)

career_state$CareerScore <- as.numeric(career_state$CareerScore)

# Convert abbreviations to full state names
abbr_to_name <- c(
  AL="Alabama", AK="Alaska", AZ="Arizona", AR="Arkansas", CA="California",
  CO="Colorado", CT="Connecticut", DE="Delaware", FL="Florida", GA="Georgia",
  HI="Hawaii", ID="Idaho", IL="Illinois", IN="Indiana", IA="Iowa",
  KS="Kansas", KY="Kentucky", LA="Louisiana", ME="Maine", MD="Maryland",
  MA="Massachusetts", MI="Michigan", MN="Minnesota", MS="Mississippi",
  MO="Missouri", MT="Montana", NE="Nebraska", NV="Nevada", NH="New Hampshire",
  NJ="New Jersey", NM="New Mexico", NY="New York", NC="North Carolina",
  ND="North Dakota", OH="Ohio", OK="Oklahoma", OR="Oregon", PA="Pennsylvania",
  RI="Rhode Island", SC="South Carolina", SD="South Dakota", TN="Tennessee",
  TX="Texas", UT="Utah", VT="Vermont", VA="Virginia", WA="Washington",
  WV="West Virginia", WI="Wisconsin", WY="Wyoming", DC="District of Columbia"
)

career_state$State <- abbr_to_name[career_state$State]

# -----------------------------
# 4. MERGE DATASETS
# -----------------------------
affordability_data <- merge(clean_income, clean_cost, by = "State")
affordability_data$AffordabilityIndex <- affordability_data$Income / affordability_data$CostOfLiving

final_data <- merge(affordability_data, career_state, by = "State")

# -----------------------------
# 5. CREATE YOUNG PROFESSIONAL SCORE
# -----------------------------
final_data <- final_data %>%
  mutate(
    Affordability_z = as.numeric(scale(AffordabilityIndex)),
    Career_z = as.numeric(scale(CareerScore)),
    YoungProfessionalScore = (0.6 * Affordability_z) + (0.4 * Career_z)
  )

# -----------------------------
# 6. GRAPH 1: SCATTER PLOT
# -----------------------------
ggplot(final_data, aes(x = AffordabilityIndex, y = CareerScore)) +
  geom_point() +
  geom_text(aes(label = State), size = 2.5, vjust = -0.5) +
  labs(
    title = "Affordability vs Career Opportunity by State",
    x = "Affordability Index",
    y = "Career Opportunity Score"
  ) +
  theme_minimal()

# -----------------------------
# 7. GRAPH 2: TOP 10 STATES
# -----------------------------
top10 <- final_data %>%
  arrange(desc(YoungProfessionalScore)) %>%
  slice(1:10)

ggplot(top10, aes(x = reorder(State, YoungProfessionalScore), y = YoungProfessionalScore)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 States for Young Professionals",
    x = "State",
    y = "Young Professional Score"
  ) +
  theme_minimal()

# -----------------------------
# 8. VIEW RESULTS
# -----------------------------
print(head(final_data))
print(top10)