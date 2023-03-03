configfile: "config/config.yaml"

rule markDups:
    output:
        bam = expand("{dir}/BAM/{samples}_F.bam",
            dir=config['dir'], samples=config['samples']),
        metrics = expand("{dir}/QC/{samples}_dup_metrics.txt",
            dir=config['dir'], samples=config['samples'])
    input:
        expand("{dir}/BAM/{samples}_sorted.bam", 
            dir=config['dir'], samples=config['samples'])
    run:
        for i, o, m in zip(input, output.bam, output.metrics):
            shell("picard MarkDuplicates --REMOVE_DUPLICATES true -I {i} -O {o} -M {m}")