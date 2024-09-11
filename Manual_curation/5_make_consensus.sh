#!/bin/bash

#SBATCH -t 36:00:00
#SBATCH --mem 50G

########################################################
# Generate a consensus sequence from curted MSA -  from Manual Curation handbook
#######################################################

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
export PATH=$PATH:~/sharedscratch/apps/TE_ManAnnot/bin
export PATH=$PATH:~/sharedscratch/apps/pfam_scan

## Source miniconda3 installation and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate te_annot

## Set up variables and paths
export seq="ltr-1_family-4#LTR"

## Run emboss consensus sequence builder
cons -sequence edited_ind_seq/$seq.fa.maf.edit.fa -outseq consensus/$seq.consensus.fa 

## remove any N's
cat consensus/$seq.consensus.fa | tr -d 'n'

awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-13); next} 1' consensus/$seq.consensus.fa | sed 's/consensus\///g' > consensus/$seq.consensus_named.fa

# P3 predict domains with Pfam

getorf -sequence consensus/$seq.consensus_named.fa -outseq consensus/$seq.consensus_named.orf -minsize 300

# check if pfam has been run, otherwise run it
/uoa/home/r01ms21/sharedscratch/apps/pfam_scan/pfam_scan.py -out consensus/$seq.consensus_named.pfam.results consensus/$seq.consensus_named.orf \
	/uoa/home/r01ms21/sharedscratch/apps/Pfam_DB/

