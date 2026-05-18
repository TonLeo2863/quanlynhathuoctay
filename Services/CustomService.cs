using System.Data.SqlClient;

namespace PharmacySalesApp.Services
{
    public class CustomerService
    {
        public CustomerService()
        {
        }

        public bool CustomerExists(string phone)
        {
            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            string query = "SELECT COUNT(*) FROM Customers WHERE Phone = @Phone";

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Phone", phone);

            int count = Convert.ToInt32(cmd.ExecuteScalar());
            return count > 0;
        }
    }
}