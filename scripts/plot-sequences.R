library(ggplot2)


le <- read.table("99kb_stats.txt", col.names = c("length","gc"))
gt <- read.table("101kb_stats.txt", col.names = c("length","gc"))

############################################
# 1. Sequence length distribution (histogram, log scale)
############################################

p1 <- ggplot(le, aes(x = length)) +
  geom_histogram(bins = 50) +
  scale_x_log10() +
  ggtitle("Sequence Length Distribution (≤100 kb)")

ggsave("output/length_hist_99kb.png", p1)

p2 <- ggplot(gt, aes(x = length)) +
  geom_histogram(bins = 50) +
  scale_x_log10() +
  ggtitle("Sequence Length Distribution (>100 kb)")

ggsave("output/length_hist_101kb.png", p2)

############################################
# 2. GC% distribution (histogram)
############################################

p3 <- ggplot(le, aes(x = gc)) +
  geom_histogram(bins = 50) +
  ggtitle("GC Distribution (≤100 kb)")

ggsave("output/gc_hist_99kb.png", p3)

p4 <- ggplot(gt, aes(x = gc)) +
  geom_histogram(bins = 50) +
  ggtitle("GC Distribution (>100 kb)")

ggsave("output/gc_hist_101kb.png", p4)

############################################
# 3. Cumulative sequence size (largest → smallest)
############################################

len_le <- sort(le$length, decreasing = TRUE)
len_gt <- sort(gt$length, decreasing = TRUE)

run_le <- cumsum(len_le)
run_gt <- cumsum(len_gt)

cdf_le <- data.frame(index = 1:length(run_le), size = run_le)
cdf_gt <- data.frame(index = 1:length(run_gt), size = run_gt)

p5 <- ggplot(cdf_le, aes(x = index, y = size)) +
  geom_line() +
  xlab("Sequences sorted by size") +
  ylab("Cumulative bases") +
  ggtitle("Cumulative Sequence Size (≤100 kb)")

ggsave("output/cdf_99kb.png", p5)

p6 <- ggplot(cdf_gt, aes(x = index, y = size)) +
  geom_line() +
  xlab("Sequences sorted by size") +
  ylab("Cumulative bases") +
  ggtitle("Cumulative Sequence Size (>100 kb)")

ggsave("output/cdf_101kb.png", p6)
