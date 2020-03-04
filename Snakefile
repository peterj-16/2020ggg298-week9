# list genome file numbers
number=['1',
        '2',
        '3',
        '4',
        '5']

rule all:
    input:
        "all.cmp.matrix.png"
        
rule download_genomes:
    output:
        expand("{name}.fa.gz", name=number)
    shell:
        """wget https://osf.io/t5bu6/download -O 1.fa.gz
        wget https://osf.io/ztqx3/download -O 2.fa.gz
        wget https://osf.io/w4ber/download -O 3.fa.gz
        wget https://osf.io/dnyzp/download -O 4.fa.gz
        wget https://osf.io/ajvqk/download -O 5.fa.gz"""

rule sourmash_compute:
    conda: "export.yml"
    input:    
        expand("{name}.fa.gz", name=number)
    output:
        expand("{name}.fa.gz.sig", name=number)
    shell:
        """sourmash compute 1.fa.gz
        sourmash compute 2.fa.gz
        sourmash compute 3.fa.gz
        sourmash compute 4.fa.gz
        sourmash compute 5.fa.gz"""

rule sourmash_compare:
    input:
        expand("{name}.fa.gz.sig", name=number)
    output:
        "all.cmp",
        "all.cmp.labels.txt"
    shell:
        """sourmash compare -k 31 *.sig -o all.cmp"""

rule sourmash_plot:
    input:
        "all.cmp",
        "all.cmp.labels.txt"
    output:
        "all.cmp.hist.png",
        "all.cmp.dendro.png",
        "all.cmp.matrix.png"
    shell:
        """sourmash plot --labels all.cmp"""
