using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

namespace ShopHunter
{
    public static class ReportEngine
    {
        private static readonly string[] Blocked = new string[]
        {
            "process", "diagnostics", "cmd.exe", "cmd /c", "powershell", "pwsh",
            "system.io", "file.", "directory.", "registry", "wscript",
            "shell.application", "xp_cmdshell", "webclient", "downloadstring",
            "startinfo", "environment.", "processstartinfo"
        };

        public static bool IsBlocked(string template, out string token)
        {
            string lower = template.ToLowerInvariant();
            foreach (string b in Blocked)
            {
                if (lower.Contains(b))
                {
                    token = b;
                    return true;
                }
            }
            token = null;
            return false;
        }

        public static string Export(string xsltTemplate)
        {
            string xmlData = BuildReportXml();

            var settings = new XsltSettings(enableDocumentFunction: true, enableScript: true);
            var xslt = new XslCompiledTransform();
            using (var sr = new StringReader(xsltTemplate))
            using (var xr = XmlReader.Create(sr))
                xslt.Load(xr, settings, new XmlUrlResolver());

            var sb = new StringBuilder();
            using (var xmlReader = XmlReader.Create(new StringReader(xmlData)))
            using (var writer = new StringWriter(sb))
                xslt.Transform(xmlReader, null, writer);

            return sb.ToString();
        }

        private static string BuildReportXml()
        {
            int totalOrders, pendingOrders, totalProducts;
            decimal totalRevenue;
            Store.Stats(out totalOrders, out totalRevenue, out totalProducts, out pendingOrders);

            int delivered = 0, cancelled = 0;
            foreach (var o in Store.Orders())
            {
                if (o.Status == "delivered") delivered++;
                if (o.Status == "cancelled") cancelled++;
            }

            var sb = new StringBuilder();
            sb.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            sb.AppendLine("<report>");
            sb.AppendLine("  <summary>");
            sb.AppendLine("    <total_orders>" + totalOrders + "</total_orders>");
            sb.AppendLine("    <total_revenue>" + totalRevenue.ToString("F2") + "</total_revenue>");
            sb.AppendLine("    <delivered_orders>" + delivered + "</delivered_orders>");
            sb.AppendLine("    <pending_orders>" + pendingOrders + "</pending_orders>");
            sb.AppendLine("    <cancelled_orders>" + cancelled + "</cancelled_orders>");
            sb.AppendLine("  </summary>");
            sb.AppendLine("  <orders>");
            foreach (var o in Store.Orders(50))
            {
                sb.AppendLine("    <order>");
                sb.AppendLine("      <id>" + o.Id + "</id>");
                sb.AppendLine("      <code>" + XmlEnc(o.OrderCode) + "</code>");
                sb.AppendLine("      <customer>" + XmlEnc(o.CustomerName) + "</customer>");
                sb.AppendLine("      <total>" + o.Total.ToString("F2") + "</total>");
                sb.AppendLine("      <status>" + XmlEnc(o.Status) + "</status>");
                sb.AppendLine("      <date>" + XmlEnc(o.CreatedAt) + "</date>");
                sb.AppendLine("    </order>");
            }
            sb.AppendLine("  </orders>");
            sb.AppendLine("</report>");
            return sb.ToString();
        }

        private static string XmlEnc(string s)
        {
            if (s == null) return "";
            return s.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;");
        }

        public static string Sha256(string input)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(input ?? ""));
                var sb = new StringBuilder();
                foreach (byte b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }
    }
}
