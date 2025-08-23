#! /bin/bash -l
#SBATCH --clusters=serial
#SBATCH --partition=serial_std
#SBATCH --cpus-per-task=4
#SBATCH -t 1-00:00

#USAGE: vcfs_genes.sh <VCF> <LIST OF GENES>
#conda init bash
#conda activate variants

vcf="."
bedFiles="/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/Benoit/refs/$3"

#Produce a vcf for each site type (0,2,3 or 4fold)
tabix -R ${bedFiles}/$1 -h $2 > $(basename $2 .vcf.gz)_$(basename $1 .bed).vcf
bcftools filter -i '(TYPE="snp" | TYPE="ref") & ALT!="*" & QUAL!="." & QUAL>20' $(basename $2 .vcf.gz)_$(basename $1 .bed).vcf | # $(basename $2 .vcf.gz)_$(basename $1 .bed)_snps.vcf
bcftools filter -e 'TYPE="indel" | TYPE="other" | TYPE="bnd" | TYPE="mnp" | FILTER="lowQ"' | #$(basename $2 .vcf.gz)_$(basename $1 .bed).vcf  |
bcftools sort  > $(basename $2 .vcf.gz)_$(basename $1 .bed)_snps_Q20_noIndels.vcf.gz

for i in *snps_Q20_noIndels.vcf.gz ; do
#bgzip $i
tabix -p vcf ${i} #.gz
bcftools stats ${i} > $(basename ${i} .gz).stats ; done ;

bcftools stats $(basename $2 .vcf.gz)_$(basename $1 .bed).vcf > $(basename $2 .vcf.gz)_$(basename $1 .bed).vcf.stats
#bcftools stats $(basename $2 .vcf.gz)_$(basename $1 .bed)_snps.vcf > $(basename $2 .vcf.gz)_$(basename $1 .bed)_snps.vcf.stats
