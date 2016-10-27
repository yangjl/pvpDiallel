### Jinliang Yang
### 2016-08-22

library("farmeR")

set_array_job(shid="slurm-script/getmajor.sh",
             shcode='R --no-save --args ${SLURM_ARRAY_TASK_ID} < profiling/4.GERP-GS/4.6.A_1_estimate_dsite.R',
             arrayjobs="1-9", wd=NULL, jobid="getmajor", 
             email="yangjl0930@gmail.com",
             run=c(TRUE, "bigmemh", 8))

