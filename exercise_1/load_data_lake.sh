#!/bin/bash

# Working vars, can also pass positional args to replace defaults

work_dir=${1:-Hospital_Revised_Flatfiles}
o_dir=${2:-"processed_files"}
hdfs_path=${3:-"/user/w205/hospital_compare"}
start_dir=$(pwd)
RED='\x1B[1;31m'
GRN='\x1B[1;32m'
BLU='\x1B[1;34m'
NC='\x1B[0m' # No Color

echo
echo -e "${BLU}[INFO]${NC}: INPUT DIR: ${work_dir}"
echo -e "${BLU}[INFO]${NC}: OUTPUT DIR: ${work_dir}/${o_dir}"

wget_opts="-O${work_dir}.zip"

data_url="https://data.medicare.gov/views/bg9k-emty/files/Nqcy71p9Ss2RSBWDmP77H\
1DQXcyacr2khotGbDHHW_s?content_type=application%2Fzip%3B%20charset%3Dbinary&fil\
ename=Hospital_Revised_Flatfiles.zip"

# Download and unzip data files
if ! wget "${wget_opts}" "${data_url}"}; then
  echo
  echo -e "${RED}[ERROR]${NC}: Unable to download data."
  exit 1
fi

if ! rm -rf "${work_dir}"; then
  echo
  echo -e "${RED}[ERROR]${NC}: Could not access working directory."
  exit 1
fi

if ! mkdir "${work_dir}"; then
  echo
  echo -e "${RED}[ERROR]${NC}: Could not create working directory: ${work_dir}."
  exit 1
fi

if ! unzip "Hospital_Revised_Flatfiles.zip" "-d" "${work_dir}"; then
  echo
  echo -e "${RED}[ERROR]${NC}: Unable to unzip download data."
  exit 1
fi

if ! cd "./${work_dir}"; then
  echo
  echo -e "${RED}[ERROR]${NC}: Unable to cd to working directory."
  rm -rf "${work_dir}"
  rm -f "${work_dir}.zip"
  exit 1
fi

echo
echo -e "${BLU}[INFO]${NC}: Renaming hospital data files and stripping CSV headers"

fn1="Hospital*General*Information"
fn2="Timely*and*Effective*Care"
fn3="Readmissions*and*Deaths"
fn4="Measure*Dates"
fn5="hvbp*hcahps"
fn6="Complications"

# Replace filename spaces with underscores
for filename in *\ *; do 
	mv "$filename" "${filename// /_}";
done | sh

# Create output directory
if [ ! -d "$o_dir" ]; then
	mkdir "${o_dir}"
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
for filename in $fn6*csv; do
  tail -n +2 $filename > ${o_dir}/${filename//$fn6/complications};
done | sh


# Add output files to HDFS
if ! cd "./${o_dir}"; then
  echo
  echo -e "${RED}[ERROR]${NC}: Unable to cd to working directory."
  rm -rf "${work_dir}"
  rm -f "${work_dir}.zip"
  exit 1
fi

echo
echo -e "${BLU}[INFO]${NC}: Initializing HDFS path ${hdfs_path}"
echo -e "${BLU}[INFO]${NC}: Hang tight, it's still working."
hdfs dfs -rm -R "${hdfs_path}"
hdfs dfs -mkdir "${hdfs_path}"

echo
echo -e "${BLU}[INFO]${NC}: Adding csv files to HDFS path"
for filename in *.csv; do
	hdfs dfs -mkdir "${hdfs_path}/${filename//.csv/}"
	hdfs dfs -put "${filename}" "${hdfs_path}/${filename//.csv/}"
done | sh

# Show contents of directory after completion
echo
echo -e "${BLU}[INFO]${NC}: HDFS Path contents"
hdfs dfs -ls -R "${hdfs_path}"
echo
echo -e "${BLU}[INFO]${NC}: ${GRN}SUCCESS!!${NC}"
exit 0
