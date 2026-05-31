using PharmacySalesApp.Models.Purchases;
using PharmacySalesApp.Repositories.Purchases;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace PharmacySalesApp.ViewModels.Purchases
{
    public class PurchaseViewModel : INotifyPropertyChanged
    {
        private readonly PurchaseRepository _repository;

        public ObservableCollection<NhaCungCapModel> NhaCungCaps { get; set; }
        public ObservableCollection<ThuocModel> Thuocs { get; set; }
        public ObservableCollection<ChiTietPhieuNhapModel> DanhSachChiTiet { get; set; }

        private NhaCungCapModel _selectedNhaCungCap;
        public NhaCungCapModel SelectedNhaCungCap
        {
            get => _selectedNhaCungCap;
            set { _selectedNhaCungCap = value; OnPropertyChanged(nameof(SelectedNhaCungCap)); }
        }

        private ThuocModel _selectedThuoc;
        public ThuocModel SelectedThuoc
        {
            get => _selectedThuoc;
            set { _selectedThuoc = value; OnPropertyChanged(nameof(SelectedThuoc)); }
        }

        private string _soLo;
        public string SoLo
        {
            get => _soLo;
            set { _soLo = value; OnPropertyChanged(nameof(SoLo)); }
        }

        private DateTime _hanSuDung = DateTime.Now.AddMonths(1);
        public DateTime HanSuDung
        {
            get => _hanSuDung;
            set { _hanSuDung = value; OnPropertyChanged(nameof(HanSuDung)); }
        }

        private string _soLuong;
        public string SoLuong
        {
            get => _soLuong;
            set { _soLuong = value; OnPropertyChanged(nameof(SoLuong)); }
        }

        private string _giaNhap;
        public string GiaNhap
        {
            get => _giaNhap;
            set { _giaNhap = value; OnPropertyChanged(nameof(GiaNhap)); }
        }

        private decimal _tongTien;
        public decimal TongTien
        {
            get => _tongTien;
            set { _tongTien = value; OnPropertyChanged(nameof(TongTien)); }
        }

        public ICommand ThemThuocCommand { get; }
        public ICommand LuuPhieuNhapCommand { get; }

        public PurchaseViewModel()
        {
            _repository = new PurchaseRepository();
            DanhSachChiTiet = new ObservableCollection<ChiTietPhieuNhapModel>();

            LoadData();

            ThemThuocCommand = new RelayCommand(ThemThuoc);
            LuuPhieuNhapCommand = new RelayCommand(LuuPhieuNhap);
        }

        private void LoadData()
        {
            try
            {
                NhaCungCaps = new ObservableCollection<NhaCungCapModel>(_repository.GetNhaCungCaps());
                Thuocs = new ObservableCollection<ThuocModel>(_repository.GetThuocs());

                OnPropertyChanged(nameof(NhaCungCaps));
                OnPropertyChanged(nameof(Thuocs));
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi kết nối CSDL: " + ex.Message);
            }
        }

        private void ThemThuoc(object obj)
        {
            // Validation
            if (SelectedThuoc == null) { MessageBox.Show("Vui lòng chọn thuốc!"); return; }
            if (string.IsNullOrWhiteSpace(SoLo)) { MessageBox.Show("Vui lòng nhập số lô!"); return; }
            if (HanSuDung <= DateTime.Now) { MessageBox.Show("Hạn sử dụng phải lớn hơn ngày hiện tại!"); return; }
            if (!int.TryParse(SoLuong, out int sl) || sl <= 0) { MessageBox.Show("Số lượng phải là số nguyên > 0!"); return; }
            if (!decimal.TryParse(GiaNhap, out decimal gia) || gia < 0) { MessageBox.Show("Giá nhập phải >= 0!"); return; }

            var chiTiet = new ChiTietPhieuNhapModel
            {
                MaThuoc = SelectedThuoc.MaThuoc,
                TenThuoc = SelectedThuoc.TenThuoc,
                SoLo = SoLo,
                HanSuDung = HanSuDung,
                SoLuong = sl,
                GiaNhap = gia
            };

            DanhSachChiTiet.Add(chiTiet);
            TinhTongTien();

            // Reset form nhập liệu
            SoLo = "";
            SoLuong = "";
            GiaNhap = "";
            SelectedThuoc = null;
        }

        private void LuuPhieuNhap(object obj)
        {
            if (SelectedNhaCungCap == null) { MessageBox.Show("Vui lòng chọn nhà cung cấp!"); return; }
            if (DanhSachChiTiet.Count == 0) { MessageBox.Show("Danh sách nhập hàng trống!"); return; }

            var phieuNhap = new PhieuNhapModel
            {
                MaNhaCungCap = SelectedNhaCungCap.MaNhaCungCap,
                TongTien = TongTien
            };

            bool success = _repository.SavePhieuNhap(phieuNhap, DanhSachChiTiet.ToList());

            if (success)
            {
                MessageBox.Show("Lưu phiếu nhập thành công!", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Information);
                DanhSachChiTiet.Clear();
                TinhTongTien();
            }
            else
            {
                MessageBox.Show("Lưu phiếu nhập thất bại. Vui lòng kiểm tra lại!", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void TinhTongTien()
        {
            TongTien = DanhSachChiTiet.Sum(x => x.ThanhTien);
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    // Lớp RelayCommand chuẩn dùng nội bộ cho ViewModel này
    public class RelayCommand : ICommand
    {
        private readonly Action<object> _execute;
        private readonly Predicate<object> _canExecute;
        public RelayCommand(Action<object> execute, Predicate<object> canExecute = null)
        {
            _execute = execute;
            _canExecute = canExecute;
        }
        public bool CanExecute(object parameter) => _canExecute == null || _canExecute(parameter);
        public void Execute(object parameter) => _execute(parameter);
        public event EventHandler CanExecuteChanged
        {
            add { CommandManager.RequerySuggested += value; }
            remove { CommandManager.RequerySuggested -= value; }
        }
    }
}
