#!/bin/bash

################################################################################

# Set the working path
source ./setdir.sh
checkdir $@

# Get all .log files
files=$working_path/*.log

# If the second argument contains files, use these instead of *.log
if [ $# -eq 2 ]; then
	files=$2
fi
echo "Check files: $files"

# Sensor types (0=ambient, 6=accelerometer, etc.)
SENSOR_TYPES=('ambient' 'reflection' 'proximity' 'docking' 'Ambient' 'RGB' 'Acceleration')
# Robot types (0=front)
ROBOT_SIDES=('front' 'left' 'rear' 'right')

# Select which sensor type it is gonna be
SENSOR_INDEX=1

# Select which sensor id it is gonna be (there are only two sensors)
# Remark: these two sensors occur 3 times after each other... this is under different lighting 
# conditions (with a different LED turned on)
sensor_id=0

# Select which robot side it is gonna be (front is 0)
ROBOT_SIDE_INDEX=2

# Iterate over all sensors
sensor_iteration=true

# Cutoff time series
timeseries_cutoff=false

# Time period starts at
timeseries_start_at=0

# Maximum time period
timeseries_cutoff_at=400

# Show in browser
show_in_browser=false

# Plot results
plot_results=false

################################################################################
# Create proper structures from given information
################################################################################

sensor_type="${SENSOR_TYPES[$SENSOR_INDEX]}"
robot_side="${ROBOT_SIDES[$ROBOT_SIDE_INDEX]}"

field=2
if [[ $sensor_type == reflection ]]; then
	echo "This is a reflection sensor, so we need field \"3\""
	field=3
fi

echo "Retrieve sensor data"
if $sensor_iteration ; then
	sensor_id_start=0
	sensor_id_stop=1
else
	sensor_id_start=$sensor_id
	sensor_id_stop=$sensor_id
fi

# Mask for temporary files
temp_files=$working_path/*.tmp

# Remove all temporary files from previous runs
rm -f $temp_files

################################################################################
# Start script body
################################################################################

for sensor_id in $(seq $sensor_id_start $sensor_id_stop); do 
	echo "Iterate over sensor: $sensor_id"
	if [ $SENSOR_INDEX -gt 3 ]; then
		echo "Make sensor id empty"
		sensor_id=""
		sensor_type_and_id="$sensor_type"
	else if $sensor_iteration ; then
		bracket_sensor_id="\[${sensor_id}\]"
		sensor_type_and_id="$sensor_type"
	else
	#	echo "Add square brackets around sensor id"
		bracket_sensor_id="\[${sensor_id}\]"
		sensor_type_and_id="${sensor_type}_${sensor_id}"
	fi
	fi
	for f in $files
	do
		# File with all attributes (extension)
		fa=${f##*/}
		# File without extension
		fb=${fa%.*}
		# File with new name reflecting sensor type
		fn=$(echo $fb | sed "s/sensors/$sensor_type/g").${sensor_id}.tmp	
		echo "Will print $sensor_type to $fn"

		sourcefile=$working_path/$fa
		rawfile=$working_path/$fn
#		head $fa
	
		# Extract sensor data
#		echo "Command: cat $fa | grep \"$robot_side\" | grep \"$sensor_type\" | grep \"${bracket_sensor_id}\" | cut -d':' -f3 | cut -d' ' -f\"$field\""
		cat $sourcefile | grep "$robot_side" | grep "$sensor_type" | grep "${bracket_sensor_id}" | cut -d':' -f3 | cut -d' ' -f"$field" > $rawfile
	#	cat $fa | grep "$robot_side" | grep "$sensor_type" | grep "${bracket_sensor_id}" | head -n 10
		file_size=$(du $rawfile | awk '{print $1}');
    		if [ $file_size == 0 ]; then
			echo "File $rawfile is empty! Adjust your grep commands... Exit!"
			exit
		fi
	done
done

################################################################################
# Now merge the data extracted before
################################################################################

echo "Get file with maximum number of lines"
#   tr -s ' ' removes duplicate spaces
#   removes "total" if it is the last word in a line (wc always has this line)
#      this is better than an ignorant "head -n -1" because this will fail to output anything when temp_files is 1 file (no total)
#   cut -d' ' -f2 skips the remaining space at the beginning
#   sort on size
#   tail -n1 get the biggest (last in the row)
#echo "Command: wc -l $temp_files | tr -s ' ' | sed -e 's/^[ \t]*//' | grep -v total$ | cut -d' ' -f1 | sort -n | tail -n1"
max_nr_lines=$(wc -l $temp_files | tr -s ' ' | sed -e 's/^[ \t]*//' | grep -v total$ | cut -d' ' -f1 | sort -n | tail -n1)
#echo "Maximum number of lines: $max_nr_lines"

# What is a smart strategy to append N lines with a certain string "0" in this case to a file?
#zeros=zeros.tmp # use dd to fill it?
#sed -e "${to_print}q" $zeros >> $f

echo "Append sensor data with zeros so all columns are at the same length"
for f in $temp_files
do
	nr_lines=$(wc -l $f | cut -d' ' -f1)
	to_print=$(($max_nr_lines - $nr_lines + 1))
#	echo "Lines to print: $to_print"
	for i in $(seq $to_print); do 
		echo "0" >> $f
	done
done

result=$working_path/${fb}_${sensor_type_and_id}.data

# Merge all columns 
paste $temp_files > $result

if $timeseries_cutoff ; then
#	sed -i "${timeseries_start_at}q" $result
	sed -i "1,${timeseries_start_at}d" $result
#	sed -e :a -e "\$q;N;${timeseries_start_at},\$D;ba" $result
fi

# Cutoff time series (just for convenience sake)
if $timeseries_cutoff ; then
#	echo "Command: sed -i \"${timeseries_cutoff_at},\$d\" $result"
	sed -i "${timeseries_cutoff_at},\$d" $result
fi

################################################################################
# Show the results
################################################################################

# Plot results at all or not
if $plot_results ; then
	extension=png

	echo "Plot using octave (see octave.txt for warnings/errors)"
	octave plotsensors.m ${result} ${sensor_type_and_id} $extension > $working_path/octave.txt

	# Show result in browser
	if $show_in_browser ; then
		browser=google-chrome
	
		#echo $browser ${fb}_${sensor_type_and_id}.${extension}
		$browser $working_path/${fb}_${sensor_type_and_id}.${extension}
	fi
fi

