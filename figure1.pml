bg_color white

# 1. Load full structures

load 3s48_ref.pdb, ref
load final_280K.pdb, md280
load final_300K.pdb, md300
load final_320K.pdb, md320


# 2. Align WHOLE complexes to reference
align md280 and chain A+B and name CA, ref and chain A+D and name CA
align md300 and chain A+B and name CA, ref and chain A+D and name CA
align md320 and chain A+B and name CA, ref and chain A+D and name CA


# 3. Split chains after alignment
split_chains ref
split_chains md280
split_chains md300
split_chains md320


# 4. Global colour scheme
hide everything, all

# haemoglobin
color deepteal, ref_D or md280_B or md300_B or md320_B
# IsdH
color lightpink, ref_A or md280_A or md300_A or md320_A

show cartoon, ref_A or ref_D or md280_A or md280_B or md300_A or md300_B or md320_A or md320_B


# 5. Define panel selections
select panel_ref,  (ref_D and resi 11+74) or (ref_A and resi 130+151+152+182)
select panel_280,  (md280_B and resi 11) or (md280_A and resi 44+65+66)
select panel_300,  (md300_B and resi 7+11+74) or (md300_A and resi 43+93+96)
select panel_320,  (md320_B and resi 11+74) or (md320_A and resi 44+46+66)

show sticks, panel_ref or panel_280 or panel_300 or panel_320
util.cnc panel_ref
util.cnc panel_280
util.cnc panel_300
util.cnc panel_320


# 6. Representative contacts only
# Reference
distance ref_c1, (ref_D and resi 11 and name NZ), (ref_A and resi 152 and name OG1), 3.6
distance ref_c2, (ref_D and resi 74 and name OD2), (ref_A and resi 182 and name NE2), 4.0

# 280 K
distance k280_c1, (md280_B and resi 11 and name NZ), (md280_A and resi 44 and name OG), 3.6
distance k280_c2, (md280_B and resi 11 and name NZ), (md280_A and resi 66 and name OG1), 3.6

# 300 K
distance k300_c1, (md300_B and resi 11 and name NZ), (md300_A and resi 43 and name O), 3.6
distance k300_c2, (md300_B and resi 74 and name OD1+OD2), (md300_A and resi 96 and name NE2), 4.0

# 320 K
distance k320_c1, (md320_B and resi 11 and name NZ), (md320_A and resi 44 and name OG), 3.6
distance k320_c2, (md320_B and resi 74 and name OD1+OD2), (md320_A and resi 46 and name NZ), 4.0

color yellow, ref_c1
color orange, ref_c2
color yellow, k280_c1
color yellow, k280_c2
color yellow, k300_c1
color orange, k300_c2
color yellow, k320_c1
color orange, k320_c2

hide labels, ref_c1
hide labels, ref_c2
hide labels, k280_c1
hide labels, k280_c2
hide labels, k300_c1
hide labels, k300_c2
hide labels, k320_c1
hide labels, k320_c2


# 7. Set ONE common view using reference
disable all
enable ref_A or ref_D
hide everything, all
show cartoon, ref_A or ref_D
show sticks, panel_ref
util.cnc panel_ref
enable ref_c1
enable ref_c2


# 8. Export four panels with the SAME view
set_view (\
    -0.028616410,    0.713460624,   -0.700105846,\
     0.246842921,   -0.673659563,   -0.696599305,\
    -0.968627870,   -0.192750901,   -0.156837210,\
     0.000445265,   -0.000109447,  -72.683563232,\
    30.418245316,  -50.707862854,   37.595279694,\
    51.477912903,   93.933166504,   20.000000000 )

disable all
enable ref_A or ref_D
hide everything, all
show cartoon, ref_A or ref_D
show sticks, panel_ref
util.cnc panel_ref
label ref_D and resi 11 and name CA, "Lys11"
label ref_D and resi 74 and name CA, "Asp74"
label ref_A and resi 152 and name CA, "Thr152"
label ref_A and resi 182 and name CA, "His182"


disable all
enable md280_A or md280_B
hide everything, all
show cartoon, md280_A or md280_B
show sticks, panel_280
util.cnc panel_280
label md280_B and resi 11 and name CA, "Lys11"
label md280_A and resi 44 and name CA, "Ser44"
label md280_A and resi 66 and name CA, "Thr66"


disable all
enable md300_A or md300_B
hide everything, all
show cartoon, md300_A or md300_B
show sticks, panel_300
util.cnc panel_300
label md300_B and resi 11 and name CA, "Lys11"
label md300_B and resi 74 and name CA, "Asp74"
label md300_A and resi 43 and name CA, "Phe43"
label md300_A and resi 96 and name CA, "His96"


disable all
enable md320_A or md320_B
hide everything, all
show cartoon, md320_A or md320_B
show sticks, panel_320
util.cnc panel_320
label md320_B and resi 11 and name CA, "Lys11"
label md320_B and resi 74 and name CA, "Asp74"
label md320_A and resi 44 and name CA, "Ser44"
label md320_A and resi 46 and name CA, "Lys46"