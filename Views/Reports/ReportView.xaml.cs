using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PharmacySalesApp.Views.Reports
{
    /// <summary>
    /// Interaction logic for ReportView.xaml
    /// </summary>
    public partial class ReportView : UserControl
    {
        public ReportView()
        {
            InitializeComponent();
        }

        private void BtnPrintInvoice_Click(object sender, RoutedEventArgs e)
        {
            lblReportTitle.Inlines.Clear();
            lblReportTitle.Inlines.Add("HÓA ĐƠN BÁN LẺ");
            PrintDocument();
        }

        private void BtnPrintReport_Click(object sender, RoutedEventArgs e)
        {
            lblReportTitle.Inlines.Clear();
            lblReportTitle.Inlines.Add("BÁO CÁO DOANH THU TỔNG HỢP");
            PrintDocument();
        }

        private void PrintDocument()
        {
            PrintDialog printDialog = new PrintDialog();
            if (printDialog.ShowDialog() == true)
            {
                // In FlowDocument
                printDialog.PrintDocument(((IDocumentPaginatorSource)reportDocument).DocumentPaginator, "In Báo Cáo");
            }
        }
    }
}
