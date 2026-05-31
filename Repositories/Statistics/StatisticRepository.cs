using PharmacySalesApp.Models.Statistics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Repositories.Statistics
{
    public class StatisticRepository : IStatisticRepository
    {
        // Mock dữ liệu. Hãy thay thế bằng Entity Framework/Dapper query thực tế của bạn
        public List<HoaDonBanModel> GetHoaDonTheoKhoangThoiGian(DateTime tuNgay, DateTime denNgay)
        {
            // Ví dụ kết nối DB:
            // using (var db = new PharmacyDbContext()) {
            //     return db.HoaDonBans.Where(x => x.NgayLap >= tuNgay && x.NgayLap <= denNgay)
            //                         .Select(x => new HoaDonBanModel { ... }).ToList();
            // }

            return new List<HoaDonBanModel>
            {
                new HoaDonBanModel { MaHD = "HD01", NgayLap = DateTime.Now.AddDays(-1), TongTien = 150000, TenKhachHang = "Nguyen Van A" },
                new HoaDonBanModel { MaHD = "HD02", NgayLap = DateTime.Now, TongTien = 300000, TenKhachHang = "Tran Thi B" }
            };
        }
    }
}
