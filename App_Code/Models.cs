using System.Collections.Generic;

namespace ShopHunter
{
    public class User
    {
        public int    Id           { get; set; }
        public string Username     { get; set; }
        public string FullName     { get; set; }
        public string PasswordHash { get; set; }
        public string Role         { get; set; }
        public bool   Active       { get; set; }
        public string LastLogin    { get; set; }
        public string CreatedAt    { get; set; }
    }

    public class Category
    {
        public int    Id          { get; set; }
        public string Name        { get; set; }
        public string Description { get; set; }
        public int    SortOrder   { get; set; }
    }

    public class Product
    {
        public int      Id           { get; set; }
        public string   Name         { get; set; }
        public string   Description  { get; set; }
        public decimal  Price        { get; set; }
        public decimal? SalePrice    { get; set; }
        public int      CategoryId   { get; set; }
        public string   CategoryName { get; set; }
        public int      Stock        { get; set; }
        public string   Sku          { get; set; }
        public string   ImageUrl     { get; set; }
        public bool     Active       { get; set; }
        public bool     Featured     { get; set; }
        public string   CreatedAt    { get; set; }

        public decimal EffectivePrice
        {
            get { return (SalePrice.HasValue && SalePrice.Value > 0) ? SalePrice.Value : Price; }
        }
    }

    public class Order
    {
        public int      Id            { get; set; }
        public string   OrderCode     { get; set; }
        public string   CustomerName  { get; set; }
        public string   Email         { get; set; }
        public string   Phone         { get; set; }
        public string   Address       { get; set; }
        public decimal  Subtotal      { get; set; }
        public decimal  ShippingFee   { get; set; }
        public decimal  Total         { get; set; }
        public string   Status        { get; set; }
        public string   PaymentMethod { get; set; }
        public string   Note          { get; set; }
        public string   CreatedAt     { get; set; }
        public List<OrderItem> Items  { get; set; }

        public Order() { Items = new List<OrderItem>(); }

        public string StatusLabel
        {
            get
            {
                if (Status == "pending")   return "Ch\u1edd x\u00e1c nh\u1eadn";
                if (Status == "confirmed") return "\u0110\u00e3 x\u00e1c nh\u1eadn";
                if (Status == "shipping")  return "\u0110ang giao";
                if (Status == "delivered") return "\u0110\u00e3 giao";
                if (Status == "cancelled") return "\u0110\u00e3 h\u1ee7y";
                return Status;
            }
        }
    }

    public class OrderItem
    {
        public int     Id          { get; set; }
        public int     OrderId     { get; set; }
        public int     ProductId   { get; set; }
        public string  ProductName { get; set; }
        public string  Sku         { get; set; }
        public int     Qty         { get; set; }
        public decimal UnitPrice   { get; set; }
        public decimal LineTotal   { get; set; }
    }
}
