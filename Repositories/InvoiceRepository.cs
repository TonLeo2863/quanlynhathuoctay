using PharmacySalesApp.Models;
using System;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.SqlClient;

namespace PharmacySalesApp.Repositories
{
    public class InvoiceRepository
    {
        public void CreateInvoice(
                                    ObservableCollection<CartItem> cartItems,
                                    decimal totalAmount,
                                    string note,
                                    int createdBy,
                                    int? maKhachHang)
        {
            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            using SqlTransaction tran = con.BeginTransaction();

            try
            {
                int invoiceId = CreateInvoiceHeader(con, tran, totalAmount, note, createdBy, maKhachHang);

                foreach (var item in cartItems)
                {
                    int medicineId = GetMedicineIdByName(con, tran, item.Name);
                    decimal unitPrice = item.TotalPrice / item.Quantity;

                    CheckEnoughStock(con, tran, medicineId, item.Quantity, item.Name);

                    DeductStockAndInsertDetailsByFEFO(
                        con,
                        tran,
                        invoiceId,
                        medicineId,
                        item.Quantity,
                        unitPrice
                    );
                }

                tran.Commit();
            }
            catch
            {
                tran.Rollback();
                throw;
            }
        }

        private int CreateInvoiceHeader(SqlConnection con, SqlTransaction tran, decimal totalAmount, string note, int createdBy, int? maKhachHang)
        {
            string sql = @"
                INSERT INTO dbo.HoaDonBan
                (
                    MaSoHoaDon,
                    MaChiNhanh,
                    MaKhachHang,
                    MaNhanVien,
                    MaCaLamViec,
                    NgayBan,
                    TrangThai,
                    TongTienHang,
                    TienGiamGia,
                    TienVAT,
                    TongThanhToan,
                    GhiChu
                )
                OUTPUT INSERTED.MaHoaDon
                VALUES
                (
                    @MaSoHoaDon,
                    1,
                    NULL,
                    @MaNhanVien,
                    NULL,
                    GETDATE(),
                    N'Da thanh toan',
                    @TongTienHang,
                    0,
                    0,
                    @TongThanhToan,
                    @GhiChu
                )";

            using SqlCommand cmd = new SqlCommand(sql, con, tran);
            cmd.Parameters.AddWithValue("@MaSoHoaDon", "HD" + DateTime.Now.ToString("yyyyMMddHHmmss"));
            cmd.Parameters.AddWithValue("@MaNhanVien", createdBy);
            cmd.Parameters.AddWithValue("@TongTienHang", totalAmount);
            cmd.Parameters.AddWithValue("@TongThanhToan", totalAmount);
            cmd.Parameters.AddWithValue("@GhiChu", note ?? "");
            cmd.Parameters.Add("@MaKhachHang", SqlDbType.Int).Value =
         maKhachHang.HasValue ? maKhachHang.Value : DBNull.Value;

            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        private int GetMedicineIdByName(SqlConnection con, SqlTransaction tran, string medicineName)
        {
            string sql = @"
                SELECT TOP 1 MaThuoc
                FROM dbo.Thuoc
                WHERE TenThuoc = @TenThuoc
                  AND DangKinhDoanh = 1";

            using SqlCommand cmd = new SqlCommand(sql, con, tran);
            cmd.Parameters.AddWithValue("@TenThuoc", medicineName);

            object? result = cmd.ExecuteScalar();

            if (result == null)
                throw new Exception("Không tìm thấy thuốc: " + medicineName);

            return Convert.ToInt32(result);
        }

        private void CheckEnoughStock(SqlConnection con, SqlTransaction tran, int medicineId, int quantityNeed, string medicineName)
        {
            string sql = @"
                SELECT ISNULL(SUM(SoLuongTon), 0)
                FROM dbo.TonKhoLo
                WHERE MaThuoc = @MaThuoc
                  AND SoLuongTon > 0
                  AND HanSuDung >= CAST(GETDATE() AS DATE)";

            using SqlCommand cmd = new SqlCommand(sql, con, tran);
            cmd.Parameters.AddWithValue("@MaThuoc", medicineId);

            int currentStock = Convert.ToInt32(cmd.ExecuteScalar());

            if (currentStock < quantityNeed)
                throw new Exception($"Không đủ tồn kho cho thuốc '{medicineName}'. Còn {currentStock}, cần {quantityNeed}.");
        }

        private void DeductStockAndInsertDetailsByFEFO(
            SqlConnection con,
            SqlTransaction tran,
            int invoiceId,
            int medicineId,
            int quantityNeed,
            decimal unitPrice)
        {
            string selectLotsSql = @"
                SELECT MaTonKhoLo, SoLuongTon
                FROM dbo.TonKhoLo
                WHERE MaThuoc = @MaThuoc
                  AND SoLuongTon > 0
                  AND HanSuDung >= CAST(GETDATE() AS DATE)
                ORDER BY HanSuDung ASC, NgayNhanHang ASC";

            using SqlCommand selectCmd = new SqlCommand(selectLotsSql, con, tran);
            selectCmd.Parameters.AddWithValue("@MaThuoc", medicineId);

            DataTable lots = new DataTable();

            using (SqlDataAdapter adapter = new SqlDataAdapter(selectCmd))
            {
                adapter.Fill(lots);
            }

            int remaining = quantityNeed;

            foreach (DataRow row in lots.Rows)
            {
                if (remaining <= 0)
                    break;

                int lotId = Convert.ToInt32(row["MaTonKhoLo"]);
                int lotQuantity = Convert.ToInt32(row["SoLuongTon"]);
                int deduct = Math.Min(remaining, lotQuantity);
                decimal lineTotal = deduct * unitPrice;

                InsertInvoiceDetail(con, tran, invoiceId, medicineId, lotId, deduct, unitPrice, lineTotal);
                UpdateLotQuantity(con, tran, lotId, deduct);

                remaining -= deduct;
            }

            if (remaining > 0)
                throw new Exception("Không đủ tồn kho để trừ theo FEFO.");
        }

        private void InsertInvoiceDetail(
            SqlConnection con,
            SqlTransaction tran,
            int invoiceId,
            int medicineId,
            int lotId,
            int quantity,
            decimal unitPrice,
            decimal lineTotal)
        {
            string sql = @"
                INSERT INTO dbo.ChiTietHoaDon
                (
                    MaHoaDon,
                    MaThuoc,
                    MaTonKhoLo,
                    MaKhuyenMai,
                    SoLuong,
                    DonGiaBan,
                    TienGiam
                    
                )
                VALUES
                (
                    @MaHoaDon,
                    @MaThuoc,
                    @MaTonKhoLo,
                    NULL,
                    @SoLuong,
                    @DonGiaBan,
                    0
                    
                )";

            using SqlCommand cmd = new SqlCommand(sql, con, tran);
            cmd.Parameters.AddWithValue("@MaHoaDon", invoiceId);
            cmd.Parameters.AddWithValue("@MaThuoc", medicineId);
            cmd.Parameters.AddWithValue("@MaTonKhoLo", lotId);
            cmd.Parameters.AddWithValue("@SoLuong", quantity);
            cmd.Parameters.AddWithValue("@DonGiaBan", unitPrice);
            

            cmd.ExecuteNonQuery();
        }

        private void UpdateLotQuantity(SqlConnection con, SqlTransaction tran, int lotId, int quantity)
        {
            string sql = @"
                UPDATE dbo.TonKhoLo
                SET SoLuongTon = SoLuongTon - @SoLuongTru
                WHERE MaTonKhoLo = @MaTonKhoLo";

            using SqlCommand cmd = new SqlCommand(sql, con, tran);
            cmd.Parameters.AddWithValue("@SoLuongTru", quantity);
            cmd.Parameters.AddWithValue("@MaTonKhoLo", lotId);

            cmd.ExecuteNonQuery();
        }
    }
}