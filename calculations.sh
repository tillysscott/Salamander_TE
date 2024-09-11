#!/bin/bash


for num in $(cat numbers.txt)
do
	ls $num/$num_*.fa >> name.txt
	grep -c ">" $num/$num_*.fa >> total_loci.txt
	grep "LINE" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> LINE.txt
	grep "SINE" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> SINE.txt
	grep "LTR" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> LTR.txt
	grep "DNA" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> DNA.txt
	grep "RC" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> RC.txt
	grep "Crypton" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> Crypton.txt
	grep "Maverick" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> Maverick.txt
	grep "Unknown" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> Unknown.txt
	grep "Low_complexity" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> Low_complexity.txt
	grep "Simple_repeat" $num/05_full_out/$num.full_mask.out | awk '{print $5}' | sort | uniq | wc -l >> Simple_repeat.txt
	tail -n +4 $num/05_full_out/$num.full_mask.out | grep -v "Simple" | grep -v "Low" | awk '{print $5}' | sort | uniq | wc -l >> TE.txt
done


#outside of loop
paste name.txt \
	total_loci.txt \
	LINE.txt \
	SINE.txt \
	LTR.txt \
	DNA.txt \
	RC.txt \
	Maverick.txt \
	Crypton.txt \
	Unknown.txt \
	Low_complexity.txt \
	Simple_repeat.txt \
	TE.txt > all_data.txt

#percentage of all contigs that contain a TE order
##awk '{print $1, ($3/$2)*100, ($4/$2)*100, ($5/$2)*100, (($6-$8-$9)/$2)*100, ($7/$2)*100, ($8/$2)*100, ($9/$2)*100, ($10/$2)*100, ($11/$2)*100, ($12/$2)*100, ($13/$2)*100, (($11+$12)/$2)*100 }' \
##	all_data.txt > calculation.tbl

echo file LINE SINE LTR TIR Helitron Maverick Crypton Unknown Low_complexity Simple_repeat Total_TE Total_SR > header.txt

##cat header.txt calculation.tbl > TE_matrix.tbl

#percentage of total contigs with a repeat that contain a TE order
awk '{print $1, ($3/($11+$12+$13))*100, ($4/($11+$12+$13))*100, ($5/($11+$12+$13))*100, (($6-$8-$9)/($11+$12+$13))*100, ($7/($11+$12+$13))*100, ($8/($11+$12+$13))*100, ($9/($11+$12+$13))*100, ($10/($11+$12+$13))*100, ($11/($11+$12+$13))*100, ($12/($11+$12+$13))*100, ($13/($11+$12+$13))*100, (($11+$12)/($11+$12+$13))*100 }' \
        all_data.txt > percent_of_repeats.tbl

cat header.txt percent_of_repeats.tbl > Percent_Total_Reapeat_Matrix.tbl
