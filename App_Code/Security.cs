using System;
using System.Security.Cryptography;
using System.Web;

namespace ShopHunter
{
    public static class Security
    {
        private const int Iter    = 120000;
        private const int SaltLen = 16;
        private const int KeyLen  = 32;

        public static string Hash(string password)
        {
            byte[] salt = new byte[SaltLen];
            using (var rng = RandomNumberGenerator.Create()) rng.GetBytes(salt);
            using (var kdf = new Rfc2898DeriveBytes(password, salt, Iter, HashAlgorithmName.SHA256))
            {
                byte[] key = kdf.GetBytes(KeyLen);
                return "pbkdf2_sha256$" + Iter + "$"
                     + Convert.ToBase64String(salt) + "$"
                     + Convert.ToBase64String(key);
            }
        }

        public static bool Verify(string password, string stored)
        {
            try
            {
                string[] parts = stored.Split('$');
                if (parts.Length != 4 || parts[0] != "pbkdf2_sha256") return false;
                int    iter     = int.Parse(parts[1]);
                byte[] salt     = Convert.FromBase64String(parts[2]);
                byte[] expected = Convert.FromBase64String(parts[3]);
                using (var kdf = new Rfc2898DeriveBytes(password, salt, iter, HashAlgorithmName.SHA256))
                {
                    byte[] actual = kdf.GetBytes(expected.Length);
                    return FixedEquals(actual, expected);
                }
            }
            catch { return false; }
        }

        private static bool FixedEquals(byte[] a, byte[] b)
        {
            if (a.Length != b.Length) return false;
            int diff = 0;
            for (int i = 0; i < a.Length; i++) diff |= a[i] ^ b[i];
            return diff == 0;
        }

        public static void SignIn(User u)
        {
            var s = HttpContext.Current.Session;
            s["uid"]   = u.Id;
            s["uname"] = u.Username;
            s["fname"] = u.FullName;
            s["role"]  = u.Role;
            if (s["csrf"] == null) s["csrf"] = Guid.NewGuid().ToString("N");
        }

        public static void SignOut()
        {
            HttpContext.Current.Session.Clear();
        }

        public static bool IsAuthenticated
        {
            get
            {
                return HttpContext.Current.Session != null
                    && HttpContext.Current.Session["uid"] != null;
            }
        }

        public static string CurrentUser
        {
            get
            {
                var s = HttpContext.Current.Session;
                return (s != null && s["uname"] != null) ? s["uname"].ToString() : "-";
            }
        }

        public static string CurrentFullName
        {
            get
            {
                var s = HttpContext.Current.Session;
                return (s != null && s["fname"] != null) ? s["fname"].ToString() : "-";
            }
        }

        public static string CurrentRole
        {
            get
            {
                var s = HttpContext.Current.Session;
                return (s != null && s["role"] != null) ? s["role"].ToString() : "-";
            }
        }

        private static int Rank(string role)
        {
            if (role == "admin")   return 3;
            if (role == "manager") return 2;
            if (role == "staff")   return 1;
            return 0;
        }

        public static bool Require(string minRole)
        {
            var ctx = HttpContext.Current;
            if (!IsAuthenticated)
            {
                ctx.Response.Redirect("~/admin/login.aspx?next=" +
                    ctx.Server.UrlEncode(ctx.Request.Url.PathAndQuery));
                return false;
            }
            if (Rank(CurrentRole) < Rank(minRole))
            {
                ctx.Response.StatusCode = 403;
                ctx.Response.Write("403 Forbidden");
                ctx.Response.End();
                return false;
            }
            return true;
        }

        public static string CsrfToken()
        {
            var s = HttpContext.Current.Session;
            if (s["csrf"] == null) s["csrf"] = Guid.NewGuid().ToString("N");
            return (string)s["csrf"];
        }

        public static bool CheckCsrf()
        {
            var req  = HttpContext.Current.Request;
            string sent = req.Form["csrf_token"];
            if (sent == null) sent = req.Headers["X-CSRF-Token"];
            if (sent == null) sent = "";
            string good = (string)(HttpContext.Current.Session["csrf"] ?? "");
            if (good.Length == 0 || sent.Length != good.Length) return false;
            return FixedEquals(
                System.Text.Encoding.UTF8.GetBytes(sent),
                System.Text.Encoding.UTF8.GetBytes(good));
        }
    }
}
