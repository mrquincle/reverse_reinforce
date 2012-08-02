#!/bin/bash

VERSION=0.1

checkdir() {

if [[ "$1" == "" ]]
then
	echo "No args supplied! Run $0 -h for more info"
	exit 1
fi

if [[ "$1" == "-V" ]]
then
	echo "$VERSION"
	exit 0
fi

if [[ "$1" == "-h" ]]
then
	echo "Version $VERSION - Usage:"
	echo "----------------------------------------"
	echo "  $0 \"path\""
	echo "----------------------------------------"
	echo "* path - The path where the logs or temporary files reside"
	exit 0 
fi
}

working_path=$1

export -f checkdir
