#!/bin/bash

do_minimization () {
  gmx grompp -f ../minimization.mdp -c system.gro -p system.top -o "minim$count.tpr"

  gmx mdrun -deffnm "minim$count" -v

  rm step*
}

GMX_MAXCONSTRWARN=-1

minimized="false"
count=0
while [[ $minimized = "false" ]]; do

  count=$(( $count + 1 ))

  do_minimization $count

  {
    gmx grompp -f ../equilibration.mdp -c system.gro -p system.top -o "eq.tpr"
    gmx mdrun -deffnm "eq" -v
    minimized="true"
    rm step* 
} || {
    echo "Failed equilibration, running a new minimization step."
  }

done


gmx grompp -f ../production.mdp -c system.gro -p system.top -o "final.tpr"
gmx mdrun -deffnm "final" -v

rm step*
