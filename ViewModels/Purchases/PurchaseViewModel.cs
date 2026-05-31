using PharmacySalesApp.Commands;
using PharmacySalesApp.Helper;
using PharmacySalesApp.Models.Purchases;
using PharmacySalesApp.Repositories.Purchases;
using PharmacySalesApp.ViewModels;
using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;

namespace PharmacySalesApp.ViewModels.Purchases
{
    public class PurchaseViewModel : BaseViewModel
    {
        private readonly PurchaseInvoiceRepository _repository = new PurchaseInvoiceRepository();

        public ObservableCollection<SupplierOption> Suppliers { get; } = new ObservableCollection<SupplierOption>();
        public ObservableCollection<MedicineOption> Medicines { get; } = new ObservableCollection<MedicineOption>();
        public ObservableCollection<PurchaseInvoiceLine> Lines { get; } = new ObservableCollection<PurchaseInvoiceLine>();

        private SupplierOption _selectedSupplier;
        public SupplierOption SelectedSupplier
        {
            get => _selectedSupplier;
            set
            {
                _selectedSupplier = value;
                OnPropertyChanged();
            }
        }

        private MedicineOption _selectedMedicine;
        public MedicineOption SelectedMedicine
        {
            get => _selectedMedicine;
            set
            {
                _selectedMedicine = value;
                OnPropertyChanged();

                if (value != null && ImportPrice <= 0)
                    ImportPrice = value.ImportPrice;
            }
        }

        private string _batchNumber = "";
        public string BatchNumber
        {
            get => _batchNumber;
            set
            {
                _batchNumber = value;
                OnPropertyChanged();
            }
        }

        private DateTime _expiryDate = DateTime.Today.AddYears(2);
        public DateTime ExpiryDate
        {
            get => _expiryDate;
            set
            {
                _expiryDate = value;
                OnPropertyChanged();
            }
        }

        private int _quantity = 1;
        public int Quantity
        {
            get => _quantity;
            set
            {
                _quantity = value;
                OnPropertyChanged();
            }
        }

        private decimal _importPrice;
        public decimal ImportPrice
        {
            get => _importPrice;
            set
            {
                _importPrice = value;
                OnPropertyChanged();
            }
        }

        private string _note = "";
        public string Note
        {
            get => _note;
            set
            {
                _note = value;
                OnPropertyChanged();
            }
        }

        private PurchaseInvoiceLine _selectedLine;
        public PurchaseInvoiceLine SelectedLine
        {
            get => _selectedLine;
            set
            {
                _selectedLine = value;
                OnPropertyChanged();
            }
        }

        private decimal _totalAmount;
        public decimal TotalAmount
        {
            get => _totalAmount;
            set
            {
                _totalAmount = value;
                OnPropertyChanged();
            }
        }

        public ICommand LoadCommand { get; }
        public ICommand AddLineCommand { get; }
        public ICommand RemoveLineCommand { get; }
        public ICommand SaveCommand { get; }
        public ICommand ClearCommand { get; }

        public PurchaseViewModel()
        {
            LoadCommand = new RelayCommand(_ => LoadData());
            AddLineCommand = new RelayCommand(_ => AddLine());
            RemoveLineCommand = new RelayCommand(_ => RemoveLine(), _ => SelectedLine != null);
            SaveCommand = new RelayCommand(_ => SavePurchaseInvoice());
            ClearCommand = new RelayCommand(_ => ClearForm());

            LoadData();
        }

        private void LoadData()
        {
            try
            {
                Suppliers.Clear();
                Medicines.Clear();

                foreach (var supplier in _repository.GetSuppliers())
                    Suppliers.Add(supplier);

                foreach (var medicine in _repository.GetMedicines())
                    Medicines.Add(medicine);

                SelectedSupplier = Suppliers.FirstOrDefault();
                SelectedMedicine = Medicines.FirstOrDefault();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải dữ liệu phiếu nhập: " + ex.Message);
            }
        }

        private void AddLine()
        {
            if (SelectedMedicine == null)
            {
                MessageBox.Show("Vui lòng chọn thuốc.");
                return;
            }

            if (string.IsNullOrWhiteSpace(BatchNumber))
            {
                MessageBox.Show("Vui lòng nhập số lô.");
                return;
            }

            if (ExpiryDate.Date <= DateTime.Today)
            {
                MessageBox.Show("Hạn sử dụng phải lớn hơn ngày hiện tại.");
                return;
            }

            if (Quantity <= 0)
            {
                MessageBox.Show("Số lượng nhập phải lớn hơn 0.");
                return;
            }

            if (ImportPrice < 0)
            {
                MessageBox.Show("Giá nhập không được âm.");
                return;
            }

            Lines.Add(new PurchaseInvoiceLine
            {
                MedicineId = SelectedMedicine.Id,
                MedicineCode = SelectedMedicine.Code,
                MedicineName = SelectedMedicine.Name,
                BatchNumber = BatchNumber.Trim(),
                ExpiryDate = ExpiryDate.Date,
                Quantity = Quantity,
                ImportPrice = ImportPrice
            });

            CalculateTotal();

            BatchNumber = "";
            Quantity = 1;
            ImportPrice = SelectedMedicine.ImportPrice;
        }

        private void RemoveLine()
        {
            if (SelectedLine == null)
                return;

            Lines.Remove(SelectedLine);
            CalculateTotal();
        }

        private void SavePurchaseInvoice()
        {
            if (SelectedSupplier == null)
            {
                MessageBox.Show("Vui lòng chọn nhà cung cấp.");
                return;
            }

            if (Lines.Count == 0)
            {
                MessageBox.Show("Phiếu nhập chưa có chi tiết thuốc.");
                return;
            }

            try
            {
                int employeeId = AppSession.CurrentUser?.Id ?? 1;
                int branchId = 1;

                string code = _repository.SavePurchaseInvoice(
                    SelectedSupplier.Id,
                    branchId,
                    employeeId,
                    Lines.ToList(),
                    Note);

                MessageBox.Show("Lưu phiếu nhập thành công: " + code);

                ClearForm();
                LoadData();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi lưu phiếu nhập: " + ex.Message);
            }
        }

        private void ClearForm()
        {
            Lines.Clear();
            Note = "";
            BatchNumber = "";
            Quantity = 1;
            ImportPrice = 0;
            ExpiryDate = DateTime.Today.AddYears(2);
            CalculateTotal();
        }

        private void CalculateTotal()
        {
            TotalAmount = Lines.Sum(x => x.Total);
        }
    }
}