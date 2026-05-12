using System.Windows;
using PharmacySalesApp.ViewModels;
using OfficeOpenXml;
using System.IO;

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
    }
}