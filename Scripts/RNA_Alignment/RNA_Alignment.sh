#!/bin/bash
#SBATCH -p intelsong
#SBATCH --mem=8g
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J RNA_Alignment
#SBATCH -D /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Scripts/RNA_Alignment
#SBATCH -o /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/RNA_Alignment/RNA_Alignment-%A_%a.out
#SBATCH -e /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/RNA_Alignment/RNA_Alignment-%A_%a.error
#SBATCH --mail-user alanluu2@illinois.edu
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --array 1-50

INDEX_PATH="/home/mirror/igenome/Homo_sapiens/UCSC/hg38/Sequence/Bowtie2Index/genome"
INPUT_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Trimmed_53_FastQ"
OUTPUT_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/RNA_Alignment"
FILE_ARR=($(ls $INPUT_PATH | grep -i .*_[1,2]_.*_.*_53T_R[1,2].fastq | sed 's/_53T_R[1,2].fastq//g' | uniq ))
N=$SLURM_ARRAY_TASK_ID
EXP=${FILE_ARR[N-1]}

module load Bowtie2/2.3.2-IGB-gcc-4.9.4
module load TopHat/2.1.1-IGB-gcc-4.9.4

mkdir -p $OUTPUT_PATH/${EXP}

if [ "$N" = "1" ]
then
  I="1"
  for FILE in ${FILE_ARR[*]}
  do
    echo "${I}:${FILE}" >> ${OUTPUT_PATH}/index.txt
    I=$(( $I + 1 ))
  done
fi

tophat -o $OUTPUT_PATH/${EXP} $INDEX_PATH ${INPUT_PATH}/${EXP}_53T_R1.fastq ${INPUT_PATH}/${EXP}_53T_R2.fastq
