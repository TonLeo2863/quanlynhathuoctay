using PharmacySalesApp.Models;
using System;
using System.Data.SqlClient;

namespace PharmacySalesApp.Services
{
    public class AuthService
    {
        public User? Login(string username, string password)
        {
            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            string query = @"
                SELECT 
                    nv.MaNhanVien AS Id,
                    tk.TenDangNhap AS Username,
                    nv.HoTen AS Name,
                    vt.TenVaiTro AS Role
                FROM dbo.TaiKhoan tk
                JOIN dbo.NhanVien nv ON tk.MaNhanVien = nv.MaNhanVien
                JOIN dbo.VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro
                WHERE tk.TenDangNhap = @Username
                  AND tk.MatKhauBam = @Password
                  AND tk.BiKhoa = 0";

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Username", username);
            cmd.Parameters.AddWithValue("@Password", password);

            using SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                return new User
                {
                    Id = Convert.ToInt32(reader["Id"]),
                    Username = reader["Username"].ToString() ?? "",
                    Name = reader["Name"].ToString() ?? "",
                    Role = reader["Role"].ToString() ?? ""
                };
            }

            return null;
        }
    }
}