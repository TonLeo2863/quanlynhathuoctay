using PharmacySalesApp.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace PharmacySalesApp.Repositories
{
    public class MedicineRepository
    {
        public List<Medicine> GetAll()
        {
            var medicines = new List<Medicine>();

            string query = @"
                SELECT 
                    t.MaThuoc AS Id,
                    t.MaSoThuoc AS Code,
                    t.TenThuoc AS Name,
                    ISNULL(dvt.TenDonViTinh, N'') AS Unit,
                    ISNULL(nt.TenNhomThuoc, N'') AS Category,
                    ISNULL(hsx.TenHangSanXuat, N'') AS Manufacturer,
                    t.GiaBan AS Price,
                    ISNULL(SUM(tkl.SoLuongTon), 0) AS Quantity
                FROM dbo.Thuoc t
                LEFT JOIN dbo.DonViTinh dvt ON t.MaDonViTinh = dvt.MaDonViTinh
                LEFT JOIN dbo.NhomThuoc nt ON t.MaNhomThuoc = nt.MaNhomThuoc
                LEFT JOIN dbo.HangSanXuat hsx ON t.MaHangSanXuat = hsx.MaHangSanXuat
                LEFT JOIN dbo.TonKhoLo tkl ON t.MaThuoc = tkl.MaThuoc
                WHERE t.DangKinhDoanh = 1
                GROUP BY 
                    t.MaThuoc,
                    t.MaSoThuoc,
                    t.TenThuoc,
                    dvt.TenDonViTinh,
                    nt.TenNhomThuoc,
                    hsx.TenHangSanXuat,
                    t.GiaBan
                ORDER BY t.TenThuoc";

            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            using SqlCommand cmd = new SqlCommand(query, con);
            using SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                medicines.Add(new Medicine
                {
                    Id = Convert.ToInt32(reader["Id"]),
                    Code = reader["Code"].ToString() ?? "",
                    Name = reader["Name"].ToString() ?? "",
                    Unit = reader["Unit"].ToString() ?? "",
                    Category = reader["Category"].ToString() ?? "",
                    Manufacturer = reader["Manufacturer"].ToString() ?? "",
                    Price = Convert.ToDecimal(reader["Price"]),
                    Quantity = Convert.ToInt32(reader["Quantity"]),
                    ImagePath = ""
                });
            }

            return medicines;
        }

        public void Add(Medicine medicine)
        {
            string query = @"
                INSERT INTO dbo.Thuoc
                (
                    MaSoThuoc,
                    TenThuoc,
                    TenNgan,
                    MaNhomThuoc,
                    MaDonViTinh,
                    GiaNhap,
                    GiaBan,
                    PhanTramVAT,
                    TonToiThieu,
                    TonToiDa,
                    DangKinhDoanh
                )
                VALUES
                (
                    @MaSoThuoc,
                    @TenThuoc,
                    @TenNgan,
                    1,
                    1,
                    0,
                    @GiaBan,
                    0,
                    10,
                    1000,
                    1
                )";

            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@MaSoThuoc", medicine.Code);
            cmd.Parameters.AddWithValue("@TenThuoc", medicine.Name);
            cmd.Parameters.AddWithValue("@TenNgan", medicine.Name);
            cmd.Parameters.AddWithValue("@GiaBan", medicine.Price);

            cmd.ExecuteNonQuery();
        }

        public void Update(Medicine medicine)
        {
            string query = @"
                UPDATE dbo.Thuoc
                SET 
                    MaSoThuoc = @MaSoThuoc,
                    TenThuoc = @TenThuoc,
                    TenNgan = @TenNgan,
                    GiaBan = @GiaBan
                WHERE MaThuoc = @MaThuoc";

            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@MaThuoc", medicine.Id);
            cmd.Parameters.AddWithValue("@MaSoThuoc", medicine.Code);
            cmd.Parameters.AddWithValue("@TenThuoc", medicine.Name);
            cmd.Parameters.AddWithValue("@TenNgan", medicine.Name);
            cmd.Parameters.AddWithValue("@GiaBan", medicine.Price);

            cmd.ExecuteNonQuery();
        }

        public void Disable(int medicineId)
        {
            string query = @"
                UPDATE dbo.Thuoc
                SET DangKinhDoanh = 0
                WHERE MaThuoc = @MaThuoc";

            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@MaThuoc", medicineId);

            cmd.ExecuteNonQuery();
        }

        public void ImportStock(int medicineId, string batchNumber, DateTime expiryDate, int quantity, decimal importPrice)
        {
            string query = @"
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
                    1,
                    NULL,
                    @SoLo,
                    @HanSuDung,
                    @SoLuongTon,
                    @DonGiaVon,
                    GETDATE()
                )";

            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@MaThuoc", medicineId);
            cmd.Parameters.AddWithValue("@SoLo", batchNumber);
            cmd.Parameters.AddWithValue("@HanSuDung", expiryDate);
            cmd.Parameters.AddWithValue("@SoLuongTon", quantity);
            cmd.Parameters.AddWithValue("@DonGiaVon", importPrice);

            cmd.ExecuteNonQuery();
        }
    }
}