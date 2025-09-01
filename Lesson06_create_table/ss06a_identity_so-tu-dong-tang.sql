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
--Identity (cột tự động tăng)
	--1.tạo bảng
		create table table_ID (
			col01 int identity(500,1),
			col02 int,
			col03 int)
			go
	--2.thêm thông  tin
		insert into table_ID (col02,col03) values (12,13),(22,23),(32,33)
			go
	--3.select
		select * from table_ID
	--test=> 1 giá trị identity khi bị xóa sẽ biến mất khỏi hệ thống, khi thêm DB mới, sẽ tạo dòng mới, ID mới
		--xóa cột 502
			delete from table_ID where col01 = 502
				go
		--thêm lại 1 cột mới
			insert into table_ID (col02,col03) values (42,43)
				go
