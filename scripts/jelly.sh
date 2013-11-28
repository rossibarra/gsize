#!/bin/zsh -l
#SBATCH -D /home/jri/projects/genomesize
#SBATCH -J st
#SBATCH -o out-%j.txt
#SBATCH -p serial
#SBATCH -e error-%j.txt


# script to run jellyfish on paul's files

echo "nicE!"

#/home/jri/pkg/bin/jellyfish


