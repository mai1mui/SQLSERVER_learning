use master
	go
--Kiểm tra xem DB có tồn tại thì xoá đi.
if exists(select * from sys.databases where name='HomeCare')
	begin
		alter database HomeCare set single_user with rollback immediate
		drop database HomeCare;
	end
	go

--1.tạo DB theo yêu cầu filegroup
create database HomeCare
	on primary (
		name		=HomeCare_dat,
		filename	='C:\DMS\DB\HomeCare_dat.mdf',
		size		=10MB,
		maxsize		=unlimited,
		filegrowth	=1MB
		),
	filegroup Regions1 (
		name		=Regions1_dat,
		filename	='C:\DMS\DB\Regions1_dat.ndf',
		size		=10MB,
		maxsize		=unlimited,
		filegrowth	=1MB
		)
	log on (
		name		=HomeCare_Log,
		filename	='C:\DMS\DB\HomeCare_log.ldf',
		size		=10MB,
		maxsize		=unlimited,
		filegrowth	=1MB
		);
	go
	--vào DB
	use HomeCare
		go

--2.tạo bảng 
	--2.1.Doctor
	create table Doctor (
		DoctorNo		varchar(15) primary key,
		DoctorName		varchar(50),
		[Address]		varchar(50),
		Email			varchar(50),
		Phone			varchar(15)
	);
	go
	--2.2.Patients
	create table Patients (
		PatientsNo		varchar(15) primary key,
		PatientsName	varchar(50),
		Email			varchar(50),
		Phone			varchar(15),
		Gender			varchar(2) check (gender in ('F', 'M'))
	);
	go
	--2.3.Schedule
	create table Schedule (
		ScheduleID		int identity primary key,
		Doctor			varchar(15) foreign key references Doctor(DoctorNo),
		Patients		varchar(15) foreign key references Patients(PatientsNo),
		Appointment		datetime,
		[Status]		bit default 1
	);
	go
--3.Insert data vào bảng
	--3.1.Doctor
	insert into Doctor (DoctorNo, DoctorName, [Address], Email, Phone) 
	values 
		('D001', 'Le Van Loi', '123 Le Loi, HCM', 'anh.nguyen@example.com', '0987654321'),
		('D002', 'Tran Hung', '456 Tran Hung Dao, HCM', 'hung.tran@example.com', '0978543210'),
		('D003', 'Nguyen Hung', '789 Nguyen Hue, HN', 'nguyenhung@example.com', '0965234789'),
		('D004', 'Pham Thi Dung', '321 Hai Ba Trung, DN', 'dung.pham@example.com', '0945123789'),
		('D005', 'Hoang Van En', '654 Ly Tu Trong, CT', 'en.hoang@example.com', '0934567890');
	go
	select * from Doctor
	go
	--3.2.Patients
	insert into Patients (PatientsNo, PatientsName, Email, Phone, Gender) 
	values 
		('P001', 'Nguyen Van An', 'an.nguyen@example.com', '0987123456', 'M'),
		('P002', 'Tran Thi Be', 'be.tran@example.com', '0978234567', 'F'),
		('P003', 'Le Van Chanh', 'chanh.le@example.com', '0969345678', 'M'),
		('P004', 'Pham Thi Van', 'van.pham@example.com', '0945456789', 'F'),
		('P005', 'Hoang Van Tung', 'tung.hoang@example.com', '0936567890', 'M');
	go
	select * from Patients
	go
	--3.3.Schedule
	insert into Schedule (Doctor, Patients, Appointment, [Status]) 
	values 
		('D001', 'P001', '2025-03-20 08:00:00', 1),
		('D002', 'P002', '2025-03-20 10:30:00', 1),
		('D003', 'P003', '2025-03-21 14:00:00', 0),
		('D004', 'P004', '2025-03-22 16:45:00', 1),
		('D005', 'P005', '2025-03-23 09:15:00', 1);
	go
	select * from Schedule
	go

--4.tạo chỉ mục
--create clustered index IX_Schedule 
	--on Schedule (ScheduleID);
	--go

--5.tạo view lấy tất cả bệnh nhân có giới tính 'M' và có lịch hẹn đang hoạt động
--Xóa view cũ trước khi tạo lại
	if exists (select * from sys.views where name = 'vw_Schedule')
		drop view vw_Schedule
		go
create view vw_Schedule
	as
	select P.PatientsNo, P.PatientsName, P.Gender, S.[Status]
	from Schedule S, Patients P
	where	S.Patients =P.PatientsNo and
			P.Gender = 'M' and 
			S.[Status] = 1;
	go
	select * from vw_Schedule
	go
--6.tạo stored procedure chọn tất cả bệnh nhân theo tên có lịch hẹn đang hoạt động
create procedure sp_Schedule 
		@PatientsName varchar(50)
	as
	begin
		select P.PatientsNo, P.PatientsName, P.Gender, S.Appointment, S.[Status]
		from Schedule S, Patients P
		where	S.Patients =P.PatientsNo and
				P.PatientsName like '%' + @PatientsName + '%' and 
				S.[Status] = 1;
	end;
	go
	--test procedure
	exec sp_Schedule 'Hoang Van Tung';
	go
--7.tạo trigger tự động xóa bản ghi khi status bị chuyển thành false (0) và hiển thị thông báo
	--lệnh DELETE thủ công trước khi tạo trigger-> xóa điều kiện status = 0 có sẵn lúc insert data
	delete from Schedule where [Status] = 0;
		go
	create trigger t_Schedule
		on Schedule
		after insert, update
		as
		begin
			set nocount on;
			-- Xóa bản ghi có Status = 0 sau khi cập nhật hoặc thêm mới
			delete from Schedule
			where ScheduleID in (
				select ScheduleID 
				from inserted 
				where [Status] = 0
			);

			print 'Item has been deleted.';
		end;
		go
	--kiểm tra Trigger
	update Schedule
		set [Status] = 0
		where ScheduleID = 1;
		go
	select * from Schedule 

