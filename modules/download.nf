// Process to download sequences
process download_NCBI {

    shell = '/usr/bin/env bash'
    publishDir "${params.outdir}/ncbi", mode: 'copy'
    errorStrategy 'ignore'

    input:
        path(ids_file)

    output:
        path("gtf/*")
        path("cds/*"), emit: genome

    script:
    """
    module load miniforge/24.3.0-py3.11
    source activate msprime_env

    python3 ${params.scripts_dir}/download_genomes.py \\
        --assembly_list ${ids_file} \\
        --out_dir downloads

    # Remove intermediate files
    rm downloads/*/*.gz

    # Get everything in the correct directories
    mkdir gtf
    mkdir cds

    mv downloads/*/*gtf gtf/
    mv downloads/*/*gff gtf/
    mv downloads/*/*cds_from_genomic.fna cds/
    mv downloads/*/*genomic.fna cds/
    """
}

// Define workflow
workflow {

    // Run download script
    download_NCBI(params.species_list)
}
