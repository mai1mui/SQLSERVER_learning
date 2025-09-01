--1.select without from
	--1.1.system variable
	select @@VERSION--truy vấn version của SQL trên máy tính
	--1.2.user-defined variable
	declare @myvari varchar (100)
	set @myvari = 'i am go to school'
	select @myvari
	--1.3.function
	select getdate()--trả kq năm/tháng/ngày hiện tại
	select convert (varchar(15), getdate(),103)--103:năm/tháng/ngày, 101:tháng/ngày/năm
	select DATEDIFF(dd,getdate(),'2025/04/30') --tính độ lệch, datepart:dd, day, mm,month, yy, year viết nào cũng được
	select dateadd(dd,51,getdate())
	select convert (varchar(10), dateadd(dd,51,getdate()),103)
--5.using constraint 
--6.renaming result set column names 1-2
select CCode + 'co sdt la' + CPhone as N'Customer inf-thông tin'
from Customer
--7.select...distinct
select distinct ItemCode
from OrderDetails
--8.using top and percent:giới hạn số lượng hàng trả về từ truy vấn
SELECT TOP (6) CName,CCode
FROM Customer
ORDER BY CName;

SELECT TOP (10) PERCENT CustomerID, CustomerName
FROM Customers
ORDER BY CustomerID;
--9.select...into:tạo một bảng mới và sao chép dữ liệu từ một bảng hiện có
SELECT * INTO New_Customers
FROM Customers;
--10.select...where qua quen thuộc
--11.group...by
	--11.1.group...by without aggregate function
	select ItemCode
	from OrderDetails
	group by ItemCode
	--11.2.sum phải sử dụng group...by
	select ItemCode sum(Qty) as Total
	from OrderDetails
	group by ItemCode
	--14. group...by đi với having
	select ItemCode sum(Qty)
	from OrderDetails
	group by ItemCode
	having ItemCode like 'STCS%'
--12.order by clause:sắp xếp kết quả truy vấn theo một hoặc nhiều cột theo thứ tự tăng dần (ASC) hoặc giảm dần (DESC).
SELECT ICode,ItemName
FROM Item
ORDER BY Rate;
--13.xml data type( chưa học tới)
--15.summaiing data
	select OrderNo, ItemCode, sum(Qty)
	from OrderDetails
	group by OrderNo, ItemCode with cube

	select OrderNo, ItemCode, sum(Qty)
	from OrderDetails
	group by OrderNo, ItemCode with rollup