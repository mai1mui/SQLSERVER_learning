use StrongHold
	go

create view view_item
as
select Icode, ItemName
from Item

select * from view_item
--1.check definition of view (except encrypted view):xem lại cấu lệnh lúc tạo view
exec sp_helptext 'view_item'
--2.DML on view
	--2.1.select all
	select * from view_item
	--2.2.select field
	select Icode
	from view_item
	--2.3.filter
	select *
	from view_item
	where ICode like 'STCS%'
	--2.4.insert dữ liệu
	insert into view_item 
	values ('fpt01','values01'),('fpt02','values02') 
	--2.5.update dữ liệu thông qua view
	update view_item
	set ItemName ='values of fpt 01'
	where ICode ='fpt01'
	--2.6.xóa thông tin bằng view
	delete from view_item
	where ICode like 'fpt02'
--3.check option
alter view view_item
as
select *
from Item
where Rate <1000
with check option
go

--xem kq
select * from Item
--cập nhật thử rate có dc >1000 không?
update view_item
set Rate =1200
where Icode ='RKSK-B'
	--kq:Lỗi điều kiện
	--The attempted insert or update failed because the target view either specifies WITH CHECK OPTION or spans a view that specifies WITH CHECK OPTION and one or more rows resulting from the operation did not qualify under the CHECK OPTION constraint.

--4.schemabinding option
alter view view_item
with schemabinding
as 
select ICode, ItemName
from dbo.Item
--test
alter table Item
alter column ItemName varchar (255)
