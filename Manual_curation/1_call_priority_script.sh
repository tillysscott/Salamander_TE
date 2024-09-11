#!/bin/bash 

#SBATCH -t 36:00:00
#SBATCH --mem 50G

########################################################
# Call Protocol 0 from Manual Curation handbook
# Generate a priority table of TE families
# with number of BLAST hits in genome, TE length and encoded proteins
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

# call script
bash \
       ~/sharedscratch/apps/TE_ManAnnot/bin/generate_priority_list_from_RM2.sh \
       rm2-families.fa \
       chr.fasta \
       ~/sharedscratch/apps/Pfam_DB/ \
       ~/sharedscratch/apps/TE_ManAnnot/

#call script (bash)
#path to TE_ManAnnot/generate_priority_list_from_RM2.sh
#consensus RepMod library
#path to genome
#path to downloaded Pfam_DB
#path to TE_ManAnnot
