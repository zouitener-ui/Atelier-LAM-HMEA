#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
cd "$WS"
echo "=========================================="
echo "ÉTAPE 03 — Alignement STAR"
echo "=========================================="
tail -n +2 samples.tsv | while read -r S LAYOUT; do
    [ -z "$S" ] && continue
    mkdir -p "results/star/$S"
    if [ "$LAYOUT" = "paired" ]; then
        echo "→ $S (paired-end)"
        STAR --runThreadN 8 --genomeDir data/ref/star_index \
            --readFilesIn "data/raw/${S}_1.fastq.gz" "data/raw/${S}_2.fastq.gz" \
            --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate \
            --outFileNamePrefix "results/star/$S/${S}_" \
            --outSAMattrRGline ID:$S SM:$S PL:ILLUMINA
    else
        echo "→ $S (single-end)"
        STAR --runThreadN 8 --genomeDir data/ref/star_index \
            --readFilesIn "data/raw/${S}.fastq.gz" \
            --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate \
            --outFileNamePrefix "results/star/$S/${S}_" \
            --outSAMattrRGline ID:$S SM:$S PL:ILLUMINA
    fi
    samtools index "results/star/$S/${S}_Aligned.sortedByCoord.out.bam"
done
echo ""
echo "→ En-tête BAM :"
samtools view -H results/star/MV411_Rep1/MV411_Rep1_Aligned.sortedByCoord.out.bam | head -8
echo ""
echo "→ Taux d'alignement :"
for S in MV411_Rep1 MV411_Rep2 HL60; do
    echo -n "   $S : "
    grep "Uniquely mapped reads %" "results/star/$S/${S}_Log.final.out" | awk -F'|' '{print $2}'
done
