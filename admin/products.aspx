<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" %>
<%@ Import Namespace="ShopHunter" %>
<script runat="server">
    string flash = null;
    bool flashOk = false;

    void Page_Load(object sender, EventArgs e)
    {
        if (!Security.Require("staff")) return;
    }
</script>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Sản phẩm – ShopHunter Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/admin/admin.css">
</head>
<body>
<div class="layout">
  <%= UI.Sidebar("products") %>
  <div class="main">
    <%= UI.Topbar() %>
    <div class="content">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
        <h1>Quản lý sản phẩm</h1>
      </div>
      <p class="muted">Danh sách tất cả sản phẩm trong hệ thống.</p>
      <% if (flash != null) { %>
        <div class="flash <%= flashOk ? "success" : "error" %>"><%= UI.Enc(flash) %></div>
      <% } %>
      <div class="card" style="padding:0">
        <table>
          <tr><th>#</th><th>Ảnh</th><th>Tên sản phẩm</th><th>Danh mục</th><th>SKU</th>
              <th>Giá bán</th><th>Tồn kho</th><th>Nổi bật</th><th>Trạng thái</th></tr>
          <% foreach (var p in Store.Products()) { %>
            <tr>
              <td><%= p.Id %></td>
              <td><img src="<%= UI.Enc(p.ImageUrl) %>" width="44" height="44"
                       style="border-radius:6px;object-fit:cover;border:1px solid #eee"
                       onerror="this.src='/img/no-image.png'" /></td>
              <td><strong><%= UI.Enc(p.Name) %></strong></td>
              <td><%= UI.Enc(p.CategoryName) %></td>
              <td class="muted" style="font-family:monospace"><%= UI.Enc(p.Sku) %></td>
              <td>
                <% if (p.SalePrice.HasValue) { %>
                  <span style="text-decoration:line-through;color:#999"><%= p.Price.ToString("N0") %></span><br>
                  <strong style="color:var(--primary)"><%= p.SalePrice.Value.ToString("N0") %> ₫</strong>
                <% } else { %>
                  <strong><%= p.Price.ToString("N0") %> ₫</strong>
                <% } %>
              </td>
              <td><span style="font-weight:600;<%= p.Stock < 5 ? "color:var(--danger)" : "" %>"><%= p.Stock %></span></td>
              <td><%= p.Featured ? "⭐" : "–" %></td>
              <td>
                <span class="badge <%= p.Active ? "badge-active" : "badge-inactive" %>">
                  <%= p.Active ? "Đang bán" : "Tạm ngừng" %>
                </span>
              </td>
            </tr>
          <% } %>
        </table>
      </div>
    </div>
  </div>
</div>
</body></html>
