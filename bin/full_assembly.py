#!/usr/bin/env python
# -*- coidng: utf-8

import sys
import argparse
import subprocess
from pathlib import PATH
import csv
import os

"""what do I have and where I am going. 

I have a pipeline that works on a single sample. it takes a fastq file as input and creates all the specified subdirs and files
within a given dir.

What do I want: two fold objectives: I want to create a pipeline that is generalizable to all samples or a dataset. I would leverage 
argparse to do this and let argparse create a specified config file that snakemake ultimately uses. (implement argparse, create
config file from given data, update snakemake to work with config file) (Use dry run!)

The other objective is to create a pipeline that does subassemblies and iterative subtractive assemblies. I believe this can be 
accomplished with two new rules. One rule will be subsetting reads. another rule will be mapping reads. perhaps another rule
will be subsetting only unmapped reads.

TODO: set up argparse
TODO: config file
TODO: sub assemblies
    TODO: subsetting rule:
    TODO: mapping rule:
TODO: job groups see: https://stackoverflow.com/questions/69942132/snakemake-workflowerror-failed-to-group-jobs-together
    motivation: sub jobs won't delete their output if error in entire job group prevails--smarter slurm resource management


"""
def main():
    args = add_arguments()

    check_arguments(args)
    create_config_file()

    # TODO: subprocess and call snakemake with temp config file
    # TODO: configure snakemake to use config file
    # TODO: delete config file 

def add_arguments():
    p = argparse.ArgumentParser(prog="Assembly workflow", description="Run Streamlined Assembly Protocols")
    p.add_argument('-i', help='Path to input interleaved fastq files. If path is a dir with fastq files, the -s flag should be used \n'
                   'i.e. "_all.fastq" for "<sample>_all.fastq". Another option is to indicate a csv file. The csv file should contain \n'
                   'sample names in the first column and paths to interleaved sample fastq files in the second column. ', required=True)
    p.add_argument('-s', help='suffix for interleaved fastq files i.e. "_all.fastq" for "<sample>_all.fastq"', required=False)
    p.add_argument('-o', help="path to output dir. If output dir does not exist, it will be created", required=True)
    p.add_argument('--resource_req', help='path to yaml file that stores the resource requirements if using slurm', required = False)
    p.add_argument('-n', help='dry run through snakemake workflow', default=False, action='store_true')

    #TODO: add additional options to specify subassemblies and iterative subtractive assembly

    return p.parse_args()

def check_arguments(args):
    """TODO: make sure -i flag points to dir or csv file. make sure that suffix flag is indicated if -i points to a dir"""
    if os.path.isdir(args.i) and not args.s:
        raise IOError("suffix must be supplied if input flag points to a directory")

def create_config_file():
    # TODO: create a temporary config file
    """
    Input:
        input_fastq_dir: "/project/thrash_89/db/EAGER_metaG_for_ck/interleaved_metaG/qual_trim_after_interleaving/brett_cat"
        input_fastq_suffix: "_all.fastq"
        input_fastq_csv_file: ""
    output_dir: "/project/thrash_89/db/EAGER_metaG_for_ck/pipeline_assemblies"  
    slurm_scheduling:
        uses_slurm_scheduling: "True"
        slurm_resource_paramter_yml: """

    # with f as open(filename) etc.
    pass

if __name__ == '__main__':
    main()