process map_reads {

    label 'process_high'
    shell = '/usr/bin/env bash'
    publishDir "${params.outdir}/mapping", mode: 'copy'

    input:
        path reads
        path genome

    output:
        path "*.bam", emit: bam

    script:
    """
    module load apptainer
    module load samtools

    cp ${genome} genome.fa
    cp ${reads} reads.fq.gz

    apptainer exec docker://nanozoo/minimap2:2.28--9e3bd01 \\
        minimap2 -ax map-hifi \\
        -t ${params.threads} genome.fa reads.fq.gz | \\
        samtools view -Sb - | \\
        samtools sort -@ ${params.threads} -o aligned.sorted.bam
    samtools index aligned.sorted.bam
    """
}

// Define workflow
workflow {
    
    Channel.fromPath(params.fastq)
        .set { fastq_ch }

    Channel.fromPath("obtusa_hifi/ncbi/cds/algae.genomic.fna")
        .set { genome_ch }

    // Run scaffolder! Testing for optimal kmer + window sizes
    map_reads(fastq_ch, genome_ch)

}