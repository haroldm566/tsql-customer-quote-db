--	Use the assignment database (RUN THIS FOR EVERY SCRIPT)
USE mandha1_IN705Assignment1;

--	Check tables
SELECT * FROM Contact
SELECT * FROM Supplier
SELECT * FROM Category
SELECT * FROM Component
SELECT * FROM AssemblySubcomponent
SELECT * FROM Customer
SELECT * FROM Quote
SELECT * FROM QuoteComponent

--	Delete all rows from a table
DELETE FROM QuoteComponent
DELETE FROM AssemblySubcomponent
DELETE FROM Quote
DELETE FROM Component
DELETE FROM Category
DELETE FROM Customer
DELETE FROM Supplier
DELETE FROM Contact

--	// Drop tables //
DROP TABLE AssemblySubcomponent;
DROP TABLE QuoteComponent;
DROP TABLE Quote;
DROP TABLE Component;
DROP TABLE Customer;
DROP TABLE Category;
DROP TABLE Supplier;
DROP TABLE Contact;

--	// Debugging commands //
--	Reset ID values of identity column(s) back to 0
--DECLARE @contactMaxId INT
--SELECT @contactMaxId = MAX(ContactID) FROM Contact

DBCC CHECKIDENT ('Contact', RESEED, 0);
DBCC CHECKIDENT ('Category', RESEED, 0);
DBCC CHECKIDENT ('Quote', RESEED, 0);

--drop functions, views and sp
DROP PROCEDURE createCustomer
DROP PROCEDURE createAssembly
DROP PROCEDURE addSubComponent

DROP FUNCTION dbo.getCategoryID
DROP FUNCTION dbo.getAssemblySupplierID

DROP TRIGGER trigSupplierDelete
DROP TRIGGER componentUC