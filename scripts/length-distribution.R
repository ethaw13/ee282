library(ggplot2)

le <- read.table("99kb_stats.txt", col.names=c("length","gc"))
gt <- read.table("101kb_stats.txt", col.names=c("length","gc"))

library(ggplot2)

le <- read.table("99kb_stats.txt", col.names=c("length","gc"))
gt <- read.table("101kb_stats.txt", col.names=c("length","gc"))

p1 <- ggplot(le, aes(x=length)) +
  geom_histogram(bins=50) +
  scale_x_log10()

ggsave("length_hist_99kb.png", p1)

p2 <- ggplot(gt, aes(x=length)) +
  geom_histogram(bins=50) +
  scale_x_log10()

ggsave("length_hist_101kb.png", p2)
