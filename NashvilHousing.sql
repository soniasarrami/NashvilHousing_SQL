
-- Checking data in queries 

SELECT *
FROM SQL_Cleaning..NashvilHousing

-- Standardize Date format


SELECT SaleDataConverted, CONVERT(date,SaleDate) 
FROM SQL_Cleaning..NashvilHousing

Update NashvilHousing
Set SaleDate = CONVERT(date,SaleDate) 

ALTER Table Nashvilhousing
add SaleDataConverted Date;

Update NashvilHousing
Set SaleDataConverted = CONVERT(date,SaleDate) 


-- Populate property address data

SELECT *
FROM SQL_Cleaning..NashvilHousing
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM SQL_Cleaning..NashvilHousing a
join SQL_Cleaning..NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


update a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM SQL_Cleaning..NashvilHousing a
join SQL_Cleaning..NashvilHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 



-- Breaking address into individual columns based on (Address, City, State)

SELECT PropertyAddress
FROM SQL_Cleaning..NashvilHousing
--where PropertyAddress is null
-- order by ParcelID


SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address,
 SUBSTRING (PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress) )as Address

FROM SQL_Cleaning..NashvilHousing


ALTER Table Nashvilhousing
add PropertySplitAddress Nvarchar(255);

Update NashvilHousing
Set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)


ALTER Table Nashvilhousing
add PropertySplitCity Nvarchar(255);

Update NashvilHousing
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress) )




select *
FROM SQL_Cleaning..NashvilHousing



select OwnerAddress
FROM SQL_Cleaning..NashvilHousing


select 
PARSENAME (Replace (OwnerAddress, ',', '.') ,3),
PARSENAME (Replace (OwnerAddress, ',', '.') ,2),
PARSENAME (Replace (OwnerAddress, ',', '.') ,1)
FROM SQL_Cleaning..NashvilHousing


ALTER Table Nashvilhousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilHousing
Set OwnerSplitAddress = PARSENAME (Replace (OwnerAddress, ',', '.') ,3)


ALTER Table Nashvilhousing
add OwnerSplitCity Nvarchar(255);

Update NashvilHousing
Set OwnerSplitCity = PARSENAME (Replace (OwnerAddress, ',', '.') ,2)


ALTER Table Nashvilhousing
add OwnerSplitState Nvarchar(255);

Update NashvilHousing
Set OwnerSplitState2 = PARSENAME (Replace (OwnerAddress, ',', '.') ,1)

select *
FROM SQL_Cleaning..NashvilHousing



-- Change Y and N to Yes and No in "sold as vacant" field

select distinct (SoldAsVacant), count(SoldAsVacant)
FROM SQL_Cleaning..NashvilHousing
group by SoldAsVacant
order by 2 desc

select SoldAsVacant,
Case WHEN SoldAsVacant = 'y'then 'Yes'
     WHEN SoldAsVacant = 'n' then 'No'
	 else SoldAsVacant
	 end
FROM SQL_Cleaning..NashvilHousing


update NashvilHousing
set SoldAsVacant = Case WHEN SoldAsVacant = 'y'then 'Yes'
     WHEN SoldAsVacant = 'n' then 'No'
	 else SoldAsVacant
	 end

select distinct (SoldAsVacant), count(SoldAsVacant)
FROM SQL_Cleaning..NashvilHousing
group by SoldAsVacant
order by 2 desc


-- Removing duplicates

WITH RowNumCTE AS (
select *, 
	ROW_NUMBER() over(
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID) row_num
FROM SQL_Cleaning..NashvilHousing
--ORDER BY ParcelID
)
DELETE 
from RowNumCTE
where row_num >1


-- DELETE Unused columns

select *
FROM SQL_Cleaning..NashvilHousing

ALTER TABLE SQL_Cleaning..NashvilHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress, OnwerSplitState, OnwerSplitState1, OwerSplitState, OwerSplitState2


ALTER TABLE SQL_Cleaning..NashvilHousing
DROP COLUMN SaleDate