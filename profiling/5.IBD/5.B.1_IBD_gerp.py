# Jinliang Yang
# ipython

import pandas as pd
import numpy as np

### read.table
snpibd = pd.read_table("largedata/IBD/allsnps_11m_IBD.bed", sep="\t", header= None)
gerp = pd.read_csv("largedata/SNP/allsnps_11m_gerpv2_tidy.csv")
dsf7 = pd.read_table("largedata/SNP/allsnps_11m.dsf5", sep="\t")

### replace = gsub
snpibd[3].replace("chr", "", regex=True, inplace=True)

### paste
snpibd['snpid'] = snpibd[3].map(str) + "_" + snpibd[2].map(str)
snpibd['ibdid'] = snpibd[3].map(str) + "_" + snpibd[4].map(str)

### merge
snpibd = pd.merge(snpibd, gerp[["snpid", "RS"]], on='snpid', sort=False, how='inner')
snp0 = snpibd[snpibd['RS']>0]

###
ibdsnpcount = snpibd.groupby('ibdid').size()
ibd0 = snp0.groupby('ibdid').size()
len(ibd0)
#Out[16]: 85388

### GERP>0 merged with dsf7
ibddsf = pd.merge(snp0, dsf7.iloc[:,np.r_[0, 7:19]], on="snpid", sort=False, how="inner")


### Iterating through groups
for name, group in ibddsf.groupby(['ibdid']):
  for onesnp in group:
    if onesnp['B73'] != 'N' and onesnp['MO17'] == onesnp['B73']:
      snptype = 2
    if onesnp['B73'] != 'N' and onesnp['MO17'] != onesnp['B73']:
      snptype = 1
    
      
  
def afunction():
  

### write.csv
snp11mgp.to_csv("largedata/SNP/allsnps_11m_gerpv2.csv", index=False)







