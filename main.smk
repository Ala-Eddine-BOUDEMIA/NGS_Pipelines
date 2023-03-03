configfile: "config/config.yaml"

include: "common/bowtie2.smk"
include: "common/compreSAM.smk"
include: "common/fastqc.smk"
include: "common/indexBAM.smk"
include: "common/markDups.smk"
include: "common/multiqc.smk"
include: "common/qualityControl.smk"
include: "common/sam2bam.smk"
include: "common/sortBAM.smk"
include: "common/trim_galore.smk"

if config['data_type'] == 'PE':
    fq = expand("{dir}/FASTQ/{samples}/{samples}.{R}.fastq.gz",
        dir=config['dir'], samples=config['samples'], R=['R1', 'R2']),

    trimmed_fq = expand("{dir}/TRIMMED/{samples}.R{R}_val_{R}.fq.gz",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),
    trimmed_report = expand("{dir}/TRIMMED/{samples}.{R}.fastq.gz_trimming_report.txt",
        dir=config['dir'], samples=config['samples'], R=['R1', 'R2']),
    
    fastqc = expand("{dir}/QC/FASTQC/", dir=config["dir"]),
    fastqc_html = expand("{dir}/QC/FASTQC/{samples}.R{R}_val_{R}_fastqc.html",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),
    fastqc_zip = expand("{dir}/QC/FASTQC/{samples}.R{R}_val_{R}_fastqc.zip",
        dir=config['dir'], samples=config['samples'], R=['1', '2']),

    sam = expand("{dir}/SAM/{samples}.sam", 
        dir=config['dir'], samples=config['samples']),
    sam_gz = expand("{dir}/SAM/{samples}.sam.tar.gz",  
        dir=config['dir'], samples=config['samples']),
    
    bam = expand("{dir}/BAM/{samples}.bam", 
        dir=config['dir'], samples=config['samples']),
    bam_sorted = expand("{dir}/BAM/{samples}_sorted.bam",
        dir=config['dir'], samples=config['samples']),
    dup_metrics = expand("{dir}/QC/{samples}_dup_metrics.txt",
        dir=config['dir'], samples=config['samples']),
    bam_f = expand("{dir}/BAM/{samples}_F.bam",
            dir=config['dir'], samples=config['samples']),
    bai = expand("{dir}/BAM/{samples}_F.bam.bai", 
        dir=config['dir'], samples=config['samples']),

    asm = expand("{dir}/QC/{samples}_ASM.txt",
        dir=config['dir'], samples=config['samples']),
    
    multiqc_report = expand("{dir}/QC/MULTIQC/multiqc_report.html", dir=config["dir"]),
    multiqc = expand("{dir}/QC/MULTIQC/multiqc_data/", dir=config["dir"])

if config['data_type'] == 'SE':
    fq = expand("{dir}/FASTQ/{samples}/{samples}.fastq.gz",
        dir=config['dir'], samples=config['samples']),

    trimmed_fq = expand("{dir}/TRIMMED/{samples}/{samples}.fastq.gz",
        dir=config['dir'], samples=config['samples']),
    trimmed_report = expand("{dir}/TRIMMED/{samples}.fastq.gz_trimming_report.txt",
        dir=config['dir'], samples=config['samples']),

    fastqc = expand("{dir}/QC/FASTQC/", dir=config["dir"]),
    fastqc_html = expand("{dir}/QC/FASTQC/{samples}_fastqc.html",
            dir=config['dir'], samples=config['samples']),
    fastqc_zip = expand("{dir}/QC/FASTQC/{samples}_fastqc.zip",
        dir=config['dir'], samples=config['samples']),
    
    multiext("Reference/hg19/Bowtie2Index/hg19",
            ".1.bt2", ".2.bt2", ".3.bt2",
            ".4.bt2", ".rev.1.bt2", ".rev.2.bt2"),

    sam = expand("{dir}/SAM/{samples}.sam", 
        dir=config['dir'], samples=config['samples']),
    sam_gz = expand("{dir}/SAM/{samples}.sam.tar.gz",  
        dir=config['dir'], samples=config['samples']),

    bam = expand("{dir}/BAM/{samples}.bam", 
        dir=config['dir'], samples=config['samples']),
    bam_sorted = expand("{dir}/BAM/{samples}_sorted.bam",
        dir=config['dir'], samples=config['samples']),
    bam_f = expand("{dir}/BAM/{samples}_F.bam",
            dir=config['dir'], samples=config['samples']),
    bai = expand("{dir}/BAM/{samples}_F.bam.bai", 
        dir=config['dir'], samples=config['samples']),

    dup_metrics = expand("{dir}/QC/{samples}_dup_metrics.txt",
        dir=config['dir'], samples=config['samples']),
    asm = expand("{dir}/QC/{samples}_ASM.txt",
        dir=config['dir'], samples=config['samples']),

    multiqc_report = expand("{dir}/MULTIQC/multiqc_report.html", dir=config["dir"]),
    multiqc = expand("{dir}/MULTIQC/multiqc_data/", dir=config["dir"])

rule all:
    input:
        fq, trimmed_fq, trimmed_report, fastqc_html, fastqc_zip,
        multiext(
            "/Users/aboudemi/Documents/NGS_Analysis/Reference/hg19/Bowtie2Index/hg19",
            ".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2"), 
        sam, sam_gz, bam, bam_sorted, dup_metrics, bam_f, bai,
        asm, multiqc_report, multiqc
        