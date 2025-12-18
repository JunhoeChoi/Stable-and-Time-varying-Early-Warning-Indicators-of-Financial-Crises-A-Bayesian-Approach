# ----------------------------
# Overview of estimated coefficients
# ----------------------------
library(ggplot2)

# Set recession periods
recession <- data.frame(xmin = c(1914, 1933, 1939),
                        xmax = c(1918, 1939, 1945))

ggplot(beta_df, aes(x = year, y = variable, fill = med)) +
  geom_tile() +
  scale_fill_gradient2(
    name = "coefs",
    low = "blue", mid = "white", high = "red",
    midpoint = 0
  ) +
  geom_rect(data = recession,inherit.aes = FALSE, 
            aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 1)+
  labs(x = "Year", y = "Variables") +
  theme_minimal(base_size = 10) +
  theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "beige", color = 'grey'),
    plot.background  = element_rect(fill = "beige", color = 'black'),
    axis.text.y = element_text(size = 9),
    axis.text.x = element_text(size = 11),
    legend.position = "right"
  )


