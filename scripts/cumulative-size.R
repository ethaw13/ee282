library(ggplot2)

le <- read.table("99kb_stats.txt", col.names=c("length","gc"))
gt <- read.table("101kb_stats.txt", col.names=c("length","gc"))

len_le <- sort(le$length, decreasing=TRUE)
len_gt <- sort(gt$length, decreasing=TRUE)

run_le <- cumsum(len_le)
run_gt <- cumsum(len_gt)

cdf_le <- data.frame(index=1:length(run_le), size=run_le)
cdf_gt <- data.frame(index=1:length(run_gt), size=run_gt)

ggplot(cdf_le, aes(index,size)) +
  geom_line() +
  ggsave("cdf_99kb.png")

ggplot(cdf_gt, aes(index,size)) +
  geom_line() +
  ggsave("cdf_101kb.png")
