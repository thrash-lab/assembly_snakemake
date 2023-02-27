import os
import pandas as pd
import numpy as np
import csv


dict = {"Bin Id": [], 
        "Marker lineage": [], 
        "# genomes": [], 
        "# markers": [], 
        "# marker sets": [], 
        "0": [],
        "1": [],
        "2": [],
        "3": [],
        "4": [],
        "5+": [],
        "completeness": [], 
        "contamination": [], 
        "Strain heterogeneity": [], 
        "quality_metric": []}

counth = 0
countl = 0
countm = 0
countx = 0
count = 0
for file in os.listdir("/Users/connerkojima/thrash/checkm_outputs/"):
    with open("/Users/connerkojima/thrash/checkm_outputs/{}".format(file)) as f:
        lines = f.readlines()
        lines = lines[3:-1]
        
        for line in lines:
            tokens = line.split()
            dict["Bin Id"].append(tokens[0])
            dict["Marker lineage"].append("{} {}".format(tokens[1], tokens[2]))
            dict["# genomes"].append(tokens[3])
            dict["# markers"].append(tokens[4])
            dict["# marker sets"].append(tokens[5])
            dict["0"].append(tokens[6])
            dict["1"].append(tokens[7])
            dict["2"].append(tokens[8])
            dict["3"].append(tokens[9])
            dict["4"].append(tokens[10])
            dict["5+"].append(tokens[11])
            dict["completeness"].append(str(tokens[12]))
            dict["contamination"].append(str(tokens[13]))
            dict["Strain heterogeneity"].append(str(tokens[14]))
            dict["quality_metric"].append(float(tokens[12])-float(tokens[13])*5)
            if float(tokens[12]) > 90 and float(tokens[13]) < 5:
                counth = counth + 1
            if float(tokens[12]) >= 50 and float(tokens[13]) < 10:
                countm = countm + 1
            if float(tokens[12]) >= 50 and float(tokens[13]) < 10 and tokens[1] == "c__Alphaproteobacteria":
                countl = countl + 1
            if float(tokens[12]) > 90 and float(tokens[13]) < 5 and tokens[1] == "c__Alphaproteobacteria":
                countx = countx + 1
            count = count + 1
            

data = pd.DataFrame(dict)
data_300 = data.nlargest(300, "quality_metric")

data_300.to_csv("/Users/connerkojima/thrash/300_best.csv")

print(counth)
print(countm)
print(countl)
print(countx)
print(count)