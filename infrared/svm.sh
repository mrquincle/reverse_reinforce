#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

# Add directory where the SVM light binaries reside to the path
PATH=$PATH:/opt/svm_light

echo "Make sure your PATH does contain the folder where svm_rank_learn and svm_rank_classify reside"

# Create training/testing set from data
#./leave2out.sh
./leave1setout.sh $working_path

# The file with the training data
trainfile=$working_path/svmlight_train.dat

# Test data
testfile=$working_path/svmlight_test.dat

MAX_REGUL_EXP=3
MIN_REGUL_EXP=$(( -$MAX_REGUL_EXP ))

verbosity=1

# Iterate over a series of values for the parameter "c" fo the SVM rank algorithm
# This "regularization" parameter denotes a trade-off between training error and margin (default = 0.01)
for regul_exponent in $(seq $MIN_REGUL_EXP $MAX_REGUL_EXP); do

	regul=`echo "10 ^ ($regul_exponent - 2)" | bc -l`
	modelfile=$working_path/model_$regul.txt

	echo "Train with the regularization parameter for the svm_rank_algorithm equal to $regul"
	svm_rank_learn -c $regul -v $verbosity $trainfile $modelfile

	echo "Test with test set (previously obtained by leave-1-out for example)"
	svm_rank_classify -v $verbosity $testfile $modelfile

	echo "Get weights from model file"
	perl svm2weight.pl $modelfile
done

mv svm_predictions $working_path
