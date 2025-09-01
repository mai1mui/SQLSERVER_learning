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
--Default(mặc định)
	--1.tạo 2 bảng
		create table table_Default01 (
			col11 int,
			col12 int,
			col13 varchar(10) default ('no value'))
			go
		create table table_Default02 (
			col21 int,
			col22 int,
			col23 varchar(10) constraint DF_code23 default ('no value'))--constraint: đặt tên
			go
	--2.test: 
		--2.1thêm thông  tin
		
			insert into table_Default01(col11,col12) values (11,12)
				go
			insert into table_Default02(col21,col22) values (11,12)
				go
		--2.2.alter
			alter table table_Default02
			add constraint DF_code23 default (0) for col22
			go
			insert into table_Default02(col21, col23) values (31, 'test')
		--2.3.drop
			alter table table_Default02
			drop constraint DF_code23
			go
			insert into table_Default02(col21, col23) values (41, 51)
	--3.select
		select * from table_Default01
		select * from table_Default02
