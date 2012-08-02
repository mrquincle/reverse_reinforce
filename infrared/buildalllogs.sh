#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

# Only the logs that are splitted
files=$working_path/*.split.log

for f in $files
do
	./compare.sh $working_path $f
	./data2svmlight.sh $working_path
done

datafiles=$working_path/*.dat

result=$working_path/svmlight.dat

rm -f $result
rm -f $working_path/svmlight*.dat

# Replace qid:X mask with id's
id=1
for f in $datafiles
do
#	echo "Command: sed -i \"s/qid:X/qid:$id/\" $f"
	sed -i "s/qid:X/qid:$id/" $f
	id=$(($id + 1))
	cat $f >> $result
done

rm $working_path/*.dattmp
rm $working_path/*.tmp

echo "Result can be found in $result (of which the last part is): "
tail $result
