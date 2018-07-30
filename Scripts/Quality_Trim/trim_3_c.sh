#!/bin/bash
#SBATCH -p intelsong
#SBATCH --mem=4g
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J Quality_Trim_c_3-%A_%a.out
#SBATCH -D /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Scripts/Quality_Trim
#SBATCH -o /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/Quality_Trim/Quality_Trim_c_3.%A_%a.out
#SBATCH -e /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/Quality_Trim/Quality_Trim_c_3.%A_%a.error
#SBATCH --mail-user alanluu2@illinois.edu
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --array 1-50

module load cutadapt/1.14-IGB-gcc-4.9.4-Python-2.7.13

IN_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Trimmed_5_FastQ"
OUT_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Trimmed_53_FastQ"
PRIMER_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Primers"
LOG_PATH="/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/Quality_Trim"

FILE_ARR=($(ls $IN_PATH/*_[1,2]_*_*_5T_R[1,2].fastq | xargs -n 1 basename | sed 's/_5T_R[1,2].fastq//g' | uniq))
N=$SLURM_ARRAY_TASK_ID
EXP=${FILE_ARR[N-1]}
EXON=$(echo $EXP | sed 's/.*_[1,2]_//g')

cutadapt -q 20 --pair-filter=any --minimum-length 50 \
--too-short-output ${OUT_PATH}/short_${EXP}_53T_R1.fastq \
--too-short-paired-output ${OUT_PATH}/short_${EXP}_53T_R2.fastq \
-a file:${PRIMER_PATH}/primers_${EXON}_fw_3.fasta \
-A file:${PRIMER_PATH}/primers_${EXON}_rev_3.fasta \
-o ${OUT_PATH}/${EXP}_53T_R1.fastq \
-p ${OUT_PATH}/${EXP}_53T_R2.fastq \
${IN_PATH}/${EXP}_5T_R1.fastq \
${IN_PATH}/${EXP}_5T_R2.fastq
