--PRIMARY KEY
--a. 
create table table_PK1 (
	pk11 int constraint pk_pk11 primary key,
	pk12 int,
	pk13 int)
--b.
create table table_PK2(
	pk21 int,
	pk22 int,
	pk23 int,
	constraint pk_pk21 primary key (pk21))
--c.composit key
create table table_PK3(
	pk31 int,
	pk32 int,
	pk33 int,
	constraint pk_pk31 primary key (pk31,pk32))
	go

insert into table_PK1(pk12,pk13) values (12,13)--err: Invalid object name 'table_PK1'.
go

insert into table_PK1 values (11,12,13),(11,22,23)--err: Invalid object name 'table_PK1'.
go

--d.
create table table_PK4 (
	pk41 int not null,
	pk42 int,
	pk43 int)

alter table table_PK4
alter column pk41 int not null--thay vì viết 2 câu này, b có thể ghi sẵn not null trên phần tạo bảng
go

alter table table_PK4
add constraint pk_pk41 primary key (pk41)

--foreign key
--a. create
	--.primary key
		create table Brands(
			bid int identity primary key,
			BName varchar (90))
			go
	--foreign key
	create table products(
		Pcode varchar(5) primary key,
		Brand int constraint FK_Brand foreign key references Brands (bid),
		Pname varchar(50))

	insert into Brands (BName) values ('samsung'),('apple')
	go
	insert into Products values ('ss5',1,'galaxy s25 ultra'),('i16',2,'iphone 16e')

	select Pcode, A.BName, B.Pname
	from Brands A, Products B
	where A.bid=B.Brand 