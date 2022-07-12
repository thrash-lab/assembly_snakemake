#!/bin/bash

# activate metaquast env
rgs=`ls /project/thrash_89/cykojima/rrap_LD12_salinity/recruitment/rg_Jun_6_2022/* | python -c 'import sys; print(",".join([x.strip() for x in sys.stdin.readlines()]))'`

metaquast.py spades_assembly/contigs.fasta -r $rgs --no-plots --no-icarus --no-snps --no-gc --no-sv --threads 6 -o /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/metaquast_analysis/


