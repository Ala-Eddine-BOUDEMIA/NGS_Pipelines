configfile: "config/config.yaml"

rule index_bam:
    output:
        expand("{dir}/BAM/{samples}_F.bam.bai", 
            dir=config['dir'], samples=config['samples'])
    input:
        expand("{dir}/BAM/{samples}_F.bam", 
            dir=config['dir'], samples=config['samples'])
    run:
        for i, o in zip(input, output):
            shell("samtools index -o {o} {i}")