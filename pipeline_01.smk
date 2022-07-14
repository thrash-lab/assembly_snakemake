import snakemake
import numpy
import os

#TODO
# slurm
# configuration file
#http://bluegenes.github.io/Using-Snakemake_Profiles/
#https://github.com/Snakemake-Profiles/slurm
#https://snakemake.readthedocs.io/en/stable/snakefiles/best_practices.html?highlight=set-resources#best-practices
# https://bluegenes.github.io/snakemake-via-slurm/

SAMPLES=['CJ_V1_S8']
fastq_dir='/project/thrash_89/db/EAGER_metaG_for_ck/interleaved_metaG/qual_trim_after_interleaving/brett_cat'
base_dir='/project/thrash_89/db/EAGER_metaG_for_ck/pipeline_assemblies'

#TODO rule all
#TODO conda yaml for each rule
rule all:
    input: 
        #dir= base_dir + "/{sample}_assembly_dir/checkm/dastools/",
        checkm_table= base_dir + "/{sample}_assembly_dir/checkm/dastools/output_table.txt"

rule sickle_trim:
    input:
        fastq = fastq_dir + '/{sample}_all.fastq'
    output:
        singles=base_dir + '/{sample}_assembly_dir/sickle_trimmed/{sample}_all_singles.fastq',
        trimmed=base_dir + '/{sample}_assembly_dir/sickle_trimmed/{sample}_all_trimmed.fastq'
    conda: "envs/sickle.yml"
    shell:
        "sickle pe -c {input.fastq} -t sanger -m {output.trimmed} -s {output.singles}"

rule metaspades_assembly:
    input:
        trimmed_fq=base_dir + '/{sample}_assembly_dir/sickle_trimmed/{sample}_all_trimmed.fastq'
    output:
        dir=directory(base_dir + '/{sample}_assembly_dir/spades_assembly/'),
        contigs=base_dir + '/{sample}_assembly_dir/spades_assembly/contigs.fasta'
    conda: "envs/spades.yml"
    threads: 64
    shell:
        "metaspades.py --12 {input} -o {output} --memory 998 -t {threads}"


rule bowtie2_map_reads:
    input:
        trimmed_fq = base_dir + '/{sample}_assembly_dir/sickle_trimmed/{sample}_all_trimmed.fastq',
        contigs = base_dir + '/{sample}_assembly_dir/spades_assembly/contigs.fasta'
    output:
        bam = base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.bam',
        bam_index = base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.bam.bai',
        index = base_dir + '/{sample}_assembly_dir/read_mapping/',
        sam = temp(base_dir + '{sample}_assembly_dir/read_mapping/{sample}.sam'),
        raw_bam = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}_RAW.bam'),
        index_f1 = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.1.bt2'),
        index_f2 = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.2.bt2'),
        index_f3 = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.3.bt2'),
        index_f4 = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.4.bt2'),
        index_r1 = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.rev.1.bt2'),
        index_r2 = temp(base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.rev.2.bt2')
    conda: "envs/read_mapping.yml"
    threads: 32
    shell:
        """bowtie2-build {input.contigs} {output.index} --threads {threads}

        # align reads
        bowtie2 -x {output.index} --interleaved {input.trimmed_fq} -S {output.sam} --threads {threads}

        # convert sam file into sorted and indexed bam file
        samtools view -bS {output.sam} --threads {threads} > {output.raw_bam}
        samtools sort {output.raw_bam} --threads {threads} > {output.bam}
        samtools index -@ 32 {output.bam}"""


rule generate_depth_files:
    input:
        bam=base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.bam'
    output:
        depth_file='{input.read_mapping_dir}/{sample}_depth.txt',
        paired_file='{input.read_mapping_dir}/{sample}_paired.txt'
    conda: "envs/metabat2.yml"
    shell:
        "jgi_summarize_bam_contig_depths --outputDepth {output.depth_file} --pairedContigs {output.paired_file} {input.bam}"

rule bin_metabat2:
    input:
        contigs= base_dir + "/{sample}_assembly_dir/spades_assembly/contigs.fasta",
        depth_file='{input.read_mapping_dir}/{sample}_depth.txt'
    output:
        bins_dir=directory(base_dir + "/{sample}_assembly_dir/binning/metabat2")
    conda: "envs/metabat2.yml"
    params:
        minCVSum=0,
        minCV=0.1,
        m=2000
    threads: 16
    shell:
        "metabat2 -i {input.contigs}  -a {input.depth_file} -o {output.bins_dir} -t {threads} --minCVSum {params.minCVSum} --saveCls -d -v --minCV {params.minCV} -m {params.m}"

rule bin_concoct:
    input:
        contigs = base_dir + "/{sample}_assembly_dir/spades_assembly/contigs.fasta",
        bam = base_dir + '/{sample}_assembly_dir/read_mapping/{sample}.bam'
    output:
        contigs_bed = base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs/contigs_10K.bed",
        contig_chunks = base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs/contigs_10K.fa",
        cov_table = base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs/coverage_table.csv",
        clustering_gt1000 = base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs/concoct_subcontigs_clustering_gt1000.csv",
        clustering_merged = base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs/concoct_subcontigs_clustering_merged.csv",
        bins_dir = directory(base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs/fasta_bins"),
        concoct_dir = directory(base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs")
    conda: "envs/concoct.yml"
    params:
        chunk=1000
    threads: 16
    shell:
        """
        # first command (est time: 2 min)
        cut_up_fasta.py {input.contigs} -c {params.chunk} -o 0 --merge_last -b {output.contigs_bed} > {output.contig_chunks}
        # EST TIME: 4 hours
        concoct_coverage_table.py {output.contigs_bed} {input.bam} > {output.cov_table}

        # about 12 hours (overestimate) with 16 threads
        concoct --composition_file {output.contig_chunks} --coverage_file {output.cov_table} -b base_dir/{wildcards.sample}_assembly_dir/binning/concoct_subcontigs --threads {threads}

        merge_cutup_clustering.py {output.clustering_gt1000} > {output.clustering_merged}
        mkdir {output.bins_dir}
        extract_fasta_bins.py {input.contigs} {output.clustering_merged} --output_path {output.bins_dir}/concoct"""

rule bin_maxbin2:
    input:
        contigs = base_dir + "/{sample}_assembly_dir/spades_assembly/contigs.fasta",
        trimmed_fq = base_dir + '/{sample}_assembly_dir/sickle_trimmed/{sample}_all_trimmed.fastq'
    output:
        bins_dir=directory(base_dir + "/{sample}_assembly_dir/binning/maxbin2")
    conda: "envs/maxbin2.yml"
    threads: 32
    shell:
        "run_MaxBin.pl -contig {input.contigs} -reads {input.trimmed_fq} -thread {threads} -out {output.bins_dir}/maxbin"

rule generate_consensus_bins_dastools:
    input:
        contigs= base_dir + "/{sample}_assembly_dir/spades_assembly/contigs.fasta",
        metabat_fa_dir= base_dir + "/{sample}_assembly_dir/binning/metabat2",
        concoct_fa_dir= base_dir + "/{sample}_assembly_dir/binning/concoct_subcontigs",
        maxbin_fa_dir= base_dir + "/{sample}_assembly_dir/binning/maxbin2"
    output:
        base_dir + "/{sample}_assembly_dir/binning/dastools/metabat_contigs2bin.tsv",
        base_dir + "/{sample}_assembly_dir/binning/dastools/maxbin_contigs2bin.tsv",
        base_dir + "/{sample}_assembly_dir/binning/dastools/concoct_contigs2bin.tsv",
        dastools_dir=directory(base_dir + "/{sample}_assembly_dir/binning/dastools"),
        dastools_bins=directory(base_dir + "/{sample}_assembly_dir/binning/dastools/{sample}_DASTool_bins")
    conda: "envs/dastool.yml"
    threads: 32
    shell:
        """
        # metabat2
        Fasta_to_Contig2Bin.sh -e fa -i {input.metabat_fa_dir}/ > {output.dastools_dir}/metabat_contigs2bin.tsv

        # maxbin
        Fasta_to_Contig2Bin.sh -e fasta -i {input.maxbin_fa_dir}/ > {output.dastools_dir}/maxbin_contigs2bin.tsv

        # concoct (delete first line "contig_id	concoct.cluster_id", use correct command
        perl -pe "s/,/\tconcoct./g;" {input.concoct_fa_dir}/concoct_subcontigs_clustering_merged.csv > {output.dastools_dir}/concoct_contigs2bin.tsv
        sed -i '1,1d' {output.dastools_dir}/concoct_contigs2bin.tsv

        # Run DAS_Tool (EST TIME < 2 hours per sample)
        DAS_Tool -i {output.dastools_dir}/maxbin_contigs2bin.tsv,\
        {output.dastools_dir}/concoct_contigs2bin.tsv,\
        {output.dastools_dir}/metabat_contigs2bin.tsv \
        -l maxbin,concoct,metabat \
        -c {input.contigs} \
        -o {output.dastools_bins}/{wildcards.sample} --write_bins --write_bin_evals \
        -t {threads}
        """

rule evaluate_bins_checkm:
    input:
        bins= base_dir + "/{sample}_assembly_dir/binning/dastools/{sample}_DASTool_bins"
    output:
        dir=directory(base_dir + "/{sample}_assembly_dir/checkm/dastools/"),
        checkm_table= base_dir + "/{sample}_assembly_dir/checkm/dastools/output_table.txt"
    conda: "envs/checkm.yml"
    threads: 16
    shell:
        "checkm lineage_wf -x fa -t {threads} {input.bins} {output.dir} -f {output.checkm_table}"


    

