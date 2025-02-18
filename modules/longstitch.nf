// Make scaffolds from long reads using longstitch
process run_longstitch {

    label 'process_high'
    shell = '/usr/bin/env bash'
    publishDir "${params.outdir}/longstitch", mode: 'copy'

    input:
        path draft
        path reads

    output:
        path "*", emit: longstitch_dir

    script:
    """
    module load apptainer

    cp ${draft} obtusa_draft.fa

    apptainer run ${params.sifs_dir}/longstitch_latest.sif \\
        longstitch run \\
        draft=obtusa_draft.fa \\
        reads=${reads} \\
        t=${params.threads} \\
        G=${params.genomeSize} \\
        longmap=hifi
    """
}

// Define workflow
workflow {
    
    Channel.fromPath(params.fastq)
        .set { fastq_ch }

    Channel.fromPath("obtusa_hifi/genome/obtusa_hifi/obtusa.contigs.fasta")
        .set { draft_ch }

    // Run de novo assembly!
    run_longstitch(draft_ch, fastq_ch)
}
