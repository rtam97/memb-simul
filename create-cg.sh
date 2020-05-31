#!/bin/bash

pdb='./starting-structures/*.pdb'
dssp='./starting-structures/*.dssp'

for p in $pdb; do
	name=${p:22:(-4)}

	python ./scripts/martinize.py -ff martini22 -f $p -ss './starting-structures/'$name'.dssp' -x './cg-structures/'$name'_cg.pdb' -o $name'.top' -name  $name -sep

	gmx editconf -f './cg-structures/'$name'_cg.pdb' -o './cg-structures/'$name'.gro' -d 1.5


done
