--5.field alias
use StrongHold
go
--tại sao 2 cái viết khác nhau nhưng ra kết quả giống nhau
select CCode,CName
from Customer

select Customer.CCode, Customer.CName
from Customer
--alias là gì?vì sao cần sd
select A.CCode, A.Cname
from Customer as A--có thể viết tắt from Customer A
	--alias dùng để chỉ cụ thể cột CCode được lấy từ bảng nào nếu select đang chọn nhiều bảng, có nhiều cột giống nhau

--6.return a result --> bôi từng bó lệnh-> f5 để xem khác biệt
	--lọc giá trị của cột ccode
select CCode
from Customer
	--tìm giá trị TLT trong cột ccode
select CCode
from Customer
where CCode ='TLT'
	--ccode nằm trong '' được xem là hằng
select 'CCode'
from Customer
	--tìm giá trị TLT trong cột ccode, nếu đúng-> hiển thị true
select 'true'
from Customer
where CCode ='TLT'
	--tìm giá trị TLT1 trong cột ccode, nếu đúng-> hiển thị true
select 'true'
from Customer
where CCode ='TLT1'
