use master
	go
--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(select * from sys.databases where name='CarWorld')
	begin
		alter database CarWorld set single_user with rollback immediate
		--SET SINGLE_USER: Đặt database vào chế độ "đơn người dùng" (chỉ cho phép một kết nối duy nhất, thường là của admin).
		/*WITH ROLLBACK IMMEDIATE: Ngắt tất cả các kết nối hiện tại đến database ngay lập tức và rollback tất cả các giao dịch đang chạy.
	Điều này đảm bảo rằng database không bị khóa khi thực hiện lệnh tiếp theo.*/
		drop database CarWorld;
	end
	go
--nếu không xóa được DB do lỗi: Cannot drop database "CarWorld" because it is currently in use.
	--làm như sau:
	--B1:use master go
	--B2:ngắt kết nối DB với các liên kết khác
		--	ALTER DATABASE CarWorld SET SINGLE_USER WITH ROLLBACK IMMEDIATE;	GO
		--	DROP DATABASE CarWorld; GO

--1.tạo DB theo yêu cầu filegroup
create database CarWorld
	on primary (
		name		=CarWorld_dat,
		filename	='C:\DMS\DB\CarWorld_dat.mdf',
		size		=10MB,
		maxsize		=100MB,
		filegrowth	=1MB
		),
	filegroup Regions (
		name		=Regions_dat,
		filename	='C:\DMS\DB\Regions_dat.ndf',
		size		=10MB,
		maxsize		=100MB,
		filegrowth	=1MB
	)
	log on (
		name		=CarWorld_Log,
		filename	='C:\DMS\DB\CarWorld_log.ldf',
		size		=5MB,
		maxsize		=25MB,
		filegrowth	=1MB
		);
	go
--vào database
use CarWorld
	go

--2.tạo bảng Brands
create table Brands (
	BrandID int identity(1,1) primary key,--identity: giá trị tự động tăng(1,1) (bắt đầu, bước nhảy)
	BrandName varchar(50) unique not null,--unique: k trùng lặp, not null: k để trống
	Decription varchar(100) null--null: dc để trống
	)
	go

--3.tạo bảng Types
create table [Types] (
	TypeCode varchar(15) primary key,
	TypeName varchar(50) unique not null,
	Decription varchar(100) null--null: dc để trống
	)
	go

--4.tạo bảng Cars
create table Cars (
	CarCode varchar(20) primary key,
	CarName varchar(50) unique not null,
	Brand int not null foreign key (Brand) references Brands(BrandID),--khóa ngoại liên kết Brands (BrandID)
	[Type] varchar(15) foreign key ([Type]) references [Types](TypeCode),--khóa ngoại liên kết Types (TypeCode)
	Price int default 0 check (Price>0),--giá mặc định 0, k đc âm
	Decription varchar(100) null--null: dc để trống
	)
	go

--5.Insert data vào bảng
	--5.1.Brands
	insert into Brands(BrandName, Decription)
		values
		('Toyota',''),  
		('BMW', 'A German luxury automobile manufacturer'),  
		('VinFast', 'Vietnamese electric vehicle company'),  
		('Ford', 'American multinational automaker'),  
		('Honda', 'Japanese automotive and motorcycle company');
		go
	select * from Brands
		go
	--5.2.Types
	insert into [Types](TypeCode, TypeName, Decription)
		values
		('SEDAN', 'Sedan', 'A compact and fuel-efficient car'),  
		('SUV', 'SUV', 'A sports utility vehicle with off-road capability'),  
		('HATCH', 'Hatchback', 'A small car with a rear hatch door'),  
		('TRUCK', 'Truck', 'A vehicle designed for transporting goods'),  
		('EV', 'Electric Vehicle', 'A car powered by electric batteries');  
		go
	select * from [Types]
		go
	--5.2.Cars
	insert into Cars(CarCode, CarName, Brand, [Type], Price, Decription)
		values
		('CAR001', 'Toyota Camry', 1, 'SEDAN', 35000, 'A reliable and comfortable sedan'),  
		('CAR002', 'BMW X5', 2, 'SUV', 60000, 'A luxury SUV with powerful performance'),  
		('CAR003', 'VinFast VF8', 3, 'SUV', 45000, 'An electric SUV made by VinFast'),  
		('CAR004', 'Ford Ranger', 4, 'TRUCK', 40000, 'A versatile pickup truck for all terrains'),  
		('CAR005', 'Honda Civic', 5, 'HATCH', 28000, 'A compact and sporty hatchback');  
		go
	select * from Cars
		go

--6.clustered index(Tạo chỉ mục )
--create clustered index IX_BrandName--tạo chỉ mục có tên IX_BrandName
	--on Brands(BrandName)--áp dụng chỉ mục trên cột BrandName trong bảng Brands
	--with (online = on);--cho phép tạo chỉ mục mà không khóa bảng, giúp bảng có thể truy cập trong quá trình tạo
			--Mục đích tạo chỉ mục:
				--tăng tốc độ select(truy xuất), order by(sắp xếp): nếu k có chỉ mục, khi cần select, order by, SQL sẽ phải quét toàn bộ bảng
				--tối ưu join, group by(truy vấn có điều kiện)
				--dễ kiểm tra trùng lặp dữ liệu
				--online=on: tránh gián đoạn hoạt động hệ thống
	--go
--7.tạo view
	--Xóa view cũ trước khi tạo lại
	if exists (select * from sys.views where name = 'vw_Cars')
		drop view vw_Cars
		go
create view vw_Cars--tạo view
	as
	select C.CarCode, C.CarName, A.BrandName , B.TypeName, C.Price, C.Decription 
	from Brands A, [Types] B, Cars C
	where	A.BrandID	=C.Brand and
			C.[Type]	=B.TypeCode and
			A.BrandName ='Vinfast' and B.TypeName ='SUV'
	go
select * from vw_Cars 
	go

--8.procedure
create procedure sp_ListDevices
	@BrandName varchar(50)--khai báo tham số đầu vào để lọc theo tên thương hiệu.
	as
	begin
		select C.CarCode, C.CarName, A.BrandName, B.TypeName
		from Brands A, [Types] B, Cars C
		where	A.BrandID	=C.Brand and
				C.[Type]	=B.TypeCode and
				A.BrandName =@BrandName--lọc dữ liệu theo thương hiệu được truyền vào.
	end
	go
	--xem kết quả gọi procedure vd vinfast: exec sp_ListDevices @BrandName ='Vinfast' go

--9.trigger
	--Xóa trigger cũ trước khi tạo lại
	if exists (select * from sys.triggers where name = 'tg_UpdateCarsPrice')
		drop trigger tg_UpdateCarsPrice
		go
create trigger tg_UpdateCarsPrice
	on Cars
	instead of update
	as
	begin
		set nocount on
		-- Nếu có bản ghi nào bị cập nhật mà Price = 0 thì xóa chúng
		if exists(SELECT 1 FROM inserted WHERE Price = 0)--inserted → Bảng tạm chứa dữ liệu mới được cập nhật.
		begin
			delete from Cars where CarCode in (select CarCode from inserted where Price =0)
			print 'Item has been deleted'
		end
		else
		begin
			print'Update done'
		end
	end
	go
	--Cách kiểm tra Trigger:
		--Cập nhật giá về 0 để kiểm tra xóa:
			--UPDATE Cars SET Price = 0 WHERE CarCode = 'CAR001';
			--👉Kết quả: "Item has been deleted"
		--Cập nhật giá bình thường:
			--UPDATE Cars SET Price = 50000 WHERE CarCode = 'CAR002';
			--👉 Kết quả: "Update done"

