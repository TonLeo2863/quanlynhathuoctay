using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PharmacySalesApp.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Username { get; set; } = string.Empty;

        public string Name { get; set; } = string.Empty; // tên hiển thị

        public string Role { get; set; } = "User"; // Admin / User / Cashier
    }
}
