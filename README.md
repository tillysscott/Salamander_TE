# Salamander
Salamander Project for Mark Urban's lab group

## Scripts
1. 	Make TE library with RepeatModeler2 with LTRStruct pipeline (RepeatModeler2.sh)  
2.	Run TE trimmer with divergent setting enabled on TE library (TEtrimmer.sh)  
3.	Run manual curation script 0 (Manual_curation/1_call_priority_script.sh) to generate a priority table with original TE consensus length, number of blast hits in genome and number of ORFs and PFam domains.  
4.	Join the priority table to TEtrimmer summary.txt, making axolotl-families_TEtrimmer-divergent_mancalc-priority.xlsx  
5.	Manually check TE-aid output from TEtrimmer for all ‘perfect’ and ‘good’ annotations. Make changes where necessary (recorded in ‘curation_notes’ column of xlsx), including choosing RMod consensus, changing classification in fasta header, manually curating the alignment (extension, trimming, separating merged elements/tandem repeats, removing gaps and sequences (Manual_curation/*)), or using TEtrimmer consensus sequence.  
6.	Then curate TE families with 5 or more pfam domains predicted and at least one good blast hit, using TEtrimmer output.  
7.	Library options: (made with collate_library.sh)  
	 a. TETrimmer output sequences that have been manually checked + RMod output for all others = “TeT_and_RMod_library.fa”. This library has more unknown elements  
	 b. Those that have been manually checked + TErimmer output (except those that were skipped by TETrimmer, use original RMod sequence for these elements) = “TeT_library.fa”. This library has more known elements.  
8.	Cd-hit-est using 80 80 80 rule (from (Goubert et al., 2022)) to cluster together sequences that are from the same family (*_library.reduced.fa; cdhit_mancur.sh)
9.	Split library into known and unknown elements (Split_library.sh)  
10.	Once have all individuals assembled and bias removed (if ok for pop gen should be ok for this)   
	a. run RepeatMasker iteratively (TE_prediction.sh) on individual fasta files (or on population level consensus fasta) as a task array  
	b. calculate (number of contigs with a TE family or simple repeat)/(number of contigs with a TE or repeat)  ×100 using calculations.sh  
	c. perform PCA  
