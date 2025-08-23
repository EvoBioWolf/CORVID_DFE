#! /bin/bash
#SBATCH --clusters=biohpc_gen
#SBATCH --partition=biohpc_gen_normal
#SBATCH -t 01:00:00
#SBATCH --cpus-per-task=1

for i in $(ls *summary) ; do cp $i ${i}2 ; done ;

sed -ir "s/\t13,13\t-1/\t3\t-1/" *summary2
sed -ir "s/\t13\t-1/\t3\t-1/" *summary2
sed -ir "s/\t12,12\t-1/\t3\t-1/" *summary2
sed -ir "s/\t12\t-1/\t3\t-1/" *summary2
sed -ir "s/\t3,3\t-1/\t3\t-1/" *summary2
sed -ir "s/\t4,4\t-1/\t4\t-1/" *summary2

#Fringilla only
#for i in $(ls *summary | grep -e autosomes -e chr21 -e chr22 -e chr23 -e chr26 -e chr25 -e chr26 -e chr27 -e chr28) ; do 
#for i in $(ls *summary | grep chr27) ; do 
#cp $i ${i}2  ;
#sed -ir "s/\t13,13\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t13\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t12,12\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t12\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t3,3\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t4,4\t-1/\t4\t-1/" ${i}2 ;
#done ;

#Autosomes
#for i in $(ls *summary | grep autosomes) ; do cp $i ${i}2 ;
#sed -ir "s/\t13,13\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t13\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t12,12\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t12\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t3,3\t-1/\t3\t-1/" ${i}2 ;
#sed -ir "s/\t4,4\t-1/\t4\t-1/" ${i}2 ;
#done ;

rm *summary2r
