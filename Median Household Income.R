library(ggplot2)

options(scipen = 999)

data <- read.csv("2024.csv", skip = 1)

clean_data <- data[, c("Geographic.Area.Name", "Estimate..Households..Median.income..dollars.")]
colnames(clean_data) <- c("State", "Income")

clean_data$Income <- as.numeric(gsub(",", "", clean_data$Income))

clean_data <- clean_data[clean_data$State!="United States", ]

ggplot(clean_data, aes(x = reorder(State, Income), y=Income, fill=Income))+
  geom_col(width = 0.7)+
  geom_text(aes(label = paste0("$", format(Income, big.mark=","))),
            hjust = -0.1, size = 2.2)+
  coord_flip() +
  
  labs(title = "Estimated Median Household Income by State",
       x = "State",
       y = "Estimated Median Income (2024)") +
  
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  
  # Add dollar signs to x-axis
  scale_y_continuous(
    labels = function(x) paste0("$", format(x, big.mark=",")),
    expand = expansion(mult = c(0, 0.1))
  ) +
  
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 6),
    axis.text.x = element_text(size = 10),
    plot.title = element_text(size = 14, face = "bold"),
    plot.margin = margin(20, 40, 20, 20),
    panel.grid.major.y = element_blank(),
    legend.position = "none"
  )
