# Jinliang Yang
# ipython

import pandas as pd
import numpy as np
from __future__ import print_function
import sys
import argparse
import textwrap
import timeit
import os

def readData():
  ### read.table
  snpibd = pd.read_table("largedata/IBD/allsnps_11m_IBD.bed", sep="\t", header= None)
  gerp = pd.read_csv("largedata/SNP/allsnps_11m_gerpv2_tidy.csv")
  dsf7 = pd.read_table("largedata/SNP/allsnps_11m.dsf5", sep="\t")

  ### replace = gsub
  snpibd[3].replace("chr", "", regex=True, inplace=True)

  ### paste
  snpibd['snpid'] = snpibd[3].map(str) + "_" + snpibd[2].map(str)
  snpibd['ibdid'] = snpibd[3].map(str) + "_" + snpibd[4].map(str)

  ### merge SNPs with positive GERP score
  snpibd = pd.merge(snpibd, gerp[["snpid", "RS"]], on='snpid', sort=False, how='inner')
  snp0 = snpibd[snpibd['RS']>0]

  ###
  ibd0 = snp0.groupby('ibdid').size()
  #len(ibd0)
  #Out[16]: 85388

  ### GERP>0 merged with dsf7
  ibddsf = pd.merge(snp0, dsf7.iloc[:,np.r_[0, 7:19]], on="snpid", sort=False, how="inner")
  return ibddsf

### create a pedigree table
def getPed(ibddsf):
  names = ibddsf.columns.values[9:21]
  names = np.sort(names)
  ped = pd.DataFrame({'F1': np.random.randn(144),
                      'P1': np.repeat(names, 12, axis=0),
                      'P2': names.tolist() * 12})
  ped = ped[ped['P1'] < ped['P2']]
  ped.loc[:, 'F1'] = ped['P1'] + "x" + ped['P2']
  return ped
  
### compute GERP in additive mode  
def ComputeOneGroup(onegroup):
  # gerp1a/gerp1d: gerp complementation
  # gerp2a/gerp2d: sum of gerp value
  gerp1a = gerp2a = gerp1d = gerp2d = 0
  p1 = "P1"
  p2 = "P2"
  for name, onesnp in onegroup.iterrows():
    # checking B73 reference
    if onesnp["B73"] != "N":
      b73 = onesnp["B73"]
        
      if onesnp[p1] == b73 and onesnp[p2] == b73:
        gerp1a = gerp1a + 2
        gerp2a = gerp2a + onesnp["RS"]*2
        gerp1d = gerp1d + 1
        gerp2d = gerp2d + onesnp["RS"]
      elif (onesnp[p1] != b73 and onesnp[p1] != "N") and onesnp[p2] == b73:
        gerp1a = gerp1a + 1
        gerp2a = gerp2a + onesnp["RS"]
        gerp1d = gerp1d + 1
        gerp2d = gerp2d + onesnp["RS"]
      elif onesnp[p1] == "N" and onesnp[p2] == b73:
        gerp1a = gerp1a + 1.5
        gerp2a = gerp2a + onesnp["RS"]*1.5
        gerp1d = gerp1d + 0.5
        gerp2d = gerp2d + onesnp["RS"]*0.5
          
      elif onesnp[p1] == b73 and (onesnp[p2] != b73 and onesnp[p2] != "N"):
        gerp1a = gerp1a + 1
        gerp2a = gerp2a + onesnp["RS"]
        gerp1d = gerp1d + 1
        gerp2d = gerp2d + onesnp["RS"]
      elif (onesnp[p1] != b73 and onesnp[p1] != "N") and (onesnp[p2] != b73 and onesnp[p2] != "N"):
        gerp1a = gerp1a + 0
        gerp2a = gerp2a + 0
        gerp1d = gerp1d + 0
        gerp2d = gerp2d + 0
      elif onesnp[p1] == "N" and (onesnp[p2] != b73 and onesnp[p2] != "N"):
        gerp1a = gerp1a + 0.5
        gerp2a = gerp2a + onesnp["RS"]*0.5
        gerp1d = gerp1d + 0.5
        gerp2d = gerp2d + onesnp["RS"]*0.5
       
      elif onesnp[p1] == b73 and onesnp[p2] == "N":
        gerp1a = gerp1a + 1.5
        gerp2a = gerp2a + onesnp["RS"]*1.5
        gerp1d = gerp1d + 1
        gerp2d = gerp2d + onesnp["RS"]
      elif (onesnp[p1] != b73 and onesnp[p1] != "N") and onesnp[p2] == "N":
        gerp1a = gerp1a + 0.5
        gerp2a = gerp2a + onesnp["RS"]*0.5
        gerp1d = gerp1d + 0.5
        gerp2d = gerp2d + onesnp["RS"]*0.5
      elif onesnp[p1] == "N" and onesnp[p2] == "N":
        gerp1a = gerp1a + 1
        gerp2a = gerp2a + onesnp["RS"]
        gerp1d = gerp1d + 1
        gerp2d = gerp2d + onesnp["RS"]
      else:
        warnings(onesnp["snpid"], "for", p1, p2, "have problem for additive imputation!")
    gres = {'gerp1a': gerp1a, 'gerp2a': gerp2a, "gerp1d": gerp1d, "gerp2d": gerp2d}  
  return pd.Series(gres, name='metrics')
  

### Iterating through groups
def GetIBDgerp(ped, ibddsf):
  
  ### setup empty dataframe to collect results
  resa1 = resa2 = resd1 = resd2 = pd.DataFrame()
  
  for index, row in ped[1:2,].iterrows():
    mydf = ibddsf[ ["ibdid", "B73", "RS", row["P1"], row["P2"]] ]
    mydf.columns = ["ibdid", "B73", "RS", 'P1', 'P2']
    
    print ">>> computing F1: [ ", row["F1"], " ]!"
    myres = mydf.groupby(['ibdid']).apply(ComputeOneGroup)
    #### concatenate the results
    tema1 = pd.DataFrame(myres, columns= ["gerp1a"])
    tema1.columns = [row["F1"]]
    resa1 = pd.concat([resa1, tema1], axis=1)
    
    tema2 = pd.DataFrame(myres, columns= ["gerp2a"])
    tema2.columns = [row["F1"]]
    resa2 = pd.concat([resa2, tema2], axis=1)
    
    temd1 = pd.DataFrame(myres, columns= ["gerp1d"])
    temd1.columns = [row["F1"]]
    resd1 = pd.concat([resd1, temd1], axis=1)
    
    temd2 = pd.DataFrame(myres, columns= ["gerp2d"])
    temd2.columns = [row["F1"]]
    resd2 = pd.concat([resd2, temd2], axis=1)
  
  hashres = {"gerpa1": resa1, "gerpa2":resa2, "gerpd1":resd1, "gerpd2":resd2}
  return hashres  

### write results
def writeRes(hashres):
  #Apply operates on each row or column with the lambda function
  #axis = 0 -> act on columns, axis = 1 act on rows
  #x is a variable for the whole row or column
  #This line will scale minimum = 0 and maximum = 1 for each column
  #newrange = [-10, 10]
  #mfac = (newrange[1] - newrange[0])
  #change to (-10, 10)
  gerpa1 = hashres["gerpa1"]
  gerpa1 = gerpa1.apply(lambda x:-10+(x.astype(float) - min(x))/(max(x)-min(x))*20, axis = 0)
  gerpa1 = pd.transpose(gerpa1)
  gerpa1 = np.round(gerpa1, 0)
  gerpa1.to_csv("largedata/SNP/allsnps_11m_gerpv2.gensel", sep="\t", index=False)

  gerpa2 = hashres["gerpa2"]
  gerpa2 = gerpa2.apply(lambda x:-10+(x.astype(float) - min(x))/(max(x)-min(x))*20, axis = 0)
  gerpa2 = np.round(gerpa2, 0)
  gerpa2 = gerpa2.transpose()
  
  gerpa2.to_csv("largedata/SNP/allsnps_11m_gerpv2.gensel", sep="\t", index=False)

def version():
    ver0 = """
    ##########################################################################################
    gerpIBD version 0.1
    Author: Jinliang Yang
    purpose: compute the accumulative GERP rate in an IBD region
    --------------------------------

    updated: 12/16/2014
    ##########################################################################################
    """
    return ver0

def warning(*objs):
    print("WARNING: ", *objs, end='\n', file=sys.stderr)
    sys.exit()

##########################################################################################
def get_parser():
  parser = argparse.ArgumentParser(
      formatter_class=argparse.RawDescriptionHelpFormatter,
      description=textwrap.dedent(version())
      )

  # positional arguments:
  #parser.add_argument('query', metavar='QUERY', type=str, nargs='*', \
  #                    help='the question to answer')
  # optional arguments:
  parser.add_argument('-p', '--path', help='the path of the input files', \
                      nargs='?', default=os.getcwd())
  parser.add_argument('-i','--input', help='largedata/SNP/allsnps_11m_gerpv2_tidy.csv', type=str)
  parser.add_argument('-o', '--output', help='output files, such as chr1_merged', type=str)
  return parser
  #parser = get_parser()
  #parser.print_help()
    
def main():
  ### read data
  print ">>> reading data"
  ibddsf = readData()
  print ">>> generating pedigree info"
  ### get ped info from names of idbdsf object
  ped = getPed(ibddsf)
  ### get IBM gerp looping through ped lines
  test = GetIBDgerp(ped, ibddsf)
  print ">>> writing results"
  writeRes(hashres=test)

 
if __name__ == "__main__":
  main()







