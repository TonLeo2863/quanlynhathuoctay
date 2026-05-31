using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models.Statistics
{
    public class HoaDonBanModel
    {
        public string MaHD { get; set; }
        public DateTime NgayLap { get; set; }
        public decimal TongTien { get; set; }
        public string TenKhachHang { get; set; }
    }
}
