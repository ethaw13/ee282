#!/usr/bin/env Rscript

#
# Cross-Species Conservation Comparison Plot
# Compare HIV-1 temporal vs cross-species evolutionary conservation
# This creates a proper "apples to apples" comparison
#

library(ggplot2)

cat("Creating cross-species conservation comparison...\n")

# Load HIV-1 temporal data
if (!file.exists("analysis_results/conservation_data.csv")) {
  cat("Error: HIV-1 conservation data not found. Run ./hiv1-conservation.sh first.\n")
  quit(status=1)
}

hiv1_temporal <- read.csv("analysis_results/conservation_data.csv")

# Load cross-species data
if (!file.exists("cross_species_analysis/cross_species_conservation.csv")) {
  cat("Error: Cross-species data not found. Run ./cross_species_analysis.sh first.\n")
  quit(status=1)
}

cross_species <- read.csv("cross_species_analysis/cross_species_conservation.csv")
cross_species$Conservation_Pct <- cross_species$Conservation * 100

cat("HIV-1 temporal data:", nrow(hiv1_temporal), "positions\n")
cat("Cross-species data:", nrow(cross_species), "positions\n")

# Prepare comparison data (use shorter length)
min_length <- min(nrow(hiv1_temporal), nrow(cross_species))
comparison_positions <- 1:min_length

comparison_data <- data.frame(
  Position = rep(comparison_positions, 2),
  Conservation = c(
    hiv1_temporal$Average_Conservation[comparison_positions],
    cross_species$Conservation_Pct[comparison_positions]
  ),
  Analysis_Type = rep(c("HIV-1 Temporal", "Cross-Species Evolutionary"), each = min_length),
  Evolutionary_Scale = rep(c("Recent (decades)", "Ancient (millions of years)"), each = min_length)
)

# Create the comparison plot
p1 <- ggplot(comparison_data, aes(x = Position, y = Conservation, color = Analysis_Type)) +
  geom_line(linewidth = 1.5, alpha = 0.9) +
  scale_color_manual(
    values = c(
      "HIV-1 Temporal" = "#DC143C",
      "Cross-Species Evolutionary" = "#2E8B57"
    ),
    name = "Conservation Type"
  ) +
  labs(
    title = "Temporal vs Evolutionary Conservation Patterns",
    subtitle = "Red: HIV-1 functional constraints over time | Green: Viral family divergence over evolution",
    x = "CA Position",
    y = "Conservation (%)",
    caption = "Demonstrates different evolutionary timescales and selective pressures"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold",
                              margin = margin(b = 10)),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray60",
                                 margin = margin(b = 15)),
    plot.caption = element_text(hjust = 0.5, size = 10, color = "gray50",
                                margin = margin(t = 10)),
    axis.title.x = element_text(size = 14, face = "bold",
                                margin = margin(t = 15)),
    axis.title.y = element_text(size = 14, face = "bold",
                                margin = margin(r = 15)),
    axis.text = element_text(size = 12, color = "black"),
    panel.border = element_rect(linewidth = 0.8, color = "black", fill = NA),
    axis.ticks = element_line(linewidth = 0.6, color = "black"),
    legend.position = "top",
    legend.title = element_text(size = 13, face = "bold"),
    legend.text = element_text(size = 12),
    legend.key.width = unit(1.8, "cm"),
    legend.margin = margin(b = 15),
    panel.grid.major.y = element_line(color = "grey90", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  ) +
  ylim(0, 100)

# Save the plot
ggsave("analysis_results/temporal_vs_evolutionary_conservation.png", p1,
       width = 12, height = 8, dpi = 300)

# Calculate comparative statistics
correlation <- cor(
  hiv1_temporal$Average_Conservation[comparison_positions],
  cross_species$Conservation_Pct[comparison_positions],
  use = "complete.obs"
)

# Summary statistics
hiv1_mean <- mean(hiv1_temporal$Average_Conservation, na.rm = TRUE)
cross_species_mean <- mean(cross_species$Conservation_Pct, na.rm = TRUE)

# Biological analysis
high_temporal <- sum(hiv1_temporal$Average_Conservation > 95, na.rm = TRUE)
high_evolutionary <- sum(cross_species$Conservation_Pct > 50, na.rm = TRUE)

cat("\n=== CROSS-SPECIES CONSERVATION ANALYSIS ===\n")
cat("Temporal Conservation (HIV-1):\n")
cat("  Mean conservation:", round(hiv1_mean, 1), "%\n")
cat("  Highly conserved positions (>95%):", high_temporal, "out of", nrow(hiv1_temporal), "\n")

cat("\nEvolutionary Conservation (Cross-species):\n")
cat("  Mean conservation:", round(cross_species_mean, 1), "%\n")
cat("  Moderately conserved positions (>50%):", high_evolutionary, "out of", nrow(cross_species), "\n")

cat("\nComparative Analysis:\n")
cat("  Correlation:", round(correlation, 3), "\n")
cat("  Conservation difference:", round(hiv1_mean - cross_species_mean, 1), "percentage points\n")

# Biological interpretation
cat("\n=== BIOLOGICAL INTERPRETATION ===\n")
cat("Temporal Conservation Pattern:\n")
cat("  - Reflects functional constraints within HIV-1\n")
cat("  - High values indicate critical functional sites\n")
cat("  - Operates on recent evolutionary timescale (decades)\n")

cat("\nEvolutionary Conservation Pattern:\n")
cat("  - Reflects structural constraints across viral families\n")
cat("  - Lower values expected due to long evolutionary divergence\n")
cat("  - Operates on ancient evolutionary timescale (millions of years)\n")

if (abs(correlation) < 0.3) {
  cat("\nLow correlation confirms these operate on different evolutionary scales.\n")
  cat("This demonstrates the difference between functional and structural constraints.\n")
} else {
  cat("\nModerate correlation suggests some shared fundamental constraints\n")
  cat("across both functional and structural evolutionary pressures.\n")
}

cat("\nFiles created:\n")
cat("  - analysis_results/temporal_vs_evolutionary_conservation.png\n")

cat("\nThis provides a scientifically rigorous comparison of conservation\n")
cat("operating at different evolutionary timescales!\n")