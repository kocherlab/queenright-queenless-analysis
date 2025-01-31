# Load necessary libraries
library(lme4)
library(tidyverse)
library(stringr)
library(wesanderson)
library(cowplot)
library(ggbeeswarm)

source("scripts/manuscript/constants.R")
source("scripts/manuscript/load_data.R")

# Reorder and rename levels of bds$QR_Queen_Condition

bds_means <- bds_means %>%
  mutate(QR_Queen_Condition = case_when(
    QR_Queen_Condition == "Queenless" ~ "Queenless\nWorker",
    QR_Queen_Condition == "Queenright" ~ "Queenright\nWorker",
    TRUE ~ QR_Queen_Condition # This retains the names for "Queen" and "Keystone"
  )) %>%
  mutate(QR_Queen_Condition = factor(QR_Queen_Condition, levels = c("Queen", "Queenright\nWorker", "Queenless\nWorker")))


# Map the categories to new names
bds_means_of_means <- bds_means_of_means %>%
  mutate(QR_Queen_Condition = case_when(
    QR_Queen_Condition == "Queenless" ~ "Queenless\nWorker",
    QR_Queen_Condition == "Queenright" ~ "Queenright\nWorker",
    TRUE ~ QR_Queen_Condition # This retains the names for "Queen" and "Keystone"
  )) %>%
  mutate(QR_Queen_Condition = factor(QR_Queen_Condition, levels = c("Queen", "Queenright\nWorker", "Queenless\nWorker")))

# Define dodge position
dodge <- position_dodge(width = 0.6)

# Plot Degree with SE error bars
plot_degree <- ggplot(bds_means %>% filter(QR_Queen_Condition != "Queen"), aes(x = QR_Queen_Condition, y = Degree)) +
  geom_line(data = bds_means_of_means, aes(group = Trial), color = "darkgray", linewidth = 0.2) +
  geom_point(data = bds_means_of_means %>% filter(Queen == 1), aes(color = Trial, fill = Trial), size = 3, shape = 21, stroke = 0.2, position = position_dodge(width = 0), color = "black") +
  geom_beeswarm(aes(color = Trial), stroke = 0, size = 1, alpha = .2, method = "hex") +
  geom_point(data = bds_means_of_means %>% filter(Queen == 0), aes(color = Trial, fill = Trial), size = 3, shape = 21, stroke = 0.2, position = position_dodge(width = 0), color = "black") +
  scale_color_manual(
    values = COLONY_COLORS,
    labels = c("Col 1", "Col 2", "Col 3", "Col 4", "Col 5") # Replace with your actual labels
  ) +
  scale_fill_manual(values = COLONY_COLORS, labels = c("Col 1", "Col 2", "Col 3", "Col 4", "Col 5")) +
  xlab("") +
  ylab("Std. Interactions per Hour") +
  CONSISTENT_THEME +
  theme(
    legend.position = "top",
    legend.direction = "horizontal",
    legend.title = element_blank(), # Removes the legend title if not needed
    legend.spacing.x = unit(0.2, "cm"), # Reduces the space between legend labels
    legend.margin = margin(t = 0, r = 0, b = 0, l = 0), # Reduces the margin around the legend
    legend.key.width = unit(0.25, "cm"), # Reduces the width of the legend keys
    legend.key.height = unit(0.25, "cm"), # Reduces the height of the legend keys
    axis.title.y = element_text(size = 8)
  )

# Plot Initiation.Freq with SE error bars
plot_init_freq <- ggplot(bds_means %>% filter(QR_Queen_Condition != "Queen"), aes(x = QR_Queen_Condition, y = Initiation.Freq)) +
  geom_line(data = bds_means_of_means, aes(group = Trial), color = "darkgray", linewidth = 0.2) +
  geom_point(data = bds_means_of_means %>% filter(Queen == 1), aes(color = Trial, fill = Trial), size = 3, shape = 21, stroke = 0.2, position = position_dodge(width = 0), color = "black") +
  geom_beeswarm(aes(color = Trial), stroke = 0, size = 1, alpha = .2, method = "hex") +
  geom_point(data = bds_means_of_means %>% filter(Queen == 0), aes(color = Trial, fill = Trial), size = 3, shape = 21, stroke = 0.2, position = position_dodge(width = 0), color = "black") +
  scale_color_manual(values = COLONY_COLORS) +
  scale_fill_manual(values = COLONY_COLORS) +
  xlab("") +
  ylab("Initiation Frequency") +
  CONSISTENT_THEME

# Plot N90.Day4 with SE error bars
plot_n90_day4 <- ggplot(bds_means %>% filter(QR_Queen_Condition != "Queen"), aes(x = QR_Queen_Condition, y = N90.Day4)) +
  geom_line(data = bds_means_of_means, aes(group = Trial), color = "darkgray", linewidth = 0.2) +
  geom_point(data = bds_means_of_means %>% filter(Queen == 1), aes(color = Trial, fill = Trial), size = 3, shape = 21, stroke = 0.2, position = position_dodge(width = 0), color = "black") +
  geom_beeswarm(aes(color = Trial), stroke = 0, size = 1, alpha = .2, method = "hex") +
  geom_point(data = bds_means_of_means %>% filter(Queen == 0), aes(color = Trial, fill = Trial), size = 3, shape = 21, stroke = 0.2, position = position_dodge(width = 0), color = "black") +
  scale_color_manual(values = COLONY_COLORS) +
  scale_fill_manual(values = COLONY_COLORS) +
  xlab("") +
  ylab("N90 (Dispersion)") +
  CONSISTENT_THEME

# Rug
bds$Alpha <- ifelse(bds$Queen, .5, 0.1)
bds$PointSize <- ifelse(bds$Queen, .05, .005)

degree_over_time <- ggplot(bds, aes(x = as.integer(Hour), y = Degree / 20, group = ID)) +
  geom_jitter(aes(color = QR_Queen_Condition, alpha = Alpha, size = PointSize)) +
  geom_smooth(aes(group = QR_Queen_Condition, color = QR_Queen_Condition), se = FALSE) +
  scale_size(range = c(.001, .5)) +
  scale_color_manual(
    labels = c("Queen", "Queenright Worker", "Queenless Worker"),
    values = setNames(c(Q_QRW_KEY_QLW$Q, Q_QRW_KEY_QLW$QRW, Q_QRW_KEY_QLW$QLW), levels(bds$QR_Queen_Condition)),
    guide = guide_legend(direction = "horizontal")
  ) +
  scale_x_continuous(breaks = c(0, seq(24, 96, by = 24)), limits = c(0, NA), expand = c(0, 0)) + # Expand limits to include 0
  labs(color = "") +
  xlab("Hour") +
  ylab("Std. Time Interacting per Hour (s)") +
  theme_minimal() +
  theme(
    text = element_text(size = 9),
    plot.title = element_text(hjust = 0.5),
    legend.position = c(1, 1.02), # Move legend to top right
    legend.justification = c(1, 1), # Align legend to top right
    legend.background = element_rect(fill = alpha("white", 1), color = NA), # Add white background to legend
    legend.title = element_text(size = 9, face = "bold"),
    legend.text = element_text(size = 9),
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 9, face = "bold"), # Make facet plot titles larger and bold
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 9),
    plot.margin = unit(c(0, 0, 0, 0), "cm") # Add margin for alignment
  ) +
  guides(alpha = "none", size = "none")

# Align the top left plot and the bottom plot
plots <- align_plots(plot_degree, degree_over_time, align = "v", axis = "l")

# Create the top row with the aligned top left plot and the other two top row plots
top_row <- plot_grid(plots[[1]], plot_n90_day4, plot_init_freq, nrow = 1, align = "hv", axis = "tblr")

# Create the final plot with the top row and the bottom plot
final_plot <- plot_grid(plots[[2]], top_row, ncol = 1, rel_heights = c(1, 1))

# Save the combined plot
# Adjust the plot saving command to include margins
ggsave("figures/manuscript/figure_2.jpeg", plot = final_plot, width = 8.5, height = 6, dpi = 600)
