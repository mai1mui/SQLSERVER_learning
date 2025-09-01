--CHECK
	--1.tạo 2 bảng
		create table table_check (
			col11 int,
			col12 int,
			col13 varchar(10) constraint CK_col3 check (col13 in ('M','F'))
			go
		insert into table_check values (11,12,'A')
		insert into table_check values (11,12,'M')

		select * from table_check
	--2.alter
	alter table table_check
	add constraint CK_code23 check (col12 > 0)
		go
	insert into table_check values (31, 0,'F')
	--2.3.drop
		alter table table_check
		drop constraint CK_cod12
		go
		insert into table_check values (41, 0,'F')