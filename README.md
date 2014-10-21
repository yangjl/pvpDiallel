## Welcome to Project exPVP Diallel!


### Traits of interest:
* **PHT**: plant height
* **EHT**: ear height
* **DTS**: days to silking
* **DTP**: days to pollen
* **ASI**: anthesis-silk Interval
* **Adj.GY**: adjusted grain yield
* **TW**: _test weight?_ what is this trait? 


### Jinliang's report on phenotypic data checking

```{r, eval=FALSE}
source("~/Documents/Github/pvpDiallel/munge/1.raw_pheno/1.A.1_format_pheno.R")
```





### Notes from Sofiane 10/13/2014

Here are the links to the data: 

```
Genetic values, MPH, BPH and combining abilities:
"/group/jrigrp2/DiallelSofiane/GeneticValues/"

"GCA-SCA*.txt" are the combining abilities (one file per traits)

"Gvalues_*" are the hybrid values with MPH and BPH as well (one file per trait)

"GeneticValuesExPVPdiallelbis" is the file of fitted values that I used to create GCA-SCA and Gvalues. 



We have 7 traits PHT(plant height),	EHT(ear height),DTS(days to silking),DTP(Days to pollen), ASI,
Adj.GY (afjusted yield) and TW (Test weight).

The SNP data (only the parents) is in "/group/jrigrp2/DiallelSofiane/BWA/SNPfiles/FinalSNPs_all.txt" 

I also imputed missing alleles with Beagle and the data is in 
"/group/jrigrp2/DiallelSofiane/BWA/SNPfiles/ImpSNPs_all"

The SNP annotation is in "/group/jrigrp2/DiallelSofiane/BWA/SNPfiles/SNP-DelCall-all.txt"

The hybrid genotypes are in "/group/jrigrp2/DiallelSofiane/BWA/SNPfiles/HetGeno_chr*" with one file per chromosome; 
it was faster to run the analyses on parallel for all chromosomes and I had them in separate file to limit I/O problems.

Finally,  I have the same hybrid information coded 0/1 in 
"/group/jrigrp2/DiallelSofiane/BWA/SNPfiles/Het0-1_chr$" 
```
