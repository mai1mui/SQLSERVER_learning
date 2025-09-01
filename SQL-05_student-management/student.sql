use master
	go

--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(SELECT * FROM sys.databases WHERE name='Student')
DROP DATABASE Student
	GO

--tạo DB tên Student
create database Student
	go

--vào DB Student
use Student
	go

--tạo bảng môn học
CREATE TABLE SSubject (
    MaMH VARCHAR(10) NOT NULL,
    Lop VARCHAR(10) NOT NULL PRIMARY KEY,     -- Lớp học
    TenMH NVARCHAR(50) NOT NULL,  -- Tên môn học (cho phép tiếng Việt có dấu)
    SoTiet INT CHECK (SoTiet > 0) -- Số tiết (phải lớn hơn 0)
	);
	GO

--tạo bảng thông tin sinh vien
CREATE TABLE SStudent (
    MaSV VARCHAR(10) PRIMARY KEY,  -- Mã sinh viên (khóa chính)
    Lop VARCHAR(10) NOT NULL,      -- Lớp học (không đặt UNIQUE)
    TenSV NVARCHAR(50) NOT NULL,   -- Họ và tên sinh viên
    NgaySinh DATE,                 -- Ngày sinh (chỉ lưu ngày)
    GioiTinh NVARCHAR(10),         -- Giới tính (Nam/Nữ)
    QueQuan NVARCHAR(50),          -- Quê quán
    FOREIGN KEY (Lop) REFERENCES SSubject(Lop) -- Khóa ngoại liên kết lớp học
	);
	GO


--tạo bảng kết quả
CREATE TABLE SScore (
    MaSV VARCHAR(10) NOT NULL,  -- Mã sinh viên
    MaMH VARCHAR(10) NOT NULL,  -- Mã môn học
    Diem DECIMAL(3,1) CHECK (Diem BETWEEN 0 AND 100), -- Điểm từ 0 - 10
    FOREIGN KEY (MaSV) REFERENCES SStudent(MaSV),
	);
	GO

--insert data SSubject
INSERT INTO SSubject (MaMH, Lop, TenMH, SoTiet) 
VALUES
	('MH001', '10A1', N'Toán', 45),
	('MH004', '10A2', N'Lý', 30),
	('MH006', '11B1', N'Sinh', 25),
	('MH008', '11B2', N'Địa', 20),
	('MH009', '12C1', N'GDCD', 15),
	('MH010', '12C2', N'Tin học', 25);
	GO

--insert data SStudent
INSERT INTO SStudent (MaSV, Lop, TenSV, NgaySinh, GioiTinh, QueQuan) 
VALUES
	('SV001', '10A1', N'Nguyễn Văn A', '2005-09-15', N'Nam', N'Hà Nội'),
	('SV002', '10A1', N'Trần Thị B', '2005-05-22', N'Nữ', N'Hải Phòng'),
	('SV003', '10A1', N'Lê Văn C', '2005-07-08', N'Nam', N'Nam Định'),
	('SV004', '10A2', N'Phạm Thị D', '2004-12-30', N'Nữ', N'Thái Bình'),
	('SV005', '10A2', N'Hoàng Văn E', '2004-06-10', N'Nam', N'Ninh Bình'),
	('SV006', '11B1', N'Vũ Thị F', '2003-11-25', N'Nữ', N'Hà Nam'),
	('SV007', '11B1', N'Bùi Văn G', '2003-02-14', N'Nam', N'Hải Dương'),
	('SV008', '11B2', N'Đinh Thị H', '2003-08-19', N'Nữ', N'Bắc Giang'),
	('SV009', '12C1', N'Ngô Văn I', '2002-04-05', N'Nam', N'Vĩnh Phúc'),
	('SV010', '12C2', N'Tôn Nữ J', '2002-09-29', N'Nữ', N'Thừa Thiên Huế');
	GO

--insert data SScore
INSERT INTO SScore (MaSV, MaMH, Diem) 
VALUES
	('SV001', 'MH001', 80.5),
	('SV002', 'MH001', 70.0),
	('SV003', 'MH004', 90.0),
	('SV004', 'MH006', 60.5),
	('SV005', 'MH004', 50.0),
	('SV006', 'MH009', 70.5),
	('SV007', 'MH008', 80.0),
	('SV008', 'MH008', 90.5),
	('SV009', 'MH008', 40.0),
	('SV010', 'MH009', 98.0);
GO

--1.thêm 2 sv mới
--2.cập nhật sv lê văn C chuyển lớp 11B1
--3.xóa sv tôn nữ J đã chuyển trường
--4.tính điểm trung bình từng sv
--5.tìm sv xuất sắc nhất
--6.thống kê số lượng sv theo từng khung điểm
--7.thêm cột xếp hạng thành tích sv: <50 trượt, >50 đạt, >90 xuất sắc