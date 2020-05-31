#!/bin/bash
# Initialize simulation with lipid bilayer and the specified T7SSs
#   plus additional proteins (randomized)

# ------------------ INPUTS ---------------
# 1)      Name of simulation (will create a folder in 'simulations' with said name)
# 2,3,4)  box dimensions [X, Y, Z]
# 5,6,7)  Number of T7SSs [hexamer, dimer, protomer]
# 8)      Number of extra proteins

name=$1
x=$2
y=$3
z=$4
h=$5
d=$6
p=$7
extra=$8

dir='./simulations/'$name''

mkdir $dir
cp ./scripts/test-stability.sh $dir
cp ./scripts/run-sim.sh $dir

mkdir $dir/backmap
cp -rf ./bmap-source/* $dir/backmap


additional='./cg-structures/*.gro'
declare -a add
declare -a t7ss
for a in $additional; do
  fn=${a##*/}
  if [[ ${fn:(-6):6} != *"er.gro"* ]];then
    add=("${add[@]}" "$a")
  else
    t7ss=("${t7ss[@]}" "$a")
  fi
done

ln=${#add[@]}


t7in="-f ./cg-structures/esx1_hexamer.gro:$h -f ./cg-structures/esx1_dimer.gro:$d -f ./cg-structures/esx1_protomer.gro:$p"
extrain=""
for e in $(seq 1 $extra); do
  pick=$(( RANDOM % $ln  ))
  extrain="${extrain}-f ${add[$pick]}:1 "
done



python ./scripts/insane.py $t7in $extrain -l POPG -l POPE -t ./protein-topologies/ -pbc square -x $x -y $y -z $z -zd "./simulations/z-displacement.txt" -ring -center -p "$dir/system.top" -o "$dir/system.gro"  -sol W

sed -i 's/.\//..\/..\//' $dir/system.top
