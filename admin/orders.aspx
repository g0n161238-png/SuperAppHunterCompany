<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" %>
<%@ Import Namespace="ShopHunter" %>
<script runat="server">
    string flash = null;
    bool   flashOk = false;
    Order  detail = null;

    void Page_Load(object sender, EventArgs e)
    {
        if (!Security.Require("staff")) return;

        int id; int.TryParse(Request.QueryString["id"], out id);

        if (Request.HttpMethod == "POST")
        {
            if (!Security.CheckCsrf()) { Response.StatusCode = 400; Response.Write("CSRF"); Response.End(); return; }
            string action = Request.Form["action"] ?? "";
            if (action == "update_status" && id > 0)
            {
                string status = Request.Form["status"] ?? "";
                var allowed = new[] { "pending","confirmed","shipping","delivered","cancelled" };
                if (Array.IndexOf(allowed, status) >= 0)
                {
                    bool ok = Store.UpdateOrderStatus(id, status);
                    flash = ok ? "Đã cập nhật trạng thái đơn hàng." : "Không tìm thấy đơn hàng.";
                    flashOk = ok;
                    AppLog.Notice("order_status", AppLog.F("id", id, "status", status, "user", Security.CurrentUser));
                }
            }
        }

        if (id > 0) detail = Store.FindOrder(id);
    }
</script>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Đơn hàng – ShopHunter Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/admin/admin.css">
</head>
<body>
<div class="layout">
  <%= UI.Sidebar("orders") %>
  <div class="main">
    <%= UI.Topbar() %>
    <div class="content">
      <% if (detail != null) { %>
        <div style="margin-bottom:12px"><a href="/admin/orders.aspx" class="btn btn-light btn-sm">← Danh sách</a></div>
        <h1>Đơn hàng #<%= detail.Id %> – <%= UI.Enc(detail.OrderCode) %></h1>
        <% if (flash != null) { %>
          <div class="flash <%= flashOk ? "success" : "error" %>"><%= UI.Enc(flash) %></div>
        <% } %>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
          <div class="card">
            <h2 style="margin-top:0">Thông tin khách hàng</h2>
            <p><strong>Họ tên:</strong> <%= UI.Enc(detail.CustomerName) %></p>
            <p><strong>Email:</strong> <%= UI.Enc(detail.Email) %></p>
            <p><strong>Điện thoại:</strong> <%= UI.Enc(detail.Phone) %></p>
            <p><strong>Địa chỉ:</strong> <%= UI.Enc(detail.Address) %></p>
            <p><strong>Ghi chú:</strong> <%= UI.Enc(detail.Note) %></p>
          </div>
          <div class="card">
            <h2 style="margin-top:0">Thông tin đơn hàng</h2>
            <p><strong>Ngày đặt:</strong> <%= UI.Enc(detail.CreatedAt) %></p>
            <p><strong>Thanh toán:</strong> <%= UI.Enc(detail.PaymentMethod.ToUpper()) %></p>
            <p><strong>Tiền hàng:</strong> <%= detail.Subtotal.ToString("N0") %> ₫</p>
            <p><strong>Phí vận chuyển:</strong> <%= detail.ShippingFee.ToString("N0") %> ₫</p>
            <p><strong>Tổng cộng:</strong> <span style="font-size:17px;font-weight:700;color:var(--primary)"><%= detail.Total.ToString("N0") %> ₫</span></p>
            <p><strong>Trạng thái:</strong> <span class="badge badge-<%= detail.Status %>"><%= UI.Enc(detail.StatusLabel) %></span></p>
            <% if (Security.CurrentRole != "staff") { %>
              <form method="post" style="margin-top:14px;display:flex;gap:10px;align-items:center">
                <input type="hidden" name="csrf_token" value="<%= Security.CsrfToken() %>" />
                <input type="hidden" name="action" value="update_status" />
                <select name="status">
                  <% foreach (var s in new[]{"pending","confirmed","shipping","delivered","cancelled"}) { %>
                    <option value="<%= s %>" <%= detail.Status == s ? "selected" : "" %>><%= new Order{Status=s}.StatusLabel %></option>
                  <% } %>
                </select>
                <button class="btn btn-primary btn-sm">Cập nhật</button>
              </form>
            <% } %>
          </div>
        </div>
        <h2>Sản phẩm trong đơn</h2>
        <div class="card" style="padding:0">
          <table>
            <tr><th>Sản phẩm</th><th>SKU</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr>
            <% foreach (var item in detail.Items) { %>
              <tr>
                <td><%= UI.Enc(item.ProductName) %></td>
                <td class="muted"><%= UI.Enc(item.Sku) %></td>
                <td><%= item.Qty %></td>
                <td><%= item.UnitPrice.ToString("N0") %> ₫</td>
                <td><strong><%= item.LineTotal.ToString("N0") %> ₫</strong></td>
              </tr>
            <% } %>
          </table>
        </div>
      <% } else { %>
        <h1>Quản lý đơn hàng</h1>
        <p class="muted">Danh sách tất cả đơn hàng của cửa hàng.</p>
        <% if (flash != null) { %>
          <div class="flash <%= flashOk ? "success" : "error" %>"><%= UI.Enc(flash) %></div>
        <% } %>
        <div class="card" style="padding:0">
          <table>
            <tr><th>#</th><th>Mã đơn</th><th>Khách hàng</th><th>Điện thoại</th>
                <th>Tổng tiền</th><th>Thanh toán</th><th>Trạng thái</th><th>Ngày đặt</th></tr>
            <% foreach (var o in Store.Orders()) { %>
              <tr>
                <td><%= o.Id %></td>
                <td><a href="?id=<%= o.Id %>"><%= UI.Enc(o.OrderCode) %></a></td>
                <td><%= UI.Enc(o.CustomerName) %></td>
                <td><%= UI.Enc(o.Phone) %></td>
                <td><strong><%= o.Total.ToString("N0") %> ₫</strong></td>
                <td><%= UI.Enc(o.PaymentMethod.ToUpper()) %></td>
                <td><span class="badge badge-<%= o.Status %>"><%= UI.Enc(o.StatusLabel) %></span></td>
                <td class="muted"><%= UI.Enc(o.CreatedAt) %></td>
              </tr>
            <% } %>
          </table>
        </div>
      <% } %>
    </div>
  </div>
</div>
</body></html>
