using System;

namespace PharmacySalesApp.Models.Statistics
{
    public class RevenueInvoiceRow
    {
        public string InvoiceCode { get; set; } = "";
        public DateTime CreatedDate { get; set; }
        public string EmployeeName { get; set; } = "";
        public string CustomerName { get; set; } = "";
        public decimal TotalAmount { get; set; }
        public string Note { get; set; } = "";
    }
}