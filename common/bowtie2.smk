configfile: "config/config.yaml"

if config['data_type'] == 'PE':
    R1_files = expand("{dir}/TRIMMED/{samples}.R1_val_1.fq.gz",
        dir=config['dir'], samples=config['samples'])
    R2_files = expand("{dir}/TRIMMED/{samples}.R2_val_2.fq.gz",
        dir=config['dir'], samples=config['samples'])

elif config['data_type'] == 'SE':
    R1_files = expand("{dir}/TRIMMED/{samples}_trimmed.fq.gz",
        dir=config['dir'], samples=config['samples'])
    R2_files = ["Placeholder"]

rule bowtie2_mapping:
    output:
        temp(expand("{dir}/SAM/{samples}.sam", 
            dir=config['dir'], samples=config['samples']))
    input:
        R1 = R1_files,
        R2 = R2_files
    params:
        "../Reference/hg19/Bowtie2Index/hg19"
    threads: 
        config['threads']
    run:    
        if config['data_type'] == 'PE':
            for r1, r2, o in zip(input.R1, input.R2, output):
                shell("bowtie2 -p {threads} -x {params} -1 {r1} -2 {r2} -S {o}")
        elif config['data_type'] == 'SE':
            for r1, o in zip(input.R1, output):
                shell("bowtie2 -p {threads} -x {params} -U {r1} -S {o}")