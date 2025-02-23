# *Daqhnia obtusa Genome Assembly Pipeline*

- This pipeline performs de novo genome assembly using HiCanu and integrates with nf-core/pairgenomealign for downstream analysis.

## Prerequisites
-   Nextflow
-   Slurm environment
-   Miniforge
-   nf-core

## Setup

1.  Clone the repository:

    ```bash
    git clone https://github.com/connor122721/obtusa
    cd obtusa
    ```

## Running the Pipeline

### 1. De Novo Assembly with HiCanu

To run the de novo assembly pipeline, use the following command:

```bash
nextflow run main.nf -profile slurm
```

This command executes the `main.nf` script using the Slurm profile defined in `nextflow.config`. The pipeline will:

1.  Read HiFi reads from the specified FASTQ file.
2.  Perform genome assembly using HiCanu.
3.  Output the assembled genome to the `obtusa_hifi/genome` directory.

### 2. Downloading Genomes from NCBI

To download genomes using the `download_NCBI` module, execute the `modules/download.nf` script:

```bash
nextflow run modules/download.nf -profile slurm
```

This will download genomes based on the species list provided in `params.species_list` in the `nextflow.config` file and place the output in the `obtusa_hifi/ncbi` directory.

### 3. Running nf-core/pairgenomealign

After downloading the necessary genomes, you can run the nf-core/pairgenomealign pipeline for comparative genomics analysis.

#### 3.1. Prepare Input

nf-core/pairgenomealign requires a specific input format. Create a CSV file:

```csv
sample,fasta
sample1,/path/to/reference.fasta(or fna)
sample2,/path/to/reference.fasta(or fna)
```

#### 3.2. Execute nf-core/pairgenomealign

Run the nf-core/pairgenomealign pipeline using the following command:

```bash
nextflow run nf-core/pairgenomealign \
    -r 1.0.0 \
    -profile slurm,apptainer \
    --input samplesheet.csv \
    --target obtusa_hifi/genome/obtusa_hifi/obtusa.contigs.fasta \
    --outdir obtusa_hifi/ \
    -c nextflow.config
```

After running the scaffolding software, longstitch, test the alignment again: 

```bash
nextflow run nf-core/pairgenomealign \
    -r 1.0.0 \
    -profile slurm,apptainer \
    --input samplesheet.csv \
    --target obtusa_hifi/longstitch/obtusa_draft.k32.w100.tigmint-ntLink.longstitch-scaffolds.fa \
    --outdir obtusa_hifi_scaffold/ \
    -c nextflow.config
```

## Configuration

The `nextflow.config` file contains various parameters that can be adjusted.