import os
import pandas as pd
import numpy as np
import csv


dict = {"Bin Id": [], "Marker lineage": [], "# genomes": [], "# markers": [], "# marker sets": [], "completeness": [], "contamination": [], "Strain heterogeneity": []}
counth = 0
countl = 0
countm = 0
countx = 0
for file in os.listdir("/Users/connerkojima/thrash/checkm_outputs"):
    with open("/Users/connerkojima/thrash/checkm_outputs/{}".format(file)) as f:
        lines = f.readlines()
        lines = lines[3:-1]
        
        for line in lines:
            tokens = line.split()
            dict["Bin Id"].append(tokens[0])
            dict["Marker lineage"].append(tokens[1])
            dict["# genomes"].append(tokens[3])
            dict["# markers"].append(tokens[4])
            dict["# marker sets"].append(tokens[5])
            dict["completeness"].append(tokens[12])
            dict["contamination"].append(tokens[13])
            dict["Strain heterogeneity"].append(tokens[14])
            if float(tokens[12]) > 90 and float(tokens[13]) < 5:
                counth = counth + 1
            if float(tokens[12]) >= 50 and float(tokens[13]) < 10:
                countm = countm + 1
            if float(tokens[12]) >= 50 and float(tokens[13]) < 10 and tokens[1] == "c__Alphaproteobacteria":
                countl = countl + 1
            if float(tokens[12]) > 90 and float(tokens[13]) < 5 and tokens[1] == "c__Alphaproteobacteria":
                countx = countx + 1
            

data = pd.DataFrame(dict)
print(counth)
print(countm)
print(countl)
print(countx)
