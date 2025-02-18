#!/usr/bin/env bash
#
#SBATCH -J run_hicanu # A single job name for the array
#SBATCH --ntasks-per-node=20 # multi core
#SBATCH -N 1 # on one node
#SBATCH -t 3-00:00 # 3 days
#SBATCH --mem 100G
#SBATCH -o /project/berglandlab/connor/err/run_hiCanu.out # Standard output
#SBATCH -e /project/berglandlab/connor/err/run_hiCanu.err # Standard error
#SBATCH -p standard
#SBATCH --account berglandlab

# Modules
module load miniforge/24.3.0-py3.11
conda activate hicanu

# Install canu once
# conda create -n hicanu
# module load mamba
# mamba install canu

# Fastq
fastq="/project/berglandlab/Robert/HMWDNAElvis3/fastq/m84128_250121_222443_s2.hifi_reads.bc2104.fq.gz"

# Start
echo "Starting HiCanu"
date

# Run HiCanu
canu \
-assemble \
-p obtusa \
 -d obtusa_hifi \
 maxThreads=20 \
 maxMemory=100g \
 useGrid=false \
 genomeSize=180m \
 -pacbio-hifi \
 ${fastq}

# Finish
echo "Finish HiCanu"
date