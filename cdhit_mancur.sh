#!/bin/bash

#SBATCH --time=36:00:00
#SBATCH -c 8
#SBATCH --mem 100G

export prefix="TeT_library"

module load cdhit

cd-hit-est -i $prefix.fa -o $prefix.reduced.fa -T 8 -d 0 -aS 0.8 -c 0.8 -G 0 -g 1 -b 500 -M 2000
#these settings are from manual curation handbook protocol 2
