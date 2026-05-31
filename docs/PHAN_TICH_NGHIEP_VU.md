# PHÂN TÍCH NGHIỆP VỤ HỆ THỐNG QUẢN LÝ NHÀ THUỐC

## 1. Mô tả bài toán

Trong hoạt động kinh doanh nhà thuốc, việc quản lý thuốc, tồn kho, nhập hàng và bán hàng thường được thực hiện với số lượng lớn dữ liệu.

Nếu quản lý thủ công sẽ dễ xảy ra:

* Sai sót khi tính toán
* Thất thoát hàng hóa
* Khó kiểm soát doanh thu
* Khó thống kê báo cáo

Do đó cần xây dựng hệ thống quản lý nhà thuốc nhằm tự động hóa các nghiệp vụ.

---

## 2. Các tác nhân trong hệ thống

### Admin

* Quản lý tài khoản
* Phân quyền người dùng
* Theo dõi toàn bộ hệ thống

### Manager

* Quản lý thuốc
* Quản lý nhập kho
* Xem thống kê
* Xuất báo cáo

### Nhân viên

* Bán hàng
* Lập hóa đơn
* Tra cứu thuốc

---

## 3. Danh sách chức năng

| STT | Chức năng          | Mô tả                |
| --- | ------------------ | -------------------- |
| 1   | Đăng nhập          | Xác thực người dùng  |
| 2   | Quản lý tài khoản  | CRUD tài khoản       |
| 3   | Quản lý thuốc      | CRUD thuốc           |
| 4   | Tìm kiếm thuốc     | Theo mã, tên         |
| 5   | Nhập kho           | Tạo phiếu nhập       |
| 6   | Bán hàng           | Tạo hóa đơn bán      |
| 7   | Giỏ hàng           | Quản lý sản phẩm mua |
| 8   | In hóa đơn         | Xuất hóa đơn         |
| 9   | Thống kê doanh thu | Tổng hợp doanh thu   |
| 10  | Báo cáo            | Xuất report          |

---

## 4. Quy trình nhập kho

1. Manager tạo phiếu nhập.
2. Chọn thuốc cần nhập.
3. Nhập số lượng.
4. Nhập đơn giá.
5. Lưu phiếu nhập.
6. Hệ thống cập nhật tồn kho.

---

## 5. Quy trình bán hàng

1. Nhân viên chọn thuốc.
2. Thêm vào giỏ hàng.
3. Nhập số lượng mua.
4. Hệ thống tính tổng tiền.
5. Thanh toán.
6. Sinh hóa đơn.
7. Trừ tồn kho.

---

## 6. Quy trình thống kê

1. Người dùng chọn khoảng thời gian.
2. Hệ thống lấy dữ liệu hóa đơn.
3. Tổng hợp doanh thu.
4. Hiển thị báo cáo.

---

## 7. Các thực thể dữ liệu

### User

* UserId
* Username
* Password
* Role

### Medicine

* MedicineId
* MedicineName
* Unit
* Price
* Quantity
* ExpiredDate

### ImportInvoice

* ImportId
* ImportDate
* TotalAmount

### SalesInvoice

* InvoiceId
* InvoiceDate
* TotalAmount

### InvoiceDetail

* InvoiceDetailId
* Quantity
* UnitPrice
* Amount

---

## 8. Yêu cầu phi chức năng

* Giao diện dễ sử dụng.
* Dữ liệu chính xác.
* Bảo mật đăng nhập.
* Hiệu năng ổn định.
* Dễ bảo trì và mở rộng.

---

## 9. Kiến trúc MVVM

### Model

Quản lý dữ liệu và thao tác với cơ sở dữ liệu.

### View

Hiển thị giao diện.

### ViewModel

Xử lý nghiệp vụ và binding dữ liệu.
