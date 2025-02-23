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

// Modify longstitch to test different kmer and window sizes
include { run_longstitch as longstitch1 } from './modules/longstitch.nf'
include { run_longstitch as longstitch2 } from './modules/longstitch.nf'
include { run_longstitch as longstitch3 } from './modules/longstitch.nf'

include { run_longstitch as longstitch4 } from './modules/longstitch.nf'
include { run_longstitch as longstitch5 } from './modules/longstitch.nf'
include { run_longstitch as longstitch6 } from './modules/longstitch.nf'

include { run_longstitch as longstitch7 } from './modules/longstitch.nf'
include { run_longstitch as longstitch8 } from './modules/longstitch.nf'
include { run_longstitch as longstitch9 } from './modules/longstitch.nf'

// Define workflow
workflow {
    
    Channel.fromPath(params.fastq)
        .set { fastq_ch }

    // Run de novo assembly!
    //def canu = run_hicanu(fastq_ch)

    Channel.fromPath("obtusa_hifi/genome/obtusa_hifi/obtusa.contigs.fasta")
        .set { draft_ch }

    // Run scaffolder! Testing for optimal kmer + window sizes
    longstitch1(draft_ch, fastq_ch, "k_ntLink=24 w=100")
    longstitch2(draft_ch, fastq_ch, "k_ntLink=32 w=100")
    longstitch3(draft_ch, fastq_ch, "k_ntLink=40 w=100")

    // Window 250 bps
    longstitch4(draft_ch, fastq_ch, "k_ntLink=24 w=250")
    longstitch5(draft_ch, fastq_ch, "k_ntLink=32 w=250")
    longstitch6(draft_ch, fastq_ch, "k_ntLink=40 w=250")

    // Window 500 bps
    longstitch7(draft_ch, fastq_ch, "k_ntLink=24 w=500")
    longstitch8(draft_ch, fastq_ch, "k_ntLink=32 w=500")
    longstitch9(draft_ch, fastq_ch, "k_ntLink=40 w=500")

}
