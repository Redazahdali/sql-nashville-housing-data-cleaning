# SQL Data Cleaning — Nashville Housing

[Français](#français) · [English](#english)

## Français

### Présentation
Projet de nettoyage et de préparation de données immobilières avec SQL Server. Les requêtes permettent de standardiser les données, traiter les valeurs manquantes, restructurer les adresses, normaliser certaines valeurs et identifier puis supprimer les doublons.

### Travaux réalisés
- Standardisation du format de date
- Traitement des adresses de propriété manquantes
- Séparation des adresses en colonnes distinctes
- Normalisation des valeurs Y / N de SoldAsVacant
- Identification et suppression des doublons avec ROW_NUMBER()
- Suppression des colonnes devenues inutiles

### Techniques SQL utilisées
SELECT · UPDATE · ALTER TABLE · JOIN · ISNULL · SUBSTRING · CHARINDEX · PARSENAME · REPLACE · CASE · CTE · ROW_NUMBER() · DELETE

### Technologies
**SQL Server** · **T-SQL** · **Data Cleaning**

### Fichier du projet
Le script SQL documenté est disponible dans ce dépôt.

### Statut
**Terminé**

---

## English

### Overview
SQL Server data cleaning and preparation project based on housing data. The queries standardize data, handle missing values, restructure addresses, normalize values, and identify and remove duplicate records.

### Work performed
- Standardized the date format
- Handled missing property addresses
- Split addresses into separate columns
- Normalized Y / N values in SoldAsVacant
- Identified and removed duplicates using ROW_NUMBER()
- Removed columns that were no longer required

### SQL techniques used
SELECT · UPDATE · ALTER TABLE · JOIN · ISNULL · SUBSTRING · CHARINDEX · PARSENAME · REPLACE · CASE · CTE · ROW_NUMBER() · DELETE

### Technologies
**SQL Server** · **T-SQL** · **Data Cleaning**

### Project file
The documented SQL script is available in this repository.

### Status
**Completed**
