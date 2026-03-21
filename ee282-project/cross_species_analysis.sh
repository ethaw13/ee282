#!/bin/bash

#
# Viral Strain Conservation Comparison
# Compare conservation patterns across different viral strains
#

echo "========================================"
echo "    Viral Strain Conservation Comparison"
echo "========================================"

# Check if strain data exists
if [[ ! -d "viral_strains" ]] || [[ $(find viral_strains -name "*.fasta" 2>/dev/null | wc -l) -lt 3 ]]; then
    echo "Viral strains data missing or incomplete. Fetching now..."
    scripts/fetch_viral_strains.sh
    echo "Viral strain fetching complete"
    echo
fi

# Check required files
if [[ ! -f "CA-sequence.txt" ]]; then
    echo "Error: CA-sequence.txt not found!"
    exit 1
fi

# Create output directory
mkdir -p cross_species_analysis

echo "Step 1: Extracting CA regions from viral strains..."

# Function to extract CA regions and calculate conservation
analyze_viral_family() {
    local family_name="$1"
    shift
    local files=("$@")

    echo "  Analyzing $family_name..."

    # Combine sequences from all strains/subtypes in this family
    local combined_file="cross_species_analysis/${family_name}_combined.fasta"
    > "$combined_file"  # Clear file

    local total_seqs=0
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "    Adding sequences from $(basename "$file")..."
            cat "$file" >> "$combined_file"
            local seqs=$(grep -c "^>" "$file")
            total_seqs=$((total_seqs + seqs))
        fi
    done

    echo "    Total sequences for $family_name: $total_seqs"

    if [[ $total_seqs -lt 5 ]]; then
        echo "    Warning: Too few sequences for $family_name"
        return
    fi

    # Extract CA-like regions
    local ca_file="cross_species_analysis/${family_name}_ca.fasta"
    > "$ca_file"  # Clear file

    # For HIV-1, we know the CA domain well
    if [[ "$family_name" == "HIV-1" ]]; then
        # Use known HIV-1 CA boundaries in gag (approximately positions 130-350)
        awk 'BEGIN {in_fasta=0; count=0; seq=""}
             /^>/ && !in_fasta {in_fasta=1; next}
             in_fasta && /^>/ {
                 if(seq != "" && length(seq) > 400) {
                     ca_region = substr(seq, 130, 220)  # HIV-1 CA region
                     if(length(ca_region) > 180) {
                         print ">HIV-1_CA_" count
                         print ca_region
                         count++
                     }
                 }
                 seq = ""
                 next
             }
             in_fasta && !/^>/ {
                 gsub(/[-\s]/, "")
                 seq = seq $0
             }
             END {
                 if(seq != "" && length(seq) > 400) {
                     ca_region = substr(seq, 130, 220)
                     if(length(ca_region) > 180) {
                         print ">HIV-1_CA_" count
                         print ca_region
                     }
                 }
             }' "$combined_file" >> "$ca_file"
    else
        # For other viruses, use similar extraction
        awk -v family="$family_name" 'BEGIN {in_fasta=0; count=0; seq=""}
             /^>/ && !in_fasta {in_fasta=1; next}
             in_fasta && /^>/ {
                 if(seq != "" && length(seq) > 300) {
                     ca_region = substr(seq, 120, 200)  # Estimated CA region
                     if(length(ca_region) > 150) {
                         print ">" family "_CA_" count
                         print ca_region
                         count++
                     }
                 }
                 seq = ""
                 next
             }
             in_fasta && !/^>/ {
                 gsub(/[-\s]/, "")
                 seq = seq $0
             }
             END {
                 if(seq != "" && length(seq) > 300) {
                     ca_region = substr(seq, 120, 200)
                     if(length(ca_region) > 150) {
                         print ">" family "_CA_" count
                         print ca_region
                     }
                 }
             }' "$combined_file" >> "$ca_file"
    fi

    local extracted=$(tail -n +2 "$ca_file" | wc -l)
    echo "    Extracted $extracted CA sequences"
}

# Analyze each viral family
if ls viral_strains/HIV-1_subtype_*.fasta 1> /dev/null 2>&1; then
    analyze_viral_family "HIV-1" viral_strains/HIV-1_subtype_*.fasta
fi

if [[ -f "viral_strains/HIV-2_strains.fasta" ]]; then
    analyze_viral_family "HIV-2" viral_strains/HIV-2_strains.fasta
fi

if ls viral_strains/SIV_*.fasta 1> /dev/null 2>&1; then
    analyze_viral_family "SIV" viral_strains/SIV_*.fasta
fi

if [[ -f "viral_strains/HTLV-1_strains.fasta" ]]; then
    analyze_viral_family "HTLV-1" viral_strains/HTLV-1_strains.fasta
fi

echo
echo "Step 2: Calculating conservation using HIV-1 reference coordinates (1-221)..."

# Get HIV-1 reference length
if [[ ! -f "CA-sequence.txt" ]]; then
    echo "Error: CA-sequence.txt not found!"
    exit 1
fi

hiv1_ca=$(head -1 CA-sequence.txt | tr -d '[:space:]')
ref_length=${#hiv1_ca}
echo "  Using HIV-1 reference length: $ref_length positions"

# Function to calculate conservation using reference coordinates
calculate_reference_conservation() {
    local family_name="$1"
    local ca_file="cross_species_analysis/${family_name}_ca.fasta"

    if [[ ! -f "$ca_file" ]] || [[ $(grep -c "^>" "$ca_file") -lt 3 ]]; then
        echo "  Skipping $family_name (insufficient sequences)"
        return
    fi

    echo "  Analyzing $family_name..."

    # Extract just the sequences (no headers) and truncate/pad to reference length
    grep -v "^>" "$ca_file" > "cross_species_analysis/${family_name}_seqs.txt"

    # Pad or truncate sequences to match reference length
    awk -v ref_len="$ref_length" '{
        seq = $0
        gsub(/[-\s]/, "", seq)  # Remove gaps and spaces
        if(length(seq) > ref_len) seq = substr(seq, 1, ref_len)  # Truncate
        while(length(seq) < ref_len) seq = seq "X"  # Pad with X
        print seq
    }' "cross_species_analysis/${family_name}_seqs.txt" > "cross_species_analysis/${family_name}_fixed.txt"

    local num_seqs=$(wc -l < "cross_species_analysis/${family_name}_fixed.txt")
    echo "    Using $num_seqs sequences"

    # Calculate conservation at each reference position
    echo "Position,Conservation" > "cross_species_analysis/${family_name}_conservation.csv"

    for pos in $(seq 1 $ref_length); do
        local column=$(cut -c$pos "cross_species_analysis/${family_name}_fixed.txt")

        if [[ -n "$column" ]]; then
            local total_seqs=$(echo "$column" | wc -l)
            local non_gaps=$(echo "$column" | grep -v '^X$' | grep -v '^-$' | wc -l)
            local gap_fraction=$(echo "scale=2; ($total_seqs - $non_gaps) / $total_seqs" | bc -l)

            # Skip positions with >50% gaps/padding
            if (( $(echo "$gap_fraction > 0.5" | bc -l) )); then
                echo "$pos,NA" >> "cross_species_analysis/${family_name}_conservation.csv"
            elif [[ $non_gaps -gt 2 ]]; then
                local most_common_count=$(echo "$column" | grep -v '^X$' | grep -v '^-$' | sort | uniq -c | sort -nr | head -1 | awk '{print $1}')
                local conservation=$(echo "scale=3; $most_common_count / $non_gaps" | bc -l)
                echo "$pos,$conservation" >> "cross_species_analysis/${family_name}_conservation.csv"
            else
                echo "$pos,NA" >> "cross_species_analysis/${family_name}_conservation.csv"
            fi
        else
            echo "$pos,NA" >> "cross_species_analysis/${family_name}_conservation.csv"
        fi
    done

    rm "cross_species_analysis/${family_name}_seqs.txt"
    # Keep _fixed.txt for consensus sequence creation

    local avg_conservation=$(tail -n +2 "cross_species_analysis/${family_name}_conservation.csv" | awk -F',' '$2!="NA" {sum+=$2; count++} END {if(count>0) printf "%.1f", (sum/count)*100; else print "0.0"}')
    echo "    Average conservation: ${avg_conservation}%"
}

# Calculate conservation for each viral family using reference coordinates
calculate_reference_conservation "HIV-1"
calculate_reference_conservation "HIV-2"
calculate_reference_conservation "SIV"
calculate_reference_conservation "HTLV-1"

echo
echo "Step 3: Creating viral strain conservation comparison plot..."

# Create R plotting script
cat > temp_viral_comparison_plot.R << 'EOF'
library(ggplot2)

# Load data for all viral families
families <- c("HIV-1", "HIV-2", "SIV", "HTLV-1")
all_data <- data.frame()

for (family in families) {
  file_path <- paste0("cross_species_analysis/", family, "_conservation.csv")
  if (file.exists(file_path)) {
    data <- read.csv(file_path, stringsAsFactors = FALSE)
    data$Conservation[data$Conservation == "NA"] <- NA
    data$Conservation <- as.numeric(data$Conservation)
    data$Conservation_Pct <- data$Conservation * 100
    data$Viral_Family <- family
    all_data <- rbind(all_data, data)
  }
}

if (nrow(all_data) == 0) {
  cat("No conservation data found\n")
  quit(status=1)
}

# Create comparison plot
p1 <- ggplot(all_data, aes(x = Position, y = Conservation_Pct, color = Viral_Family)) +
  geom_line(linewidth = 1.2, alpha = 0.8) +
  scale_color_manual(values = c("HIV-1" = "#DC143C", "HIV-2" = "#FF6347", "SIV" = "#4169E1", "HTLV-1" = "#32CD32")) +
  labs(title = "Viral Strain Conservation Comparison",
       x = "HIV-1 CA Position (1-221)", y = "Conservation (%)", color = "Viral Family") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold", margin = margin(b = 20)),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12, color = "black"),
        panel.border = element_rect(linewidth = 0.8, color = "black", fill = NA),
        legend.position = "top",
        legend.title = element_text(size = 13, face = "bold"),
        panel.grid.major.y = element_line(color = "grey90", linewidth = 0.3),
        panel.grid.minor = element_blank()) +
  ylim(0, 100)

ggsave("analysis_results/viral_strain_comparison.png", p1, width = 12, height = 8, dpi = 300)

# Calculate and display statistics
cat("Viral Strain Conservation Analysis:\n")
for (family in families) {
  family_data <- subset(all_data, Viral_Family == family)
  if (nrow(family_data) > 0) {
    avg_conservation <- mean(family_data$Conservation_Pct, na.rm = TRUE)
    valid_positions <- sum(!is.na(family_data$Conservation_Pct))
    cat("  ", family, ":", round(avg_conservation, 1), "% average (", valid_positions, "/", nrow(family_data), " positions)\n")
  }
}
EOF

if command -v Rscript &> /dev/null; then
    Rscript temp_viral_comparison_plot.R
    rm temp_viral_comparison_plot.R
    echo "  Created: analysis_results/viral_strain_comparison.png"
else
    echo "  R not available for plotting. Data analysis complete."
fi

echo
echo "========================================"
echo "         ANALYSIS COMPLETE"
echo "========================================"
echo
echo "Files created:"
echo "  Data: cross_species_analysis/ (conservation data for each viral family)"
echo "  Plot: analysis_results/viral_strain_comparison.png"
echo
echo "This analysis compares conservation patterns across viral strains!"