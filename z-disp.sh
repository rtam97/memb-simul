#!/bin/bash


proteins='./cg-structures/*.gro'


for p in $proteins; do

    name=${p:16:10}
    dir='./zdisp-tests/'$name''
    echo $p
    echo $dir
    mkdir $dir
    python ../martini/scripts/insane.py -f $p -l DPPC -l POPG -l POPE -t ./protein-topologies/ -pbc square -zd "./simulations/z-displacement.txt" -ring -center -p "$dir/system.top" -o "$dir/system.gro"  -sol W
    sed -i 's/.\//..\/..\//' $dir/system.top

done
