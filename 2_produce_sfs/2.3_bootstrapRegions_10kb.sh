#! /bin/bash -l
#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH --cpus-per-task=1
#SBATCH -t 1:00:00


#####Usage: Run separately for each summary file (start batch script in the respective directories within /proj/b2013182/nobackup/POPseq/sfs_dfe/Ccornix_v2.5)
### C. brachyrhynchos, C. dauuricus, C. monedula, C. corone (118 inds) (DFE species comparison), max. number of inds
# for f in $(ls *noDP.vcf.summary | sed 's/.vcf.summary//g' | uniq); do sbatch /proj/b2013182/nobackup/batch_scripts/Ccornix_ref/sfs_dfe/4.2_bootstrapRegions_50kb.sh $f; done
#out='/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/vcfs_vqsr99/allSites_pass/rc_masked/test3/CpG_masked/merged'
#out='/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/vcfs_vqsr99/allSites_pass/rc_masked/test3/CpG_masked/merged'
#out='/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/vcfs_vqsr99/allSites_pass/rc_masked/test3/CpG_masked/merged'
species=$(echo $1 | cut -d'_' -f2)
#out="/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/vcfs_vqsr99/allSites_pass/rc_masked/test3/CpG_masked/merged/no_indels/per_chromosome/${species}"
#out="/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/vcfs_vqsr99/allSites_pass/rc_masked/test3/CpG_masked/merged/no_indels/per_chromosome/gc_groups/${species}"
out='.'
scripts='/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/alpha/Final_Datasets/DFEalpha/scripts'
file=${1}
partition=$(echo $file | sed -e 's/.*_chr/chr/' -e 's/_noDP.*//') 
#partition='autosomes'
inds=$2

#`echo ${file} | cut -d'.' -f3`
(( i = $inds ))
(( chr = i * 2 ))

#dataset=`echo ${file} | cut -d'_' -f1 | sed 's/.recode//'`
mkdir ${out}/${species}_${partition}_${inds}.inds_10kb

#module load /lrz/sys/share/modules/files_sles15/tools/python/2.7_intel
#python ${scripts}/scripts_rwilliamson/bootstrapRegions.py ${file}.vcf.summary -b 200 -N ${chr} -w 10000 -s 4,3 > ${out}/${dataset}_${partition}_${inds}.inds_10kb/${file}_10kb.200bt.sfs
python ${scripts}/scripts_rwilliamson/bootstrapRegions.py ${file}.vcf.summary2 -b 200 -N ${chr} -w 10000 -s 4,3 > ${out}/${species}_${partition}_${inds}.inds_10kb/${file}_10kb.200bt.sfs
#split the allele frequency output file incl. bootstrap replicates from Robert Williamson's pipeline into multiple files, one per afs, and move them into a new directory
cd ${out}/${species}_${partition}_${inds}.inds_10kb
awk -v RS="" '{print $0 > $1".sfs"}' ${file}_10kb.200bt.sfs

