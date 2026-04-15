from pdbfixer import PDBFixer
from openmm.app import PDBFile

input_pdb = "/home/cmml3_xxxx/pdb_file/3S48_chainAD_noHEM.pdb"
output_pdb = "/home/cmml3_xxxx/pdb_file/3S48_chainAD_noHEM_fixed.pdb"

fixer = PDBFixer(filename=input_pdb)

fixer.findMissingResidues()

fixer.findMissingAtoms()

fixer.addMissingAtoms()

fixer.addMissingHydrogens(7.0)

with open(output_pdb, "w") as f:
    PDBFile.writeFile(fixer.topology, fixer.positions, f)

print(f"Fixed structure written to {output_pdb}")