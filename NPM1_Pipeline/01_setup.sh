#!/bin/bash
set -eu
WS="$HOME/NPM1_Atelier"
mkdir -p "$WS"/{data/raw,data/ref,results/{fastqc,star,km_walk,report}}
cd "$WS"

FASTQ_DIR="/mnt/c/Users/GAMING/Downloads/NPM1 Illumina HiSeq 2000 sequencing GSM3680997 ID103_dx Homo sapiens RNA-Seq"
ln -sf "$FASTQ_DIR/SRR8756912_1.fastq.gz" data/raw/
ln -sf "$FASTQ_DIR/SRR8756912_2.fastq.gz" data/raw/

ln -sfn "$HOME/flt3_pipeline/data/ref/star_index" data/ref/star_index
ln -sfn "$HOME/flt3_pipeline/data/ref/GRCh38.primary_assembly.genome.fa" data/ref/genome.fa

if [ ! -f "data/ref/NPM1_4ins_exons_10-11utr.fa" ]; then
    wget -qO data/ref/NPM1_4ins_exons_10-11utr.fa "https://raw.githubusercontent.com/iric-soft/km/master/data/catalog/GRCh38/NPM1_4ins_exons_10-11utr.fa"
fi
echo "✅ Étape 1 terminée : Répertoire prêt."
