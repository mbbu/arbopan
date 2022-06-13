nextflow.enable.dsl = 2

process combineFasta {
    publishDir "${params.outdir}/combined_sequences", mode: "${params.publish_dir_mode}"

    input:
        path sequences
    output:
        path "combined_sequences.fa"

    """
    cat $sequences > combined_sequences.fa
    sed -i.bak '/^\$/d' combined_sequences.fa
    """
}

process alignSequences {
    publishDir "${params.outdir}/aligned_sequences", mode: "${params.publish_dir_mode}"

    input:
        path combined_sequences
    output:
        path "aligned_sequences.fa"

    """
    mafft --thread ${params.threads} --auto --reorder $combined_sequences > aligned_sequences.fa
    """
}

process callVariants {
    publishDir "${params.outdir}/variants", mode: "${params.publish_dir_mode}"

    input:
        path aligned_sequences
    output:
        path "variants.vcf.gz"

    """
    snp-sites $aligned_sequences -v -o variants.vcf
    bgzip -c variants.vcf > variants.vcf.gz
    tabix -p vcf variants.vcf.gz
    """
}

process createGraph {
    publishDir "${params.outdir}/graph", mode: "${params.publish_dir_mode}"

    input:
        path aligned_sequences
        path variants
    output:
        path "graph.vg"
    """
    vg construct --msa $aligned_sequences -v $variants > graph.vg
    """
}

process visualizeGraph {
    publishDir "${params.outdir}/visualization", mode: "${params.publish_dir_mode}"

    input:
        path graph
    output:
        path "graph.gfa"
        path "graph.dot"

    """
    vg view $graph > graph.gfa
    vg view -d $graph > graph.dot
    """
}

workflow {
    Channel.fromPath(params.input).collect()
    | combineFasta
    | alignSequences
    | callVariants

    createGraph(alignSequences.out, callVariants.out)
    | visualizeGraph
}