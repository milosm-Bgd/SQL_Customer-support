/*
2. napraviti bazu Korisnicke podrske, sa tabelama Korisnik, Operater, Ugovor, Oprema, napuniti atributima , 
primerima, i nakon toga napraviti min 10 upita gde ce se pokazati spajanje, funkcije, razni uslovi.
*/

SHOW databases;

SELECT database();

CREATE DATABASE IF NOT EXISTS Korisnicka_podrska;

USE Korisnicka_podrska;

/*CREATE TABLE BLOCK*/

DROP TABLE IF EXISTS Supplier;
CREATE TABLE Supplier (
    SupplierID INT NOT NULL PRIMARY KEY,
    SupplierName VARCHAR(55),
    Location VARCHAR(55)
);

DROP TABLE IF EXISTS Contract;
CREATE TABLE Contract (
    ContractID INT NOT NULL PRIMARY KEY,
    ContractName VARCHAR(55),
    ContractValue DECIMAL(10,2),
    ContractLength VARCHAR(55),
    CustomerID INT, 
    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
);

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
    CustomerID INT NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(55),
    Phone VARCHAR(55),
    Country VARCHAR(55),
    City VARCHAR(55),
    ContractDate DATE,
    SupplierID INT,     
	FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
); 

DROP TABLE IF EXISTS Equipment;
CREATE TABLE Equipment (
    EquipmentID INT NOT NULL PRIMARY KEY,
    EquipmentName VARCHAR(55),
    Origin VARCHAR(55)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    OrderID INT NOT NULL PRIMARY KEY,
    OrderDate DATE,
    OrderValue DECIMAL(10,2),
    ShippingDate DATE,
    City VARCHAR(55),
    CustomerID INT,  
    SupplierID INT, 
    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
	FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
); 

DROP TABLE IF EXISTS Claims;
CREATE TABLE Claims (
    ClaimID INT NOT NULL PRIMARY KEY,
    DescriptionNote VARCHAR(55),
    ClaimCases INT,
    CustomerID INT,  
    SupplierID INT, 
    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
	FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
);

show tables;

/*INSERT VALUES BLOCK*/

INSERT INTO Supplier (SupplierID, SupplierName, Location)
VALUES (1, 'MTS', 'Serbia'),
	(2, 'Telenor', 'Norway'),
    (3, 'A1', 'Austria');
SELECT * FROM Supplier;
 
INSERT INTO Customer (CustomerID, CustomerName, Phone, Country, City, ContractDate, SupplierID)
VALUES (1, 'Marko Markovic', '021 555-666', 'Serbia', 'Novi Sad', '2012-06-01', 2),
	(2, 'Janko Jankovic', '031 777-888', 'Montenegro', 'Podgorica', '2019-06-01', 3),
    (3, 'Branko Brankovic', '071 222-333', 'Bosnia', 'Sarajevo', '2021-06-01', 1);
SELECT * FROM Customer;

INSERT INTO Contract (ContractID, ContractName, ContractValue, ContractLength, CustomerID)
VALUES (1, 'Omorika', 1500, '12 months', 1),
	(2, 'Soko', 1800, '18 months', 2),
    (3, 'Morava', 2000, '24 months', 3);
SELECT * FROM Contract;

INSERT INTO Equipment (EquipmentID, EquipmentName, Origin)
VALUES (1, 'via_sat', 'China'),
	(2, 'sat_new', 'Taiwan'),
    (3, 'space_one', 'Korea');
SELECT * FROM Equipment;

INSERT INTO Orders (OrderID, OrderDate, OrderValue, ShippingDate, CustomerID, SupplierID)
VALUES (1, '2023-03-01', '4500', '2023-08-01', 2, 1),
	(2, '2023-04-01', '8000', '2023-08-15', 1, 3),
    (3, '2022-11-01', '7200', '2023-03-01', 3, 2),
    (4, '2022-06-01', '5600', '2022-09-15', 2, 2),
    (5, '2022-01-01', '8800', '2022-04-01', 3, 3),
    (6, '2021-08-01', '12200','2021-10-16', 3, 2),
    (7, '2021-03-01', '9600', '2021-05-02', 3, 2),
    (8, '2020-10-01', '12200', '2020-11-16', 2, 1),
    (9, '2020-05-01', '2800', '2020-08-02', 1, 3)
    ;
SELECT * FROM Orders;

INSERT INTO Claims (ClaimID, DescriptionNote, ClaimCases, CustomerID, SupplierID)
VALUES (1, 'Nedovoljna jacina signala', 4, 2, 2),
	(2, 'Mala pokrivenost u zemlji', 3, 1, 2),
    (3, 'Spor protok informacija', 6, 3, 1);
SELECT * FROM Claims;

/*QUERIES BLOCK*/

-- 1. Izbaci ime korisnika koji je kupio paket / ugovor "Omorika"
SELECT 
    c.customername, c.city , contractdate
FROM
    customer c
        JOIN
    contract cn ON c.contractID = cn.contractID
WHERE
    cn.contractname = 'Omorika';
    
-- 2. izbaci sve ordere iz 2023 god gde je korisnik iz Novog Sada
SELECT 
    o.orderid, c.customername, c.city
FROM
    orders o
        JOIN
    customer c ON o.customerid = c.customerid
WHERE
    c.city = 'Novi Sad'
        AND orderdate BETWEEN '2023-01-01' AND '2023-12-31';
        
-- 3. izbaci sve ordere iz 2022 god gde je korisnik iz Sarajeva
SELECT 
    o.orderid, c.customername, c.city
FROM
    orders o
        JOIN
    customer c ON o.customerid = c.customerid
WHERE
    c.city = 'Sarajevo'
        AND orderdate BETWEEN '2022-01-01' AND '2022-12-31';
       
-- 4.primer sa inner/nested join:  izbaci sve korisnike kojima ugovor istice posle 12 meseci 
SELECT 
    c.customername, c.contractdate, cn.contractid, cn.contractname
FROM
    customer c
        JOIN
    contract cn ON c.customerid = cn.customerid
WHERE
    cn.contractID IN (SELECT 
            contractID
        FROM
            contract
        WHERE
            contractlength = '12 months');

-- 5.primer sa inner/nested join:  izbaci sve korisnike koji nemaju reklamacije  

SELECT 
    cl.claimID, c.customername
FROM
    claims cl
        JOIN
    customer c ON cl.customerid = c.customerid
WHERE
    claimcases IS NULL;
    
-- 5.primer sa inner/nested join:  izbaci sve korisnike koji imaju vise od 5 reklamacija  

SELECT 
    cl.claimID, c.customername
FROM
    claims cl
        JOIN
    customer c ON cl.customerid = c.customerid
WHERE
    claimcases  > 5;
    
    
-- 6. izabaciti sve korisnike koji se zale na nedovoljan signal i navesti naziv operatera u opadajucem redoseldu      
    SELECT 
    c.customername, contractid, DescriptionNote, s.suppliername
FROM
    claims cl
        JOIN
    customer c ON cl.customerid = c.customerid
        JOIN
    supplier s ON c.supplierid = s.supplierid
        JOIN
    contract cn ON c.customerid = cn.customerid
WHERE
    DescriptionNote LIKE '%jacina signala'
ORDER BY suppliername DESC;
    
-- 7 . izbaciti korisnika sa najvecom narudzbenicom kod operatera MTS 
    SELECT 
    MAX(ordervalue), c.customerid, s.suppliername
FROM
    orders o
        JOIN
    customer c ON o.customerid = c.customerid
        JOIN
    supplier s ON o.supplierid = s.supplierid
WHERE
    s.suppliername = 'MTS'
GROUP BY suppliername
ORDER BY suppliername DESC;


-- 8 . izbaciti korisnika sa najmanjom narudzbenicom kod operatera A1 

    SELECT 
    MIN(ordervalue), c.customerid, s.suppliername
FROM
    orders o
        JOIN
    customer c ON o.customerid = c.customerid
        JOIN
    supplier s ON o.supplierid = s.supplierid
WHERE
    s.suppliername = 'A1'
GROUP BY suppliername
ORDER BY suppliername ASC;


-- 9 . grupisati sve naloge po operaterima i sortirati u opadajucem tj rastucem redoseldu 

    SELECT 
    COUNT(orderid) AS broj_naloga_po_operateru, 
    #c.customerid, 
    #c.customername, 
    s.suppliername
FROM
    orders o
        JOIN
    #customer c ON o.customerid = c.customerid
    #    JOIN
    supplier s ON o.supplierid = s.supplierid
#WHERE
#s.suppliername = 'A1'
GROUP BY suppliername
ORDER BY suppliername ASC;

-- 10 . grupisati sve naloge po operaterima i sortirati u rastucem redoseldu
-- a) bez vremenskih okvira
-- b) u toku 2022 god. 

-- a)
   SELECT 
    COUNT(orderid) AS broj_naloga_po_operateru,
    SUM(ordervalue) AS zbir_naloga_po_operateru,
    s.suppliername
FROM
    orders o
        JOIN
    supplier s ON o.supplierid = s.supplierid
GROUP BY suppliername
ORDER BY zbir_naloga_po_operateru DESC;
 
-- b)
    SELECT 
    COUNT(orderid) AS broj_naloga_po_operateru,
    SUM(ordervalue) AS zbir_naloga_po_operateru,
    s.suppliername
FROM
    orders o
        JOIN
    supplier s ON o.supplierid = s.supplierid
WHERE
    o.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY suppliername
ORDER BY zbir_naloga_po_operateru DESC;

