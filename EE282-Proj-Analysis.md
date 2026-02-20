# HIV-1 Capsid Protein Evolutionary Analysis

## Introduction

This project combines evolutionary, structural biology, and computational methods to examine protein sequence variation on the HIV-1 capsid (CA) protein, a somewhat delicate system that must reliably self-assemble into a complex high ordered lattice. Sequence alignments and structural overlays may be able to reveal certain amino acid residues that serve an essential function when it comes to capsid protein assembly and stability. Mapping these constraints can highlight functionally regions that may nominate certain regions as targets for the binding of small drugs and molecules.

To study the HIV-1 capsid protein in an evolutionary context, we can acquire protein sequence data from online databases including BLAST and UniProt. These datasets enable comparison across strains and lineages. If more variability and data is required, we can extend the databases to include all viral capsid proteins and assembly-related proteins, rather than just HIV-1 sequences. The motivation to analyze multiple sequence alignments (MSAs) is to quantify sequence conservation and variability among viral strain protein sequences. Additionally, evolutionary cladograms of sequence data can be important in showing close relatedness and revealing patterns of divergence. Outside of traditional bioinformatics, three-dimensional structural data can be incorporated to relate evolutionary conservation to capsid structure and function, possibly detailing exact residues responsible for stability. Together, these analyses identify which regions of HIV-1 capsid protein can be evolutionary conserved but be susceptible to mutation.

We hypothesize that certain residues involved in functional interfaces and lattice stability will exhibit strong evolutionary conservation. To test this, multiple sequence alignments will be generated using MAFFT, enabling residue-residue comparisons among the viral strains. Conservation metrics from these alignments will be used to identify positions under strong evolutionary constraint. Additionally, sequence logo plots can be used to visualize the likelihood of certain amino acids at a certain position. Phylogenetic analysis will provide further context for observed variation, and conservation scores will be mapped to structures linking evolutionary constraints to biophysical determinants of stability.

A central question is how much sequence variation the HIV-1 capsid protein can tolerate while still assembling into a functional lattice. By examining conservation across multiple sequence alignments, we can separate residues that are tightly constrained by structural or functional and identify where even small mutations might disrupt the larger assembly. Evolutionary history also plays an important role, since similarities between sequences may reflect common ancestry rather than strict functional requirements. Viewing conservation in an evolutionary mindset helps differentiate functional residues between age-related differences and function, shaping the virus over time. Ultimately, the structural context of each position determines how well mutations can be varied, due to electrostatic interactions, and interfacial interactions influencing whether a substitution is tolerated or whether it sacrifices higher-order functions.

## Datasets

The datasets will be acquired from online databases like UniProt and Blast. Additionally, HIV-1 curated sequences can be found in the Los Alamos HIV sequence database. Together, these resources provide a large amount of protein sequences that enable comparisons in sequences spanning geographic regions, yearly genetic drift, and small variations in the capsid protein sequence. The sequences gained from these online resources will first have to be truncated and aligned to fit the residues of interest. More specifically, the residues 1-221 of the CA protein will be analyzed. This standardized alignment will allow residue-residue comparisons of conservation and variability.

## Analyses

Multiple sequence alignment will be generated to enable residue comparisons across HIV-1 capsid protein sequences. From these MAFFT (Katoh et al. 2013) alignments, positional alignments will give a conservation score (Valdar et al. 2002) which will be computed by counting the total counts of a certain amino acid from a reference sequence over the total counts that appear in all the databases. High conservation will indicate highly conserved residues and be highly functional. Low conservation scores will reveal amino acids susceptible to mutation. Sequence logos (Schneider et al. 1990) may also be made to visualize preferred amino acids at a certain position. These conservation values will be mapped onto three dimensional structures using visualization tools like VMD, enabling evolutionary patterns to be interpreted in the context of capsid assembly and protein interactions.

## Visualization

To visualize the analyses, we will employ bash scripting for the preprocessing alignment, and Python 3.12.2 to do the conservation calculations. We will be using the matplotlib library to plot the conservation score as a function of residue positions. Additionally, we can use tcl scripting in the VMD (Humphrey et al. 1996) console to render capsid variants relative to a reference structure. Where experimental structures are unavailable, we may use AlphaFold3 (Abramson et al. 2024) to provide structural context for interpreting evolutionary concepts.

## Conclusion

By combining sequence data and structural interpretation, this project aims to quantify evolutionary pressures acting on the HIV-1 capsid protein while preserving the ability to self-assemble. Conservation scores and sequence logos will reveal amino acid residues which may have characteristics enabling structural integrity and lattice formation despite rapid mutations. Mapping evolutionary patterns onto protein structures may reveal how function may counteract sequence variability, maintaining capsid stability.

## References

Katoh K, Standley DM. 2013. MAFFT multiple sequence alignment software version 7: improvements in performance and usability. Mol Biol Evol 30: 772–780.

Valdar WSJ. 2002. Scoring residue conservation. Proteins 48: 227–241.

Schneider TD, Stephens RM. 1990. Sequence logos: a new way to display consensus sequences. Nucleic Acids Res 18: 6097–6100.

Humphrey W, Dalke A, Schulten K. 1996. VMD: Visual molecular dynamics. J Mol Graph 14: 33–38.

Abramson J, Adler J, Dunger J, Green T, Pritzel A, et al. 2024. Accurate structure prediction of biomolecular interactions with AlphaFold. Nature 630: 493–500.
