<%@ Page Language="C#" %>
<%@ Import Namespace="ShopHunter" %>
<script runat="server">
    Product product;

    void Page_Load(object sender, EventArgs e)
    {
        int id;
        int.TryParse(Request.QueryString["id"], out id);
        if (id > 0) product = Store.FindProduct(id);
        if (product == null) Response.Redirect("~/");
    }

    string Fmt(decimal price) { return price.ToString("N0") + " ₫"; }
</script>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%= product != null ? System.Web.HttpUtility.HtmlEncode(product.Name) : "Sản phẩm" %> – ShopHunter</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;color:#1a1a2e;background:#f8fafc;font-size:15px}
a{text-decoration:none;color:inherit}
:root{--primary:#e44d26;--dark:#1a1a2e;--border:#e2e8f0}
.header{background:#fff;border-bottom:1px solid var(--border);padding:0 24px;height:64px;
        display:flex;align-items:center;justify-content:space-between}
.logo{font-size:20px;font-weight:800;display:flex;align-items:center;gap:10px}
.logo-icon{background:var(--primary);color:#fff;width:32px;height:32px;border-radius:7px;
           display:flex;align-items:center;justify-content:center;font-size:16px}
.back{font-size:13px;color:#666;display:flex;align-items:center;gap:6px}
.back:hover{color:var(--primary)}
.wrap{max-width:1100px;margin:32px auto;padding:0 24px}
.product-detail{display:grid;grid-template-columns:1fr 1fr;gap:40px;background:#fff;
                border-radius:14px;border:1px solid var(--border);padding:32px}
.img-box{border-radius:10px;overflow:hidden;background:#f8fafc;border:1px solid var(--border);
         aspect-ratio:1;display:flex;align-items:center;justify-content:center;padding:24px}
.img-box img{max-width:100%;max-height:100%;object-fit:contain}
.detail-body h1{font-size:22px;font-weight:800;line-height:1.3;margin-bottom:8px}
.detail-cat{font-size:12px;color:#888;text-transform:uppercase;letter-spacing:.4px;margin-bottom:12px}
.price-wrap{margin-bottom:18px}
.price-big{font-size:30px;font-weight:800;color:var(--primary)}
.price-old{font-size:14px;color:#aaa;text-decoration:line-through;margin-left:10px}
.detail-meta{display:flex;flex-direction:column;gap:8px;font-size:13px;color:#555;margin-bottom:22px}
.detail-meta span strong{color:#1a1a2e}
.btn-buy{display:block;width:100%;padding:14px;background:var(--primary);color:#fff;border:none;
         border-radius:10px;font-size:16px;font-weight:700;cursor:pointer;font-family:inherit;
         text-align:center;transition:background .15s;margin-bottom:12px}
.btn-buy:hover{background:#c83b16}
.btn-cart{display:block;width:100%;padding:13px;background:#f1f5f9;color:#1a1a2e;border:1.5px solid var(--border);
          border-radius:10px;font-size:15px;font-weight:600;cursor:pointer;font-family:inherit;
          text-align:center;transition:background .15s}
.btn-cart:hover{background:#e2e8f0}
.desc{background:#f8fafc;border-radius:10px;padding:20px;font-size:14px;line-height:1.8;color:#444;margin-top:24px}
@media(max-width:700px){.product-detail{grid-template-columns:1fr}}
</style>
</head>
<body>
<header class="header">
  <a href="/" class="logo">
    <div class="logo-icon">🛒</div>ShopHunter
  </a>
  <a href="/" class="back">← Về trang chủ</a>
</header>

<div class="wrap">
  <% if (product != null) { %>
  <div class="product-detail">
    <div class="img-box">
      <img src="<%= System.Web.HttpUtility.HtmlEncode(product.ImageUrl) %>"
           alt="<%= System.Web.HttpUtility.HtmlEncode(product.Name) %>"
           onerror="this.src='https://via.placeholder.com/400x400/f8fafc/ccc?text=No+Image'" />
    </div>
    <div class="detail-body">
      <div class="detail-cat"><%= System.Web.HttpUtility.HtmlEncode(product.CategoryName) %></div>
      <h1><%= System.Web.HttpUtility.HtmlEncode(product.Name) %></h1>
      <div class="price-wrap">
        <% if (product.SalePrice.HasValue) { %>
          <span class="price-big"><%= Fmt(product.SalePrice.Value) %></span>
          <span class="price-old"><%= Fmt(product.Price) %></span>
        <% } else { %>
          <span class="price-big"><%= Fmt(product.Price) %></span>
        <% } %>
      </div>
      <div class="detail-meta">
        <span>SKU: <strong><%= System.Web.HttpUtility.HtmlEncode(product.Sku) %></strong></span>
        <span>Tình trạng: <strong style="color:<%= product.Stock > 0 ? "#16a34a" : "#dc2626" %>">
          <%= product.Stock > 0 ? "Còn hàng (" + product.Stock + " cái)" : "Hết hàng" %></strong></span>
      </div>
      <button class="btn-buy">⚡ Mua ngay</button>
      <button class="btn-cart">🛒 Thêm vào giỏ hàng</button>
      <div class="desc">
        <%= System.Web.HttpUtility.HtmlEncode(product.Description) %>
      </div>
    </div>
  </div>
  <% } %>
</div>
</body>
</html>
