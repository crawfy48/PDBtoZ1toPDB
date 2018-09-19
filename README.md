# PDBtoZ1toPDB
utilities for converting PDB files to a format recognized by Z1 code (http://www.complexfluids.ethz.ch/cgi-bin/Z1) and then back to PDB.

Usage examples:
`./PDBtoZ1.sh file.pdb`
Converts file.pdb to file0001.z1, file0002.z1, ... file000n.z1, where n is the number of frames/models in PDB file. PDB files with single frames are also created (file0001.pdb etc).

`./PDBtoZ1.sh file.pdb 3`
Converts file.pdb to file0001.z1, file0004.z1... where the 2nd optional argument is the interval between frames to be converted (the interval set to m means that every mth frame will be converted).

`./Z1toPDB.sh coords_sp_full_plus_beadinfo_and_entanglements`
Converts coords_sp_full_plus_beadinfo_and_entanglements (result of Z1 algorithm) into coords_sp_full_plus_beadinfo_and_entanglements.pdb, where entanglement points (or 0 for no entanglement) are saved in the "occupancy" column of the PDB file.
