use master
	go
--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(SELECT * FROM sys.databases WHERE name='Cinema_CGV')
	BEGIN
		ALTER DATABASE Cinema_CGV SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE Cinema_CGV;
	END
	go
--1.tạo database cinema_CGV
CREATE DATABASE Cinema_CGV;
GO
--2.vào chính DB
USE Cinema_CGV;
GO
--3.tạo bảng khách hàng:SDT làm primary key, tên khách hàng,email, địa chỉ
CREATE TABLE Customers (
    PhoneNumber VARCHAR(15) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE, --không trùng email
    CAddress NVARCHAR(255)--N: cho phép gõ tiếng việt
);
--4.tạo bảng movie-inf: ID phim làm primary key, thể loại, tên phim,đạo diễn, thời lượng phim, nước sx, năm sx, đánh giá
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY IDENTITY(1,1),
    Genre NVARCHAR(50) NOT NULL,
    MovieName NVARCHAR(255) NOT NULL,
    Director NVARCHAR(100),
    Duration INT CHECK (Duration > 0),  -- Thời lượng tính bằng phút
    Country NVARCHAR(100),
    ReleaseYear INT, 
    Rating FLOAT CHECK (Rating BETWEEN 0 AND 10) -- Đánh giá từ 0 - 10
);
--5.tạo bảng phòng chiếu: Id phòng làm primary key, tên phòng, vị trí, loại phòng(thường,vip), số ghế, tình trạng(trống, đang mở, đã đầy)
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomName NVARCHAR(50) NOT NULL,
    RLocation NVARCHAR(255),
    RoomType NVARCHAR(10),
    SeatCount INT CHECK (SeatCount > 0),
    RStatus NVARCHAR(20)
);
--6.tạo bảng ticket-inf:ID vé làm primary key,sdt khách hàng, tên phim, ngày mua vé,giá vé, số lượng vé đã mua
CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    PhoneNumber VARCHAR(15) NOT NULL,
    MovieID INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    TicketQuantity INT CHECK (TicketQuantity > 0),
    FOREIGN KEY (PhoneNumber) REFERENCES Customers(PhoneNumber) ON DELETE CASCADE,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE
);
--7.tạo bảng lịch chiếu phim: id lịch làm primary key,ID phim,ngày chiếu, giờ chiếu, ID phòng, số ghế, số ghế đã đặt
CREATE TABLE MovieSchedules (
    ScheduleID INT PRIMARY KEY IDENTITY(1,1),
    MovieID INT NOT NULL,
    ShowDate DATE NOT NULL,
    ShowTime TIME NOT NULL,
    RoomID INT NOT NULL,
    SeatCount INT CHECK (SeatCount > 0),
    BookedSeats INT CHECK (BookedSeats >= 0),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE
);
--8.Bảng ghế ngồi: id ghế làm primary key, Id phòng, số ghế, kiểu ghế
CREATE TABLE Seats (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT NOT NULL,
    SeatNumber NVARCHAR(10) NOT NULL,  -- Ví dụ: A1, B2, C10
    SeatType NVARCHAR(10),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE CASCADE,
    UNIQUE (RoomID, SeatNumber) -- Đảm bảo không có trùng số ghế trong cùng một phòng
);
--9.Bảng đặt ghế (liên kết khách hàng, vé và ghế ngồi): ID đặt ghế làm primary key, ID vé, id ghế, ngày đặt
CREATE TABLE SeatBookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    TicketID INT NOT NULL,
    SeatID INT NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID) ON DELETE CASCADE,
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID) ON DELETE CASCADE,
    UNIQUE (SeatID) -- Một ghế chỉ có thể được đặt một lần
);
--10.tạo bảng doanh thu:id làm primary key, ngày, ID phim, giá vé, số lượng vé đã bán
CREATE TABLE Revenue (
    RevenueID INT PRIMARY KEY IDENTITY(1,1),
    RevenueDate DATE NOT NULL,
    MovieID INT NOT NULL,
    TicketPrice DECIMAL(10,2) CHECK (TicketPrice > 0),
    TicketsSold INT CHECK (TicketsSold >= 0),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID) ON DELETE CASCADE
);
--11.insert data vào bảng customer
INSERT INTO Customers (PhoneNumber, CustomerName, Email, CAddress)
VALUES 
	('0987654321', N'Nguyễn Văn A', 'nguyenvana@example.com', N'123 Lê Lợi, Hà Nội'),
	('0976543210', N'Trần Thị B', 'tranthib@example.com', N'45 Nguyễn Trãi, TP.HCM'),
	('0965432109', N'Lê Văn C', 'levanc@example.com', N'78 Hai Bà Trưng, Đà Nẵng'),
	('0954321098', N'Phạm Thị D', 'phamthid@example.com', N'99 Trần Hưng Đạo, Cần Thơ'),
	('0943210987', N'Hoàng Văn E', 'hoangvane@example.com', N'12 Lý Thường Kiệt, Hải Phòng'),
	('0932109876', N'Đặng Thị F', 'dangthif@example.com', N'56 Pasteur, Nha Trang');
	go
--12.insert data vào bảng Movies
INSERT INTO Movies (Genre, MovieName, Director, Duration, Country, ReleaseYear, Rating)
VALUES 
	(N'Hành động',			N'John Wick 4', N'Chad Stahelski', 169, N'Mỹ', 2023, 8.2),
	(N'Khoa học viễn tưởng', N'Avatar: The Way of Water', N'James Cameron', 192, N'Mỹ', 2022, 7.8),
	(N'Kinh dị',			N'IT: Chapter Two', N'Andy Muschietti', 169, N'Mỹ', 2019, 7.0),
	(N'Hoạt hình',			N'Toy Story 4',		N'Josh Cooley', 100, N'Mỹ', 2019, 8.0),
	(N'Tâm lý',				N'A Star Is Born', N'Bradley Cooper', 136, N'Mỹ', 2018, 7.7),
	(N'Phiêu lưu',			N'Indiana	Jones and the Dial of Destiny', N'James Mangold', 154, N'Mỹ', 2023, 6.7),
	(N'Hài hước',			N'Jumanji:	Welcome to the Jungle', N'Jake Kasdan', 119, N'Mỹ', 2017, 7.0),
	(N'Kinh dị',			N'Conjuring: The Devil Made Me Do It', N'Michael Chaves', 112, N'Mỹ', 2021, 6.3),
	(N'Viễn tưởng',			N'Dune:		Part One', N'Denis Villeneuve', 155, N'Mỹ', 2021, 8.1),
	(N'Chiến tranh',		N'1917',	N'Sam Mendes', 119, N'Anh', 2019, 8.3);
	go
--13.insert data vào bảng Rooms
INSERT INTO Rooms (RoomName, RLocation, RoomType, SeatCount, RStatus)
VALUES 
(N'Phòng 1', N'Tầng 1 - Khu A', N'Thường', 100, N'Đang mở'),
(N'Phòng 2', N'Tầng 1 - Khu B', N'VIP', 50, N'Đang mở'),
(N'Phòng 3', N'Tầng 2 - Khu A', N'Thường', 120, N'Trống'),
(N'Phòng 4', N'Tầng 2 - Khu B', N'Thường', 90, N'Đã đầy'),
(N'Phòng 5', N'Tầng 3 - Khu A', N'VIP', 60, N'Đang mở'),
(N'Phòng 6', N'Tầng 3 - Khu B', N'Thường', 110, N'Trống'),
(N'Phòng 7', N'Tầng 4 - Khu A', N'VIP', 70, N'Đang mở');

--14.insert data vào bảng Tickets
INSERT INTO Tickets (PhoneNumber, MovieID, PurchaseDate, Price, TicketQuantity)
VALUES 
	-- Khách hàng 1
	('0987654321', 1, '2025-03-01', 120000, 2),
	('0987654321', 3, '2025-03-02', 100000, 1),
	('0987654321', 5, '2025-03-03', 150000, 3),
	-- Khách hàng 2
	('0976543210', 2, '2025-03-01', 130000, 2),
	('0976543210', 4, '2025-03-02', 90000, 1),
	('0976543210', 6, '2025-03-03', 110000, 2),
	-- Khách hàng 3
	('0965432109', 1, '2025-03-04', 120000, 2),
	('0965432109', 7, '2025-03-05', 95000, 1),
	('0965432109', 9, '2025-03-06', 140000, 3),
	-- Khách hàng 4
	('0954321098', 2, '2025-03-04', 130000, 2),
	('0954321098', 8, '2025-03-05', 90000, 1),
	('0954321098', 10, '2025-03-06', 125000, 2),
	-- Khách hàng 5
	('0943210987', 3, '2025-03-07', 100000, 2),
	('0943210987', 5, '2025-03-08', 150000, 1),
	('0943210987', 7, '2025-03-09', 95000, 2),
	-- Khách hàng 6
	('0932109876', 4, '2025-03-07', 90000, 3),
	('0932109876', 6, '2025-03-08', 110000, 2),
	('0932109876', 8, '2025-03-09', 90000, 1),
	-- Thêm vé khác cho nhiều khách hàng
	('0987654321', 9, '2025-03-10', 140000, 2),
	('0976543210', 10, '2025-03-11', 125000, 1),
	('0965432109', 1, '2025-03-12', 120000, 2),
	('0954321098', 2, '2025-03-13', 130000, 2),
	('0943210987', 3, '2025-03-14', 100000, 1),
	('0932109876', 4, '2025-03-15', 90000, 2),
	('0987654321', 5, '2025-03-16', 150000, 3),
	('0976543210', 6, '2025-03-17', 110000, 2),
	('0965432109', 7, '2025-03-18', 95000, 1),
	('0954321098', 8, '2025-03-19', 90000, 2),
	('0943210987', 9, '2025-03-20', 140000, 2),
	('0932109876', 10, '2025-03-21', 125000, 1);

--15.insert data vào bảng MovieSchedules
INSERT INTO MovieSchedules (MovieID, ShowDate, ShowTime, RoomID, SeatCount, BookedSeats)
VALUES 
	(1, '2025-03-10', '18:00:00', 1, 100, 80),
	(2, '2025-03-10', '20:30:00', 2, 50, 45),
	(3, '2025-03-11', '19:00:00', 3, 120, 100),
	(4, '2025-03-11', '21:00:00', 4, 90, 90),
	(5, '2025-03-12', '18:30:00', 5, 60, 50),
	(6, '2025-03-12', '20:00:00', 6, 110, 85),
	(7, '2025-03-13', '19:30:00', 7, 70, 60),
	(8, '2025-03-13', '21:15:00', 1, 100, 70),
	(9, '2025-03-14', '18:45:00', 2, 50, 40),
	(10, '2025-03-14', '20:45:00', 3, 120, 90);
	go

--16.insert data vào bảng customer
INSERT INTO Seats (RoomID, SeatNumber, SeatType)
VALUES 
	-- Ghế trong Phòng 1
	(1, 'A1', N'Thường'), (1, 'A2', N'Thường'), (1, 'A3', N'Thường'), (1, 'A4', N'Thường'), (1, 'A5', N'Thường'),
	(1, 'B1', N'Thường'), (1, 'B2', N'Thường'), (1, 'B3', N'Thường'), (1, 'B4', N'Thường'), (1, 'B5', N'Thường'),
	-- Ghế trong Phòng 2 (VIP)
	(2, 'A1', N'VIP'), (2, 'A2', N'VIP'), (2, 'A3', N'VIP'), (2, 'A4', N'VIP'), (2, 'A5', N'VIP'),
	(2, 'B1', N'VIP'), (2, 'B2', N'VIP'), (2, 'B3', N'VIP'), (2, 'B4', N'VIP'), (2, 'B5', N'VIP'),
	-- Ghế trong Phòng 3
	(3, 'A1', N'Thường'), (3, 'A2', N'Thường'), (3, 'A3', N'Thường'), (3, 'A4', N'Thường'), (3, 'A5', N'Thường'),
	-- Ghế trong Phòng 4
	(4, 'B1', N'Thường'), (4, 'B2', N'Thường'), (4, 'B3', N'Thường'), (4, 'B4', N'Thường'), (4, 'B5', N'Thường'),
	-- Ghế trong Phòng 5 (VIP)
	(5, 'C1', N'VIP'), (5, 'C2', N'VIP'), (5, 'C3', N'VIP'), (5, 'C4', N'VIP'), (5, 'C5', N'VIP'),
	-- Ghế trong Phòng 6
	(6, 'D1', N'Thường'), (6, 'D2', N'Thường'), (6, 'D3', N'Thường'), (6, 'D4', N'Thường'), (6, 'D5', N'Thường'),
	-- Ghế trong Phòng 7 (VIP)
	(7, 'E1', N'VIP'), (7, 'E2', N'VIP'), (7, 'E3', N'VIP'), (7, 'E4', N'VIP'), (7, 'E5', N'VIP');

--17.insert data vào bảng SeatBookings
INSERT INTO SeatBookings (TicketID, SeatID, BookingDate)
VALUES 
	-- Vé của khách hàng 1
	(1, 1, '2025-03-01 10:00:00'), (1, 2, '2025-03-01 10:01:00'),
	(2, 3, '2025-03-02 14:30:00'),
	(3, 4, '2025-03-03 16:45:00'), (3, 5, '2025-03-03 16:46:00'), (3, 6, '2025-03-03 16:47:00'),
	-- Vé của khách hàng 2
	(4, 7, '2025-03-01 18:00:00'), (4, 8, '2025-03-01 18:01:00'),
	(5, 9, '2025-03-02 20:30:00'),
	(6, 10, '2025-03-03 21:15:00'), (6, 11, '2025-03-03 21:16:00'),
	-- Vé của khách hàng 3
	(7, 12, '2025-03-04 19:00:00'), (7, 13, '2025-03-04 19:01:00'),
	(8, 14, '2025-03-05 20:00:00'),
	(9, 15, '2025-03-06 21:30:00'), (9, 16, '2025-03-06 21:31:00'), (9, 17, '2025-03-06 21:32:00'),
	-- Vé của khách hàng 4
	(10, 18, '2025-03-04 17:30:00'), (10, 19, '2025-03-04 17:31:00'),
	(11, 20, '2025-03-05 18:15:00'),
	(12, 21, '2025-03-06 20:45:00'), (12, 22, '2025-03-06 20:46:00'),
	-- Vé của khách hàng 5
	(13, 23, '2025-03-07 15:30:00'), (13, 24, '2025-03-07 15:31:00'),
	(14, 25, '2025-03-08 17:45:00'),
	(15, 26, '2025-03-09 19:00:00'), (15, 27, '2025-03-09 19:01:00'), (15, 28, '2025-03-09 19:02:00'),
	-- Vé của khách hàng 6
	(16, 29, '2025-03-07 12:00:00'), (16, 30, '2025-03-07 12:01:00'),
	(17, 31, '2025-03-08 14:45:00'),
	(18, 32, '2025-03-09 16:30:00'), (18, 33, '2025-03-09 16:31:00'),
	-- Thêm đặt chỗ cho nhiều khách hàng khác
	(19, 34, '2025-03-10 18:00:00'), (20, 35, '2025-03-11 20:00:00'),
	(21, 36, '2025-03-12 18:30:00'), (22, 37, '2025-03-13 19:30:00'),
	(23, 38, '2025-03-14 21:00:00'), (24, 39, '2025-03-15 20:45:00'),
	(25, 40, '2025-03-16 18:45:00'), (26, 41, '2025-03-17 19:15:00'),
	(27, 42, '2025-03-18 20:30:00'), (28, 43, '2025-03-19 21:15:00'),
	(29, 44, '2025-03-20 19:45:00'), (30, 45, '2025-03-21 20:00:00');
--18.insert data vào bảng Revenue
--19.truy vấn lấy danh sách phim đang chiếu theo ngày, theo giờ, theo phòng,
--20.kiểm tra số lượng vé đã bán theo từng loại phim, tìm phim đang hot
--21.kiểm tra các phòng còn vé
--22.lọc các phòng đã đầy
--23.truy vấn thông tin phim
--24.thống kê số lượng vé bán theo từng cụm ngày