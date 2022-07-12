#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --time=0:20:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=50GB
#SBATCH --partition=epyc-64

module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/checkm

sample=CJ_V2_S8

bins=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/K99/maxbin2/
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/checkm/K99/maxbin2
#checkm lineage_wf -x fasta -t 16 ${bins} ${out_dir} -f ${out_dir}/output_table.txt

bins=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/concoct_subcontigs/fasta_bins/
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/checkm/concoct
checkm lineage_wf -x fa -t 16 ${bins} ${out_dir} -f ${out_dir}/output_table.txt

bins=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/metabat2
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/checkm/metabat2
#checkm lineage_wf -x fa -t 16 ${bins} ${out_dir} -f ${out_dir}/output_table.txt

