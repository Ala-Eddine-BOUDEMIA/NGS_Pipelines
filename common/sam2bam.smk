configfile: "config/config.yaml"

rule sam2bam:
    output:
        temp(expand("{dir}/BAM/{samples}.bam", 
            dir=config['dir'], samples=config['samples']))
    input:
        expand("{dir}/SAM/{samples}.sam",  
            dir=config['dir'], samples=config['samples'])
    threads: 
        config['threads']
    run:
        for i, o in zip(input, output):
            shell("samtools view {i} -bo {o} -@ {threads}")