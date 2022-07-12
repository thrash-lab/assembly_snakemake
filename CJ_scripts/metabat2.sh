#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

#activate metabat2 conda env
module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/metabat2

# roughly thirty minutes to run (overestimate)
sample=CJ_V2_S8
dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping
jgi_summarize_bam_contig_depths --outputDepth ${dir}/${sample}_depth.txt --pairedContigs ${dir}/${sample}_paired.txt ${dir}/${sample}.bam

# time estimate (less than seven minutes)
metabat2 -i /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/spades_assembly/contigs.fasta  -a /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}_depth.txt -o /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/metabat2/metabat2 -t 16 --minCVSum 0 --saveCls -d -v --minCV 0.1 -m 2000
