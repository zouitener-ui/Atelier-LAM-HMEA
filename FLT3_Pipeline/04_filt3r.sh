#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
cd "$WS"
mkdir -p results/filt3r
echo "=========================================="
echo "ÉTAPE 04 — FiLT3r (détection FLT3-ITD)"
echo "=========================================="
run_filt3r() {
    local S="$1"; local SEQ="$2"
    echo "→ FiLT3r : $S"
    docker run --rm \
        -v "$HOME/flt3_pipeline/data/raw:/data:ro" \
        -v "$WS/data/ref/flt3_ref.fa:/ref.fa:ro" \
        -v "$WS/results/filt3r:/out" \
        --user "$(id -u):$(id -g)" \
        mikaels/filt3r:latest /bin/filt3r \
        --ref /ref.fa -k 12 \
        --out "/out/${S}.results.json" \
        $SEQ
}
run_filt3r "MV411_Rep1" "--sequences /data/MV411_Rep1_1.fastq.gz /data/MV411_Rep1_2.fastq.gz"
run_filt3r "MV411_Rep2" "--sequences /data/MV411_Rep2_1.fastq.gz /data/MV411_Rep2_2.fastq.gz"
run_filt3r "HL60"       "--sequences /data/HL60.fastq.gz"
echo ""
echo "→ Résumé ITD :"
python3 - <<'PYEOF'
import json
from pathlib import Path
d = Path.home() / "flt3_HMEA" / "results" / "filt3r"
for f in sorted(d.glob("*.results.json")):
    j = json.load(open(f))
    itds = [e for e in j.get("details", [])
            if e.get("is_duplication") and e.get("VAF",0)>=0.05 and e.get("occurrence",0)>=10]
    if itds:
        t = max(itds, key=lambda x: x["occurrence"])
        print(f"  {f.stem:15s} ITD {t['size']:+d} bp  VAF={t['VAF']*100:.1f}%  reads={t['occurrence']}  pos={t['reference_pos']}")
    else:
        print(f"  {f.stem:15s} négatif")
PYEOF
