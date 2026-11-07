#!/bin/bash
set -eu
cd "$HOME/NPM1_Atelier"

echo "→ Nettoyage avec fastp..."
fastp -i data/raw/SRR8756912_1.fastq.gz -I data/raw/SRR8756912_2.fastq.gz \
      -o data/raw/SRR8756912_1_fastp.fastq.gz -O data/raw/SRR8756912_2_fastp.fastq.gz \
      --detect_adapter_for_pe --correction -w 8 -j results/fastqc/fastp.json -h results/fastqc/fastp.html

echo "→ Contrôle qualité avec FastQC..."
fastqc -t 4 --outdir results/fastqc data/raw/*_fastp.fastq.gz

echo "✅ Étape 2 terminée : Fastp et FastQC OK."
