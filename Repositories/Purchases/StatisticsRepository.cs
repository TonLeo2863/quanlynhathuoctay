using PharmacySalesApp.Models.Statistics;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace PharmacySalesApp.Repositories.Statistics
{
    public class StatisticsRepository
    {
        public List<RevenueInvoiceRow> GetRevenueInvoices(DateTime fromDate, DateTime toDate)
        {
            var result = new List<RevenueInvoiceRow>();

            string query = @"
                SELECT 
                    hdb.MaSoHoaDon,
                    hdb.NgayBan,
                    ISNULL(nv.HoTen, N'') AS TenNhanVien,
                    ISNULL(kh.HoTen, N'Khách lẻ') AS TenKhachHang,
                    hdb.TongThanhToan,
                    ISNULL(hdb.GhiChu, N'') AS GhiChu
                FROM dbo.HoaDonBan hdb
                LEFT JOIN dbo.NhanVien nv ON hdb.MaNhanVien = nv.MaNhanVien
                LEFT JOIN dbo.KhachHang kh ON hdb.MaKhachHang = kh.MaKhachHang
                WHERE hdb.NgayBan >= @FromDate
                  AND hdb.NgayBan < DATEADD(DAY, 1, @ToDate)
                ORDER BY hdb.NgayBan DESC";

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@FromDate", fromDate.Date);
                cmd.Parameters.AddWithValue("@ToDate", toDate.Date);

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new RevenueInvoiceRow
                        {
                            InvoiceCode = reader["MaSoHoaDon"].ToString() ?? "",
                            CreatedDate = Convert.ToDateTime(reader["NgayBan"]),
                            EmployeeName = reader["TenNhanVien"].ToString() ?? "",
                            CustomerName = reader["TenKhachHang"].ToString() ?? "",
                            TotalAmount = Convert.ToDecimal(reader["TongThanhToan"]),
                            Note = reader["GhiChu"].ToString() ?? ""
                        });
                    }
                }
            }

            return result;
        }

        public List<RevenueByDate> GetRevenueByDate(DateTime fromDate, DateTime toDate)
        {
            var result = new List<RevenueByDate>();

            string query = @"
                SELECT 
                    CAST(NgayBan AS DATE) AS Ngay,
                    COUNT(*) AS SoHoaDon,
                    SUM(TongThanhToan) AS DoanhThu
                FROM dbo.HoaDonBan
                WHERE NgayBan >= @FromDate
                  AND NgayBan < DATEADD(DAY, 1, @ToDate)
                GROUP BY CAST(NgayBan AS DATE)
                ORDER BY Ngay";

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@FromDate", fromDate.Date);
                cmd.Parameters.AddWithValue("@ToDate", toDate.Date);

                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        result.Add(new RevenueByDate
                        {
                            Date = Convert.ToDateTime(reader["Ngay"]),
                            InvoiceCount = Convert.ToInt32(reader["SoHoaDon"]),
                            TotalRevenue = Convert.ToDecimal(reader["DoanhThu"])
                        });
                    }
                }
            }

            return result;
        }
    }
}