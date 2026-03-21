#!/usr/bin/env bash

#
# Map conservation scores from R analysis to PDB structure
# Replaces B-factor column with conservation scores for visualization
#

PDB_FILE="6BHT_monomer.pdb"
CONSERVATION_FILE="analysis_results/conservation_data.csv"

# Check if files exist
if [[ ! -f "$PDB_FILE" ]]; then
    echo "Error: PDB file $PDB_FILE not found!"
    exit 1
fi

if [[ ! -f "$CONSERVATION_FILE" ]]; then
    echo "Error: Conservation data file $CONSERVATION_FILE not found!"
    echo "Please run simple_analysis.R first to generate the data."
    exit 1
fi

# Function to map conservation scores to PDB
map_conservation() {
    local column="$1"
    local output_file="$2"

    awk -F',' -v pdb="$PDB_FILE" -v col="$column" '
        FNR==NR && FNR==1 {
            for (i=1; i<=NF; i++) if ($i == col) colidx = i
            if (!colidx) { print "Error: Column " col " not found"; exit 1 }
            next
        }
        FNR==NR {
            scores[FNR-1] = $colidx
            next
        }
        /^ATOM/ {
            res_num = substr($0,23,4) + 0
            score = (res_num in scores) ? scores[res_num] : 0.0
            printf "%s%6.2f%s\n", substr($0,1,60), score, substr($0,67)
            next
        }
        { print }
    ' "$CONSERVATION_FILE" "$PDB_FILE" > "$output_file"

    if [[ $? -eq 0 ]]; then
        echo "Saved as $output_file"
    else
        echo "Error: Failed to create $output_file"
        exit 1
    fi
}

# Process conservation columns for each time period
time_periods=("2015_2025" "2000_2025" "1975_2025")

for period in "${time_periods[@]}"; do
    column="\"Conservation_${period}\""
    output_file="6BHT_conservation_${period}.pdb"

    # Check if column exists and process
    if head -n 1 "$CONSERVATION_FILE" | grep -q "$column"; then
        map_conservation "$column" "$output_file"
    else
        echo "Warning: Column $column not found, skipping $period"
    fi
done

# Also create the average conservation PDB
avg_column='"Average_Conservation"'
avg_output_file="6BHT_conservation_average.pdb"

if head -n 1 "$CONSERVATION_FILE" | grep -q "$avg_column"; then
    map_conservation "$avg_column" "$avg_output_file"
else
    echo "Warning: Column $avg_column not found"
fi
