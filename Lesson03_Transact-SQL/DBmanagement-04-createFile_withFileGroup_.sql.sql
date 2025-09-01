/*Review-2*/
--create DB abc
/*Review-1*/
--with FileGroup
--Syntax: create database [DB-Name] on primary (Attribute_list) log on (Attribute_list)
--kiểm tra sự tồn tại của DB abc, nếu tìm thấy thì xóa để có thể tạo bảng abc nhiều lần k bị trùng
if exists (select name from master..sysdatabases where name = 'ABC')
drop database ABC --xóa
go

create database ABC
on primary (
	name		=ABC_dat,
	filename	='C:\DMS\session_class\session03_Transact-SQL\DB\ABC_dat.mdf',
	size		=5MB,
	maxsize		=10MB,
	filegrowth	=1mB

),
--tạo 2 file ABC_FG1_dat.ndf, ABC_FG2_dat.ndf trong folder filegroup
filegroup FG1 (
	name		=ABC_FG1_dat,
	filename	='C:\DMS\session_class\session03_Transact-SQL\DB\filegroup\ABC_FG1_dat.ndf',
	size		=5MB,
	maxsize		=10MB,
	filegrowth	=1mB

),
filegroup FG2 (
	name		=ABC_FG2_dat,
	filename	='C:\DMS\session_class\session03_Transact-SQL\DB\filegroup\ABC_FG2_dat.ndf',
	size		=5MB,
	maxsize		=10MB,
	filegrowth	=1mB

)
log on (
	name		=ABC_log,
	filename	='C:\DMS\session_class\session03_Transact-SQL\DB\ABC_log.ldf',
	size		=5MB,
	maxsize		=10MB,
	filegrowth	=1mB
)
--chọn ABC làm current DB
go 
use ABC
go