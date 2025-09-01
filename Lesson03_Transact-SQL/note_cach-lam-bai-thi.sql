/*Thi assignment*/
	--1.tạo DB
		--cách 1: /*Review-2*/
			create database xyz
		--cách 2:/*Review-1*/--with FileGroup
	--2.chọn xyz làm current DB
		go 
		use xyz
		go
	--3.thêm filegroup
		alter database xyz
		add filegroup FG3
		go
-----------------------
--select file group
select name from sys.filegroups