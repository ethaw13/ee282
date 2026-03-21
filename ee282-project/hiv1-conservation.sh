#!/bin/bash

#
# Complete HIV-1 Conservation Analysis + PDB Mapping Pipeline
#

echo "==========================================="
echo "  Complete HIV-1 Conservation Pipeline"
echo "==========================================="
echo

# Step 1: Run conservation analysis
echo "Step 1: Running conservation analysis..."
scripts/complete_conservation_analysis.R

if [[ $? -ne 0 ]]; then
    echo "Error: Conservation analysis failed"
    exit 1
fi

# Step 2: Map conservation to PDB
echo
echo "Step 2: Mapping conservation to PDB structure..."
scripts/map_conservation_to_pdb.sh

if [[ $? -ne 0 ]]; then
    echo "Error: PDB mapping failed"
    exit 1
fi

echo
echo "==========================================="
echo "             PIPELINE COMPLETE"
echo "==========================================="
echo
echo "Results created:"
echo "  Plots:"
echo "    - analysis_results/conservation_plot_3groups.png"
echo
echo "  Data:"
echo "    - analysis_results/conservation_data.csv"
echo
echo "  PDB Structures:"
echo "    - 6BHT_conservation_2015_2025.pdb (10 years)"
echo "    - 6BHT_conservation_2000_2025.pdb (25 years)"
echo "    - 6BHT_conservation_1975_2025.pdb (50 years)"
echo "    - 6BHT_conservation_average.pdb (average)"
