#!/bin/bash


#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

module purge
module load anaconda3
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/concoct_2

## NOTE: Make sure Bam.bai file is present!!! will not run to completion otherwise
sample=CJ_V2_S8
sample_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/concoct_subcontigs
dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/spades_assembly

# first command (est time: 2 min)
cut_up_fasta.py ${dir}/contigs.fasta -c 10000 -o 0 --merge_last -b ${sample_dir}/contigs_10K.bed > ${sample_dir}/contigs_10K.fa
# second command bam file not found (make sure BAM index file is here) EST TIME: 4 hours
concoct_coverage_table.py ${sample_dir}/contigs_10K.bed /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}.bam > ${sample_dir}/coverage_table.csv

# about 12 hours (overestimate) with 16 threads
concoct --composition_file ${sample_dir}/contigs_10K.fa --coverage_file ${sample_dir}/coverage_table.csv -b ${sample_dir}/concoct_subcontigs --threads 16

merge_cutup_clustering.py ${sample_dir}/concoct_subcontigs_clustering_gt1000.csv > ${sample_dir}/concoct_subcontigs_clustering_merged.csv
mkdir ${sample_dir}/fasta_bins
extract_fasta_bins.py ${dir}/contigs.fasta ${sample_dir}/concoct_subcontigs_clustering_merged.csv --output_path ${sample_dir}/fasta_bins
