#!/bin/bash 

module load cdhit
module load blast-plus
module load bedtools2
module load checkm coordinatecleaner devtools seurat muscle
module load r
module load mafft
module load hmmer
module load perl
module load biopython
export PATH=$PATH:~/sharedscratch/apps/TE_ManAnnot/bin
export PATH=$PATH:~/sharedscratch/apps/pfam_scan

## Source miniconda3 installation and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate te_annot


##########################################################
# Protocol 7 - manual curation handbook .docx
##########################################################

#set directort and file name variable
export reduced="cdhit"
export outdir="ind_seq"

#make directory for output
#mkdir -p $outdir

# run TE_ManAnnot/bin script fasta_multi_to_one_line.pl to change split line sequences onto one line
perl /uoa/home/r01ms21/sharedscratch/apps/TE_ManAnnot/bin/fasta_multi_to_one_line.pl \
	$reduced.fa > $reduced.onelineseq.fasta

# change / in headers to space, so that single TE fasta files in next step have functional non-path names
sed "s/\// /g" $reduced.onelineseq.fasta > $reduced.onelineseq_namechg.fasta

# use faSplit programme to spilt multi-TE fasta into single TE fasta
faSplit byname $reduced.onelineseq_namechg.fasta $outdir/
