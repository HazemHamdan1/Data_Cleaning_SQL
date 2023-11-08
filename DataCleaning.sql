/*
Cleaning Data in SQL Queries
*/


select* from Nashville_Housing

--------------------------------------------------------------------------

---- Standardize Date Format:

select saledateconverted ,convert(date,saledate)saledate
from Nashville_Housing

alter table [dbo].[Nashville_Housing]
add SaleDateConverted date

update Nashville_Housing
set [SaleDateConverted]=convert(date,saledate)

--------------------------------------------------------------------------

--populate property adress date :

select *
from Nashville_Housing
where PropertyAddress is null

select a.ParcelID , a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
	on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
	on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------

--Breaking out Address into individual columns (Address,City,State):

select PropertyAddress
from Nashville_Housing

select PropertyAddress, SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) state
from Nashville_Housing

alter table Nashville_Housing
add PropertySplitAddress nvarchar(255)

update Nashville_Housing
set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
from Nashville_Housing


alter table Nashville_Housing
add PropertySplitCity nvarchar(255)

update Nashville_Housing
set PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))
from Nashville_Housing

select *
from Nashville_Housing



select OwnerAddress
from Nashville_Housing

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from Nashville_Housing


alter table Nashville_Housing
add Ownersplitaddress nvarchar(255)

update Nashville_Housing
set Ownersplitaddress= PARSENAME(REPLACE(OwnerAddress,',','.'),3)
from Nashville_Housing

alter table Nashville_Housing
add Ownersplitcity nvarchar(255)

update Nashville_Housing
set Ownersplitcity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
from Nashville_Housing

alter table Nashville_Housing
add Ownersplitstate nvarchar(255)

update Nashville_Housing
set Ownersplitstate= PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from Nashville_Housing


select Ownersplitaddress,Ownersplitcity,Ownersplitstate
from Nashville_Housing

--------------------------------------------------------------------------

--Change Y and N to Yes and Now in (sold sa vacant) field:

select case
when SoldAsVacant='N' then 'No'
when SoldAsVacant='Y' then 'Yes'
else SoldAsVacant
end as new
from Nashville_Housing

update Nashville_Housing
set SoldAsVacant =case
when SoldAsVacant='N' then 'No'
when SoldAsVacant='Y' then 'Yes'
else SoldAsVacant
end 
from Nashville_Housing

select SoldAsVacant,count(SoldAsVacant)
from Nashville_Housing
group by SoldAsVacant

--------------------------------------------------------------------------

--Remove Dublicates:

with RowNumCTE as(
select * , ROW_NUMBER() over (partition by 
propertyAddress,
ParcelID,
SaleDate,
salePrice,
LegalReference
order by uniqueID
) as RowNum
from PortfolioProject..Nashville_Housing
)

Delete from RowNumCTE
where rownum > 1

--------------------------------------------------------------------------

--Delete Unwanted Columns:

select* 
from Nashville_Housing


alter table Nashville_Housing
drop column OwnerAddress,PropertyAddress,TaxDistrict


alter table Nashville_Housing
drop column SaleDate

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




