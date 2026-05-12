using System;
using System.Threading.Tasks;
using System.Windows;
using PharmacySalesApp.Views;

namespace PharmacySalesApp
{
    public partial class App : Application
    {
        public static string ConnectionString = @"Server=.;Database=PharmacyDB;Trusted_Connection=True;Encrypt=False;";

        public App()
        {
            this.DispatcherUnhandledException += App_DispatcherUnhandledException;
        }

        private void App_DispatcherUnhandledException(object sender, System.Windows.Threading.DispatcherUnhandledExceptionEventArgs e)
        {
            MessageBox.Show("Phát hiện lỗi hệ thống ngầm:\n\n" + e.Exception.Message,
                            "Cảnh báo lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            e.Handled = true;
        }
        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            try
            {
                SplashView splash = new SplashView();
                this.MainWindow = splash;
                splash.Show();
                await Task.Delay(2500);
                MainWindow mainWindow = new MainWindow();
                this.MainWindow = mainWindow;
                mainWindow.Show();
                splash.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi tải giao diện:\n" + ex.Message,
                                "Cảnh báo lỗi", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}