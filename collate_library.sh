#!/bin/bash

### get the curated sequences from curated folder
#cat ../curated/manual_edits.fa ../curated/original.fa ../curated/rename.fa > curated_TE.fa

### get the original RMod sequences using list_RMods.txt, using input_name
#cat ../../axolotl-families.fa | seqkit fx2tab > axolotl-families.tab
#sed 's/rnd_/rnd-/g' list_RMods.txt | sed 's/family_/family-/g' > list2_RMods.txt

for seq in $(cat list2_RMods.txt)
do
	grep "${seq}#" axolotl-families.tab >> RMod_TE.tab
done

cat RMod_TE.tab | seqkit tab2fx > RMod_TE.fa

### get the TETrimmer sequences using list_TeTs.txt, using consensus_name
#cat ../../TEtrimmer_output_divergent/TEtrimmer_consensus.fasta | seqkit fx2tab > TEtrimmer_consensus.tab

for tseq in $(cat list_TeTs.txt)
do
	grep "${tseq}#" TEtrimmer_consensus.tab >> TETrimmer_TE.tab
done

cat TETrimmer_TE.tab | seqkit tab2fx > TETrimmer_TE.fa

### combine all 3
cat curated_TE.fa RMod_TE.fa TETrimmer_TE.fa > TeT_and_RMod_library.fa

### run cd-hit afterwards
