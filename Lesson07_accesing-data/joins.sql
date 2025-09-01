use StrongHold
	go
--INNER JOIN BY FILTER
select A.CName, B.OrderNo, D.ItemName, C.Qty
from Customer A, OrderMaster B, OrderDetails C, Item D
where	A.CCode		=B.CCode and
		B.OrderNo	=C.OrderNo and
		C.ItemCode	=D.ICode
--JOIN BY INNER JOIN
select A.CName, B.OrderNo, D.ItemName, C.Qty
from Customer A INNER JOIN	OrderMaster B	ON (A.CCode		=B.CCode)
				INNER JOIN	OrderDetails C	ON (B.OrderNo	=C.OrderNo)
				INNER JOIN	Item D			ON (C.ItemCode	=D.ICode)