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
export prefix="rnd-4_family-292#LINE"
export outdir="MSA_loop"

mkdir $outdir

####
# call script to generate multi sequence fasta
for ind in $(cat ind_seq_list.txt)
do
	bash \
		~/sharedscratch/apps/TE_ManAnnot/bin/make_fasta_from_blast.sh \
		chr.fasta \
		ind_seq/$ind \
		0 500
	mv $ind.blast.bed.fa $outdir/$ind.blast.bed.fa
	mafft --reorder  --thread -3 $outdir/$ind.blast.bed.fa > $outdir/$ind.maf.fa
done


