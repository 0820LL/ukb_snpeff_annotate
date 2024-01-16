// Declare syntax version
nextflow.enable.dsl=2

process SNPEFF {

    container = "${projectDir}/../singularity-images/nfcore-snpeff-5.1.GRCh38.img"

    input:
    path vcf
    val db
    val prefix

    output:
    path "*.ann.vcf"
    path "*.csv"
    path "*.html"
    path "*.genes.txt"

    script:
    """
    snpEff "-Xmx36g" \\
        $db \\
        -nodownload -canon -v \\
        -csvStats ${prefix}.csv \\
        $vcf \\
        > ${prefix}.ann.vcf
    cp ${prefix}.ann.vcf ${launchDir}/${params.outdir}/
    cp ${prefix}.csv ${launchDir}/${params.outdir}/
    cp snpEff_summary.html ${launchDir}/${params.outdir}/
    cp ${prefix}.genes.txt ${launchDir}/${params.outdir}/
    """
}

workflow{
    vcf    = Channel.of(params.vcf_file)
    db     = Channel.of(params.db)
    prefix = Channel.of(params.prefix)
    SNPEFF(vcf, db, prefix)
}

