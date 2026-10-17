# Regenerate noise_templates.txt with 30 ASCII-only XSLT templates
# Each template references real ShopHunter report fields

$templates = @(

# 1 - Full summary table
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <table border="1" cellpadding="5" style="border-collapse:collapse;font-family:Arial,sans-serif;font-size:13px">
      <caption style="font-weight:bold">ShopHunter - Revenue Summary Report</caption>
      <tr style="background:#f0f0f0"><th>Metric</th><th>Value</th></tr>
      <tr><td>Total Orders</td><td><xsl:value-of select="summary/total_orders"/></td></tr>
      <tr><td>Total Revenue (VND)</td><td><xsl:value-of select="summary/total_revenue"/></td></tr>
      <tr><td>Active Products</td><td><xsl:value-of select="summary/active_products"/></td></tr>
      <tr><td>Delivered</td><td><xsl:value-of select="summary/delivered_orders"/></td></tr>
      <tr><td>Pending</td><td><xsl:value-of select="summary/pending_orders"/></td></tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@,

# 2 - Orders only, numbered list
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <div style="font-family:Arial;font-size:13px">
      <h3 style="margin-bottom:8px">Order Status Breakdown</h3>
      <ol>
        <li>Pending: <b><xsl:value-of select="summary/pending_orders"/></b></li>
        <li>Confirmed: <b><xsl:value-of select="summary/confirmed_orders"/></b></li>
        <li>Shipping: <b><xsl:value-of select="summary/shipping_orders"/></b></li>
        <li>Delivered: <b><xsl:value-of select="summary/delivered_orders"/></b></li>
        <li>Cancelled: <b><xsl:value-of select="summary/cancelled_orders"/></b></li>
      </ol>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 3 - CSV/text format
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/report">metric,value
total_orders,<xsl:value-of select="summary/total_orders"/>
total_revenue,<xsl:value-of select="summary/total_revenue"/>
active_products,<xsl:value-of select="summary/active_products"/>
delivered_orders,<xsl:value-of select="summary/delivered_orders"/>
pending_orders,<xsl:value-of select="summary/pending_orders"/>
cancelled_orders,<xsl:value-of select="summary/cancelled_orders"/>
  </xsl:template>
</xsl:stylesheet>
"@,

# 4 - Revenue card style
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <div style="font-family:Arial,sans-serif;max-width:400px;border:1px solid #ddd;border-radius:8px;padding:20px">
      <div style="font-size:12px;color:#888;text-transform:uppercase;letter-spacing:1px">Total Revenue</div>
      <div style="font-size:32px;font-weight:bold;color:#e44d26;margin:8px 0">
        <xsl:value-of select="summary/total_revenue"/> VND
      </div>
      <div style="font-size:13px;color:#555">
        From <xsl:value-of select="summary/total_orders"/> orders
        (<xsl:value-of select="summary/delivered_orders"/> delivered)
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 5 - Products focus
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <!-- ShopHunter product catalog report v1.2 -->
  <xsl:template match="/report">
    <table cellpadding="6" style="border-collapse:collapse;font-family:Tahoma,sans-serif;font-size:13px;width:100%">
      <tr style="background:#1a1a2e;color:#fff">
        <th colspan="2" style="padding:10px">Product Inventory Overview</th>
      </tr>
      <tr><td>Active Products</td><td style="font-weight:bold"><xsl:value-of select="summary/active_products"/></td></tr>
      <tr style="background:#f8f8f8"><td>Total Orders</td><td style="font-weight:bold"><xsl:value-of select="summary/total_orders"/></td></tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@,

# 6 - Delivery rate computation
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <div style="font-family:Arial;padding:16px">
      <h4>Fulfillment Report</h4>
      <p>Orders placed: <xsl:value-of select="summary/total_orders"/></p>
      <p>Successfully delivered: <xsl:value-of select="summary/delivered_orders"/></p>
      <p>Awaiting fulfillment: <xsl:value-of select="summary/pending_orders"/></p>
      <p>In transit: <xsl:value-of select="summary/shipping_orders"/></p>
      <p>Return/Cancel: <xsl:value-of select="summary/cancelled_orders"/></p>
      <hr/>
      <p style="color:#888;font-size:11px">Generated by ShopHunter Report Engine</p>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 7 - Minimal one-liner style
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/report">ShopHunter Report | Orders: <xsl:value-of select="summary/total_orders"/> | Revenue: <xsl:value-of select="summary/total_revenue"/> VND | Products: <xsl:value-of select="summary/active_products"/></xsl:template>
</xsl:stylesheet>
"@,

# 8 - XML output passthrough
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/report">
    <report_export version="1.0" source="ShopHunter">
      <total_orders><xsl:value-of select="summary/total_orders"/></total_orders>
      <total_revenue currency="VND"><xsl:value-of select="summary/total_revenue"/></total_revenue>
      <fulfillment>
        <delivered><xsl:value-of select="summary/delivered_orders"/></delivered>
        <pending><xsl:value-of select="summary/pending_orders"/></pending>
        <cancelled><xsl:value-of select="summary/cancelled_orders"/></cancelled>
      </fulfillment>
    </report_export>
  </xsl:template>
</xsl:stylesheet>
"@,

# 9 - KPI dashboard style
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <div style="display:flex;gap:12px;flex-wrap:wrap;font-family:Arial">
      <div style="border:1px solid #ddd;border-radius:6px;padding:14px;min-width:140px;text-align:center">
        <div style="font-size:11px;color:#999">TOTAL ORDERS</div>
        <div style="font-size:28px;font-weight:bold"><xsl:value-of select="summary/total_orders"/></div>
      </div>
      <div style="border:1px solid #ddd;border-radius:6px;padding:14px;min-width:140px;text-align:center">
        <div style="font-size:11px;color:#999">REVENUE (VND)</div>
        <div style="font-size:28px;font-weight:bold;color:#e44d26"><xsl:value-of select="summary/total_revenue"/></div>
      </div>
      <div style="border:1px solid #ddd;border-radius:6px;padding:14px;min-width:140px;text-align:center">
        <div style="font-size:11px;color:#999">ACTIVE PRODUCTS</div>
        <div style="font-size:28px;font-weight:bold;color:#10b981"><xsl:value-of select="summary/active_products"/></div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 10 - Finance export with borders
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <!-- Finance department export template - ShopHunter v2 -->
  <xsl:template match="/report">
    <table style="border-collapse:collapse;width:100%;font-family:Calibri,Arial;font-size:14px">
      <thead>
        <tr style="background:#1a1a2e;color:white">
          <th style="padding:10px 14px;text-align:left">Category</th>
          <th style="padding:10px 14px;text-align:right">Count</th>
        </tr>
      </thead>
      <tbody>
        <tr><td style="padding:8px 14px;border-bottom:1px solid #eee">Total Revenue (VND)</td><td style="padding:8px 14px;text-align:right;font-weight:bold;color:#e44d26"><xsl:value-of select="summary/total_revenue"/></td></tr>
        <tr style="background:#fafafa"><td style="padding:8px 14px;border-bottom:1px solid #eee">Orders Received</td><td style="padding:8px 14px;text-align:right"><xsl:value-of select="summary/total_orders"/></td></tr>
        <tr><td style="padding:8px 14px;border-bottom:1px solid #eee">Delivered</td><td style="padding:8px 14px;text-align:right;color:#10b981"><xsl:value-of select="summary/delivered_orders"/></td></tr>
        <tr style="background:#fafafa"><td style="padding:8px 14px;border-bottom:1px solid #eee">Pending</td><td style="padding:8px 14px;text-align:right;color:#f59e0b"><xsl:value-of select="summary/pending_orders"/></td></tr>
        <tr><td style="padding:8px 14px">Cancelled</td><td style="padding:8px 14px;text-align:right;color:#ef4444"><xsl:value-of select="summary/cancelled_orders"/></td></tr>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@,

# 11 - Simple paragraph
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <div style="font-family:Georgia,serif;line-height:1.7;max-width:560px;font-size:14px;color:#333">
      <p>As of the current reporting period, ShopHunter has recorded
      <b><xsl:value-of select="summary/total_orders"/></b> total orders with gross revenue of
      <b><xsl:value-of select="summary/total_revenue"/> VND</b>.</p>
      <p>Of these, <xsl:value-of select="summary/delivered_orders"/> have been delivered and
      <xsl:value-of select="summary/pending_orders"/> remain pending.
      <xsl:value-of select="summary/cancelled_orders"/> orders were cancelled.</p>
      <p>The catalogue currently lists <xsl:value-of select="summary/active_products"/> active products.</p>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 12 - Compact 2-col
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <dl style="font-family:Arial;font-size:13px;display:grid;grid-template-columns:200px 1fr;gap:4px 12px">
      <dt style="color:#888">Total Orders</dt><dd><xsl:value-of select="summary/total_orders"/></dd>
      <dt style="color:#888">Gross Revenue</dt><dd><xsl:value-of select="summary/total_revenue"/> VND</dd>
      <dt style="color:#888">Active Products</dt><dd><xsl:value-of select="summary/active_products"/></dd>
      <dt style="color:#888">Pending</dt><dd><xsl:value-of select="summary/pending_orders"/></dd>
      <dt style="color:#888">Delivered</dt><dd><xsl:value-of select="summary/delivered_orders"/></dd>
    </dl>
  </xsl:template>
</xsl:stylesheet>
"@,

# 13 - Shipping focus
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <div style="font-family:Arial;font-size:13px;padding:12px">
      <b>Shipping Status Summary</b><br/><br/>
      <table cellspacing="0" cellpadding="6" border="1" style="border-collapse:collapse">
        <tr style="background:#f5f5f5"><th>Status</th><th>Count</th></tr>
        <tr><td>In Transit</td><td><xsl:value-of select="summary/shipping_orders"/></td></tr>
        <tr><td>Delivered</td><td><xsl:value-of select="summary/delivered_orders"/></td></tr>
        <tr><td>Confirmed (not shipped)</td><td><xsl:value-of select="summary/confirmed_orders"/></td></tr>
        <tr><td>Pending Confirmation</td><td><xsl:value-of select="summary/pending_orders"/></td></tr>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 14 - JSON-like text output
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/report">{
  "source": "ShopHunter",
  "total_orders": <xsl:value-of select="summary/total_orders"/>,
  "total_revenue": <xsl:value-of select="summary/total_revenue"/>,
  "active_products": <xsl:value-of select="summary/active_products"/>,
  "delivered": <xsl:value-of select="summary/delivered_orders"/>,
  "pending": <xsl:value-of select="summary/pending_orders"/>,
  "cancelled": <xsl:value-of select="summary/cancelled_orders"/>
}</xsl:template>
</xsl:stylesheet>
"@,

# 15 - Two-section layout
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <div style="font-family:Arial,sans-serif;font-size:13px">
      <div style="margin-bottom:16px">
        <div style="font-weight:bold;border-bottom:2px solid #e44d26;padding-bottom:4px;margin-bottom:8px">Sales Performance</div>
        <p>Revenue: <b style="color:#e44d26"><xsl:value-of select="summary/total_revenue"/> VND</b></p>
        <p>Orders: <b><xsl:value-of select="summary/total_orders"/></b></p>
      </div>
      <div>
        <div style="font-weight:bold;border-bottom:2px solid #3b82f6;padding-bottom:4px;margin-bottom:8px">Order Pipeline</div>
        <p>Pending: <xsl:value-of select="summary/pending_orders"/></p>
        <p>Delivering: <xsl:value-of select="summary/shipping_orders"/></p>
        <p>Completed: <xsl:value-of select="summary/delivered_orders"/></p>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 16 - Minimal bordered
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <table style="border-collapse:collapse;font-family:monospace;font-size:12px">
      <tr><td style="padding:3px 10px;border:1px solid #ccc">orders_total</td><td style="padding:3px 10px;border:1px solid #ccc"><xsl:value-of select="summary/total_orders"/></td></tr>
      <tr><td style="padding:3px 10px;border:1px solid #ccc">revenue_vnd</td><td style="padding:3px 10px;border:1px solid #ccc"><xsl:value-of select="summary/total_revenue"/></td></tr>
      <tr><td style="padding:3px 10px;border:1px solid #ccc">products_active</td><td style="padding:3px 10px;border:1px solid #ccc"><xsl:value-of select="summary/active_products"/></td></tr>
      <tr><td style="padding:3px 10px;border:1px solid #ccc">orders_pending</td><td style="padding:3px 10px;border:1px solid #ccc"><xsl:value-of select="summary/pending_orders"/></td></tr>
      <tr><td style="padding:3px 10px;border:1px solid #ccc">orders_delivered</td><td style="padding:3px 10px;border:1px solid #ccc"><xsl:value-of select="summary/delivered_orders"/></td></tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@,

# 17 - Print-ready
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <!-- print-ready template for accounting dept -->
  <xsl:template match="/report">
    <div style="font-family:'Times New Roman',serif;font-size:13pt;max-width:700px;margin:0 auto;padding:20px">
      <h2 style="text-align:center;border-bottom:2px solid #000;padding-bottom:8px">REVENUE REPORT</h2>
      <p style="text-align:center;font-size:10pt;color:#666">ShopHunter Management System</p>
      <table style="width:100%;border-collapse:collapse;margin-top:20px">
        <tr><td style="padding:6px;border:1px solid #999"><b>Total Orders</b></td><td style="padding:6px;border:1px solid #999;text-align:right"><xsl:value-of select="summary/total_orders"/></td></tr>
        <tr><td style="padding:6px;border:1px solid #999"><b>Gross Revenue (VND)</b></td><td style="padding:6px;border:1px solid #999;text-align:right"><xsl:value-of select="summary/total_revenue"/></td></tr>
        <tr><td style="padding:6px;border:1px solid #999"><b>Items in Catalogue</b></td><td style="padding:6px;border:1px solid #999;text-align:right"><xsl:value-of select="summary/active_products"/></td></tr>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 18 - Inline stats
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <span style="font-family:Arial;font-size:13px;color:#333">
      Orders: <b><xsl:value-of select="summary/total_orders"/></b> &#x2022;
      Revenue: <b style="color:#e44d26"><xsl:value-of select="summary/total_revenue"/> VND</b> &#x2022;
      Pending: <b style="color:#f59e0b"><xsl:value-of select="summary/pending_orders"/></b> &#x2022;
      Delivered: <b style="color:#10b981"><xsl:value-of select="summary/delivered_orders"/></b>
    </span>
  </xsl:template>
</xsl:stylesheet>
"@,

# 19 - Striped table variant
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <table cellpadding="8" style="border-collapse:collapse;font-size:13px;font-family:Arial;min-width:320px">
      <tr style="background:#1a1a2e;color:#fff"><th colspan="2">ShopHunter - Weekly Export</th></tr>
      <tr style="background:#fff"><td>Total Orders</td><td style="text-align:right"><xsl:value-of select="summary/total_orders"/></td></tr>
      <tr style="background:#f8f8f8"><td>Total Revenue</td><td style="text-align:right;color:#e44d26"><xsl:value-of select="summary/total_revenue"/> VND</td></tr>
      <tr style="background:#fff"><td>Products Active</td><td style="text-align:right"><xsl:value-of select="summary/active_products"/></td></tr>
      <tr style="background:#f8f8f8"><td>Delivered</td><td style="text-align:right;color:#10b981"><xsl:value-of select="summary/delivered_orders"/></td></tr>
      <tr style="background:#fff"><td>Pending</td><td style="text-align:right;color:#f59e0b"><xsl:value-of select="summary/pending_orders"/></td></tr>
      <tr style="background:#f8f8f8"><td>Cancelled</td><td style="text-align:right;color:#ef4444"><xsl:value-of select="summary/cancelled_orders"/></td></tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@,

# 20 - Compact CSV variant
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/report">ShopHunter Export
Date,Metric,Value
-,total_orders,<xsl:value-of select="summary/total_orders"/>
-,total_revenue_vnd,<xsl:value-of select="summary/total_revenue"/>
-,active_products,<xsl:value-of select="summary/active_products"/>
-,orders_delivered,<xsl:value-of select="summary/delivered_orders"/>
-,orders_pending,<xsl:value-of select="summary/pending_orders"/>
-,orders_shipping,<xsl:value-of select="summary/shipping_orders"/>
-,orders_cancelled,<xsl:value-of select="summary/cancelled_orders"/>
  </xsl:template>
</xsl:stylesheet>
"@,

# 21 - Accounting summary
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <div style="padding:16px;font-family:Arial;font-size:13px;border:1px solid #e0e0e0;border-radius:4px;max-width:500px">
      <div style="font-size:16px;font-weight:bold;margin-bottom:12px;color:#1a1a2e">Accounting Summary</div>
      <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #eee">
        <span>Gross Revenue</span><span style="font-weight:bold;color:#e44d26"><xsl:value-of select="summary/total_revenue"/> VND</span>
      </div>
      <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #eee">
        <span>Total Transactions</span><span><xsl:value-of select="summary/total_orders"/></span>
      </div>
      <div style="display:flex;justify-content:space-between;padding:8px 0">
        <span>Active SKUs</span><span><xsl:value-of select="summary/active_products"/></span>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 22 - Pipeline view
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <div style="font-family:Arial;font-size:12px">
      <div style="background:#f0f9ff;padding:10px 16px;border-left:4px solid #3b82f6;margin-bottom:6px">
        <b>Pending</b>: <xsl:value-of select="summary/pending_orders"/> orders awaiting confirmation
      </div>
      <div style="background:#f0fdf4;padding:10px 16px;border-left:4px solid #10b981;margin-bottom:6px">
        <b>Confirmed</b>: <xsl:value-of select="summary/confirmed_orders"/> orders confirmed
      </div>
      <div style="background:#eff6ff;padding:10px 16px;border-left:4px solid #6366f1;margin-bottom:6px">
        <b>In Transit</b>: <xsl:value-of select="summary/shipping_orders"/> packages shipping
      </div>
      <div style="background:#ecfdf5;padding:10px 16px;border-left:4px solid #059669;margin-bottom:6px">
        <b>Delivered</b>: <xsl:value-of select="summary/delivered_orders"/> orders completed
      </div>
      <div style="background:#fef2f2;padding:10px 16px;border-left:4px solid #ef4444">
        <b>Cancelled</b>: <xsl:value-of select="summary/cancelled_orders"/> orders
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 23 - Executive one-pager
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <!-- Executive summary - monthly -->
  <xsl:template match="/report">
    <div style="font-family:'Segoe UI',Arial;padding:24px;max-width:600px">
      <div style="font-size:20px;font-weight:700;color:#1a1a2e;margin-bottom:4px">ShopHunter</div>
      <div style="font-size:12px;color:#888;margin-bottom:20px;text-transform:uppercase;letter-spacing:1px">Executive Summary</div>
      <div style="font-size:40px;font-weight:800;color:#e44d26"><xsl:value-of select="summary/total_revenue"/></div>
      <div style="font-size:12px;color:#888;margin-bottom:16px">Total Revenue (VND)</div>
      <div style="font-size:24px;font-weight:700;color:#333"><xsl:value-of select="summary/total_orders"/> orders</div>
      <div style="font-size:12px;color:#888"><xsl:value-of select="summary/delivered_orders"/> delivered, <xsl:value-of select="summary/pending_orders"/> pending</div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 24 - Tab-separated
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/report">SHOPHUNTER REPORT EXPORT
================================
total_orders	<xsl:value-of select="summary/total_orders"/>
total_revenue	<xsl:value-of select="summary/total_revenue"/>
active_products	<xsl:value-of select="summary/active_products"/>
delivered_orders	<xsl:value-of select="summary/delivered_orders"/>
pending_orders	<xsl:value-of select="summary/pending_orders"/>
shipping_orders	<xsl:value-of select="summary/shipping_orders"/>
cancelled_orders	<xsl:value-of select="summary/cancelled_orders"/>
================================
  </xsl:template>
</xsl:stylesheet>
"@,

# 25 - Product catalog report
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <table cellpadding="7" style="border-collapse:collapse;font-family:Arial;font-size:13px;border:1px solid #ddd">
      <tr style="background:#e44d26;color:#fff">
        <th style="padding:8px 14px" colspan="2">ShopHunter Catalog Status</th>
      </tr>
      <tr><td style="border:1px solid #eee;padding:7px 14px">Active Products</td>
          <td style="border:1px solid #eee;padding:7px 14px;font-weight:bold"><xsl:value-of select="summary/active_products"/></td></tr>
      <tr style="background:#fafafa">
          <td style="border:1px solid #eee;padding:7px 14px">Total Revenue Generated</td>
          <td style="border:1px solid #eee;padding:7px 14px;color:#e44d26;font-weight:bold"><xsl:value-of select="summary/total_revenue"/> VND</td></tr>
      <tr><td style="border:1px solid #eee;padding:7px 14px">Orders Linked</td>
          <td style="border:1px solid #eee;padding:7px 14px"><xsl:value-of select="summary/total_orders"/></td></tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@,

# 26 - Simple div list
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/report">
    <div style="font-family:Arial;font-size:13px;line-height:2">
      <div><span style="display:inline-block;width:180px;color:#666">Orders Total:</span><b><xsl:value-of select="summary/total_orders"/></b></div>
      <div><span style="display:inline-block;width:180px;color:#666">Revenue (VND):</span><b style="color:#e44d26"><xsl:value-of select="summary/total_revenue"/></b></div>
      <div><span style="display:inline-block;width:180px;color:#666">Active Products:</span><b><xsl:value-of select="summary/active_products"/></b></div>
      <div><span style="display:inline-block;width:180px;color:#666">Orders Delivered:</span><b style="color:#10b981"><xsl:value-of select="summary/delivered_orders"/></b></div>
      <div><span style="display:inline-block;width:180px;color:#666">Orders Pending:</span><b style="color:#f59e0b"><xsl:value-of select="summary/pending_orders"/></b></div>
      <div><span style="display:inline-block;width:180px;color:#666">Orders Cancelled:</span><b style="color:#ef4444"><xsl:value-of select="summary/cancelled_orders"/></b></div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 27 - API-style XML
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  <xsl:template match="/report">
    <response status="ok" system="ShopHunter" version="2.0">
      <metrics>
        <metric name="total_orders" type="integer"><xsl:value-of select="summary/total_orders"/></metric>
        <metric name="total_revenue" type="decimal" currency="VND"><xsl:value-of select="summary/total_revenue"/></metric>
        <metric name="active_products" type="integer"><xsl:value-of select="summary/active_products"/></metric>
      </metrics>
      <fulfillment>
        <metric name="delivered" type="integer"><xsl:value-of select="summary/delivered_orders"/></metric>
        <metric name="pending" type="integer"><xsl:value-of select="summary/pending_orders"/></metric>
        <metric name="shipping" type="integer"><xsl:value-of select="summary/shipping_orders"/></metric>
        <metric name="cancelled" type="integer"><xsl:value-of select="summary/cancelled_orders"/></metric>
      </fulfillment>
    </response>
  </xsl:template>
</xsl:stylesheet>
"@,

# 28 - Colorful progress-bar style
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/report">
    <div style="font-family:Arial;font-size:13px;max-width:480px">
      <div style="background:#1a1a2e;color:#fff;padding:10px 16px;border-radius:6px 6px 0 0;font-weight:bold">ShopHunter Order Dashboard</div>
      <div style="border:1px solid #e0e0e0;border-top:none;padding:14px 16px;border-radius:0 0 6px 6px">
        <div style="margin-bottom:10px">
          <div style="font-size:11px;color:#888;margin-bottom:2px">TOTAL REVENUE</div>
          <div style="font-size:22px;font-weight:bold;color:#e44d26"><xsl:value-of select="summary/total_revenue"/> VND</div>
        </div>
        <div style="display:flex;gap:20px">
          <div><div style="font-size:11px;color:#888">ORDERS</div><div style="font-size:18px;font-weight:bold"><xsl:value-of select="summary/total_orders"/></div></div>
          <div><div style="font-size:11px;color:#888">DELIVERED</div><div style="font-size:18px;font-weight:bold;color:#10b981"><xsl:value-of select="summary/delivered_orders"/></div></div>
          <div><div style="font-size:11px;color:#888">PENDING</div><div style="font-size:18px;font-weight:bold;color:#f59e0b"><xsl:value-of select="summary/pending_orders"/></div></div>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
"@,

# 29 - Minimal text summary
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/report">--- ShopHunter Report Export ---
Orders    : <xsl:value-of select="summary/total_orders"/>
Revenue   : <xsl:value-of select="summary/total_revenue"/> VND
Products  : <xsl:value-of select="summary/active_products"/>
Delivered : <xsl:value-of select="summary/delivered_orders"/>
Pending   : <xsl:value-of select="summary/pending_orders"/>
Cancelled : <xsl:value-of select="summary/cancelled_orders"/>
---------------------------------
  </xsl:template>
</xsl:stylesheet>
"@,

# 30 - Full audit table
@"
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <!-- audit export v3 - all fields -->
  <xsl:template match="/report">
    <table style="border-collapse:collapse;font-family:'Courier New',monospace;font-size:12px;width:100%">
      <tr style="background:#222;color:#0f0"><th style="padding:6px 10px;text-align:left">FIELD</th><th style="padding:6px 10px;text-align:left">VALUE</th></tr>
      <tr><td style="padding:5px 10px;border-bottom:1px solid #eee">SYS.ORDERS.TOTAL</td><td style="padding:5px 10px;border-bottom:1px solid #eee"><xsl:value-of select="summary/total_orders"/></td></tr>
      <tr style="background:#fafafa"><td style="padding:5px 10px;border-bottom:1px solid #eee">SYS.REVENUE.GROSS</td><td style="padding:5px 10px;border-bottom:1px solid #eee"><xsl:value-of select="summary/total_revenue"/></td></tr>
      <tr><td style="padding:5px 10px;border-bottom:1px solid #eee">SYS.PRODUCTS.ACTIVE</td><td style="padding:5px 10px;border-bottom:1px solid #eee"><xsl:value-of select="summary/active_products"/></td></tr>
      <tr style="background:#fafafa"><td style="padding:5px 10px;border-bottom:1px solid #eee">ORD.STATUS.PENDING</td><td style="padding:5px 10px;border-bottom:1px solid #eee"><xsl:value-of select="summary/pending_orders"/></td></tr>
      <tr><td style="padding:5px 10px;border-bottom:1px solid #eee">ORD.STATUS.SHIPPING</td><td style="padding:5px 10px;border-bottom:1px solid #eee"><xsl:value-of select="summary/shipping_orders"/></td></tr>
      <tr style="background:#fafafa"><td style="padding:5px 10px;border-bottom:1px solid #eee">ORD.STATUS.DELIVERED</td><td style="padding:5px 10px;border-bottom:1px solid #eee"><xsl:value-of select="summary/delivered_orders"/></td></tr>
      <tr><td style="padding:5px 10px">ORD.STATUS.CANCELLED</td><td style="padding:5px 10px"><xsl:value-of select="summary/cancelled_orders"/></td></tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
"@
)

$enc = [System.Text.Encoding]::UTF8
$lines = @()
$i = 1
foreach ($tpl in $templates) {
    $bytes  = $enc.GetBytes($tpl.Trim())
    $b64    = [Convert]::ToBase64String($bytes)
    $sha256 = (Get-FileHash -InputStream ([IO.MemoryStream]::new($bytes)) -Algorithm SHA256).Hash.ToLower()
    $lines += "# template_$i sha256=$sha256"
    $lines += $b64
    $lines += ""
    $i++
}

$outPath = Join-Path $PSScriptRoot "noise_templates.txt"
$lines | Set-Content -Encoding UTF8 -Path $outPath
Write-Host "Generated $($templates.Count) templates -> $outPath"
