<%@ Application Language="C#" %>
<%@ Import Namespace="ShopHunter" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
        try { SeedPasswords(); }
        catch { /* non-fatal - DB may not be ready yet */ }
    }

    static void SeedPasswords()
    {
        string connStr = ConfigurationManager.ConnectionStrings["ShopDB"].ConnectionString;

        string[] usernames  = new string[] { "admin",   "manager",   "staff"       };
        string[] passwords  = new string[] { "Admin@2026", "Manager@2026", "Staff@2026" };

        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            for (int i = 0; i < usernames.Length; i++)
            {
                string username = usernames[i];
                string password = passwords[i];

                using (var chk = new SqlCommand(
                    "SELECT PasswordHash FROM Users WHERE Username = @u", conn))
                {
                    chk.Parameters.AddWithValue("@u", username);
                    string current = chk.ExecuteScalar() as string;
                    if (current == null || !current.StartsWith("pbkdf2_sha256$"))
                    {
                        string hash = Security.Hash(password);
                        using (var upd = new SqlCommand(
                            "UPDATE Users SET PasswordHash = @h WHERE Username = @u", conn))
                        {
                            upd.Parameters.AddWithValue("@h", hash);
                            upd.Parameters.AddWithValue("@u", username);
                            upd.ExecuteNonQuery();
                        }
                    }
                }
            }
        }
    }

    void Application_BeginRequest(object sender, EventArgs e)
    {
        Response.ContentEncoding = new System.Text.UTF8Encoding(false);
        Response.Charset = "utf-8";
        if (Request.Path.ToLowerInvariant().EndsWith(".aspx"))
            Response.ContentType = "text/html; charset=utf-8";
    }

    void Application_Error(object sender, EventArgs e)
    {
        var ex = Server.GetLastError();
        if (ex != null)
            System.Diagnostics.Trace.TraceError("Unhandled: " + ex.ToString());
    }
</script>
