cd ~/pdb_file || exit 1

INPUT_PDB="3S48_AD_HEM_clean.pdb"
PREFIX="3S48_AD_HEM_300K_test"
OUTPUT_DIR="/home/cmml3_xxxx/Results"

gmx pdb2gmx \
  -f ${INPUT_PDB} \
  -o ${OUTPUT_DIR}/${PREFIX}_processed.gro \
  -water spce \
  -ignh

# 2. Define the box
gmx editconf \
  -f ${OUTPUT_DIR}/${PREFIX}_processed.gro \
  -o ${OUTPUT_DIR}/${PREFIX}_newbox.gro \
  -c -d 1.0 -bt cubic

# 3. Solvate the system
gmx solvate \
  -cp ${OUTPUT_DIR}/${PREFIX}_newbox.gro \
  -cs spc216.gro \
  -o ${OUTPUT_DIR}/${PREFIX}_solv.gro \
  -p topol.top

# 4. Prepare for ion addition
gmx grompp \
  -f ions.mdp \
  -c ${OUTPUT_DIR}/${PREFIX}_solv.gro \
  -p topol.top \
  -o ions.tpr

# 5. Add ions
gmx genion \
  -s ions.tpr \
  -o ${OUTPUT_DIR}/${PREFIX}_solv_ions.gro \
  -p topol.top \
  -pname NA -nname CL -neutral

# 6. Energy minimization pre-processing
gmx grompp \
  -f minim.mdp \
  -c ${OUTPUT_DIR}/${PREFIX}_solv_ions.gro \
  -p topol.top \
  -o em.tpr

# 7. Run energy minimization
gmx mdrun -v -deffnm em

# 8. Check potential energy
gmx energy -f em.edr -o potential.xvg

# 9. NVT equilibration pre-processing
gmx grompp \
  -f nvt_short.mdp \
  -c em.gro \
  -r em.gro \
  -p topol.top \
  -o nvt.tpr

# 10. Run short NVT equilibration
gmx mdrun -deffnm nvt
gmx grompp -f npt_short.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt
gmx energy -f npt.edr -o pressure.xvg
gmx grompp -f md_short.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
gmx mdrun -deffnm md_0_1
gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_noPBC.xtc -pbc mol -center
gmx rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsd.xvg -tu ns
gmx rms -s em.tpr -f md_0_1_noPBC.xtc -o rmsd_xtal.xvg -tu ns
gmx gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -o gyrate.xvg