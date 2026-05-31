namespace PharmacySalesApp.Helper
{
    public static class RoleHelper
    {
        public const string Admin = "Admin";
        public const string Manager = "Manager";
        public const string NhanVien = "NhanVien";

        public static bool IsAdmin(string? role)
        {
            return role == Admin;
        }

        public static bool IsManager(string? role)
        {
            return role == Manager;
        }

        public static bool IsNhanVien(string? role)
        {
            return role == NhanVien;
        }

        public static bool CanManageSystem(string? role)
        {
            return role == Admin;
        }

        public static bool CanManageEmployees(string? role)
        {
            return role == Admin;
        }

        public static bool CanManageStore(string? role)
        {
            return role == Admin || role == Manager;
        }

        public static bool CanSell(string? role)
        {
            return role == Admin || role == Manager || role == NhanVien;
        }

        public static bool CanViewReports(string? role)
        {
            return role == Admin || role == Manager;
        }
    }
}