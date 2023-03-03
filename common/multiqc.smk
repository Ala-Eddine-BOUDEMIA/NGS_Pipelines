configfile: "config/config.yaml"

if config['data_type'] == 'PE':
    fastqc_output_html = expand("{dir}/QC/FASTQC/{samples}.R{R}_val_{R}_fastqc.html",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),
    fastqc_output_zip = expand("{dir}/QC/FASTQC/{samples}.R{R}_val_{R}_fastqc.zip",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),
    trim_report_files = expand("{dir}/TRIMMED/{samples}.{R}.fastq.gz_trimming_report.txt",
        dir=config['dir'], samples=config['samples'], R=['R1', 'R2'])

elif config['data_type'] == 'SE':
    fastqc_output_html = expand("{dir}/QC/FASTQC/{samples}_fastqc.html",
        dir=config['dir'], samples=config['samples']),
    fastqc_output_zip = expand("{dir}/QC/FASTQC/{samples}_fastqc.zip",
        dir=config['dir'], samples=config['samples']),
    trim_report_files = expand("{dir}/TRIMMED/{samples}.fastq.gz_trimming_report.txt",
        dir=config['dir'], samples=config['samples'])

rule multiQC:
    output:
        dir = directory(expand("{dir}/QC/MULTIQC/", dir=config["dir"])),
        html = expand("{dir}/QC/MULTIQC/multiqc_report.html", dir=config["dir"]),
        multiqc_dir = directory(expand("{dir}/QC/MULTIQC/multiqc_data/", dir=config["dir"]))
    input:
        fastqc_output_html, fastqc_output_zip, trim_report_files,
        asm = expand("{dir}/QC/{samples}_ASM.txt",
                dir=config['dir'], samples=config['samples']),
        dups_metrics = expand("{dir}/QC/{samples}_dup_metrics.txt",
                dir=config['dir'], samples=config['samples']),
        stats = expand("{dir}/QC/{samples}_stats.txt",
            dir=config['dir'], samples=config['samples']),
        flagstat = expand("{dir}/QC/{samples}_flagstats.txt",
            dir=config['dir'], samples=config['samples'])
    run:
        shell('multiqc --config config/multiqc_config.yml -f {input} -o {output.dir[0]}')