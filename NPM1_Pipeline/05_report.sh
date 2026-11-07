#!/bin/bash
cd "$HOME/NPM1_Atelier"

# Extraction des valeurs depuis le rapport km-walk
RES=$(grep "Insertion" results/km_walk/km_report.txt | head -1)
ADDED=$(echo "$RES" | awk '{print $6}')
VAF=$(echo "$RES" | awk '{print $9}')

# Génération du rapport HTML avec l'en-tête officiel
cat > results/report/NPM1_report.html << HTML_END
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Rapport NPM1 — Atelier HMEA</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 40px; background-color: #f4f7f6; color: #333; }
        .header { background: linear-gradient(135deg, #1f3a5f 0%, #3d95fd 100%); color: white; padding: 25px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .header h1 { margin: 0 0 15px 0; font-size: 24px; }
        .header p { margin: 5px 0; font-size: 16px; }
        h2 { color: #1f3a5f; margin-top: 30px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { border: 1px solid #ddd; padding: 15px; text-align: left; }
        th { background: #1f3a5f; color: white; }
        .pos { background: #f8d7da; font-weight: bold; color: #721c24; }
        .footer { margin-top: 50px; text-align: center; color: #777; font-size: 0.9em; }
    </style>
</head>
<body>

    <div class="header">
        <h1>2ème Journée Médico-Chirurgicale de l'Hôpital Mère-Enfant de l'Armée (1er RM)</h1>
        <p><strong>Auteur / Organisateur :</strong> Professeur ZOUITEN Raouf</p>
        <p><strong>Date :</strong> 14 Novembre 2026</p>
        <p><strong>Analyse :</strong> Détection de la mutation NPM1 par RNA-seq</p>
    </div>

    <h2>Résultats de l'analyse</h2>
    <p><strong>Échantillon :</strong> SRR8756912 (GSM3680997)</p>
    <p><strong>Outil de détection :</strong> km-walk (basé sur les k-mers)</p>

    <table>
        <tr>
            <th>Type de mutation</th>
            <th>Taille ajoutée</th>
            <th>Fréquence allélique (rVAF)</th>
        </tr>
        <tr class="pos">
            <td>Insertion (NPM1)</td>
            <td>${ADDED} bp</td>
            <td>${VAF}</td>
        </tr>
    </table>

    <h2>Interprétation clinique</h2>
    <p>La mutation NPM1 a été détectée avec succès. Un rVAF d'environ 0.5 (50%) est typique d'une mutation hétérozygote, signature classique de la Leucémie Aiguë Myéloïde (LAM).</p>
    <p><em>Note pédagogique : GATK HaplotypeCaller a échoué à détecter cette insertion de 4 pb. Cela démontre l'importance d'utiliser des outils spécialisés comme km-walk pour ce type de variant structurel.</em></p>

    <div class="footer">
        <p>Généré automatiquement par le pipeline d'analyse NPM1.</p>
    </div>

</body>
</html>
HTML_END

echo "✅ Étape 5 terminée : Rapport généré avec l'en-tête officiel."
explorer.exe "$(wslpath -w $HOME/NPM1_Atelier/results/report/NPM1_report.html)"
