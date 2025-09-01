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
--Nullability(giá trị rỗng null)
	--1.tạo bảng
		create table table_Null (
			col01 int,
			col02 int null,
			col03 int not null)
			go
	--2.test: thêm thông  tin
		--test1: 
			insert into table_Null (col02,col03) values (12,13)
		--test2: 
			insert into table_Null (col01,col03) values (21,23)
		--test3:lỗi -> Cannot insert the value NULL into column 'col03'
			insert into table_Null (col01,col02) values (31,32)
	--3.select
		select * from table_Null
			