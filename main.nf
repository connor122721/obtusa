// Nextflow pipeline for de novo assembly
nextflow.enable.dsl=2

// Run de novo assembly with HiCanu
process run_hicanu {

    shell = '/usr/bin/env bash'
    publishDir "${params.outdir}/genome", mode: 'copy'
    threads = 20
    memory = '100 GB'

    input:
        path fastq

    output:
        path "*", emit: assembly_dir

    script:
    """
    module load miniforge/24.3.0-py3.11
    conda activate hicanu

    canu \\
        -assemble \\
        -p ${params.assemblyId} \\
        -d ${params.outdir} \\
        maxThreads=20 \\
        maxMemory=100g \\
        useGrid=false \\
        genomeSize=${params.genomeSize} \\
        -pacbio-hifi \\
        ${fastq}
    """
}

// Define workflow
workflow {
    
    Channel.fromPath(params.fastq)
        .set { fastq_channel }

    // Run de novo assembly!
    run_hicanu(fastq_channel)
}
