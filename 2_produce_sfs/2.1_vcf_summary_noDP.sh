#! /bin/bash -l
#SBATCH --clusters=biohpc_gen	
#SBATCH --partition=biohpc_gen_normal
#SBATCH --cpus-per-task=1
#SBATCH -t 04:00:00
#####Usage: Run separately for each VCF file (start batch script in the respective directories within /proj/b2013182/nobackup/POPseq/sfs_dfe/Ccornix_v2.5)
### C. brachyrhynchos, C. dauuricus, C. monedula, C. corone (118 inds) (DFE species comparison), C. corone (16 inds) (alpha theory), C. corone (118 inds) subsampling, C. corone (118 inds) population comparisons
# for f in $(ls *.inds*.vcf.gz | sed 's/.gz//g' | uniq); do sbatch /proj/b2013182/nobackup/batch_scripts/Ccornix_ref/sfs_dfe/4.1B_vcf_summary_noDP.sh $f; done
dataset=`ls ${1}.vcf.gz | cut -d'_' -f1`
taxon=$2
scripts="/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/alpha/Final_Datasets/DFEalpha/scripts"
annDir="/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/Benoit/refs/${taxon}"
#annot=$(ls ${annDir}/*sites)
annot=$(ls ${annDir}/*annotated.sites) #Darwin finches
#annot=$(ls ${annDir}/*sorted.sitesV) #Fringilla
#annot=$(ls ${annDir}/new) #Zosterops

#Only for Fringilla
#chr=$(echo $1 | sed -e 's/.*_chr/chr/' -e 's/_.*//')
#echo $chr
#annot=$(ls ${annDir}/${chr}.sites)
#annot=$(ls ${annDir}/${chr}_scaff.sites) #chr18,21-28
#echo $annot

#Folded SFS for total sites
# get the data set name from the file name
#dataset=`ls ${1}.vcf.gz | cut -d'_' -f1`

#Generate a vcf summary using vcfSummarizer.py by Robert Williamson
module load python/2.7_intel
python ${scripts}/scripts_rwilliamson/vcfSummarizer.py ${1}.vcf.gz $annot -q 0 -d 0 -D 1000 -L 0 -N 0 > summary_files/${1}_noDP.vcf.summary

#cp *summary ${out}
