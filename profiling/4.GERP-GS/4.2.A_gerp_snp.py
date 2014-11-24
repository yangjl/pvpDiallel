# Jinliang Yang
# ipython

import pandas as pd
import numpy as np

snp11m = pd.read_table("largedata/SNP/allsnps_11m.dsf5", sep="\t")

gerp130m = pd.read_csv("largedata/GERPv2/gerp130m.csv")

#paste two columns
gerp130m['snpid'] = gerp130m.chr.map(str) + "_" + gerp130m.pos.map(str)


snp11mgp = pd.merge(gerp130m[["snpid", "N", "RS"]], snp11m, on='snpid', sort=False, how='right')

snp11mgp.to_csv("largedata/SNP/allsnps_11m_gerpv2.csv", index=False)
