#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=125GB
#SBATCH --partition=epyc-64

module load bowtie2
module load samtools

sample=CJ_V2_S8

bowtie2-build /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/spades_assembly/contigs.fasta /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample} --threads 32

# align reads
bowtie2 -x /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample} --interleaved /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/sickle_trimmed/${sample}_all_trimmed.fastq -S /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}.sam --threads 32

# convert sam file into sorted and indexed bam file
samtools view -bS /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}.sam --threads 32 > /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}_RAW.bam

samtools sort /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}_RAW.bam --threads 32 > /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}.bam

samtools index -@ 32 /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}.bam

rm /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}_RAW.bam /project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/read_mapping/${sample}.sam

