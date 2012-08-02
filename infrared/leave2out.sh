#!/bin/bash

# Input file
file=svmlight.dat

# Output files
train=svmlight_train.dat
test=svmlight_test.dat

rm $train
rm $test

# Total number of training samples, before we test two
nr=20

# We do not do anything sophisticated here, we just test on regular intervals...
i=2
while read line; do
	pick1=$(( $i % $nr ))
	pick2=$(( ($i + 1) % $nr ))
	if [ $pick1 -eq 0 -o $pick2 -eq 0 ] ; then
		echo $line >> $test
	else
		echo $line >> $train
	fi
	
	i=$(($i+1))
done < "$file"

training_size=$(wc -l $train | cut -f1 -d' ')
test_size=$(wc -l $test | cut -f1 -d' ')

echo "Create a training set of size: $training_size samples" 

echo "Create a test set of size: $test_size samples" 
