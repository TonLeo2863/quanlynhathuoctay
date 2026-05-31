using PharmacySalesApp.ViewModels.Purchases;
using System.Windows;

namespace PharmacySalesApp.Views.Purchases
{
    public partial class PurchaseView : Window
    {
        public PurchaseView()
        {
            InitializeComponent();
            DataContext = new PurchaseViewModel();
        }
    }
}