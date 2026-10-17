<%@ Page Language="C#" %>
<%@ Import Namespace="ShopHunter" %>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        Security.SignOut();
        Response.Redirect("~/admin/login.aspx");
    }
</script>
