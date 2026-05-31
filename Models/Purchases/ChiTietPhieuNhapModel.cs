using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models.Purchases
{
    public class ChiTietPhieuNhapModel
    {
        public int MaThuoc { get; set; }
        public string TenThuoc { get; set; }
        public string SoLo { get; set; }
        public DateTime HanSuDung { get; set; }
        public int SoLuong { get; set; }
        public decimal GiaNhap { get; set; }
        public decimal ThanhTien => SoLuong * GiaNhap;
    }
}
