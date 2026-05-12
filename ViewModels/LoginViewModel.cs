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

        private void Login(object obj)
        {
            if (Username == "admin" && Password == "123")
            {
                AppSession.CurrentUser = new User
                {
                    Id = 1,
                    Username = Username
                };

                // TODO: chuyển sang MainView
            }
        }
    }
}