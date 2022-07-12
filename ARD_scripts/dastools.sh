#!/bin/bash

sample=ARD_V2_S1
# activate dastool conda env

# metabat2 (10 seconds)
Fasta_to_Contig2Bin.sh -e fa -i ./ > my_contigs2bin.tsv

# maxbin
Fasta_to_Contig2Bin.sh -e fasta -i ./ > my_contigs2bin.tsv

# IMPORTANT
# concoct (delete first line "contig_id	concoct.cluster_id", use correct command
# depending on whether concoct was used with full or subcontigs. 
perl -pe "s/,/\tconcoct./g;" ${sample}_clustering_gt1000.csv > concoct.contigs2bin.tsv
perl -pe "s/,/\tconcoct./g;" concoct_subcontigs_clustering_merged.csv > concoct.contigs2bin.tsv

## Run DAS_Tool
DAS_Tool -i /project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/maxbin/ARD_V2_S1_test/my_contigs2bin.tsv,\
/project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/concoct/whole_contig_bins/ARD_V2_S1_test/concoct.contigs2bin.tsv,\
/project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/metabat2/ARD_V2_S1_test/my_contigs2bin.tsv \
-l maxbin,concoct,metabat \
-c /project/thrash_89/db/EAGER_metaG_for_ck/contigs/qual_trim_after_interleaving/ARD_V2_S1/contigs.fasta \
-o /project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/dastool/ARD_V2_S1_test/ARD_V2_S1 --write_bins --write_bin_evals

# round 2
DAS_Tool -i /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/maxbin2/my_contigs2bin.tsv,\
/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/concoct_subcontigs/concoct.contigs2bin.tsv,\
/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/metabat2/my_contigs2bin.tsv \
-l maxbin,concoct,metabat \
-c /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/contigs.fasta \
-o /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/binning/dastools/ARD_V2_S1 --write_bins --write_bin_evals
