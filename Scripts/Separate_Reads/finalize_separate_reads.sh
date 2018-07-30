#!/bin/bash

SUMMARY_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Summary/Separate_Reads/"

FILE_ARR=($(ls $SUMMARY_PATH | grep -v separation_summary.txt))

for FILE in ${FILE_ARR[*]}
do
  cat ${SUMMARY_PATH}$FILE >> ${SUMMARY_PATH}separation_summary.txt
done
