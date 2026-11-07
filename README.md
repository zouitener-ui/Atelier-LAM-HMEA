# Atelier de Bioinformatique — Leucémie Aiguë Myéloïde (LAM)

**2ème Journée Médico-Chirurgicale de l'Hôpital Mère-Enfant de l'Armée (1er RM)**
**14 Novembre 2026**

**Auteur / Organisateur :** Professeur ZOUITEN Raouf

---

## Introduction

Ce dépôt contient les pipelines d'analyse RNA-seq développés pour l'atelier. Ils permettent la détection de deux mutations majeures dans la Leucémie Aiguë Myéloïde (LAM) :
1. **FLT3-ITD** (Internal Tandem Duplication) via l'outil FiLT3r.
2. **NPM1** (Insertion de 4 pb) via l'outil km-walk.

---

## Prérequis

### Matériel
- RAM : 32 Go minimum (48 Go recommandé pour l'index STAR GRCh38).
- CPU : 8 cœurs.
- OS : Linux (Ubuntu) ou WSL2 sous Windows.

### Logiciels (Conda & Docker)
```bash
conda create -n rnaseq python=3.11 -y
conda activate rnaseq
conda install -c bioconda -c conda-forge fastqc multiqc star=2.7.11b samtools gatk4 fastp -y
```
- **Docker** doit être installé et fonctionnel (pour FiLT3r).
- **km-walk** doit être installé dans un environnement virtuel :
```bash
python3 -m venv ~/km_env
source ~/km_env/bin/activate
pip install km-walk
```

---

## 1. Pipeline FLT3-ITD

Ce pipeline utilise FiLT3r pour détecter les grandes duplications en tandem et compare les résultats avec GATK.

**Dossier :** `FLT3_Pipeline/`

**Instructions d'exécution :**
```bash
bash FLT3_Pipeline/00_setup.sh
bash FLT3_Pipeline/01_inspect_fastq.sh
bash FLT3_Pipeline/02_fastqc_multiqc.sh
bash FLT3_Pipeline/03_star.sh
bash FLT3_Pipeline/04_filt3r.sh
bash FLT3_Pipeline/05_gatk_demo.sh
bash FLT3_Pipeline/06_compare.sh
bash FLT3_Pipeline/07_report.sh
```
*Résultats attendus : MV411 positif (ITD +30 bp, VAF 80%), GATK ne détecte rien.*

---

## 2. Pipeline NPM1 & Découverte FLT3

Ce pipeline utilise un nettoyage strict avec `fastp`, un alignement STAR, et l'outil `km-walk` basé sur les k-mers pour détecter l'insertion de 4 pb.

**Dossier :** `NPM1_Pipeline/`

**Instructions d'exécution :**
```bash
bash NPM1_Pipeline/01_setup.sh
bash NPM1_Pipeline/02_fastp.sh
bash NPM1_Pipeline/03_star_igv.sh
bash NPM1_Pipeline/04_km_walk.sh
bash NPM1_Pipeline/05_filt3r_check.sh
bash NPM1_Pipeline/06_report.sh
```
*Résultats attendus : Détection de l'insertion NPM1 (rVAF ~48.4%) ET découverte d'une ITD FLT3 (+15 bp, VAF 54%). L'échantillon SRR8756912 présente une **double mutation**.*

---

## 3. Kit de Visualisation IGV

Un kit contenant des fichiers BAM allégés (régions NPM1 et FLT3) est fourni pour permettre aux participants de visualiser les mutations sur le logiciel IGV.
Consultez le fichier `INSTRUCTIONS_IGV.txt` inclus dans le kit pour savoir comment naviguer vers les positions `chr5:171410544` (NPM1) et `chr13:28034118` (FLT3).

---

## Contact
**Professeur ZOUITEN Raouf**
Hôpital Mère-Enfant de l'Armée (1er RM)
