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
dir=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping
base=ARD_V2_S1
jgi_summarize_bam_contig_depths --outputDepth ${dir}/${base}_depth.txt --pairedContigs ${dir}/${base}_paired.txt ${dir}/${base}.bam

# time estimate (less than seven minutes)
metabat2 -i /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/contigs_2kbp.fasta  -a /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/${base}_depth.txt -o /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/K99/metabat2/metabat2 -t 16 --minCVSum 0 --saveCls -d -v --minCV 0.1 -m 2000
