#!/bin/bash

# Set the working path
source ./setdir.sh
checkdir $@

# Show in browser
show_in_browser=true

# Plot results
plot_results=true

testfile=$working_path/test.tmp

testfile_input=$working_path/svmlight_test.dat

cat $testfile_input | cut -f1 -d' ' > $testfile

result=$working_path/prediction_comparison.data

predictionfile=$working_path/svm_predictions

paste $testfile $predictionfile > $result


octavelogfile=$working_path/octave.txt

title="Comparison prediction with test run"

# Plot results at all or not
if $plot_results ; then
	extension=png

	echo "Plot using octave (see octave.txt for warnings/errors)"
	octave plotsensors.m ${result} "${title}" $extension > $octavelogfile

	# Show result in browser
	if $show_in_browser ; then
		browser=google-chrome
		# File with all attributes (extension)
		fa=${result##*/}
		# File without extension
		fb=${fa%.*}

		picturefile=${fb}.png

		$browser $picturefile
	fi
fi

