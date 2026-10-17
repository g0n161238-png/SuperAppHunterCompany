using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ShopHunter
{
    public static class Store
    {
        private static string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["ShopDB"].ConnectionString; }
        }

        private static SqlConnection Open()
        {
            var c = new SqlConnection(ConnStr);
            c.Open();
            return c;
        }

        private static string Str(SqlDataReader r, string col)
        {
            object v = r[col];
            return (v == null || v == DBNull.Value) ? "" : v.ToString();
        }

        public static User FindUser(string username)
        {
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "SELECT * FROM Users WHERE Username = @u AND Active = 1", conn))
            {
                cmd.Parameters.AddWithValue("@u", username);
                using (var r = cmd.ExecuteReader())
                    return r.Read() ? MapUser(r) : null;
            }
        }

        public static void UpdateLastLogin(int userId)
        {
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "UPDATE Users SET LastLogin = GETDATE() WHERE Id = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", userId);
                cmd.ExecuteNonQuery();
            }
        }

        public static void UpsertUserHash(string username, string hash)
        {
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "UPDATE Users SET PasswordHash = @h WHERE Username = @u", conn))
            {
                cmd.Parameters.AddWithValue("@h", hash);
                cmd.Parameters.AddWithValue("@u", username);
                cmd.ExecuteNonQuery();
            }
        }

        private static User MapUser(SqlDataReader r)
        {
            object ll = r["LastLogin"];
            return new User
            {
                Id           = (int)r["Id"],
                Username     = Str(r, "Username"),
                FullName     = Str(r, "FullName"),
                PasswordHash = Str(r, "PasswordHash"),
                Role         = Str(r, "Role"),
                Active       = (bool)r["Active"],
                LastLogin    = (ll == DBNull.Value) ? null
                               : Convert.ToDateTime(ll).ToString("yyyy-MM-dd HH:mm"),
                CreatedAt    = Convert.ToDateTime(r["CreatedAt"]).ToString("yyyy-MM-dd HH:mm")
            };
        }

        public static List<Category> Categories()
        {
            var list = new List<Category>();
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "SELECT * FROM Categories ORDER BY SortOrder, Id", conn))
            using (var r = cmd.ExecuteReader())
            {
                while (r.Read())
                {
                    list.Add(new Category
                    {
                        Id          = (int)r["Id"],
                        Name        = Str(r, "Name"),
                        Description = Str(r, "Description"),
                        SortOrder   = (int)r["SortOrder"]
                    });
                }
            }
            return list;
        }

        public static List<Product> Products(bool activeOnly)
        {
            var list = new List<Product>();
            string sql = "SELECT p.*, c.Name AS CategoryName "
                       + "FROM Products p "
                       + "LEFT JOIN Categories c ON c.Id = p.CategoryId"
                       + (activeOnly ? " WHERE p.Active = 1" : "")
                       + " ORDER BY p.Id DESC";
            using (var conn = Open())
            using (var cmd = new SqlCommand(sql, conn))
            using (var r = cmd.ExecuteReader())
                while (r.Read()) list.Add(MapProduct(r));
            return list;
        }

        public static List<Product> Products()
        {
            return Products(false);
        }

        public static List<Product> FeaturedProducts(int top)
        {
            var list = new List<Product>();
            string sql = "SELECT TOP " + top + " p.*, c.Name AS CategoryName "
                       + "FROM Products p "
                       + "LEFT JOIN Categories c ON c.Id = p.CategoryId "
                       + "WHERE p.Active = 1 AND p.Featured = 1 "
                       + "ORDER BY p.Id DESC";
            using (var conn = Open())
            using (var cmd = new SqlCommand(sql, conn))
            using (var r = cmd.ExecuteReader())
                while (r.Read()) list.Add(MapProduct(r));
            return list;
        }

        public static Product FindProduct(int id)
        {
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "SELECT p.*, c.Name AS CategoryName "
              + "FROM Products p "
              + "LEFT JOIN Categories c ON c.Id = p.CategoryId "
              + "WHERE p.Id = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                using (var r = cmd.ExecuteReader())
                    return r.Read() ? MapProduct(r) : null;
            }
        }

        private static Product MapProduct(SqlDataReader r)
        {
            object sp = r["SalePrice"];
            return new Product
            {
                Id           = (int)r["Id"],
                Name         = Str(r, "Name"),
                Description  = Str(r, "Description"),
                Price        = (decimal)r["Price"],
                SalePrice    = (sp == DBNull.Value) ? (decimal?)null : (decimal)sp,
                CategoryId   = (int)r["CategoryId"],
                CategoryName = Str(r, "CategoryName"),
                Stock        = (int)r["Stock"],
                Sku          = Str(r, "Sku"),
                ImageUrl     = Str(r, "ImageUrl"),
                Active       = (bool)r["Active"],
                Featured     = (bool)r["Featured"],
                CreatedAt    = Convert.ToDateTime(r["CreatedAt"]).ToString("yyyy-MM-dd HH:mm")
            };
        }

        public static List<Order> Orders(int limit)
        {
            var list = new List<Order>();
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "SELECT TOP " + limit + " * FROM Orders ORDER BY Id DESC", conn))
            using (var r = cmd.ExecuteReader())
                while (r.Read()) list.Add(MapOrder(r));
            return list;
        }

        public static List<Order> Orders()
        {
            return Orders(200);
        }

        public static Order FindOrder(int id)
        {
            Order o = null;
            using (var conn = Open())
            {
                using (var cmd = new SqlCommand(
                    "SELECT * FROM Orders WHERE Id = @id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    using (var r = cmd.ExecuteReader())
                        if (r.Read()) o = MapOrder(r);
                }
                if (o != null)
                {
                    using (var cmd = new SqlCommand(
                        "SELECT * FROM OrderItems WHERE OrderId = @oid", conn))
                    {
                        cmd.Parameters.AddWithValue("@oid", id);
                        using (var r = cmd.ExecuteReader())
                            while (r.Read()) o.Items.Add(MapOrderItem(r));
                    }
                }
            }
            return o;
        }

        public static bool UpdateOrderStatus(int id, string status)
        {
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "UPDATE Orders SET Status = @s WHERE Id = @id", conn))
            {
                cmd.Parameters.AddWithValue("@s", status);
                cmd.Parameters.AddWithValue("@id", id);
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        private static Order MapOrder(SqlDataReader r)
        {
            return new Order
            {
                Id            = (int)r["Id"],
                OrderCode     = Str(r, "OrderCode"),
                CustomerName  = Str(r, "CustomerName"),
                Email         = Str(r, "Email"),
                Phone         = Str(r, "Phone"),
                Address       = Str(r, "Address"),
                Subtotal      = (decimal)r["Subtotal"],
                ShippingFee   = (decimal)r["ShippingFee"],
                Total         = (decimal)r["Total"],
                Status        = Str(r, "Status"),
                PaymentMethod = Str(r, "PaymentMethod"),
                Note          = Str(r, "Note"),
                CreatedAt     = Convert.ToDateTime(r["CreatedAt"]).ToString("yyyy-MM-dd HH:mm")
            };
        }

        private static OrderItem MapOrderItem(SqlDataReader r)
        {
            return new OrderItem
            {
                Id          = (int)r["Id"],
                OrderId     = (int)r["OrderId"],
                ProductId   = (int)r["ProductId"],
                ProductName = Str(r, "ProductName"),
                Sku         = Str(r, "Sku"),
                Qty         = (int)r["Qty"],
                UnitPrice   = (decimal)r["UnitPrice"],
                LineTotal   = (decimal)r["LineTotal"]
            };
        }

        public static void Stats(out int orders, out decimal revenue,
                                 out int products, out int pending)
        {
            orders = 0; revenue = 0m; products = 0; pending = 0;
            using (var conn = Open())
            using (var cmd = new SqlCommand(
                "SELECT COUNT(*) FROM Orders;" +
                "SELECT ISNULL(SUM(Total),0) FROM Orders WHERE Status NOT IN ('cancelled');" +
                "SELECT COUNT(*) FROM Products WHERE Active = 1;" +
                "SELECT COUNT(*) FROM Orders WHERE Status = 'pending';", conn))
            using (var r = cmd.ExecuteReader())
            {
                if (r.Read()) orders = r.GetInt32(0);
                r.NextResult();
                if (r.Read()) revenue = r.GetDecimal(0);
                r.NextResult();
                if (r.Read()) products = r.GetInt32(0);
                r.NextResult();
                if (r.Read()) pending = r.GetInt32(0);
            }
        }
    }
}
