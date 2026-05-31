using PharmacySalesApp.Commands;
using PharmacySalesApp.Models.Statistics;
using PharmacySalesApp.Repositories.Statistics;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace PharmacySalesApp.ViewModels.Statistics
{
    public class ThongKeDoanhThuViewModel : BaseViewModel
    {
        private readonly IStatisticRepository _repo;

        private DateTime _tuNgay = DateTime.Now.AddDays(-30);
        public DateTime TuNgay
        {
            get => _tuNgay;
            set { _tuNgay = value; OnPropertyChanged(); }
        }

        private DateTime _denNgay = DateTime.Now;
        public DateTime DenNgay
        {
            get => _denNgay;
            set { _denNgay = value; OnPropertyChanged(); }
        }

        private int _tongSoHoaDon;
        public int TongSoHoaDon
        {
            get => _tongSoHoaDon;
            set { _tongSoHoaDon = value; OnPropertyChanged(); }
        }

        private decimal _tongDoanhThu;
        public decimal TongDoanhThu
        {
            get => _tongDoanhThu;
            set { _tongDoanhThu = value; OnPropertyChanged(); }
        }

        public ObservableCollection<HoaDonBanModel> DanhSachHoaDon { get; set; } = new ObservableCollection<HoaDonBanModel>();
        public ObservableCollection<DoanhThuThongKeModel> DanhSachGomNhom { get; set; } = new ObservableCollection<DoanhThuThongKeModel>();

        public ICommand ThongKeCommand { get; }

        public ThongKeDoanhThuViewModel()
        {
            _repo = new StatisticRepository();
            ThongKeCommand = new RelayCommand(ExecuteThongKe);
            ExecuteThongKe(null);
        }

        private void ExecuteThongKe(object obj)
        {
            var data = _repo.GetHoaDonTheoKhoangThoiGian(TuNgay.Date, DenNgay.Date.AddDays(1).AddTicks(-1));

            DanhSachHoaDon.Clear();
            foreach (var item in data) DanhSachHoaDon.Add(item);

            TongSoHoaDon = data.Count;
            TongDoanhThu = data.Sum(x => x.TongTien);

            // Gom nhóm theo ngày
            var groupedData = data.GroupBy(x => x.NgayLap.Date)
                                  .Select(g => new DoanhThuThongKeModel
                                  {
                                      ThoiGian = g.Key.ToString("dd/MM/yyyy"),
                                      SoLuongHoaDon = g.Count(),
                                      TongDoanhThu = g.Sum(x => x.TongTien)
                                  }).ToList();

            DanhSachGomNhom.Clear();
            foreach (var item in groupedData) DanhSachGomNhom.Add(item);
        }
    }
}
