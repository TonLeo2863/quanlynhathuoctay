# HƯỚNG DẪN CÀI ĐẶT VÀ CHẠY DỰ ÁN

## 1. Yêu cầu môi trường

### Phần mềm

* Visual Studio 2022
* .NET 8 hoặc phiên bản theo project
* SQL Server 2019 trở lên
* SQL Server Management Studio (SSMS)

---

## 2. Clone source code

```bash
git clone https://github.com/TonLeo2863/quanlynhathuoctay.git
```

Hoặc tải file ZIP từ GitHub và giải nén.

---

## 3. Tạo cơ sở dữ liệu

Mở SQL Server Management Studio.

Tạo database:

```sql
CREATE DATABASE QuanLyNhaThuoc;
GO
```

Mở file:

```text
Database.sql
```

Thực thi toàn bộ script để tạo:

* Bảng dữ liệu
* Khóa chính
* Khóa ngoại
* Dữ liệu mẫu

---

## 4. Cấu hình chuỗi kết nối

Mở file:

```text
App.config
```

Hoặc:

```text
appsettings.json
```

Cập nhật:

```xml
Data Source=TEN_SERVER;
Initial Catalog=QuanLyNhaThuoc;
Integrated Security=True;
```

Ví dụ:

```xml
Data Source=localhost;
Initial Catalog=QuanLyNhaThuoc;
Integrated Security=True;
```

---

## 5. Chạy project

Mở solution:

```text
QuanLyNhaThuoc.sln
```

Chọn:

```text
Set as Startup Project
```

Nhấn:

```text
F5
```

Hoặc:

```text
Ctrl + F5
```

---

## 6. Tài khoản mẫu

### Admin

```text
Username: admin
Password: 123456
```

### Manager

```text
Username: manager
Password: 123456
```

### Nhân viên

```text
Username: nhanvien
Password: 123456
```

---

## 7. Kiểm tra chức năng

* Đăng nhập
* Quản lý thuốc
* Nhập kho
* Bán hàng
* Hóa đơn
* Thống kê doanh thu
* Report hóa đơn
* Report doanh thu

---

## 8. Một số lỗi thường gặp

### Không kết nối được SQL Server

Nguyên nhân:

* Sai tên server
* SQL Server chưa chạy

Cách khắc phục:

* Kiểm tra Services
* Kiểm tra Connection String

### Thiếu package

Chạy:

```powershell
Restore NuGet Packages
```

Hoặc:

```bash
dotnet restore
```

### Build lỗi

Thực hiện:

```bash
Clean Solution
Rebuild Solution
```

---

## 9. Kết luận

Sau khi hoàn thành các bước trên, hệ thống sẽ hoạt động đầy đủ với các chức năng quản lý nhà thuốc, nhập kho, bán hàng, báo cáo và thống kê doanh thu.
