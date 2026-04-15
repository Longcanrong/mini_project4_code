from collections import Counter
import sys

dssp_file = "/home/cmml3_canrong/Results/50ns/final_300K_50ns_protein.dssp"
# dssp_file = "/home/cmml3_canrong/Results/50ns/final_280K_50ns_protein.dssp"
# dssp_file = "/home/cmml3_canrong/Results/50ns/final_320K_50ns_protein.dssp"
# dssp_file = "/home/cmml3_canrong/Results/50ns/fold_model.dssp"

counts = Counter()
total = 0
start = False

with open(dssp_file) as f:
    for line in f:
        if line.startswith("  #  RESIDUE AA STRUCTURE") or line.startswith("#  RESIDUE AA STRUCTURE"):
            start = True
            continue
        if not start:
            continue
        if len(line) < 17:
            continue

        aa = line[13]
        if aa == "!":
            continue

        ss = line[16]  # DSSP secondary structure column

        if ss in ["H", "G", "I"]:
            counts["Helix"] += 1
        elif ss in ["E", "B"]:
            counts["Sheet"] += 1
        else:
            counts["Coil/Other"] += 1

        total += 1

print(f"File: {dssp_file}")
print(f"Total residues: {total}")
for k in ["Helix", "Sheet", "Coil/Other"]:
    n = counts[k]
    pct = 100 * n / total if total else 0
    print(f"{k}: {n} ({pct:.2f}%)")