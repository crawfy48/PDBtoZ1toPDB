#!/bin/bash
#do # ^ means start of line
if [ $# -lt 1 ] # first argument is the PDB filename
then
	echo "PDBtoZ1 cannot proceed: no PDB file specified."
	exit
fi
interval=1
if [ $# -gt 1 ] # second (optional) argument is the interval between the frames that should be converted
then
	interval=$2
fi
n=`grep "END" $1|wc -l` # total number of frames
echo "Number of frames in structure $1: ${n}. 1 out of every ${interval} frames will be converted."
title=`echo $1|awk -F".pdb" '{print $1}'`
for ((t=1; t<=$n; t++ ))
do
	if [[ $(((t-1)%interval)) -eq 0 ]]
	then
		echo ${t}/$n
		printf -v time "%04d" $t
		frame="${title}${time}.pdb" # program saves selected frames to separate files
		framez="${title}${time}.z1" # converted files have differ	ent extension
		awk 'BEGIN {c=1} {if(c=='$t'){print};if(substr($0,1,3)=="END") {c=c+1}}' $1 > $frame # each frame must end by "END" or "ENDMDL" tag
		awk '$1=="TER"' $frame|wc -l > $framez # chains must be separated by the "TER" tag
		if grep -q "CRYST1" $frame
		then # if each frame has separate CRYST1 entry, it will be used in the converted file
			awk '$1=="CRYST1"' $frame|awk '{print $2,$3,$4}' >> $framez
		else # otherwise the first CRYST1 entry from the original file will be used
			awk '$1=="CRYST1"' $1|head -1|awk '{print $2,$3,$4}' >> $framez
		fi # residues in the 6th column do not have to start from 1, but there should be no breaks and CA atoms should be present
		awk '$1=="ATOM" && $3=="CA" {if(!firstindex){firstindex=$6};if($6<lastindex){printf (lastindex-firstindex+1)" ";firstindex=$6};lastindex=$6} END {print (lastindex-firstindex+1)}' $frame >> $framez
		awk '$1=="ATOM" && $3=="CA" {print substr($0,31,8),substr($0,39,8),substr($0,47,8)}' $frame >> $framez
	fi
done
