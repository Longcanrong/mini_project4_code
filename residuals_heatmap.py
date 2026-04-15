import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.DataFrame({
    "Reference": [113.71, 76.59, 64.48, 131.38, 35.95, 56.97, 70.85, 18.68, 0.00, 0.00, 0.00],
    "280K":      [107.30, 66.13, 62.58, 127.04, 41.61, 49.09, 52.42, 26.45, 43.85, 0.00, 0.00],
    "300K":      [95.17,  69.63, 64.75, 140.06, 26.82, 52.62, 71.30, 20.19, 0.00, 0.00, 15.06],
    "320K":      [106.57, 70.57, 56.21, 141.23, 25.97, 52.23, 27.00, 0.00, 76.15, 6.03, 0.00],
}, index=[
    "Lys11",
    "Tyr39 / Tyr125",
    "Tyr40 / Tyr126",
    "Phe43 / Phe129",
    "Asn65 / Asn151",
    "Thr66 / Thr152",
    "Asp74",
    "His96 / His182-like",
    "Lys46",
    "Ser3 (weak-contact example)",
    "Val92 (weak-contact example)",
])

fig, ax = plt.subplots(figsize=(8.6, 6.6))
sns.heatmap(
    df,
    annot=True,
    fmt=".2f",
    cmap="magma_r",
    vmin=0, vmax=145,
    linewidths=0.7, linecolor="white",
    cbar_kws={"label": "BSA (Å²)", "shrink": 0.9},
    ax=ax
)
ax.set_title("BSA (Buried Surface Area), Å²", pad=14, fontsize=13, fontweight=500)
ax.set_xlabel("")
ax.set_ylabel("")
for y in [6, 9]:
    ax.hlines(y, *ax.get_xlim(), colors="black", linewidth=2.5)

group_pos = [3, 7.0, 10]
group_text = [
    "Conserved / mostly retained",
    "Variable edge / partner region",
    "Weak-contact examples"
]

for y_pos, text in zip(group_pos, group_text):
    ax.text(
        x=-2.3,                
        y=y_pos,
        s=text,
        va="center", ha="left",
        fontsize=10, fontweight="bold",
        bbox=dict(boxstyle="round,pad=0.3",  
                  facecolor="#f0f0f0",      
                  edgecolor="none")          
    )

ax.set_yticklabels(ax.get_yticklabels(), rotation=0, fontsize=10)
ax.set_xticklabels(ax.get_xticklabels(), rotation=0, fontsize=10)
plt.xticks(rotation=0)
plt.tight_layout()
plt.subplots_adjust(left=0.32, right=0.95, top=0.90)
plt.show()