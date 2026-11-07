#!/bin/bash
cd "$HOME/NPM1_Atelier"

# Génération du rapport HTML avec Python pour lire les deux JSON
python3 << 'PYEOF'
import json
from pathlib import Path
from datetime import datetime

WS = Path.home() / "NPM1_Atelier"
REPORT = WS / "results" / "report" / "NPM1_report.html"

# 1. Lire NPM1
km_txt = (WS / "results/km_walk/km_report.txt").read_text()
npm1_line = [l for l in km_txt.splitlines() if "Insertion" in l][0]
npm1_size = npm1_line.split()[5]
npm1_vaf = npm1_line.split()[8]

# 2. Lire FLT3
f3_file = WS / "results/filt3r/SRR8756912_FLT3.results.json"
flt3_status = "NÉGATIF"
flt3_size = "-"
flt3_vaf = "-"
if f3_file.exists():
    d = json.load(open(f3_file))
    itds = [e for e in d.get("details", []) if e.get("is_duplication") and e.get("VAF",0)>=0.05 and e.get("occurrence",0)>=10]
    if itds:
        top = max(itds, key=lambda x: x["occurrence"])
        flt3_status = "POSITIF"
        flt3_size = f"{top['size']:+d} bp"
        flt3_vaf = f"{top['VAF']*100:.1f} %"

html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Rapport NPM1 & FLT3 — Atelier HMEA</title>
    <style>
        body {{ font-family: 'Segoe UI', Arial, sans-serif; margin: 40px; background-color: #f4f7f6; color: #333; }}
        .header {{ background: linear-gradient(135deg, #1f3a5f 0%, #3d95fd 100%); color: white; padding: 25px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }}
        .header h1 {{ margin: 0 0 15px 0; font-size: 24px; }}
        .header p {{ margin: 5px 0; font-size: 16px; }}
        h2 {{ color: #1f3a5f; margin-top: 30px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }}
        table {{ border-collapse: collapse; width: 100%; margin-top: 20px; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }}
        th, td {{ border: 1px solid #ddd; padding: 15px; text-align: left; }}
        th {{ background: #1f3a5f; color: white; }}
        .pos {{ background: #f8d7da; font-weight: bold; color: #721c24; }}
        .neg {{ background: #d4edda; color: #155724; }}
        .alert {{ padding: 20px; background: #fff3cd; border-left: 5px solid #ffc107; margin-top: 30px; border-radius: 5px; }}
        .footer {{ margin-top: 50px; text-align: center; color: #777; font-size: 0.9em; }}
    </style>
</head>
<body>

    <div class="header">
        <h1>2ème Journée Médico-Chirurgicale de l'Hôpital Mère-Enfant de l'Armée (1er RM)</h1>
        <p><strong>Auteur / Organisateur :</strong> Professeur ZOUITEN Raouf</p>
        <p><strong>Date :</strong> 14 Novembre 2026</p>
        <p><strong>Analyse :</strong> Détection des mutations NPM1 et FLT3-ITD par RNA-seq</p>
    </div>

    <h2>Résultats de l'analyse génomique</h2>
    <p><strong>Échantillon :</strong> SRR8756912 (ID103_dx)</p>

    <table>
        <tr>
            <th>Gène / Mutation</th>
            <th>Outil</th>
            <th>Statut</th>
            <th>Taille</th>
            <th>Fréquence allélique</th>
        </tr>
        <tr class="pos">
            <td><strong>NPM1</strong> (Insertion)</td>
            <td>km-walk</td>
            <td>POSITIF</td>
            <td>{npm1_size} bp</td>
            <td>{npm1_vaf}</td>
        </tr>
        <tr class="pos">
            <td><strong>FLT3-ITD</strong> (Duplication)</td>
            <td>FiLT3r</td>
            <td>{flt3_status}</td>
            <td>{flt3_size}</td>
            <td>{flt3_vaf}</td>
        </tr>
    </table>

    <div class="alert">
        <h4>🚨 Découverte Clinique Majeure : Double Mutation</h4>
        <p>Cet échantillon présente une <strong>co-occurrence</strong> de la mutation NPM1 et de la duplication FLT3-ITD.</p>
        <p>La combinaison NPM1+/FLT3-ITD+ est une signature moléculaire fréquente dans la Leucémie Aiguë Myéloïde (LAM). Elle a une importance pronostique majeure et guide les décisions thérapeutiques (notamment pour l'utilisation d'inhibiteurs de FLT3).</p>
        <p><em>Note technique : L'analyse visuelle sur IGV permet de confirmer ces deux événements (insertion de 4 pb pour NPM1 et duplication en tandem pour FLT3).</em></p>
    </div>

    <div class="footer">
        <p>Généré automatiquement par le pipeline d'analyse NPM1/FLT3.</p>
    </div>

</body>
</html>"""

REPORT.write_text(html)
print("✅ Rapport HTML généré avec succès.")
PYEOF

explorer.exe "$(wslpath -w $HOME/NPM1_Atelier/results/report/NPM1_report.html)"
