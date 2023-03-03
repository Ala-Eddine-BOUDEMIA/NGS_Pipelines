configfile: "config/config.yaml"

rule samtools:
    output:
        stats = expand("{dir}/QC/{samples}_stats.txt",
            dir=config['dir'], samples=config['samples']),
        flagstat = expand("{dir}/QC/{samples}_flagstats.txt",
            dir=config['dir'], samples=config['samples'])
    input:
        expand("{dir}/BAM/{samples}_F.bam", 
            dir=config['dir'], samples=config['samples'])
    threads:
        config["threads"]
    run:
        for i, os, of in zip(input, output.stats, output.flagstat):
            shell("samtools stats -@ {threads} {i} > {os}")
            shell("samtools flagstat -@ {threads} {i} > {of}")
