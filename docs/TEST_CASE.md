# TEST CASE HỆ THỐNG QUẢN LÝ NHÀ THUỐC

| TC ID | Chức năng            | Dữ liệu kiểm thử   | Kết quả mong đợi       |
| ----- | -------------------- | ------------------ | ---------------------- |
| TC01  | Đăng nhập            | Tài khoản đúng     | Đăng nhập thành công   |
| TC02  | Đăng nhập            | Sai mật khẩu       | Báo lỗi                |
| TC03  | Đăng nhập            | Bỏ trống tài khoản | Báo bắt buộc nhập      |
| TC04  | Thêm thuốc           | Dữ liệu hợp lệ     | Thêm thành công        |
| TC05  | Thêm thuốc           | Trùng mã thuốc     | Báo lỗi                |
| TC06  | Sửa thuốc            | Dữ liệu hợp lệ     | Cập nhật thành công    |
| TC07  | Xóa thuốc            | Thuốc tồn tại      | Xóa thành công         |
| TC08  | Tìm kiếm thuốc       | Tên thuốc          | Hiển thị kết quả       |
| TC09  | Tạo phiếu nhập       | Dữ liệu hợp lệ     | Lưu thành công         |
| TC10  | Tạo phiếu nhập       | Số lượng âm        | Báo lỗi                |
| TC11  | Thêm vào giỏ hàng    | Thuốc còn hàng     | Thêm thành công        |
| TC12  | Thêm vào giỏ hàng    | Vượt tồn kho       | Báo lỗi                |
| TC13  | Thanh toán           | Dữ liệu hợp lệ     | Sinh hóa đơn           |
| TC14  | Thanh toán           | Giỏ hàng rỗng      | Báo lỗi                |
| TC15  | In hóa đơn           | Hóa đơn tồn tại    | In thành công          |
| TC16  | Xem doanh thu        | Chọn ngày          | Hiển thị doanh thu     |
| TC17  | Xem doanh thu        | Chọn tháng         | Hiển thị doanh thu     |
| TC18  | Xuất report          | Dữ liệu tồn tại    | Xuất report thành công |
| TC19  | Phân quyền Admin     | Truy cập toàn bộ   | Thành công             |
| TC20  | Phân quyền Nhân viên | Truy cập quản trị  | Từ chối                |
