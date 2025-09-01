use master
	go

--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(SELECT * FROM sys.databases WHERE name='ClothingStore')
	BEGIN
		ALTER DATABASE ClothingStore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE ClothingStore;
	END
	go

--tạo DB tên ClothingStore
create database ClothingStore
	go

--vào DB ClothingStore
use ClothingStore
	go

--tạo bảng customer
CREATE TABLE Customer (
    ID INT PRIMARY KEY IDENTITY(1,1),--identity: tự động tăng
    CName NVARCHAR(50) NOT NULL,
    Phone VARCHAR(15) UNIQUE--unique: không trùng lặp
	);
	GO

--tạo bảng ordermaster
	CREATE TABLE OrderMaster (
    OrderNo INT PRIMARY KEY IDENTITY(1,1),
    OrderDate DATE DEFAULT GETDATE(),
    ID INT FOREIGN KEY REFERENCES Customer(ID) ON DELETE CASCADE--ON DELETE CASCADE: Thêm vào các khóa ngoại để tránh lỗi khi xóa dữ liệu
	);
	GO

--tạo bảng item
CREATE TABLE Item (
    ItemCode INT PRIMARY KEY IDENTITY(1,1),
    ItemName NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0)--DECIMAL(10,2): kiểu dữ liệu bao gồm 10 kí tự cả phần nguyên
	);
	GO

--tạo bảng orderdetails
CREATE TABLE OrderDetails (
    OrderNo INT FOREIGN KEY REFERENCES OrderMaster(OrderNo) ON DELETE CASCADE,
    ID_Detail INT IDENTITY(1,1) PRIMARY KEY,
    ItemCode INT FOREIGN KEY REFERENCES Item(ItemCode),
    Quantity INT CHECK (Quantity > 0)--điều kiện số lượng >0
	);
	GO

--Insert data vào bảng Customer
INSERT INTO Customer (CName, Phone) 
VALUES
	(N'Nguyễn Văn A', '0905123456'),
	(N'Trần Thị B', '0914234567'),
	(N'Lê Văn C', '0925345678'),
	(N'Phạm Thị D', '0936456789');
	GO

--Insert data vào bảng item
INSERT INTO Item (ItemName, Price) 
VALUES
	(N'Áo sơ mi', 250000),
	(N'Quần jean', 500000),
	(N'Giày thể thao', 750000),
	(N'Nón lưỡi trai', 150000);
	GO

--Insert data vào bảng ordermaster
INSERT INTO OrderMaster (ID) 
VALUES
	(1), (2), (1), (3), (4);
	GO

--Insert data vào bảng orderdetails
INSERT INTO OrderDetails (OrderNo, ItemCode, Quantity) 
VALUES
	(1, 1, 20), -- Nguyễn Văn A mua 20 áo sơ mi
	(1, 3, 10), -- Nguyễn Văn A mua 10 giày thể thao
	(2, 2, 30), -- Trần Thị B mua 30 quần jean
	(3, 4, 50), -- Nguyễn Văn A mua 50 nón lưỡi trai
	(4, 1, 10), -- Lê Văn C mua 10 áo sơ mi
	(5, 3, 20); -- Phạm Thị D mua 20 giày thể thao
	GO

--1.select ID, name customer, orderdate, itemcode, itemname, price, quantity
select A.ID, A.CName, B.OrderDate, C.ItemCode, D.ItemName, D.Price, C.Quantity
from Customer A, OrderMaster B, OrderDetails C, Item D
where	A.ID		=B.ID and
		B.OrderNo	=C.OrderNo and 
		C.ItemCode	=D.ItemCode

--2.tính tổng tiền đơn hàng theo khách hàng
select A.ID, A.CName, B.OrderDate,  D.Price * C.Quantity as 'Amount'
from Customer A, OrderMaster B, OrderDetails C, Item D
where	A.ID		=B.ID and
		B.OrderNo	=C.OrderNo and 
		C.ItemCode	=D.ItemCode
order by A.CName

--3.tính tổng tiền đơn hàng , tìm khách hàng hóa đơn nhiều tiền nhất
select top 1 A.ID, A.CName, sum(D.Price * C.Quantity) as 'Total' 
from Customer A, OrderMaster B, OrderDetails C, Item D
where	A.ID		=B.ID and
		B.OrderNo	=C.OrderNo and 
		C.ItemCode	=D.ItemCode
group by A.ID, A.CName--Khi dùng SUM(), mọi cột khác trong SELECT phải có trong GROUP BY.
order by Total desc

--4.thêm 2 sản phẩm mới vào cửa hàng
--5.cập nhật thông tin cho khách Nguyễn Văn A đổi SDT 0903456777
--6.cập nhật thông tin cho Áo sơ mi giá mới 300.000
--7.xóa sản phẩm nón lưỡi trai
--8.thêm cột số lượng tồn kho đầu kì vào bảng item
--9.kiểm tra số lượng tồn kho sau khi bán, lọc tìm sản phẩm hết hạn và sản phẩm còn tồn nhiều hàng
--10.thêm đơn hàng mới cho khách trần thị B, và thêm 1 đơn mới cho khách mới vũ thị E
--11.tính tổng doanh thu, tổng doanh thu theo tháng
--12.thống kê sp bán chạy