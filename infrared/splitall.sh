#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

rm $working_path/*.split.log

files=$working_path/*.log

for f in $files
do
	./split.sh $working_path $f
done
