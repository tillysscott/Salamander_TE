#!/bin/bash

#SBATCH -t 36:00:00
#SBATCH --mem 50G
#SBATCH -c 3

########################################################
# Call Protocol 8 from Manual Curation handbook
# for a te familys consensus sequence extract all hits in genome
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
export TEfam="ind_seq/ltr-1_family-4#LTR.fa"
export prefix="ltr-1_family-4#LTR.fa"

####
# Run
## call script to generate multi sequence fasta
bash \
       ~/sharedscratch/apps/TE_ManAnnot/bin/make_fasta_from_blast.sh \
       chr.fasta \
      $TEfam \
      0 500

### call script (bash)
### path to TE_ManAnnot/bin/make_fasta_from_blast.sh
### path to genome.fa
### path to individual TE family fasta
### minimum blast hit length - setting to 0 means that minimum blast hit length will be half that of the query (e.g. query = 1000, min=500)
#### bp to extend either flank of blast hit

## perform alignment on .bed.fa
mafft --reorder  --thread -3 $prefix.blast.bed.fa > $prefix.maf.fa

