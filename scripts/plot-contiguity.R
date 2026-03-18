#!/usr/bin/env Rscript

library(ggplot2)

read_lengths <- function(file, label) {
  lengths <- scan(file)
  lengths <- sort(lengths, decreasing = TRUE)

  cum_lengths <- cumsum(lengths)
  total <- sum(lengths)

  data.frame(
    frac_contigs = seq_along(lengths) / length(lengths),
    frac_size = cum_lengths / total,
    assembly = label
  )
}

# ---- input files ----
df_hifi <- read_lengths("output/iso_lengths_sorted.txt", "HiFiasm")
df_flybase <- read_lengths("output/flybase_lengths_sorted.txt", "FlyBase Scaffolds")

# OPTIONAL: include FlyBase contigs if available
contig_file <- "output/flybase_contig_lengths.txt"
if (file.exists(contig_file)) {
  df_contig <- read_lengths(contig_file, "FlyBase Contigs")
  df <- rbind(df_hifi, df_flybase, df_contig)
} else {
  df <- rbind(df_hifi, df_flybase)
}

# ---- plot ----
p <- ggplot(df, aes(x = frac_contigs, y = frac_size, color = assembly)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Contiguity Plot",
    x = "Fraction of Contigs",
    y = "Fraction of Assembly Size"
  ) +
  theme_minimal()

# ---- save ----
ggsave("output/contiguity_plot.png", p, width = 6, height = 5)

print(p)
