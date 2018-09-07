#!/bin/bash
if [ $# -lt 1 ] 
then
	echo "Z1toPDB: no file specified"
	exit
fi
echo -n "number of chains in structure $1: "
head -1 $1
title="${1}.pdb"
awk 'BEGIN {split("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", A, "")} {if(NR>2){{if(NF==1){if(c){j=j+1;printf("TER  %6d  CA  GLY %1s %5d\n",j,A[c],i)};i=0;c=c+1}else{i=i+1;j=j+1; printf("%4s %6d  %3s %3s %1s %3d %11.3f%8.3f%8.3f%6.2f\n","ATOM",j,"CA ","GLY",A[c],i,$1,$2,$3,$5)}}}else{if(NF==3){printf("CRYST1%9.3f%9.3f%9.3f  90.00  90.00  90.00 P 1           1\n",$1,$2,$3)}}}' $1 > $title
