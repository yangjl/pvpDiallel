#!/bin/bash
#SBATCH -D /home/jolyang/Documents/pvpDiallel/
#SBATCH -o /home/jolyang/Documents/pvpDiallel/slurm-log/
#SBATCH -e /home/jolyang/Documents/pvpDiallel/slurm-log/
#SBATCH -J snpfrq
set -e
set -u

sh /home/jolyang/Documents/pvpDiallel/largedata/GenSel/test.sh