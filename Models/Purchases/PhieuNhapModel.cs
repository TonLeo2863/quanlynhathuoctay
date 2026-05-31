using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models.Purchases
{
    public class PhieuNhapModel
    {
        public int MaPhieuNhap { get; set; }
        public int MaNhaCungCap { get; set; }
        public DateTime NgayNhap { get; set; } = DateTime.Now;
        public decimal TongTien { get; set; }
    }
}
