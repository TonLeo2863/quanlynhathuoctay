-- 1. TẠO CƠ SỞ DỮ LIỆU
CREATE DATABASE PharmacyDB;
GO

USE PharmacyDB;


-- 2. TẠO CÁC BẢNG
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL
);

CREATE TABLE Medicines (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Unit NVARCHAR(50) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    ImagePath NVARCHAR(MAX)
);

CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    LoyaltyPoints INT NOT NULL DEFAULT 0
);

CREATE TABLE Invoices (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId VARCHAR(50) UNIQUE,
    CustomerId INT NULL,
    CreatedBy INT NULL,
    CreatedDate DATETIME NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    Note NVARCHAR(MAX),

    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
);

CREATE TABLE InvoiceDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId INT NOT NULL,
    MedicineId INT NOT NULL,
    MedicineName NVARCHAR(200) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TotalPrice DECIMAL(18,2) NOT NULL,

    FOREIGN KEY (InvoiceId) REFERENCES Invoices(Id),
    FOREIGN KEY (MedicineId) REFERENCES Medicines(Id)
);


CREATE TABLE MedicineBatches (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MedicineId INT NOT NULL,
    BatchNumber NVARCHAR(50),
    Quantity INT NOT NULL,
    ExpiryDate DATE NOT NULL,
    ImportDate DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (MedicineId) REFERENCES Medicines(Id)
);

SELECT * FROM Invoices
SELECT * FROM InvoiceDetails
SELECT COUNT(*) FROM Medicines
-- 3. THÊM THUỐC
INSERT INTO Medicines (Name, Unit, Price, Quantity, ImagePath) VALUES
(N'Paracetamol 500mg', N'Viên', 2000, 500, ''),
(N'Vitamin C 500mg', N'Hộp', 45000, 51, ''),
(N'Nước muối sinh lý 0.9%', N'Chai', 5000, 200, ''),
(N'Panadol Extra', N'Vỉ', 15000, 100, ''),
(N'Amoxicillin 500mg', N'Viên', 3000, 300, ''),
(N'Efferangan 500mg', N'Viên', 4000, 150, ''),
(N'Siro ho Bổ Phế', N'Chai', 35000, 40, ''),
(N'Dầu gió xanh Thiên Ân', N'Chai', 25000, 80, ''),
(N'Bông y tế Bạch Tuyết 50g', N'Gói', 12000, 100, ''),
(N'Cồn 90 độ', N'Chai', 10000, 60, ''),
(N'Oresol vị cam', N'Gói', 3500, 250, ''),
(N'Thuốc nhỏ mắt Osla', N'Lọ', 18000, 70, ''),
(N'Vitamin 3B (B1, B6, B12)', N'Vỉ', 12000, 120, ''),
(N'Decolgen (Trị cảm cúm)', N'Vỉ', 10000, 200, ''),
(N'Tiffy Dey', N'Vỉ', 12000, 150, ''),
(N'Hoạt huyết dưỡng não', N'Hộp', 65000, 30, ''),
(N'Bao cao su Durex Invisible', N'Hộp', 120000, 40, ''),
(N'Que thử thai Quickstick', N'Hộp', 20000, 100, ''),
(N'Băng cá nhân Urgo', N'Hộp', 35000, 80, ''),
(N'Gạc y tế tiệt trùng', N'Gói', 5000, 300, ''),
(N'Khẩu trang y tế 4 lớp', N'Hộp', 40000, 150, ''),
(N'Nước súc miệng Listerine 250ml', N'Chai', 45000, 50, ''),
(N'Kem bôi da Gentrisone', N'Tuýp', 22000, 90, ''),
(N'Thuốc mỡ Tetracyclin 1%', N'Tuýp', 8000, 120, ''),
(N'Vitamin D3 K2 MK7', N'Lọ', 250000, 20, ''),
(N'Men tiêu hóa Enterogermina', N'Ống', 8000, 400, ''),
(N'Thuốc dạ dày Phosphalugel (Chữ P)', N'Gói', 5000, 300, ''),
(N'Thuốc dạ dày Yumangel (Chữ Y)', N'Gói', 5500, 250, ''),
(N'Berberin 100mg', N'Lọ', 15000, 100, ''),
(N'Loperamid 2mg (Trị tiêu chảy)', N'Vỉ', 8000, 150, ''),
(N'Trà gừng hòa tan', N'Hộp', 35000, 60, ''),
(N'Viên ngậm Bảo Thanh', N'Vỉ', 18000, 100, ''),
(N'Viên ngậm Strepsils', N'Hộp', 30000, 80, ''),
(N'Siro húng chanh', N'Chai', 55000, 40, ''),
(N'C sủi Plusssz', N'Tuýp', 42000, 70, ''),
(N'Canxi Corbiere', N'Ống', 7000, 200, ''),
(N'Sắt Ferrovit', N'Vỉ', 20000, 100, ''),
(N'Omega 3 Fish Oil', N'Lọ', 150000, 40, ''),
(N'Ginkgo Biloba 120mg', N'Lọ', 180000, 35, ''),
(N'Kẽm ZinC', N'Viên', 3000, 250, ''),
(N'Boganic (Giải độc gan)', N'Hộp', 85000, 50, ''),
(N'Thuốc tránh thai hằng ngày Marvelon', N'Vỉ', 65000, 40, ''),
(N'Thuốc tránh thai khẩn cấp Postinor', N'Viên', 35000, 80, ''),
(N'Cao dán Salonpas', N'Hộp', 20000, 100, ''),
(N'Xịt tấy tóc', N'Chai', 45000, 30, ''),
(N'Thuốc nhỏ mũi V.Rohto', N'Lọ', 55000, 60, ''),
(N'Xịt mũi cá heo Sterimar', N'Chai', 110000, 25, ''),
(N'Xịt họng Thái Dương', N'Chai', 45000, 40, ''),
(N'Kem chống muỗi Remos', N'Tuýp', 35000, 50, ''),
(N'Dầu Tràm Cung Đình', N'Chai', 80000, 30, ''),
(N'Thuốc tẩy giun Fugacar', N'Viên', 22000, 100, ''),
(N'Thuốc tẩy giun Zentel', N'Viên', 18000, 80, ''),
(N'Kháng histamine Cetirizin 10mg', N'Vỉ', 10000, 150, ''),
(N'Kháng histamine Loratadin 10mg', N'Vỉ', 12000, 120, ''),
(N'Prednisolon 5mg', N'Viên', 1000, 500, ''),
(N'Alpha Choay (Kháng viêm)', N'Vỉ', 25000, 100, ''),
(N'Kẹo ngậm vị dâu', N'Gói', 15000, 50, ''),
(N'Sữa rửa mặt Cetaphil 125ml', N'Chai', 135000, 20, ''),
(N'Nước tẩy trang Bioderma', N'Chai', 350000, 15, ''),
(N'Kem trị mụn Megaduo', N'Tuýp', 120000, 30, ''),
(N'Bột sủi thanh nhiệt Sensa Cools', N'Hộp', 25000, 60, ''),
(N'Thuốc hạ sốt Hapacol 250', N'Gói', 3000, 200, ''),
(N'Viên đặt phụ khoa', N'Hộp', 150000, 20, ''),
(N'Dung dịch vệ sinh Dạ Hương', N'Chai', 35000, 50, ''),
(N'Nhiệt kế thủy ngân', N'Cái', 15000, 100, ''),
(N'Nhiệt kế điện tử Omron', N'Cái', 120000, 20, ''),
(N'Máy đo huyết áp Omron', N'Cái', 850000, 10, ''),
(N'Kim tiêm 5ml', N'Cái', 1000, 1000, ''),
(N'Dây truyền dịch', N'Cái', 5000, 200, ''),
(N'Thuốc huyết áp Amlodipin 5mg', N'Vỉ', 15000, 150, ''),
(N'Thuốc tiểu đường Metformin 500mg', N'Vỉ', 20000, 120, ''),
(N'Thuốc mỡ Dibetalic', N'Tuýp', 45000, 40, ''),
(N'Cồn I-ốt 10%', N'Chai', 15000, 80, ''),
(N'Nước cất tiêm', N'Ống', 2000, 500, ''),
(N'Thuốc say xe Nautamine', N'Vỉ', 25000, 100, ''),
(N'Miếng dán say xe Ariel', N'Gói', 15000, 150, ''),
(N'Cẩm nang sức khỏe', N'Quyển', 50000, 10, ''),
(N'Thuốc cường dương Rocket 1h', N'Hộp', 300000, 15, ''),
(N'Viên sủi Xtraman', N'Tuýp', 500000, 10, ''),
(N'Glucosamine (Bổ khớp)', N'Lọ', 450000, 25, ''),
(N'Collagen Youtheory', N'Lọ', 600000, 15, ''),
(N'Enat 400 (Vitamin E)', N'Hộp', 120000, 40, ''),
(N'Kem trị sẹo Dermatix', N'Tuýp', 210000, 30, ''),
(N'Natri Clorid 0.9% 500ml', N'Chai', 12000, 100, ''),
(N'Dung dịch Ringer Lactat', N'Chai', 15000, 50, ''),
(N'Oxy già 3%', N'Chai', 8000, 100, ''),
(N'Thuốc mọc tóc Minoxidil 5%', N'Chai', 250000, 20, ''),
(N'Viên ngậm trắng da', N'Hộp', 350000, 15, ''),
(N'Dầu cá hồi Úc', N'Lọ', 320000, 20, ''),
(N'Mật ong chanh đào', N'Hộp', 85000, 30, ''),
(N'Tinh dầu tràm', N'Chai', 65000, 50, ''),
(N'Cốt toái bổ', N'Gói', 120000, 10, ''),
(N'Nước hồng sâm Hàn Quốc', N'Hộp', 450000, 15, ''),
(N'Tỏi đen', N'Hộp', 250000, 20, ''),
(N'Băng thun y tế', N'Cuộn', 25000, 60, ''),
(N'Găng tay y tế Vglove', N'Hộp', 75000, 50, ''),
(N'Áo blouse trắng', N'Cái', 150000, 10, ''),
(N'Cân sức khỏe', N'Cái', 200000, 5, ''),
(N'Máy đo đường huyết', N'Cái', 450000, 10, ''),
(N'Thuốc xịt hen suyễn Ventolin', N'Chai', 110000, 30, '');
INSERT INTO Users (Username, Password, Name, Role)
VALUES
('admin', '123', N'Quản trị viên', 'Admin'),
('nv01', '123', N'Nhân viên bán hàng', 'NhanVien');
GO
INSERT INTO Customers (CustomerName, Phone, LoyaltyPoints)
VALUES
(N'Khách lẻ', '0900000001', 0),
(N'Nguyễn Văn A', '0900000002', 10);

