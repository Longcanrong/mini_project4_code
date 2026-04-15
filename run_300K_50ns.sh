cd /home/cmml3_xxxx/Results/300K_50ns || exit 1

GMX="/software/gromacs-2024.3/build/bin/gmx_mpi"
PREFIX="3S48_300K"
PDB="3S48_chainAD_noHEM_fixed.pdb"

for f in "$PDB" ions.mdp minim.mdp nvt_300K.mdp npt_300K.mdp md_300K.mdp; do
    if [[ ! -f "$f" ]]; then
        echo "[ERROR] Missing file: $f"
        exit 1
    fi
done

echo "[INFO] Starting workflow in $(pwd)"
date

printf "18\n" | "$GMX" pdb2gmx \
    -f "$PDB" \
    -o "${PREFIX}_processed.gro" \
    -water spce \
    -ignh

"$GMX" editconf \
    -f "${PREFIX}_processed.gro" \
    -o "${PREFIX}_newbox.gro" \
    -c -d 1.0 -bt cubic

"$GMX" solvate \
    -cp "${PREFIX}_newbox.gro" \
    -cs spc216.gro \
    -o "${PREFIX}_solv.gro" \
    -p topol.top

"$GMX" grompp \
    -f ions.mdp \
    -c "${PREFIX}_solv.gro" \
    -p topol.top \
    -o ions.tpr

printf "13\n" | "$GMX" genion \
    -s ions.tpr \
    -o "${PREFIX}_solv_ions.gro" \
    -p topol.top \
    -pname NA -nname CL -neutral

"$GMX" grompp \
    -f minim.mdp \
    -c "${PREFIX}_solv_ions.gro" \
    -p topol.top \
    -o em.tpr

"$GMX" mdrun -v -deffnm em

printf "10\n0\n" | "$GMX" energy \
    -f em.edr \
    -o potential.xvg

"$GMX" grompp \
    -f nvt_300K.mdp \
    -c em.gro \
    -r em.gro \
    -p topol.top \
    -o nvt_300K.tpr

"$GMX" mdrun -deffnm nvt_300K

printf "16\n0\n" | "$GMX" energy \
    -f nvt_300K.edr \
    -o temperature_300K.xvg

"$GMX" grompp \
    -f npt_300K.mdp \
    -c nvt_300K.gro \
    -r nvt_300K.gro \
    -t nvt_300K.cpt \
    -p topol.top \
    -o npt_300K.tpr

"$GMX" mdrun -deffnm npt_300K

printf "18\n0\n" | "$GMX" energy \
    -f npt_300K.edr \
    -o pressure_300K.xvg

printf "24\n0\n" | "$GMX" energy \
    -f npt_300K.edr \
    -o density_300K.xvg

"$GMX" grompp \
    -f md_300K.mdp \
    -c npt_300K.gro \
    -t npt_300K.cpt \
    -p topol.top \
    -o md_300K.tpr

"$GMX" mdrun -deffnm md_300K

printf "1\n0\n" | "$GMX" trjconv \
    -s md_300K.tpr \
    -f md_300K.xtc \
    -o md_300K_noPBC.xtc \
    -pbc mol -center

printf "4\n4\n" | "$GMX" rms \
    -s md_300K.tpr \
    -f md_300K_noPBC.xtc \
    -o rmsd_300K.xvg \
    -tu ns

printf "4\n4\n" | "$GMX" rms \
    -s em.tpr \
    -f md_300K_noPBC.xtc \
    -o rmsd_xtal_300K.xvg \
    -tu ns

printf "1\n" | "$GMX" gyrate \
    -s md_300K.tpr \
    -f md_300K_noPBC.xtc \
    -o gyrate_300K.xvg

echo "[INFO] Workflow completed successfully."