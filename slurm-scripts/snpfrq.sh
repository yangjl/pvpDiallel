#!/bin/bash
#SBATCH -D /home/jolyang/Documents/pvpDiallel/
#SBATCH -o /home/jolyang/Documents/pvpDiallel/slurm-log/
#SBATCH -e /home/jolyang/Documents/pvpDiallel/slurm-log/
#SBATCH -J snpfrq
set -e
set -u

snpfrq -i allsnps_13.7m.dsf2 -s 5 -e 16 -m NH -a 0 -b 1 -o allsnps_frq.out