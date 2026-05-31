using System;

namespace PharmacySalesApp.Models.Statistics
{
    public class RevenueByDate
    {
        public DateTime Date { get; set; }
        public int InvoiceCount { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}