#! /bin/bash
#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --get-user-env
scripts='/gpfs/scratch/uj502/di57ril/di57ril/scripts'
#Load modules or conda environment containing Perl apps from vcftools.
#chrom=$(basename $1 .vcf.gz | sed -e 's/.*_chr/chr/' -e 's/_renamed_sorted.*//')
#chrom=$(basename $1 .vcf.gz | sed -e 's/.*_chr/chr/' | cut -d '_' -f1) #filtered_inds
#chrom='autosomes'
module load slurm_setup
vcfintersect -v -b $2 $1 > ./CpG_filtered/$(basename $1 .vcf.gz)_CpGfiltered.vcf

cd CpG_filtered ;

#python2 ${scripts}/clean_mns.py $(basename $1 .vcf.gz)_CpGfiltered.vcf $chrom
#sort -V -k1,1 -k2,2n ${chrom}_toClean.bed > ${chrom}_toClean_sorted.bed


#bcftools view -t ^$(cat ${chrom}_toClean_sorted.bed | sed 's/\t/:/' | tr '\n' ',') $(basename $1 .vcf.gz)_CpGfiltered.vcf > $(basename $1 .vcf.gz)_CpG_MNP_filtered.vcf

#bgzip $(basename $1 .vcf.gz)_CpG_MNP_filtered.vcf
#tabix -p vcf $(basename $1 .vcf.gz)_CpG_MNP_filtered.vcf.gz
#bcftools stats $(basename $1 .vcf.gz)_CpG_MNP_filtered.vcf.gz > $(basename $1 .vcf.gz)_CpG_MNP_filtered.vcf.stats

bgzip $(basename $1 .vcf.gz)_CpGfiltered.vcf
tabix -p vcf $(basename $1 .vcf.gz)_CpGfiltered.vcf.gz
bcftools stats $(basename $1 .vcf.gz)_CpGfiltered.vcf.gz > $(basename $1 .vcf.gz)_CpGfiltered.vcf.stats
