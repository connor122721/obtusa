// Run de novo assembly with HiFiasm
process run_hifiasm {

    shell = '/usr/bin/env bash'
    publishDir "${params.outdir}/hifiasm", mode: 'copy'
    threads = 20
    memory = '100 GB'

    output:
        path "*", emit: gfa_files

    script:
        """
        module load apptainer

        # Run HiFiasm with parameters
        apptainer exec docker://dmolik/hifiasm:v1 hifiasm \\
            -o ${params.assemblyId} \\
            -t ${task.cpus} \\
            --dual-scaf \\
            ${params.fastq}
        """
}

// Define workflow
workflow {
    
    // Run de novo assembly!
    //def canu = run_hicanu(fastq_ch)
    def asm = run_hifiasm()
}