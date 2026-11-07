#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
cd "$WS"
mkdir -p results/gatk
echo "=========================================="
echo "ÉTAPE 05 — GATK (démonstration VCF)"
echo "=========================================="
echo "⚠️  GATK ne détecte PAS les FLT3-ITD (conçu pour SNV/indels courts)"
BAM="results/star/MV411_Rep1/MV411_Rep1_Aligned.sortedByCoord.out.bam"
gatk HaplotypeCaller \
    -R data/ref/genome.fa \
    -I "$BAM" \
    -L chr13:28030000-28040000 \
    -O results/gatk/MV411_Rep1_flt3.vcf.gz \
    -ERC GVCF 2>&1 | tail -5
echo ""
echo "→ Variants détectés dans la région FLT3 :"
zcat results/gatk/MV411_Rep1_flt3.vcf.gz | grep -v "^#" | \
    awk -F'\t' '$1=="chr13" && $2>=28033760 && $2<=28034429 {print}' || echo "   (aucun)"
