---
output: pdf_document
---

# To Do List

-----

Was talking to a colleague yesterday about the work you guys are doing, and he expressed concerns about the genomic prediction.  He wanted to know if the GERP SNPs do better than random SNPs in genes or random SNPs in similar recombination bins.  I think the first is easy to calculate, and we should probably do so.  What do you think?

This is a good point! 
But if there is a correlation between the number of genes and conserved SNPs along the genome, it will be hard to dissociate them. 
What about separating SNPs in protein coding sequences from the ones in the introns?
--
Actually I like the intron idea as that separates out linkage to causative sites from actual GERP scores.  What do you think Jinliang?  Or we could do genic SNPs with low GERP scores vs. genic SNPs with high GERP scores?

-Jeff
------




1. Run the BPH trait after trait _per se_
2. SNP in the bin
3. cM method, try to fix the negative cM issue
4. 

------

# Short reminder of what has been done (By Sofiane):

## phentoype
1. Diallel phenotypic data 
2. analyses of the phenotypic data 
3. estimates of MPH, BPHmax, BPHmin
4. estimates of GCA and SCA

## Diallel parent sequence data 

1. sequences mapped to the B73 ref. 
2. SNP calls and filtering 
3. IBS estimates with Beagle 
4. Haplotypic bloc definition 
5. Synonymous/non synonymous SNP calls 
6. deleterious SNPs calls (SIFT and MAPP)

## Statistics 

1. GWAS at SNP level 
2. SNP heterozygosity with heterosis
3. SNP heterozygosity with heterosis assuming dominance (I included one of the homozygotes with the heterozygotes)
4. SNPs with the genetic values of the hybrids
5. SNPs with SCA

## GWAS at the Haplotype level

1. heterozygosity with heterosis 


Summaries of the results:

Number of significant haplotypic blocs for :

different thresholds 

a minimum haplotype count of 5, 10 or 30 

MPH, BPHmax and BPHmins

Comparison of dominance vs additivity for the SNPs for 

different thresholds 

MPH, BPHmax and BPHmins

I looked at significant haplotypic blocs with minimum allele count of at least 5 that are significant (pval<0.0001) and checked what is the better model for significant SNPs (pval<0.001) in the haplotype: dominance or additivity

Check the number of haplotypes in each haplotypic group and identify the polymorphisms and weather that are deleterious

it’s stil running on the server …

