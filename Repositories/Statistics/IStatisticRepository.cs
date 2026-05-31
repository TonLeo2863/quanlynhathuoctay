using PharmacySalesApp.Models.Statistics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Repositories.Statistics
{
    public interface IStatisticRepository
    {
        List<HoaDonBanModel> GetHoaDonTheoKhoangThoiGian(DateTime tuNgay, DateTime denNgay);
    }
}
