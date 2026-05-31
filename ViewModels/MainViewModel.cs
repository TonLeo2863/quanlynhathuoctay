using OfficeOpenXml;
using PharmacySalesApp.Commands;
using PharmacySalesApp.Helper;
using PharmacySalesApp.Models;
using PharmacySalesApp.Repositories;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace PharmacySalesApp.ViewModels
{
    public class MainViewModel : BaseViewModel
    {
        private readonly MedicineRepository _medicineRepository = new MedicineRepository();
        private readonly InvoiceRepository _invoiceRepository = new InvoiceRepository();

        // ===== ROLE / USER =====
        public bool IsAdmin => RoleHelper.IsAdmin(AppSession.CurrentUser?.Role);
        public bool IsManager => RoleHelper.IsManager(AppSession.CurrentUser?.Role);
        public bool IsNhanVien => RoleHelper.IsNhanVien(AppSession.CurrentUser?.Role);
        public bool CanManageSystem => RoleHelper.CanManageSystem(AppSession.CurrentUser?.Role);
        public bool CanManageStore => RoleHelper.CanManageStore(AppSession.CurrentUser?.Role);
        public int DefaultTabIndex => 0;
        public bool CanSell => RoleHelper.CanSell(AppSession.CurrentUser?.Role);
        public bool CanViewReports => RoleHelper.CanViewReports(AppSession.CurrentUser?.Role);
        public bool CanManageEmployees => RoleHelper.CanManageEmployees(AppSession.CurrentUser?.Role);

        public string CurrentUserInfo
        {
            get
            {
                var user = AppSession.CurrentUser;
                return user == null ? string.Empty : $"{user.Username} - {user.Role}";
            }
        }

        // ===== COLLECTIONS =====
        public ObservableCollection<string> AvailableUnits { get; }
        public ObservableCollection<Medicine> Medicines { get; } = new ObservableCollection<Medicine>();
        public ObservableCollection<Medicine> FilteredMedicines { get; } = new ObservableCollection<Medicine>();
        public ObservableCollection<CartItem> CartItems { get; } = new ObservableCollection<CartItem>();
        public ObservableCollection<Invoice> Invoices { get; } = new ObservableCollection<Invoice>();

        // ===== COMMANDS =====
        public ICommand SelectImageCommand { get; }
        public ICommand AddCommand { get; }
        public ICommand UpdateCommand { get; }
        public ICommand DeleteCommand { get; }
        public ICommand AddToCartCommand { get; }
        public ICommand PrintBillCommand { get; }
        public ICommand ImportStockCommand { get; }
        public ICommand ImportExcelCommand { get; }
        public ICommand AddCustomerCommand { get; }
        public ICommand UpdateCustomerCommand { get; }
        public ICommand DeleteCustomerCommand { get; }
        public ICommand SearchCustomerCommand { get; }
        public ICommand ReloadCustomerCommand { get; }
        public ICommand FindCustomerCommand { get; }

        // ===== NOTIFICATION / LOADING =====
        private bool _isNotificationVisible;
        public bool IsNotificationVisible
        {
            get => _isNotificationVisible;
            set { _isNotificationVisible = value; OnPropertyChanged(); }
        }
        private string _customerSearchPhone = "";
        public string CustomerSearchPhone
        {
            get => _customerSearchPhone;
            set
            {
                _customerSearchPhone = value;
                OnPropertyChanged();
            }
        }
        private string _notificationMessage = string.Empty;
        public string NotificationMessage
        {
            get => _notificationMessage;
            set { _notificationMessage = value; OnPropertyChanged(); }
        }

        private bool _isLoading;
        public bool IsLoading
        {
            get => _isLoading;
            set { _isLoading = value; OnPropertyChanged(); }
        }

        private int _importProgress;
        public int ImportProgress
        {
            get => _importProgress;
            set { _importProgress = value; OnPropertyChanged(); }
        }

        // ===== MEDICINE FORM =====
        private Medicine _selectedMedicine;
        public Medicine SelectedMedicine
        {
            get => _selectedMedicine;
            set
            {
                _selectedMedicine = value;
                OnPropertyChanged();

                if (value != null)
                    FillMedicineForm(value);

                RaiseMedicineCommandStates();
            }
        }

        private string _code = string.Empty;
        public string Code
        {
            get => _code;
            set { _code = value; OnPropertyChanged(); }
        }
        private int _selectedTabIndex;
        public int SelectedTabIndex
        {
            get => _selectedTabIndex;
            set
            {
                _selectedTabIndex = value;
                OnPropertyChanged();
            }
        }

        private string _name = string.Empty;
        public string Name
        {
            get => _name;
            set { _name = value; OnPropertyChanged(); }
        }

        private string _unit = string.Empty;
        public string Unit
        {
            get => _unit;
            set { _unit = value; OnPropertyChanged(); }
        }

        private decimal _price;
        public decimal Price
        {
            get => _price;
            set { _price = value; OnPropertyChanged(); }
        }

        private int _quantity;
        public int Quantity
        {
            get => _quantity;
            set { _quantity = value; OnPropertyChanged(); }
        }

        private string _imagePath = string.Empty;
        public string ImagePath
        {
            get => _imagePath;
            set { _imagePath = value ?? string.Empty; OnPropertyChanged(); }
        }

        // ===== SELLING =====
        private string _searchText = string.Empty;
        public string SearchText
        {
            get => _searchText;
            set
            {
                _searchText = value;
                OnPropertyChanged();
                FilterMedicines();
            }
        }

        private string _invoiceNote = string.Empty;
        public string InvoiceNote
        {
            get => _invoiceNote;
            set { _invoiceNote = value; OnPropertyChanged(); }
        }

        private Medicine _selectedSellMedicine;
        public Medicine SelectedSellMedicine
        {
            get => _selectedSellMedicine;
            set
            {
                _selectedSellMedicine = value;
                OnPropertyChanged();
                RaiseCommand(AddToCartCommand);
            }
        }
        public ObservableCollection<Customer> Customers { get; } = new ObservableCollection<Customer>();

        private Customer _selectedCustomerInList;
        public Customer SelectedCustomerInList
        {
            get => _selectedCustomerInList;
            set
            {
                _selectedCustomerInList = value;
                OnPropertyChanged();

                if (value != null)
                {
                    CustomerName = value.CustomerName;
                    CustomerPhoneInput = value.Phone;
                    CustomerEmail = value.Email;
                    CustomerAddress = value.Address;
                }
            }
        }

        private decimal _totalAmount;
        public decimal TotalAmount
        {
            get => _totalAmount;
            set { _totalAmount = value; OnPropertyChanged(); }
        }
        private string _customerName = "";
        public string CustomerName
        {
            get => _customerName;
            set { _customerName = value; OnPropertyChanged(); }
        }

        private string _customerPhoneInput = "";
        public string CustomerPhoneInput
        {
            get => _customerPhoneInput;
            set { _customerPhoneInput = value; OnPropertyChanged(); }
        }

        private string _customerEmail = "";
        public string CustomerEmail
        {
            get => _customerEmail;
            set { _customerEmail = value; OnPropertyChanged(); }
        }

        private string _customerAddress = "";
        public string CustomerAddress
        {
            get => _customerAddress;
            set { _customerAddress = value; OnPropertyChanged(); }
        }

        // ===== IMPORT STOCK =====
        private string _batchNumber = string.Empty;
        public string BatchNumber
        {
            get => _batchNumber;
            set { _batchNumber = value; OnPropertyChanged(); }
        }

        private DateTime _expiryDate = DateTime.Now.AddYears(2);
        public DateTime ExpiryDate
        {
            get => _expiryDate;
            set { _expiryDate = value; OnPropertyChanged(); }
        }

        private int _importQuantity;
        public int ImportQuantity
        {
            get => _importQuantity;
            set { _importQuantity = value; OnPropertyChanged(); }
        }

        private decimal _importPrice;
        public decimal ImportPrice
        {
            get => _importPrice;
            set { _importPrice = value; OnPropertyChanged(); }
        }

        // ===== CUSTOMER =====
        private string _customerPhone = string.Empty;
        public string CustomerPhone
        {
            get => _customerPhone;
            set { _customerPhone = value; OnPropertyChanged(); }
        }

        private Customer _selectedCustomer;
        public Customer SelectedCustomer
        {
            get => _selectedCustomer;
            set { _selectedCustomer = value; OnPropertyChanged(); }
        }

        public MainViewModel()
        {
            AvailableUnits = new ObservableCollection<string>
            {
                "Viên", "Vỉ", "Hộp", "Lọ", "Chai", "Tuýp", "Ống", "Gói", "Thùng", "Bịch"
            };
            Unit = AvailableUnits[0];

            AddCommand = new RelayCommand(_ => AddMedicine());
            UpdateCommand = new RelayCommand(_ => UpdateMedicine(), _ => SelectedMedicine != null);
            DeleteCommand = new RelayCommand(_ => DeleteMedicine(), _ => SelectedMedicine != null);
            ImportStockCommand = new RelayCommand(_ => ImportStock(), _ => SelectedMedicine != null);

            AddToCartCommand = new RelayCommand(_ => AddToCart(), _ => SelectedSellMedicine != null && SelectedSellMedicine.Quantity > 0);
            PrintBillCommand = new RelayCommand(_ => PrintBill(), _ => CartItems.Count > 0);

            SelectImageCommand = new RelayCommand(_ => SelectImage());
            ImportExcelCommand = new RelayCommand(async _ => await ImportExcelAsync());
            AddCustomerCommand = new RelayCommand(_ => AddCustomer());
            UpdateCustomerCommand = new RelayCommand(_ => UpdateCustomer(), _ => SelectedCustomerInList != null);
            DeleteCustomerCommand = new RelayCommand(_ => DeleteCustomer(), _ => SelectedCustomerInList != null);
            SearchCustomerCommand = new RelayCommand(_ => SearchCustomerByPhone());
            ReloadCustomerCommand = new RelayCommand(_ => ReloadCustomers());
            FindCustomerCommand = new RelayCommand(_ => FindCustomerByPhone());

            

            if (System.ComponentModel.DesignerProperties.GetIsInDesignMode(new DependencyObject()))
                return;
            SelectedTabIndex = CanManageStore ? 0 : 1;
            if (CanManageStore)
            {
                LoadMedicinesFromDatabase();
            }

            if (CanSell)
            {
                LoadMedicinesFromDatabase();
            }

            LoadInvoicesFromDatabase();
            LoadCustomersFromDatabase();
        }

        // ===== LOAD DATA =====
        
        private void LoadCustomersFromDatabase()
        {
            Customers.Clear();

            const string query = @"
                SELECT MaKhachHang, MaSoKhachHang, HoTen, SoDienThoai, Email, DiaChi, DiemTichLuy, TongTienDaMua
                FROM dbo.KhachHang
                ORDER BY MaKhachHang DESC";

            TryRun("Lỗi tải khách hàng", () =>
            {
                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Customers.Add(new Customer
                            {
                                Id = Convert.ToInt32(reader["MaKhachHang"]),
                                CustomerCode = reader["MaSoKhachHang"].ToString(),
                                CustomerName = reader["HoTen"].ToString(),
                                Phone = reader["SoDienThoai"].ToString(),
                                Email = reader["Email"].ToString(),
                                Address = reader["DiaChi"].ToString(),
                                LoyaltyPoints = Convert.ToInt32(reader["DiemTichLuy"]),
                                TotalSpent = Convert.ToDecimal(reader["TongTienDaMua"])
                            });
                        }
                    }
                }
            });
        }
        private void LoadMedicinesFromDatabase()
        {
            TryRun("Lỗi tải danh sách thuốc", () =>
            {
                Medicines.Clear();

                foreach (var medicine in _medicineRepository.GetAll())
                    Medicines.Add(medicine);

                FilterMedicines();
            });
        }

        private void LoadInvoicesFromDatabase()
        {
            const string query = @"
                SELECT 
                    MaSoHoaDon AS InvoiceId,
                    NgayBan AS CreatedDate,
                    TongThanhToan AS TotalAmount,
                    ISNULL(GhiChu, N'') AS Note
                FROM dbo.HoaDonBan
                ORDER BY NgayBan DESC";

            TryRun("Lỗi tải lịch sử hóa đơn", () =>
            {
                Invoices.Clear();

                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Invoices.Add(new Invoice
                            {
                                InvoiceId = reader["InvoiceId"].ToString() ?? string.Empty,
                                CreatedDate = Convert.ToDateTime(reader["CreatedDate"]),
                                TotalAmount = Convert.ToDecimal(reader["TotalAmount"]),
                                Note = reader["Note"]?.ToString() ?? string.Empty
                            });
                        }
                    }
                }
            });
        }

        // ===== MEDICINE CRUD =====
        private void AddMedicine()
        {
            if (!ValidateMedicineForm()) return;

            TryRun("Lỗi thêm thuốc", () =>
            {
                _medicineRepository.Add(new Medicine
                {
                    Code = string.IsNullOrWhiteSpace(Code) ? GenerateCode("TH") : Code.Trim(),
                    Name = Name.Trim(),
                    Unit = Unit,
                    Price = Price,
                    Quantity = Quantity,
                    ImagePath = ImagePath
                });

                MessageBox.Show("Thêm thuốc thành công.");
                RefreshMedicineData();
            });
        }

        private void UpdateMedicine()
        {
            if (SelectedMedicine == null)
            {
                MessageBox.Show("Vui lòng chọn thuốc cần sửa.");
                return;
            }

            if (!ValidateMedicineForm()) return;

            TryRun("Lỗi sửa thuốc", () =>
            {
                SelectedMedicine.Code = string.IsNullOrWhiteSpace(Code) ? SelectedMedicine.Code : Code.Trim();
                SelectedMedicine.Name = Name.Trim();
                SelectedMedicine.Unit = Unit;
                SelectedMedicine.Price = Price;
                SelectedMedicine.Quantity = Quantity;
                SelectedMedicine.ImagePath = ImagePath;

                _medicineRepository.Update(SelectedMedicine);

                MessageBox.Show("Cập nhật thuốc thành công.");
                RefreshMedicineData();
            });
        }

        private void DeleteMedicine()
        {
            if (SelectedMedicine == null)
            {
                MessageBox.Show("Vui lòng chọn thuốc cần xóa.");
                return;
            }

            bool confirmed = MessageBox.Show(
                $"Bạn có chắc muốn ngừng kinh doanh thuốc '{SelectedMedicine.Name}' không?",
                "Xác nhận",
                MessageBoxButton.YesNo,
                MessageBoxImage.Question) == MessageBoxResult.Yes;

            if (!confirmed) return;

            TryRun("Lỗi xóa thuốc", () =>
            {
                _medicineRepository.Disable(SelectedMedicine.Id);

                MessageBox.Show("Đã ngừng kinh doanh thuốc.");
                RefreshMedicineData();
            });
        }

        public void DeleteMedicines(List<Medicine> selectedMedicines)
        {
            if (selectedMedicines == null || selectedMedicines.Count == 0) return;

            bool confirmed = MessageBox.Show(
                $"Chắc chắn xóa {selectedMedicines.Count} thuốc?",
                "Xóa",
                MessageBoxButton.YesNo,
                MessageBoxImage.Warning) == MessageBoxResult.Yes;

            if (!confirmed) return;

            TryRun("Lỗi xóa", () =>
            {
                using (var con = new SqlConnection(App.ConnectionString))
                {
                    con.Open();

                    foreach (var medicine in selectedMedicines)
                    {
                        ExecuteNonQuery(con, "DELETE FROM MedicineBatches WHERE MedicineId = @Id", medicine.Id);
                        ExecuteNonQuery(con, "DELETE FROM Medicines WHERE Id = @Id", medicine.Id);
                    }
                }

                RefreshMedicineData();
            });
        }

        private void ImportStock()
        {
            if (SelectedMedicine == null)
            {
                MessageBox.Show("Vui lòng chọn thuốc cần nhập kho.");
                return;
            }

            if (ImportQuantity <= 0)
            {
                MessageBox.Show("Số lượng nhập phải lớn hơn 0.");
                return;
            }

            TryRun("Lỗi nhập kho", () =>
            {
                string batch = string.IsNullOrWhiteSpace(BatchNumber)
                    ? GenerateCode("LO")
                    : BatchNumber.Trim();

                _medicineRepository.ImportStock(
                    SelectedMedicine.Id,
                    batch,
                    ExpiryDate,
                    ImportQuantity,
                    ImportPrice);

                MessageBox.Show("Nhập kho thành công.");
                ClearImportForm();
                LoadMedicinesFromDatabase();
            });
        }

        // ===== SELLING =====
        private void FilterMedicines()
        {
            FilteredMedicines.Clear();

            string keyword = SearchText?.Trim().ToLower() ?? string.Empty;

            var result = Medicines.Where(m =>
                string.IsNullOrWhiteSpace(keyword) ||
                Contains(m.Name, keyword) ||
                Contains(m.Code, keyword) ||
                Contains(m.Category, keyword) ||
                Contains(m.Manufacturer, keyword));

            foreach (var medicine in result)
                FilteredMedicines.Add(medicine);
        }

        private void AddToCart()
        {
            if (SelectedSellMedicine == null || SelectedSellMedicine.Quantity <= 0) return;

            var item = CartItems.FirstOrDefault(c => c.Name == SelectedSellMedicine.Name);

            if (item == null)
            {
                CartItems.Add(new CartItem
                {
                    Name = SelectedSellMedicine.Name,
                    Quantity = 1,
                    TotalPrice = SelectedSellMedicine.Price
                });
            }
            else
            {
                item.Quantity++;
                item.TotalPrice = item.Quantity * SelectedSellMedicine.Price;
            }

            SelectedSellMedicine.Quantity--;
            RefreshSellMedicineRow();
            CalculateTotal();

            RaiseCommand(AddToCartCommand);
            RaiseCommand(PrintBillCommand);
        }

        private async void PrintBill()
        {
            if (CartItems.Count == 0)
            {
                MessageBox.Show("Giỏ hàng trống!", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            TryRun("Lỗi thanh toán", () =>
            {
                int createdBy = AppSession.CurrentUser?.Id ?? 1;

                _invoiceRepository.CreateInvoice(CartItems, TotalAmount, InvoiceNote, createdBy);

                CartItems.Clear();
                InvoiceNote = string.Empty;
                CalculateTotal();

                RaiseCommand(PrintBillCommand);

                LoadMedicinesFromDatabase();
                LoadInvoicesFromDatabase();
            });

            await ShowNotificationAsync("Thanh toán thành công và đã trừ tồn kho!");
        }

        private void CalculateTotal()
        {
            TotalAmount = CartItems.Sum(c => c.TotalPrice);
        }

        // ===== IMAGE =====
        private void SelectImage()
        {
            var dlg = new Microsoft.Win32.OpenFileDialog
            {
                Filter = "Image Files|*.jpg;*.jpeg;*.png;*.gif"
            };

            if (dlg.ShowDialog() != true) return;

            TryRun("Lỗi khi chọn ảnh", () =>
            {
                string imagesFolder = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Images");
                Directory.CreateDirectory(imagesFolder);

                string fileName = Guid.NewGuid() + Path.GetExtension(dlg.FileName);
                string destinationPath = Path.Combine(imagesFolder, fileName);

                File.Copy(dlg.FileName, destinationPath, true);
                ImagePath = destinationPath;
            });
        }

        // ===== EXCEL IMPORT =====
        private async Task ImportExcelAsync()
        {
            var rows = ImportFromExcel();
            if (rows.Count == 0) return;

            IsLoading = true;
            ImportProgress = 0;

            await Task.Run(() => ImportMedicinesToDatabase(rows));

            IsLoading = false;
            LoadMedicinesFromDatabase();
            MessageBox.Show("Import Excel thành công!");
        }

        private List<Medicine> ImportFromExcel()
        {
            var medicines = new List<Medicine>();

            var dlg = new Microsoft.Win32.OpenFileDialog
            {
                Filter = "Excel Files|*.xlsx;*.xls",
                Title = "Chọn file Excel danh sách thuốc"
            };

            if (dlg.ShowDialog() != true) return medicines;

            TryRun("Lỗi khi đọc file Excel", () =>
            {
                using (var package = new ExcelPackage(new FileInfo(dlg.FileName)))
                {
                    var sheet = package.Workbook.Worksheets[0];
                    if (sheet?.Dimension == null) return;

                    for (int row = 2; row <= sheet.Dimension.Rows; row++)
                    {
                        string name = sheet.Cells[row, 1].Text.Trim();
                        if (string.IsNullOrWhiteSpace(name)) continue;

                        decimal.TryParse(sheet.Cells[row, 3].Text.Trim(), out decimal price);
                        int.TryParse(sheet.Cells[row, 4].Text.Trim(), out int quantity);

                        medicines.Add(new Medicine
                        {
                            Name = name,
                            Unit = sheet.Cells[row, 2].Text.Trim(),
                            Price = price,
                            Quantity = quantity
                        });
                    }
                }
            });

            return medicines;
        }

        private void ImportMedicinesToDatabase(List<Medicine> rows)
        {
            using (var con = new SqlConnection(App.ConnectionString))
            {
                con.Open();

                for (int i = 0; i < rows.Count; i++)
                {
                    int newMedicineId = InsertMedicine(con, rows[i]);
                    InsertMedicineBatch(con, newMedicineId, rows[i].Quantity);

                    int percent = (i + 1) * 100 / rows.Count;
                    App.Current.Dispatcher.Invoke(() => ImportProgress = percent);
                }
            }
        }

        private int InsertMedicine(SqlConnection con, Medicine medicine)
        {
            const string query = @"
                INSERT INTO Medicines (Name, Unit, Price, Quantity, ImagePath)
                VALUES (@Name, @Unit, @Price, @Qty, '');
                SELECT SCOPE_IDENTITY()";

            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Name", medicine.Name);
                cmd.Parameters.AddWithValue("@Unit", medicine.Unit);
                cmd.Parameters.AddWithValue("@Price", medicine.Price);
                cmd.Parameters.AddWithValue("@Qty", medicine.Quantity);

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void InsertMedicineBatch(SqlConnection con, int medicineId, int quantity)
        {
            const string query = @"
                INSERT INTO MedicineBatches (MedicineId, Quantity, ExpiryDate)
                VALUES (@MedId, @Qty, @Expiry)";

            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@MedId", medicineId);
                cmd.Parameters.AddWithValue("@Qty", quantity);
                cmd.Parameters.AddWithValue("@Expiry", DateTime.Now.AddYears(2));
                cmd.ExecuteNonQuery();
            }
        }

        // ===== CUSTOMER =====
        private void SearchCustomerByPhone()
        {
            Customers.Clear();

            string phone = CustomerSearchPhone?.Trim() ?? "";

            if (string.IsNullOrWhiteSpace(phone))
            {
                MessageBox.Show("Vui lòng nhập số điện thoại cần tìm.");
                LoadCustomersFromDatabase();
                return;
            }

            const string query = @"
                SELECT MaKhachHang, MaSoKhachHang, HoTen, SoDienThoai, Email, DiaChi, DiemTichLuy, TongTienDaMua
                FROM dbo.KhachHang
                WHERE SoDienThoai LIKE @Phone
                ORDER BY MaKhachHang DESC";

            TryRun("Lỗi tìm khách hàng", () =>
            {
                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Phone", "%" + phone + "%");

                    con.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Customers.Add(new Customer
                            {
                                Id = Convert.ToInt32(reader["MaKhachHang"]),
                                CustomerCode = reader["MaSoKhachHang"].ToString() ?? "",
                                CustomerName = reader["HoTen"].ToString() ?? "",
                                Phone = reader["SoDienThoai"].ToString() ?? "",
                                Email = reader["Email"].ToString() ?? "",
                                Address = reader["DiaChi"].ToString() ?? "",
                                LoyaltyPoints = Convert.ToInt32(reader["DiemTichLuy"]),
                                TotalSpent = Convert.ToDecimal(reader["TongTienDaMua"])
                            });
                        }
                    }
                }

                if (Customers.Count == 0)
                {
                    MessageBox.Show("Không tìm thấy khách hàng.");
                }
            });
        }

        private void ReloadCustomers()
        {
            CustomerSearchPhone = "";
            ClearCustomerForm();
            LoadCustomersFromDatabase();
        }
        private void FindCustomerByPhone()
        {
            if (string.IsNullOrWhiteSpace(CustomerPhone))
            {
                MessageBox.Show("Vui lòng nhập số điện thoại khách hàng.");
                return;
            }

            const string query = @"
                SELECT MaKhachHang, MaSoKhachHang, HoTen, SoDienThoai, Email, DiaChi, DiemTichLuy, TongTienDaMua
                FROM dbo.KhachHang
                WHERE SoDienThoai = @Phone";

            TryRun("Lỗi tìm khách hàng", () =>
            {
                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Phone", CustomerPhone.Trim());
                    con.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            SelectedCustomer = null;
                            MessageBox.Show("Không tìm thấy khách hàng.");
                            return;
                        }

                        SelectedCustomer = new Customer
                        {
                            Id = Convert.ToInt32(reader["MaKhachHang"]),
                            CustomerCode = reader["MaSoKhachHang"].ToString() ?? "",
                            CustomerName = reader["HoTen"].ToString() ?? "",
                            Phone = reader["SoDienThoai"].ToString() ?? "",
                            Email = reader["Email"].ToString() ?? "",
                            Address = reader["DiaChi"].ToString() ?? "",
                            LoyaltyPoints = Convert.ToInt32(reader["DiemTichLuy"]),
                            TotalSpent = Convert.ToDecimal(reader["TongTienDaMua"])
                        };

                        MessageBox.Show("Đã chọn khách hàng: " + SelectedCustomer.CustomerName);
                    }
                }
            });
        }
        private void AddCustomer()
        {
            if (string.IsNullOrWhiteSpace(CustomerName) || string.IsNullOrWhiteSpace(CustomerPhoneInput))
            {
                MessageBox.Show("Vui lòng nhập họ tên và số điện thoại.");
                return;
            }

            TryRun("Lỗi thêm khách hàng", () =>
            {
                string code = "KH" + DateTime.Now.ToString("yyyyMMddHHmmss");

                const string query = @"
                    INSERT INTO dbo.KhachHang
                    (MaSoKhachHang, HoTen, SoDienThoai, Email, DiaChi)
                    VALUES
                    (@Code, @Name, @Phone, @Email, @Address)";

                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Code", code);
                    cmd.Parameters.AddWithValue("@Name", CustomerName.Trim());
                    cmd.Parameters.AddWithValue("@Phone", CustomerPhoneInput.Trim());
                    cmd.Parameters.AddWithValue("@Email", CustomerEmail ?? "");
                    cmd.Parameters.AddWithValue("@Address", CustomerAddress ?? "");

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                MessageBox.Show("Thêm khách hàng thành công.");
                ClearCustomerForm();
                LoadCustomersFromDatabase();
            });
        }
        private void UpdateCustomer()
        {
            if (SelectedCustomerInList == null) return;

            TryRun("Lỗi sửa khách hàng", () =>
            {
                const string query = @"
                    UPDATE dbo.KhachHang
                    SET HoTen = @Name,
                        SoDienThoai = @Phone,
                        Email = @Email,
                        DiaChi = @Address
                    WHERE MaKhachHang = @Id";

                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Id", SelectedCustomerInList.Id);
                    cmd.Parameters.AddWithValue("@Name", CustomerName.Trim());
                    cmd.Parameters.AddWithValue("@Phone", CustomerPhoneInput.Trim());
                    cmd.Parameters.AddWithValue("@Email", CustomerEmail ?? "");
                    cmd.Parameters.AddWithValue("@Address", CustomerAddress ?? "");

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                MessageBox.Show("Cập nhật khách hàng thành công.");
                LoadCustomersFromDatabase();
            });
        }

        private void DeleteCustomer()
        {
            if (SelectedCustomerInList == null) return;

            if (MessageBox.Show("Bạn có chắc muốn xóa khách hàng này?", "Xác nhận", MessageBoxButton.YesNo) != MessageBoxResult.Yes)
                return;

            TryRun("Lỗi xóa khách hàng", () =>
            {
                const string query = "DELETE FROM dbo.KhachHang WHERE MaKhachHang = @Id";

                using (var con = new SqlConnection(App.ConnectionString))
                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Id", SelectedCustomerInList.Id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                MessageBox.Show("Xóa khách hàng thành công.");
                ClearCustomerForm();
                LoadCustomersFromDatabase();
            });
        }

        private void ClearCustomerForm()
        {
            CustomerName = "";
            CustomerPhoneInput = "";
            CustomerEmail = "";
            CustomerAddress = "";
            SelectedCustomerInList = null;
        }
        // ===== HELPERS =====
        private bool ValidateMedicineForm()
        {
            if (!string.IsNullOrWhiteSpace(Name)) return true;

            MessageBox.Show("Vui lòng nhập tên thuốc.");
            return false;
        }

        private void FillMedicineForm(Medicine medicine)
        {
            Code = medicine.Code;
            Name = medicine.Name;
            Unit = medicine.Unit;
            Price = medicine.Price;
            Quantity = medicine.Quantity;
            ImagePath = medicine.ImagePath;
        }

        private void ClearForm()
        {
            Code = string.Empty;
            Name = string.Empty;
            Unit = AvailableUnits[0];
            Price = 0;
            Quantity = 0;
            ImagePath = string.Empty;
            SelectedMedicine = null;
        }

        private void ClearImportForm()
        {
            BatchNumber = string.Empty;
            ExpiryDate = DateTime.Now.AddYears(2);
            ImportQuantity = 0;
            ImportPrice = 0;
        }

        private void RefreshMedicineData()
        {
            ClearForm();
            LoadMedicinesFromDatabase();
        }

        private void RefreshSellMedicineRow()
        {
            int index = FilteredMedicines.IndexOf(SelectedSellMedicine);
            if (index >= 0)
                FilteredMedicines[index] = SelectedSellMedicine;
        }

        private async Task ShowNotificationAsync(string message)
        {
            NotificationMessage = message;
            IsNotificationVisible = true;

            await Task.Delay(2000);

            IsNotificationVisible = false;
        }

        private static bool Contains(string source, string keyword)
        {
            return !string.IsNullOrWhiteSpace(source) && source.ToLower().Contains(keyword);
        }

        private static string GenerateCode(string prefix)
        {
            return prefix + DateTime.Now.ToString("yyyyMMddHHmmss");
        }

        private static void ExecuteNonQuery(SqlConnection con, string query, int id)
        {
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
            }
        }

        private static void RaiseCommand(ICommand command)
        {
            (command as RelayCommand)?.RaiseCanExecuteChanged();
        }

        private void RaiseMedicineCommandStates()
        {
            RaiseCommand(UpdateCommand);
            RaiseCommand(DeleteCommand);
            RaiseCommand(ImportStockCommand);
        }

        private static void TryRun(string errorTitle, Action action)
        {
            try
            {
                action();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"{errorTitle}: {ex.Message}");
            }
        }

        public class Customer
        {
            public int Id { get; set; }
            public string CustomerCode { get; set; }
            public string CustomerName { get; set; }
            public string Phone { get; set; }
            public string Email { get; set; }
            public string Address { get; set; }
            public int LoyaltyPoints { get; set; }
            public decimal TotalSpent { get; set; }
        }

    }

    public static class AppSession
    {
        public static User CurrentUser { get; set; }
    }
}
