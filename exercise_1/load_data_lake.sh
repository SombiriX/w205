#!/bin/bash

# Working vars, can also pass positional args to replace
# Defaults assume script is called from the directory containing
# the unzipped hospital data directory.
work_dir=${1:-Hospital_Revised_Flatfiles}
o_dir=${2:-"processed_files"}
hdfs_path=${3:-"/user/w205/hospital_compare"}
start_dir=$(pwd)

echo
echo "INPUT DIR: "$work_dir
echo "OUTPUT DIR: "$work_dir"/"$o_dir

#su - w205
cd ./$work_dir

echo
echo "Renaming hospital data files and stripping CSV headers"

fn1="Hospital*General*Information"
fn2="Timely*and*Effective*Care"
fn3="Readmissions*and*Deaths"
fn4="Measure*Dates"
fn5="hvbp*hcahps"

# Replace filename spaces with underscores
for filename in *\ *; do 
	mv "$filename" "${filename// /_}";
done | sh

# Create output directory
if [ ! -d "$o_dir" ]; then
	mkdir ${o_dir}
fi

# Simplify filenames and strip CSV headers
for filename in $fn1*csv; do
	tail -n +2 $filename > ${o_dir}/${filename//$fn1/hospitals};
done | sh
for filename in $fn2*csv; do
	tail -n +2 $filename > ${o_dir}/${filename//$fn2/effective_care};
done | sh
for filename in $fn3*csv; do
	tail -n +2 $filename > ${o_dir}/${filename//$fn3/readmissions};
done | sh
for filename in $fn4*csv; do
	tail -n +2 $filename > ${o_dir}/${filename//$fn4/measures};
done | sh
for filename in $fn5*csv; do
	tail -n +2 $filename > ${o_dir}/${filename//$fn5/survey_responses};
done | sh


# Add output files to HDFS
cd ./$o_dir

hdfs dfs -mkdir ${hdfs_path}

for filename in *.csv; do
	hdfs dfs -put ${filename} ${hdfs_path}
done | sh

# Show contents of directory after completion
hdfs dfs -ls ${hdfs_path}