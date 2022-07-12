#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

module load bowtie2
module load samtools

bowtie2-build /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/contigs_2kbp.fasta /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k --threads 32

# align reads
bowtie2 -x /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k --interleaved /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_trimmed.fastq -S /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k.sam --threads 32

# convert sam file into sorted and indexed bam file
samtools view -bS /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k.sam --threads 32 > /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k_RAW.bam

samtools sort /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k_RAW.bam --threads 32 > /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k.bam

samtools index -@ 32 /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k.bam

rm /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k_RAW.bam /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/read_mapping/ARD_V2_S1_2k.sam

