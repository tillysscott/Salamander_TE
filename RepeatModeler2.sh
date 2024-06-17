#!/bin/bash

#SBATCH --time=120:00:00
#SBATCH -c 40
#SBATCH --mem 80G
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH -p uoa-compute

###########################################
# RepeatModeler2 to generate TE library from Ambystoma mexicanum (axolotl) whole genome assembly
# Using optional LTRStruct programme
# Will generate ${genome}-families.fa for next steps
###########################################

## SET UP
export genome="axolotl"
module load repeatmodeler
#expect perl errors

## BUILD DATABASE
BuildDatabase -name $genome $genome.fa

## RUN REPEATMODELER2
RepeatModeler -database $genome -LTRStruct  -pa 40

##-recoverDir $RM_directory
