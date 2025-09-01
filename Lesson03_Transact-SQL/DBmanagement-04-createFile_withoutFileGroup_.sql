/*Review-2*/
--create DB abc
/*Review-1*/
--without FileGroup
--Syntax: create database [DB-Name] on primary (Attribute_list) log on (Attribute_list)
--example: 
	--chuyển sang DB master
		use master
			go
	--kiểm tra sự tồn tại của DB abc, nếu tìm thấy thì xóa để có thể tạo bảng abc nhiều lần k bị trùng
		if exists (select name from master..sysdatabases where name = 'ABC')
		drop database ABC --xóa
			go
	-----------------------
	--create DB ABC
		create database ABC
			go
		
	--tạo 2 file ABC_dat.mdf và ABC_log.ldf trong folder DB
	create database ABC
	on primary (
		name		=ABC_dat,
		filename	='C:\DMS\session_class\session03_Transact-SQL\DB\ABC_dat.mdf',
		size		=5MB,
		maxsize		=10MB,--unlimited
		filegrowth	=1mB

	)
	log on (
		name		=ABC_log,
		filename	='C:\DMS\session_class\session03_Transact-SQL\DB\ABC_log.ldf',
		size		=5MB,
		maxsize		=10MB,--unlimited
		filegrowth	=1mB
	)
	--chọn ABC làm current DB
	go 
	use ABC
	go