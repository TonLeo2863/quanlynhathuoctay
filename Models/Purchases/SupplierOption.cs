using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models.Purchases
{
    public class SupplierOption
    {
        public int Id { get; set; }
        public string Code { get; set; } = "";
        public string Name { get; set; } = "";

        public override string ToString()
        {
            return Name;
        }
    }
}
