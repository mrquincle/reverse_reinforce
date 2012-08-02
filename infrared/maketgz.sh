#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

cd $working_path

echo "We clean some temporary files before"

# Remove the splitted logs
rm -f *split.log

# Remove the (temporary) data files
rm -f *split_*.data
rm -f *split.data
rm -f *.data

# Remove all .dat files except for the input for the SVM 
rm -f *split.dat

# Remove the pictures
# rm -f *.png

echo "We drop everything in a tar ball"

cd ..
tar -czvf result.tar.gz --exclude=*.log $working_path
