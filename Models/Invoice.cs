using System;
using System.Collections.ObjectModel;

namespace PharmacySalesApp.Models
{
    public class Invoice
    {
        public string InvoiceId { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public decimal TotalAmount { get; set; }
        public string Note { get; set; } = string.Empty;
        public ObservableCollection<CartItem> Details { get; set; } = new ObservableCollection<CartItem>();
    }
}