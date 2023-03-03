configfile: "config/config.yaml"

if config['data_type'] == 'PE':
    input_files = expand("{dir}/TRIMMED/{samples}.R{R}_val_{R}.fq.gz",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),
    output_html = expand("{dir}/QC/FASTQC/{samples}.R{R}_val_{R}_fastqc.html",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),
    output_zip = expand("{dir}/QC/FASTQC/{samples}.R{R}_val_{R}_fastqc.zip",
        dir=config['dir'], samples=config['samples'], R=['1', '2'])

elif config['data_type'] == 'SE':
    input_files = expand("{dir}/TRIMMED/{samples}_trimmed.fq.gz",
        dir=config['dir'], samples=config['samples']),
    output_html= expand("{dir}/QC/FASTQC/{samples}_fastqc.html",
        dir=config['dir'], samples=config['samples']),
    output_zip = expand("{dir}/QC/FASTQC/{samples}_fastqc.zip",
        dir=config['dir'], samples=config['samples'])

rule fastqc:
    output: output_html, output_zip
    input: input_files
    threads: config['threads']
    run:
        shell("mkdir -p {config[dir]}/QC/FASTQC/")
        shell("fastqc -t {threads} {input} -o {config[dir]}/QC/FASTQC")
