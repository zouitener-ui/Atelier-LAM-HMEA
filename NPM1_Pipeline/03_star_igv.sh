#!/bin/bash
set -eu
cd "$HOME/NPM1_Atelier"

echo "→ Alignement STAR..."
STAR --runThreadN 8 --genomeDir data/ref/star_index \
     --readFilesIn data/raw/SRR8756912_1_fastp.fastq.gz data/raw/SRR8756912_2_fastp.fastq.gz \
     --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate \
     --outFileNamePrefix results/star/NPM1_

echo "→ Indexation et préparation de la région pour IGV..."
samtools index results/star/NPM1_Aligned.sortedByCoord.out.bam
samtools view -b results/star/NPM1_Aligned.sortedByCoord.out.bam chr5:171410000-171415000 > results/star/NPM1_region.bam
samtools index results/star/NPM1_region.bam

echo "✅ Étape 3 terminée : BAM IGV prêt."
