/*

Cleaning Data in SQL Queries

*/


Select *
From NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format







ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From NashvilleHousing
order by ParcelID



Select nash1.ParcelID, nash1.PropertyAddress, nash2.ParcelID, nash2.PropertyAddress, ISNULL(nash1.PropertyAddress, nash2.PropertyAddress)
From NashvilleHousing nash1
JOIN NashvilleHousing nash2
	on nash1.ParcelID = nash2.ParcelID
	AND nash1.[UniqueID ] <> nash2.[UniqueID ]
Where nash1.PropertyAddress is null


Update nash1
SET PropertyAddress = ISNULL(nash1.PropertyAddress, nash2.PropertyAddress)
From NashvilleHousing nash1
JOIN NashvilleHousing nash2
	on nash1.ParcelID = nash2.ParcelID
	AND nash1.[UniqueID ] <> nash2.[UniqueID ]
Where nash1.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as city
from NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))





Select OwnerAddress
From NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress,',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress,',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)
from NashvilleHousing
where OwnerAddress is not null

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)

Select *
From NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE
WHEN SoldAsVacant = 'N' THEN 'NO'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END
from NashvilleHousing
where SoldAsVacant = 'N'


update NashvilleHousing
set SoldAsVacant = CASE
WHEN SoldAsVacant = 'N' THEN 'NO'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


with rownumcte as(

select *,
ROW_NUMBER() over(
partition by ParcelID,
		     PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
		order by UniqueID) row_num
from NashvilleHousing
--order by ParcelID
)

select *
from rownumcte
where row_num > 1


with rownumcte as(

select *,
ROW_NUMBER() over(
partition by ParcelID,
		     PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
		order by UniqueID) row_num
from NashvilleHousing
--order by ParcelID
)

delete
from rownumcte
where row_num > 1




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
