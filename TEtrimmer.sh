#!/bin/bash

#SBATCH --time=72:00:00
#SBATCH -c 10
#SBATCH --mem 100G
#SBATCH -p uoa-compute

#####################################
# Use TEtrimmer to curate TE library
## Input is RepeatModeler library
## More information at https://github.com/qjiangzhao/TEtrimmer/blob/main/docs/TEtrimmerv1.3.0Manual.pdf
#####################################

# Test run

# Set up
## load programme
module load <TEtrimmer>

## Set up variables and paths
export dir="tests/"
export TElib="test_input.fa"
export genome="test_genome.fasta"
export outdir="TEtrimmer_output"

## make output directory
mkdir $dir/$outdir

# Run TEtrimmer
python ./tetrimmer/TEtrimmer.py \
	-i $dir/$TElib \
	-g $dir/$genome \
	-o $dir/$outdir \
	--preset divergent \
	-t 10 --classify_all
#--continue_analysis
