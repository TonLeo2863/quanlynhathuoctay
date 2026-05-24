using System.Windows;
using PharmacySalesApp.ViewModels;
using OfficeOpenXml;
using System.IO;
using System.Linq;

namespace PharmacySalesApp.Views
{
    public partial class MainWindow : Window 
    {
        public MainWindow()
        {
            ExcelPackage.License.SetNonCommercialPersonal("PharmacySalesApp");
            InitializeComponent();
            DataContext = new MainViewModel();
        }
        private void DeleteSelectedMedicines_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as MainViewModel;
            if (vm == null) return;

            var selectedMedicines = MedicinesDataGrid.SelectedItems
                .Cast<PharmacySalesApp.Models.Medicine>()
                .ToList();

            if (selectedMedicines.Count == 0)
            {
                MessageBox.Show("Vui lòng chọn thuốc cần xóa.");
                return;
            }

            vm.DeleteMedicines(selectedMedicines);
        }
        private void Logout_Click(object sender, RoutedEventArgs e)
        {
            AppSession.CurrentUser = null;

            LoginView loginView = new LoginView();
            Application.Current.MainWindow = loginView;
            loginView.Show();

            this.Close();
        }
    }
}