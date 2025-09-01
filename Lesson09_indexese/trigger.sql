--1.Khái niệm trigger:
	--Trigger (bộ kích hoạt) là một loại thủ tục đặc biệt trong cơ sở dữ liệu, được tự động thực thi khi xảy ra một sự kiện cụ thể trên bảng (table),
--chẳng hạn như thêm (INSERT), cập nhật (UPDATE), hoặc xóa (DELETE) dữ liệu
--2.Trigger thường được sử dụng để:
	--Duy trì tính toàn vẹn dữ liệu.
	--Tự động thực hiện các tác vụ (ví dụ: ghi log, cập nhật bảng khác).
	--Kiểm soát hoặc ghi lại các thay đổi trong cơ sở dữ liệu.
--3.các đặc điểm chính:
	--Loại sự kiện: INSERT, UPDATE, DELETE.
	--Thời điểm kích hoạt: BEFORE (trước sự kiện), AFTER (sau sự kiện), hoặc INSTEAD OF (thay thế sự kiện).
	--Phạm vi: Áp dụng trên từng dòng (ROW) hoặc toàn bộ câu lệnh (STATEMENT).

--example:
	--Tạo bảng: lưu thông tin nhân viên (id, name, salary)
	CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
	);
	--Tạo bảng:ghi lại mỗi lần lương nhân viên bị thay đổi.
	CREATE TABLE audit_log (
    log_id INT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date DATETIME
	);
	--Trigger này sẽ tự động ghi log vào bảng audit_log mỗi khi lương (salary) trong bảng employees được cập nhật:
	DELIMITER //
		CREATE TRIGGER salary_update_trigger
		AFTER UPDATE ON employees
		FOR EACH ROW
		BEGIN
			IF OLD.salary != NEW.salary THEN
				INSERT INTO audit_log (employee_id, old_salary, new_salary, change_date)
				VALUES (OLD.id, OLD.salary, NEW.salary, NOW());
			END IF;
		END //
	DELIMITER ;