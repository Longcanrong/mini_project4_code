cd /home/cmml3_xxxx/Results/280K_50ns || exit 1

GMX="/software/gromacs-2024.3/build/bin/gmx_mpi"
PREFIX="3S48_280K"
PDB="3S48_chainAD_noHEM_fixed.pdb"

GPU_ID="1"
NTOMP="16"

for f in "$PDB" ions.mdp minim.mdp nvt_280K.mdp npt_280K.mdp md_280K.mdp; do
    if [[ ! -f "$f" ]]; then
        echo "[ERROR] Missing file: $f"
        exit 1
    fi
done

echo "[INFO] Starting workflow in $(pwd)"
date
echo "[INFO] Using GPU ${GPU_ID}, ntomp=${NTOMP}"

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

printf "SOL\n" | "$GMX" genion \
    -s ions.tpr \
    -o "${PREFIX}_solv_ions.gro" \
    -p topol.top \
    -pname NA -nname CL -neutral

"$GMX" grompp \
    -f minim.mdp \
    -c "${PREFIX}_solv_ions.gro" \
    -p topol.top \
    -o em.tpr

"$GMX" mdrun -v -deffnm em \
    -gpu_id "${GPU_ID}" -ntomp "${NTOMP}"

printf "Potential\n0\n" | "$GMX" energy \
    -f em.edr \
    -o potential.xvg

"$GMX" grompp \
    -f nvt_280K.mdp \
    -c em.gro \
    -r em.gro \
    -p topol.top \
    -o nvt_280K.tpr

"$GMX" mdrun -deffnm nvt_280K \
    -gpu_id "${GPU_ID}" -ntomp "${NTOMP}"

printf "Temperature\n0\n" | "$GMX" energy \
    -f nvt_280K.edr \
    -o temperature_280K.xvg

"$GMX" grompp \
    -f npt_280K.mdp \
    -c nvt_280K.gro \
    -r nvt_280K.gro \
    -t nvt_280K.cpt \
    -p topol.top \
    -o npt_280K.tpr

"$GMX" mdrun -deffnm npt_280K \
    -gpu_id "${GPU_ID}" -ntomp "${NTOMP}"

printf "Pressure\n0\n" | "$GMX" energy \
    -f npt_280K.edr \
    -o pressure_280K.xvg

printf "Density\n0\n" | "$GMX" energy \
    -f npt_280K.edr \
    -o density_280K.xvg

"$GMX" grompp \
    -f md_280K.mdp \
    -c npt_280K.gro \
    -t npt_280K.cpt \
    -p topol.top \
    -o md_280K.tpr

"$GMX" mdrun -deffnm md_280K \
    -gpu_id "${GPU_ID}" -ntomp "${NTOMP}"

printf "Protein\nSystem\n" | "$GMX" trjconv \
    -s md_280K.tpr \
    -f md_280K.xtc \
    -o md_280K_noPBC.xtc \
    -pbc mol -center

printf "Backbone\nBackbone\n" | "$GMX" rms \
    -s md_280K.tpr \
    -f md_280K_noPBC.xtc \
    -o rmsd_280K.xvg \
    -tu ns

printf "Backbone\nBackbone\n" | "$GMX" rms \
    -s em.tpr \
    -f md_280K_noPBC.xtc \
    -o rmsd_xtal_280K.xvg \
    -tu ns

printf "Protein\n" | "$GMX" gyrate \
    -s md_280K.tpr \
    -f md_280K_noPBC.xtc \
    -o gyrate_280K.xvg

echo "[INFO] Workflow completed successfully."