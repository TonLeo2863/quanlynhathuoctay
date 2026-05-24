using PharmacySalesApp.Commands;
using PharmacySalesApp.Models;
using PharmacySalesApp.Views;
using System;
using System.Windows;
using System.Windows.Input;
using System.Linq;
using PharmacySalesApp.Services;

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

            AuthService authService = new AuthService();
            var user = authService.Login(Username, Password);

            if (user == null)
            {
                MessageBox.Show("Sai tài khoản hoặc mật khẩu.");
                return;
            }

            AppSession.CurrentUser = user;

            if (user.Role == "NhanVien" || user.Role == "Cashier")
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
            Application.Current.MainWindow = mainWindow;
            mainWindow.Show();

            CloseLoginWindow();
        }

        private void OpenManagerMain()
        {
            MainWindow mainWindow = new MainWindow();
            Application.Current.MainWindow = mainWindow;
            mainWindow.Show();

            CloseLoginWindow();
        }

        private void CloseLoginWindow()
        {
            Application.Current.Windows
            .OfType<LoginView>()
            .FirstOrDefault()
            ?.Close();
        }
    }
}