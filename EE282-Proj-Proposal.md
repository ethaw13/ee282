# HIV-1 Capsid Protein: Sequence Variation and Functional Conservation

## Introduction

Proteins are an essential component of life, performing integral functions in structure, metabolism, immune defense. Amino acid sequences encode these functions through their three-dimensional structures and chemical properties. However, the variability in which a protein sequence can differ while maintaining function pressure remains relatively uncharacterized. This balance between sequence and structural constraint underlies many biological processes (Guo et al. 2004), demonstrating how proteins are able to evolve new functions but remain prone to mutation. Understanding this delicate balance will provide a good explanation to protein evolution, functional conservation, and protein structure robustness.

Viral structural proteins provide a good model to study physical function and sequence data. In HIV-1, the capsid protein (CA) is responsible for forming the cone-like shape (Mattei et al. 2016; Schirra et al. 2023; Pornillos 2009) surrounding the viral genome, and is necessary for the virus to function as a single entity. This cone is composed of hexamers and pentamers of the viral capsid protein. Together, they form a lattice-like structure due to the mechanistic interactions between identical sequences of CA proteins. This mature fullerene cone shape consists of approximately 1500-2000 copies of CA (Li et al. 2000). Such a large complex would undergo large changes from something even as small single amino acid mutations. Despite these constraints, a single CA amino acid sequence is capable of assembling into the complete capsid conical envelope.

## Data

To study HIV-1 capsid protein in an evolutionary context, we can acquire protein sequence data from online databases including BLAST and UniProt. If more variability and data is required, we can extend the databases to include all viral capsid proteins. These datasets enable comparisons of CA sequences across diverse viral strains and lineages. The motivation to analyze multiple sequence alignments (MSAs) is to quantify sequence conservation and variability among viral strain protein sequences. Additionally, evolutionary cladograms of sequence data can be important in showing close relatedness and revealing patterns of divergence. Outside of traditional bioinformatics, three-dimensional structural data can be incorporated to relate evolutionary conservation to capsid architecture and function. Together, these analyses identify which regions of HIV-1 capsid protein can be evolutionary conserved but be susceptible to mutation.

## Questions

We hypothesize that certain residues involved in functional interfaces and lattice stability will exhibit strong evolutionary conservation. To test this, multiple sequence alignments will be generated using MAFFT, enabling residue comparisons among the viral strains. Conservation metrics from these alignments will be used to identify positions under strong evolutionary constraint. Phylogenetic analysis will visualize the aligned sequences and provide evolutionary context. Finally, conservation scores will be mapped to structures linking evolutionary constraints to protein stability.

How much sequence variation can the HIV-1 capsid protein tolerate while maintaining its ability to assemble into a functional lattice? The capsid protein must satisfy structural requirements to assemble into a relatively stable conical lattice, while being able to contain the viral genome. By analyzing MSAs, patterns of conservation can be quantified along the amino acid sequence. Highly conserved residues are expected to reflect strong functional or structural constraints, where variable mutations may tolerate mutations. The analysis allows us to identify regions that are robust to amino acid change, as well as positions where small perturbations could destabilize the larger structures.

Additionally, how does evolutionary history shape conservation in the HIV-1 capsid protein? Conservation can arise from shared ancestry as well as functional necessity, making evolutionary context necessary for interpretation. Phylogenetic analyses based on aligned protein sequences reveal how closely related viral strains may behave similarly. By combining phylogenetic trees and conservation analyses, it becomes possible to assess conserved residues that serve as deeply functional and necessary. Supplementary uses of deep evolutionary datasets, such as the computed MSAs from the AlphaFold3 database, can further high residues conserved. Together, these clarify divergence and structural constraints shape HIV-1 into the virus it is today.

How does structural information enable HIV-1 capsid protein to tolerate amino acid mutations while maintaining function? Some structures are more tolerant to mutations due to their chemical properties. Lattice stability is largely dependent electrostatic interactions between capsid proteins. Small sequence changes would propagate in higher-order assemblies and may potentially cause an envelope to be ineffective.

## Conclusion

This project hopefully combines evolutionary, structural biology, and computational methods to examine protein sequence variation on the HIV-1 capsid protein, a somewhat delicate system that must reliably self-assemble into a complex high ordered lattice. Biological implication include mapping amino acids by necessity or tolerability, and locating functionally significant regions may nominate certain regions as targets for the binding of small drugs and molecules.

## Feasibility

This project is feasible for completion due to the wide access protein sequence data and three-dimensional structure data. The use of computational tools are well-established and heavy on documentation. Sequences gathered from BLAST and UniProt can quickly be analyzed with MAFFT. Structural mapping of conserved residues onto existing CA structures would provide interesting atomistic details without the need for experimental data collection. The use of preexisting well known libraries and computationally simple methods ensure meaning evolutionary results. Hopefully, regions may be nominated to be further investigated. However, it may not be feasible within the scope of the project to perform extensive simulations or experimental validation, the study will focus on comparative methods in preexisting sequence databases.

## References

Guo HH, Choe J, Loeb LA. Protein tolerance to random amino acid change. Proc Natl Acad Sci U S A. 2004;101(25):9205–9210. doi:10.1073/pnas.0403255101. Available from: https://pmc.ncbi.nlm.nih.gov/articles/PMC438954/

Mattei S, Glass B, Hagen WJH, Kräusslich HG, Briggs JAG. The structure and flexibility of conical HIV-1 capsids determined within intact virions. Science. 2016;354(6318):1434–1437. doi:10.1126/science.aah4972.

Schirra RT, dos Santos NFB, Zadrozny KK, Kucharska I, Ganser-Pornillos BK, Pornillos O. A molecular switch modulates assembly and host factor binding of the HIV-1 capsid. Nat Struct Mol Biol. 2023;30:383–390. doi:10.1038/s41594-022-00913-5.

Pornillos O, Ganser-Pornillos BK, Johnson MC, et al. X-ray structures of the hexameric building block of the HIV capsid. Cell. 2009;137(7):1282–1292. Available from: https://pmc.ncbi.nlm.nih.gov/articles/PMC3075868/

Li S, Hill CP, Sundquist WI, Finch JT. Image reconstructions of helical assemblies of the HIV-1 CA protein. Nature. 2000;407:409–413. Available from: https://www.nature.com/articles/nature12162