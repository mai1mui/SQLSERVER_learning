use master
	go
--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(SELECT * FROM sys.databases WHERE name='Bookstore_SSDO')
	BEGIN
		ALTER DATABASE Bookstore_SSDO SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE Bookstore_SSDO;
	END
	GO
--nếu không xóa được DB do lỗi: Cannot drop database "Bookstore_SSDO" because it is currently in use.
	--làm như sau:
	--B1:use master go
	--B2:ngắt kết nối DB với các liên kết khác
		--	ALTER DATABASE Bookstore_SSDO SET SINGLE_USER WITH ROLLBACK IMMEDIATE;	GO
		--	DROP DATABASE Bookstore_SSDO; GO

--1+2.tạo DB tên polysite theo yêu cầu filegroup
create database Bookstore_SSO
on primary (
	name		=Bookstore_SSO_dat,
	filename	='C:\DMS\DB\Bookstore_SSO_dat.mdf',
	size		=10MB,
	maxsize		=100MB,
	filegrowth	=1MB
	),
filegroup MyGroup (
	name		=MyGroup_SSO_dat,
	filename	='C:\DMS\DB\MyGroup_SSO_dat.ndf',
	size		=10MB,
	maxsize		=100MB,
	filegrowth	=1MB
)
log on (
	name		=Bookstore_SSO_Log,
	filename	='C:\DMS\DB\Bookstore_SSO_log.ldf',
	size		=5MB,
	maxsize		=25MB,--unlimted
	filegrowth	=1MB
	);
go
--vào DB polysite
use Bookstore_SSO
	go

--3.tạo bảng categories
create table Categories (
	CateID int not null,
	CateName varchar(15),
	Decription varchar(20)
	)
	go

--4.tạo bảng books
create table Books(
	BookID int not null,
	Title varchar(20),
	CateID int,
	CoverImage  varchar(50),
	ShortDescription varchar(50),
	Price int,
	Edition int
	)
	go

--5.Thêm ràng buộc PRIMARY KEY và FOREIGN KEY trên các bảng
	-- Thêm khóa chính cho bảng Categories
	ALTER TABLE Categories
	ADD CONSTRAINT PK_Categories PRIMARY KEY (CateID);--CateID là khóa chính của Categories (đảm bảo mỗi danh mục là duy nhất).
	-- Thêm khóa chính cho bảng Books
	ALTER TABLE Books
	ADD CONSTRAINT PK_Books PRIMARY KEY (BookID);--BookID là khóa chính của Books (mỗi sách có một mã riêng).
	-- Thêm khóa ngoại cho bảng Books tham chiếu đến bảng Categories
	ALTER TABLE Books
	ADD CONSTRAINT FK_Books_Categories 
	FOREIGN KEY (CateID) REFERENCES Categories(CateID)
	go
--Insert data vào bảng categories
INSERT INTO Categories (CateID, CateName, Decription)  
VALUES  
    (1, 'Fiction', 'Stories and novels'),  
    (2, 'Science', 'Science books'),  
    (3, 'Technology', 'Tech-related books'),  
    (4, 'History', 'Historical books'),  
    (5, 'Business', 'Business')
GO
--Insert data vào bảng books
INSERT INTO Books (BookID, Title, CateID, CoverImage, ShortDescription, Price, Edition)  
VALUES  
    (1, 'The Alchemist', 0001, 'alchemist.jpg', 'Inspirational novel', 150000, 2),  
    (2, 'A Brief History', 0002, 'briefhistory.jpg', 'Science book by Hawking', 200000, 1),  
    (3, 'Clean Code', 0003, 'cleancode.jpg', 'Coding best practices', 300000, 1),  
    (4, 'Sapiens', 0004, 'sapiens.jpg', 'History of humankind', 250000, 3),  
    (5, 'Rich Dad Poor Dad', 0005, 'richdad.jpg', 'Personal finance guide', 180000, 1);
GO
--6.Thêm ràng buộc Price > 0 và giá trị MẶC ĐỊNH là 1 cho Edition  
alter table Books
	add check (Price > 0)
	go
alter table Books
	add default (1) for Edition
	go
--7.Clustered Index :Bảng danh mục
	-- Tạo mới một CLUSTERED INDEX có tên là IX_CateID
	-- Sửa IX_CateID với Trạng thái trực tuyến thay đổi thành TẮT
--8.Tạo VIEW có tên vw_Info lưu trữ BookID, Title, CateName,Cover, Price và Edition
--9.Store Procedure :--Tên: sp_BookInfo
					---Tham số đầu vào: BookID
					---Mục tiêu:
					---- Chọn tất cả thông tin của cuốn sách
					---- Cập nhật giá của cuốn sách lên 10%
					---- Chọn lại tất cả thông tin của cuốn sách
create proc sp_BookInfo
@BookID int
as
select * from Books where BookID = @BookID
update Books set Price = Price *1.1 where BookID = @BookID
select * from Books where BookID =@BookID
--exec sp_BookInfo
--10.Trigger : Ngăn người dùng xóa một danh mục nếu bất kỳ Sách nào thuộc danh mục này đã tồn tại trong cơ sở dữ liệu. Thông báo “Bạn không thể
		--xóa danh mục này vì một số sách thuộc danh mục này đã tồn tại trong cơ sở dữ liệu” sẽ được đưa ra trong trường hợp này
		--sd bẫy lỗi master-details
create trigger
on Categories
for delete
as
select 'true' 
from deleted A inner join Books B 
on (A.CateID =B.CateID)
--test bonus:
	--1.thêm 5 sách mới
	--2.thêm bảng tồn kho: bookid, bookname, số lượng nhập, sl bán, sl tồn kho
	--3.lọc sách nào có số lượng tồn ít để nhập thêm