/*unique
-cho phép null 1 lần
-không trùng*/
create table tb_unit (
	col01 int unique,
	col02 int,
	col03 int
	)

--test1: 
insert into tb_unit (col01,col02) values (12,13)
--test2:
insert into tb_unit (col02,col03) values (22,23)
--test3:
insert into tb_unit values (11,12,13),(21,22,23)
go
select * from tb_unit