#!/bin/bash
#SBATCH -D slurm-scripts/
#SBATCH -o /home/jolyang/Documents/pvpDiallel/slurm-log/testout-%j.txt
#SBATCH -e #SBATCH -e /home/jolyang/Documents/pvpDiallel/slurm-log/error-%j.txt
#SBATCH -J gyjob
set -e
set -u

GenSel4R gy_test.inp > gy_test.log
python /home/jolyang/bin/send_email.py -s gy_test.inp
