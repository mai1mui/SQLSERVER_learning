/*chú thích nhiều dòng*/
/*1.chú thích
	-- single line
	/**/multiple line
2.chọn current database (DB mặc định)
3.thực thi câu lệnh dc chọn
4.khác*/
use StrongHold
go
--cau 2
--1.CCode, CName from Customer
select CCode, CName
from Customer
--2.all field from OrderMaster
select *
from OrderMaster
--3.OrderNo, ItemCode,Quantity from OrderDetails
select OrderNo,ItemCode, Qty
from OrderDetails