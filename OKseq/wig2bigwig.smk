configfile: "config/config.yaml"

rule wig2bigwig:
    output:
        expand("{dir}/OKseqOEM/{samples}/{samples}_OEM_{binlist}kb.bw", 
            dir=config["dir"], samples=config["samples"], binlist=config["binlist"])
    input:
        expand("{dir}/OKseqOEM/{samples}/{samples}_OEM_{binlist}kb.wig", 
            dir=config["dir"], samples=config["samples"], binlist=config["binlist"])
    params:
        chrsizes = "/Users/aboudemi/Documents/NGS_Analysis/Reference/hg19/Chr_Sizes/hg19.chrom.sizes"
    run:
        for i, o in zip(input, output):
            shell("Scripts/wigToBigWig {i} {params.chrsizes} {o}")