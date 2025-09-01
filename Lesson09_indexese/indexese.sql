--syntax(cú pháp):
	--[create clustered|nonclustered index] [index_Name] ON [Table_Name]
create clustered index IX_CName
ON Customer(CName)
create nonclustered index IX_Name
ON Customer (CName)
--list tablde index
exec sp_helpindex 'Customer'

drop index Customer.IX_CName

--alter table for create clustered
--1.xóa pk_CCode trong Customer
	--1.1 xóa khóa ngoại fk_CCode trong OrderMaster
	alter table OrderMaster
	drop constraint fk_CCode
	go
	--1.2.xóa pk_CCode trong Customer
	alter table Customer
	drop constraint PK_CCode
--2.tạo clustered index
create clustered index IX_CName
ON Customer (CName)
go
--3.tái lập khóa chính trong Customer
	--3.1. tái lập PK_CCode trong Customer
	alter table Customer
	add constraint PK_CCode primary key (CCode)
	go
	--3.1.Tái lập PK_CCode trong OrderMaster
	alter table OrderMaster
	add constraint PK_CCode foreign key (CCode) references Customer (CCode)


--4.create table with nonslustered
create table tb_IX(
colX1 int primary key nonclustered,
colX2 int,
colX3 int,
colX4 int
)
go
create clustered index IX_colX1
on tb_IX (colX1)
--include
create nonclustered index IX_colX2
on tb_IX (colX2) include (colX3,colX4)
--alter
alter index IX_colX1
on tb_IX rebuild with (online =off)

