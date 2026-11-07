#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
SRC="$HOME/flt3_pipeline"
echo "=========================================="
echo "ÉTAPE 00 — Setup du répertoire d'atelier"
echo "=========================================="
mkdir -p "$WS"/{data/raw,data/ref,results/{fastqc,star,filt3r,gatk,report},logs,scripts}
ln -sfn "$SRC/data/raw/"*.fastq.gz "$WS/data/raw/" 2>/dev/null || true
ln -sfn "$SRC/data/ref/star_index" "$WS/data/ref/star_index" 2>/dev/null || true
ln -sfn "$SRC/data/ref/GRCh38.primary_assembly.genome.fa" "$WS/data/ref/genome.fa" 2>/dev/null || true
ln -sfn "$SRC/data/ref/GRCh38.primary_assembly.genome.fa.fai" "$WS/data/ref/genome.fa.fai" 2>/dev/null || true
ln -sfn "$SRC/data/ref/flt3_exon14-15.fa" "$WS/data/ref/flt3_ref.fa" 2>/dev/null || true
cat > "$WS/samples.tsv" << 'EOT'
# sample	layout
MV411_Rep1	paired
MV411_Rep2	paired
HL60	single
EOT
echo "✅ Répertoire : $WS"
echo ""
echo "→ Contenu data/raw/ :"
ls -lh "$WS/data/raw/"
