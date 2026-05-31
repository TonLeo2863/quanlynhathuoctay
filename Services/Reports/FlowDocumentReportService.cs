using PharmacySalesApp.Models.Statistics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Media;

namespace PharmacySalesApp.Services.Reports
{
    public class FlowDocumentReportService
    {
        public void ShowSimpleRevenueReport(
            IEnumerable<RevenueInvoiceRow> rows,
            DateTime fromDate,
            DateTime toDate)
        {
            FlowDocument doc = CreateBaseDocument();

            AddTitle(doc, "BÁO CÁO HÓA ĐƠN BÁN HÀNG");
            AddParagraph(doc, $"Từ ngày {fromDate:dd/MM/yyyy} đến ngày {toDate:dd/MM/yyyy}");
            AddParagraph(doc, $"Ngày in: {DateTime.Now:dd/MM/yyyy HH:mm}");

            Table table = CreateTable(new[] { "Mã hóa đơn", "Ngày bán", "Nhân viên", "Khách hàng", "Tổng tiền" });

            foreach (var row in rows)
            {
                AddRow(table, new[]
                {
                    row.InvoiceCode,
                    row.CreatedDate.ToString("dd/MM/yyyy HH:mm"),
                    row.EmployeeName,
                    row.CustomerName,
                    row.TotalAmount.ToString("N0")
                });
            }

            doc.Blocks.Add(table);

            decimal total = rows.Sum(x => x.TotalAmount);
            AddParagraph(doc, $"TỔNG DOANH THU: {total:N0} đ", true);

            ShowDocument(doc, "Report hóa đơn bán hàng");
        }

        public void ShowAdvancedRevenueReport(
            IEnumerable<RevenueByDate> rows,
            DateTime fromDate,
            DateTime toDate)
        {
            FlowDocument doc = CreateBaseDocument();

            AddTitle(doc, "BÁO CÁO DOANH THU THEO NGÀY");
            AddParagraph(doc, $"Từ ngày {fromDate:dd/MM/yyyy} đến ngày {toDate:dd/MM/yyyy}");
            AddParagraph(doc, $"Ngày in: {DateTime.Now:dd/MM/yyyy HH:mm}");

            Table table = CreateTable(new[] { "Ngày", "Số hóa đơn", "Doanh thu" });

            foreach (var row in rows)
            {
                AddRow(table, new[]
                {
                    row.Date.ToString("dd/MM/yyyy"),
                    row.InvoiceCount.ToString(),
                    row.TotalRevenue.ToString("N0")
                });
            }

            doc.Blocks.Add(table);

            int totalInvoice = rows.Sum(x => x.InvoiceCount);
            decimal totalRevenue = rows.Sum(x => x.TotalRevenue);

            AddParagraph(doc, $"TỔNG SỐ HÓA ĐƠN: {totalInvoice}", true);
            AddParagraph(doc, $"TỔNG DOANH THU: {totalRevenue:N0} đ", true);

            ShowDocument(doc, "Report doanh thu nâng cao");
        }

        private FlowDocument CreateBaseDocument()
        {
            return new FlowDocument
            {
                PagePadding = new Thickness(40),
                FontFamily = new FontFamily("Segoe UI"),
                FontSize = 13,
                ColumnWidth = 900
            };
        }

        private void AddTitle(FlowDocument doc, string title)
        {
            Paragraph paragraph = new Paragraph(new Run(title))
            {
                FontSize = 22,
                FontWeight = FontWeights.Bold,
                TextAlignment = TextAlignment.Center,
                Margin = new Thickness(0, 0, 0, 20)
            };

            doc.Blocks.Add(paragraph);
        }

        private void AddParagraph(FlowDocument doc, string text, bool bold = false)
        {
            Paragraph paragraph = new Paragraph(new Run(text))
            {
                Margin = new Thickness(0, 4, 0, 4)
            };

            if (bold)
                paragraph.FontWeight = FontWeights.Bold;

            doc.Blocks.Add(paragraph);
        }

        private Table CreateTable(string[] headers)
        {
            Table table = new Table
            {
                CellSpacing = 0,
                Margin = new Thickness(0, 15, 0, 15)
            };

            for (int i = 0; i < headers.Length; i++)
            {
                table.Columns.Add(new TableColumn());
            }

            TableRowGroup group = new TableRowGroup();
            table.RowGroups.Add(group);

            TableRow headerRow = new TableRow
            {
                Background = Brushes.LightGray,
                FontWeight = FontWeights.Bold
            };

            foreach (var header in headers)
            {
                headerRow.Cells.Add(CreateCell(header));
            }

            group.Rows.Add(headerRow);

            return table;
        }

        private void AddRow(Table table, string[] values)
        {
            TableRow row = new TableRow();

            foreach (var value in values)
            {
                row.Cells.Add(CreateCell(value));
            }

            table.RowGroups[0].Rows.Add(row);
        }

        private TableCell CreateCell(string text)
        {
            return new TableCell(new Paragraph(new Run(text)))
            {
                BorderBrush = Brushes.Gray,
                BorderThickness = new Thickness(0.5),
                Padding = new Thickness(5)
            };
        }

        private void ShowDocument(FlowDocument doc, string title)
        {
            Window window = new Window
            {
                Title = title,
                Width = 950,
                Height = 720,
                WindowStartupLocation = WindowStartupLocation.CenterScreen
            };

            DockPanel dockPanel = new DockPanel();

            Button printButton = new Button
            {
                Content = "In report",
                Height = 38,
                Width = 120,
                Margin = new Thickness(10),
                HorizontalAlignment = HorizontalAlignment.Right
            };

            printButton.Click += (s, e) =>
            {
                PrintDialog dialog = new PrintDialog();

                if (dialog.ShowDialog() == true)
                {
                    dialog.PrintDocument(
                        ((IDocumentPaginatorSource)doc).DocumentPaginator,
                        title);
                }
            };

            DockPanel.SetDock(printButton, Dock.Top);
            dockPanel.Children.Add(printButton);

            FlowDocumentScrollViewer viewer = new FlowDocumentScrollViewer
            {
                Document = doc,
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto
            };

            dockPanel.Children.Add(viewer);

            window.Content = dockPanel;
            window.ShowDialog();
        }
    }
}