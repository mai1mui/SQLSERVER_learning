use master
	go

--Kiểm tra xem StrongHold có tồn tại thì xoá đi.
if exists(SELECT * FROM master..sysdatabases WHERE name='PolySite')
DROP DATABASE PolySite
	GO

--tạo DB tên polysite
create database PolySite
	go

--vào DB polysite
use PolySite
	go

--tạo bảng customer
create table Customer (
	CCode varchar(10) primary key not null,
	CName varchar(50),
	CAddress varchar(100),
	CPhone varchar(20)
	)
	go

--tạo bảng ordermaster
create table OrderMaster(
	OrderNo varchar(10) primary key not null,
	OrderDate datetime,
	CCode varchar(10) not null foreign key references Customer (CCode)
	)
	go

--tạo bảng item
create table Item(
	Icode varchar(20) primary key,
	ItemName varchar(50),
	Rate int
	)
	go

--tạo bảng orderdetails
create table OrderDetails(
	SrNo int identity(1,1),
	OrderNo varchar(10) not null foreign key references OrderMaster(OrderNo),
	ItemCode varchar(20) not null foreign key references Item(Icode),
	Qty int,
	constraint PK_SrNo_OrderNo primary key(SrNo,OrderNo)
	)
	go

--Insert data vào bảng Customer
INSERT INTO Customer VALUES ('KH0001','lE QUANG DINH','123 NGUYEN VAN NGHI, GO VAP,THU DUC','0123-456-789'),
							('KH0002','LY THAI TO','456 KHA VAN CAN, THU DUC, TPHCM','0246-810-135'),
							('KH0003','KHA VAN CAN','789 QUANG TRUNG, GOVAP, TPHCM','0137-246-789'),
							('KH0004','QUANG TRUNG','124 LE QUANG DINH, BINH THANH, TPHCM','0125-567-876'),
							('KH0005','NGUYEN VAN NGHI','126 LINH DONG, THU DUC, TPHCM','0245-564-875'),
							('KH0006','LINH DONG','135 LY THAI TO, QUAN 3, TPHCM','0128-987-654')
	GO

--Insert data vào bảng OrderMaster
INSERT INTO OrderMaster VALUES	('0083/24', '12/03/2024', 'KH0001'), -- Default format mm/dd/yyyy
								('0084/24', '02/06/2024', 'KH0001'),
								('0195/24', '10/04/2024', 'KH0006'),
								('0256/24', '10/06/2024', 'KH0002'),
								('0300/24', '05/06/2024', 'KH0002'),
								('0343/24', '06/06/2024', 'KH0005'),
								('0430/24', '07/01/2024', 'KH0003'),
								('0441/24', '07/03/2024', 'KH0003'),
								('0703/24', '10/15/2024', 'KH0004'),
								('0704/24', '10/15/2024', 'KH0004'),
								('0705/24', '10/15/2024', 'KH0006'),
								('0856/24', '10/09/2024', 'KH0005')

--Insert data vào bảng Item (SPOUT: VÒI)
INSERT INTO Item VALUES	('B50', 'PLASTIC BOTTLE 50ml', 450),
						('B250', 'PLASTIC BOTTLE 250ml', 500),
						('B330', 'PLASTIC BOTTLE 330ml', 1075),
						('BS330', 'PLASTIC BOTTLE WITH SPOUT 330ml', 1575),
						('B500', 'PLASTIC BOTTLE 500ml', 1575),
						('BS500', 'PLASTIC BOTTLE WITH SPOUT 500ml', 1790)
	GO

--Insert data vào bảng OrderDeatils
INSERT INTO OrderDetails	(OrderNo, ItemCode, Qty) VALUES('0083/24', 'B250', 10000),
							('0083/24', 'B50', 5000),
							('0083/24', 'B250', 10000),
							('0084/24', 'B330', 12000),
							('0084/24', 'BS330', 20000),
							('0195/24', 'B50', 10000),
							('0195/24', 'BS330', 7500),
							('0256/24', 'B250', 5000),
							('0256/24', 'B50', 7000),
							('0300/24', 'B500', 10000),
							('0343/24', 'B50', 5000),
							('0343/24', 'BS330', 6000),
							('0430/24', 'B250', 12000),
							('0430/24', 'BS500', 7000),
							('0430/24', 'BS330', 13000),
							('0441/24', 'B50', 4000),
							('0441/24', 'B250', 10000),
							('0703/24', 'B330', 7000),
							('0703/24', 'B250', 3000),
							('0704/24', 'BS500', 2000),
							('0705/24', 'BS500', 5000),
							('0856/24', 'B330', 12000),
							('0856/24', 'B500', 10000),
							('0856/24', 'B500', 2000)