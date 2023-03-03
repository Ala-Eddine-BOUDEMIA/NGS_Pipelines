configfile: "config/config.yaml"

rule compress_sam:
    output:
        expand("{dir}/SAM/{samples}.sam.tar.gz",  
            dir=config['dir'], samples=config['samples'])
    input:
        expand("{dir}/SAM/{samples}.sam",  
            dir=config['dir'], samples=config['samples'])
    params:
        expand("{dir}/SAM", dir=config['dir'])
    run:
        for i, o in zip(input, output):
            p = i.split("/")[-1]
            shell("tar -czf {o} -C {params[0]} {p}")