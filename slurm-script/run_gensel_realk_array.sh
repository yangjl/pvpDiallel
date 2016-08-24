#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/pvpDiallel
#SBATCH -o /home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/pvpDiallel/slurm-log/err-%j.txt
#SBATCH -J gensel
#SBATCH --array=1-84
#SBATCH --mail-user=yangjl0930@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

sh largedata/newGERPv2/allgeno_bph_k/run_gensel_$SLURM_ARRAY_TASK_ID.sh
