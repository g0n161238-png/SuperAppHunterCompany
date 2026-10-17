using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;

namespace ShopHunter
{
    public static class AppLog
    {
        private static string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["ShopDB"].ConnectionString; }
        }

        public static void Notice(string evt, string data) { Write("notice", evt, data); }
        public static void Notice(string evt)              { Write("notice", evt, null); }
        public static void Warn(string evt, string data)   { Write("warn",   evt, data); }
        public static void Warn(string evt)                { Write("warn",   evt, null); }
        public static void Error(string evt, string data)  { Write("error",  evt, data); }
        public static void Error(string evt)               { Write("error",  evt, null); }

        private static void Write(string level, string evt, string data)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    using (var cmd = new SqlCommand(
                        "INSERT INTO AppLogs(Level,Event,Data) VALUES(@l,@e,@d)", conn))
                    {
                        cmd.Parameters.AddWithValue("@l", level);
                        cmd.Parameters.AddWithValue("@e", evt);
                        cmd.Parameters.AddWithValue("@d", (object)data ?? DBNull.Value);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch { }
        }

        public static string F(params object[] pairs)
        {
            var sb = new StringBuilder();
            for (int i = 0; i + 1 < pairs.Length; i += 2)
            {
                if (sb.Length > 0) sb.Append(' ');
                sb.Append(pairs[i]).Append('=').Append(pairs[i + 1]);
            }
            return sb.ToString();
        }
    }
}
