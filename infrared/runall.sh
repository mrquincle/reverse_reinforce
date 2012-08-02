#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

# Clean results from previous time
./cleanall.sh $working_path

# Split the original logs, etc.
./splitall.sh $working_path

# Create all the data files for the SVM from the splitted logs
./buildalllogs.sh $working_path

# Run the SVM (this also splits the dataset properly in a training and testing part)
./svm.sh $working_path

# Show the performance in the form of a plot
./performance.sh $working_path

echo "Done!"
