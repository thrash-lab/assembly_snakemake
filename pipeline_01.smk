import snakemake
import numpy

#TODO rule all
#TODO conda yaml for each rule
rule all:
    input: 
        dir=directory("{outupt_dir}/checkm/dastools/"),
        checkm_table="{output_dir}/checkm/dastools/output_table.txt"

rule sickle_trim:
    input:
        fastq='{fastq_dir}/{sample}_all.fastq'
    output:
        singles='{output_dir}/sickle_trimmed/{sample}_all_singles.fastq',
        trimmed='{output_dir}/sickle_trimmed/{sample}_all_trimmed.fastq'
    shell:
        """module purge
        eval "$(conda shell.bash hook)"
        conda activate /home1/cykojima/.conda/envs/sickle
        sickle pe -c {input.fastq} -t sanger -m {output.trimmed} -s {output.singles}"""

rule metaspades_assembly:
    input:
        trimmed_fq='{output_dir}/sickle_trimmed/{sample}_all_trimmed.fastq'
    output:
        dir=directory('{output_dir}/spades_assembly/'),
        contigs='{output_dir}/spades_assembly/contigs.fasta'
    threads: 64
    shell:
        """#load metaspades
        metaspades.py --12 {input} -o {output} --memory 998 -t {threads}"""


rule bowtie2_map_reads:
    input:
        trimmed_fq='{output_dir}/sickle_trimmed/{sample}_all_trimmed.fastq',
        contigs='{output_dir}/spades_assembly/contigs.fasta'
    output:
        index='{output_dir}/read_mapping/',
        dir=direcotry('{output_dir}/read_mapping/{sample}'),
        'bam={output_dir}/read_mapping/{sample}.bam',
        'bam_index={output_dir}/read_mapping/{sample}.bam.bai'
    threads: 32
    shell:
        """bowtie2-build "{input.contigs}" {output.index} --threads {threads}

        # align reads
        bowtie2 -x {output.index} --interleaved {input.trimmed} -S {output_dir}/read_mapping/{sample}.sam --threads {threads}

        # convert sam file into sorted and indexed bam file
        samtools view -bS {output_dir}/read_mapping/{sample}.sam --threads {threads} > {output_dir}/read_mapping/{sample}_RAW.bam
        samtools sort {output_dir}/read_mapping/{sample}_RAW.bam --threads {threads} > {output.bam}
        samtools index -@ 32 {output_dir}/read_mapping/{sample}.bam

        # remove intermediate files
        rm {output_dir}/read_mapping/{sample}_RAW.bam {output_dir}/read_mapping/{sample}.sam"""


rule generate_depth_files:
    input:
        bam='{output_dir}/read_mapping/{sample}.bam'
    output:
        depth_file='{input.read_mapping_dir}/{sample}_depth.txt',
        paired_file='{input.read_mapping_dir}/{sample}_paired.txt'
    shell:
        "jgi_summarize_bam_contig_depths --outputDepth {output.depth_file} --pairedContigs {output.paired_file} {input.bam}"

rule bin_metabat2:
    input:
        contigs="{output_dir}/spades_assembly/contigs.fasta",
        depth_file='{input.read_mapping_dir}/{sample}_depth.txt'
    output:
        bins_dir=directory("{output_dir}/binning/metabat2/metabat2")
    params:
        minCVSum=0,
        minCV=0.1,
        m=2000
    threads: 16
    shell:
        "metabat2 -i {input.contigs}  -a {input.depth_file} -o {output.bins_dir} -t {threads} --minCVSum {params.minCVSum} --saveCls -d -v --minCV {params.minCV} -m {params.m}"

rule bin_conoct:
    input:
        contigs="{output_dir}/spades_assembly/contigs.fasta",
        bam='{output_dir}/read_mapping/{sample}.bam'
    output:
        contigs_bed="{output_dir}/binning/concoct_subcontigs/contigs_10K.bed",
        contig_chunks="{output_dir}/binning/concoct_subcontigs/contigs_10K.fa",
        cov_table="{output_dir}/binning/concoct_subcontigs/coverage_table.csv",
        clustering_gt1000="{output_dir}/binning/concoct_subcontigs/concoct_subcontigs_clustering_gt1000.csv",
        clustering_merged="{output_dir}/binning/concoct_subcontigs/concoct_subcontigs_clustering_merged.csv",
        bins_dir=directory("{output_dir}/binning/concoct_subcontigs/fasta_bins")

    params:
        chunk=1000
    threads: 16
    shell:
        """## NOTE: Make sure Bam.bai file is present!!! will not run to completion otherwise
        sample=CJ_V2_S8
        sample_dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/binning/concoct_subcontigs
        dir=/project/thrash_89/db/EAGER_metaG_for_ck/${sample}_investigation/spades_assembly

        # first command (est time: 2 min)
        cut_up_fasta.py {input.contigs} -c {params.chunk} -o 0 --merge_last -b {output.contigs_bed} > {output.contig_chunks}
        # EST TIME: 4 hours
        concoct_coverage_table.py {output.contigs_bed} {input.bam} > {output.cov_table}

        # about 12 hours (overestimate) with 16 threads
        concoct --composition_file {output.contig_chunks} --coverage_file {output.cov_table} -b {output_dir}/binning/concoct_subcontigs --threads {threads}

        merge_cutup_clustering.py {output.cluster_gt1000} > {output.clustering_merged}
        mkdir {output.bins_dir}
        extract_fasta_bins.py {input.contigs} {output.clustering_merged} --output_path {output.bins_dir}/concoct"""

rule bin_maxbin2:
    input:
        contigs="{output_dir}/spades_assembly/contigs.fasta",
        trimmed_fq='{output_dir}/sickle_trimmed/{sample}_all_trimmed.fastq'
    output:
        bins_dir=directory("{output_dir}/binning/maxbin2")
    threads: 32
    shell:
        "run_MaxBin.pl -contig {input.contigs} -reads {input.trimmed_fq} -thread {threads} -out {output_dir}/binning/maxbin2/maxbin"

rule generate_consensus_bins_dastools:
    input:
        contigs="{output_dir}/spades_assembly/contigs.fasta",
        metabat_fa_dir=directory("{output_dir}/binning/metabat2"),
        concoct_fa_dir=directory("{output_dir}/binning/concoct_subcontigs"),
        maxbin_fa_dir=directory("{output_dir}/binning/maxbin2")
    output:
        "{output_dir}/binning/metabat2/metabat2/my_contigs2bin.tsv",
        "{output_dir}/binning/maxbin2/my_contigs2bin.tsv",
        "{output_dir}/binning/concoct_subcontigs/concoct.contigs2bin.tsv",
        dastools_dir=directory("{output_dir}/binning/dastools")
        dastool_bins=directory("{output_dir}/binning/dastools/{sample}_DASTool_bins")
        

    threads: 32
    shell:
        """
        # metabat2
        Fasta_to_Contig2Bin.sh -e fa -i {input.metabat_fa_dir}/ > {input.metabat_fa_dir}/my_contigs2bin.tsv

        # maxbin
        Fasta_to_Contig2Bin.sh -e fasta -i {input.maxbin_fa_dir}/ > {input.maxbin_fa_dir}/my_contigs2bin.tsv

        # concoct (delete first line "contig_id	concoct.cluster_id", use correct command
        perl -pe "s/,/\tconcoct./g;" {input.concoct_fa_dir}/concoct_subcontigs_clustering_merged.csv > {input.concoct_fa_dir}/concoct.contigs2bin.tsv
        sed -i '1,1d' {input.concoct_fa_dir}/concoct.contigs2bin.tsv

        # Run DAS_Tool (EST TIME < 2 hours per sample)
        DAS_Tool -i {input.maxbin_fa_dir}/my_contigs2bin.tsv,\
        {input.concoct_fa_dir}/concoct.contigs2bin.tsv,\
        {input.metabat_fa_dir}/my_contigs2bin.tsv \
        -l maxbin,concoct,metabat \
        -c {input.contigs} \
        -o {output.dastools_bins}/{sample} --write_bins --write_bin_evals \
        -t {threads}
        """

rule evaluate_bins_checkm:
    input:
        bins=directory("{output_dir}/binning/dastools/{sample}_DASTool_bins")
    output:
        dir=directory("{outupt_dir}/checkm/dastools/"),
        checkm_table="{output_dir}/checkm/dastools/output_table.txt"
    threads: 16
    shell:
        "checkm lineage_wf -x fa -t {threads} {input.bins} {output.dir} -f {output.checkm_table}"


    

