using PharmacySalesApp.Models.Purchases;
using PharmacySalesApp.Repositories.Purchases;
using PharmacySalesApp.ViewModels;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace PharmacySalesApp.Repositories.Purchases
{
    public class PurchaseRepository
    {
        // Đảm bảo đổi chuỗi kết nối này khớp với config thực tế trong App.config của bạn
        private readonly string _connectionString = App.ConnectionString;

        public List<NhaCungCapModel> GetNhaCungCaps()
        {
            var list = new List<NhaCungCapModel>();
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT MaNhaCungCap, TenNhaCungCap FROM NhaCungCap", con))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new NhaCungCapModel
                        {
                            MaNhaCungCap = reader.GetInt32(0),
                            TenNhaCungCap = reader.GetString(1)
                        });
                    }
                }
            }
            return list;
        }

        public List<ThuocModel> GetThuocs()
        {
            var list = new List<ThuocModel>();
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT MaThuoc, TenThuoc FROM Thuoc", con))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new ThuocModel
                        {
                            MaThuoc = reader.GetInt32(0),
                            TenThuoc = reader.GetString(1)
                        });
                    }
                }
            }
            return list;
        }

        public bool SavePhieuNhap(PhieuNhapModel phieuNhap, List<ChiTietPhieuNhapModel> chiTietList)
        {
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                con.Open();
                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Lưu Phiếu Nhập
                        string maSoPhieuNhap = "PN" + DateTime.Now.ToString("yyyyMMddHHmmss");

                        string insertPhieu = @"
    INSERT INTO dbo.PhieuNhap
    (
        MaSoPhieuNhap,
        MaNhaCungCap,
        MaChiNhanh,
        MaNhanVien,
        NgayNhap,
        TongTien
    )
    OUTPUT INSERTED.MaPhieuNhap
    VALUES
    (
        @MaSoPhieuNhap,
        @MaNCC,
        @MaChiNhanh,
        @MaNhanVien,
        @NgayNhap,
        @TongTien
    )";

                        SqlCommand cmdPhieu = new SqlCommand(insertPhieu, con, transaction);
                        cmdPhieu.Parameters.AddWithValue("@MaSoPhieuNhap", maSoPhieuNhap);
                        cmdPhieu.Parameters.AddWithValue("@MaNCC", phieuNhap.MaNhaCungCap);
                        cmdPhieu.Parameters.AddWithValue("@MaChiNhanh", 1);
                        cmdPhieu.Parameters.AddWithValue("@MaNhanVien", AppSession.CurrentUser?.Id ?? 1);
                        cmdPhieu.Parameters.AddWithValue("@NgayNhap", DateTime.Now);
                        cmdPhieu.Parameters.AddWithValue("@TongTien", phieuNhap.TongTien);

                        int newMaPhieuNhap = Convert.ToInt32(cmdPhieu.ExecuteScalar());

                        // 2. Lưu Chi Tiết và Cập nhật Tồn Kho
                        foreach (var item in chiTietList)
                        {
                            string insertChiTiet = @"
    INSERT INTO dbo.ChiTietPhieuNhap
    (
        MaPhieuNhap,
        MaThuoc,
        SoLo,
        HanSuDung,
        SoLuong,
        DonGiaNhap
    )
    VALUES
    (
        @MaPhieu,
        @MaThuoc,
        @SoLo,
        @HSD,
        @SoLuong,
        @GiaNhap
    )";
                            SqlCommand cmdChiTiet = new SqlCommand(insertChiTiet, con, transaction);
                            cmdChiTiet.Parameters.AddWithValue("@MaPhieu", newMaPhieuNhap);
                            cmdChiTiet.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                            cmdChiTiet.Parameters.AddWithValue("@SoLo", item.SoLo);
                            cmdChiTiet.Parameters.AddWithValue("@HSD", item.HanSuDung);
                            cmdChiTiet.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                            cmdChiTiet.Parameters.AddWithValue("@GiaNhap", item.GiaNhap);
                            cmdChiTiet.ExecuteNonQuery();
                            string updateThuoc = @"
UPDATE Thuoc
SET SoLuongTon = SoLuongTon + @SoLuong
WHERE MaThuoc = @MaThuoc";

                            SqlCommand cmdUpdate = new SqlCommand(updateThuoc, con, transaction);

                            cmdUpdate.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                            cmdUpdate.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);

                            cmdUpdate.ExecuteNonQuery();

                            // Cập nhật tồn kho (Kiểm tra xem lô đã tồn tại chưa)
                            string checkKho = "SELECT COUNT(1) FROM TonKhoLo WHERE MaThuoc = @MaThuoc AND SoLo = @SoLo";
                            SqlCommand cmdCheckKho = new SqlCommand(checkKho, con, transaction);
                            cmdCheckKho.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                            cmdCheckKho.Parameters.AddWithValue("@SoLo", item.SoLo);

                            int count = (int)cmdCheckKho.ExecuteScalar();

                            if (count > 0)
                            {
                                string updateKho = @"
                                UPDATE dbo.TonKhoLo
                                SET SoLuongTon = SoLuongTon + @SoLuong
                                WHERE MaThuoc = @MaThuoc AND SoLo = @SoLo"; SqlCommand cmdUpdateKho = new SqlCommand(updateKho, con, transaction);
                                cmdUpdateKho.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                                cmdUpdateKho.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                                cmdUpdateKho.Parameters.AddWithValue("@SoLo", item.SoLo);
                                cmdUpdateKho.ExecuteNonQuery();
                            }
                            else
                            {
                                string insertKho = @"
                                INSERT INTO dbo.TonKhoLo
                                (
                                    MaThuoc,
                                    MaChiNhanh,
                                    SoLo,
                                    HanSuDung,
                                    SoLuongTon,
                                    DonGiaVon
                                )
                                VALUES
                                (
                                    @MaThuoc,
                                    @MaChiNhanh,
                                    @SoLo,
                                    @HSD,
                                    @SoLuong,
                                    @GiaNhap
                                )"; SqlCommand cmdInsertKho = new SqlCommand(insertKho, con, transaction);
                                cmdInsertKho.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                                cmdInsertKho.Parameters.AddWithValue("@SoLo", item.SoLo);
                                cmdInsertKho.Parameters.AddWithValue("@HSD", item.HanSuDung);
                                cmdInsertKho.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                                cmdInsertKho.Parameters.AddWithValue("@MaChiNhanh", 1);
                                cmdInsertKho.Parameters.AddWithValue("@GiaNhap", item.GiaNhap);
                                cmdInsertKho.ExecuteNonQuery();
                            }
                        }

                        transaction.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        MessageBox.Show(ex.Message);
                        return false;
                    }
                }
            }
        }
    }
}
