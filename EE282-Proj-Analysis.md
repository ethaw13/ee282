# HIV-1 Capsid Protein Evolutionary Analysis

## Introduction

This project combines evolutionary, structural biology, and computational methods to examine protein sequence variation on the HIV-1 capsid (CA) protein, a somewhat delicate system that must reliably self-assemble into a complex high ordered lattice. Sequence alignments and statistical probabilities may be able to reveal certain amino acid residues that serve an essential function when it comes to capsid protein assembly and stability. Mapping these constraints can highlight functionally regions that may nominate certain regions as targets for the binding of small drugs and molecules.

To study the HIV-1 capsid protein in an evolutionary context, we can acquire protein sequence data from online databases including BLAST and UniProt. These large datasets enable comparison across strains and lineages but may require some filtering for the target sequence. If more variability and data is required, we can extend the databases to include all viral capsid proteins and assembly-related proteins, rather than just HIV-1 sequences. The motivation to analyze multiple sequence alignments (MSAs) is to quantify sequence conservation and variability among viral strain protein sequences. Additionally, evolutionary cladograms of sequence data can be important in showing close relatedness and revealing patterns of divergence. Three-dimensional structural data can be incorporated to relate evolutionary conservation to capsid structure and function, possibly detailing exact amino acids responsible for assembly. Together, these analyses identify which regions of HIV-1 capsid protein can be evolutionary conserved but be susceptible to mutation.

We hypothesize that certain residues involved in functional interfaces and lattice stability will exhibit strong evolutionary conservation. To test this, multiple sequence alignments will be generated using MAFFT, enabling residue-residue comparisons among the viral strains. Conservation metrics from these alignments will be used to identify positions under strong evolutionary constraint. Additionally, sequence logo plots can be used to visualize the likelihood of certain amino acids at a certain position.

A central question is how much sequence variation the HIV-1 capsid protein can tolerate while still assembling into a functional lattice. By examining conservation across multiple sequence alignments, we can separate residues that are tightly constrained by structural or functional and identify where even small mutations might disrupt the larger assembly. Evolutionary history also plays an important role, since similarities between sequences may reflect common ancestry rather than strict functional requirements. Viewing conservation in an evolutionary mindset helps differentiate functional residues between age-related differences and function, shaping the virus over time. The structural context of each position determines how well mutations can be varied, due to electrostatic interactions, and interfacial interactions influencing whether a substitution is tolerated or whether it sacrifices higher-order functions. Furthermore, by investigating strongly conserved amino acids and those prone to mutation provides potential regions of interest to disrupt capsid assembly.

## Datasets

The protein sequence datasets will be acquired from online databases like UniProt and BLAST, using command line functions such as `curl` or `wget`. Additionally, curated HIV-1 sequences can be found in the Los Alamos HIV sequence database, which provides detailed and annotated viral strains spanning reions and time and minute mutations. The combined resources allow for comprehensive comparirisons of HIV-1 capsid variation across evolutionary space. 

Because sequences typically contain the full Gag polyprotein and the capsid domain (CA) is only a small component, the sequences first have to be truncated and aligned to fit the residues of interest. More specifically, the residues 1-221 of the CA protein will be filtered from the data sources, likely by using `grep`, `awk`, or `bioawk`. This preprocessing alignment step will allow residue-residue comparisons of conservation and variability.

## Analyses

Multiple sequence alignment will be generated to enable residue comparisons across HIV-1 capsid protein sequences. Utilization of the linux package MAFFT (Katoh et al. 2013) alignments executed in bash, enabling uniform comparisons across HIV-1 capsid protein sequences. The resulting aligned FASTA file will be analyzed entirely in RStudio, where conservation metrics, potential phylogenetic trees, and statistics will be computed with existing R libraries. All figures will be generated using ggplot. Sequence positional conservation scores (Valdar et al. 2002) will be derived from the amino acid positional frequencies and Shannon entropy across each position. High conservation should indicate essential amino acids for capsid  function and must persist throughout mutation to maintain functionality. Low conservation scores will reveal amino acids susceptible to mutation. Sequence logos (Schneider et al. 1990) may also be made to visualize preferred amino acids at a certain position. Subsequently, these conservation values will be mapped onto three dimensional structures using visualization tools like VMD (Humphrey et al. 1996), enabling evolutionary patterns to be interpreted in the context of capsid assembly and protein interactions. Hopefully, these analyses will identify certain amino acids and their properties involved in forming the fully mature capsid envelope for the HIV-1 viral genome.

## Visualization

Visualization and quantitative analysis will be conducted though a Bash/RStudio workflow. Bash scripting will automate sequence retrieval, CA domain filtration, and alignment with Unix command line tools like `wget` and `grep` and `bioawk`. In R, conservation scores (Shannon entropt or residue frequency) will be calculated from the filtered FASTA file. We will be using the ggplot library in R to plot the conservation score as a function of residue positions. This may come in the form of a conservation line plot, showing low conservation at certain positions or frequency heatmaps. To relate evolutionary constraints to sure, mapping these conservation score to a three-dimensional structure is important to answer the overarching question. This will be done in RStudio, parsing certain protein structures (PDB) and computing the root mean squared differences (RMSD) from known HIV-1 capsid protein structures.

## Conclusion

By combining sequence data and structural interpretation, this project aims to quantify evolutionary pressures acting on the HIV-1 capsid protein while preserving the ability to self-assemble. Conservation scores and sequence logos will reveal amino acid residues which may have characteristics enabling structural integrity and lattice formation despite rapid mutations. Mapping evolutionary patterns onto protein structures may reveal how function may counteract sequence variability, maintaining capsid stability.

## References

Katoh K, Standley DM. 2013. MAFFT multiple sequence alignment software version 7: improvements in performance and usability. Mol Biol Evol 30: 772–780.

Valdar WSJ. 2002. Scoring residue conservation. Proteins 48: 227–241.

Schneider TD, Stephens RM. 1990. Sequence logos: a new way to display consensus sequences. Nucleic Acids Res 18: 6097–6100.

Humphrey W, Dalke A, Schulten K. 1996. VMD: Visual molecular dynamics. J Mol Graph 14: 33–38.

