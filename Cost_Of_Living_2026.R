library(ggplot2)

options(scipen = 999)

cost_data <- read.csv("CostOfLiving_2026.csv")

clean_cost <- cost_data[, c("State", "Cost.Of.Living..2026.")]
colnames(clean_cost) <- c("State", "CostOfLiving")

clean_cost$CostOfLiving <- as.numeric(gsub(",", "", clean_cost$CostOfLiving))

ggplot(clean_cost, aes(x = reorder(State, CostOfLiving), y = CostOfLiving, fill = CostOfLiving)) +
  geom_col(width = 0.7)+
  geom_text(aes(label = paste0("$", format(CostOfLiving, big.mark=","))),
            hjust = -0.1, size = 2.2) +
  coord_flip()+
  
  labs(title = "Cost of Living by State",
       x = "State",
       y = "Annual Total Expenditures (2026)")+
  
  scale_fill_gradient(low = "lightblue", high = "darkblue")+
  
  # Add dollar sign to x-axis
  scale_y_continuous(
    labels = function(x) paste0("$", format(x, big.mark = ",")),
    expand = expansion(mult = c(0, 0.1))
  )+
  
  theme_minimal()+
  theme(
    axis.text.y = element_text(size = 5),
    axis.text.x = element_text(size = 10),
    plot.title = element_text(size = 14, face = "bold"),
    plot.margin = margin(20, 50, 20, 60),
    panel.grid.major.y = element_blank(),
    legend.position = "none"
  )
