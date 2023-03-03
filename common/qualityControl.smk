configfile: "config/config.yaml"

rule Aligment_qc:
    output:
        expand("{dir}/QC/{samples}_ASM.txt",
            dir=config['dir'], samples=config['samples']),
    input:
        expand("{dir}/BAM/{samples}_F.bam", 
            dir=config['dir'], samples=config['samples'])
    run:
        for i, o in zip(input, output):
            shell("picard CollectAlignmentSummaryMetrics -I {i} -O {o}")