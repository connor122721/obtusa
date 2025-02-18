#!/usr/bin/env bash
#
#SBATCH -J nf_genome # Job name
#SBATCH --ntasks-per-node=20 # one core
#SBATCH -N 1 # on one node
#SBATCH -t 3-00:00 # days
#SBATCH --mem 100G
#SBATCH -o /project/berglandlab/connor/err/nf_genome.out # Standard output
#SBATCH -e /project/berglandlab/connor/err/nf_genome.err # Standard error
#SBATCH -p standard
#SBATCH --account berglandlab

# Modules to load
module load nextflow

# Run nextflow
nextflow run main.nf -profile slurm -resume
