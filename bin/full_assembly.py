#!/usr/bin/env python
# -*- coidng: utf-8

import sys
import argparse

"""what do I have and where I am going. 

I have a pipeline that works on a single sample. it takes a fastq file as input and creates all the specified subdirs and files
within a given dir.

What do I want: two fold objectives: I want to create a pipeline that is generalizable to all samples or a dataset. I would leverage 
argparse to do this and let argparse create a specified config file that snakemake ultimately uses. (implement argparse, create
config file from given data, update snakemake to work with config file) (Use dry run!)

The other objective is to create a pipeline that does subassemblies and iterative subtractive assemblies. I believe this can be 
accomplished with two new rules. One rule will be subsetting reads. another rule will be mapping reads. perhaps another rule
will be subsetting only unmapped reads.

TODO: also, splitting rules into subrules and grouping rules together

"""
def main(args):
    print(args)

if __name__ == '__main__':
    main()