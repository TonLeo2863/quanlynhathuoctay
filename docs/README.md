# HỆ THỐNG QUẢN LÝ NHÀ THUỐC TÂY

## 1. Giới thiệu đề tài

Hệ thống Quản lý Nhà thuốc Tây được xây dựng nhằm hỗ trợ các hoạt động quản lý và kinh doanh thuốc trong nhà thuốc. Ứng dụng giúp quản lý thông tin thuốc, nhập kho, bán hàng, theo dõi doanh thu và xuất báo cáo một cách nhanh chóng và chính xác.

Dự án được phát triển bằng công nghệ WPF .NET theo mô hình MVVM và sử dụng SQL Server để lưu trữ dữ liệu.

---

## 2. Công nghệ sử dụng

| Công nghệ        | Mô tả                       |
| ---------------- | --------------------------- |
| WPF .NET         | Xây dựng giao diện Desktop  |
| C#               | Ngôn ngữ lập trình          |
| SQL Server       | Quản lý cơ sở dữ liệu       |
| Entity Framework | Kết nối và thao tác dữ liệu |
| MVVM             | Kiến trúc ứng dụng          |
| RDLC Report      | Xuất báo cáo và hóa đơn     |

---

## 3. Chức năng chính

### Quản lý người dùng

* Đăng nhập hệ thống
* Phân quyền Admin
* Phân quyền Manager
* Phân quyền Nhân viên

### Quản lý thuốc

* Thêm thuốc
* Sửa thông tin thuốc
* Xóa thuốc
* Tìm kiếm thuốc
* Quản lý tồn kho

### Nhập kho

* Tạo phiếu nhập
* Thêm chi tiết nhập kho
* Cập nhật số lượng tồn

### Bán hàng

* Tạo giỏ hàng
* Thanh toán
* Xuất hóa đơn bán
* Lưu lịch sử giao dịch

### Thống kê

* Thống kê doanh thu theo ngày
* Thống kê doanh thu theo tháng
* Thống kê doanh thu theo khoảng thời gian

### Báo cáo

* In hóa đơn bán hàng
* Xuất báo cáo doanh thu

---

## 4. Kiến trúc hệ thống

Dự án áp dụng mô hình MVVM:

* Model: Quản lý dữ liệu và nghiệp vụ
* View: Giao diện người dùng
* ViewModel: Trung gian xử lý dữ liệu giữa View và Model

---

## 5. Cấu trúc thư mục

```text
Project
│
├── Models
├── Views
├── ViewModels
├── Services
├── Reports
├── Database
└── Docs
```

---

## 6. Vai trò người dùng

| Vai trò   | Quyền hạn                          |
| --------- | ---------------------------------- |
| Admin     | Toàn quyền hệ thống                |
| Manager   | Quản lý thuốc, nhập kho, doanh thu |
| Nhân viên | Bán hàng và tra cứu thuốc          |

---

## 7. Kết quả đạt được

* Xây dựng hệ thống quản lý nhà thuốc hoàn chỉnh.
* Áp dụng mô hình MVVM.
* Kết nối cơ sở dữ liệu SQL Server.
* Thực hiện phân quyền người dùng.
* Quản lý nhập kho và bán hàng.
* Thống kê doanh thu.
* Xuất báo cáo hóa đơn và doanh thu.

---

## 8. Hướng phát triển

* Quản lý khách hàng thân thiết.
* Tích hợp mã vạch.
* Tích hợp máy in hóa đơn.
* Đồng bộ dữ liệu Cloud.
* Quản lý hạn sử dụng thuốc tự động.
