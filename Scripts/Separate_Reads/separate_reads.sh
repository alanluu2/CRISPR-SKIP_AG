#!/bin/bash
#SBATCH -p intelsong
#SBATCH --mem=16g
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J Separate_Reads-%A_%a
#SBATCH -D /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Scripts/Separate_Reads
#SBATCH -o /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/Separate_Reads/Separate_Reads-%A_%a.out
#SBATCH -e /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Logs/Separate_Reads/Separate_Reads-%A_%a.error
#SBATCH --mail-user alanluu2@illinois.edu
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --array 1-10

SUMMARY_PATH='/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Summary/Separate_Reads/'

module load Python/3.6.1-IGB-gcc-4.9.4
module load Biopython/1.68-IGB-gcc-4.9.4-Python-3.6.1

ARR=($(ls /home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/FastQ | sed 's/_R[1,2].fastq//g' | uniq))
N=$SLURM_ARRAY_TASK_ID
EXP=${ARR[N-1]}

python separate_reads.py ${EXP} ${SUMMARY_PATH}${EXP}_summary.txt \
'/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/FastQ' \
'/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Separated_FastQ'
