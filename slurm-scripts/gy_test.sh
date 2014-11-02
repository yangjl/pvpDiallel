#!/bin/bash
#SBATCH -D /Users/yangjl/Documents/Github/pvpDiallel
#SBATCH -o /home/jolyang/Documents/pvpDiallel/slurm-log/testout-%j.txt
#SBATCH -e /home/jolyang/Documents/pvpDiallel/slurm-log/error-%j.txt
#SBATCH -J gyjob
set -e
set -u

GenSel4R slurm-scripts/gy_test.inp > slurm-scripts/gy_test.log
python /home/jolyang/bin/send_email.py -s slurm-scripts/gy_test.inp
