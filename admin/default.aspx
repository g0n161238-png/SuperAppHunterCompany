<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" %>
<%@ Import Namespace="ShopHunter" %>
<%@ Import Namespace="System.Linq" %>
<script runat="server">
    int totalOrders, totalProducts, pendingOrders;
    decimal totalRevenue;

    void Page_Load(object sender, EventArgs e)
    {
        if (!Security.Require("staff")) return;
        Store.Stats(out totalOrders, out totalRevenue, out totalProducts, out pendingOrders);
    }
</script>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Tổng quan – ShopHunter Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/admin/admin.css">
</head>
<body>
<div class="layout">
  <%= UI.Sidebar("") %>
  <div class="main">
    <%= UI.Topbar() %>
    <div class="content">
      <h1>Tổng quan</h1>
      <p class="muted">Chào mừng trở lại, <strong><%= UI.Enc(Security.CurrentFullName) %></strong>. Dưới đây là số liệu tổng hợp hệ thống.</p>

      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-label">Tổng đơn hàng</div>
          <div class="stat-value"><%= totalOrders %></div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Doanh thu (VNĐ)</div>
          <div class="stat-value primary"><%= totalRevenue.ToString("N0") %></div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Sản phẩm đang bán</div>
          <div class="stat-value success"><%= totalProducts %></div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Chờ xác nhận</div>
          <div class="stat-value warning"><%= pendingOrders %></div>
        </div>
      </div>

      <h2>Đơn hàng gần nhất</h2>
      <div class="card" style="padding:0">
        <table>
          <tr><th>#</th><th>Mã đơn</th><th>Khách hàng</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày đặt</th></tr>
          <% foreach (var o in Store.Orders(8)) { %>
          <tr>
            <td><%= o.Id %></td>
            <td><a href="/admin/orders.aspx?id=<%= o.Id %>"><%= UI.Enc(o.OrderCode) %></a></td>
            <td><%= UI.Enc(o.CustomerName) %></td>
            <td><strong><%= o.Total.ToString("N0") %> ₫</strong></td>
            <td><span class="badge badge-<%= o.Status %>"><%= UI.Enc(o.StatusLabel) %></span></td>
            <td class="muted"><%= UI.Enc(o.CreatedAt) %></td>
          </tr>
          <% } %>
        </table>
      </div>

      <p><a href="/admin/orders.aspx" class="btn btn-light">Xem tất cả đơn hàng →</a></p>
    </div>
  </div>
</div>
</body></html>
