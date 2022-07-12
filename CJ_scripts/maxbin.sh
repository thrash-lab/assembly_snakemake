#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --time=6:30:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64


#https://denbi-metagenomics-workshop.readthedocs.io/_/downloads/en/latest/pdf/
sample=CJ_V2_S8
bam_dir=/project/thrash_89/db/EAGER_metaG_for_ck/mapping_contigs/qual_trim_after_interleaving/bam/
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/maxbin/${sample}_test
contig_dir=/project/thrash_89/db/EAGER_metaG_for_ck/contigs/qual_trim_after_interleaving/${sample}/


#REMINDERS

module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/maxbin2

#activate maxbin2 conda env EST TIME (2 hr, 45 min accurate)
run_MaxBin.pl -contig /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/spades_assembly/contigs.fasta -reads /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/sickle_trimmed/${sample}_all_trimmed.fastq -thread 32 -out /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/maxbin2/maxbin



