using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models.Purchases
{
    public class PurchaseInvoiceLine
    {
        public int MedicineId { get; set; }
        public string MedicineCode { get; set; } = "";
        public string MedicineName { get; set; } = "";
        public string BatchNumber { get; set; } = "";
        public DateTime ExpiryDate { get; set; }
        public int Quantity { get; set; }
        public decimal ImportPrice { get; set; }

        public decimal Total => Quantity * ImportPrice;
    }
}
