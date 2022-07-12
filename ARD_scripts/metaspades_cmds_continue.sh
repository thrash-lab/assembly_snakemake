#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=64
#SBATCH --mem=998GB
#SBATCH --partition=largemem

module load spades

output_dir=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/
file=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_trimmed.fastq

metaspades.py -o $output_dir --continue
