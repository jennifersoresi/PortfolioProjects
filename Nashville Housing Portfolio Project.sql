-- Cleaning data in SQL Queries

-- */

Select *
From PortfolioProject.dbo.[Nashville Housing]

-- Standardize date format

Select SaleDateConverted, CONVERT(Date, Saledate)
From PortfolioProject.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD SaleDateConverted Date;

Update [Nashville Housing]
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate property address data

Select *
From PortfolioProject.dbo.[Nashville Housing]
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Breaking out address into individual columns (address, city, state)

Select PropertyAddress
From PortfolioProject.dbo.[Nashville Housing]

Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD PropertySplitAddress NVarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
ADD PropertySplitCity NVarchar(255);

Update [Nashville Housing]
SET PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select OwnerAddress
From PortfolioProject.dbo.[Nashville Housing]

Select
Parsename(REPLACE(OwnerAddress, ',', '.'), 3)
, Parsename(REPLACE(OwnerAddress, ',', '.'), 2)
, Parsename(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD OwnerSplitAddress NVarchar(255);

ALTER TABLE [Nashville Housing]
ADD OwnerSplitCity NVarchar(255);

ALTER TABLE [Nashville Housing]
ADD OwnerSplitState NVarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = Parsename(REPLACE(OwnerAddress, ',', '.'), 3)

Update [Nashville Housing]
SET OwnerSplitCity = Parsename(REPLACE(OwnerAddress, ',', '.'), 2)

Update [Nashville Housing]
SET OwnerSplitState = Parsename(REPLACE(OwnerAddress, ',', '.'), 1)

-- Change Y and N to Yes or No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.[Nashville Housing]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	else SoldAsVacant
	end
From PortfolioProject.dbo.[Nashville Housing]

Update [Nashville Housing]
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	else SoldAsVacant
	end

-- Removing duplicates

With RowNumCTE As(
Select *,
	Row_number() Over (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.[Nashville Housing]
)
Select *
From RowNumCTE
Where row_num > 1

-- Delete unused columns

Alter table PortfolioProject.dbo.[Nashville Housing]
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table PortfolioProject.dbo.[Nashville Housing]
Drop column SaleDate



