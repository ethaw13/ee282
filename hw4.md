# Homework 4 Pipeline

## Summarize partitions of a genome assembly

### Calculate the following for all sequences ≤100kb and all sequences > 100kb:

#### To find the 1) Total number of nucleotides 2) Total number of Ns 3) Total number of sequences

##### We can run this command like we did in hw3:

`../faSize ../dmel-all-chromosome-r6.66.fasta.gz`

#### To return:

# 143726002 bases (1152978 N's 142573024 real 142573024 upper 0 lower) in 1870 sequences in 1 files
# Total size: mean 76858.8 sd 1382100.2 min 544 (211000022279089) max 32079331 (3R) median 1577
# N count: mean 616.6 sd 6960.7
# U count: mean 76242.3 sd 1379508.4
# L count: mean 0.0 sd 0.0
# %0.00 masked total, %0.00 masked real

Resulting in:

- Total # of nucleotides: 143,726,002
- Total # of Ns: 1,152,978
- Total # of sequences: 1,870

## Genome Assembly

### Plots of the following for all all sequences ≤ 100kb and all sequences > 100kb:

bioawk -c fastx '{print length($seq), gc($seq)}' 99kb.fa > 99kb_stats.txt
bioawk -c fastx '{print length($seq), gc($seq)}' 101kb.fa > 101kb_stats.txt

grep -c ">" 101kb.fa
that outputs
7

grep -c ">" 99kb.fa
outputs 
1863


1) Sequence length distribution histogram, potentially a logscale


2) Sequence GC% distribution histogram
3) Cumulative sequence size sorted from largest to smallest. Use plotCDF





### Assemble a genome using Pacbio HiFi reads

#### This was run locally with 16 threads:


hifiasm -o iso1 -t 16 ISO_HiFi_Shukla2025.fasta.gz

output:
[M::main] Version: 0.16.1-r375
[M::main] CMD: hifiasm -o iso1 -t 16 ISO_HiFi_Shukla2025.fasta.gz
[M::main] Real time: 2925.937 sec; CPU: 45407.865 sec; Peak RSS: 17.650 GB

