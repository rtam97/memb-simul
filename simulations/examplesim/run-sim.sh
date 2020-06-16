#!/bin/bash

do_minimization () {

  GMX_MAXCONSTRWARN=-1

  gmx grompp -f ../minimization.mdp -c "minim$(($count - 1)).gro" -p system.top -o "minim$count.tpr"

  gmx mdrun -deffnm "minim$count" -v

  rm step*
}

GMX_MAXCONSTRWARN=-1


gmx grompp -f ../minimization.mdp -c system.gro -p system.top -o minim0.tpr
gmx mdrun -deffnm minim0 -v
rm step*

minimized="false"
count=1
while [[ $minimized = "false" ]]; do

  GMX_MAXCONSTRWARN=-1

  gmx grompp -f ../equilibration.mdp -c "minim$(($count - 1)).gro" -p system.top -o "eq.tpr"
  gmx mdrun -deffnm "eq" -v -g out.log

  err=$(grep "Fatal error" out.log | wc -l)

  if [[ $err -ne 0 ]]; then
    minimized="true"
  else
    rm eq*
    echo "Failed equilibration, running a new minimization step."
    do_minimization $count
    count=$(( $count + 1 ))
  fi
done

GMX_MAXCONSTRWARN=-1

gmx grompp -f ../production.mdp -c eq.gro -p system.top -o "final.tpr"
gmx mdrun -deffnm final -v
