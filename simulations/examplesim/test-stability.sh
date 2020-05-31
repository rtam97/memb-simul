#!/bin/bash

gmx grompp -f ../minimization.mdp -p system.top -c system.gro -o test.tpr

gmx mdrun -deffnm test -v


