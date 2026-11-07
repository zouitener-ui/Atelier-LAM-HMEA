#!/bin/bash
set -eu
cd "$HOME/NPM1_Atelier"
mkdir -p results/filt3r

echo "→ Recherche d'une ITD FLT3 dans l'échantillon NPM1 (SRR8756912)..."
docker run --rm \
    -v "$HOME/NPM1_Atelier/data/raw:/data:ro" \
    -v "$HOME/flt3_pipeline/data/ref/flt3_exon14-15.fa:/ref.fa:ro" \
    -v "$HOME/NPM1_Atelier/results/filt3r:/out" \
    --user "$(id -u):$(id -g)" \
    mikaels/filt3r:latest /bin/filt3r \
    --ref /ref.fa -k 12 \
    --out "/out/SRR8756912_FLT3.results.json" \
    --sequences /data/SRR8756912_1_fastp.fastq.gz /data/SRR8756912_2_fastp.fastq.gz

echo "✅ Étape 5 terminée : Recherche FLT3-ITD terminée."
