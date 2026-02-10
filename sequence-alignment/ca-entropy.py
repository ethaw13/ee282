#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

CA_QUERY = "CA-sequence.txt"
HIV_DB1  = "HIV-1_gag_757.fasta"
HIV_DB2  = "HIV-1_gag_2967.fasta"
OUTPUT1  = "ca_conservation_757.png"
OUTPUT2  = "ca_conservation_2967.png"

AMINO_ACIDS = "ACDEFGHIKLMNPQRSTVWY"


def extract_ca_sequences(hiv_fasta, ca_query_seq):
    hiv_records = []
    for rec in SeqIO.parse(hiv_fasta, "fasta"):
        degapped = str(rec.seq).replace("-", "")
        if len(degapped) > 50:
            hiv_records.append(SeqRecord(Seq(degapped), id=rec.id, description=""))

    print(f"Found {len(hiv_records)} HIV sequences for CA extraction")

    ca_sequences = []
    ca_len = len(ca_query_seq)

    for rec in hiv_records:
        seq = str(rec.seq)
        best_score = 0
        best_start = 0

        for start in range(max(1, len(seq) - ca_len)):
            window = seq[start:start + ca_len]
            if len(window) == ca_len:
                score = sum(1 for a, b in zip(ca_query_seq, window) if a == b)
                if score > best_score:
                    best_score = score
                    best_start = start

        if best_score > ca_len * 0.3:
            ca_seq = seq[best_start:best_start + ca_len]
            if len(ca_seq) == ca_len:
                ca_sequences.append(ca_seq)

    return ca_sequences


def compute_conservation_score(sequences):
    if not sequences:
        return np.array([])

    seq_len = len(sequences[0])
    conservation = np.zeros(seq_len)

    for pos in range(seq_len):
        aa_counts = {aa: 0 for aa in AMINO_ACIDS}
        total = 0

        for seq in sequences:
            if pos < len(seq):
                aa = seq[pos]
                if aa in aa_counts:
                    aa_counts[aa] += 1
                    total += 1

        if total > 0:
            max_count = max(aa_counts.values())
            conservation[pos] = (max_count / total) * 100

    return conservation


def plot_conservation(conservation_values, output, title_suffix):
    positions = np.arange(1, len(conservation_values) + 1)

    fig, ax = plt.subplots(figsize=(10, 6))

    ax.plot(positions, conservation_values, linewidth=1.5, color='steelblue')

    ax.set_xlabel("CA Residue Position")
    ax.set_ylabel("Conservation Score (%)")
    ax.set_title(f"Conservation Score of HIV-1 CA Protein - {title_suffix}")
    ax.set_xlim(1, len(conservation_values))
    ax.set_ylim(0, 100)

    ax.axhline(100, color="darkblue", linestyle="--", linewidth=0.8, alpha=0.7)
    ax.axhline(50, color="gray", linestyle=":", linewidth=0.8, alpha=0.7)

    plt.tight_layout()
    plt.savefig(output, dpi=200, bbox_inches='tight')
    print(f"Plot saved to {output}")


def analyze_dataset(fasta_file, ca_query, dataset_name):
    print(f"\nAnalyzing {dataset_name}...")
    print(f"  Extracting CA regions from {fasta_file}...")
    ca_sequences = extract_ca_sequences(fasta_file, ca_query)
    print(f"  Extracted {len(ca_sequences)} CA sequences")

    if len(ca_sequences) < 10:
        print(f"  Warning: Very few CA sequences found in {dataset_name}")

    all_sequences = [ca_query] + ca_sequences
    conservation = compute_conservation_score(all_sequences)

    print(f"  Mean conservation: {conservation.mean():.1f}%")
    print(f"  Min conservation:  {conservation.min():.1f}% (most variable)")
    print(f"  Max conservation:  {conservation.max():.1f}% (most conserved)")

    sorted_idx = np.argsort(conservation)
    print(f"  Top 5 most variable positions:")
    for i in sorted_idx[:5]:
        print(f"    Position {i+1:3d}: {conservation[i]:.1f}% conserved, residue = {ca_query[i]}")

    return conservation


def main():
    print(f"Reading CA query from {CA_QUERY}...")
    ca_text = Path(CA_QUERY).read_text().strip()
    if ca_text.startswith(">"):
        ca_query = str(next(SeqIO.parse(CA_QUERY, "fasta")).seq)
    else:
        ca_query = ca_text

    print(f"  CA query length: {len(ca_query)} residues")

    conservation1 = analyze_dataset(HIV_DB1, ca_query, "Dataset 1 (757 sequences)")
    conservation2 = analyze_dataset(HIV_DB2, ca_query, "Dataset 2 (2967 sequences)")

    print(f"\nGenerating plots...")
    plot_conservation(conservation1, OUTPUT1, "757 sequences")
    plot_conservation(conservation2, OUTPUT2, "2967 sequences")


if __name__ == "__main__":
    main()