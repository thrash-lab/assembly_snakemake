#!/bin/bash


#SBATCH --ntasks=1
#SBATCH --time=15:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

# arg 1 is base dir that holds the assemblies
# arg 2 is bam dir
# arg 3 is output dir

#e.g.
#1 /project/thrash_89/db/EAGER_metaG_for_ck/contigs/qual_trim_after_interleaving/
#2 /project/thrash_89/db/EAGER_metaG_for_ck/mapping_contigs/qual_trim_after_interleaving/bam
#3 /project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/concoct/subcontig_bins/

module purge
module load anaconda3
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/concoct_2

## NOTE: Make sure Bam.bai file is present!!! will not run to completion otherwise
sample=ARD_V2_S1
sample_dir=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/concoct_subcontigs
dir=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly

# first command (est time: 2 min)
cut_up_fasta.py ${dir}/contigs.fasta -c 10000 -o 0 --merge_last -b ${sample_dir}/contigs_10K.bed > ${sample_dir}/contigs_10K.fa
# second command bam file not found (make sure BAM index file is here) EST TIME: 4 hours
concoct_coverage_table.py ${sample_dir}/contigs_10K.bed /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_mapped_unmapped.bam > ${sample_dir}/coverage_table.csv

concoct --composition_file ${sample_dir}/contigs_10K.fa --coverage_file ${sample_dir}/coverage_table.csv -b ${sample_dir}/concoct_subcontigs --threads 16

merge_cutup_clustering.py ${sample_dir}/clustering_gt1000.csv > ${sample_dir}/clustering_merged.csv
mkdir /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/concoct_subcontigs/fasta_bins
extract_fasta_bins.py ${dir}/contigs.fasta ${sample_dir}/clustering_merged.csv --output_path /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/concoct_subcontigs/fasta_bins
