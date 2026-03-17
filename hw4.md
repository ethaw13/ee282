For output plots, please look in the output/ directory

# Homework 4 Pipeline

## Summarize Partitions of a Genome Assembly

### Overall Assembly Summary

To calculate the total number of nucleotides, total number of Ns, and total number of sequences across the full assembly, run:

```bash
../faSize ../dmel-all-chromosome-r6.66.fasta.gz
```

Output:

```
143726002 bases (1152978 N's 142573024 real 142573024 upper 0 lower) in 1870 sequences in 1 files
Total size: mean 76858.8 sd 1382100.2 min 544 (211000022279089) max 32079331 (3R) median 1577
N count: mean 616.6 sd 6960.7
U count: mean 76242.3 sd 1379508.4
L count: mean 0.0 sd 0.0
%0.00 masked total, %0.00 masked real
```

Results:

- **Total # of nucleotides:** 143,726,002
- **Total # of Ns:** 1,152,978
- **Total # of sequences:** 1,870

---

### Calculate Stats for Sequences ≤100kb and >100kb

Split the assembly into two partitions based on sequence length:

```bash
bioawk -c fastx 'length($seq)<=100000 {print ">"$name"\n"$seq}' ../dmel-all-chromosome-r6.66.fasta > output/99kb.fa
bioawk -c fastx 'length($seq)>100000 {print ">"$name"\n"$seq}' ../dmel-all-chromosome-r6.66.fasta > output/101kb.fa
```

Count the number of sequences in each partition:

```bash
grep -c ">" output/101kb.fa
# 7

grep -c ">" output/99kb.fa
# 1863
```

Extract sequence lengths and GC content for each partition:

```bash
bioawk -c fastx '{print length($seq), gc($seq)}' 99kb.fa > output/99kb_stats.txt
bioawk -c fastx '{print length($seq), gc($seq)}' 101kb.fa > output/101kb_stats.txt
```

Generate plots in R:

1. Sequence length distribution histogram (log scale recommended)
2. Sequence GC% distribution histogram
3. Cumulative sequence size sorted from largest to smallest (use `plotCDF`)

```R
source("scripts/plot-sequences.R")
```

---

## Genome Assembly

### Assemble a Genome Using PacBio HiFi Reads

Assembled locally using 16 threads:

```bash
hifiasm -o iso1 -t 16 ISO_HiFi_Shukla2025.fasta.gz
```

Output:

```
[M::main] Version: 0.16.1-r375
[M::main] CMD: hifiasm -o iso1 -t 16 ISO_HiFi_Shukla2025.fasta.gz
[M::main] Real time: 2925.937 sec; CPU: 45407.865 sec; Peak RSS: 17.650 GB
```

---

### Assembly Evaluation

Working with the primary contig assembly: `iso1.bp.p_ctg.gfa`

Convert `.gfa` to `.fa`:

```bash
awk '/^S/{print ">"$2"\n"$3}' hifiasm-output/iso1.bp.p_ctg.gfa > output/iso1_primary.fa
```

Extract and sort sequence lengths:

```bash
# Extract sequence lengths
bioawk -c fastx '{print length($seq)}' output/iso1_primary.fa > output/iso_lengths.txt

# Sort from largest to smallest
sort -nr output/iso_lengths.txt > output/iso_lengths_sorted.txt
```

Calculate N50:

```bash
./scripts/calculate-n50.sh
```

This script reads the sorted contig lengths and computes total assembly size. Once the cumulative length reaches half the total assembly size, it reports the length of that contig as the N50.

```
N50 = 21,714,252
```

The reference genome on NCBI ([GCF_000001215.4](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001215.4/)) reports a contig N50 of 21.5 Mb; our result of 21.7 Mb is very close.

---

### Contiguity Comparison: HiFiasm vs. FlyBase

Extract lengths from the FlyBase reference assembly and generate comparison plots:

```bash
bioawk -c fastx '{print length($seq)}' ../dmel-all-chromosome-r6.66.fasta | sort -nr > output/flybase_lengths_sorted.txt

Rscript scripts/plot-contiguity.R
```

---

### BUSCO Scores

#### HiFiasm Assembly

```bash
busco -i output/iso1_primary.fa -l diptera_odb10 -m genome -o iso1_busco -c 16
```

```
-------------------------------------------------------------------------------------------
|Results from dataset diptera_odb10                                                        |
-------------------------------------------------------------------------------------------
|C:99.8%[S:99.6%,D:0.2%],F:0.0%,M:0.2%,n:3285,E:10.6%                                   |
|3280    Complete BUSCOs (C)    (of which 349 contain internal stop codons)                |
|3273    Complete and single-copy BUSCOs (S)                                               |
|7       Complete and duplicated BUSCOs (D)                                                |
|0       Fragmented BUSCOs (F)                                                             |
|5       Missing BUSCOs (M)                                                                |
|3285    Total BUSCO groups searched                                                       |
-------------------------------------------------------------------------------------------
```

#### FlyBase Reference Assembly

```bash
busco -i dmel-all-chromosome-r6.66.fasta -l diptera_odb10 -m genome -o flybase_busco -c 16
```

```
-------------------------------------------------------------------------------------------
|Results from dataset diptera_odb10                                                        |
-------------------------------------------------------------------------------------------
|C:99.9%[S:99.7%,D:0.3%],F:0.0%,M:0.1%,n:3285,E:10.6%                                   |
|3283    Complete BUSCOs (C)    (of which 349 contain internal stop codons)                |
|3274    Complete and single-copy BUSCOs (S)                                               |
|9       Complete and duplicated BUSCOs (D)                                                |
|0       Fragmented BUSCOs (F)                                                             |
|2       Missing BUSCOs (M)                                                                |
|3285    Total BUSCO groups searched                                                       |
-------------------------------------------------------------------------------------------
```
