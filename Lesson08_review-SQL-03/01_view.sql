use StrongHold
	go

--Tạo view view_OrderInfor
create view view_OrderInfor
as
select B.OrderNo, B.OrderDate, D.ItemName, C.Qty
from Customer A, OrderMaster B, OrderDetails C, Item D
where	A.CCode		=B.CCode and
		B.OrderNo	=C.OrderNo and
		C.ItemCode	=D.ICode
	go
select * from view_OrderInfor
--xóa view
select * from drop view_OrderInfor
