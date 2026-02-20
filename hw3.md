# Homework 3 pipeline

## Integrity of downloaded files

### First we use md5sum of the .gz and compare it to the md5sum.txt that FlyBase provides. Another simpler way to do this is do:
####`grep dmel-all-chromosome-r6.66.fasta.gz md5sum.txt`
 or
####`vim md5sum.txt' to check if the hash is the same

##### results in a hash of: ccb86e94117eb4eeaaf70efb6be1b6b9  dmel-all-chromosome-r6.66.fasta.gz

## Calculate summaries of the genome

### '../faSize dmel-all-chromosome-r6.66.fasta.gz' to print summaries of .fasta file

 
#### 143726002 bases (1152978 N's 142573024 real 142573024 upper 0 lower) in 1870 sequences in 1 files
#### Total size: mean 76858.8 sd 1382100.2 min 544 (211000022279089) max 32079331 (3R) median 1577
#### N count: mean 616.6 sd 6960.7
#### U count: mean 76242.3 sd 1379508.4
#### L count: mean 0.0 sd 0.0
#### %0.00 masked total, %0.00 masked real

### Total # of nucleotides: 143,726,002
### Total # of Ns: 1,152,978
### Total # of sequences: 1,870

## Summarize an annotation file

### md5sum dmel-all-r6.66.gtf.gz to check integrity of file

#### results in ea600dbb86f1779463f69082131753cd  dmel-all-r6.66.gtf.gz
 
### bioawk -c gff '{print $feature}' dmel-all-r6.66.gtf.gz | sort | uniq -c
 190176 exon
 163377 CDS
  46856 5UTR
  33778 3UTR
  30922 start_codon
  30862 stop_codon
  30836 mRNA
  17872 gene
   3059 ncRNA
    485 miRNA
    365 pseudogene
    312 tRNA
    270 snoRNA
    262 pre_miRNA
    115 rRNA
     32 snRNA

#### bioawk -c gff '$feature=="gene" {print $seqname}' dmel-all-r6.66.gtf.gz | grep -E "^(X|Y|2L|2R|3L|3R|4)$" | sort | uniq -c | sort -nr
   3508 2L
   3649 2R
   3481 3L
   4226 3R
    114 4
   2704 X
    113 Y

Total # of genes per chromosome arm:
X: 2704
Y: 113
2L: 3508
3L: 3481
3R: 4226
4: 114
