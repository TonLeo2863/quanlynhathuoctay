using PharmacySalesApp.ViewModels.Statistics;
using System.Windows;

namespace PharmacySalesApp.Views.Statistics
{
    public partial class StatisticsView : Window
    {
        public StatisticsView()
        {
            InitializeComponent();
            DataContext = new StatisticsViewModel();
        }
    }
}