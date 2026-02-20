# Homework 3 Pipeline

## Integrity of Downloaded Files

We use `md5sum` of the `.gz` file and compare it to the `md5sum.txt` that FlyBase provides:

```
grep dmel-all-chromosome-r6.66.fasta.gz md5sum.txt
```

Or alternatively, `vim md5sum.txt` to manually check the hash.

**Result:** `ccb86e94117eb4eeaaf70efb6be1b6b9  dmel-all-chromosome-r6.66.fasta.gz`

---

## Calculate Summaries of the Genome

Command used:
```
../faSize dmel-all-chromosome-r6.66.fasta.gz
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

- Total # of nucleotides: 143,726,002
- Total # of Ns: 1,152,978
- Total # of sequences: 1,870

---

## Summarize an Annotation File

Integrity check:
```
md5sum dmel-all-r6.66.gtf.gz
```

**Result:** `ea600dbb86f1779463f69082131753cd  dmel-all-r6.66.gtf.gz`

### Feature Counts

Command:
```
bioawk -c gff '{print $feature}' dmel-all-r6.66.gtf.gz | sort | uniq -c
```

| Count | Feature |
|---|---|
| 190,176 | exon |
| 163,377 | CDS |
| 46,856 | 5UTR |
| 33,778 | 3UTR |
| 30,922 | start_codon |
| 30,862 | stop_codon |
| 30,836 | mRNA |
| 17,872 | gene |
| 3,059 | ncRNA |
| 485 | miRNA |
| 365 | pseudogene |
| 312 | tRNA |
| 270 | snoRNA |
| 262 | pre_miRNA |
| 115 | rRNA |
| 32 | snRNA |

### Genes per Chromosome Arm

Command:
```
bioawk -c gff '$feature=="gene" {print $seqname}' dmel-all-r6.66.gtf.gz | grep -E "^(X|Y|2L|2R|3L|3R|4)$" | sort | uniq -c | sort -nr
```

Total # of genes per chromosome arm:

| Chromosome | Gene Count |
|---|---|
| 3R | 4,226 |
| 2R | 3,649 |
| 2L | 3,508 |
| 3L | 3,481 |
| X | 2,704 |
| 4 | 114 |
| Y | 113 |
