#! /bin/bash
#SBATCH --clusters=serial
#SBATCH --partition=serial_std
#SBATCH --cpus-per-task=2
#SBATCH --time=08:00:00


awk '$6 == "3" || $6 == "3,3"' ${1} > 0fold_sites.txt
awk '$6 == "12" || $6 == "12,12"' ${1} > 2fold_sites.txt
awk '$6 == "13" || $6 == "13,13"' ${1} > 3fold_sites.txt
awk '$6 == "4" || $6 == "4,4"' ${1} > 4fold_sites.txt

#Subtract 1 from site position to convert it to 0-based, sort the file
awk 'OFS="\t"{print $1, $2-1, $2}' 0fold_sites.txt | sort -k1,1V -k2,2n > 0fold_sites_perSite_sorted.bed
awk 'OFS="\t"{print $1, $2-1, $2}' 2fold_sites.txt | sort -k1,1V -k2,2n > 2fold_sites_perSite_sorted.bed
awk 'OFS="\t"{print $1, $2-1, $2}' 3fold_sites.txt | sort -k1,1V -k2,2n > 3fold_sites_perSite_sorted.bed
awk 'OFS="\t"{print $1, $2-1, $2}' 4fold_sites.txt | sort -k1,1V -k2,2n > 4fold_sites_perSite_sorted.bed
# Merge neighboring sites
bedtools merge -i 0fold_sites_perSite_sorted.bed > 0fold_sites.bed
bedtools merge -i 2fold_sites_perSite_sorted.bed > 2fold_sites.bed
bedtools merge -i 3fold_sites_perSite_sorted.bed > 3fold_sites.bed
bedtools merge -i 4fold_sites_perSite_sorted.bed > 4fold_sites.bed

sed -i '1i #CHROM\tSTART\tEND' *sites.bed
