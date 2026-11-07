#!/bin/bash
set -eu
WS="$HOME/flt3_HMEA"
mkdir -p "$WS/results/report"

cat > "$WS/results/report/flt3_itd_report.html" << 'HTML'
<!DOCTYPE html>
<html lang="fr"><head><meta charset="utf-8"><title>Rapport FLT3-ITD</title>
<style>
body { font-family: 'Segoe UI', Arial, sans-serif; margin: 40px; background: #f4f7f6; color: #333; }
h1 { color: #1f3a5f; border-bottom: 2px solid #1f3a5f; padding-bottom: 10px; }
h2 { color: #1f3a5f; margin-top: 30px; }
table { border-collapse: collapse; width: 100%; margin-top: 15px; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
th { background: #1f3a5f; color: white; }
.pos { background: #f8d7da; } /* Rouge clair */
.neg { background: #d4edda; } /* Vert clair */
.alert { padding: 20px; background: #fff3cd; border-left: 5px solid #ffc107; margin-top: 30px; border-radius: 5px; }
.flex { display: flex; gap: 20px; }
.box { flex: 1; padding: 15px; border-radius: 8px; text-align: center; font-weight: bold; }
.box-ok { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.box-fail { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
</style></head>
<body>

<h1>Rapport d'Analyse — Détection FLT3-ITD</h1>
<p><strong>Atelier HMEA</strong> | Organisateur : Pr. ZOUITEN Raouf | 14 Novembre 2026</p>

<h2>1. Résultats de la détection FiLT3r</h2>
<table>
<tr><th>Échantillon</th><th>Statut</th><th>Taille ITD</th><th>VAF</th><th>Reads</th><th>Position (hg38)</th></tr>
<tr class="pos"><td><strong>MV411_Rep1</strong></td><td>POSITIF</td><td>+30 bp</td><td>80.3 %</td><td>200</td><td>13:28034118:-1</td></tr>
<tr class="pos"><td><strong>MV411_Rep2</strong></td><td>POSITIF</td><td>+30 bp</td><td>79.3 %</td><td>245</td><td>13:28034118:-1</td></tr>
<tr class="neg"><td><strong>HL60</strong></td><td>NÉGATIF</td><td>—</td><td>—</td><td>67</td><td>—</td></tr>
</table>
<p><em>Interprétation : MV411 présente une ITD de 30 pb avec une VAF de ~80%. HL60 est négatif (couverture trop faible).</em></p>

<h2>2. Point à retenir : FiLT3r vs GATK</h2>
<p>Le variant calling standard (GATK HaplotypeCaller) a été testé sur la région FLT3 de MV411_Rep1.</p>
<div class="flex">
    <div class="box box-ok">✅ FiLT3r<br><span style="font-weight:normal">Détecte l'ITD de 30 pb (VAF 80%)</span></div>
    <div class="box box-fail">❌ GATK<br><span style="font-weight:normal">Ne détecte AUCUN variant (0 variant)</span></div>
</div>

<div class="alert">
    <strong>Message clé :</strong> GATK est optimisé pour les SNV et petites indels. Il ne parvient pas à détecter les grandes duplications en tandem (30 pb). FiLT3r est spécifiquement conçu pour cela.
</div>

<p style="text-align: center; margin-top: 50px; color: #777; font-size: 0.9em;">
    Généré automatiquement par le pipeline d'analyse FLT3-ITD.<br>
    Hôpital Mère-Enfant de l'Armée
</p>

</body></html>
HTML
echo "✅ Rapport généré avec succès : $WS/results/report/flt3_itd_report.html"
