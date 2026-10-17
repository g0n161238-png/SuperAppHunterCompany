-- ============================================================
-- ShopHunterDB  –  Database schema + seed data
-- Server  : 10.16.16.201
-- Database: ShopHunterDB
-- Run     : sqlcmd -S 10.16.16.201 -U sa -P <pwd> -i schema.sql
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ShopHunterDB')
    CREATE DATABASE ShopHunterDB
        COLLATE Vietnamese_CI_AS;
GO

USE ShopHunterDB;
GO

-- ----------------------------------------------------------
-- Tables
-- ----------------------------------------------------------

IF OBJECT_ID('OrderItems','U') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('Orders',    'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products',  'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Categories','U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Users',     'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('AppLogs',   'U') IS NOT NULL DROP TABLE AppLogs;
GO

CREATE TABLE Categories (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500) NULL,
    SortOrder   INT NOT NULL DEFAULT 0
);

CREATE TABLE Products (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(300)  NOT NULL,
    Description NVARCHAR(MAX)  NULL,
    Price       DECIMAL(18,2)  NOT NULL DEFAULT 0,
    SalePrice   DECIMAL(18,2)  NULL,
    CategoryId  INT            NOT NULL REFERENCES Categories(Id),
    Stock       INT            NOT NULL DEFAULT 0,
    Sku         NVARCHAR(100)  NULL,
    ImageUrl    NVARCHAR(500)  NULL DEFAULT '/img/no-image.png',
    Active      BIT            NOT NULL DEFAULT 1,
    Featured    BIT            NOT NULL DEFAULT 0,
    CreatedAt   DATETIME       NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Orders (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    OrderCode     NVARCHAR(50)   NOT NULL,
    CustomerName  NVARCHAR(200)  NOT NULL,
    Email         NVARCHAR(200)  NOT NULL,
    Phone         NVARCHAR(50)   NOT NULL,
    Address       NVARCHAR(500)  NOT NULL,
    Subtotal      DECIMAL(18,2)  NOT NULL DEFAULT 0,
    ShippingFee   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    Total         DECIMAL(18,2)  NOT NULL DEFAULT 0,
    Status        NVARCHAR(50)   NOT NULL DEFAULT 'pending',
    PaymentMethod NVARCHAR(100)  NOT NULL DEFAULT 'cod',
    Note          NVARCHAR(MAX)  NULL,
    CreatedAt     DATETIME       NOT NULL DEFAULT GETDATE()
);

CREATE TABLE OrderItems (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    OrderId     INT           NOT NULL REFERENCES Orders(Id) ON DELETE CASCADE,
    ProductId   INT           NOT NULL,
    ProductName NVARCHAR(300) NOT NULL,
    Sku         NVARCHAR(100) NULL,
    Qty         INT           NOT NULL,
    UnitPrice   DECIMAL(18,2) NOT NULL,
    LineTotal   DECIMAL(18,2) NOT NULL
);

CREATE TABLE Users (
    Id           INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(100) NOT NULL UNIQUE,
    FullName     NVARCHAR(200) NOT NULL,
    PasswordHash NVARCHAR(500) NOT NULL,
    Role         NVARCHAR(50)  NOT NULL DEFAULT 'staff',  -- admin | manager | staff
    Active       BIT           NOT NULL DEFAULT 1,
    LastLogin    DATETIME      NULL,
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE()
);

CREATE TABLE AppLogs (
    Id        BIGINT IDENTITY(1,1) PRIMARY KEY,
    Level     NVARCHAR(20)   NOT NULL,
    Event     NVARCHAR(200)  NOT NULL,
    Data      NVARCHAR(MAX)  NULL,
    CreatedAt DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- ----------------------------------------------------------
-- Indexes
-- ----------------------------------------------------------
CREATE INDEX IX_Products_CategoryId  ON Products(CategoryId);
CREATE INDEX IX_Products_Active      ON Products(Active, Featured);
CREATE INDEX IX_Orders_Status        ON Orders(Status, CreatedAt DESC);
CREATE INDEX IX_OrderItems_OrderId   ON OrderItems(OrderId);
CREATE INDEX IX_AppLogs_CreatedAt    ON AppLogs(CreatedAt DESC);
GO

-- ----------------------------------------------------------
-- Seed: Categories
-- ----------------------------------------------------------
SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (Id, Name, Description, SortOrder) VALUES
(1, N'Điện thoại & Máy tính bảng', N'Smartphone, tablet các thương hiệu', 1),
(2, N'Laptop & Máy tính',          N'Laptop văn phòng, gaming, workstation', 2),
(3, N'Thiết bị âm thanh',          N'Tai nghe, loa Bluetooth, micro', 3),
(4, N'Phụ kiện điện tử',           N'Sạc, cáp, bao da, ốp lưng', 4),
(5, N'Thiết bị mạng',              N'Router, switch, access point', 5);
SET IDENTITY_INSERT Categories OFF;
GO

-- ----------------------------------------------------------
-- Seed: Products
-- ----------------------------------------------------------
SET IDENTITY_INSERT Products ON;
INSERT INTO Products (Id, Name, Description, Price, SalePrice, CategoryId, Stock, Sku, Active, Featured) VALUES
(1,  N'iPhone 15 Pro 256GB',         N'Chip A17 Pro, camera 48MP, Dynamic Island', 29990000, 27990000, 1, 45, N'IP15P-256', 1, 1),
(2,  N'Samsung Galaxy S24 Ultra',    N'Snapdragon 8 Gen 3, S Pen, 200MP zoom',     32500000, 30000000, 1, 30, N'SGS24U',    1, 1),
(3,  N'Xiaomi 14 Ultra 512GB',       N'Leica camera, Snapdragon 8 Gen 3',          25990000, NULL,      1, 20, N'XMI14U',   1, 0),
(4,  N'Dell XPS 15 9530 i7-13700H',  N'OLED 3.5K, RTX 4060, 32GB RAM, 1TB SSD',  45000000, 42000000, 2, 12, N'XPS15-9530',1, 1),
(5,  N'MacBook Pro 14" M3 Pro',      N'Chip M3 Pro 11 nhân, 18GB RAM, 512GB',     55990000, NULL,      2, 8,  N'MBP14-M3P', 1, 1),
(6,  N'ASUS ROG Zephyrus G14 2024',  N'Ryzen 9 8945HS, RTX 4070, 165Hz QHD',     39900000, 37500000, 2, 15, N'ROGG14-24', 1, 0),
(7,  N'Sony WH-1000XM5',            N'Chống ồn ANC, 30h pin, Multipoint',          8490000, 7490000,  3, 60, N'WHX1000M5', 1, 1),
(8,  N'AirPods Pro 2nd Gen',         N'ANC H2, Lossless với AirPods 4',            6290000, NULL,      3, 80, N'APP2-USB',  1, 1),
(9,  N'JBL Charge 5',                N'30W, IP67, PartyBoost, pin 20h',            3290000, 2990000,  3, 100,N'JBLCHG5',  1, 0),
(10, N'Cáp USB-C 100W 2m Anker',     N'PowerLine III, sạc nhanh 100W',              290000, NULL,      4, 500,N'ANK-USBC', 1, 0),
(11, N'Ốp lưng iPhone 15 Pro MagSafe',N'Silicone cao cấp, hỗ trợ MagSafe',          490000, 390000,   4, 200,N'CASE-15P', 1, 0),
(12, N'TP-Link Archer AX73 WiFi 6',  N'AX5400, 6 anten, MU-MIMO, OFDMA',          2290000, 1990000,  5, 35, N'AX73',      1, 0);
SET IDENTITY_INSERT Products OFF;
GO

-- ----------------------------------------------------------
-- Seed: Orders
-- ----------------------------------------------------------
SET IDENTITY_INSERT Orders ON;
INSERT INTO Orders (Id, OrderCode, CustomerName, Email, Phone, Address, Subtotal, ShippingFee, Total, Status, PaymentMethod, CreatedAt) VALUES
(1,  N'DH2026-0001', N'Nguyễn Văn An',    N'an.nv@gmail.com',      N'0912345678', N'45 Lê Lợi, Q. Hồng Bàng, Hải Phòng',  29990000, 0,      29990000, N'delivered',  N'cod',     '2026-09-02 09:15:00'),
(2,  N'DH2026-0002', N'Trần Thị Bích',    N'bich.tt@outlook.com',   N'0987654321', N'12 Trần Phú, Q. Lê Chân, Hải Phòng',  55990000, 0,      55990000, N'delivered',  N'banking', '2026-09-05 14:30:00'),
(3,  N'DH2026-0003', N'Lê Minh Cường',    N'cuong.lm@yahoo.com',    N'0908123456', N'78 Điện Biên Phủ, Q. Ngô Quyền, HP',  8490000,  30000,  8520000,  N'shipping',   N'cod',     '2026-09-10 10:00:00'),
(4,  N'DH2026-0004', N'Phạm Thị Dung',    N'dung.pt@gmail.com',     N'0933221144', N'22 Tô Hiệu, Q. Lê Chân, Hải Phòng',   6290000,  30000,  6320000,  N'confirmed',  N'momo',    '2026-09-12 16:45:00'),
(5,  N'DH2026-0005', N'Hoàng Quốc Đạt',   N'dat.hq@gmail.com',      N'0977889900', N'5 Quang Trung, Q. Hồng Bàng, HP',    45000000, 0,      45000000, N'delivered',  N'banking', '2026-09-15 08:20:00'),
(6,  N'DH2026-0006', N'Vũ Thị Hương',     N'huong.vt@gmail.com',    N'0903456789', N'101 Lạch Tray, Q. Ngô Quyền, HP',     3290000,  30000,  3320000,  N'delivered',  N'cod',     '2026-09-18 11:30:00'),
(7,  N'DH2026-0007', N'Đỗ Mạnh Hùng',     N'hung.dm@gmail.com',     N'0912000001', N'33 Cát Dài, Q. Lê Chân, Hải Phòng',  32500000, 0,      32500000, N'pending',    N'cod',     '2026-10-01 09:00:00'),
(8,  N'DH2026-0008', N'Ngô Thị Lan',      N'lan.nt@gmail.com',      N'0922333444', N'67 Trần Hưng Đạo, Q. Hồng Bàng, HP',  780000,   30000,   810000,  N'pending',    N'cod',     '2026-10-02 14:00:00'),
(9,  N'DH2026-0009', N'Bùi Thanh Long',   N'long.bt@gmail.com',     N'0931555666', N'89 Lê Hồng Phong, Q. Ngô Quyền, HP', 25990000, 0,      25990000, N'confirmed',  N'banking', '2026-10-05 10:30:00'),
(10, N'DH2026-0010', N'Đinh Thị Mai',     N'mai.dt@gmail.com',      N'0944777888', N'14 Hai Bà Trưng, Q. Hồng Bàng, HP',  2290000,  30000,  2320000,  N'shipping',   N'momo',    '2026-10-08 15:45:00'),
(11, N'DH2026-0011', N'Lương Văn Nam',    N'nam.lv@gmail.com',      N'0955888999', N'55 Phan Bội Châu, Q. Lê Chân, HP',    7490000,  0,      7490000,  N'pending',    N'cod',     '2026-10-10 09:15:00'),
(12, N'DH2026-0012', N'Phan Thị Oanh',    N'oanh.pt@gmail.com',     N'0966999000', N'27 Nguyễn Đức Cảnh, Q. Lê Chân, HP', 39900000, 0,      39900000, N'cancelled',  N'banking', '2026-10-12 08:00:00');
SET IDENTITY_INSERT Orders OFF;
GO

INSERT INTO OrderItems (OrderId, ProductId, ProductName, Sku, Qty, UnitPrice, LineTotal) VALUES
(1,  1,  N'iPhone 15 Pro 256GB',          N'IP15P-256', 1, 29990000, 29990000),
(2,  5,  N'MacBook Pro 14" M3 Pro',       N'MBP14-M3P', 1, 55990000, 55990000),
(3,  7,  N'Sony WH-1000XM5',             N'WHX1000M5', 1, 8490000,  8490000),
(4,  8,  N'AirPods Pro 2nd Gen',          N'APP2-USB',  1, 6290000,  6290000),
(5,  4,  N'Dell XPS 15 9530 i7-13700H',  N'XPS15-9530',1, 45000000, 45000000),
(6,  9,  N'JBL Charge 5',                N'JBLCHG5',   1, 3290000,  3290000),
(7,  2,  N'Samsung Galaxy S24 Ultra',    N'SGS24U',    1, 32500000, 32500000),
(8,  10, N'Cáp USB-C 100W 2m Anker',     N'ANK-USBC',  2, 290000,    580000),
(8,  11, N'Ốp lưng iPhone 15 Pro MagSafe',N'CASE-15P', 1, 490000,    490000),  -- note: total in order is 810000 incl. ship
(9,  3,  N'Xiaomi 14 Ultra 512GB',        N'XMI14U',   1, 25990000, 25990000),
(10, 12, N'TP-Link Archer AX73 WiFi 6',  N'AX73',      1, 2290000,  2290000),
(11, 7,  N'Sony WH-1000XM5',             N'WHX1000M5', 1, 7490000,  7490000), -- sale price
(12, 6,  N'ASUS ROG Zephyrus G14 2024',  N'ROGG14-24', 1, 39900000, 39900000);
GO

-- ----------------------------------------------------------
-- Seed: Users  (passwords seeded by Global.asax via PBKDF2)
-- Placeholder hashes below – Global.asax will overwrite them
-- on first run with properly hashed values.
-- ----------------------------------------------------------
SET IDENTITY_INSERT Users ON;
INSERT INTO Users (Id, Username, FullName, PasswordHash, Role, Active) VALUES
(1, N'admin',   N'Quản trị viên',  N'PENDING_HASH', N'admin',   1),
(2, N'manager', N'Quản lý kho',    N'PENDING_HASH', N'manager', 1),
(3, N'staff',   N'Nhân viên bán hàng', N'PENDING_HASH', N'staff', 1);
SET IDENTITY_INSERT Users OFF;
GO

PRINT 'ShopHunterDB schema + seed created successfully.';
GO
