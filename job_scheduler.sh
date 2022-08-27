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
snakemake /project/thrash_89/db/EAGER_metaG_for_ck/pipeline_assemblies/ARD_V9_S7_assembly_dir/checkm/dastools/output_table.txt --profile .config/slurm/