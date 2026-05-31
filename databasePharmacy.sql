/* =========================================================
   PharmacyDB_Full_Gon.sql
   Ban SQL da tinh gon nhung van giu cac chuc nang chinh:
   - Phan quyen / tai khoan / nhan vien / chi nhanh
   - Thuoc, danh muc, hoat chat, nha cung cap
   - Nhap kho, ton kho theo lo, giao dich kho
   - Ban hang, hoa don, thanh toan, don thuoc
   - Kiem ke, tra hang/hoan tien, huy hang het han
   - Dieu chuyen kho, lich su gia, nhat ky he thong
   - Thu/chi, chi phi van hanh, cham cong, bang luong
   - View/procedure/trigger can thiet cho bao cao va tu dong hoa
========================================================= */

IF DB_ID(N'PharmacyDB') IS NULL
    CREATE DATABASE PharmacyDB;
GO
USE PharmacyDB;
GO

/* =========================================================
   0. XOA DOI TUONG CU DE CHAY LAI SCRIPT
========================================================= */
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + N'.' + QUOTENAME(OBJECT_NAME(parent_object_id)) +
               N' DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.foreign_keys;
EXEC sp_executesql @sql;
GO

DROP TABLE IF EXISTS dbo.BangLuong, dbo.ChamCong, dbo.PhieuChi, dbo.PhieuThu, dbo.ChiPhiVanHanh;
DROP TABLE IF EXISTS dbo.ChiTietDieuChuyenKho, dbo.PhieuDieuChuyenKho;
DROP TABLE IF EXISTS dbo.ChiTietHuyHang, dbo.PhieuHuyHang;
DROP TABLE IF EXISTS dbo.HoanTien, dbo.ChiTietPhieuTraHang, dbo.PhieuTraHang;
DROP TABLE IF EXISTS dbo.ChiTietKiemKeKho, dbo.PhieuKiemKeKho;
DROP TABLE IF EXISTS dbo.LichSuGiaThuoc, dbo.NhatKyHeThong;
DROP TABLE IF EXISTS dbo.ThanhToan, dbo.ChiTietDonThuoc, dbo.DonThuoc, dbo.ChiTietHoaDon, dbo.HoaDonBan;
DROP TABLE IF EXISTS dbo.KhuyenMaiThuoc, dbo.KhuyenMai, dbo.GiaoDichKho, dbo.TonKhoLo, dbo.ChiTietPhieuNhap, dbo.PhieuNhap;
DROP TABLE IF EXISTS dbo.ThuocHoatChat, dbo.Thuoc, dbo.DangBaoChe, dbo.DonViTinh, dbo.HoatChat, dbo.NhomThuoc, dbo.HangSanXuat;
DROP TABLE IF EXISTS dbo.CongNoNhaCungCap, dbo.NhaCungCap, dbo.KhachHang;
DROP TABLE IF EXISTS dbo.BacSi, dbo.CoSoKhamChuaBenh;
DROP TABLE IF EXISTS dbo.CaLamViec, dbo.TaiKhoan, dbo.NhanVien, dbo.ChucVu, dbo.ChiNhanh;
DROP TABLE IF EXISTS dbo.VaiTroQuyen, dbo.Quyen, dbo.VaiTro;
DROP TABLE IF EXISTS dbo.ButToanKeToan;
GO

/* =========================================================
   1. PHAN QUYEN - CHI NHANH - NHAN VIEN
========================================================= */
CREATE TABLE dbo.VaiTro (
    MaVaiTro INT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(255),
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Quyen (
    MaQuyen INT IDENTITY(1,1) PRIMARY KEY,
    MaChucNang VARCHAR(100) NOT NULL UNIQUE,
    TenQuyen NVARCHAR(150) NOT NULL,
    NhomChucNang NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);

CREATE TABLE dbo.VaiTroQuyen (
    MaVaiTro INT NOT NULL,
    MaQuyen INT NOT NULL,
    DuocXem BIT NOT NULL DEFAULT 0,
    DuocThem BIT NOT NULL DEFAULT 0,
    DuocSua BIT NOT NULL DEFAULT 0,
    DuocXoa BIT NOT NULL DEFAULT 0,
    DuocDuyet BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (MaVaiTro, MaQuyen),
    FOREIGN KEY (MaVaiTro) REFERENCES dbo.VaiTro(MaVaiTro),
    FOREIGN KEY (MaQuyen) REFERENCES dbo.Quyen(MaQuyen)
);

CREATE TABLE dbo.ChiNhanh (
    MaChiNhanh INT IDENTITY(1,1) PRIMARY KEY,
    MaSoChiNhanh VARCHAR(20) NOT NULL UNIQUE,
    TenChiNhanh NVARCHAR(200) NOT NULL,
    DiaChi NVARCHAR(255) NOT NULL,
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DangHoatDong BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.ChucVu (
    MaChucVu INT IDENTITY(1,1) PRIMARY KEY,
    TenChucVu NVARCHAR(100) NOT NULL UNIQUE,
    LuongCoBan DECIMAL(18,2) NOT NULL DEFAULT 0,
    MoTa NVARCHAR(255)
);

CREATE TABLE dbo.NhanVien (
    MaNhanVien INT IDENTITY(1,1) PRIMARY KEY,
    MaSoNhanVien VARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nu', N'Khac')),
    NgaySinh DATE,
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DiaChi NVARCHAR(255),
    NgayVaoLam DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    MaChiNhanh INT NOT NULL,
    MaChucVu INT NOT NULL,
    MaVaiTro INT NOT NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Dang lam'
        CHECK (TrangThai IN (N'Dang lam', N'Nghi viec', N'Tam nghi')),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaChucVu) REFERENCES dbo.ChucVu(MaChucVu),
    FOREIGN KEY (MaVaiTro) REFERENCES dbo.VaiTro(MaVaiTro)
);

CREATE TABLE dbo.TaiKhoan (
    MaTaiKhoan INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT NOT NULL UNIQUE,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhauBam NVARCHAR(255) NOT NULL,
    BiKhoa BIT NOT NULL DEFAULT 0,
    LanDangNhapCuoi DATETIME2 NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);

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
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVienMoCa) REFERENCES dbo.NhanVien(MaNhanVien),
    FOREIGN KEY (MaNhanVienDongCa) REFERENCES dbo.NhanVien(MaNhanVien)
);

/* =========================================================
   2. DOI TAC - KHACH HANG - BAC SI
========================================================= */
CREATE TABLE dbo.KhachHang (
    MaKhachHang INT IDENTITY(1,1) PRIMARY KEY,
    MaSoKhachHang VARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DiaChi NVARCHAR(255),
    HangThanhVien NVARCHAR(50) NOT NULL DEFAULT N'Thuong',
    DiemTichLuy INT NOT NULL DEFAULT 0,
    TongTienDaMua DECIMAL(18,2) NOT NULL DEFAULT 0,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

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

CREATE TABLE dbo.CongNoNhaCungCap (
    MaCongNo INT IDENTITY(1,1) PRIMARY KEY,
    MaNhaCungCap INT NOT NULL,
    NgayPhatSinh DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    LoaiPhatSinh NVARCHAR(50) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    HanThanhToan DATE NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Chua thanh toan',
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaNhaCungCap) REFERENCES dbo.NhaCungCap(MaNhaCungCap)
);

CREATE TABLE dbo.CoSoKhamChuaBenh (
    MaCoSoKhamChuaBenh INT IDENTITY(1,1) PRIMARY KEY,
    MaSoCoSo VARCHAR(30) NOT NULL UNIQUE,
    TenCoSo NVARCHAR(250) NOT NULL,
    LoaiCoSo NVARCHAR(80) NOT NULL DEFAULT N'Phong kham',
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(20),
    Email VARCHAR(150),
    DangHopTac BIT NOT NULL DEFAULT 1
);

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
    FOREIGN KEY (MaCoSoKhamChuaBenh) REFERENCES dbo.CoSoKhamChuaBenh(MaCoSoKhamChuaBenh)
);

/* =========================================================
   3. DANH MUC THUOC
========================================================= */
CREATE TABLE dbo.HangSanXuat (
    MaHangSanXuat INT IDENTITY(1,1) PRIMARY KEY,
    TenHangSanXuat NVARCHAR(200) NOT NULL UNIQUE,
    QuocGia NVARCHAR(100),
    MoTa NVARCHAR(255)
);

CREATE TABLE dbo.NhomThuoc (
    MaNhomThuoc INT IDENTITY(1,1) PRIMARY KEY,
    TenNhomThuoc NVARCHAR(150) NOT NULL UNIQUE,
    MaNhomCha INT NULL,
    MoTa NVARCHAR(255),
    FOREIGN KEY (MaNhomCha) REFERENCES dbo.NhomThuoc(MaNhomThuoc)
);

CREATE TABLE dbo.HoatChat (
    MaHoatChat INT IDENTITY(1,1) PRIMARY KEY,
    TenHoatChat NVARCHAR(150) NOT NULL UNIQUE,
    CongDungChung NVARCHAR(500),
    CanhBao NVARCHAR(500),
    MoTa NVARCHAR(500)
);

CREATE TABLE dbo.DonViTinh (
    MaDonViTinh INT IDENTITY(1,1) PRIMARY KEY,
    TenDonViTinh NVARCHAR(50) NOT NULL UNIQUE,
    MoTa NVARCHAR(255)
);

CREATE TABLE dbo.DangBaoChe (
    MaDangBaoChe INT IDENTITY(1,1) PRIMARY KEY,
    TenDangBaoChe NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(255)
);

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
    GiaNhap DECIMAL(18,2) NOT NULL DEFAULT 0,
    GiaBan DECIMAL(18,2) NOT NULL DEFAULT 0,
    PhanTramVAT DECIMAL(5,2) NOT NULL DEFAULT 0,
    TonToiThieu INT NOT NULL DEFAULT 0,
    TonToiDa INT NOT NULL DEFAULT 0,
    DangKinhDoanh BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (MaNhomThuoc) REFERENCES dbo.NhomThuoc(MaNhomThuoc),
    FOREIGN KEY (MaHangSanXuat) REFERENCES dbo.HangSanXuat(MaHangSanXuat),
    FOREIGN KEY (MaDonViTinh) REFERENCES dbo.DonViTinh(MaDonViTinh),
    FOREIGN KEY (MaDangBaoChe) REFERENCES dbo.DangBaoChe(MaDangBaoChe),
    CHECK (GiaNhap >= 0 AND GiaBan >= 0)
);

CREATE TABLE dbo.ThuocHoatChat (
    MaThuoc INT NOT NULL,
    MaHoatChat INT NOT NULL,
    HamLuongHoatChat NVARCHAR(100),
    PRIMARY KEY (MaThuoc, MaHoatChat),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaHoatChat) REFERENCES dbo.HoatChat(MaHoatChat)
);

/* =========================================================
   4. NHAP KHO - TON KHO - GIAO DICH KHO
========================================================= */
CREATE TABLE dbo.PhieuNhap (
    MaPhieuNhap INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuNhap VARCHAR(30) NOT NULL UNIQUE,
    MaNhaCungCap INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaNhanVien INT NOT NULL,
    NgayNhap DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Da nhap',
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaNhaCungCap) REFERENCES dbo.NhaCungCap(MaNhaCungCap),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);

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
    FOREIGN KEY (MaPhieuNhap) REFERENCES dbo.PhieuNhap(MaPhieuNhap),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);

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
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaChiTietPhieuNhap) REFERENCES dbo.ChiTietPhieuNhap(MaChiTietPhieuNhap),
    UNIQUE (MaThuoc, MaChiNhanh, SoLo, HanSuDung)
);

CREATE TABLE dbo.GiaoDichKho (
    MaGiaoDichKho INT IDENTITY(1,1) PRIMARY KEY,
    MaThuoc INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaTonKhoLo INT NULL,
    LoaiGiaoDich NVARCHAR(50) NOT NULL,
    SoLuongThayDoi INT NOT NULL,
    LoaiChungTu NVARCHAR(50),
    MaChungTu INT NULL,
    GhiChu NVARCHAR(500),
    MaNhanVienTao INT NOT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

/* =========================================================
   5. BAN HANG - HOA DON - THANH TOAN - DON THUOC
========================================================= */
CREATE TABLE dbo.KhuyenMai (
    MaKhuyenMai INT IDENTITY(1,1) PRIMARY KEY,
    MaSoKhuyenMai VARCHAR(30) NOT NULL UNIQUE,
    TenKhuyenMai NVARCHAR(200) NOT NULL,
    LoaiKhuyenMai NVARCHAR(50) NOT NULL,
    GiaTriGiam DECIMAL(18,2) NOT NULL DEFAULT 0,
    NgayBatDau DATETIME2 NOT NULL,
    NgayKetThuc DATETIME2 NOT NULL,
    DangApDung BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.KhuyenMaiThuoc (
    MaKhuyenMai INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuongToiThieu INT NOT NULL DEFAULT 1,
    PRIMARY KEY (MaKhuyenMai, MaThuoc),
    FOREIGN KEY (MaKhuyenMai) REFERENCES dbo.KhuyenMai(MaKhuyenMai),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);

CREATE TABLE dbo.HoaDonBan (
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaSoHoaDon VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaKhachHang INT NULL,
    MaNhanVien INT NOT NULL,
    MaCaLamViec INT NULL,
    NgayBan DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Hoan tat',
    TongTienHang DECIMAL(18,2) NOT NULL DEFAULT 0,
    TienGiamGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    TienVAT DECIMAL(18,2) NOT NULL DEFAULT 0,
    TongThanhToan DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien),
    FOREIGN KEY (MaCaLamViec) REFERENCES dbo.CaLamViec(MaCaLamViec)
);

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
    FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    FOREIGN KEY (MaKhuyenMai) REFERENCES dbo.KhuyenMai(MaKhuyenMai)
);

CREATE TABLE dbo.ThanhToan (
    MaThanhToan INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon INT NOT NULL,
    PhuongThucThanhToan NVARCHAR(100) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    NgayThanhToan DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    MaGiaoDich VARCHAR(100),
    GhiChu NVARCHAR(255),
    FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon)
);

CREATE TABLE dbo.DonThuoc (
    MaDonThuoc INT IDENTITY(1,1) PRIMARY KEY,
    MaSoDonThuoc VARCHAR(30) NOT NULL UNIQUE,
    MaKhachHang INT NULL,
    MaBacSi INT NULL,
    MaCoSoKhamChuaBenh INT NULL,
    ChanDoan NVARCHAR(500),
    NgayKeDon DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    MaHoaDon INT NULL,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    FOREIGN KEY (MaBacSi) REFERENCES dbo.BacSi(MaBacSi),
    FOREIGN KEY (MaCoSoKhamChuaBenh) REFERENCES dbo.CoSoKhamChuaBenh(MaCoSoKhamChuaBenh),
    FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon)
);

CREATE TABLE dbo.ChiTietDonThuoc (
    MaChiTietDonThuoc INT IDENTITY(1,1) PRIMARY KEY,
    MaDonThuoc INT NOT NULL,
    MaThuoc INT NOT NULL,
    LieuDung NVARCHAR(200),
    TanSuatDung NVARCHAR(200),
    ThoiGianDung NVARCHAR(100),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaDonThuoc) REFERENCES dbo.DonThuoc(MaDonThuoc),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);

/* =========================================================
   6. QUAN TRI MO RONG
========================================================= */
CREATE TABLE dbo.NhatKyHeThong (
    MaNhatKy BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenBang VARCHAR(100) NULL,
    LoaiHanhDong NVARCHAR(50) NOT NULL,
    MaBanGhi NVARCHAR(100) NULL,
    NoiDung NVARCHAR(1000) NOT NULL,
    MaNhanVien INT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien)
);

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
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaNhanVienCapNhat) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.PhieuKiemKeKho (
    MaPhieuKiemKe INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuKiemKe VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaNhanVienTao INT NOT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    NgayChot DATETIME2 NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Dang kiem ke',
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.ChiTietKiemKeKho (
    MaChiTietKiemKe INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuKiemKe INT NOT NULL,
    MaTonKhoLo INT NOT NULL,
    SoLuongHeThong INT NOT NULL CHECK (SoLuongHeThong >= 0),
    SoLuongThucTe INT NOT NULL CHECK (SoLuongThucTe >= 0),
    ChenhLech AS (SoLuongThucTe - SoLuongHeThong) PERSISTED,
    LyDoChenhLech NVARCHAR(500),
    FOREIGN KEY (MaPhieuKiemKe) REFERENCES dbo.PhieuKiemKeKho(MaPhieuKiemKe),
    FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo)
);

CREATE TABLE dbo.PhieuTraHang (
    MaPhieuTraHang INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuTraHang VARCHAR(30) NOT NULL UNIQUE,
    MaHoaDon INT NOT NULL,
    MaChiNhanh INT NOT NULL,
    MaKhachHang INT NULL,
    MaNhanVienTao INT NOT NULL,
    NgayTra DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LyDoTra NVARCHAR(500) NOT NULL,
    TongTienHoan DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaHoaDon) REFERENCES dbo.HoaDonBan(MaHoaDon),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.ChiTietPhieuTraHang (
    MaChiTietTraHang INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuTraHang INT NOT NULL,
    MaChiTietHoaDon INT NOT NULL,
    MaThuoc INT NOT NULL,
    MaTonKhoLo INT NULL,
    SoLuongTra INT NOT NULL CHECK (SoLuongTra > 0),
    DonGiaHoan DECIMAL(18,2) NOT NULL CHECK (DonGiaHoan >= 0),
    TinhTrangHangTra NVARCHAR(50) NOT NULL DEFAULT N'Con ban duoc',
    FOREIGN KEY (MaPhieuTraHang) REFERENCES dbo.PhieuTraHang(MaPhieuTraHang),
    FOREIGN KEY (MaChiTietHoaDon) REFERENCES dbo.ChiTietHoaDon(MaChiTietHoaDon),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo)
);

CREATE TABLE dbo.HoanTien (
    MaHoanTien INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuTraHang INT NOT NULL,
    PhuongThucHoanTien NVARCHAR(100) NOT NULL,
    SoTienHoan DECIMAL(18,2) NOT NULL CHECK (SoTienHoan >= 0),
    NgayHoanTien DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    MaGiaoDich VARCHAR(100),
    GhiChu NVARCHAR(255),
    FOREIGN KEY (MaPhieuTraHang) REFERENCES dbo.PhieuTraHang(MaPhieuTraHang)
);

CREATE TABLE dbo.PhieuHuyHang (
    MaPhieuHuyHang INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuHuyHang VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaNhanVienTao INT NOT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LyDoHuy NVARCHAR(500) NOT NULL,
    TongGiaTriHuy DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.ChiTietHuyHang (
    MaChiTietHuyHang INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuHuyHang INT NOT NULL,
    MaTonKhoLo INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuongHuy INT NOT NULL CHECK (SoLuongHuy > 0),
    DonGiaVon DECIMAL(18,2) NOT NULL CHECK (DonGiaVon >= 0),
    ThanhTienHuy AS (SoLuongHuy * DonGiaVon) PERSISTED,
    FOREIGN KEY (MaPhieuHuyHang) REFERENCES dbo.PhieuHuyHang(MaPhieuHuyHang),
    FOREIGN KEY (MaTonKhoLo) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc)
);

CREATE TABLE dbo.PhieuDieuChuyenKho (
    MaPhieuDieuChuyen INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuDieuChuyen VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanhXuat INT NOT NULL,
    MaChiNhanhNhan INT NOT NULL,
    MaNhanVienTao INT NOT NULL,
    NgayTao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Da chuyen',
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaChiNhanhXuat) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaChiNhanhNhan) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien),
    CHECK (MaChiNhanhXuat <> MaChiNhanhNhan)
);

CREATE TABLE dbo.ChiTietDieuChuyenKho (
    MaChiTietDieuChuyen INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuDieuChuyen INT NOT NULL,
    MaThuoc INT NOT NULL,
    MaTonKhoLoXuat INT NOT NULL,
    MaTonKhoLoNhan INT NULL,
    SoLuongChuyen INT NOT NULL CHECK (SoLuongChuyen > 0),
    DonGiaVon DECIMAL(18,2) NOT NULL CHECK (DonGiaVon >= 0),
    FOREIGN KEY (MaPhieuDieuChuyen) REFERENCES dbo.PhieuDieuChuyenKho(MaPhieuDieuChuyen),
    FOREIGN KEY (MaThuoc) REFERENCES dbo.Thuoc(MaThuoc),
    FOREIGN KEY (MaTonKhoLoXuat) REFERENCES dbo.TonKhoLo(MaTonKhoLo),
    FOREIGN KEY (MaTonKhoLoNhan) REFERENCES dbo.TonKhoLo(MaTonKhoLo)
);

CREATE TABLE dbo.ChiPhiVanHanh (
    MaChiPhi INT IDENTITY(1,1) PRIMARY KEY,
    MaSoChiPhi VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    NhomChiPhi NVARCHAR(100) NOT NULL,
    NoiDung NVARCHAR(500) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    NgayPhatSinh DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    MaNhanVienTao INT NOT NULL,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Cho chi',
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.PhieuThu (
    MaPhieuThu INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuThu VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaThanhToan INT NULL,
    NgayThu DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    NguonThu NVARCHAR(100) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    PhuongThucThu NVARCHAR(100) NOT NULL,
    MaNhanVienTao INT NOT NULL,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaThanhToan) REFERENCES dbo.ThanhToan(MaThanhToan),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.PhieuChi (
    MaPhieuChi INT IDENTITY(1,1) PRIMARY KEY,
    MaSoPhieuChi VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    MaChiPhi INT NULL,
    NgayChi DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LoaiChi NVARCHAR(100) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    PhuongThucChi NVARCHAR(100) NOT NULL,
    MaNhanVienTao INT NOT NULL,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaChiPhi) REFERENCES dbo.ChiPhiVanHanh(MaChiPhi),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);

CREATE TABLE dbo.ChamCong (
    MaChamCong INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT NOT NULL,
    MaCaLamViec INT NULL,
    NgayLam DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    GioVao DATETIME2 NOT NULL,
    GioRa DATETIME2 NULL,
    SoGioLam AS (CASE WHEN GioRa IS NULL THEN NULL ELSE DATEDIFF(MINUTE, GioVao, GioRa) / 60.0 END) PERSISTED,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Di lam',
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien),
    FOREIGN KEY (MaCaLamViec) REFERENCES dbo.CaLamViec(MaCaLamViec),
    UNIQUE (MaNhanVien, NgayLam, MaCaLamViec)
);

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
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Nhap tam',
    NgayTinh DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaNhanVien) REFERENCES dbo.NhanVien(MaNhanVien),
    UNIQUE (MaNhanVien, Thang, Nam)
);

CREATE TABLE dbo.ButToanKeToan (
    MaButToan INT IDENTITY(1,1) PRIMARY KEY,
    MaSoButToan VARCHAR(30) NOT NULL UNIQUE,
    MaChiNhanh INT NOT NULL,
    NgayGhiSo DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    LoaiButToan NVARCHAR(50) NOT NULL,
    TaiKhoanNo VARCHAR(20) NOT NULL,
    TaiKhoanCo VARCHAR(20) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    LoaiChungTu NVARCHAR(50),
    MaChungTu INT NULL,
    NoiDung NVARCHAR(500),
    MaNhanVienTao INT NOT NULL,
    FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    FOREIGN KEY (MaNhanVienTao) REFERENCES dbo.NhanVien(MaNhanVien)
);
GO

/* =========================================================
   7. INDEX
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
   8. DU LIEU MAU TOI THIEU
========================================================= */
INSERT INTO dbo.VaiTro (TenVaiTro, MoTa) VALUES
(N'Admin', N'Quan tri toan bo he thong'),
(N'Manager', N'Quan ly chi nhanh, kho, nhan vien va bao cao'),
(N'NhanVien', N'Nhan vien nha thuoc');

INSERT INTO dbo.Quyen (MaChucNang, TenQuyen, NhomChucNang, MoTa) VALUES
('THUOC_XEM', N'Xem thuoc', N'Thuoc', N'Xem danh sach thuoc'),
('THUOC_THEM', N'Them thuoc', N'Thuoc', N'Them thuoc moi'),
('THUOC_SUA', N'Sua thuoc', N'Thuoc', N'Cap nhat thuoc'),
('KHO_XEM', N'Xem kho', N'Kho', N'Xem ton kho'),
('KHO_NHAP', N'Nhap kho', N'Kho', N'Nhap hang vao kho'),
('BANHANG_LAPHOADON', N'Lap hoa don', N'Ban hang', N'Tao hoa don ban'),
('BAOCAO_XEM', N'Xem bao cao', N'Bao cao', N'Xem bao cao');

INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 1, MaQuyen, 1, 1, 1, 1, 1 FROM dbo.Quyen;
INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 2, MaQuyen, 1, 1, 1, 0, 1 FROM dbo.Quyen;
INSERT INTO dbo.VaiTroQuyen (MaVaiTro, MaQuyen, DuocXem, DuocThem, DuocSua, DuocXoa, DuocDuyet)
SELECT 3, MaQuyen, 1, CASE WHEN MaChucNang='BANHANG_LAPHOADON' THEN 1 ELSE 0 END, 0, 0, 0 FROM dbo.Quyen;

INSERT INTO dbo.ChiNhanh (MaSoChiNhanh, TenChiNhanh, DiaChi, SoDienThoai, Email) VALUES
('CN001', N'Nha thuoc Tam An - Quan 1', N'12 Nguyen Trai, Quan 1, TP.HCM', '02811112222', 'quan1@taman.vn'),
('CN002', N'Nha thuoc Tam An - Thu Duc', N'88 Vo Van Ngan, Thu Duc, TP.HCM', '02833334444', 'thuduc@taman.vn');

INSERT INTO dbo.ChucVu (TenChucVu, LuongCoBan, MoTa) VALUES
(N'Quan ly nha thuoc', 15000000, N'Quan ly chi nhanh'),
(N'Duoc si', 12000000, N'Tu van va ban thuoc'),
(N'Thu ngan', 8000000, N'Lap hoa don va thu tien');

INSERT INTO dbo.NhanVien (MaSoNhanVien, HoTen, GioiTinh, SoDienThoai, Email, DiaChi, MaChiNhanh, MaChucVu, MaVaiTro) VALUES
('NV001', N'Nguyen Minh Anh', N'Nu', '0901000001', 'admin@taman.vn', N'TP.HCM', 1, 1, 1),
('NV002', N'Tran Quoc Huy', N'Nam', '0901000002', 'manager@taman.vn', N'TP.HCM', 1, 1, 2),
('NV003', N'Le Thao Vy', N'Nu', '0901000003', 'nhanvien@taman.vn', N'TP.HCM', 1, 2, 3);

INSERT INTO dbo.TaiKhoan (MaNhanVien, TenDangNhap, MatKhauBam) VALUES
(1, 'admin', N'1'),
(2, 'manager', N'1'),
(3, 'nhanvien', N'1');

INSERT INTO dbo.CaLamViec (MaChiNhanh, MaNhanVienMoCa, TenCa, ThoiGianBatDau, TienMatDauCa) VALUES
(1, 3, N'Ca sang 06:00 - 12:00', DATEADD(HOUR, -1, SYSDATETIME()), 2000000);

INSERT INTO dbo.KhachHang (MaSoKhachHang, HoTen, SoDienThoai, Email, DiaChi, DiemTichLuy, TongTienDaMua) VALUES
('KH001', N'Nguyen Van Binh', '0912000001', 'binh.nguyen@gmail.com', N'Quan 1, TP.HCM', 120, 3500000),
('KH002', N'Tran Thi Hoa', '0912000002', 'hoa.tran@gmail.com', N'Thu Duc, TP.HCM', 45, 850000);

INSERT INTO dbo.NhaCungCap (MaSoNhaCungCap, TenNhaCungCap, MaSoThue, NguoiLienHe, SoDienThoai, Email, DiaChi) VALUES
('NCC001', N'Cong ty Duoc pham An Khang', '0311111111', N'Nguyen Thanh Tung', '02870000001', 'sales@ankhang.vn', N'TP.HCM'),
('NCC002', N'Cong ty Duoc pham Viet Tin', '0312222222', N'Pham Lan Anh', '02870000002', 'contact@viettin.vn', N'Ha Noi');

INSERT INTO dbo.HangSanXuat (TenHangSanXuat, QuocGia) VALUES
(N'Duoc Hau Giang', N'Viet Nam'), (N'Traphaco', N'Viet Nam'), (N'Sanofi', N'Phap');

INSERT INTO dbo.NhomThuoc (TenNhomThuoc, MaNhomCha, MoTa) VALUES
(N'Thuoc ke don', NULL, N'Thuoc can don bac si'),
(N'Thuoc khong ke don', NULL, N'Thuoc OTC'),
(N'Thuc pham bao ve suc khoe', NULL, N'Ho tro suc khoe'),
(N'Giam dau - ha sot', 2, N'Giam dau va ha sot'),
(N'Tieu hoa', 2, N'Ho tro tieu hoa');

INSERT INTO dbo.HoatChat (TenHoatChat, CongDungChung, CanhBao) VALUES
(N'Paracetamol', N'Giam dau, ha sot', N'Tranh qua lieu'),
(N'Ibuprofen', N'Giam dau, chong viem', N'Than trong voi benh da day'),
(N'Omeprazole', N'Giam tiet acid da day', N'Dung theo huong dan');

INSERT INTO dbo.DonViTinh (TenDonViTinh, MoTa) VALUES
(N'Vien', N'Don vi vien'), (N'Vi', N'Don vi vi'), (N'Hop', N'Don vi hop'), (N'Chai', N'Don vi chai');

INSERT INTO dbo.DangBaoChe (TenDangBaoChe, MoTa) VALUES
(N'Vien nen', N'Vien nen'), (N'Vien nang', N'Vien nang'), (N'Siro', N'Dang long');

INSERT INTO dbo.Thuoc (MaSoThuoc, TenThuoc, TenNgan, MaNhomThuoc, MaHangSanXuat, MaDonViTinh, MaDangBaoChe, HamLuong, CanDonThuoc, MoTa, CongDung, GiaNhap, GiaBan, PhanTramVAT, TonToiThieu, TonToiDa) VALUES
('T001', N'Paracetamol 500mg', N'Para 500', 4, 1, 1, 1, N'500mg', 0, N'Thuoc giam dau ha sot', N'Giam dau, ha sot', 300, 800, 0, 50, 1000),
('T002', N'Ibuprofen 400mg', N'Ibu 400', 4, 2, 1, 1, N'400mg', 0, N'Thuoc giam dau khang viem', N'Giam dau, chong viem', 700, 1500, 0, 30, 600),
('T003', N'Omeprazole 20mg', N'Ome 20', 5, 3, 1, 2, N'20mg', 0, N'Ho tro da day', N'Giam tiet acid da day', 900, 2000, 0, 20, 500);

INSERT INTO dbo.ThuocHoatChat (MaThuoc, MaHoatChat, HamLuongHoatChat) VALUES
(1, 1, N'500mg'), (2, 2, N'400mg'), (3, 3, N'20mg');

INSERT INTO dbo.PhieuNhap (MaSoPhieuNhap, MaNhaCungCap, MaChiNhanh, MaNhanVien, TongTien, GhiChu) VALUES
('PN001', 1, 1, 2, 3000000, N'Nhap hang dau ky');

INSERT INTO dbo.ChiTietPhieuNhap (MaPhieuNhap, MaThuoc, SoLo, HanSuDung, SoLuong, DonGiaNhap) VALUES
(1, 1, 'LO-PARA-001', DATEADD(YEAR, 2, CAST(GETDATE() AS DATE)), 1000, 300),
(1, 2, 'LO-IBU-001', DATEADD(YEAR, 2, CAST(GETDATE() AS DATE)), 500, 700),
(1, 3, 'LO-OME-001', DATEADD(YEAR, 2, CAST(GETDATE() AS DATE)), 300, 900);

INSERT INTO dbo.TonKhoLo (MaThuoc, MaChiNhanh, MaChiTietPhieuNhap, SoLo, HanSuDung, SoLuongTon, DonGiaVon) VALUES
(1, 1, 1, 'LO-PARA-001', DATEADD(YEAR, 2, CAST(GETDATE() AS DATE)), 1000, 300),
(2, 1, 2, 'LO-IBU-001', DATEADD(YEAR, 2, CAST(GETDATE() AS DATE)), 500, 700),
(3, 1, 3, 'LO-OME-001', DATEADD(YEAR, 2, CAST(GETDATE() AS DATE)), 300, 900);
GO

/* =========================================================
   9. VIEW CHO UNG DUNG VA BAO CAO
========================================================= */
CREATE OR ALTER VIEW dbo.vw_Users AS
SELECT tk.MaTaiKhoan AS Id, tk.TenDangNhap AS Username, tk.MatKhauBam AS [Password], nv.HoTen AS [Name], vt.TenVaiTro AS [Role], nv.MaNhanVien AS EmployeeId
FROM dbo.TaiKhoan tk
JOIN dbo.NhanVien nv ON tk.MaNhanVien = nv.MaNhanVien
JOIN dbo.VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro
WHERE tk.BiKhoa = 0;
GO

CREATE OR ALTER VIEW dbo.vw_DanhSachThuocBanHang AS
SELECT
    t.MaThuoc AS Id,
    t.MaSoThuoc AS Code,
    t.MaSoThuoc AS MedicineCode,
    t.TenThuoc AS [Name],
    dvt.TenDonViTinh AS Unit,
    nt.TenNhomThuoc AS Category,
    ISNULL(hsx.TenHangSanXuat, N'') AS Manufacturer,
    t.GiaBan AS Price,
    ISNULL(SUM(tk.SoLuongTon), 0) AS Quantity,
    CAST(N'' AS NVARCHAR(500)) AS ImagePath,
    t.CanDonThuoc,
    t.DangKinhDoanh
FROM dbo.Thuoc t
JOIN dbo.NhomThuoc nt ON t.MaNhomThuoc = nt.MaNhomThuoc
JOIN dbo.DonViTinh dvt ON t.MaDonViTinh = dvt.MaDonViTinh
LEFT JOIN dbo.HangSanXuat hsx ON t.MaHangSanXuat = hsx.MaHangSanXuat
LEFT JOIN dbo.TonKhoLo tk ON tk.MaThuoc = t.MaThuoc
GROUP BY t.MaThuoc, t.MaSoThuoc, t.TenThuoc, dvt.TenDonViTinh, nt.TenNhomThuoc, hsx.TenHangSanXuat, t.GiaBan, t.CanDonThuoc, t.DangKinhDoanh;
GO

CREATE OR ALTER VIEW dbo.vw_TonKhoTheoLo AS
SELECT
    tk.MaTonKhoLo,
    t.MaSoThuoc,
    t.TenThuoc,
    cn.TenChiNhanh,
    tk.SoLo,
    tk.HanSuDung,
    tk.SoLuongTon,
    t.TonToiThieu,
    tk.DonGiaVon,
    CASE
        WHEN tk.HanSuDung < CAST(GETDATE() AS DATE) THEN N'Da het han'
        WHEN tk.HanSuDung <= DATEADD(DAY, 90, CAST(GETDATE() AS DATE)) THEN N'Sap het han'
        WHEN tk.SoLuongTon <= t.TonToiThieu THEN N'Sap het hang'
        ELSE N'Binh thuong'
    END AS TinhTrangTonKho
FROM dbo.TonKhoLo tk
JOIN dbo.Thuoc t ON tk.MaThuoc = t.MaThuoc
JOIN dbo.ChiNhanh cn ON tk.MaChiNhanh = cn.MaChiNhanh;
GO

CREATE OR ALTER VIEW dbo.vw_DoanhThuTheoNgay AS
SELECT CAST(NgayBan AS DATE) AS NgayBan, MaChiNhanh, COUNT(*) AS TongSoHoaDon, SUM(TongThanhToan) AS TongDoanhThu
FROM dbo.HoaDonBan
WHERE TrangThai IN (N'Hoan tat', N'Da tra mot phan')
GROUP BY CAST(NgayBan AS DATE), MaChiNhanh;
GO

CREATE OR ALTER VIEW dbo.vw_SoQuyThuChi AS
SELECT N'Thu' AS Loai, MaPhieuThu AS MaChungTu, MaSoPhieuThu AS SoChungTu, NgayThu AS NgayPhatSinh, SoTien, PhuongThucThu AS PhuongThuc, GhiChu FROM dbo.PhieuThu
UNION ALL
SELECT N'Chi', MaPhieuChi, MaSoPhieuChi, NgayChi, SoTien, PhuongThucChi, GhiChu FROM dbo.PhieuChi;
GO

CREATE OR ALTER VIEW dbo.vw_Crystal_TonKhoCanhBao AS
SELECT * FROM dbo.vw_TonKhoTheoLo
WHERE TinhTrangTonKho <> N'Binh thuong';
GO

/* =========================================================
   10. TRIGGER TU DONG
========================================================= */
CREATE OR ALTER TRIGGER dbo.tr_Thuoc_LuuLichSuGia
ON dbo.Thuoc
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.LichSuGiaThuoc (MaThuoc, GiaNhapCu, GiaNhapMoi, GiaBanCu, GiaBanMoi, LyDo)
    SELECT i.MaThuoc, d.GiaNhap, i.GiaNhap, d.GiaBan, i.GiaBan, N'Tu dong ghi nhan khi cap nhat gia'
    FROM inserted i
    JOIN deleted d ON i.MaThuoc = d.MaThuoc
    WHERE ISNULL(i.GiaNhap,0) <> ISNULL(d.GiaNhap,0)
       OR ISNULL(i.GiaBan,0) <> ISNULL(d.GiaBan,0);
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_ChiTietHoaDon_CapNhatTonKho
ON dbo.ChiTietHoaDon
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE tk
    SET tk.SoLuongTon = tk.SoLuongTon - i.SoLuong
    FROM dbo.TonKhoLo tk
    JOIN inserted i ON i.MaTonKhoLo = tk.MaTonKhoLo
    WHERE tk.SoLuongTon >= i.SoLuong;

    INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
    SELECT i.MaThuoc, hd.MaChiNhanh, i.MaTonKhoLo, N'Ban hang', -i.SoLuong, N'HoaDonBan', hd.MaHoaDon, N'Tu dong tru ton khi ban hang', hd.MaNhanVien
    FROM inserted i
    JOIN dbo.HoaDonBan hd ON hd.MaHoaDon = i.MaHoaDon;
END;
GO

CREATE OR ALTER TRIGGER dbo.tr_ThanhToan_TaoPhieuThu
ON dbo.ThanhToan
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.PhieuThu (MaSoPhieuThu, MaChiNhanh, MaThanhToan, NguonThu, SoTien, PhuongThucThu, MaNhanVienTao, GhiChu)
    SELECT 'PT' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss') + CAST(i.MaThanhToan AS VARCHAR(20)),
           hd.MaChiNhanh, i.MaThanhToan, N'Ban hang', i.SoTien, i.PhuongThucThanhToan, hd.MaNhanVien, N'Tu dong tao phieu thu tu thanh toan'
    FROM inserted i
    JOIN dbo.HoaDonBan hd ON hd.MaHoaDon = i.MaHoaDon;
END;
GO

/* =========================================================
   11. PROCEDURE NGHIEP VU CHINH
========================================================= */
CREATE OR ALTER PROCEDURE dbo.sp_TimThuoc
    @TuKhoa NVARCHAR(200) = NULL,
    @MaNhomThuoc INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM dbo.vw_DanhSachThuocBanHang
    WHERE DangKinhDoanh = 1
      AND (@TuKhoa IS NULL OR [Name] LIKE N'%' + @TuKhoa + N'%' OR Code LIKE '%' + CAST(@TuKhoa AS VARCHAR(200)) + '%')
      AND (@MaNhomThuoc IS NULL OR Category IN (SELECT TenNhomThuoc FROM dbo.NhomThuoc WHERE MaNhomThuoc = @MaNhomThuoc))
    ORDER BY [Name];
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CanhBaoTonKhoThap
    @MaChiNhanh INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.MaSoThuoc, t.TenThuoc, cn.TenChiNhanh, SUM(tk.SoLuongTon) AS TongSoLuongTon, t.TonToiThieu
    FROM dbo.Thuoc t
    JOIN dbo.TonKhoLo tk ON t.MaThuoc = tk.MaThuoc
    JOIN dbo.ChiNhanh cn ON tk.MaChiNhanh = cn.MaChiNhanh
    WHERE (@MaChiNhanh IS NULL OR tk.MaChiNhanh = @MaChiNhanh)
    GROUP BY t.MaSoThuoc, t.TenThuoc, cn.TenChiNhanh, t.TonToiThieu
    HAVING SUM(tk.SoLuongTon) <= t.TonToiThieu
    ORDER BY TongSoLuongTon;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CanhBaoThuocSapHetHan
    @SoNgay INT = 90,
    @MaChiNhanh INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM dbo.vw_TonKhoTheoLo
    WHERE SoLuongTon > 0
      AND HanSuDung <= DATEADD(DAY, @SoNgay, CAST(GETDATE() AS DATE))
      AND (@MaChiNhanh IS NULL OR TenChiNhanh IN (SELECT TenChiNhanh FROM dbo.ChiNhanh WHERE MaChiNhanh = @MaChiNhanh))
    ORDER BY HanSuDung;
END;
GO

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
    WHERE MaCaLamViec = @MaCaLamViec AND TrangThai IN (N'Hoan tat', N'Da tra mot phan');

    UPDATE dbo.CaLamViec
    SET MaNhanVienDongCa = @MaNhanVienDongCa,
        ThoiGianKetThucThucTe = SYSDATETIME(),
        TienMatCuoiCa = @TienMatCuoiCa,
        DoanhThuTrongCa = @DoanhThuTrongCa,
        ChenhLech = @TienMatCuoiCa - TienMatDauCa - @DoanhThuTrongCa,
        TrangThai = N'Da dong',
        GhiChu = COALESCE(@GhiChu, GhiChu)
    WHERE MaCaLamViec = @MaCaLamViec AND TrangThai = N'Dang mo';
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

    INSERT INTO dbo.ChiTietKiemKeKho (MaPhieuKiemKe, MaTonKhoLo, SoLuongHeThong, SoLuongThucTe)
    SELECT @MaPhieuKiemKe, MaTonKhoLo, SoLuongTon, SoLuongTon
    FROM dbo.TonKhoLo
    WHERE MaChiNhanh = @MaChiNhanh;

    SELECT @MaPhieuKiemKe AS MaPhieuKiemKe;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ChotPhieuKiemKeKho
    @MaPhieuKiemKe INT,
    @MaNhanVien INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    BEGIN TRY
        UPDATE tk
        SET tk.SoLuongTon = ct.SoLuongThucTe
        FROM dbo.TonKhoLo tk
        JOIN dbo.ChiTietKiemKeKho ct ON ct.MaTonKhoLo = tk.MaTonKhoLo
        WHERE ct.MaPhieuKiemKe = @MaPhieuKiemKe;

        INSERT INTO dbo.GiaoDichKho (MaThuoc, MaChiNhanh, MaTonKhoLo, LoaiGiaoDich, SoLuongThayDoi, LoaiChungTu, MaChungTu, GhiChu, MaNhanVienTao)
        SELECT tk.MaThuoc, tk.MaChiNhanh, tk.MaTonKhoLo,
               CASE WHEN ct.ChenhLech >= 0 THEN N'Dieu chinh tang' ELSE N'Dieu chinh giam' END,
               ct.ChenhLech, N'PhieuKiemKeKho', @MaPhieuKiemKe, ct.LyDoChenhLech, @MaNhanVien
        FROM dbo.ChiTietKiemKeKho ct
        JOIN dbo.TonKhoLo tk ON tk.MaTonKhoLo = ct.MaTonKhoLo
        WHERE ct.MaPhieuKiemKe = @MaPhieuKiemKe AND ct.ChenhLech <> 0;

        UPDATE dbo.PhieuKiemKeKho SET TrangThai = N'Da chot', NgayChot = SYSDATETIME() WHERE MaPhieuKiemKe = @MaPhieuKiemKe;
        COMMIT;
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
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    BEGIN TRY
        DECLARE @MaPhieuHuyHang INT;
        INSERT INTO dbo.PhieuHuyHang (MaSoPhieuHuyHang, MaChiNhanh, MaNhanVienTao, LyDoHuy, GhiChu)
        VALUES ('HH' + FORMAT(SYSDATETIME(), 'yyyyMMddHHmmss'), @MaChiNhanh, @MaNhanVienTao, N'Huy hang het han', @GhiChu);
        SET @MaPhieuHuyHang = SCOPE_IDENTITY();

        INSERT INTO dbo.ChiTietHuyHang (MaPhieuHuyHang, MaTonKhoLo, MaThuoc, SoLuongHuy, DonGiaVon)
        SELECT @MaPhieuHuyHang, MaTonKhoLo, MaThuoc, SoLuongTon, DonGiaVon
        FROM dbo.TonKhoLo
        WHERE MaChiNhanh = @MaChiNhanh AND HanSuDung < CAST(GETDATE() AS DATE) AND SoLuongTon > 0;

        UPDATE tk SET SoLuongTon = 0
        FROM dbo.TonKhoLo tk
        JOIN dbo.ChiTietHuyHang ct ON ct.MaTonKhoLo = tk.MaTonKhoLo
        WHERE ct.MaPhieuHuyHang = @MaPhieuHuyHang;

        UPDATE dbo.PhieuHuyHang
        SET TongGiaTriHuy = ISNULL((SELECT SUM(ThanhTienHuy) FROM dbo.ChiTietHuyHang WHERE MaPhieuHuyHang = @MaPhieuHuyHang), 0)
        WHERE MaPhieuHuyHang = @MaPhieuHuyHang;

        SELECT @MaPhieuHuyHang AS MaPhieuHuyHang;
        COMMIT;
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
    WHEN MATCHED THEN UPDATE SET LuongCoBan = src.LuongCoBan, TongGioLam = src.TongGioLam, LuongThucNhan = src.LuongCoBan + target.PhuCap + target.Thuong - target.KhauTru, NgayTinh = SYSDATETIME()
    WHEN NOT MATCHED THEN INSERT (MaNhanVien, Thang, Nam, LuongCoBan, TongGioLam, LuongThucNhan)
    VALUES (src.MaNhanVien, @Thang, @Nam, src.LuongCoBan, src.TongGioLam, src.LuongCoBan);
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_SaoLuuCoSoDuLieu
    @ThuMucSaoLuu NVARCHAR(260) = N'C:\SQL_Backup\'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TenFile NVARCHAR(400) = @ThuMucSaoLuu + N'PharmacyDB_' + CONVERT(VARCHAR(8), GETDATE(), 112) + N'_' + REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108), ':', '') + N'.bak';
    DECLARE @LenhSQL NVARCHAR(MAX) = N'BACKUP DATABASE [PharmacyDB] TO DISK = N''' + @TenFile + N''' WITH INIT, CHECKSUM, STATS = 10;';
    EXEC (@LenhSQL);
END;
GO

/* =========================================================
   12. TEST NHANH SAU KHI CHAY SCRIPT
========================================================= */
SELECT * FROM dbo.vw_Users;
SELECT * FROM dbo.vw_DanhSachThuocBanHang;
SELECT * FROM dbo.vw_TonKhoTheoLo;
GO
