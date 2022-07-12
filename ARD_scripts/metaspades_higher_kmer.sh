#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=64
#SBATCH --mem=998GB
#SBATCH --partition=largemem

# took 11 hours to do K55, K77, K99
# TIME: 4:30 took the sample thorugh the read correction and part of K21. 
# 10:00 took the sample through K21 through K55 just barely. A safe time is 16:00 per schedule
# approximately 10 hours took through K55, K77, and K99
module load spades

output_dir=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/spades_assembly/
file=/project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_trimmed.fastq

date +%s
metaspades.py --restart-from k55 -o $output_dir -k 21,33,55,77,99
date +%s
