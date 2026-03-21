#!/bin/bash

#
# Cross-Viral Comparison Pipeline
# Complete retroviral family CA analysis and comparison plotting
#

echo "========================================"
echo "    Cross-Viral Comparison Analysis"
echo "========================================"

# Step 0: Fetch viral sequences if needed
echo "Step 0: Ensuring viral sequences are available..."

viral_files_needed=(
    "viral_capsid_sequences/HIV-2_gag.fasta"
    "viral_capsid_sequences/SIV_gag.fasta"
    "viral_capsid_sequences/HTLV-1_gag.fasta"
)

missing_files=()
for file in "${viral_files_needed[@]}"; do
    if [[ ! -f "$file" ]]; then
        missing_files+=("$(basename "$file")")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo "  Missing viral sequences: ${missing_files[*]}"
    echo "  Fetching viral sequences..."
    ./fetch_viral_capsids.sh
    echo "  Viral sequence fetching complete"
else
    echo "  All viral sequences already available"
fi

echo

# Check dependencies
if ! command -v mafft &> /dev/null; then
    echo "Error: MAFFT not found. Install with: sudo apt-get install mafft"
    exit 1
fi

if ! command -v Rscript &> /dev/null; then
    echo "Error: R not found. Install with: sudo apt-get install r-base"
    exit 1
fi

# Check required files
if [[ ! -f "CA-sequence.txt" ]]; then
    echo "Error: CA-sequence.txt not found!"
    exit 1
fi

if [[ ! -f "analysis_results/conservation_data.csv" ]]; then
    echo "Error: HIV-1 conservation data not found!"
    echo "Please run ./hiv1-conservation.sh first"
    exit 1
fi

# Create output directory
mkdir -p retroviral_ca_analysis

echo "Step 1: Extracting CA regions from retroviral families..."

# Get HIV-1 CA reference
hiv1_ca=$(head -1 CA-sequence.txt | tr -d '[:space:]')
ca_length=${#hiv1_ca}

# Function to extract retroviral CA regions
extract_retroviral_ca() {
    local fasta_file="$1"
    local virus_name="$2"
    local output_file="retroviral_ca_analysis/${virus_name}_ca.fasta"

    if [[ ! -f "$fasta_file" ]]; then
        echo "  $virus_name: File not found, skipping..."
        return
    fi

    echo "  Extracting $virus_name CA regions..."

    echo ">$virus_name CA regions" > "$output_file"

    # Extract CA-like regions from gag proteins
    awk 'BEGIN {in_fasta=0; count=0; seq=""}
         /^>/ && !in_fasta {in_fasta=1; next}
         in_fasta && /^>/ {
             if(seq != "" && length(seq) > 400) {
                 ca_region = substr(seq, 130, 250)
                 if(length(ca_region) > 200) {
                     print ca_region
                     count++
                     if(count >= 10) exit
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
                 ca_region = substr(seq, 130, 250)
                 if(length(ca_region) > 200) {
                     print ca_region
                 }
             }
         }' "$fasta_file" >> "$output_file"

    local extracted=$(tail -n +2 "$output_file" | wc -l)
    echo "    Extracted $extracted sequences"
}

# Extract CA from all available retroviruses
extract_retroviral_ca "viral_capsid_sequences/HIV-2_gag.fasta" "HIV-2"
extract_retroviral_ca "viral_capsid_sequences/SIV_gag.fasta" "SIV"
extract_retroviral_ca "viral_capsid_sequences/HTLV-1_gag.fasta" "HTLV-1"

echo
echo "Step 2: Creating retroviral CA alignment..."

# Create HIV-1 reference
echo ">HIV-1_CA_reference" > retroviral_ca_analysis/HIV-1_ca.fasta
echo "$hiv1_ca" >> retroviral_ca_analysis/HIV-1_ca.fasta

# Combine all CA sequences
cat retroviral_ca_analysis/HIV-1_ca.fasta retroviral_ca_analysis/*_ca.fasta > retroviral_ca_analysis/all_retroviral_ca.fasta

# Count sequences
num_seqs=$(grep -c "^>" retroviral_ca_analysis/all_retroviral_ca.fasta)
echo "  Total sequences: $num_seqs"

# Align with MAFFT
mafft --quiet --localpair --maxiterate 1000 retroviral_ca_analysis/all_retroviral_ca.fasta > retroviral_ca_analysis/retroviral_ca_aligned.fasta

echo "  Alignment complete"

echo
echo "Step 3: Calculating cross-species conservation..."

# Calculate conservation
grep -v "^>" retroviral_ca_analysis/retroviral_ca_aligned.fasta > retroviral_ca_analysis/temp_seqs.txt
align_length=$(head -1 retroviral_ca_analysis/temp_seqs.txt | wc -c)
num_aligned=$(wc -l < retroviral_ca_analysis/temp_seqs.txt)

echo "Position,Conservation" > retroviral_ca_analysis/retroviral_ca_conservation.csv

for pos in $(seq 1 $align_length); do
    column=$(cut -c$pos retroviral_ca_analysis/temp_seqs.txt | grep -v '^$')

    if [[ -n "$column" ]]; then
        non_gaps=$(echo "$column" | grep -v '^-$' | wc -l)
        if [[ $non_gaps -gt 0 ]]; then
            most_common_count=$(echo "$column" | grep -v '^-$' | sort | uniq -c | sort -nr | head -1 | awk '{print $1}')
            conservation=$(echo "scale=3; $most_common_count / $non_gaps" | bc -l)
        else
            conservation=0
        fi
    else
        conservation=0
    fi

    echo "$pos,$conservation" >> retroviral_ca_analysis/retroviral_ca_conservation.csv
done

rm retroviral_ca_analysis/temp_seqs.txt

# Get conservation stats
avg_conservation=$(tail -n +2 retroviral_ca_analysis/retroviral_ca_conservation.csv | awk -F',' '{sum+=$2; count++} END {printf "%.1f", (sum/count)*100}')
echo "  Average conservation: ${avg_conservation}%"

echo
echo "Step 4: Creating comparison plots..."

# Create R plotting script and run it
cat > temp_plotting.R << 'EOF'
library(ggplot2)

# Load data
hiv1_data <- read.csv("analysis_results/conservation_data.csv")
retroviral_data <- read.csv("retroviral_ca_analysis/retroviral_ca_conservation.csv")
retroviral_data$Conservation_Pct <- retroviral_data$Conservation * 100

# Prepare comparison data
min_length <- min(nrow(hiv1_data), nrow(retroviral_data))
comparison_positions <- 1:min_length

comparison_data <- data.frame(
  Position = rep(comparison_positions, 2),
  Conservation = c(
    hiv1_data$Average_Conservation[comparison_positions],
    retroviral_data$Conservation_Pct[comparison_positions]
  ),
  Dataset = rep(c("HIV-1 Temporal", "Retroviral Family"), each = min_length)
)

# Plot 1: Side-by-side comparison
p1 <- ggplot(comparison_data, aes(x = Position, y = Conservation, color = Dataset)) +
  geom_line(linewidth = 1.5, alpha = 0.9) +
  scale_color_manual(values = c("HIV-1 Temporal" = "#DC143C", "Retroviral Family" = "#4169E1")) +
  labs(title = "Conservation: Temporal vs Evolutionary",
       subtitle = "Red: HIV-1 over time | Blue: Retroviral family across species",
       x = "CA Position", y = "Conservation (%)", color = "Type") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold", margin = margin(b = 10)),
        plot.subtitle = element_text(hjust = 0.5, size = 12, color = "gray60", margin = margin(b = 20)),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12, color = "black"),
        panel.border = element_rect(linewidth = 0.8, color = "black", fill = NA),
        legend.position = "top", legend.title = element_text(size = 13, face = "bold"),
        panel.grid.major.y = element_line(color = "grey90", linewidth = 0.3),
        panel.grid.minor = element_blank()) +
  ylim(0, 100)

ggsave("analysis_results/cross_viral_comparison.png", p1, width = 12, height = 8, dpi = 300)


# Calculate correlation
correlation <- cor(hiv1_data$Average_Conservation[comparison_positions],
                  retroviral_data$Conservation_Pct[comparison_positions], use = "complete.obs")

# Print summary
cat("Cross-Viral Comparison Results:\n")
cat("  HIV-1 temporal:", round(mean(hiv1_data$Average_Conservation), 1), "% average\n")
cat("  Retroviral family:", round(mean(retroviral_data$Conservation_Pct), 1), "% average\n")
cat("  Correlation:", round(correlation, 3), "\n")
cat("  Interpretation:", if(abs(correlation) < 0.3) "Independent evolution" else "Some shared constraints", "\n")
EOF

Rscript temp_plotting.R
rm temp_plotting.R

echo
echo "========================================"
echo "         ANALYSIS COMPLETE"
echo "========================================"
echo
echo "Cross-viral comparison files created:"
echo "  - analysis_results/cross_viral_comparison.png"
echo "  - retroviral_ca_analysis/ (alignment data)"
echo
echo "This analysis compares:"
echo "  • HIV-1 temporal conservation (functional constraints)"
echo "  • Retroviral family conservation (evolutionary constraints)"
echo
echo "Results show the difference between short-term and long-term"
echo "evolutionary pressures on viral capsid proteins!"