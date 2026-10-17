<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" %>
<%@ Import Namespace="ShopHunter" %>
<script runat="server">
    string errorMsg = null;

    void Page_Load(object sender, EventArgs e)
    {
        if (Security.IsAuthenticated)
        {
            Response.Redirect("~/admin/default.aspx");
            return;
        }

        if (Request.HttpMethod == "POST")
        {
            string username = (Request.Form["username"] ?? "").Trim();
            string password = Request.Form["password"] ?? "";
            var user = Store.FindUser(username);
            if (user != null && user.Active && Security.Verify(password, user.PasswordHash))
            {
                Security.SignIn(user);
                Store.UpdateLastLogin(user.Id);
                AppLog.Notice("login_ok", AppLog.F("user", username, "role", user.Role, "ip", Request.UserHostAddress));
                string next = Request.QueryString["next"];
                Response.Redirect(string.IsNullOrEmpty(next) ? "~/admin/default.aspx" : next);
            }
            else
            {
                AppLog.Warn("login_fail", AppLog.F("user", username, "ip", Request.UserHostAddress));
                errorMsg = "Tên đăng nhập hoặc mật khẩu không đúng.";
            }
        }
    }
</script>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Đăng nhập – ShopHunter Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',sans-serif;background:linear-gradient(135deg,#1a1a2e 0%,#16213e 50%,#0f3460 100%);
     min-height:100vh;display:flex;align-items:center;justify-content:center}
.login-wrap{width:100%;max-width:420px;padding:0 20px}
.login-card{background:#fff;border-radius:16px;padding:40px 36px;box-shadow:0 24px 60px rgba(0,0,0,.4)}
.login-logo{text-align:center;margin-bottom:28px}
.login-logo .icon{font-size:40px;display:block;margin-bottom:8px}
.login-logo h1{font-size:24px;font-weight:700;color:#1a1a2e}
.login-logo p{font-size:13px;color:#888;margin-top:4px}
.form-group{margin-bottom:18px}
.form-group label{display:block;font-size:13px;font-weight:600;color:#444;margin-bottom:6px}
.form-group input{width:100%;padding:11px 14px;border:1.5px solid #dde2ea;border-radius:8px;
                  font-size:14px;font-family:inherit;outline:none;transition:border-color .2s}
.form-group input:focus{border-color:#e44d26}
.btn-login{width:100%;padding:13px;background:linear-gradient(135deg,#e44d26,#f7941d);color:#fff;
           border:none;border-radius:8px;font-size:15px;font-weight:600;cursor:pointer;
           transition:opacity .2s;font-family:inherit}
.btn-login:hover{opacity:.9}
.error{background:#fff3f3;border:1px solid #f5c6c6;color:#c0392b;border-radius:8px;
       padding:10px 14px;font-size:13px;margin-bottom:16px}
.login-footer{text-align:center;margin-top:20px;font-size:12px;color:#aaa}
</style>
</head>
<body>
<div class="login-wrap">
  <div class="login-card">
    <div class="login-logo">
      <span class="icon">🛒</span>
      <h1>ShopHunter Admin</h1>
      <p>Hệ thống quản trị thương mại điện tử</p>
    </div>
    <% if (errorMsg != null) { %>
      <div class="error">⚠️ <%= Server.HtmlEncode(errorMsg) %></div>
    <% } %>
    <form method="post">
      <div class="form-group">
        <label>Tên đăng nhập</label>
        <input type="text" name="username" autocomplete="username" autofocus
               value="<%= Server.HtmlEncode(Request.Form["username"] ?? "") %>" />
      </div>
      <div class="form-group">
        <label>Mật khẩu</label>
        <input type="password" name="password" autocomplete="current-password" />
      </div>
      <button type="submit" class="btn-login">Đăng nhập</button>
    </form>
    <div class="login-footer">ShopHunter &copy; 2026</div>
  </div>
</div>
</body>
</html>
