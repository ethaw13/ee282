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
 
###
