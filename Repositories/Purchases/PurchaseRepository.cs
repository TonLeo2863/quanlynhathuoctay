using PharmacySalesApp.Models.Purchases;
using PharmacySalesApp.Repositories.Purchases.quanlynhathuoctay.Models.Purchases;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Repositories.Purchases
{
    public class PurchaseRepository
    {
        // Đảm bảo đổi chuỗi kết nối này khớp với config thực tế trong App.config của bạn
        private readonly string _connectionString = "Data Source=localhost;Initial Catalog=PharmacyDB;Integrated Security=True";

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
                        string insertPhieu = @"INSERT INTO PhieuNhap (MaNhaCungCap, NgayNhap, TongTien) 
                                             OUTPUT INSERTED.MaPhieuNhap 
                                             VALUES (@MaNCC, @NgayNhap, @TongTien)";
                        SqlCommand cmdPhieu = new SqlCommand(insertPhieu, con, transaction);
                        cmdPhieu.Parameters.AddWithValue("@MaNCC", phieuNhap.MaNhaCungCap);
                        cmdPhieu.Parameters.AddWithValue("@NgayNhap", phieuNhap.NgayNhap);
                        cmdPhieu.Parameters.AddWithValue("@TongTien", phieuNhap.TongTien);

                        int newMaPhieuNhap = (int)cmdPhieu.ExecuteScalar();

                        // 2. Lưu Chi Tiết và Cập nhật Tồn Kho
                        foreach (var item in chiTietList)
                        {
                            string insertChiTiet = @"INSERT INTO ChiTietPhieuNhap (MaPhieuNhap, MaThuoc, SoLo, HanSuDung, SoLuong, GiaNhap) 
                                                   VALUES (@MaPhieu, @MaThuoc, @SoLo, @HSD, @SoLuong, @GiaNhap)";
                            SqlCommand cmdChiTiet = new SqlCommand(insertChiTiet, con, transaction);
                            cmdChiTiet.Parameters.AddWithValue("@MaPhieu", newMaPhieuNhap);
                            cmdChiTiet.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                            cmdChiTiet.Parameters.AddWithValue("@SoLo", item.SoLo);
                            cmdChiTiet.Parameters.AddWithValue("@HSD", item.HanSuDung);
                            cmdChiTiet.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                            cmdChiTiet.Parameters.AddWithValue("@GiaNhap", item.GiaNhap);
                            cmdChiTiet.ExecuteNonQuery();

                            // Cập nhật tồn kho (Kiểm tra xem lô đã tồn tại chưa)
                            string checkKho = "SELECT COUNT(1) FROM TonKhoLo WHERE MaThuoc = @MaThuoc AND SoLo = @SoLo";
                            SqlCommand cmdCheckKho = new SqlCommand(checkKho, con, transaction);
                            cmdCheckKho.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                            cmdCheckKho.Parameters.AddWithValue("@SoLo", item.SoLo);

                            int count = (int)cmdCheckKho.ExecuteScalar();

                            if (count > 0)
                            {
                                string updateKho = "UPDATE TonKhoLo SET SoLuong = SoLuong + @SoLuong WHERE MaThuoc = @MaThuoc AND SoLo = @SoLo";
                                SqlCommand cmdUpdate = new SqlCommand(updateKho, con, transaction);
                                cmdUpdate.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                                cmdUpdate.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                                cmdUpdate.Parameters.AddWithValue("@SoLo", item.SoLo);
                                cmdUpdate.ExecuteNonQuery();
                            }
                            else
                            {
                                string insertKho = "INSERT INTO TonKhoLo (MaThuoc, SoLo, HanSuDung, SoLuong) VALUES (@MaThuoc, @SoLo, @HSD, @SoLuong)";
                                SqlCommand cmdInsertKho = new SqlCommand(insertKho, con, transaction);
                                cmdInsertKho.Parameters.AddWithValue("@MaThuoc", item.MaThuoc);
                                cmdInsertKho.Parameters.AddWithValue("@SoLo", item.SoLo);
                                cmdInsertKho.Parameters.AddWithValue("@HSD", item.HanSuDung);
                                cmdInsertKho.Parameters.AddWithValue("@SoLuong", item.SoLuong);
                                cmdInsertKho.ExecuteNonQuery();
                            }
                        }

                        transaction.Commit();
                        return true;
                    }
                    catch (Exception)
                    {
                        transaction.Rollback();
                        return false;
                    }
                }
            }
        }
    }
}
