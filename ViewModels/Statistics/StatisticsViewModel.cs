using PharmacySalesApp.Commands;
using PharmacySalesApp.Models.Statistics;
using PharmacySalesApp.Repositories.Statistics;
using PharmacySalesApp.Services.Reports;
using PharmacySalesApp.ViewModels;
using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;

namespace PharmacySalesApp.ViewModels.Statistics
{
    public class StatisticsViewModel : BaseViewModel
    {
        private readonly StatisticsRepository _repository = new StatisticsRepository();
        private readonly FlowDocumentReportService _reportService = new FlowDocumentReportService();

        public ObservableCollection<RevenueInvoiceRow> RevenueInvoices { get; } = new ObservableCollection<RevenueInvoiceRow>();
        public ObservableCollection<RevenueByDate> RevenueByDates { get; } = new ObservableCollection<RevenueByDate>();

        private DateTime _fromDate = DateTime.Today.AddDays(-30);
        public DateTime FromDate
        {
            get => _fromDate;
            set
            {
                _fromDate = value;
                OnPropertyChanged();
            }
        }

        private DateTime _toDate = DateTime.Today;
        public DateTime ToDate
        {
            get => _toDate;
            set
            {
                _toDate = value;
                OnPropertyChanged();
            }
        }

        private int _totalInvoiceCount;
        public int TotalInvoiceCount
        {
            get => _totalInvoiceCount;
            set
            {
                _totalInvoiceCount = value;
                OnPropertyChanged();
            }
        }

        private decimal _totalRevenue;
        public decimal TotalRevenue
        {
            get => _totalRevenue;
            set
            {
                _totalRevenue = value;
                OnPropertyChanged();
            }
        }

        public ICommand LoadCommand { get; }
        public ICommand PrintSimpleReportCommand { get; }
        public ICommand PrintAdvancedReportCommand { get; }

        public StatisticsViewModel()
        {
            LoadCommand = new RelayCommand(_ => LoadData());
            PrintSimpleReportCommand = new RelayCommand(_ => PrintSimpleReport());
            PrintAdvancedReportCommand = new RelayCommand(_ => PrintAdvancedReport());

            LoadData();
        }

        private void LoadData()
        {
            if (FromDate.Date > ToDate.Date)
            {
                MessageBox.Show("Từ ngày không được lớn hơn đến ngày.");
                return;
            }

            try
            {
                RevenueInvoices.Clear();
                RevenueByDates.Clear();

                var invoices = _repository.GetRevenueInvoices(FromDate, ToDate);
                var byDates = _repository.GetRevenueByDate(FromDate, ToDate);

                foreach (var invoice in invoices)
                    RevenueInvoices.Add(invoice);

                foreach (var item in byDates)
                    RevenueByDates.Add(item);

                TotalInvoiceCount = RevenueInvoices.Count;
                TotalRevenue = RevenueInvoices.Sum(x => x.TotalAmount);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải thống kê doanh thu: " + ex.Message);
            }
        }

        private void PrintSimpleReport()
        {
            if (RevenueInvoices.Count == 0)
            {
                MessageBox.Show("Không có dữ liệu để in report.");
                return;
            }

            _reportService.ShowSimpleRevenueReport(RevenueInvoices, FromDate, ToDate);
        }

        private void PrintAdvancedReport()
        {
            if (RevenueByDates.Count == 0)
            {
                MessageBox.Show("Không có dữ liệu để in report.");
                return;
            }

            _reportService.ShowAdvancedRevenueReport(RevenueByDates, FromDate, ToDate);
        }
    }
}