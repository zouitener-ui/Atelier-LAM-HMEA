#!/bin/bash
set -eu
cd "$HOME/NPM1_Atelier"

echo "→ Activation de l'environnement virtuel..."
source "$HOME/km_env/bin/activate"

echo "→ Comptage des k-mers avec Jellyfish (patientez)..."
zcat data/raw/SRR8756912_1_fastp.fastq.gz data/raw/SRR8756912_2_fastp.fastq.gz | \
jellyfish count -m 31 -s 100M -t 8 -C -o results/km_walk/NPM1_counts.jf /dev/fd/0

echo "→ Analyse avec km-walk..."
km find_mutation data/ref/NPM1_4ins_exons_10-11utr.fa results/km_walk/NPM1_counts.jf | \
km find_report -t data/ref/NPM1_4ins_exons_10-11utr.fa > results/km_walk/km_report.txt

deactivate
echo "✅ Étape 4 terminée. Résultat :"
cat results/km_walk/km_report.txt
