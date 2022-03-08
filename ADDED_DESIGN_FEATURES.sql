--	Use the assignment database
USE mandha1_IN705Assignment1;

--Design and implement a stored procedure createCustomer(Name, Phone, 
--PostalAddress, Email, WWW, Fax, MobilePhone) Output: CustomerID that inserts a 
--new customer to the database. The stored procedure will accept parameters that will 
--provide the data for the new customer. As appropriate, make parameters optional 
--depending on the properties of the underlying columns. The procedure returns the new 
--CustomerID created by the procedure.
GO
CREATE OR ALTER PROCEDURE createCustomer(@name VARCHAR(100), @phone VARCHAR(25), @fax VARCHAR(255) = NULL, @mobilePhone VARCHAR (11) = NULL,  @email VARCHAR(255) = NULL, @www VARCHAR(255) = NULL, @postalAddress VARCHAR(255))
AS
	INSERT INTO Contact (ContactName, ContactPhone, ContactFax, ContactMobilePhone, ContactEmail, ContactWWW, ContactPostalAddress)
	VALUES (@name, @phone, @fax, @mobilePhone, @email, @www, @postalAddress)

	DECLARE @newCustomerId INT
	SET @newCustomerId = @@IDENTITY

	--	Insert newly-made ContactID into Supplier table
	INSERT INTO Supplier (SupplierID, SupplierGST)
	VALUES (@newCustomerId, 0.00)

	--	Insert newly-made ContactID into Customer table
	INSERT INTO Customer (CustomerID)
	VALUES (@newCustomerId)

	PRINT CONCAT('The newly created CustomerID is ', @newCustomerId)
GO

--Design and implement two stored procedures createQuote(QuoteDescription, 
--QuoteDate, QuoteCompiler, CustomerID, QuoteID OUTPUT) and 
--addQuoteComponent(QuoteID, ComponentID, Quantity) that inserts a new quote 
--data to the database. 
--The stored procedures will accept parameters that will provide the 
--data for the new quote. As appropriate, make parameters optional depending on the 
--properties of the underlying columns. Make createQuote.QuoteDate optional, defaulting 
--to the current datetime. Notice that QuoteComponent table captures the component 
--prices and timeToFit at the moment the QuoteComponent is created
GO
CREATE OR ALTER PROCEDURE createQuote(@quoteDescription VARCHAR(150), @quoteDate DATE = '', @quoteCompiler VARCHAR (255), @customerID INT, @quoteID INT OUTPUT)
AS
	--	Format YYYY-MM-DD
	IF @quoteDate = ''
		SET @quoteDate = CAST(GETDATE() AS DATE)

	INSERT INTO Quote (QuoteDescription, QuoteDate, QuotePrice, QuoteCompiler, CustomerID)
	VALUES (@quoteDescription, @quoteDate, 0.00, @quoteCompiler, @customerID)

	SET @quoteID = @@IDENTITY
GO

--	addQuoteComponent stored proc
GO
CREATE OR ALTER PROCEDURE addQuoteComponent(@componentId INT, @quoteId INT, @quantity NVARCHAR(50))
AS
	--use insert select
	--	grab tradeprice, listprice and timetofit from component
	INSERT INTO QuoteComponent (ComponentID, QuoteID, Quantity, TradePrice, ListPrice, TimeToFit)
	SELECT c.ComponentID, @quoteId AS [QuoteID], @quantity AS [Quantity], c.TradePrice, c.ListPrice, c.TimeToFit FROM Component c
	WHERE c.ComponentID = @componentId
GO

--** This is in place of the uC in the diagram ** Design and implement the triggers 
--necessary to implement cascade update on constraints FK_Assembly_Component
--and FK_Subcomponent_Component.
GO
CREATE OR ALTER TRIGGER componentUC ON Component
AFTER UPDATE
AS
IF ((SELECT ComponentID FROM inserted) != (SELECT ComponentID FROM deleted))
BEGIN
	SET IDENTITY_INSERT Component ON
	INSERT Component 
	SELECT * FROM inserted
	SET IDENTITY_INSERT Component OFF
END
GO

--Design and implement a trigger trigSupplierDelete that reacts to a Supplier record 
--being deleted. If the supplier has one or more related component(s) the deletion will be 
--cancelled and the error message ‘You cannot delete this supplier. XYZ has K related 
--components.’ printed in the messages window [substitute XYZ -> SupplierName, K -> 
--number of related components ].
GO
CREATE OR ALTER TRIGGER trigSupplierDelete ON Supplier
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @componentCount INT
	DECLARE @supplierName VARCHAR(100)
	DECLARE @supplierID INT

	--	Grab total number of components with this supplier
	SELECT @componentCount = COUNT(c.SupplierID) FROM Component c
	JOIN deleted d ON c.SupplierID = d.SupplierID
	WHERE c.SupplierID = d.SupplierID

	--	Grab the to-be-deleted Supplier's name and ID
	SELECT @supplierName = co.ContactName, @supplierID = co.ContactID FROM Contact co
	JOIN deleted d ON co.ContactID = d.SupplierID
	WHERE co.ContactID = d.SupplierID

	--	Cancel delete if there's more than 1 component with this supplier on record
	IF @componentCount >= 1
		PRINT CONCAT('You cannot delete this supplier. ', @supplierName, ' has ', @componentCount, ' related components.')
	ELSE
		DELETE FROM Supplier
		WHERE SupplierID = @supplierID
END
GO
--	Ensure you can't delete a supplier with components related to it
DELETE FROM Supplier
WHERE SupplierID = 4

--	Delete a supplier without any related components
insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('Meme Company', 'Test Street', 'www.facebooks', 'teeeeeeee@email.com', '133 2331', null)

INSERT INTO Supplier (SupplierID, SupplierGST)
VALUES (7, 0.00)

DELETE FROM Supplier
WHERE SupplierID = 7

--Design and implement a stored procedure updateAssemblyPrices() that will efficiently
--and completely update the trade price and list price of all assemblies. The trade price is
--the total of all subcomponent trade prices. The list price is the total of all subcomponent
--list prices.

GO
CREATE OR ALTER PROCEDURE updateAssemblyPrices
AS
	DECLARE @ttlTradePrice DECIMAL(6,2)
    DECLARE @ttlListPrice DECIMAL(6,2)

    SELECT @ttlTradePrice = SUM(TradePrice) FROM QuoteComponent
    SELECT @ttlListPrice = SUM(ListPrice) FROM QuoteComponent

	--	Update component trade and list prices
    UPDATE Component 
	SET TradePrice = @ttlTradePrice

	UPDATE Component 
	SET ListPrice = @ttlListPrice 

	--	Update QuoteComponent trade and list prices
    UPDATE QuoteComponent 
	SET TradePrice = @ttlTradePrice

    UPDATE QuoteComponent 
	SET ListPrice = @ttlListPrice 
GO

--	BONUS!!!!!!!!!!!!
-- Design and implement a stored procedure testCyclicAssembly(assemblyID):isCyclic that
--will test if an assembly directly or indirectly contains itself as a subcomponent. The
--procedure returns a bit (1 = true; assembly is cyclic, 0 = false; assembly is not cyclic) as
--the test result 
GO
CREATE OR ALTER PROCEDURE testCyclicAssembly(@assemblyID INT, @isCyclic BIT OUTPUT)
AS
	IF (@assemblyID IN (SELECT assc.AssemblyID FROM AssemblySubcomponent assc WHERE assc.AssemblyID = @assemblyID)
		OR @assemblyID IN (SELECT assc.SubcomponentID FROM AssemblySubcomponent assc WHERE assc.SubcomponentID = @assemblyID))
		SET @isCyclic = 1		
	ELSE
		SET @isCyclic = 0
GO

--	Test testCyclicAssembly procedure
DECLARE @isCyclic INT

--	true
EXEC testCyclicAssembly 30934, @isCyclic OUTPUT
SELECT @isCyclic AS 'Is it cyclic?'

--	false
EXEC testCyclicAssembly 30913, @isCyclic OUTPUT
SELECT @isCyclic AS 'Is it cyclic?'
