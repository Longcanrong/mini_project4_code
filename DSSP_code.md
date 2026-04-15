#### pdb chosen

```bash
cd /home/cmml3_myname/Results/300K_50ns

printf "Protein\n" | /software/gromacs-2024.3/build/bin/gmx_mpi trjconv \
-s md_300K.tpr \
-f md_300K_noPBC.xtc \
-o final_300K_50ns_protein.pdb \
-dump 50000
```

#### cif format converting using gemmi

```bash
gemmi convert final_320K_50ns_protein.pdb final_300K_50ns_protein.cif
```

#### DSSP necessary path file

```bash
export LIBCIFPP_DATA_DIR=$HOME/libcifpp_data
export CIFPP_DATA_DIR=$HOME/libcifpp_data
```

#### mkdssp

```bash
mkdssp final_300K_50ns_protein.cif final_300K_50ns_protein.dssp
```
