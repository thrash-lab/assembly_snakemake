#!/bin/bash

# took about thirteen minutes (overestimate) to trim one sample
# untrimmed: 95171524
# trimmed  : 
#FastQ paired records kept: 94693966 (47346983 pairs)
#FastQ single records kept: 236266
#FastQ paired records discarded: 5026 (2513 pairs)
#FastQ single records discarded: 236266

sickle pe -c /project/thrash_89/db/EAGER_metaG_for_ck/interleaved_metaG/qual_trim_after_interleaving/brett_cat/ARD_V2_S1_all.fastq -t sanger -m /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_trimmed.fastq -s /project/thrash_89/db/EAGER_metaG_for_ck/ARD_V2_S1_investigation/sickle_trimmed/ARD_V2_S1_all_singles.fastq
