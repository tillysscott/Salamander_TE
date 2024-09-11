#!/bin/bash 

#SBATCH -t 36:00:00
#SBATCH --mem 50G
#SBATCH -c 1

########################################################
# Protocol 9 of Manual curation handbool
# use t-coffee to remove common gaps to impove later consensus building
# run on mafft alignment (output of Protocol 8) or on trimmed alignment from Allview
#######################################################

####
# set up
module load cdhit
module load blast-plus
module load bedtools2
module load checkm coordinatecleaner devtools seurat muscle
module load r
module load mafft
module load hmmer
module load perl-moose
module load biopython
module load samtools

export PATH=$PATH:~/sharedscratch/apps/TE_ManAnnot/bin
export PATH=$PATH:~/sharedscratch/apps/pfam_scan

## Source miniconda3 installation and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate te_annot

## set up variable and paths
export prefix="ltr-1_family-4#LTR.fa"

####
# Run t-coffee
t_coffee -other_pg seq_reformat -in $prefix.maf.trim.fa -action +rm_gap 80
