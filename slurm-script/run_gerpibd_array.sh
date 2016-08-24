#!/bin/bash -l
#SBATCH -D /home/jolyang/Documents/Github/pvpDiallel
#SBATCH -o /home/jolyang/Documents/Github/pvpDiallel/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/Github/pvpDiallel/slurm-log/err-%j.txt
#SBATCH -J gerpibd
#SBATCH --array=1-84
#SBATCH --mail-user=yangjl0930@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

sh slurm-script/run_gerpibd_$SLURM_ARRAY_TASK_ID.sh
