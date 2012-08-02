#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

# Remove temporary stuff
rm -f $working_path/*dat.tmp
rm -f $working_path/*dattmp
rm -f $working_path/*split.*.tmp

# Remove the splitted logs (not the original ones of course)
rm -f $working_path/*split.log
rm -f $working_path/*split_*.log

# Remove the files with the raw data (just the sensor values)
rm -f $working_path/*split_*.data
rm -f $working_path/*split.data
rm -f $working_path/*.data

# Remove the files with the data written in the format liked by SVM light
rm -f $working_path/*split.dat

# Remove the results of SVM light
rm -f $working_path/svmlight*.dat

# Remove the pictures
rm -f $working_path/*split.png
rm -f $working_path/*.png

