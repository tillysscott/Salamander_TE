#!/bin/bash

#SBATCH --time=24:00:00
#SBATCH -c 20
#SBATCH --mem 48G
#SBATCH --partition=uoa-compute

###
#set up
export genome="Urban_12_12_rainbow"
export library="axolotl-families"

#conda activate seqkit
PATH=$PATH:~/sharedscratch/apps/TwoBit/
module load repeatmasker

mkdir -p logs 01_simple_out 02_arthropoda_out 03_known_out 04_unknown_out 05_full_out 07_ParseRM_landscape
echo Directories generated: logs 01_simple_out 02_arthropoda_out 03_known_out 04_unknown_out 05_full_out 07_ParseRM_landscape


####
#Masking round 1
echo Masking Round 1

RepeatMasker -pa 20 -a -e ncbi -dir 01_simple_out -noint -xsmall ${genome}.fa 2>&1 | tee logs/01_simplemask.log

# rename outputs from previous round to something more informative
rename fa simple_mask 01_simple_out/${genome}* #replace the string 'fa' with 'simple_mask'
rename .masked .masked.fa 01_simple_out/${genome}*
echo Outputs from simple repeats round renamed

#####
#Masking round 2 - homology based
echo Masking Round 2

RepeatMasker -pa 20 -a -e ncbi -s -dir 02_arthropoda_out -nolow -species arthropoda \
        01_simple_out/${genome}.simple_mask.masked.fa 2>&1 | tee logs/02_arthropodamask.log

#rename outputs from previous round
# round 2: rename outputs
rename simple_mask.masked.fa arthropoda_mask 02_arthropoda_out/${genome}*
rename .masked .masked.fa 02_arthropoda_out/${genome}*
echo Outputs from arthropoda round renamed

#####
#Masking round 3: known de novo repeats
echo Masking Round 3

RepeatMasker -pa 20 -a -e ncbi -dir 03_known_out -nolow \
       -lib ${library}.known.fa \
       02_arthropoda_out/${genome}.arthropoda_mask.masked.fa 2>&1 | tee logs/03_knownmask_sizeselected.log

#rename outputs from previous round
# round 2: rename outputs
rename  arthropoda_mask.masked.fa known_mask 03_known_out/${genome}*
rename .masked .masked.fa 03_known_out/${genome}*
echo Outputs from known masking round renamed

#####
#Masking round 4: unknown de novo repeats
echo Masking Round 4

RepeatMasker -pa 20 -a -e ncbi -dir 04_unknown_out -nolow \
       -lib ${library}.unknown.fa        \
       03_known_out/${genome}.known_mask.masked.fa 2>&1 | tee logs/04_unknownmask.log

# round 4: rename outputs
rename known_mask.masked.fa unknown_mask 04_unknown_out/${genome}*
rename .masked .masked.fa 04_unknown_out/${genome}*
echo Outputs from unknown masking round renamed


####
# Tidy and generate outputs
echo Tidy and generate outputs:

#gzip .cat files as these are large
gzip 01_simple_out/${genome}.simple_mask.cat
gzip 02_arthropoda_out/${genome}.arthropoda_mask.cat
gzip 03_known_out/${genome}.known_mask.cat
gzip 04_unknown_out/${genome}.unknown_mask.cat
echo mask.cat files gzipped

# combine full RepeatMasker result files - .cat.gz
cat 01_simple_out/${genome}.simple_mask.cat.gz \
02_arthropoda_out/${genome}.arthropoda_mask.cat.gz \
03_known_out/${genome}.known_mask.cat.gz \
04_unknown_out/${genome}.unknown_mask.cat.gz \
> 05_full_out/${genome}.full_mask.cat.gz
echo .cat.gz outputs concatenated to generate full_mask.cat.gz and added to 05_full_out

# combine RepeatMasker tabular files for all repeats - .out
cat 01_simple_out/${genome}.simple_mask.out \
<(cat 02_arthropoda_out/${genome}.arthropoda_mask.out | tail -n +4) \
<(cat 03_known_out/${genome}.known_mask.out | tail -n +4) \
<(cat 04_unknown_out/${genome}.unknown_mask.out | tail -n +4) \
> 05_full_out/${genome}.full_mask.out
echo tabular files combined and added to 05_full_out

# copy RepeatMasker tabular files for simple repeats - .out
cat 01_simple_out/${genome}.simple_mask.out > 05_full_out/${genome}.simple_mask.out
echo simple repeats mask added to 05_full_out directory

# combine RepeatMasker tabular files for complex, interspersed repeats - .out
cat 02_arthropoda_out/${genome}.arthropoda_mask.out \
<(cat 03_known_out/${genome}.known_mask.out | tail -n +4) \
<(cat 04_unknown_out/${genome}.unknown_mask.out | tail -n +4) \
> 05_full_out/${genome}.complex_mask.out
echo .out file combined and added to 05_full_out

# combine RepeatMasker repeat alignments for all repeats - .align
cat 01_simple_out/${genome}.simple_mask.align \
02_arthropoda_out/${genome}.arthropoda_mask.align \
03_known_out/${genome}.known_mask.align \
04_unknown_out/${genome}.unknown_mask.align \
> 05_full_out/${genome}.full_mask.align
echo .align files combined and added to 05_full_out

####
#prep for parseRM
echo prep for parseRM

mv ${genome}.fa 07_ParseRM_landscape/${genome}.full_mask.fa
mv 05_full_out/${genome}.full_mask.align 07_ParseRM_landscape/${genome}.full_mask.align

