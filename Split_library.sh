#!/bin/bash

####
# set up environment
## Source miniconda3 installation and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate seqkit

## set up
export library="species1_species2.prefix.consensus"

## Split the library
cat ${library}.fa | seqkit fx2tab | grep -v "Unknown" | seqkit tab2fx > ${library}.known.fa
echo Known library generated: ${library}.known.fa

cat ${library}.fa | seqkit fx2tab | grep "Unknown" | seqkit tab2fx > ${library}.unknown.fa
echo Unknown library generated: ${library}.unknown.fa

####
#Check division worked ok
# quantify number of classified TE families
echo Number of classified TE families
grep -c ">" ${library}.known.fa
# quantify number of unknown TE families
echo Number of unknown TE families
grep -c ">" ${library}.unknown.fa
# quantify original number of TE families
echo original number of TE families
grep -c ">" ${library}.fa
