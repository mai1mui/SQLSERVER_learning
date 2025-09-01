--I.Chuẩn bị
	use master
		go

	--Kiểm tra xem DB có tồn tại thì xoá đi.
	if exists(SELECT * FROM sys.databases WHERE name='AirCraft')
		BEGIN
			ALTER DATABASE AirCraft SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
			DROP DATABASE AirCraft;
		END
		GO
--II.Database
	--1.tạo DB tên AirCraft theo yêu cầu filegroup
	create database AirCraft
		on primary (
			name		=AirCraft_dat,
			filename	='C:\DMS\DB\AirCraft_dat.mdf',
			size		=10MB,
			maxsize		=100MB,--unlimted
			filegrowth	=5MB

			),
		filegroup MyGroup (
			name		=MyGroup_dat,
			filename	='C:\DMS\DB\MyGroup_dat.ndf',
			size		=10MB,
			maxsize		=100MB,
			filegrowth	=5MB

		)
		log on (
			name		=AirCraft_log,
			filename	='C:\DMS\DB\AirCraft_log.ldf',
			size		=5MB,
			maxsize		=25MB,
			filegrowth	=3MB
			);
		go
	--vào DB AirCraft
	use AirCraft
		go

	--2.tạo bảng customer
	create table Customer (
		First_Name varchar(10) not null,
		Last_Name varchar(20),
		CAddress varchar(50) default ('Unknown'),--nếu tittle xanh xanh có thể để trong ngoặc vuông
		City varchar(50) default ('Mumbai'),
		Country varchar (12),
		Birthdate datetime
		)
		go

	--3.sửa đổi bảng customer để thay đổi First_Name:Không cho phép giá trị trùng lặp unique,Không cho phép giá trị NULL
		--cách 1: làm y như đề
		alter table Customer --chỉnh sử bảng customer
			alter column First_Name varchar (10) not null;--ALTER COLUMN chỉ có thể dùng để thay đổi kiểu dữ liệu hoặc NOT NULL
		alter table Customer
			add constraint U_FirstName unique (First_Name);--UNIQUE phải được thêm bằng ADD CONSTRAINT.
		--cách 2: unique + not null-> chính lf primary key
		alter table Customer
			add primary key (First_Name)
			go

	--4.Insert data vào bảng Customer
	insert into Customer
		values 
		('Alice', 'Smith', '456 Maple Ave', 'London', 'UK', '2011-08-22'),  
		('David', 'Brown', '789 Oak Dr', 'Sydney', 'Australia', '2010-03-10'),  
		('Emma', 'Johnson', '101 Pine Rd', 'Toronto', 'Canada', '2005-12-05'),  
		('Michael', 'White', DEFAULT, DEFAULT, 'Germany', '2007-06-30'),  
		('Sophia', 'Williams', '678 Cedar Ln', 'Paris', 'France', '2003-09-18'),  
		('Liam', 'Miller', '890 Birch St', 'Tokyo', 'Japan', '2006-11-25'),  
		('Olivia', 'Davis', '234 Willow Ave', 'Mumbai', 'India', '1999-07-14'),  
		('Noah', 'Wilson', DEFAULT, DEFAULT, 'Brazil', '2001-04-20'),  
		('Ava', 'Taylor', '567 Elm Blvd', 'Berlin', 'Germany', '2000-02-08');
		go

		
	--5.sử dụng mệnh đề SELECT … INTO chèn các giá trị từ bảng Customer vào bảng New_Customer
		-- Kiểm tra nếu bảng New_Customer đã tồn tại thì xoá đi
		IF OBJECT_ID('New_Customer', 'U') IS NOT NULL
			DROP TABLE New_Customer;
		GO
	select * into New_Customer from Customer--Sao chép toàn bộ dữ liệu từ Customer sang bảng mới New_Customer.
		go
		--Nếu New_Customer chưa tồn tại, SQL sẽ tự động tạo bảng mới với cùng cấu trúc.
		--Nếu New_Customer đã tồn tại và chỉ muốn chèn dữ liệu: 
			--INSERT INTO New_Customer (First_Name, Last_Name, CAddress, City, Country, Birthdate)
			--SELECT First_Name, Last_Name, CAddress, City, Country, Birthdate
			--FROM Customer;
		--Nếu chỉ muốn sao chép một số cột:	SELECT First_Name, Last_Name, City, Country 
										  --INTO New_Customer 
										  --FROM Customer;

	--6.thêm một cột State, varchar (10) vào bảng Customer
	alter table Customer
		add CState varchar(10);
		go

	--7.Viết truy vấn để hiển thị thành phố cùng với số lượng Khách hàng có mặt tại đó, trong đó số lượng Khách hàng >=3
	select City, count(*) as 'Total_Customer'
	from Customer
	group by City
	having count(*) >=3
		go
		--kết quả ra mumbai (3) vì: 1 KH ở mumbai, 2 KH để trống default là mumbai

	--8.hiển thị 30% bản ghi hàng đầu từ bảng Khách hàng
		--sử dụng TOP ... PERCENT để lấy 30% số bản ghi đầu tiên
		select top 30 percent *
			from Customer;
			go

	--9.Hiển thị First_Name và City của Khách hàng dưới 18 tuổi
	select First_Name, City, Birthdate
	from Customer
	where DATEDIFF(YEAR, Birthdate, GETDATE()) < 18;
		go
		--DATEDIFF(YEAR, Birthdate, GETDATE()) → Tính số năm chênh lệch giữa ngày sinh và ngày hiện tại

	--10.Cập nhật các Thành phố cũ từ “Mumbai” thành “Bombay” cho khách hàng dưới 18 tuổi
	update Customer
	set City	='Bombay'
	where	City	='Mumbai' and
			DATEDIFF(YEAR, Birthdate, GETDATE()) < 18;
		go

