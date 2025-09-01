--chuyển sang DB master
	use master
		go
--kiểm tra sự tồn tại của DB abc, nếu tìm thấy thì xóa để có thể tạo bảng abc nhiều lần k bị trùng
	if exists (select name from master..sysdatabases where name = 'ABC')
	drop database ABC --xóa
-----------------------
--create DB ABC
	create database ABC
		go
	use ABC
		go
------------------------f5 từng bó lệnh để sql chạy lần lượt
--1.create table (tạo bảng)  simple( đơn giản)
	--syntax:
		--[create table] [table-name] (fields_list)
	--example:b1: tạo bảng
		create table table_simple (
			field01 int,
			field02 varchar(10),
			field03 bit,
			field04 datetime
		)
			go
		--b2:thêm thông tin(1 dòng)
		insert into table_simple values (1,'Demo',1,'2025/03/05')
			go
		--f5 dòng này để xem kết quả
		select * from table_simple
--2.Alter
	--2.1. Adding more column ( thêm cột)
		alter table table_simple
		add col05 int
		go
	--2.2. Alter column
		alter table table_simple
		alter column field02 varchar (20)
	--2.3. Drop column
		alter table table_simple
		drop column col05