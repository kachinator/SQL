DROP TABLE IF EXISTS dbo.Inventory

-- Create table
CREATE TABLE dbo.Inventory
(
	ProdCategory nvarchar(50),
	ProdNumber  nvarchar(50),
	ProdName  nvarchar(50),
	RetailPrice  float,
	Cost  float,
	InStock  int,
	InventoryOnHand  float
)

select * from dbo.Inventory

-----------------------------------------------------------

DROP TABLE IF EXISTS dbo.EmployeeDirectory

-- Create table
CREATE TABLE dbo.EmployeeDirectory
(
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Title  nvarchar(50),
	Department nvarchar(50),
	Email  nvarchar(50),
	DepartmentID  nvarchar(50),
	EmployeeID  nvarchar(50),
	Manager  nvarchar(50)
)

select * from dbo.EmployeeDirectory

-----------------------------------------------------------

DROP TABLE IF EXISTS dbo.OnlineRetailSales

-- Create table
CREATE TABLE dbo.OnlineRetailSales
(
	OrderNum  int,
	OrderDate DATETIME,
	OrderType nvarchar(50),
	CustomerType nvarchar(50),
	CustName  nvarchar(50),
	CustState  nvarchar(50),
	ProdCategory  nvarchar(50),
	ProdNumber  nvarchar(50),
	ProdName  nvarchar(50),
	Quantity  int,
	Price  float,
	Discount  nvarchar(50),
	OrderTotal  float
)

select * from dbo.OnlineRetailSales

-----------------------------------------------------------

DROP TABLE IF EXISTS dbo.SpeakerInfo

-- Create table
CREATE TABLE dbo.SpeakerInfo
(
	SessionName nvarchar(50),
	StartDate DATETIME,
	Name nvarchar(50),
	Organization nvarchar(50),
	EndDate  DATETIME,
	RoomName  int
)

select * from dbo.SpeakerInfo

-----------------------------------------------------------

DROP TABLE IF EXISTS dbo.SessionInfo

-- Create table
CREATE TABLE dbo.SessionInfo
(
	StartDate DATETIME,
	EndDate  DATETIME,
	SessionName nvarchar(100),
	SpeakerName nvarchar(50),
	RoomName  int
)

select * from dbo.SessionInfo

-----------------------------------------------------------

DROP TABLE IF EXISTS dbo.ConventionAttendees

-- Create table
CREATE TABLE dbo.ConventionAttendees
(
	RegistrationDate DATETIME,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	Email nvarchar(50),
	PhoneNumber nvarchar(50),
	Address nvarchar(50),
	City nvarchar(50),
	State nvarchar(50),
	Zip nvarchar(50),
	Package nvarchar(50),
	PackageCost  float,
	Discount nvarchar(50),
	DiscountAmount float,
	AmountPaid float,
	PaymentType nvarchar(50),
	Last4CardDigits int,
	AuthorizationN nvarchar(50)

)

select * from dbo.ConventionAttendees


-----------------------------------------------------------