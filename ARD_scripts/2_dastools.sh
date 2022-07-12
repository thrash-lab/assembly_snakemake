#!/bin/bash
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

# dastools
module purge
eval "$(conda shell.bash hook)"
conda activate /home1/cykojima/.conda/envs/das_tool
# activate dastool conda env

# metabat2 (10 seconds)
#Fasta_to_Contig2Bin.sh -e fa -i ./ > my_contigs2bin.tsv

# maxbin
#Fasta_to_Contig2Bin.sh -e fasta -i ./ > my_contigs2bin.tsv

# IMPORTANT
# concoct (delete first line "contig_id	concoct.cluster_id", use correct command
# depending on whether concoct was used with full or subcontigs. 
#perl -pe "s/,/\tconcoct./g;" ${sample}_clustering_gt1000.csv > concoct.contigs2bin.tsv
#perl -pe "s/,/\tconcoct./g;" concoct_subcontigs_clustering_merged.csv > concoct.contigs2bin.tsv

## Run DAS_Tool (EST TIME < 2 hours per sample )
DAS_Tool -i /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/maxbin2/my_contigs2bin.tsv,\
/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/concoct_subcontigs/concoct.contigs2bin.tsv,\
/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/metabat2/my_contigs2bin.tsv \
-l maxbin,concoct,metabat \
-c /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/contigs.fasta \
-o /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/dastools/ARD_V2_S1 --write_bins --write_bin_evals
