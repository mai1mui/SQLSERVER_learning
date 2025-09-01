
use StrongHold 
go
--SQL02
	--Exercise01:Viết SQL để hiển thị thông tin sau:
		--Question01: OrderNo, OrderDate, Customer Name, Item Name từ các bảng
			select B.OrderNo, B.OrderDate, A.CName,D.ItemName
			from Customer A, OrderMaster B, OrderDetails C, Item D
			where	A.CCode		=B.CCode	AND
					B.OrderNo	=C.OrderNo	AND
					C.ItemCode	=D.ICode
--note: 4 bảng thì có 3 quan hệ => n bảng có (n-1) quan hệ
		--Question02: Mã khách hàng, Tên và Địa chỉ. Nhận thêm Tên mặt hàng, Số lượng và Số tiền
			select B.OrderNo, A.CName, A.CAddress, D.ItemName, C.Qty, D.Rate
			from Customer A, OrderMaster B, OrderDetails C, Item D
			where	A.CCode		=B.CCode	AND
					B.OrderNo	=C.OrderNo	AND
					C.ItemCode	=D.ICode
		--Question03: OrderNo, OrderDate, Tên mặt hàng, Số lượng và đơn hàng theo OrderDate
			select B.OrderNo, B.OrderDate, D.ItemName, C.Qty 
			from Customer A, OrderMaster B, OrderDetails C, Item D
			where	A.CCode		=B.CCode and
					B.OrderNo	=C.OrderNo and
					C.ItemCode	=D.Icode
			ORDER BY B.OrderDate;--Sắp xếp theo OrderDate
		--Question04: Mã mặt hàng, Tên mặt hàng và chiết khấu (20%)
			select D.Icode, D.ItemName, D.Rate * 0.2--chiết khấu (20%)
			from Customer A, OrderMaster B, OrderDetails C, Item D
			where	A.CCode		=B.CCode and
					B.OrderNo	=C.OrderNo and
					C.ItemCode	=D.Icode
	--Exercise02:
		--Question01:Viết SQL để hiển thị thông tin sau: OrderNo, OrderDate, Item Code và Item Rate
			select B.OrderNo, B.OrderDate, D.Icode, D.Rate
			from OrderMaster B, OrderDetails C, Item D
			where B.OrderNo		=C.OrderNo AND
				  C.ItemCode	=D.Icode
		--Question02:Viết SQL để hiển thị: Tên khách hàng, Mã mặt hàng, Số đơn hàng có Số lượng mặt hàng nhỏ hơn 50
			select A.CName, D.ICode, B.OrderNo
			from Customer A, OrderMaster B, OrderDetails C, Item D
			where	A.CCode		=B.CCode AND
					B.OrderNo	=C.OrderNo AND
					C.ItemCode	=D.ICode AND
					D.ICode	LIKE 'RKSK%' AND 
					C.Qty <50
		--Question03:Viết SQL để hiển thị: Khách hàng ‘TLT’ OrderNo, OrderDate, Item Code và Amount
			select D.ICode, B.OrderNo, B.OrderDate, C.Qty * D.Rate as 'Amount'
			from Customer A, OrderMaster B, OrderDetails C, Item D
			where	A.CCode		=B.CCode	AND
					B.OrderNo	=C.OrderNo	AND
					C.ItemCode	=D.ICode	AND
					A.Ccode	='TLT'
	--Exercise03:
		--Question01: viết một SQL để hiển thị tổng số Rucksacks
			--lọc ra để cộng
			select sum (Qty) as 'Total'
			from OrderDetails
			where	ItemCode like 'RKSK%'
			--cộng xong rồi nhóm
			select sum (Qty) as 'Total'
			from OrderDetails
			group by ItemCode
			having	ItemCode like 'RKSK%'
		--Question02:hiển thị Số đơn hàng, Mã mặt hàng, Số lượng mà Số lượng trong Đơn hàng lớn hơn hoặc bằng các số khác
			select OrderNo, ItemCode, Qty
			from OrderDetails
			where Qty >= (select max(qty) from OrderDetails)
	--Exercise04:
		--Question01:Viết SQL để hiển thị Mã mặt hàng, Tên mặt hàng và Tỷ lệ cho thấy tỷ lệ này lớn hơn tỷ lệ của STCS-18-M-I”
		select Icode, ItemName, Rate
		from Item
		where Rate >= (select max(Rate) from Item where Icode like '0856/99')
		--Question02:Viết SQL để hiển thị Tên khách hàng, Điện thoại, Ngày đặt hàng, Mã mặt hàng, Tỷ giá và sắp xếp theo Số lượng giảm dần
		select A.CName, A.Cphone, B.OrderDate, C.ItemCode, D.Rate, C.Qty
		from Customer A, OrderMaster B, OrderDetails C, Item D
		where	A.CCode		=B.CCode and
				B.OrderNo	=C.OrderNo and
				C.ItemCode	=D.Icode
		order by C.Qty desc--desc (Descending):Giảm dần