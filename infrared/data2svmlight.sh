#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

files=$working_path/*.tmp
temp_files=$working_path/*.dattmp

# Iterate over all logs
log_iteration=true

#if $log_iteration; then
#else
	rm -f $temp_files
#fi

id=1
for f in $files
do
	# File with all attributes (extension)
	fa=${f##*/}
	# File without extension
	fb=${fa%.*}
	# File with new name reflecting sensor type
	fn=$fb.dattmp

	idfile=$working_path/$fn

	#echo "Command: sed \"s/^/$id:/\" $f > $fn"
	sed "s/^/$id:/" $f > $idfile
	id=$(($id + 1))
	
	# Use sed instead of "tac" to reverse the entire file in place
#	sed -i '1!G;h;$!d' $fn
done

# Name for result file
#if $log_iteration; then
#	result=svmlight_combined.dat
#else
	fi=${fb%.*}
	result=$working_path/${fi}.dat
#fi

paste -d' ' $temp_files > $result

# Prepend
sed -i "s/^/qid:X /" $result

# Add line number
tempresultfile=$result.tmp
cat $result | tac | nl -s ' ' | tr -s ' ' | sed -e 's/^[ \t]*//' | tac > $tempresultfile

cp $tempresultfile $result

echo "Result for svmlight becomes"
head $result

#rm -f svmlight_recent.dat
#ln -s $result svmlight_recent.dat
