<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        /* Purple gradient background from your image */
        background: linear-gradient(135deg, #6c63d3, #6f4dbd);
        margin: 0;
        padding: 30px;
        color: #333;
        min-height: 100vh;
    }

    h2 {
        text-align: center;
        color: #ffffff; /* white text on purple */
        margin-bottom: 40px;
        font-size: 2.4em;
        font-weight: 700;
        text-shadow: 0 2px 3px rgba(0,0,0,0.2);
    }

    .container {
        width: 95%;
        max-width: 1100px;
        margin: auto;
        padding: 10px;
        display: flex;
        flex-direction: column;
        gap: 30px;
    }

    .order-block {
        background: #ffffff;
        border-radius: 20px;
        padding: 25px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .order-block:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 30px rgba(0,0,0,0.15);
    }

    .order-block h3 {
        color: #ff6f61; /* Soft reddish heading */
        margin-bottom: 10px;
        font-size: 1.5em;
    }

    .order-block p {
        margin: 5px 0;
        font-size: 1em;
        color: #555;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    th, td {
        padding: 12px;
        text-align: center;
    }

    th {
        background: #6c63d3; /* header purple */
        color: white;
        font-weight: 600;
        font-size: 0.95em;
    }

    tr:nth-child(even) {
        background: #f1f9ff;
    }

    .item-row td {
        color: #444;
        font-size: 0.95em;
    }

    a {
        color: #6c63d3;
        text-decoration: none;
        font-weight: 600;
    }

    a:hover {
        text-decoration: underline;
        color: #ff6f61;
    }

    /* Responsive */
    @media(max-width: 768px) {
        .container { width: 98%; padding: 10px; }
        table, th, td { font-size: 14px; }
        .order-block { padding: 20px; }
    }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Orders</h2>

        <%
            String email = (String) session.getAttribute("userEmail");
            if (email == null) {
                out.println("<p style='color:white; text-align:center;'>⚠ Please <a href='login.jsp'>login</a> to view your orders.</p>");
            } else {
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT * FROM orders WHERE user_email=? ORDER BY order_date DESC";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, email);
                        try (ResultSet rs = ps.executeQuery()) {
                            boolean hasOrders = false;
                            while (rs.next()) {
                                hasOrders = true;
                                int orderId = rs.getInt("id");
                                String addr = rs.getString("address");
                                String payment = rs.getString("payment_method");
                                double total = rs.getDouble("total");
                                Timestamp date = rs.getTimestamp("order_date");
        %>
                                <div class="order-block">
                                    <h3>🛒 Order ID: <%= orderId %></h3>
                                    <p><b>Date:</b> <%= date %></p>
                                    <p><b>Address:</b> <%= addr %></p>
                                    <p><b>Payment:</b> <%= payment %></p>
                                    <p><b>Total:</b> ₹ <%= total %></p>

                                    <table>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price (₹)</th>
                                            <th>Quantity</th>
                                            <th>Subtotal (₹)</th>
                                        </tr>
                                        <%
                                            String itemSql = "SELECT oi.*, p.name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id=?";
                                            try (PreparedStatement ps2 = conn.prepareStatement(itemSql)) {
                                                ps2.setInt(1, orderId);
                                                try (ResultSet rs2 = ps2.executeQuery()) {
                                                    while (rs2.next()) {
                                                        String pname = rs2.getString("name");
                                                        double price = rs2.getDouble("price");
                                                        int qty = rs2.getInt("quantity");
                                                        double subtotal = price * qty;
                                        %>
                                                        <tr class="item-row">
                                                            <td><%= pname %></td>
                                                            <td><%= price %></td>
                                                            <td><%= qty %></td>
                                                            <td><%= subtotal %></td>
                                                        </tr>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </table>
                                </div>
        <%
                            }
                            if (!hasOrders) {
                                out.println("<p style='color:white; text-align:center;'>ℹ You have no orders yet. <a href='products.jsp'>Start Shopping</a></p>");
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<p style='color:white; text-align:center;'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
