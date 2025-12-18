# ----------------------------
# Draw EWI Graphs
# ----------------------------
library(ggplot2)

# Set recession periods
recession <- data.frame(xmin = c(1914, 1933, 1939),
                        xmax = c(1918, 1939, 1945))

# Draw All variables
ggplot(beta_df, aes(x = year, y = med)) +
  # 95% credible interval
  geom_ribbon(aes(ymin = low, ymax = high), fill = "blue",alpha = 0.25) +
  geom_rect(data = recession,inherit.aes = FALSE, 
            aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 1)+
  # median line
  geom_line(linewidth = 0.6) +
  # zero line
  geom_hline(yintercept = 0, linetype = "dashed") +
  facet_wrap(~ variable, ncol = 4, scales = "free_y") +
  labs(x = "Year", y = NULL) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.background = element_rect(fill = "beige", color = 'grey'),
    plot.background  = element_rect(fill = "beige", color = 'black'),
    strip.background = element_rect(fill = "beige"),
    panel.grid.minor = element_blank()
  )
  
# ----------------------------
# Select Time varying EWIs and Stavle EWIs 
# See beta, theta, and credible interval (should mostly not cover 0)
# ----------------------------

ewi_vary <- c("Credit to GDP Change*","Equity Growth","Slope of Yield Curves*")
ewi_stable <- c("Credit to GDP Change","Noncore Funding Ratio Change","Slope of Yield Curves","Real Houseprice Growth")

ewi_vary_df <- subset(beta_df, variable %in% ewi_vary)
ewi_stable_df <- subset(beta_df, variable %in% ewi_stable)

# ----------------------------
# Time-varying EWIs
# ----------------------------

ggplot(ewi_vary_df, aes(x = year, y = med)) +
  # 95% credible interval
  geom_ribbon(aes(ymin = low, ymax = high), fill = "blue",alpha = 0.25) +
  geom_rect(data = recession,inherit.aes = FALSE, 
            aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 1)+
  # median line
  geom_line(linewidth = 0.6) +
  # zero line
  geom_hline(yintercept = 0, linetype = "dashed") +
  facet_wrap(~ variable, ncol = 2, scales = "free_y") +
  labs(x = "Year", y = NULL) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.background = element_rect(fill = "beige", color = 'grey'),
    plot.background  = element_rect(fill = "beige", color = 'black'),
    strip.background = element_rect(fill = "beige"),
    panel.grid.minor = element_blank()
  )


# ----------------------------
# Stable EWIs
# ----------------------------
ggplot(ewi_stable_df, aes(x = year, y = med)) +
  # 95% credible interval
  geom_ribbon(aes(ymin = low, ymax = high), fill = "red",alpha = 0.25) +
  geom_rect(data = recession,inherit.aes = FALSE, 
            aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf), fill = "grey", alpha = 1)+
  # median line
  geom_line(linewidth = 0.6) +
  # zero line
  geom_hline(yintercept = 0, linetype = "dashed") +
  facet_wrap(~ variable, ncol = 2, scales = "free_y") +
  labs(x = "Year", y = NULL) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.background = element_rect(fill = "beige", color = 'grey'),
    plot.background  = element_rect(fill = "beige", color = 'black'),
    strip.background = element_rect(fill = "beige"),
    panel.grid.minor = element_blank()
  )
