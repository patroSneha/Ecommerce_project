<%@ page import="java.util.*,java.sql.*,com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) { response.sendRedirect("login.jsp"); return; }

    Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()) { response.sendRedirect("cart.jsp"); return; }

    double grandTotal = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Checkout - Confirm Order</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* new gradient background */
    body {
        background: linear-gradient(135deg, #8e2de2, #4a00e0);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding-top: 40px;
        color: #fff;
    }

    .checkout-container {
        background: rgba(255,255,255,0.1);
        backdrop-filter: blur(15px);
        padding: 35px 30px;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        width: 90%;
        max-width: 1000px;
        animation: fadeIn 0.8s ease-in-out;
    }

    .checkout-container h2 {
        text-align: center;
        background: linear-gradient(90deg,#f9d423,#ff4e50);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-size: 2em;
        font-weight: 700;
        margin-bottom: 25px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 25px;
    }

    th, td {
        padding: 12px;
        text-align: center;
        color: #fff;
    }

    th {
        background: rgba(255,255,255,0.15);
        font-weight: 700;
    }

    tr:nth-child(even) {
        background: rgba(255,255,255,0.05);
    }

    label {
        font-weight: 600;
        display: block;
        margin-top: 15px;
        margin-bottom: 5px;
        color: #eee;
    }

    textarea, select {
        width: 70%;
        padding: 10px;
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 10px;
        font-size: 1em;
        margin-top: 5px;
        background: rgba(255,255,255,0.1);
        color: #fff;
    }

    textarea:focus, select:focus {
        outline: none;
        border-color: #ff4e50;
        box-shadow: 0 0 6px rgba(255,78,80,0.4);
    }

    .btn {
        display: inline-block;
        padding: 14px 35px;
        margin-top: 20px;
        background: linear-gradient(45deg,#43cea2,#185a9d);
        color: white;
        text-decoration: none;
        border-radius: 50px;
        font-weight: bold;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
        font-size: 1.05em;
    }

    .btn:hover {
        transform: translateY(-2px) scale(1.03);
        box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    }

    form {
        text-align: center;
        margin-top: 20px;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media(max-width: 768px) {
        .checkout-container { width: 95%; padding: 20px; }
        textarea, select { width: 90%; }
    }
</style>
</head>
<body>
<div class="checkout-container">
    <h2>Confirm Your Order</h2>

    <table>
        <tr><th>Product</th><th>Quantity</th><th>Price (₹)</th><th>Total (₹)</th></tr>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                for(Map.Entry<Integer,Integer> entry : cart.entrySet()){
                    int pid = entry.getKey();
                    int qty = entry.getValue();

                    PreparedStatement ps = conn.prepareStatement("SELECT name, price FROM products WHERE id=?");
                    ps.setInt(1, pid);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()){
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        double total = price * qty;
                        grandTotal += total;
        %>
                        <tr>
                            <td><%=name%></td>
                            <td><%=qty%></td>
                            <td>₹<%=price%></td>
                            <td>₹<%=total%></td>
                        </tr>
        <%
                    }
                    rs.close(); ps.close();
                }
            } catch(Exception e){ out.println("<tr><td colspan='4'>Error: "+e.getMessage()+"</td></tr>"); }
        %>
        <tr style="font-weight:700;">
            <th colspan="3">Grand Total</th><th>₹<%=grandTotal%></th></tr>
    </table>

    <form action="placeOrder.jsp" method="post">
        <label>Shipping Address:</label>
        <textarea name="address" rows="3" required></textarea>

        <label>Payment Method:</label>
        <select name="payment" required>
            <option value="Cash on Delivery">Cash on Delivery</option>
            <option value="Online Payment">Online Payment</option>
        </select>

        <br>
        <button type="submit" class="btn">Confirm & Pay</button>
    </form>
</div>
</body>
</html>
