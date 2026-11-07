#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
echo "=========================================="
echo "ÉTAPE 01 — Structure d'un fichier FASTQ"
echo "=========================================="
F="$WS/data/raw/MV411_Rep1_1.fastq.gz"
echo "→ Fichier : $F"
echo "→ Cible (résolution du lien) : $(readlink -f "$F")"
echo "→ Taille réelle : $(du -hL "$F" | cut -f1)"
echo ""
echo "→ Les 4 premières lignes (1 read = 4 lignes) :"
echo "   L1 = @identifiant | L2 = séquence | L3 = + | L4 = qualités Phred"
zcat "$F" | head -4
echo ""
echo "→ Nombre de reads :"
zcat "$F" | awk 'NR%4==1' | wc -l | awk '{print "   " $1 " reads"}'
echo ""
echo "→ Longueur du premier read :"
zcat "$F" | sed -n '2p' | awk '{print "   " length($0) " bp"}'
