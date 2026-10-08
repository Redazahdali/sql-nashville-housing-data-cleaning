/*
SQL DATA CLEANING — NASHVILLE HOUSING
SQL Server / T-SQL

Les requêtes SQL originales sont conservées.
Des explications et séparateurs ont été ajoutés pour documenter le projet.
*/

-- Cleaning Data in SQL Queries

Select * from [PortfolioProject].[dbo].[NashvilleHousing]

/*
***
ÉTAPE 1 — Standardisation du format de date
Vérifie puis applique la conversion de SaleDate vers le type DATE et crée une colonne dédiée.
***
*/

-- Standardize Data Format

Select SaleDate, Convert(Date , SaleDate) from [PortfolioProject].[dbo].[NashvilleHousing]

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set SaleDate = Convert(Date , SaleDate)

AlTER Table [PortfolioProject].[dbo].[NashvilleHousing]
ADD SaleDateConverted Date;

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set SaleDateConverted = Convert(Date , SaleDate)

Select SaleDateConverted, Convert(Date , SaleDate) from [PortfolioProject].[dbo].[NashvilleHousing]

/*
***
ÉTAPE 2 — Traitement des adresses de propriété manquantes
Repère les PropertyAddress NULL puis utilise un self-join sur ParcelID pour récupérer l'adresse correspondante.
***
*/

-- Populate property Adress data

Select [PropertyAddress] from [PortfolioProject].[dbo].[NashvilleHousing] where
[PropertyAddress] is null

Select * from [PortfolioProject].[dbo].[NashvilleHousing] where
[PropertyAddress] is null

Select * from [PortfolioProject].[dbo].[NashvilleHousing]
order by ParcelID

Select * from [PortfolioProject].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress from [PortfolioProject].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

/*
***
ÉTAPE 3 — Séparation de l'adresse de propriété
Décompose PropertyAddress afin de stocker séparément l'adresse et la ville.
***
*/

-- Breaking out adress into individual columns ( adress, city , state )

Select [PropertyAddress] from [PortfolioProject].[dbo].[NashvilleHousing]

Select SUBSTRING([PropertyAddress], 1, CHARINDEX(',' , [PropertyAddress] ) - 1) as adress
, SUBSTRING([PropertyAddress], CHARINDEX(',' , [PropertyAddress] ) + 1 , LEN([PropertyAddress]))
from [PortfolioProject].[dbo].[NashvilleHousing]

AlTER Table [PortfolioProject].[dbo].[NashvilleHousing]
ADD PropertySplitAdress NVARCHAR(255);

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set PropertySplitAdress = SUBSTRING([PropertyAddress], 1, CHARINDEX(',' , [PropertyAddress] ) - 1)

AlTER Table [PortfolioProject].[dbo].[NashvilleHousing]
ADD PropertySplitCity NVARCHAR(100);

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set PropertySplitCity = SUBSTRING([PropertyAddress], CHARINDEX(',' , [PropertyAddress] ) + 1 , LEN([PropertyAddress]))

Select * from [PortfolioProject].[dbo].[NashvilleHousing]

--------------------------------------------------------------------

/*
***
ÉTAPE 4 — Séparation de l'adresse du propriétaire
Utilise REPLACE et PARSENAME pour séparer OwnerAddress en adresse, ville et État.
***
*/

Select OwnerAddress from [PortfolioProject].[dbo].[NashvilleHousing]

Select
PARSENAME ( REPLACE ( OwnerAddress , ',', '.') , 3),
PARSENAME ( REPLACE ( OwnerAddress , ',', '.') , 2),
PARSENAME ( REPLACE ( OwnerAddress , ',', '.') , 1)
from [PortfolioProject].[dbo].[NashvilleHousing]

AlTER Table [PortfolioProject].[dbo].[NashvilleHousing]
ADD OwnerSplitAdress NVARCHAR(255);

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set OwnerSplitAdress = PARSENAME ( REPLACE ( OwnerAddress , ',', '.') , 3)

AlTER Table [PortfolioProject].[dbo].[NashvilleHousing]
ADD OwnerSplitCity NVARCHAR(100);

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set OwnerSplitCity = PARSENAME ( REPLACE ( OwnerAddress , ',', '.') , 2)

AlTER Table [PortfolioProject].[dbo].[NashvilleHousing]
ADD OwnerSplitState NVARCHAR(255);

Update [PortfolioProject].[dbo].[NashvilleHousing]
Set OwnerSplitState = PARSENAME ( REPLACE ( OwnerAddress , ',', '.') , 1)

Select * from [PortfolioProject].[dbo].[NashvilleHousing]

/*
***
ÉTAPE 5 — Normalisation de SoldAsVacant
Analyse les valeurs existantes puis transforme Y/N en Yes/No avec CASE.
***
*/

-- change Y and N to Yes and No in soldAsVacant column

Select DISTINCT( SoldAsVacant)from [PortfolioProject].[dbo].[NashvilleHousing]

Select DISTINCT( SoldAsVacant) , count( SoldAsVacant)
from [PortfolioProject].[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant ,
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
     END
from [PortfolioProject].[dbo].[NashvilleHousing]

Update [PortfolioProject].[dbo].[NashvilleHousing]
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
     END

/*
***
ÉTAPE 6 — Identification et suppression des doublons
Utilise ROW_NUMBER() dans une CTE pour identifier puis supprimer les enregistrements dupliqués.
***
*/

-- Remove Duplicate

Select * from [PortfolioProject].[dbo].[NashvilleHousing]

With RowNumCTE as (
Select *, ROW_NUMBER()
Over (
Partition by [ParcelID],
             [PropertyAddress],
             [SalePrice],
             [SaleDate],
             [LegalReference]
             Order by [UniqueID ]) as Row_Num
from [PortfolioProject].[dbo].[NashvilleHousing]
)
Select * from RowNumCTE
where Row_Num >1

DELETE from RowNumCTE
where Row_Num > 1

Select * from [PortfolioProject].[dbo].[NashvilleHousing]

/*
***
ÉTAPE 7 — Suppression des colonnes devenues inutiles
Supprime les colonnes sources qui ne sont plus nécessaires après le nettoyage.
***
*/

-- DELETE UNUSED Columns

Select * from [PortfolioProject].[dbo].[NashvilleHousing]

ALTER table [PortfolioProject].[dbo].[NashvilleHousing]
DROP COLUMN [PropertyAddress],[OwnerAddress],[TaxDistrict]

ALTER table [PortfolioProject].[dbo].[NashvilleHousing]
DROP COLUMN [SaleDate]
