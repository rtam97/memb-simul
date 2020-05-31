#!/bin/bash

: '
ststr="../../../starting-structures/*.pdb"
for ss in $ststr; do
  echo $ss
  pnm=${ss:29:(-4)}
  dir="./topologies/$pnm"
  mkdir $dir
  printf ' '1 \n 3 \n' '| gmx pdb2gmx -f $ss -p "topol_$pnm.top" -ignh

  mv *.itp $dir

  orig=' '\"top''
  rep="\"$dir/top"

  sed -i "s|$orig|$rep|g" "topol_$pnm.top"
done


#printf ''1 \n 3 \n'' | gmx pdb2gmx -f hexamer.pdb -p topol.top -ignh

#printf ''1 \n 3 \n'' | gmx pdb2gmx -f dimer.pdb -p topol2.top -ignh

#printf ''1 \n 3 \n'' | gmx pdb2gmx -f protomer.pdb -p topol3.top -ignh

#printf ''1 | 13 \n q \n'' | gmx make_ndx -f final.gro -o nowater.ndx

#printf ''15 \n' '| gmx trjconv -s final.tpr -f final.xtc -pbc whole -o ./frames/esx1-hexamer_.gro -sep -n nowater.ndx
'

date

gros="./frames/*.gro"
count=1
out="./bmap/membrane-500_$count.gro"
pdb="./pdb/membrane-500_$count.pdb"

dothings () {
  local in=$1

  B="./backward.py -f $in -o $out -kick 0.05 -sol -p topol.top -from martini -to charmm36"
  echo $B; $B || exit

  gmx editconf -f $out -o $pdb

  echo "written PDB #$count"
}

for i in $gros; do
  echo $count

  dothings "$i" &

  count=$((count+1))
  out="./bmap/membrane-500_$count.gro"
  pdb="./pdb/membrane-500_$count.pdb"

  if (( $count % 30 == 0 )); then wait; fi
done

exit 0
