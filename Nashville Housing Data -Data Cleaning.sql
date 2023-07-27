
--Cleaning Data in SQL 
Select * 
from dbo.NashvileHousing;


------------------------------------------------------------------------------------------------------------------
--Standardize Date Format using Convert

Select SaleDate, CONVERT(Date,SaleDate)
from dbo.NashvileHousing

Update NashvileHousing
Set SaleDate = Convert(Date,SaleDate)


------------------------------------------------------------------------------------------------------------------
--Pupulate Property Address data 

Select *
from dbo.NashvileHousing
where PropertyAddress is null
--order by ParcelID

--Parcel ID matches property address to fill in Nulls we will join in the tables 
Select a.ParcelID, a.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From dbo.NashvileHousing a 
join dbo.NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null 

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From dbo.NashvileHousing a 
join dbo.NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------

--Organizing Address Into Individual Columns (Address, City, State)

Select PropertyAddress
from dbo.NashvileHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address 
from dbo.NashvileHousing


ALTER TABLE NashvileHousing
add PropertySplitAddress Nvarchar(255);

Update NashvileHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvileHousing
ADD PropertySplitCity Nvarchar(255)

Update NashvileHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

/* Select*
from dbo.NashvileHousing */
--Now I will update the owner address that are null

Select Owneraddress
from dbo.NashvileHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
from dbo.NashvileHousing

ALTER TABLE NashvileHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvileHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


ALTER TABLE NashvileHousing
ADD OwnerSplitCity Nvarchar(255)

Update NashvileHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)


ALTER TABLE NashvileHousing
ADD OwnerSplitState Nvarchar(255)

Update NashvileHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

---------------------------------------------------------------------------------------------------------------------------------------

--Changing Y and N to yes and no in Sold as Vacant

Select Distinct(SoldAsVacant)
from dbo.NashvileHousing


Select SoldAsVacant,
	CASE
		When SoldAsVacant ='Y' THEN 'Yes'
		When SoldAsVacant ='n' THEN 'No'
		else SoldAsVacant
		END
From dbo.NashvileHousing

Update NashvileHousing
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

From dbo.NashvileHousing

)
Select *
from RowNumCTE
where row_num >1
--order by PropertyAddress

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
from dbo.NashvileHousing

ALTER TABLE dbo.NashvileHousing
DROP COLUMN OwnerAddress, SaleDate, TaxDistrict, PropertyAddress


