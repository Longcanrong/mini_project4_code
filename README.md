# CMML3 Mini-project 4  
## Effect of temperature on the 3S48 protein complex

This repository contains the code and analysis files I used for **CMML3 Mini-project 4**.

The project focused on the **3S48 complex**, which is formed by **human alpha-haemoglobin** and the **first NEAT domain of IsdH from *Staphylococcus aureus***. The main aim was to see how temperature changes the stability and interface organisation of this complex.

I compared:

- the **reference crystal structure** (3S48)
- an **AlphaFold3** model
- final MD structures from **280 K**, **300 K**, and **320 K**

---

## What I tried to do in this project

At the start, I thought this project would mainly be about comparing a few standard values like **RMSD** and **Rg**. But during the work, it became more about understanding how different types of structural information fit together.

So the analysis gradually developed into a workflow with two levels:

### 1. Global structural comparison
I first looked at:

- **RMSD** to compare overall deviation from the reference
- **Rg** to compare compactness

This helped me see that the three temperatures did not behave in a simple linear way.

### 2. Interface-level comparison
After that, I focused more on the binding interface itself, using:

- **PISA** for buried interface area, hydrogen bonds, salt bridges, and interfacing residues
- **PyMOL** for structural visualisation
- **DSSP** for secondary structure
- **PROCHECK** for Ramachandran plots

This part was the most useful, because it showed that temperature did not just make the complex more or less stable. Instead, it changed how the interface was arranged.

---

## The part I focused on most

The main part I focused on in more detail was the **residue-level interface analysis**.

From the **PISA interfacing residue** tables and the corresponding **buried surface area (BSA)** values, I compared the reference structure and the three MD-derived structures to see:

- which residues stayed important across models
- which residues changed more with temperature

A practical problem was that I could not just include four large PISA tables in the report. They were too big and not easy to compare directly. So instead, I selected the residues that seemed most informative and summarised them in a **heatmap**. That made it much easier to compare conserved residues and more temperature-sensitive ones.

---

## Main files / analyses in this repository

This repository may include some or all of the following, depending on the final cleaned version:

- scripts for plotting **RMSD** and **Rg**
- code for making the **interface residue heatmap**
- processed **DSSP** comparison files
- PyMOL scripts used to prepare the structural figure
- tables or notes collected from **PISA**
- figure output files used in the report

---

## General workflow

The workflow I followed was roughly:

1. start from the reference 3S48 structure
2. compare it with an AlphaFold3 model
3. analyse MD results at 280 K, 300 K, and 320 K
4. compare global properties using RMSD and Rg
5. compare interface properties using PISA and PyMOL
6. compare selected interface residues using BSA values
7. use DSSP and PROCHECK as supporting structural checks

---

## Main conclusion

The main conclusion of the project was that temperature did not simply cause loss of binding.  
Instead, it mainly changed how the complex was organised at the interface.

Overall, the same general binding region was retained, but local contacts and edge residues were more sensitive to temperature. Among the three MD end states, **300 K** remained the closest to the reference structure overall.

AlphaFold3 was useful as a comparison because it reproduced a broadly reference-like interface, but the MD results were more informative for showing how temperature could reshape that interface.

---

## Notes

This repository was prepared for coursework submission, so some parts are more focused on explaining the workflow than building a fully reusable software package.

Most of the interpretation in the final report came from combining different outputs rather than relying on one single metric.

---
