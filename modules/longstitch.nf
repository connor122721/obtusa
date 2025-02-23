// Make scaffolds from long reads using longstitch
process run_longstitch {

    label 'process_high'
    shell = '/usr/bin/env bash'
    publishDir "${params.outdir}/longstitch", mode: 'copy'

    input:
        path draft
        path reads
        val input_settings

    output:
        path "longstitch*/*", emit: longstitch_dir

    script:
    """
    module load miniforge/24.3.0-py3.11
    conda activate hicanu

    cp ${draft} obtusa_draft.fa
    cp ${reads} obtusa_reads.fq.gz

    longstitch \\
        tigmint-ntLink-arks \\
        draft=obtusa_draft \\
        reads=obtusa_reads \\
        t=${params.threads} \\
        G=180000000 \\
        longmap=hifi \\
        ${input_settings}

    # Move all output
    kset=\$(echo ${input_settings} | sed 's/=/ /g')
    k=\$(echo \${kset} | cut -f2 -d " ")
    w=\$(echo \${kset} | cut -f4 -d " ")
    echo \${k} \${w}
    mkdir longstitch_k\${k}_w\${w}/
    mv * longstitch_k\${k}_w\${w}/
    """
}
