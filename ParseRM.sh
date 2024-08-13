#!/bin/bash

#SBATCH --time=24:00:00
#SBATCH -c 10
#SBATCH --mem 50G


#IN COMMAND LINE
#export genome="Abyssorchomene_rb"
#mkdir -p 07_ParseRM_landscape_100+
#mv ${genome}.fa 07_ParseRM_landscape_100+/${genome}.full_mask.fa
#mv 05_full_out_100+/${genome}.full_mask.align 07_ParseRM_landscape_100+/${genome}.full_mask.align
#mv 9C_parseRM.sh 07_ParseRM_landscape_100+/
#cd 07_ParseRM_landscape_100+/

export PATH=$PATH:~/sharedscratch/apps/Parsing-RepeatMasker-Outputs
export PERL5LIB=$PERL5LIB:/opt/software/uoa.2022-06-29/2019/conda/miniconda3-4.6/pkgs/perl-bioperl-core-1.007002-pl526_2/lib/site_perl/5.26.2
export genome="Urban_12_12_rainbow"


#allLen=`seqtk comp ${genome}.fa | datamash sum 2`;
#parseRM.pl -v -i 05_full_out/${genome}.full_mask.align -p -g ${allLen} -l 50,1 2>&1 | tee logs/06_parserm.log


parseRM.pl -v -i ${genome}.full_mask.align -p -f -l 50,1 2>&1 | tee ../logs/06_parserm_100.log

#mv ${genome}.full_mask.fa ../${genome}.fa
#mv ${genome}.full_mask.align ../05_full_out/${genome}.full_mask.align
