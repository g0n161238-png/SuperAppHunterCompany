<%@ Page Language="C#" %>
<%@ Import Namespace="ShopHunter" %>
<%@ Import Namespace="System.Linq" %>
<script runat="server">
    System.Collections.Generic.List<Product>  featured;
    System.Collections.Generic.List<Category> cats;

    void Page_Load(object sender, EventArgs e)
    {
        try
        {
            featured = Store.FeaturedProducts(6);
            cats     = Store.Categories();
        }
        catch
        {
            featured = new System.Collections.Generic.List<Product>();
            cats     = new System.Collections.Generic.List<Category>();
        }
    }

    string Fmt(decimal price) { return price.ToString("N0") + " ₫"; }
</script>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ShopHunter – Điện tử chính hãng, giá tốt nhất</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<style>
/* ---- Reset & base ---- */
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{font-family:'Inter',sans-serif;color:#1a1a2e;background:#fff;font-size:15px;line-height:1.6}
a{text-decoration:none;color:inherit}
img{max-width:100%;vertical-align:middle}

/* ---- CSS Tokens ---- */
:root{
  --primary:#e44d26;
  --primary-d:#c83b16;
  --accent:#f7941d;
  --dark:#1a1a2e;
  --text:#2d3748;
  --muted:#718096;
  --border:#e2e8f0;
  --bg-light:#f8fafc;
  --card-shadow:0 4px 20px rgba(0,0,0,.08);
  --radius:12px;
}

/* ---- Header ---- */
.header{background:#fff;border-bottom:1px solid var(--border);position:sticky;top:0;z-index:200;
        box-shadow:0 2px 8px rgba(0,0,0,.06)}
.header-inner{max-width:1280px;margin:0 auto;padding:0 24px;height:64px;
              display:flex;align-items:center;justify-content:space-between;gap:20px}
.logo{display:flex;align-items:center;gap:10px;font-size:22px;font-weight:800;color:var(--dark)}
.logo-icon{background:var(--primary);color:#fff;width:36px;height:36px;border-radius:8px;
           display:flex;align-items:center;justify-content:center;font-size:18px}
.logo-sub{font-size:11px;font-weight:400;color:var(--muted);letter-spacing:.3px;display:block;line-height:1}
.nav{display:flex;align-items:center;gap:6px}
.nav a{padding:8px 14px;border-radius:8px;font-size:14px;font-weight:500;color:var(--text);transition:background .15s}
.nav a:hover{background:var(--bg-light)}
.nav a.active{color:var(--primary);font-weight:600}
.header-actions{display:flex;align-items:center;gap:10px}
.btn-header{padding:9px 20px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;border:none;font-family:inherit}
.btn-cart{background:#f1f5f9;color:var(--text)}
.btn-admin{background:var(--primary);color:#fff}
.btn-cart:hover{background:#e2e8f0}
.btn-admin:hover{background:var(--primary-d)}

/* ---- Hero ---- */
.hero{background:linear-gradient(135deg,var(--dark) 0%,#16213e 50%,#0f3460 100%);
      color:#fff;padding:80px 24px}
.hero-inner{max-width:1280px;margin:0 auto;display:grid;grid-template-columns:1fr 1fr;
            gap:60px;align-items:center}
.hero-tag{display:inline-block;background:rgba(228,77,38,.25);color:#ff8b6e;
          padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;
          letter-spacing:.5px;text-transform:uppercase;margin-bottom:16px}
.hero h1{font-size:clamp(28px,4vw,52px);font-weight:800;line-height:1.15;margin-bottom:16px}
.hero h1 span{color:var(--accent)}
.hero p{font-size:16px;color:rgba(255,255,255,.75);margin-bottom:28px;max-width:480px}
.hero-btns{display:flex;gap:14px;flex-wrap:wrap}
.btn-hero-primary{padding:14px 28px;background:var(--primary);color:#fff;border-radius:10px;
                  font-size:15px;font-weight:700;display:inline-block;transition:background .15s}
.btn-hero-primary:hover{background:var(--primary-d)}
.btn-hero-outline{padding:14px 28px;border:2px solid rgba(255,255,255,.3);color:#fff;
                  border-radius:10px;font-size:15px;font-weight:600;display:inline-block;
                  transition:border-color .15s}
.btn-hero-outline:hover{border-color:rgba(255,255,255,.7)}
.hero-visual{display:flex;flex-direction:column;gap:14px}
.hero-badge{background:rgba(255,255,255,.1);backdrop-filter:blur(8px);border:1px solid rgba(255,255,255,.15);
            border-radius:12px;padding:16px 20px;display:flex;align-items:center;gap:14px}
.hero-badge-icon{font-size:28px}
.hero-badge-label{font-size:12px;color:rgba(255,255,255,.6)}
.hero-badge-val{font-size:18px;font-weight:700;margin-top:2px}

/* ---- Sections ---- */
.section{padding:64px 24px}
.section-inner{max-width:1280px;margin:0 auto}
.section-header{display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:32px}
.section-title{font-size:clamp(20px,2.5vw,28px);font-weight:800}
.section-title span{color:var(--primary)}
.section-sub{font-size:14px;color:var(--muted);margin-top:4px}
.section-link{font-size:14px;font-weight:600;color:var(--primary)}

/* ---- Category strip ---- */
.cats-strip{display:flex;gap:12px;overflow-x:auto;padding-bottom:4px;scrollbar-width:none}
.cats-strip::-webkit-scrollbar{display:none}
.cat-chip{flex-shrink:0;padding:9px 18px;background:#f1f5f9;border-radius:20px;
          font-size:13px;font-weight:600;color:var(--text);cursor:pointer;
          border:2px solid transparent;transition:all .15s;white-space:nowrap}
.cat-chip:hover,.cat-chip.active{background:#fff1ee;border-color:var(--primary);color:var(--primary)}

/* ---- Product grid ---- */
.product-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:20px}
.product-card{background:#fff;border-radius:var(--radius);border:1px solid var(--border);
              overflow:hidden;transition:box-shadow .2s,transform .2s;cursor:pointer}
.product-card:hover{box-shadow:var(--card-shadow);transform:translateY(-3px)}
.product-img{aspect-ratio:1;overflow:hidden;background:#f8fafc;position:relative}
.product-img img{width:100%;height:100%;object-fit:contain;padding:16px;transition:transform .3s}
.product-card:hover .product-img img{transform:scale(1.06)}
.badge-sale{position:absolute;top:10px;left:10px;background:var(--primary);color:#fff;
            padding:3px 8px;border-radius:6px;font-size:11px;font-weight:700}
.product-body{padding:14px 16px}
.product-cat{font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:.4px;margin-bottom:4px}
.product-name{font-size:14px;font-weight:600;line-height:1.4;display:-webkit-box;
              -webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:10px}
.product-price{display:flex;align-items:baseline;gap:8px}
.price-sale{font-size:17px;font-weight:700;color:var(--primary)}
.price-orig{font-size:12px;color:var(--muted);text-decoration:line-through}
.price-normal{font-size:17px;font-weight:700;color:var(--dark)}
.btn-add{width:100%;padding:9px;background:var(--dark);color:#fff;border:none;border-radius:0 0 var(--radius) var(--radius);
         font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;transition:background .15s}
.btn-add:hover{background:var(--primary)}

/* ---- Trust bar ---- */
.trust-bar{background:var(--bg-light);border-top:1px solid var(--border);border-bottom:1px solid var(--border);padding:32px 24px}
.trust-inner{max-width:1280px;margin:0 auto;display:grid;grid-template-columns:repeat(4,1fr);gap:24px}
.trust-item{display:flex;align-items:center;gap:14px}
.trust-icon{font-size:28px;flex-shrink:0}
.trust-label{font-size:13px;color:var(--muted)}
.trust-val{font-size:15px;font-weight:700}

/* ---- Footer ---- */
footer{background:var(--dark);color:rgba(255,255,255,.75);padding:48px 24px 24px}
.footer-inner{max-width:1280px;margin:0 auto}
.footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:40px;margin-bottom:40px}
.footer-brand .logo{color:#fff;margin-bottom:12px}
.footer-brand p{font-size:13px;line-height:1.7}
footer h4{font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:.5px;color:#fff;margin-bottom:14px}
footer ul{list-style:none}
footer ul li{margin-bottom:8px}
footer ul li a{font-size:13px;color:rgba(255,255,255,.6);transition:color .15s}
footer ul li a:hover{color:#fff}
.footer-bottom{border-top:1px solid rgba(255,255,255,.1);padding-top:20px;
               display:flex;justify-content:space-between;align-items:center;
               font-size:12px;color:rgba(255,255,255,.4);flex-wrap:wrap;gap:10px}

/* ---- Responsive ---- */
@media(max-width:768px){
  .hero-inner{grid-template-columns:1fr}
  .hero-visual{display:none}
  .nav{display:none}
  .trust-inner{grid-template-columns:1fr 1fr}
  .footer-grid{grid-template-columns:1fr 1fr}
}
@media(max-width:480px){
  .trust-inner{grid-template-columns:1fr}
  .footer-grid{grid-template-columns:1fr}
}
</style>
</head>
<body>

<!-- ============ HEADER ============ -->
<header class="header">
  <div class="header-inner">
    <a href="/" class="logo">
      <div class="logo-icon">🛒</div>
      <div>
        ShopHunter
        <span class="logo-sub">Điện tử chính hãng</span>
      </div>
    </a>
    <nav class="nav">
      <a href="/" class="active">Trang chủ</a>
      <a href="/index.aspx?cat=1">Điện thoại</a>
      <a href="/index.aspx?cat=2">Laptop</a>
      <a href="/index.aspx?cat=3">Âm thanh</a>
      <a href="/index.aspx?cat=4">Phụ kiện</a>
    </nav>
    <div class="header-actions">
      <button class="btn-header btn-cart">🛒 Giỏ hàng</button>
      <a href="/admin/login.aspx" class="btn-header btn-admin">Quản trị</a>
    </div>
  </div>
</header>

<!-- ============ HERO ============ -->
<section class="hero">
  <div class="hero-inner">
    <div>
      <div class="hero-tag">🔥 Flash Sale tháng 10 – Giảm đến 15%</div>
      <h1>Công nghệ <span>đỉnh cao</span>,<br>Giá không tưởng</h1>
      <p>Hơn 500 sản phẩm điện tử chính hãng – iPhone, MacBook, Samsung, Sony và nhiều hơn nữa. Giao hàng toàn quốc.</p>
      <div class="hero-btns">
        <a href="#san-pham" class="btn-hero-primary">Mua ngay →</a>
        <a href="#danh-muc" class="btn-hero-outline">Xem danh mục</a>
      </div>
    </div>
    <div class="hero-visual">
      <div class="hero-badge">
        <div class="hero-badge-icon">📱</div>
        <div>
          <div class="hero-badge-label">iPhone 15 Pro</div>
          <div class="hero-badge-val">27.990.000 ₫</div>
        </div>
      </div>
      <div class="hero-badge">
        <div class="hero-badge-icon">💻</div>
        <div>
          <div class="hero-badge-label">MacBook Pro M3</div>
          <div class="hero-badge-val">55.990.000 ₫</div>
        </div>
      </div>
      <div class="hero-badge">
        <div class="hero-badge-icon">🎧</div>
        <div>
          <div class="hero-badge-label">Sony WH-1000XM5</div>
          <div class="hero-badge-val">7.490.000 ₫</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ============ TRUST BAR ============ -->
<div class="trust-bar">
  <div class="trust-inner">
    <div class="trust-item">
      <div class="trust-icon">🚚</div>
      <div>
        <div class="trust-val">Miễn phí vận chuyển</div>
        <div class="trust-label">Đơn hàng từ 1.000.000 ₫</div>
      </div>
    </div>
    <div class="trust-item">
      <div class="trust-icon">✅</div>
      <div>
        <div class="trust-val">Hàng chính hãng 100%</div>
        <div class="trust-label">Có hoá đơn VAT đầy đủ</div>
      </div>
    </div>
    <div class="trust-item">
      <div class="trust-icon">🔄</div>
      <div>
        <div class="trust-val">Đổi trả 30 ngày</div>
        <div class="trust-label">Lỗi 1 đổi 1 trong 12 tháng</div>
      </div>
    </div>
    <div class="trust-item">
      <div class="trust-icon">💬</div>
      <div>
        <div class="trust-val">Hỗ trợ 24/7</div>
        <div class="trust-label">Hotline: 1800 xxxx</div>
      </div>
    </div>
  </div>
</div>

<!-- ============ CATEGORIES ============ -->
<section class="section" id="danh-muc" style="padding-bottom:20px">
  <div class="section-inner">
    <div class="section-header">
      <div>
        <div class="section-title">Danh mục <span>sản phẩm</span></div>
        <div class="section-sub">Tìm sản phẩm bạn cần nhanh hơn</div>
      </div>
    </div>
    <div class="cats-strip">
      <div class="cat-chip active">Tất cả</div>
      <% foreach (var c in cats) { %>
        <div class="cat-chip"><%= System.Web.HttpUtility.HtmlEncode(c.Name) %></div>
      <% } %>
    </div>
  </div>
</section>

<!-- ============ FEATURED PRODUCTS ============ -->
<section class="section" id="san-pham">
  <div class="section-inner">
    <div class="section-header">
      <div>
        <div class="section-title">Sản phẩm <span>nổi bật</span></div>
        <div class="section-sub">Được khách hàng tin chọn nhiều nhất</div>
      </div>
      <a href="#" class="section-link">Xem tất cả →</a>
    </div>
    <div class="product-grid">
      <% foreach (var p in featured) { %>
        <div class="product-card" onclick="location.href='/product.aspx?id=<%= p.Id %>'">
          <div class="product-img">
            <img src="<%= System.Web.HttpUtility.HtmlEncode(p.ImageUrl) %>"
                 alt="<%= System.Web.HttpUtility.HtmlEncode(p.Name) %>"
                 onerror="this.src='https://via.placeholder.com/300x300/f8fafc/ccc?text=No+Image'" />
            <% if (p.SalePrice.HasValue) { %>
              <span class="badge-sale">SALE</span>
            <% } %>
          </div>
          <div class="product-body">
            <div class="product-cat"><%= System.Web.HttpUtility.HtmlEncode(p.CategoryName) %></div>
            <div class="product-name"><%= System.Web.HttpUtility.HtmlEncode(p.Name) %></div>
            <div class="product-price">
              <% if (p.SalePrice.HasValue) { %>
                <span class="price-sale"><%= Fmt(p.SalePrice.Value) %></span>
                <span class="price-orig"><%= Fmt(p.Price) %></span>
              <% } else { %>
                <span class="price-normal"><%= Fmt(p.Price) %></span>
              <% } %>
            </div>
          </div>
          <button class="btn-add" onclick="event.stopPropagation()">🛒 Thêm vào giỏ</button>
        </div>
      <% } %>
      <% if (featured.Count == 0) { %>
        <p style="color:#999;grid-column:1/-1">Chưa có sản phẩm nào. <a href="/admin/login.aspx">Đăng nhập Admin</a> để thêm.</p>
      <% } %>
    </div>
  </div>
</section>

<!-- ============ FOOTER ============ -->
<footer>
  <div class="footer-inner">
    <div class="footer-grid">
      <div class="footer-brand">
        <div class="logo" style="margin-bottom:12px">
          <div class="logo-icon" style="background:var(--primary)">🛒</div>
          <div>ShopHunter</div>
        </div>
        <p>Hệ thống bán lẻ điện tử chính hãng tại Việt Nam. Uy tín – Chất lượng – Giá tốt.</p>
      </div>
      <div>
        <h4>Danh mục</h4>
        <ul>
          <li><a href="#">Điện thoại</a></li>
          <li><a href="#">Laptop</a></li>
          <li><a href="#">Âm thanh</a></li>
          <li><a href="#">Phụ kiện</a></li>
          <li><a href="#">Thiết bị mạng</a></li>
        </ul>
      </div>
      <div>
        <h4>Hỗ trợ</h4>
        <ul>
          <li><a href="#">Tra cứu đơn hàng</a></li>
          <li><a href="#">Chính sách đổi trả</a></li>
          <li><a href="#">Bảo hành</a></li>
          <li><a href="#">Thanh toán</a></li>
        </ul>
      </div>
      <div>
        <h4>Liên hệ</h4>
        <ul>
          <li><a href="#">📍 45 Lê Lợi, Hải Phòng</a></li>
          <li><a href="#">📞 1800 xxxx (miễn phí)</a></li>
          <li><a href="#">✉️ cskh@ShopHunter.vn</a></li>
          <li><a href="#">⏰ 8:00 – 22:00 mỗi ngày</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <span>© 2026 ShopHunter. Tất cả quyền bảo lưu.</span>
    </div>
  </div>
</footer>

</body>
</html>
