#!/bin/bash -l
#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH --cpus-per-task=2
#SBATCH -t 3:00:00
#SBATCH --get-user-env
#####Usage: start in each directory containing SFS

#Path to folder containing DFEalpha executables
software='/dss/dsshome1/lxc08/di57ril/software/DFEalpha_2.16'

#Set to folder containing the configuration files
scripts='/dss/dsslegfs01/pr53da/pr53da-dss-0018/projects/2017__DFErecomb/alpha/Final_Datasets/DFEalpha/scripts'

for f in $(ls 0fold_real.sfs | grep 0fold | sed 's/.sfs//g'); do
mkdir ${f}_2e
cp ${f}.sfs ${f}_2e/sfs_malformatted.txt
cd ${f}_2e
sed '1,3c 1' sfs_malformatted.txt > sfs.txt
${software}/est_dfe -c ${scripts}/1_est_dfe_2e-site_class-0_config.txt
${software}/est_dfe -c ${scripts}/2_est_dfe_2e-site_class-1_config.txt
cd est_dfe_results_sel
${software}/prop_muts_in_s_ranges -c est_dfe.out -o prop_muts_in_s_ranges.out

cd ../.. ;

done ;
