#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --time=0:25:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=50GB
#SBATCH --partition=epyc-64

module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/checkm

sample=CJ_V2_S8
bins=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/dastools/${sample}_DASTool_bins
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/checkm/dastools

checkm lineage_wf -x fa -t 16 ${bins} ${out_dir} -f ${out_dir}/output_table.txt
