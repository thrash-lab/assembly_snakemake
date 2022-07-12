#!/bin/bash
#SBATCH --time=2:30:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

# dastools
module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/das_tool

sample=CJ_V2_S8
metabat_fa_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/metabat2
maxbin_fa_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/maxbin2
concoct_fa_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/concoct_subcontigs

# activate dastool conda env

# metabat2 (10 seconds)
Fasta_to_Contig2Bin.sh -e fa -i ${metabat_fa_dir}/ > ${metabat_fa_dir}/my_contigs2bin.tsv

# maxbin
Fasta_to_Contig2Bin.sh -e fasta -i ${maxbin_fa_dir}/ > ${maxbin_fa_dir}/my_contigs2bin.tsv

# IMPORTANT
# concoct (delete first line "contig_id	concoct.cluster_id", use correct command
# depending on whether concoct was used with full or subcontigs. 
#perl -pe "s/,/\tconcoct./g;" ${sample}_clustering_gt1000.csv > concoct.contigs2bin.tsv
perl -pe "s/,/\tconcoct./g;" ${concoct_fa_dir}/concoct_subcontigs_clustering_merged.csv > ${concoct_fa_dir}/concoct.contigs2bin.tsv
sed -i '1,1d' ${concoct_fa_dir}/concoct.contigs2bin.tsv

# Run DAS_Tool (EST TIME < 2 hours per sample)
DAS_Tool -i ${maxbin_fa_dir}/my_contigs2bin.tsv,\
${concoct_fa_dir}/concoct.contigs2bin.tsv,\
${metabat_fa_dir}/my_contigs2bin.tsv \
-l maxbin,concoct,metabat \
-c /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/spades_assembly/contigs.fasta \
-o /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/dastools/${sample} --write_bins --write_bin_evals \
-t 32

