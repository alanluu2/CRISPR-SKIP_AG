#!/bin/bash

SUMMARY_PATH='/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Summary/Separate_Reads/'

echo -n -e 'Sample\tTotal\tgDNA\tgDNA %\tUnclassified\t Unclassified %\tTotal RNA\tTotal RNA %' \
> ${SUMMARY_PATH}separation_summary.txt

for EXON in 'CTNNA1_Ex7' 'HSF1_Ex11' 'JUP_Ex10' 'AHCY_Ex9' 'RAD51_Ex7'
do
  echo -n -e '\t'$EXON'\t'$EXON' %' >> ${SUMMARY_PATH}separation_summary.txt
done

echo '' >> ${SUMMARY_PATH}separation_summary.txt
