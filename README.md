# CodeClinic

## Background -
I am using the variant prioritisation software Exomiser to analyse VCF files from patients with pitutiary adenomas. This software creates a ranked list of variants for each sample with the variant most likely to be pathogenic at the top. I have a total of 117 output files in total. I wanted to create a script which displays the information from all these files in one master file to make post analysis easier. 
The end result should look like the below image, with all the variants in the first column, then some extra information regarding gene symbol, variant class etc, then a column for every sample with either NA where the variant is not present or 0/1 if the sample contains that variant.
![image](https://github.com/evana010/CodeClinic/assets/61657803/0a325a70-ef16-4fb9-a1b5-6c260ccc7d66)

## Problem -
The R script works, however, I am not the most proficient in R and the script uses a very brute force approach. The main issue I am having is the amount of RAM required for this script to actually run. I have to requect around 150GB-200GB of RAM with 3 nodes for the script to even run, which usually means its queued in apocrita job submission for days. 
I would like any feedback or sujestions on how to make it run faster with less RAM usuage. I have provided the R script and some example Exomiser output files. 

Many Thanks :)


