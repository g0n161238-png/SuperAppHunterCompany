<%@ Page Language="C#" ContentType="text/html; charset=utf-8" ResponseEncoding="utf-8" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // Xu ly logout
        if (Request.QueryString["action"] == "logout")
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("admin.aspx");
            return;
        }

        // Xu ly login
        if (Request.HttpMethod == "POST")
        {
            string username = Request.Form["username"];
            string password = Request.Form["password"];
            
            // Dang nhap don gian (co the thay doi theo nhu cau)
            if (username == "admin" && password == "admin123")
            {
                Session["AdminLoggedIn"] = true;
                Session["Username"] = username;
                Response.Redirect("admin.aspx");
                return;
            }
            else
            {
                ViewState["LoginError"] = true;
            }
        }
    }
    
    private bool IsLoggedIn()
    {
        return Session["AdminLoggedIn"] != null && (bool)Session["AdminLoggedIn"];
    }
</script>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Panel</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            max-width: 800px;
            width: 100%;
            animation: slideIn 0.5s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-container {
            padding: 50px;
            text-align: center;
        }
        
        .login-container h2 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        .form-group label {
            display: block;
            color: #555;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .error-message {
            color: #e74c3c;
            margin-bottom: 15px;
            padding: 10px;
            background: #ffebee;
            border-radius: 5px;
        }
        
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .dashboard-header h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .dashboard-content {
            padding: 30px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .info-card h3 {
            color: #667eea;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .info-card p {
            color: #333;
            font-size: 18px;
            font-weight: 600;
        }
        
        .system-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .system-info h3 {
            color: #333;
            margin-bottom: 15px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn-secondary {
            padding: 12px 30px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s;
        }
        
        .btn-secondary:hover {
            background: #5568d3;
        }
        
        .btn-danger {
            padding: 12px 30px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }
        
        .btn-danger:hover {
            background: #c0392b;
        }
        
        .hint-text {
            margin-top: 20px;
            color: #666;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="container">
        <% if (!IsLoggedIn()) { %>
            <!-- Login Form -->
            <div class="login-container">
                <h2>&#128274; Admin Panel Login</h2>
                <% if (ViewState["LoginError"] != null && (bool)ViewState["LoginError"]) { %>
                    <div class="error-message">&#10060; Invalid username or password!</div>
                <% } %>
                <form method="post" action="admin.aspx">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" placeholder="Enter username" required />
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter password" required />
                    </div>
                    <button type="submit" class="btn">Login</button>
                </form>              
            </div>
        <% } else { %>
            <!-- Dashboard -->
            <div class="dashboard-header">
                <h2>&#127889; Admin Dashboard</h2>
                <p>Welcome back, <%= Session["Username"] %></p>
            </div>
            <div class="dashboard-content">
                <div class="info-grid">
                    <div class="info-card">
                        <h3>Server Name</h3>
                        <p><%= Environment.MachineName %></p>
                    </div>
                    <div class="info-card">
                        <h3>OS Version</h3>
                        <p><%= Environment.OSVersion.ToString() %></p>
                    </div>
                    <div class="info-card">
                        <h3>.NET Version</h3>
                        <p><%= Environment.Version.ToString() %></p>
                    </div>
                    <div class="info-card">
                        <h3>Server Time</h3>
                        <p><%= DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") %></p>
                    </div>
                    <div class="info-card">
                        <h3>Processor Count</h3>
                        <p><%= Environment.ProcessorCount %> cores</p>
                    </div>
                    <div class="info-card">
                        <h3>Server Uptime</h3>
                        <p><%= TimeSpan.FromMilliseconds(Environment.TickCount).ToString(@"dd\.hh\:mm\:ss") %></p>
                    </div>
                </div>
                
                <div class="system-info">
                    <h3>&#128202; Additional System Information</h3>
                    <div style="line-height: 1.8; color: #333;">
                        <strong>Machine Name:</strong> <%= Environment.MachineName %><br/>
                        <strong>Working Set Memory:</strong> <%= (Environment.WorkingSet / 1024 / 1024).ToString() %> MB<br/>
                        <strong>Current Directory:</strong> <%= Environment.CurrentDirectory %><br/>
                        <strong>ASP.NET Version:</strong> <%= Environment.Version.ToString() %><br/>
                        <strong>User Agent:</strong> <%= Request.UserAgent %><br/>
                        <strong>Client IP:</strong> <%= Request.UserHostAddress %>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <a href="system.aspx?exec=admin" class="btn-secondary">&#128421; Go to System Page</a>
                    <a href="admin.aspx?action=logout" class="btn-danger">&#128682; Logout</a>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>
