#!/bin/bash
#SBATCH -p intelsong
#SBATCH --mem=8g
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J RNA_Sort
#SBATCH -D /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Scripts/RNA_Sort
#SBATCH -o /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/RNA_Sort/RNA_Sort-%A_%a.out
#SBATCH -e /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/RNA_Sort/RNA_Sort-%A_%a.error
#SBATCH --mail-user alanluu2@illinois.edu
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --array 1-50

INPUT_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/RNA_Alignment"
OUTPUT_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/RNA_Sorted"
FOLDER_ARR=($(ls $INPUT_PATH | grep .*_[1,2]_.*_.*))
N=$SLURM_ARRAY_TASK_ID
EXP=${FOLDER_ARR[N-1]}

mkdir -p $OUTPUT_PATH
module load SAMtools/1.7-IGB-gcc-4.9.4

samtools sort -O bam -o ${OUTPUT_PATH}/${EXP}.sorted.bam ${INPUT_PATH}/${EXP}/accepted_hits.bam
samtools index -b ${OUTPUT_PATH}/${EXP}.sorted.bam
