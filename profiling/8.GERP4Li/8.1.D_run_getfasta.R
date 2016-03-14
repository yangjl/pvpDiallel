### AGPv2 -> AGPv3 conversion
### http://plants.ensembl.org/Oryza_sativa/Tools/AssemblyConverter?db=core
library(maizeR)
set_farm_job(slurmsh = "slurm-scripts/run_getfa.sh",
             shcode = "R --no-save  < profiling/8.GERP4Li/8.1.C_getfasta_gerpv3.R", 
             wd = NULL, jobid = "getfa",
             email = "yangjl0930@gmail.com")

