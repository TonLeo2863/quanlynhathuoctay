using OfficeOpenXml;
using PharmacySalesApp.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using static PharmacySalesApp.ViewModels.MainViewModel;
using PharmacySalesApp.Commands;

namespace PharmacySalesApp.ViewModels
{
    public class MainViewModel : BaseViewModel
    {

        public ObservableCollection<string> AvailableUnits { get; set; }
        public bool IsNotificationVisible { get => _isNotificationVisible; set { _isNotificationVisible = value; OnPropertyChanged(); } }
        private bool _isNotificationVisible;
        public string NotificationMessage { get => _notificationMessage; set { _notificationMessage = value; OnPropertyChanged(); } }
        private string _notificationMessage = string.Empty;
        

        // TAB QUẢN LÝ
        public ObservableCollection<Medicine> Medicines { get; set; }
        private Medicine? _selectedMedicine;
        public Medicine? SelectedMedicine
        {
            get => _selectedMedicine;
            set
            {
                _selectedMedicine = value; OnPropertyChanged();
                if (value != null) { Name = value.Name; Unit = value.Unit; Price = value.Price; Quantity = value.Quantity; ImagePath = value.ImagePath; }
            }
        }

        public string Name { get => _name; set { _name = value; OnPropertyChanged(); } }
        private string _name = string.Empty;
        public string Unit { get => _unit; set { _unit = value; OnPropertyChanged(); } }
        private string _unit = string.Empty;
        public decimal Price { get => _price; set { _price = value; OnPropertyChanged(); } }
        private decimal _price;
        public int Quantity { get => _quantity; set { _quantity = value; OnPropertyChanged(); } }
        private int _quantity;
        private string _imagePath = string.Empty;
        public string ImagePath
        {
            get => string.IsNullOrEmpty(_imagePath) ? null : _imagePath;
            set { _imagePath = value; OnPropertyChanged(); }
        }

        public ICommand SelectImageCommand { get; set; }
        public ICommand AddCommand { get; set; }
        public ICommand UpdateCommand { get; set; }
        public ICommand DeleteCommand { get; set; }

        // TAB BÁN HÀNG
        public string SearchText { get => _searchText; set { _searchText = value; OnPropertyChanged(); FilterMedicines(); } }
        private string _searchText = string.Empty;
        public string InvoiceNote { get => _invoiceNote; set { _invoiceNote = value; OnPropertyChanged(); } }
        private string _invoiceNote = string.Empty;

        public ObservableCollection<Medicine> FilteredMedicines { get; set; }
        public Medicine? SelectedSellMedicine { get => _selectedSellMedicine; set { _selectedSellMedicine = value; OnPropertyChanged(); (AddToCartCommand as RelayCommand)?.RaiseCanExecuteChanged(); } }
        private Medicine? _selectedSellMedicine;
        public ObservableCollection<CartItem> CartItems { get; set; } = new ObservableCollection<CartItem>();
        public decimal TotalAmount { get => _totalAmount; set { _totalAmount = value; OnPropertyChanged(); } }
        private decimal _totalAmount;

        public ICommand AddToCartCommand { get; set; }
        public ICommand PrintBillCommand { get; set; }

        // TAB LỊCH SỬ
        public ObservableCollection<Invoice> Invoices { get; set; }

        public ICommand ImportExcelCommand { get; set; }
        private bool _isLoading;
        public bool IsLoading { get => _isLoading; set { _isLoading = value; OnPropertyChanged(); } }
        private int _importProgress;
        public int ImportProgress { get => _importProgress; set { _importProgress = value; OnPropertyChanged(); } }

        // CONSTRUCTOR 
        public MainViewModel()
        {
            AvailableUnits = new ObservableCollection<string> { "Viên", "Vỉ", "Hộp", "Lọ", "Chai", "Tuýp", "Ống", "Gói", "Thùng", "Bịch" };
            Unit = AvailableUnits[0];

            Medicines = new ObservableCollection<Medicine>();
            FilteredMedicines = new ObservableCollection<Medicine>();
            Invoices = new ObservableCollection<Invoice>();

            AddCommand = new RelayCommand(_ => AddMedicine());
            UpdateCommand = new RelayCommand(_ => UpdateMedicine(), _ => SelectedMedicine != null);
            DeleteCommand = new RelayCommand(_ => DeleteMedicine(), _ => SelectedMedicine != null);
            AddToCartCommand = new RelayCommand(_ => AddToCart(), _ => SelectedSellMedicine != null && SelectedSellMedicine.Quantity > 0);
            PrintBillCommand = new RelayCommand(_ => PrintBill(), _ => CartItems.Count > 0);
            SelectImageCommand = new RelayCommand(_ => SelectImage());
            ImportExcelCommand = new RelayCommand(async _ => await ImportExcelAsync());

            if (System.ComponentModel.DesignerProperties.GetIsInDesignMode(new System.Windows.DependencyObject()))
            {
                return;
            }

            LoadMedicinesFromDatabase();
            LoadInvoicesFromDatabase();
        }

        //  KẾT NỐI DATABASE 
        private void LoadMedicinesFromDatabase()
        {
            Medicines.Clear();
            // Lấy thuốc từ CSDL mới của nhóm bạn (Dùng MedicineName)
            string query = "SELECT Id, MedicineName AS Name, Unit, Price, Quantity, ImagePath FROM Medicines WHERE IsDeleted = 0";
            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        Medicines.Add(new Medicine
                        {
                            Id = Convert.ToInt32(reader["Id"]),
                            Name = reader["Name"].ToString() ?? "",
                            Unit = reader["Unit"].ToString() ?? "",
                            Price = Convert.ToDecimal(reader["Price"]),
                            Quantity = Convert.ToInt32(reader["Quantity"]),
                            ImagePath = reader["ImagePath"]?.ToString() ?? ""
                        });
                    }
                }
                catch (Exception ex) { MessageBox.Show("Lỗi tải Thuốc: " + ex.Message); }
            }
            FilterMedicines();
        }

        private void LoadInvoicesFromDatabase()
        {
            Invoices.Clear();
            // Đổi InvoiceId thành Id và lấy thêm Note
            string query = "SELECT Id AS InvoiceId, CreatedDate, TotalAmount, Note FROM Invoices";
            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        Invoices.Add(new Invoice
                        {
                            InvoiceId = reader["InvoiceId"].ToString() ?? "",
                            CreatedDate = Convert.ToDateTime(reader["CreatedDate"]),
                            TotalAmount = Convert.ToDecimal(reader["TotalAmount"]),
                            Note = reader["Note"]?.ToString() ?? ""
                        });
                    }
                }
                catch (Exception) { /* Bỏ qua nếu chưa có hóa đơn */ }
            }
        }

        private void AddMedicine()
        {
            if (string.IsNullOrWhiteSpace(Name)) return;
            // Thêm CategoryId = 1 (mặc định) để không bị lỗi khóa ngoại
            string query = "INSERT INTO Medicines (MedicineName, Unit, Price, Quantity, ImagePath, CategoryId) VALUES (@Name, @Unit, @Price, @Qty, @ImagePath, 1)";
            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Name", Name); cmd.Parameters.AddWithValue("@Unit", Unit);
                    cmd.Parameters.AddWithValue("@Price", Price); cmd.Parameters.AddWithValue("@Qty", Quantity);
                    cmd.Parameters.AddWithValue("@ImagePath", ImagePath ?? "");
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex) { MessageBox.Show("Lỗi thêm: " + ex.Message); }
            }
            ClearForm();
            LoadMedicinesFromDatabase();
        }

        private void UpdateMedicine()
        {
            if (SelectedMedicine == null) return;
            // Cập nhật dùng MedicineName
            string query = "UPDATE Medicines SET MedicineName=@Name, Unit=@Unit, Price=@Price, Quantity=@Qty, ImagePath=@ImagePath WHERE Id=@Id";
            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Id", SelectedMedicine.Id);
                    cmd.Parameters.AddWithValue("@Name", Name); cmd.Parameters.AddWithValue("@Unit", Unit);
                    cmd.Parameters.AddWithValue("@Price", Price); cmd.Parameters.AddWithValue("@Qty", Quantity);
                    cmd.Parameters.AddWithValue("@ImagePath", ImagePath ?? "");
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex) { MessageBox.Show("Lỗi sửa: " + ex.Message); }
            }
            LoadMedicinesFromDatabase();
        }

        private void DeleteMedicine()
        {
            if (SelectedMedicine == null) return;
            if (MessageBox.Show($"Chắc chắn xóa '{SelectedMedicine.Name}'?", "Xóa", MessageBoxButton.YesNo, MessageBoxImage.Warning) == MessageBoxResult.Yes)
            {
                string query = "UPDATE Medicines SET IsDeleted = 1 WHERE Id=@Id";
                using (SqlConnection con = new SqlConnection(App.ConnectionString))
                {
                    try { con.Open(); SqlCommand cmd = new SqlCommand(query, con); cmd.Parameters.AddWithValue("@Id", SelectedMedicine.Id); cmd.ExecuteNonQuery(); }
                    catch (Exception ex) { MessageBox.Show("Lỗi xóa: " + ex.Message); }
                }
                ClearForm(); LoadMedicinesFromDatabase();
            }
        }

        private void ClearForm() { Name = string.Empty; Unit = AvailableUnits[0]; Price = 0; Quantity = 0; ImagePath = string.Empty; }

        private void FilterMedicines()
        {
            FilteredMedicines.Clear();
            var search = SearchText?.ToLower() ?? "";
            var filtered = Medicines.Where(m => m.Name.ToLower().Contains(search)).ToList();
            foreach (var item in filtered) FilteredMedicines.Add(item);
        }

        private void AddToCart()
        {
            if (SelectedSellMedicine == null || SelectedSellMedicine.Quantity <= 0) return;
            var existingItem = CartItems.FirstOrDefault(c => c.Name == SelectedSellMedicine.Name);
            if (existingItem != null) { existingItem.Quantity++; existingItem.TotalPrice = existingItem.Quantity * SelectedSellMedicine.Price; }
            else { CartItems.Add(new CartItem { Name = SelectedSellMedicine.Name, Quantity = 1, TotalPrice = SelectedSellMedicine.Price }); }

            SelectedSellMedicine.Quantity--;
            (AddToCartCommand as RelayCommand)?.RaiseCanExecuteChanged();
            var index = FilteredMedicines.IndexOf(SelectedSellMedicine);
            if (index >= 0) FilteredMedicines[index] = SelectedSellMedicine;

            CalculateTotal();
        }

        private void CalculateTotal() { TotalAmount = CartItems.Sum(c => c.TotalPrice); }
        

        public class Customer
        {
            public int Id { get; set; }
            public string CustomerName { get; set; }
            public string Phone { get; set; }
            public int LoyaltyPoints { get; set; }
        }
       

        private async void PrintBill()
        {
            if (CartItems.Count == 0)
            {
                MessageBox.Show("Giỏ hàng trống!", "Thông báo", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DateTime date = DateTime.Now;
            int? customerId = SelectedCustomer?.Id;
            int createdBy = AppSession.CurrentUser?.Id ?? 1;

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                try
                {
                    con.Open();

                    // 1. Lưu Hóa Đơn và LẤY MÃ SỐ ID TỰ ĐỘNG
                    string insertInv = @"
                INSERT INTO Invoices (CustomerId, CreatedBy, CreatedDate, TotalAmount, Note)
                OUTPUT INSERTED.Id
                VALUES (@CustomerId, @CreatedBy, @Date, @Total, @Note)";
                    SqlCommand cmdInv = new SqlCommand(insertInv, con);
                    cmdInv.Parameters.AddWithValue("@CustomerId", (object?)customerId ?? DBNull.Value);
                    cmdInv.Parameters.AddWithValue("@CreatedBy", createdBy);
                    cmdInv.Parameters.AddWithValue("@Date", date);
                    cmdInv.Parameters.AddWithValue("@Total", TotalAmount);
                    cmdInv.Parameters.AddWithValue("@Note", InvoiceNote ?? "");
                    int newInvoiceId = (int)cmdInv.ExecuteScalar();

                    // 2. Lưu Chi Tiết và Trừ Tồn Kho theo FEFO
                    foreach (var item in CartItems)
                    {
                        int medId = 0;
                        decimal unitPrice = item.TotalPrice / item.Quantity;

                        // Lấy Id của thuốc
                        string findMed = "SELECT Id FROM Medicines WHERE MedicineName = @Name AND IsDeleted = 0";
                        using (SqlCommand cmdFind = new SqlCommand(findMed, con))
                        {
                            cmdFind.Parameters.AddWithValue("@Name", item.Name);
                            var result = cmdFind.ExecuteScalar();
                            if (result != null) medId = (int)result;
                        }

                        if (medId > 0)
                        {
                            int remainingQty = item.Quantity;

                            // Lấy danh sách batch theo ExpiryDate ASC (FEFO)
                            string selectBatches = @"
                        SELECT Id, Quantity 
                        FROM MedicineBatches 
                        WHERE MedicineId = @MedId AND Quantity > 0
                        ORDER BY ExpiryDate ASC";

                            List<(int Id, int Qty)> batches = new List<(int, int)>();

                            using (SqlCommand cmdBatch = new SqlCommand(selectBatches, con))
                            {
                                cmdBatch.Parameters.AddWithValue("@MedId", medId);
                                using (SqlDataReader reader = cmdBatch.ExecuteReader())
                                {
                                    while (reader.Read())
                                    {
                                        batches.Add((reader.GetInt32(0), reader.GetInt32(1)));
                                    }
                                }
                            }

                            // Xử lý FEFO
                            

                            foreach (var batch in batches)
                            {
                                if (remainingQty <= 0) break;

                                int deduct = Math.Min(remainingQty, batch.Qty);

                                string updateBatch = "UPDATE MedicineBatches SET Quantity = Quantity - @Deduct WHERE Id = @BatchId";
                                SqlCommand cmdUpdBatch = new SqlCommand(updateBatch, con);
                                cmdUpdBatch.Parameters.AddWithValue("@Deduct", deduct);
                                cmdUpdBatch.Parameters.AddWithValue("@BatchId", batch.Id);
                                cmdUpdBatch.ExecuteNonQuery();

                                remainingQty -= deduct;
                            }

                            // ❗ Check thiếu hàng
                            if (remainingQty > 0)
                            {
                                MessageBox.Show("Không đủ hàng trong kho!", "Lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
                                return;
                            }

                            // Lưu chi tiết hóa đơn
                            string insertDet = "INSERT INTO InvoiceDetails (InvoiceId, MedicineId, Quantity, UnitPrice) VALUES (@InvId, @MedId, @Qty, @Price)";
                            SqlCommand cmdDet = new SqlCommand(insertDet, con);
                            cmdDet.Parameters.AddWithValue("@InvId", newInvoiceId);
                            cmdDet.Parameters.AddWithValue("@MedId", medId);
                            cmdDet.Parameters.AddWithValue("@Qty", item.Quantity);
                            cmdDet.Parameters.AddWithValue("@Price", unitPrice);
                            cmdDet.ExecuteNonQuery();

                            // Cập nhật tổng tồn kho
                            string updateQty = "UPDATE Medicines SET Quantity = Quantity - @Qty WHERE Id = @MedId";
                            SqlCommand cmdUpd = new SqlCommand(updateQty, con);
                            cmdUpd.Parameters.AddWithValue("@Qty", item.Quantity);
                            cmdUpd.Parameters.AddWithValue("@MedId", medId);
                            cmdUpd.ExecuteNonQuery();
                        }
                    }

                    // 3. Cập nhật điểm khách hàng (nếu có)
                    if (customerId.HasValue)
                    {
                        int pointsEarned = (int)(TotalAmount / 1000); // 1 điểm / 1000 đ
                        string updatePoints = "UPDATE Customers SET LoyaltyPoints = LoyaltyPoints + @Points WHERE Id = @CustomerId";
                        SqlCommand cmdPoints = new SqlCommand(updatePoints, con);
                        cmdPoints.Parameters.AddWithValue("@Points", pointsEarned);
                        cmdPoints.Parameters.AddWithValue("@CustomerId", customerId.Value);
                        cmdPoints.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Lỗi In Bill: " + ex.Message, "Thông báo lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
            }

            // 4. Clear Cart + Load lại dữ liệu
            CartItems.Clear();
            CalculateTotal();
            InvoiceNote = string.Empty;
            LoadMedicinesFromDatabase();
            LoadInvoicesFromDatabase();

            // 5. Thông báo Popup
            NotificationMessage = "In Bill thành công!";
            IsNotificationVisible = true;
            await Task.Delay(2000);
            IsNotificationVisible = false;
        }
        private void SelectImage()
        {
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
            dlg.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.gif";

            if (dlg.ShowDialog() == true)
            {
                try
                {
                    string selectedFilePath = dlg.FileName;
                    string imagesFolder = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Images");
                    if (!System.IO.Directory.Exists(imagesFolder))
                    {
                        System.IO.Directory.CreateDirectory(imagesFolder);
                    }
                    string fileName = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(selectedFilePath);
                    string destinationPath = System.IO.Path.Combine(imagesFolder, fileName);
                    System.IO.File.Copy(selectedFilePath, destinationPath, true);
                    ImagePath = destinationPath;
                }
                catch (Exception ex) { MessageBox.Show("Lỗi khi chọn ảnh: " + ex.Message); }
            }
        }

        private async Task ImportExcelAsync()
        {
            var rows = ImportFromExcel();
            if (rows.Count == 0) return;

            IsLoading = true;
            ImportProgress = 0;

            await Task.Run(() =>
            {
                int total = rows.Count;
                using (SqlConnection con = new SqlConnection(App.ConnectionString))
                {
                    con.Open();
                    for (int i = 0; i < total; i++)
                    {
                        var item = rows[i];
                        string query = "INSERT INTO Medicines (MedicineName, Unit, Price, Quantity, ImagePath, CategoryId) VALUES (@Name, @Unit, @Price, @Qty, '', 1)";
                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@Name", item.Name);
                        cmd.Parameters.AddWithValue("@Unit", item.Unit);
                        cmd.Parameters.AddWithValue("@Price", item.Price);
                        cmd.Parameters.AddWithValue("@Qty", item.Quantity);
                        cmd.ExecuteNonQuery();

                        int percent = (i + 1) * 100 / total;
                        App.Current.Dispatcher.Invoke(() => { ImportProgress = percent; });
                    }
                }
            });

            IsLoading = false;
            LoadMedicinesFromDatabase();
            MessageBox.Show("Import Excel thành công!");
        }

        private List<Medicine> ImportFromExcel()
        {
            var list = new List<Medicine>();
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
            dlg.Filter = "Excel Files|*.xlsx;*.xls";
            dlg.Title = "Chọn file Excel danh sách thuốc";

            if (dlg.ShowDialog() != true) return list;

            try
            {
                using (var package = new ExcelPackage(new FileInfo(dlg.FileName)))
                {
                    var worksheet = package.Workbook.Worksheets[0];
                    if (worksheet == null) return list;

                    int rowCount = worksheet.Dimension.Rows;
                    for (int row = 2; row <= rowCount; row++)
                    {
                        string name = worksheet.Cells[row, 1].Text.Trim();
                        if (string.IsNullOrEmpty(name)) continue;

                        string unit = worksheet.Cells[row, 2].Text.Trim();
                        decimal.TryParse(worksheet.Cells[row, 3].Text.Trim(), out decimal price);
                        int.TryParse(worksheet.Cells[row, 4].Text.Trim(), out int quantity);

                        list.Add(new Medicine { Name = name, Unit = unit, Price = price, Quantity = quantity });
                    }
                }
            }
            catch (Exception ex) { MessageBox.Show("Lỗi khi đọc file Excel: " + ex.Message); }
            return list;
        }
            


        //( thêm phần nhập số đth và tích điểm )
        public string CustomerPhone { get; set; }
        private Customer _selectedCustomer;
        public Customer SelectedCustomer
        {
            get => _selectedCustomer;
            set
            {
                _selectedCustomer = value;
                OnPropertyChanged();
            }
        }

        private void FindCustomerByPhone()
        {
            string query = "SELECT * FROM Customers WHERE Phone = @Phone";

            using (SqlConnection con = new SqlConnection(App.ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Phone", CustomerPhone);

                var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    SelectedCustomer = new Customer
                    {
                        Id = (int)reader["Id"],
                        CustomerName = reader["CustomerName"].ToString(),
                        Phone = reader["Phone"].ToString(),
                        LoyaltyPoints = (int)reader["LoyaltyPoints"]
                    };
                }
            }
        }
    }
    public static class AppSession
    {
        public static User CurrentUser { get; set; }
    }
}