use master
	go
--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(select * from sys.databases where name='ABCCorp')
	begin
		alter database ABCCorp set single_user with rollback immediate
		drop database ABCCorp;
	end
	go

--1.tạo DB
CREATE DATABASE ABCCorp;
	GO
	--Sử dụng database ABCCorp
	USE ABCCorp;
		GO

--2.tạo bảng Categories
CREATE TABLE Categories (
    CateCode NVARCHAR(10) PRIMARY KEY,
    CateName NVARCHAR(50) UNIQUE,
    Decription NVARCHAR(100) NULL
	);
	GO
	--Insert data vào bảng
	INSERT INTO Categories (CateCode, CateName, Decription)
	VALUES 
		(N'CAT001', N'Electronics', N'All electronic items'),
		(N'CAT002', N'Clothing', N'Fashion and apparel'),
		(N'CAT003', N'Furniture', N'Home and office furniture'),
		(N'CAT004', N'Books', N'All kinds of books and magazines'),
		(N'CAT005', N'Toys', N'Children and baby toys');
	GO
	--Kiểm tra dữ liệu
	SELECT * FROM Categories;
		GO

--3.tạo bảng Suppliers
CREATE TABLE Suppliers (
    SupplierCode INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(50) UNIQUE,
    Decription NVARCHAR(100) NULL
	);
	GO

	--Insert data vào bảng
	INSERT INTO Suppliers (SupplierName, Decription)
	VALUES 
		(N'ABC Trading', N'Supplier of electronic components'),
		(N'Global Textiles', N'Leading fabric supplier worldwide'),
		(N'Furniture Hub', N'Wholesale furniture manufacturer'),
		(N'Book Distributors', N'Bulk supplier of books and magazines'),
		(N'Toy World', N'Toys and games supplier');
	GO
	--Kiểm tra dữ liệu
	SELECT * FROM Suppliers;
		GO

--4.tạo bảng Products
CREATE TABLE Products (
    productCode NVARCHAR(10) PRIMARY KEY,
    productName NVARCHAR(50) UNIQUE,
    CateCode NVARCHAR(10) FOREIGN KEY REFERENCES Categories(CateCode),
    SupplierCode INT FOREIGN KEY REFERENCES Suppliers(SupplierCode),
    Decription NVARCHAR(100) NULL,
    Price INT CHECK (Price >= 0),--ràng buộc CHECK để không nhận giá trị âm.
    isSelling BIT DEFAULT 1
	);
	GO
	--Insert data vào bảng
	INSERT INTO Products (productCode, productName, CateCode, SupplierCode, Decription, Price, isSelling)
	VALUES 
		(N'P001', N'Smartphone X', N'CAT001', 1, N'Latest model smartphone', 999, 1),
		(N'P002', N'Laptop Pro', N'CAT001', 1, N'High-performance laptop', 1500, 1),
		(N'P003', N'T-Shirt Black', N'CAT002', 2, N'Cotton black t-shirt', 20, 1),
		(N'P004', N'Office Chair', N'CAT003', 3, N'Ergonomic office chair', 120, 1),
		(N'P005', N'Novel Bestseller', N'CAT004', 4, N'Top-selling fiction book', 15, 1),
		(N'P006', N'Teddy Bear', N'CAT005', 5, N'Soft plush teddy bear', 25, 1),
		(N'P007', N'Gaming Mouse', N'CAT001', 1, N'RGB wireless gaming mouse', 50, 1),
		(N'P008', N'Winter Jacket', N'CAT002', 2, N'Warm insulated jacket', 80, 1),
		(N'P009', N'Dining Table', N'CAT003', 3, N'Solid wood dining table', 300, 1),
		(N'P010', N'Kids Puzzle', N'CAT005', 5, N'Educational puzzle for kids', 10, 1);
	GO
	--Kiểm tra dữ liệu
	SELECT * FROM Products;
		GO

--5.tạo ClusterIndex 
	/*
	-- Tạo Clustered Index trên CateCode
	CREATE CLUSTERED INDEX IX_CateCode ON Categories(CateCode);
	GO
	--Kiểm tra dữ liệu
	SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Categories');
		GO
*/

--6.tạo Non ClusterIndex
CREATE NONCLUSTERED INDEX IX_ProductName ON Products (ProductName);
	GO
	--Non-Clustered Index không ảnh hưởng đến thứ tự vật lý của bảng nhưng giúp tăng tốc truy vấn khi tìm kiếm theo ProductName.

--7.tạo view lấy tất cả sản phẩm đang bán (isSelling = 1) từ bảng Products
CREATE VIEW vw_Product AS
	SELECT * 
	FROM Products 
	WHERE isSelling = 1;
	GO
	--Kiểm tra dữ liệu
	SELECT * FROM vw_Product;
		go

--8.tạo Stored Procedure lấy tất cả sản phẩm đang bán (isSelling = 1) của một nhà cung cấp cụ thể
CREATE PROCEDURE sp_ProductOfOrder
		@SupplierName NVARCHAR(50)
	AS
	BEGIN
		SELECT p.*
		FROM Products p
		INNER JOIN Suppliers s ON p.SupplierCode = s.SupplierCode
		WHERE s.SupplierName = @SupplierName
		  AND p.isSelling = 1;
	END;
	GO
	--Kiểm tra dữ liệu
	EXEC sp_ProductOfOrder @SupplierName = N'ABC Trading'; 
	go

--9.tạo trigger: để ngăn chặn việc xóa một danh mục (Category) nếu vẫn còn sản phẩm thuộc danh mục đó trong bảng Products
CREATE TRIGGER trg_PreventDeleteCategory
	ON Categories
	INSTEAD OF DELETE--Chặn thao tác xóa trên bảng Categories
	AS
	BEGIN
		IF EXISTS (
			SELECT 1 FROM Products p
			INNER JOIN deleted d ON p.CateCode = d.CateCode
		)--Kiểm tra xem có sản phẩm nào đang sử dụng CateCode của danh mục bị xóa không.
		BEGIN
			RAISERROR('You cannot delete this category because some products that belong to this category exist in the database.', 16, 1);--Báo lỗi nếu có sản phẩm tồn tại.
			ROLLBACK TRANSACTION;--Hủy bỏ thao tác xóa nếu điều kiện trên đúng.
		END
	END;
	GO
	--Kiểm tra dữ liệu
	DELETE FROM Categories WHERE CateCode = 'C01';
	go
