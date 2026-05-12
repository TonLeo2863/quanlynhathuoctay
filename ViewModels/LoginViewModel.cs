using PharmacyApp.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using   PharmacySalesApp.Models;

namespace PharmacySalesApp.ViewModels
{
    public class LoginViewModel : BaseViewModel
    {
        private string _username;
        public string Username
        {
            get => _username;
            set { _username = value; OnPropertyChanged(); }
        }

        private string _password;
        public string Password
        {
            get => _password;
            set { _password = value; OnPropertyChanged(); }
        }

        public ICommand LoginCommand { get; }

        public LoginViewModel()
        {
            LoginCommand = new RelayCommand(Login);
        }

        var user = authService.Login(Username, Password);

if (user.Role == "Employee")
{
    OpenEmployeeMain();
    }
else if (user.Role == "Manager" || user.Role == "Admin")
{
    OpenManagerMain();
}
    }
}