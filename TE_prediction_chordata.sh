#!/bin/bash

#SBATCH --time=48:00:00
#SBATCH -a 1-97
#SBATCH -c 20
#SBATCH --mem 48G
#SBATCH --partition=uoa-compute

##########################################################################################
# This script will run a task array on fasta files to itteratively mask TE and collate results
## Use on individual fastas or population level consensuses
## fasta files need to be names 1_name.fa, 2_name.fa etc.
#
# programmes required are RepeatMasker (on Xanadu)
##########################################################################################

#paths are set out to be run from 'ind_fa' directory

echo this is the slurm report of $SLURM_ARRAY_TASK_ID ${SLURM_ARRAY_TASK_ID}_*.fa

###
####   set up  ######

#conda activate seqkit

# ensure the TE library is in the directory where this script is run

mkdir -p $SLURM_ARRAY_TASK_ID

mv ${SLURM_ARRAY_TASK_ID}_*.fa ${SLURM_ARRAY_TASK_ID}/

export library="186-4Bathy_HironPB-families.prefix.cat.consensus"

#PATH=$PATH:~/sharedscratch/apps/TwoBit/

module load RepeatMasker/4.1.5

mkdir -p ${SLURM_ARRAY_TASK_ID}/logs ${SLURM_ARRAY_TASK_ID}/01_simple_out ${SLURM_ARRAY_TASK_ID}/02_Chordata_out ${SLURM_ARRAY_TASK_ID}/03_known_out ${SLURM_ARRAY_TASK_ID}/04_unknown_out ${SLURM_ARRAY_TASK_ID}/05_full_out
echo Directories generated: ${SLURM_ARRAY_TASK_ID}/logs ${SLURM_ARRAY_TASK_ID}/01_simple_out ${SLURM_ARRAY_TASK_ID}/02_Chordata_out ${SLURM_ARRAY_TASK_ID}/03_known_out ${SLURM_ARRAY_TASK_ID}/04_unknown_out ${SLURM_ARRAY_TASK_ID}/05_full_out ${SLURM_ARRAY_TASK_ID}/07_ParseRM_landscape


####
#Masking round 1
echo Masking Round 1

RepeatMasker -pa 20 -a -e ncbi -dir ${SLURM_ARRAY_TASK_ID}/01_simple_out -noint -xsmall \
	${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}_*.fa 2>&1 | tee ${SLURM_ARRAY_TASK_ID}/logs/01_simplemask.log

# rename outputs from previous round to something more informative
rename fa simple_mask ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_* #replace the string 'fa' with 'simple_mask'
rename .masked .masked.fa ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*
echo Outputs from simple repeats round renamed

#####
#Masking round 2 - homology based
echo Masking Round 2

RepeatMasker -pa 20 -a -e ncbi -s -dir ${SLURM_ARRAY_TASK_ID}/02_Chordata_out -nolow -species Chordata \
        ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*.simple_mask.masked.fa 2>&1 | tee ${SLURM_ARRAY_TASK_ID}/logs/02_Chordatamask.log

#rename outputs from previous round
# round 2: rename outputs
rename simple_mask.masked.fa Chordata_mask ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*
rename .masked .masked.fa ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*
echo Outputs from Chordata round renamed

#####
#Masking round 3: known de novo repeats
echo Masking Round 3

RepeatMasker -pa 20 -a -e ncbi -dir ${SLURM_ARRAY_TASK_ID}/03_known_out -nolow \
       -lib ${library}.known.fa \
       ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*.Chordata_mask.masked.fa 2>&1 | tee ${SLURM_ARRAY_TASK_ID}/logs/03_knownmask_sizeselected.log

#rename outputs from previous round
# round 2: rename outputs
rename  Chordata_mask.masked.fa known_mask ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*
rename .masked .masked.fa ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*
echo Outputs from known masking round renamed

#####
#Masking round 4: unknown de novo repeats
echo Masking Round 4

RepeatMasker -pa 20 -a -e ncbi -dir ${SLURM_ARRAY_TASK_ID}/04_unknown_out -nolow \
       -lib ${library}.unknown.fa        \
       ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*.known_mask.masked.fa 2>&1 | tee ${SLURM_ARRAY_TASK_ID}/logs/04_unknownmask.log

# round 4: rename outputs
rename known_mask.masked.fa unknown_mask ${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*
rename .masked .masked.fa ${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*
echo Outputs from unknown masking round renamed


####
# Tidy and generate outputs
echo Tidy and generate outputs:

#gzip .cat files as these are large
gzip ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*.simple_mask.cat
gzip ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*.Chordata_mask.cat
gzip ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*.known_mask.cat
gzip ${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*.unknown_mask.cat
echo mask.cat files gzipped

# combine full RepeatMasker result files - .cat.gz
cat ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*.simple_mask.cat.gz \
${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*.Chordata_mask.cat.gz \
${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*.known_mask.cat.gz \
${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*.unknown_mask.cat.gz \
> ${SLURM_ARRAY_TASK_ID}/05_full_out/${SLURM_ARRAY_TASK_ID}.full_mask.cat.gz
echo .cat.gz outputs concatenated to generate full_mask.cat.gz and added to ${SLURM_ARRAY_TASK_ID}/05_full_out

# combine RepeatMasker tabular files for all repeats - .out
cat ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*.simple_mask.out | tail -n +4 \
        <(cat ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*.Chordata_mask.out | tail -n +4) \
        <(cat ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*.known_mask.out | tail -n +4) \
        <(cat ${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*.unknown_mask.out | tail -n +4) \
        > ${SLURM_ARRAY_TASK_ID}/05_full_out/${SLURM_ARRAY_TASK_ID}.full_mask.out
echo tabular files combined and added to ${SLURM_ARRAY_TASK_ID}/05_full_out

# copy RepeatMasker tabular files for simple repeats - .out
cat ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*.simple_mask.out \
        > ${SLURM_ARRAY_TASK_ID}/05_full_out/${SLURM_ARRAY_TASK_ID}.simple_mask.out
echo simple repeats mask added to ${SLURM_ARRAY_TASK_ID}/05_full_out directory

# combine RepeatMasker tabular files for complex, interspersed repeats - .out
cat ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*.Chordata_mask.out \
        <(cat ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*.known_mask.out | tail -n +4) \
        <(cat ${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*.unknown_mask.out | tail -n +4) \
        > ${SLURM_ARRAY_TASK_ID}/05_full_out/${SLURM_ARRAY_TASK_ID}.complex_mask.out
echo .out file combined and added to ${SLURM_ARRAY_TASK_ID}/05_full_out

# combine RepeatMasker repeat alignments for all repeats - .align
cat ${SLURM_ARRAY_TASK_ID}/01_simple_out/${SLURM_ARRAY_TASK_ID}_*.simple_mask.align \
        ${SLURM_ARRAY_TASK_ID}/02_Chordata_out/${SLURM_ARRAY_TASK_ID}_*.Chordata_mask.align \
        ${SLURM_ARRAY_TASK_ID}/03_known_out/${SLURM_ARRAY_TASK_ID}_*.known_mask.align \
        ${SLURM_ARRAY_TASK_ID}/04_unknown_out/${SLURM_ARRAY_TASK_ID}_*.unknown_mask.align \
        > ${SLURM_ARRAY_TASK_ID}/05_full_out/${SLURM_ARRAY_TASK_ID}.full_mask.align
echo .align files combined and added to ${SLURM_ARRAY_TASK_ID}/05_full_out

####
# Process repeats with RMask
echo Process Repeats:
# resummarize repeat compositions from combined analysis of all RepeatMasker rounds
##will write output to same location as input
ProcessRepeats -a -species Chordata ${SLURM_ARRAY_TASK_ID}/05_full_out/${SLURM_ARRAY_TASK_ID}.full_mask.cat.gz  \
        2>&1 | tee ${SLURM_ARRAY_TASK_ID}/logs/08_processrepeats.log
