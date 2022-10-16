#!/bin/bash 

#SBATCH --ntasks=1
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

# activate snakemake
module purge
module load anaconda3
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/snakemake

# go to a particular directory
cd /project/thrash_89/db/EAGER_metaG_for_ck/scripts/assembly_snakemake/

# make things fail on errors
set -o nounset
set -o errexit
set -x

### run your commands here!
snakemake /project/thrash_89/db/EAGER_metaG_for_ck/pipeline_assemblies/CJ_V4_S10_assembly_dir/checkm/dastools/output_table.txt --profile .config/slurm/

# ARDs done, 
# ARD_V2_S1*  ARD_V7_S5*   CJ_V2_S8*   CJ_V7_S12    LKB_V4_S16  LKB_V8_S20    Tbon_V5_S24  Undetermined_S0
# ARD_V3_S2*  ARD_V8_S6*   CJ_V3_S9*   CJ_V8_S13    LKB_V5_S17  Tbon_V10_S28  Tbon_V6_S25
# ARD_V5_S3*  ARD_V9_S7*   CJ_V4_S10  LKB_V10_S21  LKB_V6_S18  Tbon_V2_S22   Tbon_V7_S26
# ARD_V6_S4*  CJ_V10_S14*  CJ_V5_S11  LKB_V2_S15   LKB_V7_S19  Tbon_V4_S23   Tbon_V8_S27

