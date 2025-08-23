#!/bin/bash -l
#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH --cpus-per-task=1
#SBATCH -t 8:00:00

scripts='/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/alpha/Final_Datasets/DFEalpha/scripts/scripts_rwilliamson'
ref=$(ls *fna)
out='.'

module load python/2.7_intel

python ${scripts}/NewAnnotateRef.py ${ref} $(ls *gff) | awk '$6 == "3" || $6 =="4" || $6 == "12" || $6 == "13" || $6 == "3,3" || $6 == "4,4" || $6 == "12,12" || $6 == "13,13"' | sort -k1,1V > ${out}/$(basename $ref .fna)_0234fold_annotated_sorted.sites 
#> ${out}/$(basename $ref .fna)_0234fold_annotated.sites

