<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" ValidateRequest="false" %>
<%@ Import Namespace="ShopHunter" %>
<script runat="server">
    string resultText = null;
    string errorText  = null;
    string shareLink  = null;
    bool   isError    = false;

    string DefaultTemplate()
    {
        return
"<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n" +
"<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n" +
"  <xsl:output method=\"html\" indent=\"yes\"/>\r\n" +
"  <xsl:template match=\"/report\">\r\n" +
"    <table border=\"1\" cellpadding=\"5\" style=\"border-collapse:collapse;font-family:Arial,sans-serif;font-size:13px\">\r\n" +
"      <caption style=\"font-weight:bold;padding:8px 0\">ShopHunter - Revenue Summary Report</caption>\r\n" +
"      <tr style=\"background:#f0f0f0\"><th>Metric</th><th>Value</th></tr>\r\n" +
"      <tr><td>Total Orders</td><td><xsl:value-of select=\"summary/total_orders\"/></td></tr>\r\n" +
"      <tr><td>Total Revenue (VND)</td><td><xsl:value-of select=\"summary/total_revenue\"/></td></tr>\r\n" +
"      <tr><td>Active Products</td><td><xsl:value-of select=\"summary/active_products\"/></td></tr>\r\n" +
"      <tr><td>Delivered Orders</td><td><xsl:value-of select=\"summary/delivered_orders\"/></td></tr>\r\n" +
"      <tr><td>Pending Orders</td><td><xsl:value-of select=\"summary/pending_orders\"/></td></tr>\r\n" +
"      <tr><td>Cancelled Orders</td><td><xsl:value-of select=\"summary/cancelled_orders\"/></td></tr>\r\n" +
"    </table>\r\n" +
"  </xsl:template>\r\n" +
"</xsl:stylesheet>\r\n";
    }

    string MakeShareLink(string template, string fmt)
    {
        string b64     = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(template));
        string origin  = Request.Url.GetLeftPart(UriPartial.Authority);
        return origin + "/admin/reports.aspx?tpl=" + Server.UrlEncode(b64)
             + "&format=" + Server.UrlEncode(fmt);
    }

    void RunExport(string template, string fmt)
    {
        string sha = ReportEngine.Sha256(template);
        AppLog.Notice("report_export", AppLog.F(
            "format", fmt,
            "template_len", template.Length,
            "template_sha256", sha,
            "user", Security.CurrentUser,
            "preview", template.Length > 300 ? template.Substring(0, 300) : template));

        string token;
        if (ReportEngine.IsBlocked(template, out token))
        {
            AppLog.Warn("report_blocked", AppLog.F("token", token, "sha256", sha));
            isError   = true;
            errorText = "Mẫu chứa từ khoá không được phép: " + token;
        }
        else
        {
            try   { resultText = ReportEngine.Export(template); }
            catch (Exception ex)
            {
                AppLog.Warn("report_error", AppLog.F("err", ex.GetType().Name + ": " + ex.Message, "sha256", sha));
                isError   = true;
                errorText = "Không thể xử lý mẫu: " + ex.GetType().Name + ": " + ex.Message;
            }
        }
    }

    void Page_Load(object sender, EventArgs e)
    {
        if (!Security.Require("staff")) return;

        // ---- GET quick-preview (link chia sẻ) ----
        if (Request.HttpMethod == "GET" &&
            (Request.QueryString["tpl"] != null ||
             Request.QueryString["template"] != null))
        {
            string template = "";
            string tpl = Request.QueryString["tpl"];
            if (!string.IsNullOrEmpty(tpl))
            {
                AppLog.Notice("report_preview_tpl", AppLog.F(
                    "tpl_b64", tpl.Length > 800 ? tpl.Substring(0, 800) : tpl,
                    "tpl_len", tpl.Length,
                    "user", Security.CurrentUser,
                    "ip", Request.UserHostAddress));
                try { template = System.Text.Encoding.UTF8.GetString(
                          Convert.FromBase64String(tpl.Trim().Replace(' ', '+'))); }
                catch { template = ""; }
            }
            else { template = Request.QueryString["template"] ?? ""; }

            RunExport(template, Request.QueryString["format"] ?? "html");
            Response.ContentType = "text/html; charset=utf-8";
            Response.Write(isError
                ? "<!-- preview error: " + Server.HtmlEncode(errorText) + " -->"
                : resultText ?? "");
            Response.End();
            return;
        }

        // ---- Builder UI + POST export yêu cầu manager ----
        if (!Security.Require("manager")) return;

        if (Request.HttpMethod == "POST" && Request.Form["action"] == "export")
        {
            if (!Security.CheckCsrf()) { Response.StatusCode = 400; Response.Write("CSRF"); Response.End(); return; }
            string tmpl = Request.Form["template"] ?? "";
            string fmt  = Request.Form["format"]   ?? "html";
            RunExport(tmpl, fmt);
            if (!isError)
                shareLink = MakeShareLink(tmpl, fmt);
        }
    }
</script>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Báo cáo doanh thu – ShopHunter Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/admin/admin.css">
<style>
.share-box{background:#f0f9ff;border:1px solid #bae6fd;border-radius:8px;padding:14px 16px;margin-bottom:20px}
.share-box label{font-size:12px;font-weight:600;color:#0369a1;text-transform:uppercase;letter-spacing:.4px;display:block;margin-bottom:6px}
.share-url{display:flex;gap:8px;align-items:center}
.share-url input{flex:1;padding:7px 10px;border:1px solid #bae6fd;border-radius:6px;font-size:12px;
                 font-family:'Consolas',monospace;background:#fff;color:#0c4a6e;outline:none}
.share-url button{padding:7px 14px;background:#0284c7;color:#fff;border:none;border-radius:6px;
                  font-size:12px;font-weight:600;cursor:pointer;white-space:nowrap}
.share-url button:hover{background:#0369a1}
</style>
</head>
<body>
<div class="layout">
  <%= UI.Sidebar("reports") %>
  <div class="main">
    <%= UI.Topbar() %>
    <div class="content">
      <h1>Báo cáo &amp; Xuất dữ liệu</h1>
      <p class="muted">
        Xuất báo cáo doanh thu theo mẫu XSLT tuỳ chỉnh. Sau khi xuất thành công,
        hệ thống tạo link chia sẻ (GET) để gửi cho bộ phận kế toán xem trực tiếp trên trình duyệt.
      </p>

      <div class="card">
        <form method="post">
          <input type="hidden" name="csrf_token" value="<%= Security.CsrfToken() %>" />
          <input type="hidden" name="action"     value="export" />
          <div class="form-row" style="grid-template-columns:200px 1fr">
            <div class="form-group" style="margin-bottom:0">
              <label>Định dạng đầu ra</label>
              <select name="format">
                <option value="html">HTML</option>
                <option value="xml">XML</option>
                <option value="text">Text / CSV</option>
              </select>
            </div>
          </div>
          <div class="form-group" style="margin-top:16px">
            <label>Mẫu XSLT</label>
            <textarea name="template" class="mono"><%= UI.Enc(
                Request.HttpMethod == "POST"
                    ? (Request.Form["template"] ?? "")
                    : DefaultTemplate()) %></textarea>
          </div>
          <button class="btn btn-primary">Xuất báo cáo</button>
        </form>
      </div>

      <% if (isError) { %>
        <div class="flash error"><%= UI.Enc(errorText) %></div>
      <% } else if (resultText != null) { %>

        <% if (shareLink != null) { %>
        <div class="share-box">
          <label>Link chia sẻ báo cáo (gửi cho kế toán)</label>
          <div class="share-url">
            <input type="text" id="shareInput" readonly value="<%= UI.Enc(shareLink) %>" />
            <button onclick="copyLink();return false;">Sao chép</button>
          </div>
        </div>
        <script>
        function copyLink(){
          var el=document.getElementById('shareInput');
          el.select(); el.setSelectionRange(0,99999);
          document.execCommand('copy');
          event.target.textContent='Đã chép ✓';
          setTimeout(function(){event.target.textContent='Sao chép'},2000);
        }
        </script>
        <% } %>

        <h2>Kết quả xem trước</h2>
        <div class="result"><pre class="mono"><%= UI.Enc(resultText) %></pre></div>
      <% } %>
    </div>
  </div>
</div>
</body></html>
