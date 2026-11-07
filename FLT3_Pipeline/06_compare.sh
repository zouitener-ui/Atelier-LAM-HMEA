#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
cd "$WS"
echo "=========================================="
echo "ÉTAPE 06 — FiLT3r vs GATK"
echo "=========================================="
echo ""
echo "→ FiLT3r :"
python3 -c "
import json
j=json.load(open('results/filt3r/MV411_Rep1.results.json'))
for e in j['details']:
    if e.get('is_duplication') and e.get('VAF',0)>=0.05 and e.get('occurrence',0)>=10:
        print(f\"   ITD {e['size']:+d} bp  VAF={e['VAF']*100:.1f}%  reads={e['occurrence']}  pos={e['reference_pos']}\")
"
echo ""
echo "→ GATK :"
if zcat results/gatk/MV411_Rep1_flt3.vcf.gz | grep -v "^#" | \
   awk -F'\t' '$1=="chr13" && $2>=28033760 && $2<=28034429' | grep -q .; then
    zcat results/gatk/MV411_Rep1_flt3.vcf.gz | grep -v "^#" | \
        awk -F'\t' '$1=="chr13" && $2>=28033760 && $2<=28034429 {print "   "$0}'
else
    echo "   ❌ GATK n'a détecté AUCUN variant dans la région FLT3-ITD"
fi
echo ""
echo "🎓 Message clé : FiLT3r détecte l'ITD, GATK non."
