#!/bin/bash 

#SBATCH -t 36:00:00
#SBATCH --mem 50G

########################################################
# n TE-Aid from Manual Curation handbook
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

## set variables
export seq="ltr-1_family-4#LTR"
export genome="chr.fasta"
export outdir="TE-aid-out"

# Run TE-Aid
/uoa/home/r01ms21/sharedscratch/apps/TE-Aid/TE-Aid -q consensus/$seq.consensus_named.fa -g $genome -o $outdir

## optional settings: -t (self dot-plot, protein hits) or -T (sample + genomic hits [can be large]) can be set. This is useful to further refine the results, estimate copy numbers, or get the precise coordinates of features such as TIRs and LTRs.
