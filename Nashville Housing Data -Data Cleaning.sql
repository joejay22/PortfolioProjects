
--Cleaning Data in SQL 
Select * 
from dbo.NashvilleHousing;


------------------------------------------------------------------------------------------------------------------
--Standardize Date Format using Convert

Select SaleDate, CONVERT(Date,SaleDate)
from dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)


------------------------------------------------------------------------------------------------------------------
--Pupulate Property Address data 

Select *
from dbo.NashvilleHousing
where PropertyAddress is null
--order by ParcelID

--Parcel ID matches property address to fill in Nulls we will join in the tables 
Select a.ParcelID, a.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a 
join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null 

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a 
join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------

--Organizing Address Into Individual Columns (Address, City, State)

Select PropertyAddress
from dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address 
from dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

/* Select*
from dbo.NashvilleHousing */
--Now I will update the owner address that are null

Select Owneraddress
from dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
from dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

---------------------------------------------------------------------------------------------------------------------------------------

--Changing Y and N to yes and no in Sold as Vacant

Select Distinct(SoldAsVacant)
from dbo.NashvilleHousing


Select SoldAsVacant,
	CASE
		When SoldAsVacant ='Y' THEN 'Yes'
		When SoldAsVacant ='n' THEN 'No'
		else SoldAsVacant
		END
From dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE
		When SoldAsVacant ='Y' THEN 'Yes'
		When SoldAsVacant ='N' THEN 'No'
		else SoldAsVacant
		END

---------------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates
WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID)
				row_num

From dbo.NashvilleHousing

)
Select *
from RowNumCTE
where row_num >1
--order by PropertyAddress

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
from dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, SaleDate, TaxDistrict, PropertyAddress


