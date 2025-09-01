use PolySite
	go

--Exercise01:Viết SQL để hiển thị thông tin sau:
	--Question01: OrderNo, OrderDate, Customer Name, Item Name từ các bảng
	select B.OrderNo, B.OrderDate, A.CName, D.ItemName
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode

	--Question02: Mã khách hàng, Tên và Địa chỉ. Nhận thêm Tên mặt hàng, Số lượng và Số tiền
	select A.CCode, A.CName, A.CAddress, D.ItemName, C.Qty, D.Rate
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode
	--Question03: OrderNo, OrderDate, Tên mặt hàng, Số lượng và đơn hàng theo OrderDate	
	select B.OrderNo, B.OrderDate, D.ItemName, C.Qty 
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode
	ORDER BY B.OrderDate;--Sắp xếp theo OrderDate
	--Question04: Mã mặt hàng, Tên mặt hàng và chiết khấu (20%)
	select D.Icode, D.ItemName, D.Rate
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode
			D.Rate * 0.2 --chiết khấu (20%)
--Exercise02:
	--Question01:Viết SQL để hiển thị thông tin sau: OrderNo, OrderDate, Item Code và Item Rate		
	select B.OrderNo, B.OrderDate, C.ItemCode, D.Rate 
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode
	--Question02:Viết SQL để hiển thị: Tên khách hàng, Mã mặt hàng, Số đơn hàng có Số lượng mặt hàng nhỏ hơn 50		
	select A.CName, C.ItemCode, B.OrderNo, C.Qty
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode and
			C.Qty <5000
	--Question03:Viết SQL để hiển thị: Khách hàng ‘KH0003’ OrderNo, OrderDate, Item Code và Amount	
	select B.OrderNo, B.OrderDate, C.ItemCode, C.Qty * D.Rate as 'Amount'
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode and
			A.CCode like 'KH0003'--like chỉ được sử dụng trong where
--Exercise03:
	--Question01: hiển thị tổng số sp có vòi (BOTTLE SPOUT) kí hiệu BSxxx
		--cách 1:tính tổng -> lọc ra có vòi
		select ItemCode,sum (Qty) as 'Total'
		from OrderDetails
		group by ItemCode
		having ItemCode like 'BS%'
			--=> cách 1 có thể xem được tổng số lượng theo từng itemcode
		--cách 2: lọc ra có vòi -> tính tổng
		select sum (Qty) as 'Total'
		from OrderDetails
		where ItemCode like 'BS%'
			--=> cách 2 chỉ xem được tổng số lượng
	--Question02:hiển thị Số đơn hàng, Mã mặt hàng, Số lượng mà Số lượng trong Đơn hàng lớn hơn hoặc bằng các số khác
		--=> để so sánh số lượng thay vì đi so sánh từng cặp tìm số lớn hơn, ta tìm số lớn nhất, rồi so sánh với số lớn nhất
		select OrderNo, ItemCode, Qty
		from OrderDetails
		where Qty >= (select max(Qty) from OrderDetails)
--Exercise04:
	--Question01:hiển thị Mã mặt hàng, Tên mặt hàng và rate cho thấy rate này >= rate của PLASTIC BOTTLE WITH SPOUT 500ml”
	select Icode, ItemName, Rate
	from Item
	where Rate >= (select max(Rate) from Item where Icode like 'BS500')
	--Question02:hiển thị Tên khách hàng, Điện thoại, Ngày đặt hàng, Mã mặt hàng, rate và sắp xếp theo Số lượng giảm dần
	select A.CName, A.Cphone, B.OrderDate, C.ItemCode, D.Rate, C.Qty
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode
	order by C.Qty desc--desc (Descending):Giảm dần
	--example: asc(Ascending):Tăng dần
	select A.CName, A.Cphone, B.OrderDate, C.ItemCode, D.Rate, C.Qty
	from Customer A, OrderMaster B, OrderDetails C, Item D
	where	A.CCode		=B.CCode and
			B.OrderNo	=C.OrderNo and
			C.ItemCode	=D.Icode
	order by C.Qty asc