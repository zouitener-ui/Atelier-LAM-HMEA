# Atelier de Bioinformatique — Leucémie Aiguë Myéloïde (LAM)

**2ème Journée Médico-Chirurgicale de l'Hôpital Mère-Enfant de l'Armée (1er RM)
14 Novembre 2026**

**Auteur / Organisateur :** Professeur ZOUITEN Raouf

\---

## Introduction

Ce dépôt contient les pipelines d'analyse RNA-seq développés pour l'atelier. Ils permettent la détection de deux mutations majeures dans la Leucémie Aiguë Myéloïde (LAM) :

1. **FLT3-ITD** (Internal Tandem Duplication) via l'outil FiLT3r.
2. **NPM1** (Insertion de 4 pb) via l'outil km-walk.

\---

## Prérequis

### Matériel

* RAM : 32 Go minimum (48 Go recommandé pour l'index STAR GRCh38).
* CPU : 8 cœurs.
* OS : Linux (Ubuntu) ou WSL2 sous Windows.

### Logiciels (Conda \& Docker)

```bash
conda create -n rnaseq python=3.11 -y
conda activate rnaseq
conda install -c bioconda -c conda-forge fastqc multiqc star=2.7.11b samtools gatk4 fastp -y
```

* **Docker** doit être installé et fonctionnel (pour FiLT3r).
* **km-walk** doit être installé dans un environnement virtuel :

```bash
python3 -m venv \~/km\_env
source \~/km\_env/bin/activate
pip install km-walk
```

\---

## 1\. Pipeline FLT3-ITD

Ce pipeline utilise FiLT3r pour détecter les grandes duplications en tandem et compare les résultats avec GATK.

**Dossier :** `FLT3\_Pipeline/`

**Instructions d'exécution :**

```bash
bash FLT3\_Pipeline/00\_setup.sh
bash FLT3\_Pipeline/01\_inspect\_fastq.sh
bash FLT3\_Pipeline/02\_fastqc\_multiqc.sh
bash FLT3\_Pipeline/03\_star.sh
bash FLT3\_Pipeline/04\_filt3r.sh
bash FLT3\_Pipeline/05\_gatk\_demo.sh
bash FLT3\_Pipeline/06\_compare.sh
bash FLT3\_Pipeline/07\_report.sh
```

*Résultats attendus : MV411 positif (ITD +30 bp, VAF 80%), GATK ne détecte rien.*

\---

## 2\. Pipeline NPM1

Ce pipeline utilise un nettoyage strict avec `fastp`, un alignement STAR, et l'outil `km-walk` basé sur les k-mers pour détecter l'insertion de 4 pb.

**Dossier :** `NPM1\_Pipeline/`

**Instructions d'exécution :**

```bash
bash NPM1\_Pipeline/01\_setup.sh
bash NPM1\_Pipeline/02\_fastp.sh
bash NPM1\_Pipeline/03\_star\_igv.sh
bash NPM1\_Pipeline/04\_km\_walk.sh
bash NPM1\_Pipeline/05\_report.sh
```

*Résultats attendus : Détection de l'insertion NPM1 avec un rVAF d'environ 48.4% (mutation hétérozygote). Visualisation possible dans IGV à la position `chr5:171410544`.*

\---

## Contact

**Professeur ZOUITEN Raouf**
Hôpital Mère-Enfant de l'Armée (1er RM)

