configfile: "config/config.yaml"

if config['data_type'] == "PE":
    fq_output = expand("{dir}/TRIMMED/{samples}.R{R}_val_{R}.fq.gz",
            dir=config['dir'], samples=config['samples'], R=['1', '2']),
    report_files = expand("{dir}/TRIMMED/{samples}.{R}.fastq.gz_trimming_report.txt",
        dir=config['dir'], samples=config['samples'], R=['R1', 'R2'])
    R1_files = expand("{dir}/FASTQ/{samples}/{samples}.R1.fastq.gz",
            dir=config['dir'], samples=config['samples']),
    R2_files = expand("{dir}/FASTQ/{samples}/{samples}.R2.fastq.gz",
        dir=config['dir'], samples=config['samples'])

elif config['data_type'] == "SE":
    fq_output = expand("{dir}/TRIMMED/{samples}/{samples}.fastq.gz",
        dir=config['dir'], samples=config['samples']),
    report_files = expand("{dir}/TRIMMED/{samples}.fastq.gz_trimming_report.txt",
        dir=config['dir'], samples=config['samples']),
    R1_files = expand("{dir}/FASTQ/{samples}/{samples}.fastq.gz",
        dir=config['dir'], samples=config['samples']),
    R2_files = ["Placeholder"]

rule trim_galore:
    output: 
        fq_output, 
        report_files
    input:
        R1 = R1_files,
        R2 = R2_files 
    threads: 
        2
    params: 
        config['dir']
    run:
        if config['data_type'] == "PE":
            for r1, r2 in zip(input.R1, input.R2):
                shell("trim_galore -j {threads} --paired -o {params}/TRIMMED {r1} {r2}")
        elif config['data_type'] == "SE":
            for r1 in input.R1:
                shell("trim_galore -j {threads} -o {params}/TRIMMED {r1}")