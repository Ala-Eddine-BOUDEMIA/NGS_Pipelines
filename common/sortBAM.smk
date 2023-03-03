configfile: "config/config.yaml"

rule sort_bam:
    output:
        temp(expand("{dir}/BAM/{samples}_sorted.bam",
            dir=config['dir'], samples=config['samples']))
    input:
        expand("{dir}/BAM/{samples}.bam", 
            dir=config['dir'], samples=config['samples'])
    threads: 
        config['threads']
    run:
        for i, o in zip(input, output):
            shell("samtools sort -l 9 -o {o} {i} -@ {threads}")