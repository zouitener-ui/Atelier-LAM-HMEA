import json
from pathlib import Path
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment

# Dossier de travail
WS = Path.home() / "flt3_HMEA"
FILT3R_DIR = WS / "results" / "filt3r"
OUTPUT_XLSX = FILT3R_DIR / "filt3r_results.xlsx"
SAMPLES = ["MV411_Rep1", "MV411_Rep2", "HL60"]

wb = Workbook()
ws = wb.active
ws.title = "Résultats FiLT3r"

# En-têtes
headers = ["Échantillon", "Statut", "Taille ITD (bp)", "VAF (%)", "Reads ITD", "Position", "Séquences filtrées"]
ws.append(headers)

# Mise en forme de l'en-tête (Bleu foncé, texte blanc)
for col_num, _ in enumerate(headers, 1):
    cell = ws.cell(row=1, column=col_num)
    cell.font = Font(bold=True, color="FFFFFF")
    cell.fill = PatternFill("solid", fgColor="1F3A5F")
    cell.alignment = Alignment(horizontal="center")

# Remplissage des données
for s in SAMPLES:
    f = FILT3R_DIR / f"{s}.results.json"
    if not f.exists():
        continue
 
    d = json.load(open(f))
    # Filtre : duplication + VAF >= 5% + au moins 10 reads
    itds = [e for e in d.get("details", []) if e.get("is_duplication") and e.get("VAF",0)>=0.05 and e.get("occurrence",0)>=10]
 
    if itds:
        t = max(itds, key=lambda x: x["occurrence"])
        row = [s, "POSITIF", f"{t['size']:+d}", f"{t['VAF']*100:.1f}", t['occurrence'], t['reference_pos'], d.get("nb_filtered", 0)]
        fill_color = "F8D7DA" # Rouge clair
    else:
        row = [s, "NÉGATIF", "-", "-", "-", "-", d.get("nb_filtered", 0)]
        fill_color = "D4EDDA" # Vert clair
 
    ws.append(row)
 
    # Appliquer la couleur à la ligne
    for col_num in range(1, len(headers) + 1):
        cell = ws.cell(row=ws.max_row, column=col_num)
        cell.fill = PatternFill("solid", fgColor=fill_color)

# Ajuster la largeur des colonnes
for col, w in zip("ABCDEFG", [15, 12, 15, 10, 12, 20, 20]):
    ws.column_dimensions[col].width = w
 
ws.freeze_panes = "A2" # Figer la première ligne
wb.save(OUTPUT_XLSX)
print(f"✅ Tableau Excel généré : {OUTPUT_XLSX}")
