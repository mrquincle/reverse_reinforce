#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

# Input file
file=$working_path/svmlight.dat

# Output files
train=$working_path/svmlight_train.dat
test=$working_path/svmlight_test.dat

# Pick one qid for testing
id=16

cat $file | grep "qid:$id" > $test

cat $file | grep -v "qid:$id" > $train

training_size=$(wc -l $train | cut -f1 -d' ')
test_size=$(wc -l $test | cut -f1 -d' ')

echo "Create a training set of size: $training_size samples" 

echo "Create a test set of size: $test_size samples" 
