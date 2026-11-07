#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
cd "$WS"
echo "=========================================="
echo "ÉTAPE 02 — FastQC + MultiQC"
echo "=========================================="
fastqc -t 4 --outdir results/fastqc data/raw/*.fastq.gz
multiqc results/fastqc --outdir results/fastqc --force
echo ""
echo "→ Rapport MultiQC :"
echo "   file://$WS/results/fastqc/multiqc_report.html"
