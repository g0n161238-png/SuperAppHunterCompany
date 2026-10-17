using System.Text;
using System.Web;

namespace ShopHunter
{
    public static class UI
    {
        private const string IconGrid =
            "<svg width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\" " +
            "stroke-linecap=\"round\" stroke-linejoin=\"round\" viewBox=\"0 0 16 16\">" +
            "<rect x=\"1\" y=\"1\" width=\"5.5\" height=\"5.5\" rx=\"1\"/>" +
            "<rect x=\"9.5\" y=\"1\" width=\"5.5\" height=\"5.5\" rx=\"1\"/>" +
            "<rect x=\"1\" y=\"9.5\" width=\"5.5\" height=\"5.5\" rx=\"1\"/>" +
            "<rect x=\"9.5\" y=\"9.5\" width=\"5.5\" height=\"5.5\" rx=\"1\"/></svg>";

        private const string IconBox =
            "<svg width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\" " +
            "stroke-linecap=\"round\" stroke-linejoin=\"round\" viewBox=\"0 0 16 16\">" +
            "<path d=\"M2 5.5l6-3.5 6 3.5\"/><path d=\"M8 2v12\"/>" +
            "<path d=\"M2 5.5v5l6 3.5 6-3.5v-5l-6-3.5-6 3.5z\"/></svg>";

        private const string IconList =
            "<svg width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\" " +
            "stroke-linecap=\"round\" viewBox=\"0 0 16 16\">" +
            "<line x1=\"3\" y1=\"4.5\" x2=\"13\" y2=\"4.5\"/>" +
            "<line x1=\"3\" y1=\"8\" x2=\"13\" y2=\"8\"/>" +
            "<line x1=\"3\" y1=\"11.5\" x2=\"9\" y2=\"11.5\"/></svg>";

        private const string IconBar =
            "<svg width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\" " +
            "stroke-linecap=\"round\" stroke-linejoin=\"round\" viewBox=\"0 0 16 16\">" +
            "<rect x=\"1.5\" y=\"9\" width=\"3\" height=\"5.5\" rx=\"0.5\"/>" +
            "<rect x=\"6.5\" y=\"5\" width=\"3\" height=\"9.5\" rx=\"0.5\"/>" +
            "<rect x=\"11.5\" y=\"2\" width=\"3\" height=\"12.5\" rx=\"0.5\"/></svg>";

        private const string IconOut =
            "<svg width=\"15\" height=\"15\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\" " +
            "stroke-linecap=\"round\" stroke-linejoin=\"round\" viewBox=\"0 0 16 16\">" +
            "<path d=\"M10 3H3a1 1 0 00-1 1v8a1 1 0 001 1h7\"/>" +
            "<polyline points=\"12,5.5 14.5,8 12,10.5\"/>" +
            "<line x1=\"7\" y1=\"8\" x2=\"14.5\" y2=\"8\"/></svg>";

        public static string Enc(string s)
        {
            if (s == null) return "";
            return HttpUtility.HtmlEncode(s);
        }

        public static string Sidebar(string active)
        {
            string fullName = Security.CurrentFullName;
            string role     = Security.CurrentRole;

            var sb = new StringBuilder();
            sb.AppendLine("<nav class=\"sidebar\">");

            sb.AppendLine("  <div class=\"sidebar-brand\">");
            sb.AppendLine("    <div class=\"brand-icon\">S</div>");
            sb.AppendLine("    <span class=\"brand-text\">ShopHunter</span>");
            sb.AppendLine("  </div>");

            sb.AppendLine("  <div class=\"sidebar-user\">");
            sb.AppendLine("    <div class=\"su-avatar\">" + Initials(fullName) + "</div>");
            sb.AppendLine("    <div class=\"su-info\">");
            sb.AppendLine("      <div class=\"su-name\">" + Enc(fullName) + "</div>");
            sb.AppendLine("      <div class=\"su-role\">" + Enc(RoleLabel(role)) + "</div>");
            sb.AppendLine("    </div>");
            sb.AppendLine("  </div>");

            sb.AppendLine("  <ul class=\"sidebar-nav\">");
            sb.AppendLine(NavItem("/admin/",              "dashboard", active, IconGrid, "Tổng quan"));
            sb.AppendLine(NavItem("/admin/products.aspx", "products",  active, IconBox,  "Sản phẩm"));
            sb.AppendLine(NavItem("/admin/orders.aspx",   "orders",    active, IconList, "Đơn hàng"));
            sb.AppendLine(NavItem("/admin/reports.aspx",  "reports",   active, IconBar,  "Báo cáo"));
            sb.AppendLine("  </ul>");

            sb.AppendLine("  <div class=\"sidebar-footer\">");
            sb.AppendLine("    <a href=\"/admin/logout.aspx\" class=\"sidebar-logout\">");
            sb.AppendLine("      <span class=\"icon\">" + IconOut + "</span>");
            sb.AppendLine("      Đăng xuất");
            sb.AppendLine("    </a>");
            sb.AppendLine("  </div>");
            sb.AppendLine("</nav>");
            return sb.ToString();
        }

        private static string Initials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "?";
            string[] parts = name.Trim().Split(
                new char[] { ' ' }, System.StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
                return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        private static string RoleLabel(string role)
        {
            switch (role)
            {
                case "admin":   return "Quản trị viên";
                case "manager": return "Quản lý";
                case "staff":   return "Nhân viên";
                default:        return role;
            }
        }

        private static string NavItem(string href, string key, string active,
                                       string icon, string label)
        {
            string cls = (key == active) ? " class=\"active\"" : "";
            return "    <li" + cls + "><a href=\"" + href + "\">"
                 + "<span class=\"icon\">" + icon + "</span>"
                 + label + "</a></li>";
        }

        public static string Topbar()
        {
            string fullName = Security.CurrentFullName;
            string role     = Security.CurrentRole;
            var sb = new StringBuilder();
            sb.AppendLine("<div class=\"topbar\">");
            sb.AppendLine("  <div class=\"topbar-breadcrumb\">");
            sb.AppendLine("    <span class=\"tb-site\">ShopHunter</span>");
            sb.AppendLine("    <span class=\"tb-sep\">›</span>");
            sb.AppendLine("    <span class=\"tb-page\">Admin</span>");
            sb.AppendLine("  </div>");
            sb.AppendLine("  <div class=\"topbar-right\">");
            sb.AppendLine("    <div class=\"user-chip\">");
            sb.AppendLine("      <div class=\"uc-avatar\">" + Initials(fullName) + "</div>");
            sb.AppendLine("      <div class=\"uc-info\">");
            sb.AppendLine("        <span class=\"uc-name\">" + Enc(fullName) + "</span>");
            sb.AppendLine("        <span class=\"uc-role\">" + Enc(RoleLabel(role)) + "</span>");
            sb.AppendLine("      </div>");
            sb.AppendLine("    </div>");
            sb.AppendLine("  </div>");
            sb.AppendLine("</div>");
            return sb.ToString();
        }
    }
}
