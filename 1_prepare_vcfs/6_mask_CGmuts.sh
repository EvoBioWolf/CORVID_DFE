#! /bin/bash

#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1


bcftools filter -e '(REF="A" & ALT="G") | (REF="T" & ALT="G") | (REF="A" & ALT="C") | (REF="T" & ALT="C") | (REF="A" & ALT="C" & AF=1.00) | (REF="A" & ALT="G" & AF=1.00) | (REF="T" & ALT="G" & AF=1.00) | (REF="T" & ALT="C" & AF=1.00)' -Oz $1 > CGmut_filter/$(basename $1 .vcf.gz)_CGmutFiltered.vcf.gz ;
cd CGmut_filter ;
tabix -p vcf $(basename $1 .vcf.gz)_CGmutFiltered.vcf.gz
bcftools stats $(basename $1 .vcf.gz)_CGmutFiltered.vcf.gz > $(basename $1 .vcf.gz)_CGmutFiltered.vcf.stats
