#!/bin/bash

module load bowtie2
module load samtools

# index (EST time: about 31 minutes)
bowtie2-build /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/contigs.fasta /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1 --threads 6

# align reads
bowtie2 -x /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1 --interleaved /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_trimmed.fastq -S /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1.sam --threads 6

# convert sam file into sorted and indexed bam file
samtools view -bS -F 4 /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1.sam > /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_RAW.bam

samtools sort /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_RAW.bam > /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1.bam

samtools index -@ 6 /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1.bam

rm /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_RAW.bam /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1.sam
