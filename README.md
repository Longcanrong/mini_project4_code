# CMML3 Mini-project 4  
## Effect of temperature on the 3S48 protein complex

This repository contains the code and analysis files I used for **CMML3 Mini-project 4**.

The project focused on the **3S48 complex**, which is formed by **human alpha-haemoglobin** and the **first NEAT domain of IsdH from *Staphylococcus aureus***. The main aim was to see how temperature changes the stability and interface organisation of this complex.

I compared:

- the **reference crystal structure** (3S48)
- an **AlphaFold3** model
- final MD structures from **280 K**, **300 K**, and **320 K**

---

## Main files / analyses in this repository

This repository may include some or all of the following, depending on the final cleaned version:

- scripts for plotting **RMSD** and **Rg**
- code for making the **interface residue heatmap**
- processed **DSSP** comparison files
- PyMOL scripts used to prepare the structural figure
- tables or notes collected from **PISA**

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


## Notes

This repository was prepared for coursework submission, so some parts are more focused on explaining the workflow.

Most of the interpretation in the final report came from combining different outputs rather than relying on one single metric.

---
