#!/bin/bash

#https://denbi-metagenomics-workshop.readthedocs.io/_/downloads/en/latest/pdf/
sample=ARD_V2_S1
bam_dir=/project/thrash_89/db/EAGER_metaG_for_ck/mapping_contigs/qual_trim_after_interleaving/bam/
out_dir=/project/thrash_89/db/EAGER_metaG_for_ck/bins/sickle/maxbin/ARD_V2_S1_test
contig_dir=/project/thrash_89/db/EAGER_metaG_for_ck/contigs/qual_trim_after_interleaving/ARD_V2_S1/

#REMINDERS
# add threads argument to commands

# activate bbmap conda env
pileup.sh in=${bam_dir}/${sample}.bam out=${out_dir}/cov.txt

# awk command takes the first and five (contig #ID and covered_percent) for each row or contig
# grep command filters out any header lines
awk '{print $1"\t"$5}' ${out_dir}/cov.txt | grep -v '^#' > ${out_dir}/abundance.txt

#activate maxbin2 conda env
run_MaxBin.pl -contig ${contig_dir}/contigs.fasta -abund ${out_dir}/abundance.txt -run_MaxBin.pl -thread 1 -out ${out_dir}/${sample}

# works verificiation

