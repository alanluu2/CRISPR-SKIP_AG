#!/bin/bash

IN_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Separated_FastQ"
LOG_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/Quality_Trim"

FILE_ARR=($(ls $IN_PATH/*_[1,2]_*_*_R[1,2].fastq | xargs -n 1 basename | sed 's/_R[1,2].fastq//g' | uniq))
N=1

echo -n > ${LOG_PATH}/index_c.txt

for FILE in ${FILE_ARR[*]}
do
  echo "${N}:${FILE}" >> ${LOG_PATH}/index_c.txt
  N=$(($N + 1))
done
