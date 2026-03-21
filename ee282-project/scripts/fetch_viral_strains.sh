#!/bin/bash

#
# Fetch Viral Strains for Cross-Species Conservation Analysis
# Gets multiple strains/subtypes of each virus for proper evolutionary comparison
#

echo "========================================"
echo "    Fetching Viral Strains for Cross-Species Analysis"
echo "========================================"

# Check dependencies
if ! command -v curl &> /dev/null; then
    echo "Error: curl not found"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq not found. Install with: sudo apt-get install jq"
    exit 1
fi

# Create output directory
mkdir -p viral_strains

# Function to fetch sequences from NCBI
fetch_ncbi_sequences() {
    local query="$1"
    local retmax="${2:-50}"
    local database="${3:-protein}"

    echo "  Searching: $query"

    # URL encode the query
    local encoded_query=$(echo "$query" | sed 's/ /%20/g' | sed 's/\[/%5B/g' | sed 's/\]/%5D/g')

    # Search for sequence IDs
    local search_url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
    local search_params="db=${database}&term=${encoded_query}&retmax=${retmax}&usehistory=y&retmode=json"

    local search_response=$(curl -s "${search_url}?${search_params}")

    if [[ $? -ne 0 ]] || [[ -z "$search_response" ]]; then
        echo "    Error: Failed to connect to NCBI"
        return 1
    fi

    # Check if we got results
    local count=$(echo "$search_response" | jq -r '.esearchresult.count // "0"')

    if [[ "$count" == "0" ]]; then
        echo "    No results found"
        return 1
    fi

    echo "    Found $count sequences"

    # Extract WebEnv and QueryKey
    local webenv=$(echo "$search_response" | jq -r '.esearchresult.webenv // empty')
    local querykey=$(echo "$search_response" | jq -r '.esearchresult.querykey // empty')

    if [[ -z "$webenv" ]] || [[ -z "$querykey" ]]; then
        echo "    Error: Could not get WebEnv/QueryKey"
        return 1
    fi

    # Fetch sequences
    local fetch_url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    local max_fetch=$((count < retmax ? count : retmax))
    local fetch_params="db=${database}&query_key=${querykey}&WebEnv=${webenv}&rettype=fasta&retmode=text&retmax=${max_fetch}"

    sleep 1  # Be nice to NCBI

    local sequences=$(curl -s "${fetch_url}?${fetch_params}")

    if [[ $? -ne 0 ]] || [[ -z "$sequences" ]]; then
        echo "    Error: Failed to fetch sequences"
        return 1
    fi

    # Check if we got FASTA format
    if [[ "$sequences" =~ ^\> ]]; then
        echo "$sequences"
        return 0
    else
        echo "    Error: Did not receive valid FASTA sequences"
        return 1
    fi
}

# Define viral strain queries for cross-species analysis
declare -A viral_strain_queries=(
    # HIV-1 subtypes (evolutionary diversity)
    ["HIV-1_subtype_A"]="HIV-1 AND subtype A AND gag"
    ["HIV-1_subtype_B"]="HIV-1 AND subtype B AND gag"
    ["HIV-1_subtype_C"]="HIV-1 AND subtype C AND gag"
    ["HIV-1_subtype_D"]="HIV-1 AND subtype D AND gag"

    # HIV-2 strains
    ["HIV-2_strains"]="HIV-2 AND gag"

    # SIV species (different host species)
    ["SIV_mac"]="SIV AND macaque AND gag"
    ["SIV_agm"]="SIV AND African green monkey AND gag"
    ["SIV_cpz"]="SIV AND chimpanzee AND gag"

    # HTLV-1 strains
    ["HTLV-1_strains"]="HTLV-1 AND gag"
)

echo "Fetching viral strains for cross-species comparison..."
echo

for virus_name in "${!viral_strain_queries[@]}"; do
    echo "[$virus_name]"

    query="${viral_strain_queries[$virus_name]}"
    output_file="viral_strains/${virus_name}.fasta"

    sequences=$(fetch_ncbi_sequences "$query" 30)

    if [[ $? -eq 0 ]] && [[ -n "$sequences" ]]; then
        echo "$sequences" > "$output_file"
        seq_count=$(grep -c "^>" "$output_file")
        echo "    Saved $seq_count sequences to: $output_file"
    else
        echo "    No sequences retrieved for $virus_name"
    fi

    echo
    sleep 2  # Rate limiting
done

echo "========================================"
echo "Viral strain fetching complete!"
echo "========================================"
echo

# Show summary
echo "Downloaded viral strain files:"
for file in viral_strains/*.fasta; do
    if [[ -f "$file" ]]; then
        basename=$(basename "$file")
        count=$(grep -c "^>" "$file" 2>/dev/null || echo "0")
        printf "  %-25s %s sequences\n" "$basename" "$count"
    fi
done

echo
echo "These sequences represent evolutionary diversity within each viral family"
echo "and can be used for proper cross-species conservation comparison."