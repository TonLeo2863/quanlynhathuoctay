
IF DB_ID(N'PharmacyDB') IS NULL
BEGIN
    CREATE DATABASE PharmacyDB;
END
GO

USE PharmacyDB;
GO


/* =========================================================
   XOA CAC DOI TUONG NANG CAP NEU CAN CHAY LAI TOAN BO SCRIPT
========================================================= */
IF OBJECT_ID('dbo.tr_Thuoc_LuuLichSuGia', 'TR') IS NOT NULL DROP TRIGGER dbo.tr_Thuoc_LuuLichSuGia;
IF OBJECT_ID('dbo.tr_ChiTietHoaDon_CapNhatTonKhoVaDoanhThu', 'TR') IS NOT NULL DROP TRIGGER dbo.tr_ChiTietHoaDon_CapNhatTonKhoVaDoanhThu;
IF OBJECT_ID('dbo.tr_ThanhToan_TaoPhieuThu', 'TR') IS NOT NULL DROP TRIGGER dbo.tr_ThanhToan_TaoPhieuThu;
GO
IF OBJECT_ID('dbo.FK_DonThuoc_BacSi', 'F') IS NOT NULL ALTER TABLE dbo.DonThuoc DROP CONSTRAINT FK_DonThuoc_BacSi;
IF OBJECT_ID('dbo.FK_DonThuoc_CoSoKhamChuaBenh', 'F') IS NOT NULL ALTER TABLE dbo.DonThuoc DROP CONSTRAINT FK_DonThuoc_CoSoKhamChuaBenh;
GO
IF OBJECT_ID('dbo.vw_SoQuyThuChi', 'V') IS NOT NULL DROP VIEW dbo.vw_SoQuyThuChi;
IF OBJECT_ID('dbo.vw_LichSuGiaThuocMoiNhat', 'V') IS NOT NULL DROP VIEW dbo.vw_LichSuGiaThuocMoiNhat;
GO
IF OBJECT_ID('dbo.sp_TaoPhieuKiemKeKho', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_TaoPhieuKiemKeKho;
IF OBJECT_ID('dbo.sp_ChotPhieuKiemKeKho', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_ChotPhieuKiemKeKho;
IF OBJECT_ID('dbo.sp_TraHangHoanTienToanBoHoaDon', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_TraHangHoanTienToanBoHoaDon;
IF OBJECT_ID('dbo.sp_HuyHangHetHan', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_HuyHangHetHan;
IF OBJECT_ID('dbo.sp_DieuChuyenKhoTheoLo', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_DieuChuyenKhoTheoLo;
IF OBJECT_ID('dbo.sp_TaoPhieuChiChiPhi', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_TaoPhieuChiChiPhi;
IF OBJECT_ID('dbo.sp_TinhBangLuongTheoThang', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_TinhBangLuongTheoThang;
IF OBJECT_ID('dbo.sp_GhiNhatKyHeThong', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GhiNhatKyHeThong;
GO
IF OBJECT_ID('dbo.ChiTietDieuChuyenKho', 'U') IS NOT NULL DROP TABLE dbo.ChiTietDieuChuyenKho;
IF OBJECT_ID('dbo.PhieuDieuChuyenKho', 'U') IS NOT NULL DROP TABLE dbo.PhieuDieuChuyenKho;
IF OBJECT_ID('dbo.ChiTietHuyHang', 'U') IS NOT NULL DROP TABLE dbo.ChiTietHuyHang;
IF OBJECT_ID('dbo.PhieuHuyHang', 'U') IS NOT NULL DROP TABLE dbo.PhieuHuyHang;
IF OBJECT_ID('dbo.HoanTien', 'U') IS NOT NULL DROP TABLE dbo.HoanTien;
IF OBJECT_ID('dbo.ChiTietPhieuTraHang', 'U') IS NOT NULL DROP TABLE dbo.ChiTietPhieuTraHang;
IF OBJECT_ID('dbo.PhieuTraHang', 'U') IS NOT NULL DROP TABLE dbo.PhieuTraHang;
IF OBJECT_ID('dbo.ChiTietKiemKeKho', 'U') IS NOT NULL DROP TABLE dbo.ChiTietKiemKeKho;
IF OBJECT_ID('dbo.PhieuKiemKeKho', 'U') IS NOT NULL DROP TABLE dbo.PhieuKiemKeKho;
IF OBJECT_ID('dbo.BangLuong', 'U') IS NOT NULL DROP TABLE dbo.BangLuong;
IF OBJECT_ID('dbo.ChamCong', 'U') IS NOT NULL DROP TABLE dbo.ChamCong;
IF OBJECT_ID('dbo.PhieuChi', 'U') IS NOT NULL DROP TABLE dbo.PhieuChi;
IF OBJECT_ID('dbo.PhieuThu', 'U') IS NOT NULL DROP TABLE dbo.PhieuThu;
IF OBJECT_ID('dbo.ChiPhiVanHanh', 'U') IS NOT NULL DROP TABLE dbo.ChiPhiVanHanh;
IF OBJECT_ID('dbo.LichSuGiaThuoc', 'U') IS NOT NULL DROP TABLE dbo.LichSuGiaThuoc;
IF OBJECT_ID('dbo.NhatKyHeThong', 'U') IS NOT NULL DROP TABLE dbo.NhatKyHeThong;
IF OBJECT_ID('dbo.BacSi', 'U') IS NOT NULL DROP TABLE dbo.BacSi;
IF OBJECT_ID('dbo.CoSoKhamChuaBenh', 'U') IS NOT NULL DROP TABLE dbo.CoSoKhamChuaBenh;
GO

/* =========================================================
   XOA BANG CU NEU CAN CHAY LAI TOAN BO SCRIPT
========================================================= */

IF OBJECT_ID('dbo.ThanhToan', 'U') IS NOT NULL DROP TABLE dbo.ThanhToan;
IF OBJECT_ID('dbo.ChiTietDonThuoc', 'U') IS NOT NULL DROP TABLE dbo.ChiTietDonThuoc;
IF OBJECT_ID('dbo.DonThuoc', 'U') IS NOT NULL DROP TABLE dbo.DonThuoc;
IF OBJECT_ID('dbo.ChiTietHoaDon', 'U') IS NOT NULL DROP TABLE dbo.ChiTietHoaDon;
IF OBJECT_ID('dbo.HoaDonBan', 'U') IS NOT NULL DROP TABLE dbo.HoaDonBan;
IF OBJECT_ID('dbo.KhuyenMaiThuoc', 'U') IS NOT NULL DROP TABLE dbo.KhuyenMaiThuoc;
IF OBJECT_ID('dbo.KhuyenMai', 'U') IS NOT NULL DROP TABLE dbo.KhuyenMai;
IF OBJECT_ID('dbo.GiaoDichKho', 'U') IS NOT NULL DROP TABLE dbo.GiaoDichKho;
IF OBJECT_ID('dbo.TonKhoLo', 'U') IS NOT NULL DROP TABLE dbo.TonKhoLo;
IF OBJECT_ID('dbo.ChiTietPhieuNhap', 'U') IS NOT NULL DROP TABLE dbo.ChiTietPhieuNhap;
IF OBJECT_ID('dbo.PhieuNhap', 'U') IS NOT NULL DROP TABLE dbo.PhieuNhap;
IF OBJECT_ID('dbo.ThuocHoatChat', 'U') IS NOT NULL DROP TABLE dbo.ThuocHoatChat;
IF OBJECT_ID('dbo.Thuoc', 'U') IS NOT NULL DROP TABLE dbo.Thuoc;
IF OBJECT_ID('dbo.DangBaoChe', 'U') IS NOT NULL DROP TABLE dbo.DangBaoChe;
IF OBJECT_ID('dbo.DonViTinh', 'U') IS NOT NULL DROP TABLE dbo.DonViTinh;
IF OBJECT_ID('dbo.HoatChat', 'U') IS NOT NULL DROP TABLE dbo.HoatChat;
IF OBJECT_ID('dbo.NhomThuoc', 'U') IS NOT NULL DROP TABLE dbo.NhomThuoc;
IF OBJECT_ID('dbo.HangSanXuat', 'U') IS NOT NULL DROP TABLE dbo.HangSanXuat;
IF OBJECT_ID('dbo.CongNoNhaCungCap', 'U') IS NOT NULL DROP TABLE dbo.CongNoNhaCungCap;
IF OBJECT_ID('dbo.NhaCungCap', 'U') IS NOT NULL DROP TABLE dbo.NhaCungCap;
IF OBJECT_ID('dbo.KhachHang', 'U') IS NOT NULL DROP TABLE dbo.KhachHang;
IF OBJECT_ID('dbo.CaLamViec', 'U') IS NOT NULL DROP TABLE dbo.CaLamViec;
IF OBJECT_ID('dbo.TaiKhoan', 'U') IS NOT NULL DROP TABLE dbo.TaiKhoan;
IF OBJECT_ID('dbo.NhanVien', 'U') IS NOT NULL DROP TABLE dbo.NhanVien;
IF OBJECT_ID('dbo.ChucVu', 'U') IS NOT NULL DROP TABLE dbo.ChucVu;
IF OBJECT_ID('dbo.ChiNhanh', 'U') IS NOT NULL DROP TABLE dbo.ChiNhanh;
IF OBJECT_ID('dbo.VaiTroQuyen', 'U') IS NOT NULL DROP TABLE dbo.VaiTroQuyen;
IF OBJECT_ID('dbo.Quyen', 'U') IS NOT NULL DROP TABLE dbo.Quyen;
IF OBJECT_ID('dbo.VaiTro', 'U') IS NOT NULL DROP TABLE dbo.VaiTro;
IF OBJECT_ID('dbo.ButToanKeToan', 'U') IS NOT NULL DROP TABLE dbo.ButToanKeToan;
GO

/* =========================================================
   BANG 01: VAI TRO
========================================================= */
CREATE TABLE dbo.VaiTro (
    MaVaiTro INT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(255),
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/* =========================================================
   BANG 02: QUYEN
========================================================= */
CREATE TABLE dbo.Quyen (
    MaQuyen INT IDENTITY(1,1) PRIMARY KEY,
    MaChucNang VARCHAR(100) NOT NULL UNIQUE,
    TenQuyen NVARCHAR(150) NOT NULL,
    NhomChucNang NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);
GO

/* =========================================================
   BANG 03: VAI TRO - QUYEN
========================================================= */
CREATE TABLE dbo.VaiTroQuyen (
    MaVaiTro INT NOT NULL,
    MaQuyen INT NOT NULL,
    DuocXem BIT NOT NULL DEFAULT 0,
    DuocThem BIT NOT NULL DEFAULT 0,
    DuocSua BIT NOT NULL DEFAULT 0,
    DuocXoa BIT NOT NULL DEFAULT 0,
    DuocDuyet BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (MaVaiTro, MaQuyen),
    CONSTRAINT FK_VaiTroQuyen_VaiTro FOREIGN KEY (MaVaiTro) REFERENCES dbo.VaiTro(MaVaiTro),
    CONSTRAINT FK_VaiTroQuyen_Quyen FOREIGN KEY (MaQuyen) REFERENCES dbo.Quyen(MaQuyen)
);
GO

/* =========================================================
   BANG 04: CHI NHANH
========================================================= */
CREATE TABLE dbo.ChiNhanh (
    MaChiNhanh INT IDENTITY(1,1) PRIMARY KEY,
    MaSoChiNhanh VARCHAR(20) NOT NULL UNIQUE,
    TenChiNhanh NVARCHAR(200) NOT NULL,
    DiaChi NVARCHAR(255) NOT NULL,
    PhuongXa NVARCHAR(100),
    QuanHuyen NVARCHAR(100),
    TinhThanh NVARCHAR(100),
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DangHoatDong BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/* =========================================================
   BANG 05: CHUC VU
========================================================= */
CREATE TABLE dbo.ChucVu (
    MaChucVu INT IDENTITY(1,1) PRIMARY KEY,
    TenChucVu NVARCHAR(100) NOT NULL UNIQUE,
    LuongCoBan DECIMAL(18,2) NOT NULL DEFAULT 0,
    MoTa NVARCHAR(255)
);
GO

/* =========================================================
   BANG 06: NHAN VIEN
========================================================= */
CREATE TABLE dbo.NhanVien (
    MaNhanVien INT IDENTITY(1,1) PRIMARY KEY,
    MaSoNhanVien VARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nu', N'Khac')),
    NgaySinh DATE,
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DiaChi NVARCHAR(255),
    SoCanCuoc VARCHAR(20),
    NgayVaoLam DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    MaChiNhanh INT NOT NULL,
    MaChucVu INT NOT NULL,
    MaVaiTro INT NOT NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Dang lam'
        CHECK (TrangThai IN (N'Dang lam', N'Nghi viec', N'Tam nghi')),
    CONSTRAINT FK_NhanVien_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_NhanVien_ChucVu FOREIGN KEY (MaChucVu) REFERENCES dbo.ChucVu(MaChucVu),
    CONSTRAINT FK_NhanVien_VaiTro FOREIGN KEY (MaVaiTro) REFERENCES dbo.VaiTro(MaVaiTro)
);
GO

/* =========================================================
   BANG 07: TAI KHOAN DANG NHAP
========================================================= */
CREATE TABLE dbo.TaiKhoan (
    MaTaiKhoan INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT NOT NULL UNIQUE,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhauBam NVARCHAR(255) NOT NULL,
    BiKhoa BIT NOT NULL DEFAULT 0,
    LanDangNhapCuoi DATETIME2 NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

/* =========================================================
   BANG 08: CA LAM VIEC 6 TIENG
========================================================= */
CREATE TABLE dbo.CaLamViec (
    MaCaLamViec INT IDENTITY(1,1) PRIMARY KEY,
    MaChiNhanh INT NOT NULL,
    MaNhanVienMoCa INT NOT NULL,
    MaNhanVienDongCa INT NULL,
    TenCa NVARCHAR(100) NOT NULL,
    ThoiGianBatDau DATETIME2 NOT NULL,
    ThoiGianKetThucDuKien AS DATEADD(HOUR, 6, ThoiGianBatDau) PERSISTED,
    ThoiGianKetThucThucTe DATETIME2 NULL,
    TienMatDauCa DECIMAL(18,2) NOT NULL DEFAULT 0,
    TienMatCuoiCa DECIMAL(18,2) NULL,
    DoanhThuTrongCa DECIMAL(18,2) NOT NULL DEFAULT 0,
    ChenhLech DECIMAL(18,2) NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Dang mo'
        CHECK (TrangThai IN (N'Dang mo', N'Da dong', N'Huy')),
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_CaLamViec_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_CaLamViec_NhanVienMo FOREIGN KEY (MaNhanVienMoCa) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT FK_CaLamViec_NhanVienDong FOREIGN KEY (MaNhanVienDongCa) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

/* =========================================================
   BANG 09: KHACH HANG VA TICH DIEM
========================================================= */
CREATE TABLE dbo.KhachHang (
    MaKhachHang INT IDENTITY(1,1) PRIMARY KEY,
    MaSoKhachHang VARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nu', N'Khac')),
    NgaySinh DATE,
    DiaChi NVARCHAR(255),
    HangThanhVien NVARCHAR(50) NOT NULL DEFAULT N'Thuong',
    DiemTichLuy INT NOT NULL DEFAULT 0,
    TongTienDaMua DECIMAL(18,2) NOT NULL DEFAULT 0,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

/* =========================================================
   BANG 10: NHA CUNG CAP
========================================================= */
CREATE TABLE dbo.NhaCungCap (
    MaNhaCungCap INT IDENTITY(1,1) PRIMARY KEY,
    MaSoNhaCungCap VARCHAR(20) NOT NULL UNIQUE,
    TenNhaCungCap NVARCHAR(200) NOT NULL,
    MaSoThue VARCHAR(30),
    NguoiLienHe NVARCHAR(150),
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DiaChi NVARCHAR(255),
    DangHopTac BIT NOT NULL DEFAULT 1
);
GO

/* =========================================================
   BANG 11: CONG NO NHA CUNG CAP
========================================================= */
CREATE TABLE dbo.CongNoNhaCungCap (
    MaCongNo INT IDENTITY(1,1) PRIMARY KEY,
    MaNhaCungCap INT NOT NULL,
    NgayPhatSinh DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    LoaiPhatSinh NVARCHAR(50) NOT NULL
        CHECK (LoaiPhatSinh IN (N'No phai tra', N'Da thanh toan', N'Dieu chinh tang', N'Dieu chinh giam')),
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    HanThanhToan DATE NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Chua thanh toan'
        CHECK (TrangThai IN (N'Chua thanh toan', N'Da thanh toan', N'Qua han')),
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_CongNo_NhaCungCap FOREIGN KEY (MaNhaCungCap) REFERENCES dbo.NhaCungCap(MaNhaCungCap)
);
GO

/* =========================================================
   BANG 12: HANG SAN XUAT
========================================================= */
CREATE TABLE dbo.HangSanXuat (
    MaHangSanXuat INT IDENTITY(1,1) PRIMARY KEY,
    TenHangSanXuat NVARCHAR(200) NOT NULL UNIQUE,
    QuocGia NVARCHAR(100),
    MoTa NVARCHAR(255)
);
GO

/* =========================================================
   BANG 13: NHOM THUOC / NHOM SAN PHAM
========================================================= */
CREATE TABLE dbo.NhomThuoc (
    MaNhomThuoc INT IDENTITY(1,1) PRIMARY KEY,
    TenNhomThuoc NVARCHAR(150) NOT NULL UNIQUE,
    MaNhomCha INT NULL,
    MoTa NVARCHAR(255),
    CONSTRAINT FK_NhomThuoc_NhomCha FOREIGN KEY (MaNhomCha) REFERENCES dbo.NhomThuoc(MaNhomThuoc)
);
GO

/* =========================================================
   BANG 14: HOAT CHAT
========================================================= */
CREATE TABLE dbo.HoatChat (
    MaHoatChat INT IDENTITY(1,1) PRIMARY KEY,
    TenHoatChat NVARCHAR(150) NOT NULL UNIQUE,
    CongDungChung NVARCHAR(500),
    CanhBao NVARCHAR(500),
    MoTa NVARCHAR(500)
);
GO

/* =========================================================
   BANG 15: DON VI TINH
========================================================= */
CREATE TABLE dbo.DonViTinh (
    MaDonViTinh INT IDENTITY(1,1) PRIMARY KEY,
    TenDonViTinh NVARCHAR(50) NOT NULL UNIQUE,
    MoTa NVARCHAR(255)
);
GO

/* =========================================================
   BANG 16: DANG BAO CHE
========================================================= */
CREATE TABLE dbo.DangBaoChe (
    MaDangBaoChe INT IDENTITY(1,1) PRIMARY KEY,
    TenDangBaoChe NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(255)
);
GO

/* =========================================================
   BANG 17: THUOC / SAN PHAM
========================================================= */
CREATE TABLE dbo.Thuoc (
    MaThuoc INT IDENTITY(1,1) PRIMARY KEY,
    MaSoThuoc VARCHAR(30) NOT NULL UNIQUE,
    TenThuoc NVARCHAR(200) NOT NULL,
    TenNgan NVARCHAR(100),
    MaNhomThuoc INT NOT NULL,
    MaHangSanXuat INT NULL,
    MaDonViTinh INT NOT NULL,
    MaDangBaoChe INT NULL,
    HamLuong NVARCHAR(100),
    SoDangKy NVARCHAR(100),
    CanDonThuoc BIT NOT NULL DEFAULT 0,
    MaVach VARCHAR(50) NULL UNIQUE,
    MoTa NVARCHAR(1000),
    CongDung NVARCHAR(1000),
    ChongChiDinh NVARCHAR(1000),
    HuongDanSuDung NVARCHAR(1000),
    HuongDanBaoQuan NVARCHAR(500),
    GiaNhap DECIMAL(18,2) NOT NULL DEFAULT 0,
    GiaBan DECIMAL(18,2) NOT NULL DEFAULT 0,
    PhanTramVAT DECIMAL(5,2) NOT NULL DEFAULT 0,
    TonToiThieu INT NOT NULL DEFAULT 0,
    TonToiDa INT NOT NULL DEFAULT 0,
    DangKinhDoanh BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Thuoc_NhomThuoc FOREIGN KEY (MaNhomThuoc) REFERENCES dbo.NhomThuoc(MaNhomThuoc),
    CONSTRAINT FK_Thuoc_HangSanXuat FOREIGN KEY (MaHangSanXuat) REFERENCES dbo.HangSanXuat(MaHangSanXuat),
    CONSTRAINT FK_Thuoc_DonViTinh FOREIGN KEY (MaDonViTinh) REFERENCES dbo.DonViTinh(MaDonViTinh),
    CONSTRAINT FK_Thuoc_DangBaoChe FOREIGN KEY (MaDangBaoChe) REFERENCES dbo.DangBaoChe(MaDangBaoChe),
    CONSTRAINT CK_Thuoc_Gia CHECK (GiaNhap >= 0 AND GiaBan >= 0)
);
GO

/* =========================================================
   BANG 18: THUOC - HOAT CHAT
========================================================= */
CREATE TABLE dbo.ThuocHoatChat (
    MaThuoc INT NOT NULL,
    MaHoatChat INT NOT NULL,
    HamLuongHoatChat NVARCHAR(100),
    PRIMARY KEY (MaThuoc, MaHoatChat),
    CONSTRAINT FK_ThuocHoatChat_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_ThuocHoatChat_HoatChat FOREIGN KEY (MaHoatChat) REFERENCES dbo.HoatChat(MaHoatChat)
);
GO

/* =========================================================
   BANG 19: PHIEU NHAP
========================================================= */
CREATE TABLE dbo.PhieuNhap (
    MaPhieuNhap INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuNhap VARCHAR(30) NOT NULL UNIQUE,
    MaNhaCungCap INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaNhanVien INT NOT NULL,
    NgayNhap DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Da nhap'
        CHECK (TrangThai IN (N'Nhap tam', N'Da dat', N'Da nhap', N'Da huy')),
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuNhap_NhaCungCap FOREIGN KEY (MaNhaCungCap) REFERENCES dbo.NhaCungCap(MaNhaCungCap),
    CONSTRAINT FK_PhieuNhap_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuNhap_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

/* =========================================================
   BANG 20: CHI TIET PHIEU NHAP
========================================================= */
CREATE TABLE dbo.ChiTietPhieuNhap (
    MaChiTietPhieuNhap INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuNhap INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLo VARCHAR(50) NOT NULL,
    NgaySanXuat DATE NULL,
    HanSuDung DATE NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGiaNhap DECIMAL(18,2) NOT NULL CHECK (DonGiaNhap >= 0),
    TienGiam DECIMAL(18,2) NOT NULL DEFAULT 0,
    ThanhTien AS ((SoLuong * DonGiaNhap) - TienGiam) PERSISTED,
    CONSTRAINT FK_ChiTietPhieuNhap_PhieuNhap FOREIGN KEY (MaPhieuNhap) REFERENCES dbo.PhieuNhap(MaPhieuNhap),
    CONSTRAINT FK_ChiTietPhieuNhap_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);
GO

/* =========================================================
   BANG 21: TON KHO THEO LO
========================================================= */
CREATE TABLE dbo.TonKhoLo (
    MaTonKhoLo INT IDENTITY(1,1) PRIMARY KEY,
    MaThuoc INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaChiTietPhieuNhap INT NULL,
    SoLo VARCHAR(50) NOT NULL,
    HanSuDung DATE NOT NULL,
    SoLuongTon INT NOT NULL DEFAULT 0 CHECK (SoLuongTon >= 0),
    DonGiaVon DECIMAL(18,2) NOT NULL DEFAULT 0,
    NgayNhanHang DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_TonKhoLo_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_TonKhoLo_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_TonKhoLo_ChiTietPhieuNhap FOREIGN KEY (MaChiTietPhieuNhap) REFERENCES dbo.ChiTietPhieuNhap(MaChiTietPhieuNhap),
    CONSTRAINT UQ_TonKhoLo UNIQUE (MaThuoc, MaChiNhanh, SoLo, HanSuDung)
);
GO

/* =========================================================
   BANG 22: GIAO DICH KHO
========================================================= */
CREATE TABLE dbo.GiaoDichKho (
    MaGiaoDichKho INT IDENTITY(1,1) PRIMARY KEY,
    MaThuoc INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaTonKhoLo INT NULL,
    LoaiGiaoDich NVARCHAR(50) NOT NULL
        CHECK (LoaiGiaoDich IN (N'Nhap kho', N'Ban hang', N'Tra hang', N'Dieu chinh tang', N'Dieu chinh giam', N'Huy do het han')),
    SoLuongThayDoi INT NOT NULL,
    LoaiChungTu NVARCHAR(50),
    MaChungTu INT NULL,
    GhiChu NVARCHAR(500),
    MaNhanVienTao INT NOT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_GiaoDichKho_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_GiaoDichKho_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_GiaoDichKho_TonKhoLo FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    CONSTRAINT FK_GiaoDichKho_NhanVien FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

/* =========================================================
   BANG 23: KHUYEN MAI
========================================================= */
CREATE TABLE dbo.KhuyenMai (
    MaKhuyenMai INT IDENTITY(1,1) PRIMARY KEY,
    MaSoKhuyenMai VARCHAR(30) NOT NULL UNIQUE,
    TenKhuyenMai NVARCHAR(200) NOT NULL,
    LoaiKhuyenMai NVARCHAR(50) NOT NULL
        CHECK (LoaiKhuyenMai IN (N'Giam phan tram', N'Giam tien mat', N'Tang diem')),
    GiaTriGiam DECIMAL(18,2) NOT NULL DEFAULT 0,
    NgayBatDau DATETIME2 NOT NULL,
    NgayKetThuc DATETIME2 NOT NULL,
    DieuKienApDung NVARCHAR(500),
    DangApDung BIT NOT NULL DEFAULT 1
);
GO

/* =========================================================
   BANG 24: KHUYEN MAI - THUOC
========================================================= */
CREATE TABLE dbo.KhuyenMaiThuoc (
    MaKhuyenMai INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuongToiThieu INT NOT NULL DEFAULT 1,
    PRIMARY KEY (MaKhuyenMai, MaThuoc),
    CONSTRAINT FK_KhuyenMaiThuoc_KhuyenMai FOREIGN KEY (MaKhuyenMai) REFERENCES dbo.KhuyenMai(MaKhuyenMai),
    CONSTRAINT FK_KhuyenMaiThuoc_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);
GO

/* =========================================================
   BANG 25: HOA DON BAN
========================================================= */
CREATE TABLE dbo.HoaDonBan (
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaSoHoaDon VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaKhachHang INT NULL,
    MaNhanVien INT NOT NULL,
    MaCaLamViec INT NULL,
    NgayBan DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Hoan tat'
        CHECK (TrangThai IN (N'Nhap tam', N'Hoan tat', N'Da huy', N'Da tra mot phan')),
    TongTienHang DECIMAL(18,2) NOT NULL DEFAULT 0,
    TienGiamGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    TienVAT DECIMAL(18,2) NOT NULL DEFAULT 0,
    TongThanhToan DECIMAL(18,2) NOT NULL DEFAULT 0,
    DiemTichLuyNhan INT NOT NULL DEFAULT 0,
    DiemTichLuyDaDung INT NOT NULL DEFAULT 0,
    CoBaoHiem BIT NOT NULL DEFAULT 0,
    SoTheBaoHiem VARCHAR(50) NULL,
    TenNguoiDuocBaoHiem NVARCHAR(150) NULL,
    MucHuongBaoHiem DECIMAL(5,2) NULL,
    SoTienBaoHiemChiTra DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_HoaDonBan_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_HoaDonBan_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    CONSTRAINT FK_HoaDonBan_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT FK_HoaDonBan_CaLamViec FOREIGN KEY (MaCaLamViec) REFERENCES dbo.CaLamViec(MaCaLamViec)
);
GO

/* =========================================================
   BANG 26: CHI TIET HOA DON
========================================================= */
CREATE TABLE dbo.ChiTietHoaDon (
    MaChiTietHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon INT NOT NULL,
    MaThuoc INT NOT NULL,
    MaTonKhoLo INT NULL,
    MaKhuyenMai INT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGiaBan DECIMAL(18,2) NOT NULL CHECK (DonGiaBan >= 0),
    TienGiam DECIMAL(18,2) NOT NULL DEFAULT 0,
    PhanTramVAT DECIMAL(5,2) NOT NULL DEFAULT 0,
    ThanhTien AS ((SoLuong * DonGiaBan) - TienGiam) PERSISTED,
    CONSTRAINT FK_ChiTietHoaDon_HoaDonBan FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon),
    CONSTRAINT FK_ChiTietHoaDon_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_ChiTietHoaDon_TonKhoLo FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    CONSTRAINT FK_ChiTietHoaDon_KhuyenMai FOREIGN KEY (MaKhuyenMai) REFERENCES dbo.KhuyenMai(MaKhuyenMai)
);
GO

/* =========================================================
   BANG 27: DON THUOC
========================================================= */
CREATE TABLE dbo.DonThuoc (
    MaDonThuoc INT IDENTITY(1,1) PRIMARY KEY,
    MaSoDonThuoc VARCHAR(30) NOT NULL UNIQUE,
    MaKhachHang INT NULL,
    TenBacSi NVARCHAR(150),
    TenPhongKham NVARCHAR(200),
    ChanDoan NVARCHAR(500),
    NgayKeDon DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    MaHoaDon INT NULL,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_DonThuoc_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    CONSTRAINT FK_DonThuoc_HoaDonBan FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon)
);
GO

/* =========================================================
   BANG 28: CHI TIET DON THUOC
========================================================= */
CREATE TABLE dbo.ChiTietDonThuoc (
    MaChiTietDonThuoc INT IDENTITY(1,1) PRIMARY KEY,
    MaDonThuoc INT NOT NULL,
    MaThuoc INT NOT NULL,
    LieuDung NVARCHAR(200),
    TanSuatDung NVARCHAR(200),
    ThoiGianDung NVARCHAR(100),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_ChiTietDonThuoc_DonThuoc FOREIGN KEY (MaDonThuoc) REFERENCES dbo.DonThuoc(MaDonThuoc),
    CONSTRAINT FK_ChiTietDonThuoc_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);
GO

/* =========================================================
   BANG 29: THANH TOAN
========================================================= */
CREATE TABLE dbo.ThanhToan (
    MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon INT NOT NULL,
    PhuongThucThanhToan NVARCHAR(100) NOT NULL
        CHECK (PhuongThucThanhToan IN (N'Tien mat', N'Chuyen khoan', N'The ngan hang', N'Vi dien tu', N'Bao hiem')),
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    NgayThanhToan DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    MaGiaoDich VARCHAR(100),
    GhiChu NVARCHAR(255),
    CONSTRAINT FK_ThanhToan_HoaDonBan FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon)
);
GO

/* =========================================================
   BANG 30: BUT TOAN KE TOAN
========================================================= */
CREATE TABLE dbo.ButToanKeToan (
    MaButToan INT IDENTITY(1,1) PRIMARY KEY,
    MaSoButToan VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    NgayGhiSo DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LoaiButToan NVARCHAR(50) NOT NULL
        CHECK (LoaiButToan IN (N'Doanh thu', N'Gia von', N'Chi phi', N'Cong no nha cung cap', N'Thu tien', N'Hoan tien', N'Sao luu he thong')),
    TaiKhoanNo VARCHAR(20) NOT NULL,
    TaiKhoanCo VARCHAR(20) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    LoaiChungTu NVARCHAR(50),
    MaChungTu INT NULL,
    NoiDung NVARCHAR(500),
    MaNhanVienTao INT NOT NULL,
    CONSTRAINT FK_ButToanKeToan_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_ButToanKeToan_NhanVien FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO


/* =========================================================
   KHOI NANG CAP QUAN TRI DOANH NGHIEP NHA THUOC
   - Kiem ke kho
   - Tra hang / hoan tien
   - Huy hang het han
   - Dieu chuyen kho giua chi nhanh
   - Lich su gia
   - Nhat ky he thong
   - Tach bac si / co so kham chua benh
   - Thu chi, chi phi van hanh
   - Cham cong, bang luong
========================================================= */

CREATE TABLE dbo.CoSoKhamChuaBenh (
    MaCoSoKhamChuaBenh INT IDENTITY(1,1) PRIMARY KEY,
    MaSoCoSo VARCHAR(30) NOT NULL UNIQUE,
    TenCoSo NVARCHAR(250) NOT NULL,
    LoaiCoSo NVARCHAR(80) NOT NULL DEFAULT N'Phong kham'
        CHECK (LoaiCoSo IN (N'Benh vien', N'Phong kham', N'Trung tam y te', N'Khac')),
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    MaSoThue VARCHAR(30),
    DangHopTac BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.BacSi (
    MaBacSi INT IDENTITY(1,1) PRIMARY KEY,
    MaSoBacSi VARCHAR(30) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    SoChungChiHanhNghe VARCHAR(80) NULL,
    ChuyenKhoa NVARCHAR(150),
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    MaCoSoKhamChuaBenh INT NULL,
    DangHoatDong BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_BacSi_CoSoKhamChuaBenh FOREIGN KEY (MaCoSoKhamChuaBenh) REFERENCES dbo.CoSoKhamChuaBenh(MaCoSoKhamChuaBenh)
);
GO

ALTER TABLE dbo.DonThuoc ADD
    MaBacSi INT NULL,
    MaCoSoKhamChuaBenh INT NULL;
GO
ALTER TABLE dbo.DonThuoc ADD CONSTRAINT FK_DonThuoc_BacSi FOREIGN KEY (MaBacSi) REFERENCES dbo.BacSi(MaBacSi);
ALTER TABLE dbo.DonThuoc ADD CONSTRAINT FK_DonThuoc_CoSoKhamChuaBenh FOREIGN KEY (MaCoSoKhamChuaBenh) REFERENCES dbo.CoSoKhamChuaBenh(MaCoSoKhamChuaBenh);
GO

CREATE TABLE dbo.NhatKyHeThong (
    MaNhatKy BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenBang VARCHAR(100) NULL,
    LoaiHanhDong NVARCHAR(50) NOT NULL
        CHECK (LoaiHanhDong IN (N'Them', N'Sua', N'Xoa', N'Dang nhap', N'Dang xuat', N'Tu dong', N'Loi he thong')),
    MaBanGhi NVARCHAR(100) NULL,
    NoiDung NVARCHAR(1000) NOT NULL,
    GiaTriCu NVARCHAR(MAX) NULL,
    GiaTriMoi NVARCHAR(MAX) NULL,
    MaNhanVien INT NULL,
    DiaChiIP VARCHAR(50) NULL,
    ThietBi NVARCHAR(255) NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_NhatKyHeThong_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.LichSuGiaThuoc (
    MaLichSuGia BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaThuoc INT NOT NULL,
    GiaNhapCu DECIMAL(18,2) NULL,
    GiaNhapMoi DECIMAL(18,2) NULL,
    GiaBanCu DECIMAL(18,2) NULL,
    GiaBanMoi DECIMAL(18,2) NULL,
    LyDo NVARCHAR(500),
    MaNhanVienCapNhat INT NULL,
    NgayApDung DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_LichSuGiaThuoc_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_LichSuGiaThuoc_NhanVien FOREIGN KEY (MaNhanVienCapNhat) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.PhieuKiemKeKho (
    MaPhieuKiemKe INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuKiemKe VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaNhanVienTao INT NOT NULL,
    MaNhanVienDuyet INT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    NgayChot DATETIME2 NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Dang kiem ke'
        CHECK (TrangThai IN (N'Dang kiem ke', N'Da chot', N'Da huy')),
    TongSoMatHang INT NOT NULL DEFAULT 0,
    TongLechTang INT NOT NULL DEFAULT 0,
    TongLechGiam INT NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuKiemKeKho_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuKiemKeKho_NhanVienTao FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT FK_PhieuKiemKeKho_NhanVienDuyet FOREIGN KEY (MaNhanVienDuyet) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.ChiTietKiemKeKho (
    MaChiTietKiemKe INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuKiemKe INT NOT NULL,
    MaTonKhoLo INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLo VARCHAR(50) NOT NULL,
    HanSuDung DATE NOT NULL,
    SoLuongHeThong INT NOT NULL CHECK (SoLuongHeThong >= 0),
    SoLuongThucTe INT NOT NULL CHECK (SoLuongThucTe >= 0),
    ChenhLech AS (SoLuongThucTe - SoLuongHeThong) PERSISTED,
    LyDoChenhLech NVARCHAR(500),
    CONSTRAINT FK_ChiTietKiemKe_Phieu FOREIGN KEY (MaPhieuKiemKe) REFERENCES dbo.PhieuKiemKeKho(MaPhieuKiemKe),
    CONSTRAINT FK_ChiTietKiemKe_TonKhoLo FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    CONSTRAINT FK_ChiTietKiemKe_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);
GO

CREATE TABLE dbo.PhieuTraHang (
    MaPhieuTraHang INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuTraHang VARCHAR(30) NOT NULL UNIQUE,
    MaHoaDon INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaKhachHang INT NULL,
    MaNhanVienTao INT NOT NULL,
    NgayTra DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LyDoTra NVARCHAR(500) NOT NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Da tra'
        CHECK (TrangThai IN (N'Nhap tam', N'Da tra', N'Da huy')),
    TongTienHoan DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuTraHang_HoaDon FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon),
    CONSTRAINT FK_PhieuTraHang_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuTraHang_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    CONSTRAINT FK_PhieuTraHang_NhanVien FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.ChiTietPhieuTraHang (
    MaChiTietTraHang INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuTraHang INT NOT NULL,
    MaChiTietHoaDon INT NOT NULL,
    MaThuoc INT NOT NULL,
    MaTonKhoLo INT NULL,
    SoLuongTra INT NOT NULL CHECK (SoLuongTra > 0),
    DonGiaHoan DECIMAL(18,2) NOT NULL CHECK (DonGiaHoan >= 0),
    TienGiamPhanBo DECIMAL(18,2) NOT NULL DEFAULT 0,
    ThanhTienHoan AS ((SoLuongTra * DonGiaHoan) - TienGiamPhanBo) PERSISTED,
    TinhTrangHangTra NVARCHAR(50) NOT NULL DEFAULT N'Con ban duoc'
        CHECK (TinhTrangHangTra IN (N'Con ban duoc', N'Loi hong', N'Khong nhap lai kho')),
    CONSTRAINT FK_ChiTietTraHang_PhieuTra FOREIGN KEY (MaPhieuTraHang) REFERENCES dbo.PhieuTraHang(MaPhieuTraHang),
    CONSTRAINT FK_ChiTietTraHang_ChiTietHoaDon FOREIGN KEY (MaChiTietHoaDon) REFERENCES dbo.ChiTietHoaDon(MaChiTietHoaDon),
    CONSTRAINT FK_ChiTietTraHang_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_ChiTietTraHang_TonKhoLo FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo)
);
GO

CREATE TABLE dbo.HoanTien (
    MaHoanTien INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuTraHang INT NOT NULL,
    PhuongThucHoanTien NVARCHAR(100) NOT NULL
        CHECK (PhuongThucHoanTien IN (N'Tien mat', N'Chuyen khoan', N'The ngan hang', N'Vi dien tu')),
    SoTienHoan DECIMAL(18,2) NOT NULL CHECK (SoTienHoan >= 0),
    NgayHoanTien DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    MaGiaoDich VARCHAR(100),
    GhiChu NVARCHAR(255),
    CONSTRAINT FK_HoanTien_PhieuTraHang FOREIGN KEY (MaPhieuTraHang) REFERENCES dbo.PhieuTraHang(MaPhieuTraHang)
);
GO

CREATE TABLE dbo.PhieuHuyHang (
    MaPhieuHuyHang INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuHuyHang VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaNhanVienTao INT NOT NULL,
    MaNhanVienDuyet INT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    NgayDuyet DATETIME2 NULL,
    LyDoHuy NVARCHAR(500) NOT NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Da huy'
        CHECK (TrangThai IN (N'Nhap tam', N'Da huy', N'Khong duyet')),
    TongGiaTriHuy DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuHuyHang_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuHuyHang_NhanVienTao FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT FK_PhieuHuyHang_NhanVienDuyet FOREIGN KEY (MaNhanVienDuyet) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.ChiTietHuyHang (
    MaChiTietHuyHang INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuHuyHang INT NOT NULL,
    MaTonKhoLo INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLo VARCHAR(50) NOT NULL,
    HanSuDung DATE NOT NULL,
    SoLuongHuy INT NOT NULL CHECK (SoLuongHuy > 0),
    DonGiaVon DECIMAL(18,2) NOT NULL CHECK (DonGiaVon >= 0),
    ThanhTienHuy AS (SoLuongHuy * DonGiaVon) PERSISTED,
    CONSTRAINT FK_ChiTietHuyHang_PhieuHuy FOREIGN KEY (MaPhieuHuyHang) REFERENCES dbo.PhieuHuyHang(MaPhieuHuyHang),
    CONSTRAINT FK_ChiTietHuyHang_TonKhoLo FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    CONSTRAINT FK_ChiTietHuyHang_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);
GO

CREATE TABLE dbo.PhieuDieuChuyenKho (
    MaPhieuDieuChuyen INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuDieuChuyen VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanhXuat INT NOT NULL,
    MaChiNhanhNhan INT NOT NULL,
    MaNhanVienTao INT NOT NULL,
    MaNhanVienDuyet INT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    NgayDuyet DATETIME2 NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Da chuyen'
        CHECK (TrangThai IN (N'Nhap tam', N'Da chuyen', N'Da huy')),
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuDieuChuyen_ChiNhanhXuat FOREIGN KEY (MaChiNhanhXuat) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuDieuChuyen_ChiNhanhNhan FOREIGN KEY (MaChiNhanhNhan) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuDieuChuyen_NhanVienTao FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT FK_PhieuDieuChuyen_NhanVienDuyet FOREIGN KEY (MaNhanVienDuyet) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT CK_PhieuDieuChuyen_KhacChiNhanh CHECK (MaChiNhanhXuat <> MaChiNhanhNhan)
);
GO

CREATE TABLE dbo.ChiTietDieuChuyenKho (
    MaChiTietDieuChuyen INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuDieuChuyen INT NOT NULL,
    MaThuoc INT NOT NULL,
    MaTonKhoLoXuat INT NOT NULL,
    MaTonKhoLoNhan INT NULL,
    SoLo VARCHAR(50) NOT NULL,
    HanSuDung DATE NOT NULL,
    SoLuongChuyen INT NOT NULL CHECK (SoLuongChuyen > 0),
    DonGiaVon DECIMAL(18,2) NOT NULL CHECK (DonGiaVon >= 0),
    CONSTRAINT FK_ChiTietDieuChuyen_Phieu FOREIGN KEY (MaPhieuDieuChuyen) REFERENCES dbo.PhieuDieuChuyenKho(MaPhieuDieuChuyen),
    CONSTRAINT FK_ChiTietDieuChuyen_Thuoc FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    CONSTRAINT FK_ChiTietDieuChuyen_TonXuat FOREIGN KEY (MaTonKhoLoXuat) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    CONSTRAINT FK_ChiTietDieuChuyen_TonNhan FOREIGN KEY (MaTonKhoLoNhan) REFERENCES dbo.TonKhoLo(MaTonKhoLo)
);
GO

CREATE TABLE dbo.ChiPhiVanHanh (
    MaChiPhi INT IDENTITY(1,1) PRIMARY KEY,
    MaSoChiPhi VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    NhomChiPhi NVARCHAR(100) NOT NULL
        CHECK (NhomChiPhi IN (N'Tien mat bang', N'Dien nuoc', N'Internet', N'Luong', N'Marketing', N'Van phong pham', N'Bao tri', N'Khac')),
    NoiDung NVARCHAR(500) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    NgayPhatSinh DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    MaNhanVienTao INT NOT NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Cho chi'
        CHECK (TrangThai IN (N'Cho chi', N'Da chi', N'Da huy')),
    CONSTRAINT FK_ChiPhiVanHanh_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_ChiPhiVanHanh_NhanVien FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.PhieuThu (
    MaPhieuThu INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuThu VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaThanhToan INT NULL,
    NgayThu DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    NguonThu NVARCHAR(100) NOT NULL
        CHECK (NguonThu IN (N'Ban hang', N'Thu cong no', N'Thu khac')),
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    PhuongThucThu NVARCHAR(100) NOT NULL,
    MaNhanVienTao INT NOT NULL,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuThu_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuThu_ThanhToan FOREIGN KEY (MaThanhToan) REFERENCES dbo.ThanhToan(MaThanhToan),
    CONSTRAINT FK_PhieuThu_NhanVien FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.PhieuChi (
    MaPhieuChi INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuChi VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaChiPhi INT NULL,
    NgayChi DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LoaiChi NVARCHAR(100) NOT NULL
        CHECK (LoaiChi IN (N'Chi phi van hanh', N'Tra nha cung cap', N'Hoan tien', N'Chi khac')),
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    PhuongThucChi NVARCHAR(100) NOT NULL,
    MaNhanVienTao INT NOT NULL,
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_PhieuChi_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_PhieuChi_ChiPhi FOREIGN KEY (MaChiPhi) REFERENCES dbo.ChiPhiVanHanh(MaChiPhi),
    CONSTRAINT FK_PhieuChi_NhanVien FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.ChamCong (
    MaChamCong INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT NOT NULL,
    MaCaLamViec INT NULL,
    NgayLam DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    GioVao DATETIME2 NOT NULL,
    GioRa DATETIME2 NULL,
    SoGioLam AS (CASE WHEN GioRa IS NULL THEN NULL ELSE DATEDIFF(MINUTE, GioVao, GioRa) / 60.0 END) PERSISTED,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Di lam'
        CHECK (TrangThai IN (N'Di lam', N'Di tre', N'Ve som', N'Nghi phep', N'Nghi khong phep')),
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_ChamCong_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT FK_ChamCong_CaLamViec FOREIGN KEY (MaCaLamViec) REFERENCES dbo.CaLamViec(MaCaLamViec),
    CONSTRAINT UQ_ChamCong_NhanVien_Ngay UNIQUE (MaNhanVien, NgayLam, MaCaLamViec)
);
GO

CREATE TABLE dbo.BangLuong (
    MaBangLuong INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT NOT NULL,
    Thang INT NOT NULL CHECK (Thang BETWEEN 1 AND 12),
    Nam INT NOT NULL CHECK (Nam >= 2000),
    LuongCoBan DECIMAL(18,2) NOT NULL DEFAULT 0,
    TongGioLam DECIMAL(10,2) NOT NULL DEFAULT 0,
    PhuCap DECIMAL(18,2) NOT NULL DEFAULT 0,
    Thuong DECIMAL(18,2) NOT NULL DEFAULT 0,
    KhauTru DECIMAL(18,2) NOT NULL DEFAULT 0,
    LuongThucNhan DECIMAL(18,2) NOT NULL DEFAULT 0,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Nhap tam'
        CHECK (TrangThai IN (N'Nhap tam', N'Da chot', N'Da thanh toan')),
    NgayTinh DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    GhiChu NVARCHAR(500),
    CONSTRAINT FK_BangLuong_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien),
    CONSTRAINT UQ_BangLuong_NhanVien_ThangNam UNIQUE (MaNhanVien, Thang, Nam)
);
GO

/* =========================================================
   INDEX GIUP TRUY VAN NHANH HON
========================================================= */
CREATE INDEX IX_Thuoc_TenThuoc ON dbo.Thuoc(TenThuoc);
CREATE INDEX IX_Thuoc_MaNhomThuoc ON dbo.Thuoc(MaNhomThuoc);
CREATE INDEX IX_TonKhoLo_HanSuDung ON dbo.TonKhoLo(HanSuDung);
CREATE INDEX IX_TonKhoLo_ThuocChiNhanh ON dbo.TonKhoLo(MaThuoc, MaChiNhanh);
CREATE INDEX IX_HoaDonBan_NgayBan ON dbo.HoaDonBan(NgayBan);
CREATE INDEX IX_HoaDonBan_KhachHang ON dbo.HoaDonBan(MaKhachHang);
CREATE INDEX IX_GiaoDichKho_ThuocChiNhanh ON dbo.GiaoDichKho(MaThuoc, MaChiNhanh);
GO

/* =========================================================
   DU LIEU MAU: VAI TRO, QUYEN, CHI NHANH, NHAN VIEN
========================================================= */

INSERT INTO dbo.VaiTro (TenVaiTro, MoTa) VALUES
(N'Quan tri he thong', N'Quan ly toan bo he thong'),
(N'Quan ly chi nhanh', N'Quan ly nhan vien, kho va doanh thu tai chi nhanh'),
(N'Duoc si', N'Tu van thuoc, kiem tra don thuoc va ban thuoc'),
(N'Thu ngan', N'Lap hoa don va nhan thanh toan'),
(N'Ke toan', N'Quan ly thu chi, cong no va bao cao ke toan');

INSERT INTO dbo.Quyen (MaChucNang, TenQuyen, NhomChucNang, MoTa) VALUES
('THUOC_XEM', N'Xem danh sach thuoc', N'Quan ly thuoc', N'Cho phep xem thong tin thuoc'),
('THUOC_THEM', N'Them thuoc', N'Quan ly thuoc', N'Cho phep them thuoc moi'),
('THUOC_SUA', N'Sua thuoc', N'Quan ly thuoc', N'Cho phep cap nhat thong tin thuoc'),
('KHO_XEM', N'Xem ton kho', N'Quan ly kho', N'Cho phep xem ton kho theo lo'),
('KHO_NHAP', N'Nhap kho', N'Quan ly kho', N'Cho phep lap phieu nhap'),
('BANHANG_LAPHOADON', N'Lap hoa don ban hang', N'Ban hang', N'Cho phep tao hoa don'),
('DONTHUOC_XEM', N'Xem don thuoc', N'Ban thuoc theo don', N'Cho phep xem don thuoc'),
('KETOAN_XEM', N'Xem ke toan', N'Ke toan', N'Cho phep xem but toan ke toan'),
('CA_DONG', N'Dong ca lam viec', N'Ca lam viec', N'Cho phep dong ca va kich hoat sao luu'),
('SAOLUU_THUCHIEN', N'Thuc hien sao luu', N'He thong', N'Cho phep sao luu co so du lieu');

INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 1, MaQuyen, 1, 1, 1, 1, 1 FROM dbo.Quyen;

INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 2, MaQuyen, 1, 1, 1, 0, 1 FROM dbo.Quyen
WHERE MaChucNang IN ('THUOC_XEM','THUOC_SUA','KHO_XEM','KHO_NHAP','BANHANG_LAPHOADON','DONTHUOC_XEM','CA_DONG');

INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 3, MaQuyen, 1, 1, 0, 0, 0 FROM dbo.Quyen
WHERE MaChucNang IN ('THUOC_XEM','KHO_XEM','BANHANG_LAPHOADON','DONTHUOC_XEM');

INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 4, MaQuyen, 1, 1, 0, 0, 0 FROM dbo.Quyen
WHERE MaChucNang IN ('THUOC_XEM','BANHANG_LAPHOADON');

INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 5, MaQuyen, 1, 1, 1, 0, 1 FROM dbo.Quyen
WHERE MaChucNang IN ('KETOAN_XEM','SAOLUU_THUCHIEN');

INSERT INTO dbo.ChiNhanh (MaSoChiNhanh, TenChiNhanh, DiaChi, PhuongXa, QuanHuyen, TinhThanh, SoDienThoai, Email) VALUES
('CN001', N'Nha thuoc Tam An - Chi nhanh Quan 1', N'12 Nguyen Trai', N'Ben Thanh', N'Quan 1', N'TP.HCM', '02811112222', 'quan1@taman.vn'),
('CN002', N'Nha thuoc Tam An - Chi nhanh Thu Duc', N'88 Vo Van Ngan', N'Linh Chieu', N'Thu Duc', N'TP.HCM', '02833334444', 'thuduc@taman.vn'),
('CN003', N'Nha thuoc Tam An - Chi nhanh Binh Duong', N'25 Dai lo Binh Duong', N'Phu Cuong', N'Thu Dau Mot', N'Binh Duong', '02745556666', 'binhduong@taman.vn');

INSERT INTO dbo.ChucVu (TenChucVu, LuongCoBan, MoTa) VALUES
(N'Giam doc van hanh', 25000000, N'Quan ly van hanh toan he thong'),
(N'Quan ly nha thuoc', 15000000, N'Quan ly chi nhanh'),
(N'Duoc si dai hoc', 12000000, N'Tu van va kiem soat chuyen mon duoc'),
(N'Nhan vien ban hang', 8000000, N'Tu van ban hang'),
(N'Ke toan vien', 10000000, N'Theo doi ke toan va cong no');

INSERT INTO dbo.NhanVien (MaSoNhanVien, HoTen, GioiTinh, NgaySinh, SoDienThoai, Email, DiaChi, SoCanCuoc, MaChiNhanh, MaChucVu, MaVaiTro) VALUES
('NV001', N'Nguyen Minh Anh', N'Nu', '1992-04-12', '0901000001', 'minhanh@taman.vn', N'TP.HCM', '079092000001', 1, 1, 1),
('NV002', N'Tran Quoc Huy', N'Nam', '1990-10-21', '0901000002', 'quochuy@taman.vn', N'TP.HCM', '079090000002', 1, 2, 2),
('NV003', N'Le Thao Vy', N'Nu', '1997-08-15', '0901000003', 'thaovy@taman.vn', N'TP.HCM', '079097000003', 1, 3, 3),
('NV004', N'Pham Hoang Nam', N'Nam', '1999-01-09', '0901000004', 'hoangnam@taman.vn', N'TP.HCM', '079099000004', 1, 4, 4),
('NV005', N'Vo Khanh Linh', N'Nu', '1995-06-28', '0901000005', 'khanhlinh@taman.vn', N'Binh Duong', '074095000005', 3, 5, 5);

INSERT INTO dbo.TaiKhoan (MaNhanVien, TenDangNhap, MatKhauBam) VALUES
(1, 'admin', 'HASH_DEMO_ADMIN_123'),
(2, 'quanly.q1', 'HASH_DEMO_QUANLY_123'),
(3, 'duocsi.vy', 'HASH_DEMO_DUOCSI_123'),
(4, 'thungan.nam', 'HASH_DEMO_THUNGAN_123'),
(5, 'ketoan.linh', 'HASH_DEMO_KETOAN_123');

INSERT INTO dbo.CaLamViec (MaChiNhanh, MaNhanVienMoCa, TenCa, ThoiGianBatDau, TienMatDauCa, GhiChu) VALUES
(1, 4, N'Ca sang 06:00 - 12:00', DATEADD(HOUR, -1, SYSDATETIME()), 2000000, N'Ca lam demo 6 tieng');

/* =========================================================
   DU LIEU MAU: KHACH HANG, NCC, THUOC
========================================================= */

INSERT INTO dbo.KhachHang (MaSoKhachHang, HoTen, SoDienThoai, Email, GioiTinh, NgaySinh, DiaChi, HangThanhVien, DiemTichLuy, TongTienDaMua) VALUES
('KH001', N'Nguyen Van Binh', '0912000001', 'binh.nguyen@gmail.com', N'Nam', '1985-02-20', N'Quan 1, TP.HCM', N'Bac', 120, 3500000),
('KH002', N'Tran Thi Hoa', '0912000002', 'hoa.tran@gmail.com', N'Nu', '1993-11-02', N'Thu Duc, TP.HCM', N'Thuong', 45, 850000),
('KH003', N'Le Minh Quan', '0912000003', NULL, N'Nam', '2000-05-10', N'Binh Duong', N'Thuong', 0, 0);

INSERT INTO dbo.NhaCungCap (MaSoNhaCungCap, TenNhaCungCap, MaSoThue, NguoiLienHe, SoDienThoai, Email, DiaChi) VALUES
('NCC001', N'Cong ty Duoc pham An Khang', '0311111111', N'Nguyen Thanh Tung', '02870000001', 'sales@ankhangpharma.vn', N'TP.HCM'),
('NCC002', N'Cong ty TNHH Duoc pham Viet Tin', '0312222222', N'Pham Lan Anh', '02870000002', 'contact@viettinpharma.vn', N'Ha Noi'),
('NCC003', N'Nha phan phoi Y te Suc Khoe Viet', '0313333333', N'Le Quoc Bao', '02870000003', 'info@suckhoeviet.vn', N'Binh Duong');

INSERT INTO dbo.CongNoNhaCungCap (MaNhaCungCap, LoaiPhatSinh, SoTien, HanThanhToan, TrangThai, GhiChu) VALUES
(1, N'No phai tra', 19700000, DATEADD(DAY, 30, CAST(GETDATE() AS DATE)), N'Chua thanh toan', N'Cong no nhap hang dau ky'),
(2, N'No phai tra', 8500000, DATEADD(DAY, 20, CAST(GETDATE() AS DATE)), N'Chua thanh toan', N'Cong no nhap hang bo sung');

INSERT INTO dbo.HangSanXuat (TenHangSanXuat, QuocGia, MoTa) VALUES
(N'Duoc Hau Giang', N'Viet Nam', N'Doanh nghiep san xuat duoc pham pho bien tai Viet Nam'),
(N'Traphaco', N'Viet Nam', N'San xuat thuoc dong duoc va tan duoc'),
(N'Sanofi', N'Phap', N'Tap doan duoc pham quoc te'),
(N'GSK', N'Anh', N'Tap doan duoc pham va cham soc suc khoe'),
(N'Bayer', N'Duc', N'Tap doan duoc pham va khoa hoc doi song');

INSERT INTO dbo.NhomThuoc (TenNhomThuoc, MaNhomCha, MoTa) VALUES
(N'Thuoc ke don', NULL, N'Nhom thuoc can co don cua bac si'),
(N'Thuoc khong ke don', NULL, N'Nhom thuoc OTC co the ban theo tu van duoc si'),
(N'Thuc pham bao ve suc khoe', NULL, N'San pham ho tro suc khoe, khong thay the thuoc chua benh'),
(N'Cham soc ca nhan', NULL, N'San pham ve sinh, cham soc da, cham soc co the'),
(N'Thiet bi y te', NULL, N'Dung cu do va vat tu y te co ban'),
(N'Giam dau - ha sot', 2, N'Thuoc ho tro giam dau, ha sot'),
(N'Tieu hoa', 2, N'Thuoc va san pham ho tro tieu hoa'),
(N'Di ung - ho hap', 2, N'Thuoc ho tro di ung, ho, cam cum'),
(N'Vitamin va khoang chat', 3, N'Vitamin, khoang chat bo sung'),
(N'Tim mach - huyet ap', 1, N'Thuoc ke don lien quan tim mach, huyet ap');

INSERT INTO dbo.HoatChat (TenHoatChat, CongDungChung, CanhBao, MoTa) VALUES
(N'Paracetamol', N'Giam dau va ha sot', N'Tranh dung qua lieu vi co nguy co doc gan', N'Hoat chat giam dau, ha sot pho bien'),
(N'Ibuprofen', N'Giam dau, ha sot, chong viem', N'Than trong voi nguoi dau da day hoac benh than', N'Hoat chat khang viem khong steroid'),
(N'Cetirizine', N'Giam trieu chung di ung', N'Co the gay buon ngu o mot so nguoi', N'Khang histamine the he 2'),
(N'Loperamide', N'Ho tro giam tieu chay cap khong bien chung', N'Khong dung khi tieu chay co sot cao hoac phan mau neu chua hoi bac si', N'Thuoc lam giam nhu dong ruot'),
(N'Omeprazole', N'Giam tiet acid da day', N'Dung keo dai can theo doi theo huong dan chuyen mon', N'Uc che bom proton'),
(N'Amoxicillin', N'Dieu tri mot so nhiem khuan nhay cam', N'Chi dung khi co chi dinh; khong tu y dung khang sinh', N'Khang sinh nhom beta-lactam'),
(N'Metformin', N'Ho tro kiem soat duong huyet', N'Can theo doi chuc nang than va dung theo don', N'Thuoc dieu tri dai thao duong type 2'),
(N'Amlodipine', N'Dieu tri tang huyet ap va dau that nguc', N'Co the gay phu chan, chong mat; dung theo don', N'Thuoc chen kenh canxi'),
(N'Vitamin C', N'Bo sung vitamin C, ho tro suc de khang', N'Dung lieu cao keo dai co the gay kho chiu tieu hoa', N'Vitamin tan trong nuoc'),
(N'Calcium Carbonate', N'Ho tro bo sung canxi', N'Than trong voi nguoi soi than hoac tang canxi mau', N'Muoi canxi thuong dung');

INSERT INTO dbo.DonViTinh (TenDonViTinh, MoTa) VALUES
(N'Vien', N'Don vi vien nen hoac vien nang'),
(N'Vi', N'Vi thuoc'),
(N'Hop', N'Hop san pham'),
(N'Chai', N'Chai dung dich hoac siro'),
(N'Tuyp', N'Tuyp kem hoac gel'),
(N'Goi', N'Goi bot hoac com'),
(N'Cai', N'Vat tu hoac thiet bi y te');

INSERT INTO dbo.DangBaoChe (TenDangBaoChe, MoTa) VALUES
(N'Vien nen', N'Dang vien nen dung duong uong'),
(N'Vien nang', N'Dang vien nang cung hoac mem'),
(N'Siro', N'Dang dung dich uong'),
(N'Kem boi', N'Dang kem dung ngoai da'),
(N'Goi bot', N'Dang bot pha uong'),
(N'Dung dich', N'Dung dich dung uong hoac dung ngoai tuy san pham'),
(N'Thiet bi', N'San pham khong phai thuoc');

INSERT INTO dbo.Thuoc (
    MaSoThuoc, TenThuoc, TenNgan, MaNhomThuoc, MaHangSanXuat, MaDonViTinh, MaDangBaoChe,
    HamLuong, SoDangKy, CanDonThuoc, MaVach, MoTa, CongDung, ChongChiDinh,
    HuongDanSuDung, HuongDanBaoQuan, GiaNhap, GiaBan, PhanTramVAT, TonToiThieu, TonToiDa
) VALUES
('SP001', N'Paracetamol 500mg', N'Para 500', 6, 1, 1, 1, N'500mg', N'VD-DEMO-001-22', 0, '8930000000011',
 N'Thuoc giam dau, ha sot thong dung dang vien nen.',
 N'Ho tro giam dau nhe den vua va ha sot.',
 N'Khong dung cho nguoi man cam voi paracetamol hoac benh gan nang.',
 N'Uong theo huong dan tren nhan hoac theo tu van duoc si; khong tu y vuot lieu.',
 N'Bao quan noi kho mat, tranh anh sang truc tiep.', 350, 700, 0, 100, 2000),

('SP002', N'Ibuprofen 400mg', N'Ibu 400', 6, 3, 1, 1, N'400mg', N'VN-DEMO-002-22', 0, '8930000000028',
 N'Thuoc khang viem khong steroid, ho tro giam dau va ha sot.',
 N'Dung trong dau rang, dau co, dau bung kinh, sot.',
 N'Than trong voi nguoi loet da day tien trien, suy than nang, di ung NSAID.',
 N'Uong sau an, dung theo tu van chuyen mon.',
 N'Bao quan duoi 30 do C, tranh am.', 900, 1800, 0, 80, 1500),

('SP003', N'Cetirizine 10mg', N'Ceti 10', 8, 4, 1, 1, N'10mg', N'VN-DEMO-003-22', 0, '8930000000035',
 N'Thuoc khang di ung the he 2, dang vien nen.',
 N'Ho tro giam hat hoi, so mui, ngua mui, noi me day.',
 N'Khong dung neu man cam voi cetirizine.',
 N'Thuong dung 1 lan/ngay theo huong dan; co the gay buon ngu.',
 N'Bao quan noi kho rao.', 500, 1200, 0, 60, 1200),

('SP004', N'Oresol goi bu nuoc dien giai', N'Oresol', 7, 2, 6, 5, N'Goi pha 200ml', N'VD-DEMO-004-22', 0, '8930000000042',
 N'Bot pha dung dich bu nuoc va dien giai.',
 N'Ho tro bu nuoc trong tieu chay, non oi, ra mo hoi nhieu.',
 N'Khong pha sai ty le; than trong voi nguoi can han che muoi.',
 N'Pha dung luong nuoc theo huong dan tren bao bi, dung trong ngay sau khi pha.',
 N'Bao quan goi chua pha noi kho mat.', 1200, 2500, 0, 100, 2000),

('SP005', N'Loperamide 2mg', N'Loperamide', 7, 1, 1, 2, N'2mg', N'VD-DEMO-005-22', 0, '8930000000059',
 N'Thuoc ho tro giam trieu chung tieu chay cap khong bien chung.',
 N'Dung trong tieu chay cap o nguoi lon theo huong dan.',
 N'Khong dung khi tieu chay co sot cao, phan mau hoac nghi nhiem khuan nang.',
 N'Uong theo lieu khuyen cao; can bu nuoc day du.',
 N'Bao quan tranh am.', 800, 1600, 0, 40, 1000),

('SP006', N'Omeprazole 20mg', N'Ome 20', 7, 3, 1, 2, N'20mg', N'VN-DEMO-006-22', 0, '8930000000066',
 N'Thuoc giam tiet acid da day nhom uc che bom proton.',
 N'Ho tro dieu tri trao nguoc, viem loet da day ta trang.',
 N'Khong dung neu di ung voi omeprazole hoac thanh phan thuoc.',
 N'Thuong uong truoc bua an; dung theo huong dan chuyen mon.',
 N'Bao quan noi kho, tranh anh sang.', 1200, 2500, 0, 50, 1000),

('SP007', N'Amoxicillin 500mg', N'Amox 500', 1, 1, 1, 2, N'500mg', N'VD-DEMO-007-22', 1, '8930000000073',
 N'Khang sinh nhom beta-lactam, chi ban khi co don hop le.',
 N'Dieu tri mot so nhiem khuan do vi khuan nhay cam.',
 N'Khong dung cho nguoi di ung penicillin hoac beta-lactam.',
 N'Dung dung lieu, dung thoi gian theo don bac si; khong tu y ngung thuoc.',
 N'Bao quan noi kho mat.', 1500, 3000, 0, 100, 2000),

('SP008', N'Metformin 500mg', N'Metformin', 1, 2, 1, 1, N'500mg', N'VD-DEMO-008-22', 1, '8930000000080',
 N'Thuoc dieu tri dai thao duong type 2, can dung theo don.',
 N'Ho tro kiem soat duong huyet o nguoi benh dai thao duong type 2.',
 N'Khong dung trong suy than nang, nhiem toan chuyen hoa hoac di ung thuoc.',
 N'Uong trong hoac sau bua an theo chi dinh bac si.',
 N'Bao quan duoi 30 do C, tranh am.', 700, 1500, 0, 100, 2000),

('SP009', N'Amlodipine 5mg', N'Amlo 5', 10, 5, 1, 1, N'5mg', N'VN-DEMO-009-22', 1, '8930000000097',
 N'Thuoc dieu tri tang huyet ap nhom chen kenh canxi.',
 N'Dung trong dieu tri tang huyet ap hoac dau that nguc theo chi dinh.',
 N'Khong dung neu man cam voi amlodipine.',
 N'Uong hang ngay theo don; khong tu y ngung thuoc.',
 N'Bao quan noi kho mat.', 900, 2000, 0, 80, 1500),

('SP010', N'Vitamin C 500mg', N'Vit C', 9, 2, 1, 1, N'500mg', N'VD-DEMO-010-22', 0, '8930000000103',
 N'San pham bo sung vitamin C dang vien.',
 N'Ho tro bo sung vitamin C, ho tro suc de khang.',
 N'Than trong khi dung lieu cao keo dai o nguoi co tien su soi than.',
 N'Uong theo huong dan tren bao bi hoac tu van duoc si.',
 N'Bao quan noi kho mat.', 600, 1500, 0, 100, 3000),

('SP011', N'Calcium D3', N'Calcium D3', 9, 4, 3, 1, N'Calcium + Vitamin D3', N'TPBVSK-DEMO-011', 0, '8930000000110',
 N'San pham ho tro bo sung canxi va vitamin D3.',
 N'Ho tro xuong chac khoe, bo sung canxi cho nguoi co nhu cau tang canxi.',
 N'Khong dung cho nguoi tang canxi mau neu chua co tu van chuyen mon.',
 N'Dung theo huong dan tren bao bi.',
 N'Day kin nap sau khi dung, tranh am.', 45000, 85000, 8, 20, 300),

('SP012', N'Nuoc muoi sinh ly NaCl 0.9%', N'NaCl 0.9', 4, 1, 4, 6, N'0.9% 500ml', N'VD-DEMO-012-22', 0, '8930000000127',
 N'Dung dich natri clorid 0.9% dung ve sinh ngoai hoac theo huong dan.',
 N'Ho tro ve sinh mui, suc rua thong thuong tuy muc dich su dung.',
 N'Khong dung neu chai ro ri, doi mau hoac qua han.',
 N'Dung theo huong dan tren nhan.',
 N'Bao quan noi sach, tranh anh nang.', 7000, 12000, 0, 50, 500);

INSERT INTO dbo.ThuocHoatChat (MaThuoc, MaHoatChat, HamLuongHoatChat) VALUES
(1, 1, N'500mg'),
(2, 2, N'400mg'),
(3, 3, N'10mg'),
(5, 4, N'2mg'),
(6, 5, N'20mg'),
(7, 6, N'500mg'),
(8, 7, N'500mg'),
(9, 8, N'5mg'),
(10, 9, N'500mg'),
(11, 10, N'Ham luong theo cong bo san pham');

/* =========================================================
   DU LIEU MAU: NHAP HANG, TON KHO, KHUYEN MAI, BAN HANG
========================================================= */

INSERT INTO dbo.PhieuNhap (MaSoPhieuNhap, MaNhaCungCap, MaChiNhanh, MaNhanVien, TrangThai, TongTien, GhiChu) VALUES
('PN001', 1, 1, 2, N'Da nhap', 19700000, N'Nhap hang dau ky cho chi nhanh Quan 1');

INSERT INTO dbo.ChiTietPhieuNhap (MaPhieuNhap, MaThuoc, SoLo, NgaySanXuat, HanSuDung, SoLuong, DonGiaNhap, TienGiam) VALUES
(1, 1, 'L-PARA-2501', '2025-01-10', '2027-01-10', 1000, 350, 0),
(1, 2, 'L-IBU-2502', '2025-02-12', '2027-02-12', 500, 900, 0),
(1, 3, 'L-CETI-2501', '2025-01-20', '2027-01-20', 600, 500, 0),
(1, 7, 'L-AMOX-2503', '2025-03-01', '2027-03-01', 800, 1500, 0),
(1, 8, 'L-MET-2501', '2025-01-18', '2027-01-18', 1000, 700, 0),
(1, 11, 'L-CAL-2504', '2025-04-05', '2027-04-05', 100, 45000, 0),
(1, 12, 'L-NACL-2504', '2025-04-01', '2027-04-01', 300, 7000, 0);

INSERT INTO dbo.TonKhoLo (MaThuoc, MaChiNhanh, MaChiTietPhieuNhap, SoLo, HanSuDung, SoLuongTon, DonGiaVon) VALUES
(1, 1, 1, 'L-PARA-2501', '2027-01-10', 1000, 350),
(2, 1, 2, 'L-IBU-2502', '2027-02-12', 500, 900),
(3, 1, 3, 'L-CETI-2501', '2027-01-20', 600, 500),
(7, 1, 4, 'L-AMOX-2503', '2027-03-01', 800, 1500),
(8, 1, 5, 'L-MET-2501', '2027-01-18', 1000, 700),
(11, 1, 6, 'L-CAL-2504', '2027-04-05', 100, 45000),
(12, 1, 7, 'L-NACL-2504', '2027-04-01', 300, 7000);

INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao) VALUES
(1, 1, 1, N'Nhap kho', 1000, N'PhieuNhap', 1, N'Nhap lo Paracetamol dau ky', 2),
(2, 1, 2, N'Nhap kho', 500, N'PhieuNhap', 1, N'Nhap lo Ibuprofen dau ky', 2),
(3, 1, 3, N'Nhap kho', 600, N'PhieuNhap', 1, N'Nhap lo Cetirizine dau ky', 2),
(7, 1, 4, N'Nhap kho', 800, N'PhieuNhap', 1, N'Nhap lo Amoxicillin dau ky', 2),
(8, 1, 5, N'Nhap kho', 1000, N'PhieuNhap', 1, N'Nhap lo Metformin dau ky', 2),
(11, 1, 6, N'Nhap kho', 100, N'PhieuNhap', 1, N'Nhap Calcium D3 dau ky', 2),
(12, 1, 7, N'Nhap kho', 300, N'PhieuNhap', 1, N'Nhap nuoc muoi sinh ly dau ky', 2);

INSERT INTO dbo.KhuyenMai (MaSoKhuyenMai, TenKhuyenMai, LoaiKhuyenMai, GiaTriGiam, NgayBatDau, NgayKetThuc, DieuKienApDung) VALUES
('KM001', N'Giam 5 phan tram cho Vitamin va khoang chat', N'Giam phan tram', 5, DATEADD(DAY, -5, SYSDATETIME()), DATEADD(DAY, 30, SYSDATETIME()), N'Ap dung cho mot so san pham vitamin va khoang chat'),
('KM002', N'Tang diem thanh vien khi mua san pham cham soc suc khoe', N'Tang diem', 20, DATEADD(DAY, -5, SYSDATETIME()), DATEADD(DAY, 30, SYSDATETIME()), N'Ap dung cho khach hang co so dien thoai');

INSERT INTO dbo.KhuyenMaiThuoc (MaKhuyenMai, MaThuoc, SoLuongToiThieu) VALUES
(1, 10, 1),
(1, 11, 1),
(2, 11, 1);

INSERT INTO dbo.HoaDonBan (
    MaSoHoaDon, MaChiNhanh, MaKhachHang, MaNhanVien, MaCaLamViec, TrangThai,
    TongTienHang, TienGiamGia, TienVAT, TongThanhToan, DiemTichLuyNhan,
    DiemTichLuyDaDung, CoBaoHiem, SoTheBaoHiem, TenNguoiDuocBaoHiem,
    MucHuongBaoHiem, SoTienBaoHiemChiTra, GhiChu
) VALUES
('HD001', 1, 1, 4, 1, N'Hoan tat',
 194000, 4000, 6800, 196800, 19,
 0, 0, NULL, NULL, NULL, 0, N'Khach mua thuoc va san pham bo sung'),

('HD002', 1, 2, 3, 1, N'Hoan tat',
 150000, 0, 0, 30000, 3,
 0, 1, 'BHYT-DEMO-0001', N'Tran Thi Hoa', 80, 120000, N'Hoa don demo co bao hiem chi tra mot phan');

INSERT INTO dbo.ChiTietHoaDon (MaHoaDon, MaThuoc, MaTonKhoLo, MaKhuyenMai, SoLuong, DonGiaBan, TienGiam, PhanTramVAT) VALUES
(1, 1, 1, NULL, 10, 700, 0, 0),
(1, 3, 3, NULL, 10, 1200, 0, 0),
(1, 11, 6, 1, 2, 85000, 4000, 8),
(1, 12, 7, NULL, 1, 12000, 0, 0),
(2, 8, 5, NULL, 100, 1500, 0, 0);

INSERT INTO dbo.ThanhToan (MaHoaDon, PhuongThucThanhToan, SoTien, MaGiaoDich, GhiChu) VALUES
(1, N'Tien mat', 196800, NULL, N'Khach thanh toan tien mat'),
(2, N'Bao hiem', 120000, 'BHYT-DEMO-0001', N'Bao hiem chi tra demo'),
(2, N'Tien mat', 30000, NULL, N'Khach thanh toan phan con lai');

INSERT INTO dbo.DonThuoc (MaSoDonThuoc, MaKhachHang, TenBacSi, TenPhongKham, ChanDoan, MaHoaDon, GhiChu) VALUES
('DT001', 1, N'BS. Nguyen Hoang', N'Phong kham Da khoa Minh Tam', N'Nhiem khuan ho hap nhe', NULL, N'Don mau demo, can kiem tra chuyen mon khi dung that'),
('DT002', 2, N'BS. Le Khanh', N'Benh vien Demo', N'Tang duong huyet can theo doi', 2, N'Don demo co lien ket hoa don bao hiem');

INSERT INTO dbo.ChiTietDonThuoc (MaDonThuoc, MaThuoc, LieuDung, TanSuatDung, ThoiGianDung, SoLuong, GhiChu) VALUES
(1, 7, N'1 vien/lần', N'Ngay 2 lan', N'5 ngay', 10, N'Khang sinh ke don, phai dung du lieu trinh'),
(1, 1, N'1 vien khi sot hoac dau', N'Cach nhau it nhat 4-6 gio', N'Khi can', 10, N'Khong vuot qua lieu toi da khuyen cao'),
(2, 8, N'1 vien/lần', N'Ngay 2 lan', N'30 ngay', 60, N'Dung theo don bac si');

INSERT INTO dbo.ButToanKeToan (MaSoButToan, MaChiNhanh, LoaiButToan, TaiKhoanNo, TaiKhoanCo, SoTien, LoaiChungTu, MaChungTu, NoiDung, MaNhanVienTao) VALUES
('KT001', 1, N'Doanh thu', '111', '511', 196800, N'HoaDonBan', 1, N'Ghi nhan doanh thu hoa don HD001', 5),
('KT002', 1, N'Doanh thu', '111', '511', 30000, N'HoaDonBan', 2, N'Ghi nhan tien khach thanh toan hoa don HD002', 5),
('KT003', 1, N'Thu tien', '138', '511', 120000, N'HoaDonBan', 2, N'Ghi nhan khoan bao hiem chi tra hoa don HD002', 5),
('KT004', 1, N'Cong no nha cung cap', '156', '331', 19700000, N'PhieuNhap', 1, N'Ghi nhan cong no nhap hang dau ky', 5);
GO


/* =========================================================
   DU LIEU MAU MO RONG CHO KHOI NANG CAP
========================================================= */
INSERT INTO dbo.CoSoKhamChuaBenh (MaSoCoSo, TenCoSo, LoaiCoSo, DiaChi, SoDienThoai, Email) VALUES
('CS001', N'Phong kham Da khoa Minh Tam', N'Phong kham', N'45 Cach Mang Thang 8, Quan 3, TP.HCM', '02870001111', 'minhtam@demo.vn'),
('CS002', N'Benh vien Demo', N'Benh vien', N'10 Nguyen Thi Minh Khai, Quan 1, TP.HCM', '02870002222', 'benhviendemo@demo.vn');

INSERT INTO dbo.BacSi (MaSoBacSi, HoTen, SoChungChiHanhNghe, ChuyenKhoa, SoDienThoai, Email, MaCoSoKhamChuaBenh) VALUES
('BS001', N'Nguyen Hoang', 'CCHN-DEMO-001', N'Noi tong quat', '0909000001', 'bs.nguyenhoang@demo.vn', 1),
('BS002', N'Le Khanh', 'CCHN-DEMO-002', N'Noi tiet', '0909000002', 'bs.lekhanh@demo.vn', 2);

UPDATE dbo.DonThuoc
SET MaBacSi = 1, MaCoSoKhamChuaBenh = 1
WHERE MaSoDonThuoc = 'DT001';

UPDATE dbo.DonThuoc
SET MaBacSi = 2, MaCoSoKhamChuaBenh = 2
WHERE MaSoDonThuoc = 'DT002';

INSERT INTO dbo.ChiPhiVanHanh (MaSoChiPhi, MaChiNhanh, NhomChiPhi, NoiDung, SoTien, MaNhanVienTao, TrangThai) VALUES
('CP001', 1, N'Dien nuoc', N'Chi phi dien nuoc demo trong thang', 2500000, 5, N'Cho chi'),
('CP002', 1, N'Internet', N'Chi phi internet cua chi nhanh Quan 1', 500000, 5, N'Cho chi');

INSERT INTO dbo.ChamCong (MaNhanVien, MaCaLamViec, NgayLam, GioVao, GioRa, TrangThai, GhiChu) VALUES
(4, 1, CAST(GETDATE() AS DATE), DATEADD(HOUR, -5, SYSDATETIME()), SYSDATETIME(), N'Di lam', N'Cham cong demo cho thu ngan'),
(3, NULL, CAST(GETDATE() AS DATE), DATEADD(HOUR, -6, SYSDATETIME()), SYSDATETIME(), N'Di lam', N'Cham cong demo cho duoc si');
GO

/* =========================================================
   VIEW BAO CAO VA TRA CUU
========================================================= */

CREATE OR ALTER VIEW dbo.vw_DanhSachThuocBanHang AS
SELECT
    t.MaThuoc,
    t.MaSoThuoc,
    t.TenThuoc,
    t.TenNgan,
    nt.TenNhomThuoc,
    hsx.TenHangSanXuat,
    dvt.TenDonViTinh,
    dbc.TenDangBaoChe,
    t.HamLuong,
    t.CanDonThuoc,
    t.MaVach,
    t.MoTa,
    t.CongDung,
    t.GiaBan,
    t.DangKinhDoanh
FROM dbo.Thuoc t
JOIN dbo.NhomThuoc nt ON t.MaNhomThuoc = nt.MaNhomThuoc
LEFT JOIN dbo.HangSanXuat hsx ON t.MaHangSanXuat = hsx.MaHangSanXuat
JOIN dbo.DonViTinh dvt ON t.MaDonViTinh = dvt.MaDonViTinh
LEFT JOIN dbo.DangBaoChe dbc ON t.MaDangBaoChe = dbc.MaDangBaoChe
WHERE t.DangKinhDoanh = 1;
GO

CREATE OR ALTER VIEW dbo.vw_TonKhoTheoLo AS
SELECT
    t.MaThuoc,
    t.MaSoThuoc,
    t.TenThuoc,
    nt.TenNhomThuoc,
    cn.TenChiNhanh,
    tk.SoLo,
    tk.HanSuDung,
    tk.SoLuongTon,
    t.TonToiThieu,
    t.GiaBan,
    tk.DonGiaVon,
    CASE
        WHEN tk.HanSuDung < CAST(GETDATE() AS DATE) THEN N'Da het han'
        WHEN tk.HanSuDung <= DATEADD(DAY, 90, CAST(GETDATE() AS DATE)) THEN N'Sap het han'
        WHEN tk.SoLuongTon <= t.TonToiThieu THEN N'Sap het hang'
        ELSE N'Binh thuong'
    END AS TinhTrangTonKho
FROM dbo.TonKhoLo tk
JOIN dbo.Thuoc t ON tk.MaThuoc = t.MaThuoc
JOIN dbo.NhomThuoc nt ON t.MaNhomThuoc = nt.MaNhomThuoc
JOIN dbo.ChiNhanh cn ON tk.MaChiNhanh = cn.MaChiNhanh;
GO

CREATE OR ALTER VIEW dbo.vw_DoanhThuTheoNgay AS
SELECT
    CAST(hd.NgayBan AS DATE) AS NgayBan,
    hd.MaChiNhanh,
    cn.TenChiNhanh,
    COUNT(DISTINCT hd.MaHoaDon) AS TongSoHoaDon,
    SUM(hd.TongTienHang) AS TongTienHang,
    SUM(hd.TienGiamGia) AS TongTienGiam,
    SUM(hd.TienVAT) AS TongTienVAT,
    SUM(hd.SoTienBaoHiemChiTra) AS TongBaoHiemChiTra,
    SUM(hd.TongThanhToan) AS TongDoanhThuThucThu
FROM dbo.HoaDonBan hd
JOIN dbo.ChiNhanh cn ON hd.MaChiNhanh = cn.MaChiNhanh
WHERE hd.TrangThai IN (N'Hoan tat', N'Da tra mot phan')
GROUP BY CAST(hd.NgayBan AS DATE), hd.MaChiNhanh, cn.TenChiNhanh;
GO

CREATE OR ALTER VIEW dbo.vw_QuyenTaiKhoan AS
SELECT
    nv.MaNhanVien,
    nv.MaSoNhanVien,
    nv.HoTen,
    tk.TenDangNhap,
    vt.TenVaiTro,
    q.MaChucNang,
    q.TenQuyen,
    q.NhomChucNang,
    vtq.DuocXem,
    vtq.DuocThem,
    vtq.DuocSua,
    vtq.DuocXoa,
    vtq.DuocDuyet
FROM dbo.NhanVien nv
JOIN dbo.TaiKhoan tk ON nv.MaNhanVien = tk.MaNhanVien
JOIN dbo.VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro
JOIN dbo.VaiTroQuyen vtq ON vt.MaVaiTro = vtq.MaVaiTro
JOIN dbo.Quyen q ON vtq.MaQuyen = q.MaQuyen;
GO

/* =========================================================
   STORED PROCEDURE: TIM THUOC
========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_TimThuoc
    @TuKhoa NVARCHAR(200) = NULL,
    @MaNhomThuoc INT = NULL,
    @ChiLayThuocKeDon BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.MaThuoc,
        t.MaSoThuoc,
        t.TenThuoc,
        t.HamLuong,
        nt.TenNhomThuoc,
        t.CanDonThuoc,
        t.GiaBan,
        t.MoTa,
        t.CongDung
    FROM dbo.Thuoc t
    JOIN dbo.NhomThuoc nt ON t.MaNhomThuoc = nt.MaNhomThuoc
    WHERE t.DangKinhDoanh = 1
      AND (@TuKhoa IS NULL OR t.TenThuoc LIKE N'%' + @TuKhoa + N'%' OR t.MaSoThuoc LIKE '%' + CAST(@TuKhoa AS VARCHAR(200)) + '%')
      AND (@MaNhomThuoc IS NULL OR t.MaNhomThuoc = @MaNhomThuoc)
      AND (@ChiLayThuocKeDon IS NULL OR t.CanDonThuoc = @ChiLayThuocKeDon)
    ORDER BY t.TenThuoc;
END;
GO

/* =========================================================
   STORED PROCEDURE: CANH BAO TON KHO THAP
========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_CanhBaoTonKhoThap
    @MaChiNhanh INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.MaSoThuoc,
        t.TenThuoc,
        cn.TenChiNhanh,
        SUM(tk.SoLuongTon) AS TongSoLuongTon,
        t.TonToiThieu,
        t.TonToiDa
    FROM dbo.Thuoc t
    JOIN dbo.TonKhoLo tk ON t.MaThuoc = tk.MaThuoc
    JOIN dbo.ChiNhanh cn ON tk.MaChiNhanh = cn.MaChiNhanh
    WHERE (@MaChiNhanh IS NULL OR tk.MaChiNhanh = @MaChiNhanh)
    GROUP BY t.MaSoThuoc, t.TenThuoc, cn.TenChiNhanh, t.TonToiThieu, t.TonToiDa
    HAVING SUM(tk.SoLuongTon) <= t.TonToiThieu
    ORDER BY TongSoLuongTon ASC;
END;
GO

/* =========================================================
   STORED PROCEDURE: CANH BAO THUOC SAP HET HAN
========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_CanhBaoThuocSapHetHan
    @SoNgay INT = 90,
    @MaChiNhanh INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.MaSoThuoc,
        t.TenThuoc,
        cn.TenChiNhanh,
        tk.SoLo,
        tk.HanSuDung,
        tk.SoLuongTon,
        DATEDIFF(DAY, CAST(GETDATE() AS DATE), tk.HanSuDung) AS SoNgayConLai
    FROM dbo.TonKhoLo tk
    JOIN dbo.Thuoc t ON tk.MaThuoc = t.MaThuoc
    JOIN dbo.ChiNhanh cn ON tk.MaChiNhanh = cn.MaChiNhanh
    WHERE tk.SoLuongTon > 0
      AND tk.HanSuDung <= DATEADD(DAY, @SoNgay, CAST(GETDATE() AS DATE))
      AND (@MaChiNhanh IS NULL OR tk.MaChiNhanh = @MaChiNhanh)
    ORDER BY tk.HanSuDung ASC;
END;
GO

/* =========================================================
   STORED PROCEDURE: DONG CA LAM VIEC
   - Cap nhat tien mat cuoi ca.
   - Tinh doanh thu trong ca.
   - Sau khi dong ca, co the goi sp_SaoLuuCoSoDuLieu.
========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_DongCaLamViec
    @MaCaLamViec INT,
    @MaNhanVienDongCa INT,
    @TienMatCuoiCa DECIMAL(18,2),
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DoanhThuTrongCa DECIMAL(18,2);

    SELECT @DoanhThuTrongCa = ISNULL(SUM(TongThanhToan), 0)
    FROM dbo.HoaDonBan
    WHERE MaCaLamViec = @MaCaLamViec
      AND TrangThai IN (N'Hoan tat', N'Da tra mot phan');

    UPDATE dbo.CaLamViec
    SET
        MaNhanVienDongCa = @MaNhanVienDongCa,
        ThoiGianKetThucThucTe = SYSDATETIME(),
        TienMatCuoiCa = @TienMatCuoiCa,
        DoanhThuTrongCa = @DoanhThuTrongCa,
        ChenhLech = @TienMatCuoiCa - TienMatDauCa - @DoanhThuTrongCa,
        TrangThai = N'Da dong',
        GhiChu = COALESCE(@GhiChu, GhiChu)
    WHERE MaCaLamViec = @MaCaLamViec
      AND TrangThai = N'Dang mo';
END;
GO

/* =========================================================
   STORED PROCEDURE: SAO LUU CO SO DU LIEU
   - Duong dan mac dinh: C:\SQL_Backup\
   - Ten file backup co dang:
     PharmacyDB_yyyyMMdd_HHmmss.bak
========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_SaoLuuCoSoDuLieu
    @ThuMucSaoLuu NVARCHAR(260) = N'C:\SQL_Backup\'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TenFile NVARCHAR(400);
    DECLARE @LenhSQL NVARCHAR(MAX);
    DECLARE @ThoiGian VARCHAR(20);

    SET @ThoiGian = CONVERT(VARCHAR(8), GETDATE(), 112) + '_' +
                    REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', '');

    SET @TenFile = @ThuMucSaoLuu + N'PharmacyDB_' + @ThoiGian + N'.bak';

    SET @LenhSQL = N'
        BACKUP DATABASE [PharmacyDB]
        TO DISK = N''' + @TenFile + N'''
        WITH INIT, COMPRESSION, CHECKSUM, STATS = 10;
    ';

    EXEC (@LenhSQL);

    INSERT INTO dbo.ButToanKeToan
    (
        MaSoButToan, MaChiNhanh, LoaiButToan, TaiKhoanNo, TaiKhoanCo,
        SoTien, LoaiChungTu, MaChungTu, NoiDung, MaNhanVienTao
    )
    VALUES
    (
        'BK' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', ''), ' ', ''),
        1,
        N'Sao luu he thong',
        '000',
        '000',
        0,
        N'Backup',
        NULL,
        N'Da sao luu co so du lieu vao file: ' + @TenFile,
        1
    );
END;
GO

/* =========================================================
   JOB SAO LUU TU DONG MOI 6 TIENG
   LUU Y:
   - Can SQL Server Agent.
   - Neu dung SQL Server Express, SQL Server Agent thuong khong co san.
   - Can tao truoc thu muc C:\SQL_Backup\
========================================================= */

USE msdb;
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Tu dong sao luu PharmacyDB moi 6 tieng')
BEGIN
    EXEC msdb.dbo.sp_delete_job
        @job_name = N'Tu dong sao luu PharmacyDB moi 6 tieng';
END
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'Tu dong sao luu PharmacyDB moi 6 tieng',
    @enabled = 1,
    @description = N'Tu dong sao luu database PharmacyDB sau moi ca lam 6 tieng.';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Tu dong sao luu PharmacyDB moi 6 tieng',
    @step_name = N'Chay thu tuc sao luu',
    @subsystem = N'TSQL',
    @database_name = N'PharmacyDB',
    @command = N'EXEC dbo.sp_SaoLuuCoSoDuLieu @ThuMucSaoLuu = N''C:\SQL_Backup\'';';
GO

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'Lich sao luu moi 6 tieng',
    @enabled = 1,
    @freq_type = 4,
    @freq_interval = 1,
    @freq_subday_type = 8,
    @freq_subday_interval = 6,
    @active_start_time = 000000;
GO

EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'Tu dong sao luu PharmacyDB moi 6 tieng',
    @schedule_name = N'Lich sao luu moi 6 tieng';
GO

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'Tu dong sao luu PharmacyDB moi 6 tieng',
    @server_name = N'(LOCAL)';
GO

USE PharmacyDB;
GO

/* =========================================================
   CAC CAU LENH TEST NHANH
========================================================= */

-- 1. Xem danh sach thuoc ban hang
-- SELECT * FROM dbo.vw_DanhSachThuocBanHang;

-- 2. Xem ton kho theo lo va canh bao het han / sap het hang
-- SELECT * FROM dbo.vw_TonKhoTheoLo;

-- 3. Tim thuoc theo ten
-- EXEC dbo.sp_TimThuoc @TuKhoa = N'Paracetamol';

-- 4. Canh bao thuoc sap het han trong 90 ngay
-- EXEC dbo.sp_CanhBaoThuocSapHetHan @SoNgay = 90;

-- 5. Canh bao ton kho thap
-- EXEC dbo.sp_CanhBaoTonKhoThap;

-- 6. Xem doanh thu theo ngay
-- SELECT * FROM dbo.vw_DoanhThuTheoNgay;

-- 7. Xem quyen cua tung tai khoan
-- SELECT * FROM dbo.vw_QuyenTaiKhoan;

-- 8. Dong ca lam viec mau
-- EXEC dbo.sp_DongCaLamViec @MaCaLamViec = 1, @MaNhanVienDongCa = 4, @TienMatCuoiCa = 2196800, @GhiChu = N'Dong ca demo';

-- 9. Sao luu thu cong
-- EXEC dbo.sp_SaoLuuCoSoDuLieu @ThuMucSaoLuu = N'C:\SQL_Backup\';


-- 10. Tao phieu kiem ke kho tu ton kho hien tai
-- EXEC dbo.sp_TaoPhieuKiemKeKho @MaChiNhanh = 1, @MaNhanVienTao = 2, @GhiChu = N'Kiem ke dinh ky demo';

-- 11. Chot phieu kiem ke sau khi cap nhat so luong thuc te trong ChiTietKiemKeKho
-- EXEC dbo.sp_ChotPhieuKiemKeKho @MaPhieuKiemKe = 1, @MaNhanVienDuyet = 2;

-- 12. Tra hang va hoan tien toan bo hoa don
-- EXEC dbo.sp_TraHangHoanTienToanBoHoaDon @MaHoaDon = 1, @MaNhanVienTao = 4, @LyDoTra = N'Khach tra hang demo', @PhuongThucHoanTien = N'Tien mat';

-- 13. Huy hang het han theo chi nhanh
-- EXEC dbo.sp_HuyHangHetHan @MaChiNhanh = 1, @MaNhanVienTao = 2, @SoNgayQuaHan = 0, @GhiChu = N'Huy hang het han demo';

-- 14. Dieu chuyen kho giua chi nhanh theo lo
-- EXEC dbo.sp_DieuChuyenKhoTheoLo @MaTonKhoLoXuat = 1, @MaChiNhanhNhan = 2, @SoLuongChuyen = 20, @MaNhanVienTao = 2, @GhiChu = N'Dieu chuyen demo sang chi nhanh 2';

-- 15. Xem lich su gia thuoc
-- SELECT * FROM dbo.vw_LichSuGiaThuocMoiNhat;

-- 16. Tao phieu chi cho chi phi van hanh
-- EXEC dbo.sp_TaoPhieuChiChiPhi @MaChiPhi = 1, @PhuongThucChi = N'Tien mat', @MaNhanVienTao = 5, @GhiChu = N'Chi phi demo';

-- 17. Tinh bang luong theo thang hien tai
-- EXEC dbo.sp_TinhBangLuongTheoThang @Thang = MONTH(GETDATE()), @Nam = YEAR(GETDATE());

-- 18. Xem so quy thu chi
-- SELECT * FROM dbo.vw_SoQuyThuChi;

/* =========================================================
   BO SUNG SAU KHI DOI CHIEU GITHUB WPF APP
   Muc tieu:
   1) Tao cac bang tuong thich voi code hien tai tren GitHub:
      Users, Medicines, MedicineBatches, Customers, Invoices, InvoiceDetails.
   2) Hoan thien cac trigger/procedure/view da duoc khai bao DROP nhung file cu chua tao.
   3) Bo sung view/procedure danh cho Crystal Report va bai thuc hanh chuong 11.
========================================================= */

/* =========================================================
   A. BANG TUONG THICH VOI WPF APP HIEN TAI TREN GITHUB
========================================================= */
IF OBJECT_ID('dbo.InvoiceDetails', 'U') IS NOT NULL DROP TABLE dbo.InvoiceDetails;
IF OBJECT_ID('dbo.Invoices', 'U') IS NOT NULL DROP TABLE dbo.Invoices;
IF OBJECT_ID('dbo.MedicineBatches', 'U') IS NOT NULL DROP TABLE dbo.MedicineBatches;
IF OBJECT_ID('dbo.Medicines', 'U') IS NOT NULL DROP TABLE dbo.Medicines;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    EmployeeId INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Users_NhanVien FOREIGN KEY (EmployeeId) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

CREATE TABLE dbo.Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerCode VARCHAR(30) NULL UNIQUE,
    CustomerName NVARCHAR(150) NOT NULL,
    Phone VARCHAR(20) NULL,
    Email VARCHAR(150) NULL,
    Address NVARCHAR(255) NULL,
    LoyaltyPoints INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Medicines (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MedicineCode VARCHAR(30) NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Unit NVARCHAR(50) NOT NULL,
    Price DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (Price >= 0),
    Quantity INT NOT NULL DEFAULT 0 CHECK (Quantity >= 0),
    ImagePath NVARCHAR(500) NULL,
    CoreMedicineId INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Medicines_Thuoc FOREIGN KEY (CoreMedicineId) REFERENCES dbo.Thuoc(MaThuoc)
);
GO

CREATE TABLE dbo.MedicineBatches (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MedicineId INT NOT NULL,
    BatchNo VARCHAR(50) NULL,
    Quantity INT NOT NULL DEFAULT 0 CHECK (Quantity >= 0),
    ExpiryDate DATE NOT NULL,
    CostPrice DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (CostPrice >= 0),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_MedicineBatches_Medicines FOREIGN KEY (MedicineId) REFERENCES dbo.Medicines(Id)
);
GO

CREATE TABLE dbo.Invoices (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId VARCHAR(30) NOT NULL UNIQUE,
    CustomerId INT NULL,
    CreatedBy INT NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (TotalAmount >= 0),
    Note NVARCHAR(500) NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT N'Hoan tat'
        CHECK (Status IN (N'Nhap tam', N'Hoan tat', N'Da huy', N'Da tra mot phan')),
    CONSTRAINT FK_Invoices_Customers FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(Id),
    CONSTRAINT FK_Invoices_Users FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(Id)
);
GO

CREATE TABLE dbo.InvoiceDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceId INT NOT NULL,
    MedicineId INT NOT NULL,
    MedicineName NVARCHAR(200) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (UnitPrice >= 0),
    TotalPrice DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (TotalPrice >= 0),
    CONSTRAINT FK_InvoiceDetails_Invoices FOREIGN KEY (InvoiceId) REFERENCES dbo.Invoices(Id),
    CONSTRAINT FK_InvoiceDetails_Medicines FOREIGN KEY (MedicineId) REFERENCES dbo.Medicines(Id)
);
GO

CREATE INDEX IX_Medicines_Name ON dbo.Medicines(Name);
CREATE INDEX IX_MedicineBatches_Expiry ON dbo.MedicineBatches(MedicineId, ExpiryDate);
CREATE INDEX IX_Invoices_CreatedDate ON dbo.Invoices(CreatedDate);
GO

INSERT INTO dbo.Users (Username, Password, Name, Role, EmployeeId)
SELECT TenDangNhap,
       CASE TenDangNhap
            WHEN 'admin' THEN 'admin'
            WHEN 'quanly.q1' THEN '123'
            WHEN 'duocsi.vy' THEN '123'
            WHEN 'thungan.nam' THEN '123'
            WHEN 'ketoan.linh' THEN '123'
            ELSE '123'
       END AS Password,
       nv.HoTen,
       vt.TenVaiTro,
       nv.MaNhanVien
FROM dbo.TaiKhoan tk
JOIN dbo.NhanVien nv ON nv.MaNhanVien = tk.MaNhanVien
JOIN dbo.VaiTro vt ON vt.MaVaiTro = nv.MaVaiTro;
GO

INSERT INTO dbo.Customers (CustomerCode, CustomerName, Phone, Email, Address, LoyaltyPoints)
SELECT MaSoKhachHang, HoTen, SoDienThoai, Email, DiaChi, DiemTichLuy
FROM dbo.KhachHang;
GO

INSERT INTO dbo.Medicines (MedicineCode, Name, Unit, Price, Quantity, ImagePath, CoreMedicineId)
SELECT t.MaSoThuoc,
       t.TenThuoc,
       dvt.TenDonViTinh,
       t.GiaBan,
       ISNULL(SUM(tkl.SoLuongTon), 0),
       N'',
       t.MaThuoc
FROM dbo.Thuoc t
JOIN dbo.DonViTinh dvt ON dvt.MaDonViTinh = t.MaDonViTinh
LEFT JOIN dbo.TonKhoLo tkl ON tkl.MaThuoc = t.MaThuoc
GROUP BY t.MaSoThuoc, t.TenThuoc, dvt.TenDonViTinh, t.GiaBan, t.MaThuoc;
GO

INSERT INTO dbo.MedicineBatches (MedicineId, BatchNo, Quantity, ExpiryDate, CostPrice)
SELECT m.Id, tkl.SoLo, tkl.SoLuongTon, tkl.HanSuDung, tkl.DonGiaVon
FROM dbo.TonKhoLo tkl
JOIN dbo.Medicines m ON m.CoreMedicineId = tkl.MaThuoc
WHERE tkl.SoLuongTon > 0;
GO

INSERT INTO dbo.Invoices (InvoiceId, CustomerId, CreatedBy, CreatedDate, TotalAmount, Note, Status)
SELECT h.MaSoHoaDon,
       c.Id,
       u.Id,
       h.NgayBan,
       h.TongThanhToan,
       h.GhiChu,
       h.TrangThai
FROM dbo.HoaDonBan h
LEFT JOIN dbo.KhachHang kh ON kh.MaKhachHang = h.MaKhachHang
LEFT JOIN dbo.Customers c ON c.CustomerCode = kh.MaSoKhachHang
LEFT JOIN dbo.NhanVien nv ON nv.MaNhanVien = h.MaNhanVien
LEFT JOIN dbo.Users u ON u.EmployeeId = nv.MaNhanVien;
GO

INSERT INTO dbo.InvoiceDetails (InvoiceId, MedicineId, MedicineName, Quantity, UnitPrice, TotalPrice)
SELECT i.Id, m.Id, t.TenThuoc, ct.SoLuong, ct.DonGiaBan, ct.ThanhTien
FROM dbo.ChiTietHoaDon ct
JOIN dbo.HoaDonBan h ON h.MaHoaDon = ct.MaHoaDon
JOIN dbo.Invoices i ON i.InvoiceId = h.MaSoHoaDon
JOIN dbo.Thuoc t ON t.MaThuoc = ct.MaThuoc
JOIN dbo.Medicines m ON m.CoreMedicineId = t.MaThuoc;
GO

/* =========================================================
   B. TRIGGER HOAN THIEN NGHIEP VU
========================================================= */
CREATE OR ALTER TRIGGER dbo.tr_Thuoc_LuuLichSuGia
ON dbo.Thuoc
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.LichSuGiaThuoc (MaThuoc, GiaNhapCu, GiaNhapMoi, GiaBanCu, GiaBanMoi, LyDo, MaNhanVienCapNhat)
    SELECT i.MaThuoc, d.GiaNhap, i.GiaNhap, d.GiaBan, i.GiaBan,
           N'Tu dong luu khi cap nhat gia thuoc', NULL
    FROM inserted i
    JOIN deleted d ON d.MaThuoc = i.MaThuoc
    WHERE ISNULL(i.GiaNhap,0) <> ISNULL(d.GiaNhap,0)
       OR ISNULL(i.GiaBan,0) <> ISNULL(d.GiaBan,0);
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_ChiTietHoaDon_CapNhatTonKhoVaDoanhThu
ON dbo.ChiTietHoaDon
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE tkl
    SET SoLuongTon = CASE WHEN tkl.SoLuongTon >= i.SoLuong THEN tkl.SoLuongTon - i.SoLuong ELSE 0 END
    FROM dbo.TonKhoLo tkl
    JOIN inserted i ON i.MaTonKhoLo = tkl.MaTonKhoLo;

    INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
    SELECT i.MaThuoc, h.MaChiNhanh, i.MaTonKhoLo, N'Ban hang', -i.SoLuong, N'HoaDonBan', h.MaHoaDon,
           N'Tu dong tru kho khi ban hang', h.MaNhanVien
    FROM inserted i
    JOIN dbo.HoaDonBan h ON h.MaHoaDon = i.MaHoaDon;

    UPDATE h
    SET TongTienHang = x.TongTienHang,
        TienGiamGia = x.TienGiamGia,
        TienVAT = x.TienVAT,
        TongThanhToan = x.TongThanhToan
    FROM dbo.HoaDonBan h
    JOIN (
        SELECT MaHoaDon,
               SUM(SoLuong * DonGiaBan) AS TongTienHang,
               SUM(TienGiam) AS TienGiamGia,
               SUM(((SoLuong * DonGiaBan) - TienGiam) * PhanTramVAT / 100.0) AS TienVAT,
               SUM(((SoLuong * DonGiaBan) - TienGiam) + (((SoLuong * DonGiaBan) - TienGiam) * PhanTramVAT / 100.0)) AS TongThanhToan
        FROM dbo.ChiTietHoaDon
        WHERE MaHoaDon IN (SELECT DISTINCT MaHoaDon FROM inserted)
        GROUP BY MaHoaDon
    ) x ON x.MaHoaDon = h.MaHoaDon;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_ThanhToan_TaoPhieuThu
ON dbo.ThanhToan
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.PhieuThu (MaSoPhieuThu, MaChiNhanh, MaThanhToan, NguonThu, SoTien, PhuongThucThu, MaNhanVienTao, GhiChu)
    SELECT 'PT' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss') + RIGHT('0000' + CAST(i.MaThanhToan AS VARCHAR(10)), 4),
           h.MaChiNhanh,
           i.MaThanhToan,
           N'Ban hang',
           i.SoTien,
           i.PhuongThucThanhToan,
           h.MaNhanVien,
           N'Tu dong tao phieu thu tu thanh toan hoa don'
    FROM inserted i
    JOIN dbo.HoaDonBan h ON h.MaHoaDon = i.MaHoaDon;
END;
GO

/* =========================================================
   C. VIEW BAO CAO / CRYSTAL REPORT
========================================================= */
CREATE OR ALTER VIEW dbo.vw_SoQuyThuChi AS
SELECT N'Thu' AS LoaiPhieu, MaPhieuThu AS MaPhieu, MaSoPhieuThu AS MaSoPhieu, MaChiNhanh,
       NgayThu AS NgayPhatSinh, NguonThu AS Nhom, SoTien, PhuongThucThu AS PhuongThuc, MaNhanVienTao, GhiChu
FROM dbo.PhieuThu
UNION ALL
SELECT N'Chi' AS LoaiPhieu, MaPhieuChi AS MaPhieu, MaSoPhieuChi AS MaSoPhieu, MaChiNhanh,
       NgayChi AS NgayPhatSinh, LoaiChi AS Nhom, -SoTien AS SoTien, PhuongThucChi AS PhuongThuc, MaNhanVienTao, GhiChu
FROM dbo.PhieuChi;
GO

CREATE OR ALTER VIEW dbo.vw_LichSuGiaThuocMoiNhat AS
SELECT *
FROM (
    SELECT lsg.*, t.MaSoThuoc, t.TenThuoc,
           ROW_NUMBER() OVER (PARTITION BY lsg.MaThuoc ORDER BY lsg.NgayApDung DESC, lsg.MaLichSuGia DESC) AS rn
    FROM dbo.LichSuGiaThuoc lsg
    JOIN dbo.Thuoc t ON t.MaThuoc = lsg.MaThuoc
) x
WHERE rn = 1;
GO

CREATE OR ALTER VIEW dbo.vw_Crystal_HoaDonBan AS
SELECT h.MaHoaDon, h.MaSoHoaDon, h.NgayBan, cn.TenChiNhanh, kh.HoTen AS TenKhachHang,
       nv.HoTen AS TenNhanVien, h.TongTienHang, h.TienGiamGia, h.TienVAT, h.TongThanhToan,
       h.TrangThai, h.GhiChu
FROM dbo.HoaDonBan h
JOIN dbo.ChiNhanh cn ON cn.MaChiNhanh = h.MaChiNhanh
LEFT JOIN dbo.KhachHang kh ON kh.MaKhachHang = h.MaKhachHang
JOIN dbo.NhanVien nv ON nv.MaNhanVien = h.MaNhanVien;
GO

CREATE OR ALTER VIEW dbo.vw_Crystal_ChiTietHoaDon AS
SELECT h.MaHoaDon, h.MaSoHoaDon, t.MaSoThuoc, t.TenThuoc, dvt.TenDonViTinh,
       ct.SoLuong, ct.DonGiaBan, ct.TienGiam, ct.PhanTramVAT, ct.ThanhTien
FROM dbo.ChiTietHoaDon ct
JOIN dbo.HoaDonBan h ON h.MaHoaDon = ct.MaHoaDon
JOIN dbo.Thuoc t ON t.MaThuoc = ct.MaThuoc
JOIN dbo.DonViTinh dvt ON dvt.MaDonViTinh = t.MaDonViTinh;
GO

CREATE OR ALTER VIEW dbo.vw_Crystal_TonKhoCanhBao AS
SELECT cn.TenChiNhanh, t.MaSoThuoc, t.TenThuoc, dvt.TenDonViTinh,
       SUM(tkl.SoLuongTon) AS TongTon, t.TonToiThieu,
       MIN(tkl.HanSuDung) AS HanGanNhat,
       CASE WHEN SUM(tkl.SoLuongTon) <= t.TonToiThieu THEN N'Ton thap'
            WHEN MIN(tkl.HanSuDung) <= DATEADD(DAY, 60, CAST(GETDATE() AS DATE)) THEN N'Sap het han'
            ELSE N'Binh thuong' END AS CanhBao
FROM dbo.TonKhoLo tkl
JOIN dbo.Thuoc t ON t.MaThuoc = tkl.MaThuoc
JOIN dbo.DonViTinh dvt ON dvt.MaDonViTinh = t.MaDonViTinh
JOIN dbo.ChiNhanh cn ON cn.MaChiNhanh = tkl.MaChiNhanh
GROUP BY cn.TenChiNhanh, t.MaSoThuoc, t.TenThuoc, dvt.TenDonViTinh, t.TonToiThieu;
GO

CREATE OR ALTER VIEW dbo.vw_Crystal_DoanhThuTheoNgay AS
SELECT CAST(h.NgayBan AS DATE) AS NgayBan, cn.TenChiNhanh,
       COUNT(DISTINCT h.MaHoaDon) AS SoHoaDon,
       SUM(h.TongThanhToan) AS DoanhThu,
       SUM(ISNULL(h.SoTienBaoHiemChiTra,0)) AS BaoHiemChiTra
FROM dbo.HoaDonBan h
JOIN dbo.ChiNhanh cn ON cn.MaChiNhanh = h.MaChiNhanh
WHERE h.TrangThai IN (N'Hoan tat', N'Da tra mot phan')
GROUP BY CAST(h.NgayBan AS DATE), cn.TenChiNhanh;
GO

/* =========================================================
   D. PROCEDURE NGHIEP VU CON THIEU
========================================================= */
CREATE OR ALTER PROCEDURE dbo.sp_GhiNhatKyHeThong
    @TenBang VARCHAR(100) = NULL,
    @LoaiHanhDong NVARCHAR(50),
    @MaBanGhi NVARCHAR(100) = NULL,
    @NoiDung NVARCHAR(1000),
    @GiaTriCu NVARCHAR(MAX) = NULL,
    @GiaTriMoi NVARCHAR(MAX) = NULL,
    @MaNhanVien INT = NULL,
    @DiaChiIP VARCHAR(50) = NULL,
    @ThietBi NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.NhatKyHeThong (TenBang, LoaiHanhDong, MaBanGhi, NoiDung, GiaTriCu, GiaTriMoi, MaNhanVien, DiaChiIP, ThietBi)
    VALUES (@TenBang, @LoaiHanhDong, @MaBanGhi, @NoiDung, @GiaTriCu, @GiaTriMoi, @MaNhanVien, @DiaChiIP, @ThietBi);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_TaoPhieuKiemKeKho
    @MaChiNhanh INT,
    @MaNhanVienTao INT,
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaPhieuKiemKe INT;
    INSERT INTO dbo.PhieuKiemKeKho (MaSoPhieuKiemKe, MaChiNhanh, MaNhanVienTao, GhiChu)
    VALUES ('KK' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaChiNhanh, @MaNhanVienTao, @GhiChu);
    SET @MaPhieuKiemKe = SCOPE_IDENTITY();

    INSERT INTO dbo.ChiTietKiemKeKho (MaPhieuKiemKe, MaTonKhoLo, MaThuoc, SoLo, HanSuDung, SoLuongHeThong, SoLuongThucTe)
    SELECT @MaPhieuKiemKe, MaTonKhoLo, MaThuoc, SoLo, HanSuDung, SoLuongTon, SoLuongTon
    FROM dbo.TonKhoLo
    WHERE MaChiNhanh = @MaChiNhanh;

    UPDATE dbo.PhieuKiemKeKho
    SET TongSoMatHang = (SELECT COUNT(*) FROM dbo.ChiTietKiemKeKho WHERE MaPhieuKiemKe = @MaPhieuKiemKe)
    WHERE MaPhieuKiemKe = @MaPhieuKiemKe;

    SELECT @MaPhieuKiemKe AS MaPhieuKiemKe;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ChotPhieuKiemKeKho
    @MaPhieuKiemKe INT,
    @MaNhanVienDuyet INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    BEGIN TRY
        UPDATE tkl
        SET SoLuongTon = ct.SoLuongThucTe
        FROM dbo.TonKhoLo tkl
        JOIN dbo.ChiTietKiemKeKho ct ON ct.MaTonKhoLo = tkl.MaTonKhoLo
        WHERE ct.MaPhieuKiemKe = @MaPhieuKiemKe;

        INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
        SELECT ct.MaThuoc, pk.MaChiNhanh, ct.MaTonKhoLo,
               CASE WHEN ct.ChenhLech >= 0 THEN N'Dieu chinh tang' ELSE N'Dieu chinh giam' END,
               ct.ChenhLech, N'KiemKeKho', pk.MaPhieuKiemKe, ISNULL(ct.LyDoChenhLech, N'Chot kiem ke'), @MaNhanVienDuyet
        FROM dbo.ChiTietKiemKeKho ct
        JOIN dbo.PhieuKiemKeKho pk ON pk.MaPhieuKiemKe = ct.MaPhieuKiemKe
        WHERE ct.MaPhieuKiemKe = @MaPhieuKiemKe AND ct.ChenhLech <> 0;

        UPDATE dbo.PhieuKiemKeKho
        SET TrangThai = N'Da chot', NgayChot = SYSDATETIME(), MaNhanVienDuyet = @MaNhanVienDuyet,
            TongLechTang = (SELECT ISNULL(SUM(CASE WHEN ChenhLech > 0 THEN ChenhLech ELSE 0 END),0) FROM dbo.ChiTietKiemKeKho WHERE MaPhieuKiemKe = @MaPhieuKiemKe),
            TongLechGiam = (SELECT ISNULL(SUM(CASE WHEN ChenhLech < 0 THEN ABS(ChenhLech) ELSE 0 END),0) FROM dbo.ChiTietKiemKeKho WHERE MaPhieuKiemKe = @MaPhieuKiemKe)
        WHERE MaPhieuKiemKe = @MaPhieuKiemKe;
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_TraHangHoanTienToanBoHoaDon
    @MaHoaDon INT,
    @MaNhanVienTao INT,
    @LyDoTra NVARCHAR(500),
    @PhuongThucHoanTien NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaPhieuTraHang INT, @TongHoan DECIMAL(18,2), @MaChiNhanh INT, @MaKhachHang INT;
    BEGIN TRAN;
    BEGIN TRY
        SELECT @MaChiNhanh = MaChiNhanh, @MaKhachHang = MaKhachHang, @TongHoan = TongThanhToan
        FROM dbo.HoaDonBan WHERE MaHoaDon = @MaHoaDon;

        INSERT INTO dbo.PhieuTraHang (MaSoPhieuTraHang, MaHoaDon, MaChiNhanh, MaKhachHang, MaNhanVienTao, LyDoTra, TongTienHoan)
        VALUES ('TH' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaHoaDon, @MaChiNhanh, @MaKhachHang, @MaNhanVienTao, @LyDoTra, @TongHoan);
        SET @MaPhieuTraHang = SCOPE_IDENTITY();

        INSERT INTO dbo.ChiTietPhieuTraHang (MaPhieuTraHang, MaChiTietHoaDon, MaThuoc, MaTonKhoLo, SoLuongTra, DonGiaHoan, TienGiamPhanBo)
        SELECT @MaPhieuTraHang, MaChiTietHoaDon, MaThuoc, MaTonKhoLo, SoLuong, DonGiaBan, TienGiam
        FROM dbo.ChiTietHoaDon WHERE MaHoaDon = @MaHoaDon;

        UPDATE tkl
        SET SoLuongTon = tkl.SoLuongTon + ct.SoLuongTra
        FROM dbo.TonKhoLo tkl
        JOIN dbo.ChiTietPhieuTraHang ct ON ct.MaTonKhoLo = tkl.MaTonKhoLo
        WHERE ct.MaPhieuTraHang = @MaPhieuTraHang AND ct.TinhTrangHangTra = N'Con ban duoc';

        INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
        SELECT MaThuoc, @MaChiNhanh, MaTonKhoLo, N'Tra hang', SoLuongTra, N'PhieuTraHang', @MaPhieuTraHang, @LyDoTra, @MaNhanVienTao
        FROM dbo.ChiTietPhieuTraHang WHERE MaPhieuTraHang = @MaPhieuTraHang;

        INSERT INTO dbo.HoanTien (MaPhieuTraHang, PhuongThucHoanTien, SoTienHoan, GhiChu)
        VALUES (@MaPhieuTraHang, @PhuongThucHoanTien, @TongHoan, N'Hoan tien toan bo hoa don');

        INSERT INTO dbo.PhieuChi (MaSoPhieuChi, MaChiNhanh, LoaiChi, SoTien, PhuongThucChi, MaNhanVienTao, GhiChu)
        VALUES ('PC' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaChiNhanh, N'Hoan tien', @TongHoan, @PhuongThucHoanTien, @MaNhanVienTao, @LyDoTra);

        UPDATE dbo.HoaDonBan SET TrangThai = N'Da tra mot phan' WHERE MaHoaDon = @MaHoaDon;
        COMMIT;
        SELECT @MaPhieuTraHang AS MaPhieuTraHang;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_HuyHangHetHan
    @MaChiNhanh INT,
    @MaNhanVienTao INT,
    @SoNgayQuaHan INT = 0,
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaPhieuHuyHang INT;
    BEGIN TRAN;
    BEGIN TRY
        INSERT INTO dbo.PhieuHuyHang (MaSoPhieuHuyHang, MaChiNhanh, MaNhanVienTao, LyDoHuy, GhiChu)
        VALUES ('HH' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaChiNhanh, @MaNhanVienTao, N'Huy hang het han', @GhiChu);
        SET @MaPhieuHuyHang = SCOPE_IDENTITY();

        INSERT INTO dbo.ChiTietHuyHang (MaPhieuHuyHang, MaTonKhoLo, MaThuoc, SoLo, HanSuDung, SoLuongHuy, DonGiaVon)
        SELECT @MaPhieuHuyHang, MaTonKhoLo, MaThuoc, SoLo, HanSuDung, SoLuongTon, DonGiaVon
        FROM dbo.TonKhoLo
        WHERE MaChiNhanh = @MaChiNhanh
          AND HanSuDung <= DATEADD(DAY, -@SoNgayQuaHan, CAST(GETDATE() AS DATE))
          AND SoLuongTon > 0;

        UPDATE tkl
        SET SoLuongTon = 0
        FROM dbo.TonKhoLo tkl
        JOIN dbo.ChiTietHuyHang ct ON ct.MaTonKhoLo = tkl.MaTonKhoLo
        WHERE ct.MaPhieuHuyHang = @MaPhieuHuyHang;

        INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
        SELECT MaThuoc, @MaChiNhanh, MaTonKhoLo, N'Huy do het han', -SoLuongHuy, N'PhieuHuyHang', @MaPhieuHuyHang, @GhiChu, @MaNhanVienTao
        FROM dbo.ChiTietHuyHang WHERE MaPhieuHuyHang = @MaPhieuHuyHang;

        UPDATE dbo.PhieuHuyHang
        SET TongGiaTriHuy = (SELECT ISNULL(SUM(ThanhTienHuy),0) FROM dbo.ChiTietHuyHang WHERE MaPhieuHuyHang = @MaPhieuHuyHang)
        WHERE MaPhieuHuyHang = @MaPhieuHuyHang;
        COMMIT;
        SELECT @MaPhieuHuyHang AS MaPhieuHuyHang;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_DieuChuyenKhoTheoLo
    @MaTonKhoLoXuat INT,
    @MaChiNhanhNhan INT,
    @SoLuongChuyen INT,
    @MaNhanVienTao INT,
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaPhieuDieuChuyen INT, @MaThuoc INT, @MaChiNhanhXuat INT, @SoLo VARCHAR(50), @HanSuDung DATE, @DonGiaVon DECIMAL(18,2), @MaTonKhoLoNhan INT;
    BEGIN TRAN;
    BEGIN TRY
        SELECT @MaThuoc = MaThuoc, @MaChiNhanhXuat = MaChiNhanh, @SoLo = SoLo, @HanSuDung = HanSuDung, @DonGiaVon = DonGiaVon
        FROM dbo.TonKhoLo
        WHERE MaTonKhoLo = @MaTonKhoLoXuat AND SoLuongTon >= @SoLuongChuyen;

        IF @MaThuoc IS NULL THROW 50001, N'Khong du ton kho de dieu chuyen.', 1;
        IF @MaChiNhanhXuat = @MaChiNhanhNhan THROW 50002, N'Chi nhanh xuat va nhan phai khac nhau.', 1;

        INSERT INTO dbo.PhieuDieuChuyenKho (MaSoPhieuDieuChuyen, MaChiNhanhXuat, MaChiNhanhNhan, MaNhanVienTao, GhiChu)
        VALUES ('DC' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaChiNhanhXuat, @MaChiNhanhNhan, @MaNhanVienTao, @GhiChu);
        SET @MaPhieuDieuChuyen = SCOPE_IDENTITY();

        UPDATE dbo.TonKhoLo SET SoLuongTon = SoLuongTon - @SoLuongChuyen WHERE MaTonKhoLo = @MaTonKhoLoXuat;

        SELECT @MaTonKhoLoNhan = MaTonKhoLo
        FROM dbo.TonKhoLo
        WHERE MaThuoc = @MaThuoc AND MaChiNhanh = @MaChiNhanhNhan AND SoLo = @SoLo AND HanSuDung = @HanSuDung;

        IF @MaTonKhoLoNhan IS NULL
        BEGIN
            INSERT INTO dbo.TonKhoLo (MaThuoc, MaChiNhanh, SoLo, HanSuDung, SoLuongTon, DonGiaVon)
            VALUES (@MaThuoc, @MaChiNhanhNhan, @SoLo, @HanSuDung, @SoLuongChuyen, @DonGiaVon);
            SET @MaTonKhoLoNhan = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE dbo.TonKhoLo SET SoLuongTon = SoLuongTon + @SoLuongChuyen WHERE MaTonKhoLo = @MaTonKhoLoNhan;
        END

        INSERT INTO dbo.ChiTietDieuChuyenKho (MaPhieuDieuChuyen, MaThuoc, MaTonKhoLoXuat, MaTonKhoLoNhan, SoLo, HanSuDung, SoLuongChuyen, DonGiaVon)
        VALUES (@MaPhieuDieuChuyen, @MaThuoc, @MaTonKhoLoXuat, @MaTonKhoLoNhan, @SoLo, @HanSuDung, @SoLuongChuyen, @DonGiaVon);

        INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
        VALUES (@MaThuoc, @MaChiNhanhXuat, @MaTonKhoLoXuat, N'Dieu chinh giam', -@SoLuongChuyen, N'PhieuDieuChuyenKho', @MaPhieuDieuChuyen, @GhiChu, @MaNhanVienTao),
               (@MaThuoc, @MaChiNhanhNhan, @MaTonKhoLoNhan, N'Dieu chinh tang', @SoLuongChuyen, N'PhieuDieuChuyenKho', @MaPhieuDieuChuyen, @GhiChu, @MaNhanVienTao);
        COMMIT;
        SELECT @MaPhieuDieuChuyen AS MaPhieuDieuChuyen;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_TaoPhieuChiChiPhi
    @MaChiPhi INT,
    @PhuongThucChi NVARCHAR(100),
    @MaNhanVienTao INT,
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaChiNhanh INT, @SoTien DECIMAL(18,2);
    SELECT @MaChiNhanh = MaChiNhanh, @SoTien = SoTien FROM dbo.ChiPhiVanHanh WHERE MaChiPhi = @MaChiPhi;
    IF @MaChiNhanh IS NULL THROW 50003, N'Chi phi van hanh khong ton tai.', 1;

    INSERT INTO dbo.PhieuChi (MaSoPhieuChi, MaChiNhanh, MaChiPhi, LoaiChi, SoTien, PhuongThucChi, MaNhanVienTao, GhiChu)
    VALUES ('PC' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaChiNhanh, @MaChiPhi, N'Chi phi van hanh', @SoTien, @PhuongThucChi, @MaNhanVienTao, @GhiChu);

    UPDATE dbo.ChiPhiVanHanh SET TrangThai = N'Da chi' WHERE MaChiPhi = @MaChiPhi;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_TinhBangLuongTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SET NOCOUNT ON;
    MERGE dbo.BangLuong AS target
    USING (
        SELECT nv.MaNhanVien, cv.LuongCoBan, ISNULL(SUM(cc.SoGioLam),0) AS TongGioLam
        FROM dbo.NhanVien nv
        JOIN dbo.ChucVu cv ON cv.MaChucVu = nv.MaChucVu
        LEFT JOIN dbo.ChamCong cc ON cc.MaNhanVien = nv.MaNhanVien AND MONTH(cc.NgayLam) = @Thang AND YEAR(cc.NgayLam) = @Nam
        WHERE nv.TrangThai = N'Dang lam'
        GROUP BY nv.MaNhanVien, cv.LuongCoBan
    ) AS src
    ON target.MaNhanVien = src.MaNhanVien AND target.Thang = @Thang AND target.Nam = @Nam
    WHEN MATCHED THEN
        UPDATE SET LuongCoBan = src.LuongCoBan, TongGioLam = src.TongGioLam,
                   LuongThucNhan = src.LuongCoBan + target.PhuCap + target.Thuong - target.KhauTru,
                   NgayTinh = SYSDATETIME()
    WHEN NOT MATCHED THEN
        INSERT (MaNhanVien, Thang, Nam, LuongCoBan, TongGioLam, LuongThucNhan)
        VALUES (src.MaNhanVien, @Thang, @Nam, src.LuongCoBan, src.TongGioLam, src.LuongCoBan);
END;
GO

/* =========================================================
   E. PROCEDURE CHO CRYSTAL REPORT / CHUONG 11
========================================================= */
CREATE OR ALTER PROCEDURE dbo.sp_RPT_HoaDonBan
    @MaHoaDon INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.vw_Crystal_HoaDonBan WHERE MaHoaDon = @MaHoaDon;
    SELECT * FROM dbo.vw_Crystal_ChiTietHoaDon WHERE MaHoaDon = @MaHoaDon;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_RPT_DoanhThuTheoNgay
    @TuNgay DATE,
    @DenNgay DATE,
    @MaChiNhanh INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CAST(h.NgayBan AS DATE) AS NgayBan, cn.TenChiNhanh,
           COUNT(DISTINCT h.MaHoaDon) AS SoHoaDon,
           SUM(h.TongThanhToan) AS DoanhThu
    FROM dbo.HoaDonBan h
    JOIN dbo.ChiNhanh cn ON cn.MaChiNhanh = h.MaChiNhanh
    WHERE CAST(h.NgayBan AS DATE) BETWEEN @TuNgay AND @DenNgay
      AND (@MaChiNhanh IS NULL OR h.MaChiNhanh = @MaChiNhanh)
      AND h.TrangThai IN (N'Hoan tat', N'Da tra mot phan')
    GROUP BY CAST(h.NgayBan AS DATE), cn.TenChiNhanh
    ORDER BY NgayBan, TenChiNhanh;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_RPT_TonKhoCanhBao
    @MaChiNhanh INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM dbo.vw_Crystal_TonKhoCanhBao
    WHERE (@MaChiNhanh IS NULL OR TenChiNhanh IN (SELECT TenChiNhanh FROM dbo.ChiNhanh WHERE MaChiNhanh = @MaChiNhanh))
      AND CanhBao <> N'Binh thuong'
    ORDER BY CanhBao, HanGanNhat;
END;
GO

/* =========================================================
   F. DU LIEU MAU BO SUNG CHO CHAM CONG, CHI PHI, REPORT
========================================================= */
IF NOT EXISTS (SELECT 1 FROM dbo.ChamCong)
BEGIN
    INSERT INTO dbo.ChamCong (MaNhanVien, MaCaLamViec, GioVao, GioRa, TrangThai, GhiChu)
    VALUES (4, 1, DATEADD(HOUR, -5, SYSDATETIME()), DATEADD(HOUR, -1, SYSDATETIME()), N'Di lam', N'Du lieu mau tinh luong');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.ChiPhiVanHanh)
BEGIN
    INSERT INTO dbo.ChiPhiVanHanh (MaSoChiPhi, MaChiNhanh, NhomChiPhi, NoiDung, SoTien, MaNhanVienTao, TrangThai)
    VALUES ('CP001', 1, N'Dien nuoc', N'Tien dien nuoc chi nhanh Quan 1', 1500000, 5, N'Cho chi');
END
GO

EXEC dbo.sp_GhiNhatKyHeThong
    @TenBang = 'Database',
    @LoaiHanhDong = N'Tu dong',
    @NoiDung = N'Hoan tat bo sung SQL tuong thich GitHub WPF, nghiep vu quan tri nha thuoc, Crystal Report va chuong 11.',
    @MaNhanVien = 1;
GO
