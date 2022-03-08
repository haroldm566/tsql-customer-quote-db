--Use the stored procedures createCustomer, createQuote and addQuoteComponent
--to populate the database with the customer-quote information (attached). Hand in the
--script you wrote to perform this task.

--	Use the assignment database
USE mandha1_IN705Assignment1;

--	Create customers
EXEC dbo.createCustomer 'Bimble & Hat', '444 5555', NULL, NULL, 'guy.little@bh.biz.nz', NULL, '123 Digit Street, Dunedin'
EXEC dbo.createCustomer 'Hyperfont Modulator (Int.) Ltd.', '(4) 213 4359', NULL, NULL, 'sue@nz.hfm.com', NULL, '3 Lambton Quay, Wellington'

--	Create quotes and quote components
DECLARE @bimble INT
SELECT @bimble = cu.CustomerID FROM Customer cu
JOIN Contact co ON cu.CustomerID = co.ContactID
WHERE co.ContactName = 'Bimble & Hat'
PRINT @bimble

--	//	Quote: Craypot frame	//
DECLARE @qID INT
EXEC dbo.createQuote 'Craypot frame', '', 'Laurenz Franz Xavier', @bimble, @qID OUTPUT

--3 of 15mm square strap assembly
EXEC addQuoteComponent 30935, 1, 3
--8 of 1250mm length BMS.5.15 ms 
EXEC addQuoteComponent 30912, 1, 8
--bar 24 of BMS10 bolt
EXEC addQuoteComponent 30901, 1, 24
--24 of NMS10 nut
EXEC addQuoteComponent 30904, 1, 24
--200ml of anti-rust paint, blue
EXEC addQuoteComponent 30933, 1, '200ml'
--150 minutes of artisan labour
EXEC addQuoteComponent 30921, 1, '150min'
--120 minutes of apprentice labour
EXEC addQuoteComponent 30923, 1, '120min'
--45 minutes of designer labour
EXEC addQuoteComponent 30922, 1, '45min'

--	//	Quote: Craypot stand	//
EXEC dbo.createQuote 'Craypot stand', '', 'John Cena', @bimble, @qID OUTPUT

--2 of 2565mm length BMS.15.40 ms
EXEC addQuoteComponent 30914, 2, 2
--bar 4 of BMS15 bolt
EXEC addQuoteComponent 30903, 2, 4
--4 of NMS15 nut
EXEC addQuoteComponent 30906, 2, 4
--100ml of anti-rust paint, blue
EXEC addQuoteComponent 30933, 2, '100ml'
--90 minutes of apprentice labour
EXEC addQuoteComponent 30923, 2, '90min'
--15 minutes of designer labour
EXEC addQuoteComponent 30922, 2, '45min'

--	//	Get the ID of Hyperfont automatically
DECLARE @hyperfont INT
SELECT @hyperfont = cu.CustomerID FROM Customer cu
JOIN Contact co ON cu.CustomerID = co.ContactID
WHERE co.ContactName = 'Hyperfont Modulator (Int.) Ltd.'
PRINT @hyperfont

--	//	Quote: Craypot stand	//
EXEC dbo.createQuote 'Phasing restitution fulcrum', '', 'Chris Bumstead', @hyperfont, @qID OUTPUT

--3 of 15mm corner brace
EXEC addQuoteComponent 30936, 3, 3
--assembly 1 of 15mm small corner
EXEC addQuoteComponent 30934, 3, 1
--320 minutes of artisan labour 105
EXEC addQuoteComponent 30921, 3, '320min'
--minutes of designer labour 0.5
EXEC addQuoteComponent 30922, 3, '105min'
--litre of anti-rust paint, red
EXEC addQuoteComponent 30932, 3, '0.5L'
