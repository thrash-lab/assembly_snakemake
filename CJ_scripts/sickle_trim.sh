#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

# took about thirteen minutes (overestimate) to trim one sample
# untrimmed: 95171524
# trimmed  : 
#FastQ paired records kept: 94693966 (47346983 pairs)
#FastQ single records kept: 236266
#FastQ paired records discarded: 5026 (2513 pairs)
#FastQ single records discarded: 236266
module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/sickle

sample=CJ_V2_S8

sickle pe -c /project/thrash_89/db/EAGER_metaG_for_ck/interleaved_metaG/qual_trim_after_interleaving/brett_cat/${sample}_all.fastq -t sanger -m /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/sickle_trimmed/${sample}_all_trimmed.fastq -s /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/sickle_trimmed/${sample}_all_singles.fastq
