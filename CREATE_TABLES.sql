--	Use the assignment database
USE mandha1_IN705Assignment1;

--	Create the tables along with constraints
CREATE TABLE Category (
	CategoryID INT IDENTITY (1, 1) PRIMARY KEY,
	CategoryName VARCHAR (255) NOT NULL
);

CREATE TABLE Contact (
	ContactID INT IDENTITY (1, 1) PRIMARY KEY,
	ContactName VARCHAR (100) NOT NULL,
	ContactPhone VARCHAR (25) NOT NULL,
	ContactFax VARCHAR (255),
	ContactMobilePhone VARCHAR (11),
	ContactEmail VARCHAR (255),
	ContactWWW VARCHAR (255),
	ContactPostalAddress VARCHAR (255) NOT NULL
);


CREATE TABLE Supplier (
	SupplierID INT NOT NULL PRIMARY KEY,
	SupplierGST DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (SupplierID) REFERENCES Contact (ContactID) ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE Customer (
	CustomerID INT NOT NULL PRIMARY KEY,
	FOREIGN KEY (CustomerID) REFERENCES Contact (ContactID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Component (
	ComponentID INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	ComponentName VARCHAR (100) NOT NULL,
	ComponentDescription VARCHAR (150) NOT NULL,
	TradePrice DECIMAL (10, 2) CHECK (TradePrice >= 0) NOT NULL,
	ListPrice DECIMAL (10, 2) CHECK (ListPrice >= 0) NOT NULL,
	TimeToFit CHAR (255) NOT NULL,	-- ***************************************	Uncertain what data-type to use
	CategoryID INT NOT NULL,
	SupplierID INT NOT NULL,
	FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE Quote (
	QuoteID INT IDENTITY (1, 1) PRIMARY KEY,
	QuoteDescription VARCHAR(150) NOT NULL,
	QuoteDate DATE NOT NULL, -- YYYY-MM-DD
	QuotePrice DECIMAL (10, 2) CHECK (QuotePrice >= 0),
	QuoteCompiler VARCHAR (255) NOT NULL,
	CustomerID INT NOT NULL,
	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE QuoteComponent (
	ComponentID INT NOT NULL,
	QuoteID INT NOT NULL,
	Quantity NVARCHAR(50) NOT NULL,
	TradePrice DECIMAL (10, 2) CHECK (TradePrice >= 0) NOT NULL,
	ListPrice DECIMAL (10, 2) CHECK (ListPrice >= 0) NOT NULL,
	TimeToFit CHAR (255) NOT NULL,		--	***********************************  Uncertain what data-type to use yet
	PRIMARY KEY (ComponentID, QuoteID),
	FOREIGN KEY (ComponentID) REFERENCES Component (ComponentID) ON DELETE NO ACTION,
	FOREIGN KEY (QuoteID) REFERENCES Quote (QuoteID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AssemblySubcomponent (
	AssemblyID INT NOT NULL,
	SubcomponentID INT NOT NULL,
	Quantity DECIMAL (9, 7) NOT NULL,
	PRIMARY KEY (AssemblyID, SubcomponentID),
	FOREIGN KEY (AssemblyID) REFERENCES Component (ComponentID) ON DELETE NO ACTION,
	FOREIGN KEY (SubcomponentID) REFERENCES Component (ComponentID) ON DELETE NO ACTION
);