using PharmacySalesApp.Models;
using System.Data.SqlClient;

namespace PharmacySalesApp.Services
{
    public class AuthService
    {
        public User? Login(string username, string password)
        {
            using SqlConnection con = new SqlConnection(App.ConnectionString);
            con.Open();

            string query = @"
                SELECT Id, Username,Name, Role
                FROM Users
                WHERE Username = @Username AND Password = @Password";

            using SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Username", username);
            cmd.Parameters.AddWithValue("@Password", password);

            using SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                return new User
                {
                    Id = Convert.ToInt32(reader["Id"]),
                    Username = reader["Username"].ToString() ?? "",
                    Name = reader["Name"].ToString() ?? "",
                    Role = reader["Role"].ToString() ?? ""
                };
            }

            return null;
        }
    }
}