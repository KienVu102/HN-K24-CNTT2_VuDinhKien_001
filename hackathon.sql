CREATE DATABASE IF NOT EXISTS Hackathon;
USE Hackathon;

-- PHẦN 1: Tạo CSDL và các bảng

CREATE TABLE Patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL
);

CREATE TABLE Doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    years_of_experience INT CHECK (years_of_experience >= 0),
    consultation_fee DECIMAL(10, 2) NOT NULL CHECK (consultation_fee >= 0)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    appointment_date TIMESTAMP NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled'),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT UNIQUE,
    payment_method VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- 2. Chèn dữ liệu
INSERT INTO Patients VALUES 
('P001','Nguyen Van An','1995-03-15','Male','0912345678','Hanoi, Vietnam'),
('P002','Tran Thi Binh','1998-07-22','Female','0923456789','Ho Chi Minh, Vietnam'),
('P003','Le Minh Chau','2000-12-05','Other','0934567890','Da Nang, Vietnam'),
('P004','Pham Hoang Duc','1987-09-10','Male','0945678901','Can Tho, Vietnam'),
('P005','Vu Thi Hoa','1992-01-28','Female','0956789012','Hai Phong, Vietnam');

INSERT INTO Doctors VALUES 
('D001', 'Nguyen Van Minh', 'Nội', 10, 500.00),
('D002', 'Tran Thi Lan', 'Ngoại', 15, 700.00),
('D003', 'Le Hoang Nam', 'Nhi', 8, 400.00),
('D004', 'Pham Quang Huy', 'Tim mạch', 20, 900.00),
('D005', 'Vu Thi Mai', 'Da liễu', 5, 350.00),
('D006', 'Nguyen Thanh Tung', 'Thần kinh', 12, 800.00),
('D007', 'Do Minh Khoa', 'Chấn thương', 7, 450.00),
('D008', 'Bui Ngoc Anh', 'Sản khoa', 18, 850.00);

INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(1, 'P001', 'D001', '2025-03-01 08:00:00', 'Completed'),
(2, 'P002', 'D002', '2025-03-01 09:30:00', 'Completed'),
(3, 'P003', 'D003', '2025-03-02 10:00:00', 'Scheduled'),
(4, 'P004', 'D004', '2025-03-02 14:00:00', 'Completed'),
(5, 'P005', 'D005', '2025-03-03 15:30:00', 'Cancelled');

INSERT INTO Payment (appointment_id, payment_method, payment_date, amount) VALUES 
(1, 'Cash', '2025-03-01 08:45:00', 500.00),
(2, 'Credit Card', '2025-03-01 10:00:00', 700.00),
(4, 'Bank Transfer', '2025-03-02 15:00:00', 900.00);

-- 3. Cập nhật số điện thoại 
UPDATE Patients SET phone = '0999888777' WHERE patient_id = 'P003';

-- 4. Cập nhật bác sĩ D001
UPDATE Doctors 
SET years_of_experience = years_of_experience + 1, 
    consultation_fee = consultation_fee * 1.2 
WHERE doctor_id = 'D001';

-- 5. Xóa lịch hẹn Cancelled trước ngày 2025-03-01
DELETE FROM Appointments WHERE status = 'Cancelled' AND appointment_date < '2025-03-01';

-- PHẦN 2: Truy vấn dữ liệu cơ bản

-- 6. Bác sĩ có KN > 5 năm
SELECT doctor_id, full_name, specialization FROM Doctors WHERE years_of_experience > 5;

-- 7. Bệnh nhân có tên chứa "Nguyen"
SELECT patient_id, full_name, phone FROM Patients WHERE full_name LIKE '%Nguyen%';

-- 8. Danh sách lịch hẹn sắp xếp theo ngày tăng dần
SELECT appointment_id, appointment_date, status FROM Appointments ORDER BY appointment_date ASC;

-- 9. 3 bản ghi đầu thanh toán bằng 'Cash'
SELECT * FROM Payment WHERE payment_method = 'Cash' LIMIT 3;

-- 10. Bác sĩ (bỏ qua 1, lấy 3)
SELECT doctor_id, full_name FROM Doctors LIMIT 3 OFFSET 1;

-- PHẦN 3: Truy vấn dữ liệu nâng cao

-- 11. Lịch hẹn Completed 
SELECT a.appointment_id, p.full_name AS patient_name, d.full_name AS doctor_name, a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed';

-- 12. Tất cả bác sĩ và ID lịch hẹn
SELECT d.doctor_id, d.full_name, a.appointment_id
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id;

-- 13. Tổng doanh thu theo phương thức thanh toán
SELECT payment_method, SUM(amount) AS Total_Revenue
FROM Payment
GROUP BY payment_method;

-- 14. Bác sĩ có từ 2 lịch hẹn trở lên

-- 15. Bác sĩ có phí khám cao hơn trung bình (Subquery)
SELECT doctor_id, full_name, consultation_fee
FROM Doctors
WHERE consultation_fee > (SELECT AVG(consultation_fee) FROM Doctors);

-- 16. Bệnh nhân từng khám chuyên khoa 'Tim mạch'

-- 17. Tổng hợp thông tin chi tiết
