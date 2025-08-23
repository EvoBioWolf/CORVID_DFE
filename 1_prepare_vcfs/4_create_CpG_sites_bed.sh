#! /bin/bash -l
#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH --cpus-per-task=2
#SBATCH --time=1-00:00:00

#####Usage: Run separately for each VCF file (directories: /proj/b2013182/private/POPseq/vcf/Ccornix_v2.5)
###C. brachyrhynchos, C. dauuricus, C. monedula
# for f in $(ls *vcf.gz | sed 's/_gatkHC_allSites_vqsr99.vcf.gz//g' | uniq); do sbatch /proj/b2013182/nobackup/batch_scripts/Ccornix_ref/sfs_dfe/2.5.1_polymorphic_CpG_sites_bed_Cbrach_Cdau_Cmon.sh $f; done

# Directories
script="/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/alpha/Final_Datasets/scripts"
out="./chromosomes/CpG_filtered"

# Find the positions of CpG, CpA and TpG sites, incl CpG/CpA and TpG/CpG polymorphisms within the resequencing data. Requires all sites VCF file, because sites not adjacent to each other will be ignored
module load python/2.7_intel

python ${script}/findCpGpolymorphism.py ${1} $(basename ${1} .vcf.gz)_CpG_pol.bed

bedtools merge -i $(basename ${1} .vcf.gz)_CpG_pol.bed > $(basename ${1} .vcf.gz)_CpG_pol_merged.bed

tar czf $(basename ${1} .vcf.gz)_CpG_pol.bed.tar.gz $(basename ${1} .vcf.gz)_CpG_pol.bed
