using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models.Statistics
{
    public class DoanhThuThongKeModel
    {
        public string ThoiGian { get; set; } // Ngày hoặc Tháng
        public int SoLuongHoaDon { get; set; }
        public decimal TongDoanhThu { get; set; }
    }
}
