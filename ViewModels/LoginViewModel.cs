using PharmacySalesApp.Commands;
using PharmacySalesApp.Models;
using PharmacySalesApp.Views;
using System;
using System.Windows;
using System.Windows.Input;
using System.Linq;

namespace PharmacySalesApp.ViewModels
{
    public class LoginViewModel : BaseViewModel
    {
        private string _username = string.Empty;
        public string Username
        {
            get => _username;
            set
            {
                _username = value;
                OnPropertyChanged();
            }
        }

        private string _password = string.Empty;
        public string Password
        {
            get => _password;
            set
            {
                _password = value;
                OnPropertyChanged();
            }
        }

        public ICommand LoginCommand { get; }

        public LoginViewModel()
        {
            LoginCommand = new RelayCommand(_ => Login());
        }

        private void Login()
        {
            if (string.IsNullOrWhiteSpace(Username) || string.IsNullOrWhiteSpace(Password))
            {
                MessageBox.Show("Vui lòng nhập tài khoản và mật khẩu.");
                return;
            }

            // Tạm thời cho chạy app trước.
            // Sau khi app build được, mình sẽ chỉnh tiếp phần kiểm tra user từ database.
            var user = new User
            {
                Id = 1,
                Username = Username,
                Role = "Admin"
            };

            AppSession.CurrentUser = user;

            if (user.Role == "Employee")
            {
                OpenEmployeeMain();
            }
            else if (user.Role == "Manager" || user.Role == "Admin")
            {
                OpenManagerMain();
            }
            else
            {
                MessageBox.Show("Tài khoản không có quyền truy cập.");
            }
        }

        private void OpenEmployeeMain()
        {
            MainWindow mainWindow = new MainWindow();
            mainWindow.Show();

            CloseLoginWindow();
        }

        private void OpenManagerMain()
        {
            MainWindow mainWindow = new MainWindow();
            mainWindow.Show();

            CloseLoginWindow();
        }

        private void CloseLoginWindow()
        {
            Application.Current.Windows
                .OfType<Window>()
                .FirstOrDefault(w => w.IsActive)
                ?.Close();
        }
    }
}