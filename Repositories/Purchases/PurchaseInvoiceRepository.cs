using PharmacySalesApp.Models.Purchases;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace PharmacySalesApp.Repositories.Purchases
{
    public class PurchaseInvoiceRepository
    {
        public List<SupplierOption> GetSuppliers()
        {
            var result = new List<SupplierOption>();

            string query = @"
                SELECT MaNhaCungCap, MaSoNhaCungCap, TenNhaCungCap
                FROM dbo.NhaCungCap
                WHERE DangHopTac = 1
                ORDER BY TenNhaCungCap";

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new SupplierOption
                        {
                            Id = Convert.ToInt32(reader["MaNhaCungCap"]),
                            Code = reader["MaSoNhaCungCap"].ToString() ?? "",
                            Name = reader["TenNhaCungCap"].ToString() ?? ""
                        });
                    }
                }
            }

            return result;
        }

        public List<MedicineOption> GetMedicines()
        {
            var result = new List<MedicineOption>();

            string query = @"
                SELECT MaThuoc, MaSoThuoc, TenThuoc, GiaNhap
                FROM dbo.Thuoc
                WHERE DangKinhDoanh = 1
                ORDER BY TenThuoc";

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new MedicineOption
                        {
                            Id = Convert.ToInt32(reader["MaThuoc"]),
                            Code = reader["MaSoThuoc"].ToString() ?? "",
                            Name = reader["TenThuoc"].ToString() ?? "",
                            ImportPrice = Convert.ToDecimal(reader["GiaNhap"])
                        });
                    }
                }
            }

            return result;
        }

        public string SavePurchaseInvoice(
            int supplierId,
            int branchId,
            int employeeId,
            List<PurchaseInvoiceLine> lines,
            string note)
        {
            if (lines == null || lines.Count == 0)
                throw new Exception("Phiếu nhập chưa có chi tiết thuốc.");

            string purchaseCode = "PN" + DateTime.Now.ToString("yyyyMMddHHmmss");
            decimal totalAmount = 0;

            foreach (var line in lines)
                totalAmount += line.Total;

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                con.Open();

                using (SqlTransaction tran = con.BeginTransaction())
                {
                    try
                    {
                        int purchaseId = InsertPurchaseInvoice(
                            con,
                            tran,
                            purchaseCode,
                            supplierId,
                            branchId,
                            employeeId,
                            totalAmount,
                            note);

                        foreach (var line in lines)
                        {
                            int detailId = InsertPurchaseInvoiceDetail(con, tran, purchaseId, line);
                            UpsertStockBatch(con, tran, branchId, employeeId, line, detailId);
                        }

                        tran.Commit();
                        return purchaseCode;
                    }
                    catch
                    {
                        tran.Rollback();
                        throw;
                    }
                }
            }
        }

        private int InsertPurchaseInvoice(
            SqlConnection con,
            SqlTransaction tran,
            string purchaseCode,
            int supplierId,
            int branchId,
            int employeeId,
            decimal totalAmount,
            string note)
        {
            string query = @"
                INSERT INTO dbo.PhieuNhap
                (
                    MaSoPhieuNhap,
                    MaNhaCungCap,
                    MaChiNhanh,
                    MaNhanVien,
                    NgayNhap,
                    TrangThai,
                    TongTien,
                    GhiChu
                )
                OUTPUT INSERTED.MaPhieuNhap
                VALUES
                (
                    @MaSoPhieuNhap,
                    @MaNhaCungCap,
                    @MaChiNhanh,
                    @MaNhanVien,
                    SYSDATETIME(),
                    N'Da nhap',
                    @TongTien,
                    @GhiChu
                )";

            using (SqlCommand cmd = new SqlCommand(query, con, tran))
            {
                cmd.Parameters.AddWithValue("@MaSoPhieuNhap", purchaseCode);
                cmd.Parameters.AddWithValue("@MaNhaCungCap", supplierId);
                cmd.Parameters.AddWithValue("@MaChiNhanh", branchId);
                cmd.Parameters.AddWithValue("@MaNhanVien", employeeId);
                cmd.Parameters.AddWithValue("@TongTien", totalAmount);
                cmd.Parameters.AddWithValue("@GhiChu", string.IsNullOrWhiteSpace(note) ? DBNull.Value : (object)note);

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private int InsertPurchaseInvoiceDetail(
            SqlConnection con,
            SqlTransaction tran,
            int purchaseId,
            PurchaseInvoiceLine line)
        {
            string query = @"
                INSERT INTO dbo.ChiTietPhieuNhap
                (
                    MaPhieuNhap,
                    MaThuoc,
                    SoLo,
                    NgaySanXuat,
                    HanSuDung,
                    SoLuong,
                    DonGiaNhap,
                    TienGiam
                )
                OUTPUT INSERTED.MaChiTietPhieuNhap
                VALUES
                (
                    @MaPhieuNhap,
                    @MaThuoc,
                    @SoLo,
                    NULL,
                    @HanSuDung,
                    @SoLuong,
                    @DonGiaNhap,
                    0
                )";

            using (SqlCommand cmd = new SqlCommand(query, con, tran))
            {
                cmd.Parameters.AddWithValue("@MaPhieuNhap", purchaseId);
                cmd.Parameters.AddWithValue("@MaThuoc", line.MedicineId);
                cmd.Parameters.AddWithValue("@SoLo", line.BatchNumber);
                cmd.Parameters.AddWithValue("@HanSuDung", line.ExpiryDate.Date);
                cmd.Parameters.AddWithValue("@SoLuong", line.Quantity);
                cmd.Parameters.AddWithValue("@DonGiaNhap", line.ImportPrice);

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void UpsertStockBatch(
            SqlConnection con,
            SqlTransaction tran,
            int branchId,
            int employeeId,
            PurchaseInvoiceLine line,
            int detailId)
        {
            string query = @"
                IF EXISTS
                (
                    SELECT 1
                    FROM dbo.TonKhoLo
                    WHERE MaThuoc = @MaThuoc
                      AND MaChiNhanh = @MaChiNhanh
                      AND SoLo = @SoLo
                      AND HanSuDung = @HanSuDung
                )
                BEGIN
                    UPDATE dbo.TonKhoLo
                    SET SoLuongTon = SoLuongTon + @SoLuong,
                        DonGiaVon = @DonGiaVon
                    WHERE MaThuoc = @MaThuoc
                      AND MaChiNhanh = @MaChiNhanh
                      AND SoLo = @SoLo
                      AND HanSuDung = @HanSuDung
                END
                ELSE
                BEGIN
                    INSERT INTO dbo.TonKhoLo
                    (
                        MaThuoc,
                        MaChiNhanh,
                        MaChiTietPhieuNhap,
                        SoLo,
                        HanSuDung,
                        SoLuongTon,
                        DonGiaVon,
                        NgayNhanHang
                    )
                    VALUES
                    (
                        @MaThuoc,
                        @MaChiNhanh,
                        @MaChiTietPhieuNhap,
                        @SoLo,
                        @HanSuDung,
                        @SoLuong,
                        @DonGiaVon,
                        SYSDATETIME()
                    )
                END

                INSERT INTO dbo.GiaoDichKho
                (
                    MaThuoc,
                    MaChiNhanh,
                    MaTonKhoLo,
                    LoaiGiaoDich,
                    SoLuongThayDoi,
                    LoaiChungTu,
                    MaChungTu,
                    GhiChu,
                    MaNhanVienTao,
                    NgayTao
                )
                SELECT TOP 1
                    @MaThuoc,
                    @MaChiNhanh,
                    MaTonKhoLo,
                    N'Nhap kho',
                    @SoLuong,
                    N'PhieuNhap',
                    @MaChiTietPhieuNhap,
                    N'Nhập kho từ phiếu nhập hàng',
                    @MaNhanVienTao,
                    SYSDATETIME()
                FROM dbo.TonKhoLo
                WHERE MaThuoc = @MaThuoc
                  AND MaChiNhanh = @MaChiNhanh
                  AND SoLo = @SoLo
                  AND HanSuDung = @HanSuDung";

            using (SqlCommand cmd = new SqlCommand(query, con, tran))
            {
                cmd.Parameters.AddWithValue("@MaThuoc", line.MedicineId);
                cmd.Parameters.AddWithValue("@MaChiNhanh", branchId);
                cmd.Parameters.AddWithValue("@MaChiTietPhieuNhap", detailId);
                cmd.Parameters.AddWithValue("@SoLo", line.BatchNumber);
                cmd.Parameters.AddWithValue("@HanSuDung", line.ExpiryDate.Date);
                cmd.Parameters.AddWithValue("@SoLuong", line.Quantity);
                cmd.Parameters.AddWithValue("@DonGiaVon", line.ImportPrice);
                cmd.Parameters.AddWithValue("@MaNhanVienTao", employeeId);

                cmd.ExecuteNonQuery();
            }
        }
    }
}