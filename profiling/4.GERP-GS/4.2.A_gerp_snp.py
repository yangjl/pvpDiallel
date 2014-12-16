# Jinliang Yang
# ipython

import pandas as pd
import numpy as np

## merge snp11m with gerp130m
snp11m = pd.read_table("largedata/SNP/allsnps_11m.dsf5", sep="\t")
gerp130m = pd.read_csv("largedata/GERPv2/gerp130m.csv")
#paste two columns
gerp130m['snpid'] = gerp130m.chr.map(str) + "_" + gerp130m.pos.map(str)
snp11mgp = pd.merge(gerp130m[["snpid", "N", "RS"]], snp11m, on='snpid', sort=False, how='right')
snp11mgp.to_csv("largedata/SNP/allsnps_11m_gerpv2.csv", index=False)

#add bins
snp11mgp = pd.read_csv("largedata/SNP/allsnps_11m_gerpv2.csv")
snp11mgp = snp11mgp[["snpid", "N", "RS", "chr", "pos"]]
snp11mgp.to_csv("largedata/SNP/allsnps_11m_gerpv2_tidy.csv", index=False)


#####
snp11m = pd.read_table("largedata/SNP/allsnps_11m.dsf5", sep="\t")
gerp = pd.read_csv("largedata/SNP/allsnps_11m_gerpv2_tidy.csv")

