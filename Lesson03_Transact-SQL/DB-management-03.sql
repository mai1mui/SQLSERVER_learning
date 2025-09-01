--chuyển sang DB master
use master
go
--kiểm tra sự tồn tại DB [DB].[Bảng]
select name from master..sysdatabases where name = 'StrongHold' --master..sysdatabases => .sysdatabases
--kiểm tra sự tồn tại của DB abc, nếu tìm thấy thì xóa để có thể tạo bảng abc nhiều lần k bị trùng
if exists (select name from master..sysdatabases where name = 'abc')
drop database abc --xóa
go
--tạo mới DB abc
create database abc
--chojn abc lafm current DB
go
use abc
go