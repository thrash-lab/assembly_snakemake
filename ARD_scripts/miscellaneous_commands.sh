#!/bin/bash

# determin read length distribution

#activate bbmap
readlength.sh in=ARD_V2_S1_all_trimmed.fastq out=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/ARD_V2_S1_read_length_histogram.txt bin=10 max=80000

# version 2 read length histogram
cat ARD_V2_S1_all.fastq | readlength.sh in=stdin.fq \
out=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/ARD_V2_S1_new_cat_untrimmed_read_length_histogram.txt \
bin=10 max=80000
