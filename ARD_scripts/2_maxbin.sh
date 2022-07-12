#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --time=3:30:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64


#https://denbi-metagenomics-workshop.readthedocs.io/_/downloads/en/latest/pdf/
sample=ARD_V2_S1
bam_dir=/project/thrash_89/db/EAGER_metaG_for_ck/mapping_contigs/qual_trim_after_interleaving/bam/
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/maxbin/ARD_V2_S1_test
contig_dir=/project/thrash_89/db/EAGER_metaG_for_ck/contigs/qual_trim_after_interleaving/ARD_V2_S1/


#REMINDERS

module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/maxbin2

#activate maxbin2 conda env EST TIME (2 hr, 45 min accurate)
run_MaxBin.pl -contig /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/contigs.fasta -reads /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_trimmed.fastq -thread 32 -out /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/K99/maxbin2/maxbin



