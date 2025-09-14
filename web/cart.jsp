<%@ page import="java.util.*, java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Ensure user is logged in
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve or create cart from session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if(cart == null) cart = new HashMap<>();

    // Add product to cart if coming from products.jsp
    String prodIdStr = request.getParameter("productId");
    String qtyStr = request.getParameter("quantity");
    if(prodIdStr != null && qtyStr != null) {
        int prodId = Integer.parseInt(prodIdStr);
        int qty = Integer.parseInt(qtyStr);
        cart.put(prodId, cart.getOrDefault(prodId, 0) + qty);
        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shopping Cart</title>
<style>
    /* Background + page layout */
    body { 
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea, #764ba2);
        margin: 0; 
        padding: 0; 
        color: #333;
        min-height: 100vh;
    }

    .container {
        width: 90%;
        max-width: 1100px;
        margin: 30px auto;
        background: #ffffff;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    h2 { 
        text-align: center; 
        color: #5a67d8; 
        margin-bottom: 20px; 
    }

    /* Navbar */
    .navbar {
        background: rgba(255,255,255,0.1);
        padding: 15px 0;
        text-align: center;
        backdrop-filter: blur(10px);
    }

    .navbar a {
        color: white;
        margin: 0 15px;
        text-decoration: none;
        font-weight: 600;
        font-size: 16px;
        transition: 0.3s;
    }

    .navbar a:hover {
        color: #ffebc7;
    }

    /* Table */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background: #fdfdfd;
        border-radius: 10px;
        overflow: hidden;
    }

    th, td {
        padding: 15px;
        text-align: center;
    }

    th {
        background: #5a67d8;
        color: white;
        font-weight: 600;
    }

    tr:nth-child(even) {
        background: #f8f9ff;
    }

    /* Buttons */
    .btn {
        padding: 8px 15px;
        background: #fc8181;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 600;
        transition: 0.3s;
        text-decoration: none;
    }

    .btn:hover {
        background: #f56565;
    }

    .checkout-btn {
        display: inline-block;
        margin-top: 25px;
        padding: 12px 30px;
        background: #48bb78;
        color: white;
        font-weight: 600;
        border-radius: 8px;
        text-decoration: none;
        transition: 0.3s;
    }

    .checkout-btn:hover {
        background: #38a169;
    }

    p {
        text-align: center;
        font-size: 1.1em;
        margin-top: 20px;
    }

    @media(max-width:768px){
        table { font-size: 14px; }
        .navbar a { margin: 0 10px; font-size: 14px; }
    }
</style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="myOrders.jsp">My Orders</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="container">
        <h2>Your Shopping Cart</h2>

        <%
            double grandTotal = 0.0;
            if(cart.isEmpty()) {
        %>
            <p>Your cart is empty. <a href="products.jsp">Shop now</a></p>
        <%
            } else {
        %>
        <table>
            <tr>
                <th>Product</th>
                <th>Price (₹)</th>
                <th>Quantity</th>
                <th>Total (₹)</th>
                <th>Action</th>
            </tr>
            <%
                try(Connection conn = DBConnection.getConnection()) {
                    for(Map.Entry<Integer,Integer> entry : cart.entrySet()) {
                        int pid = entry.getKey();
                        int qty = entry.getValue();

                        String sql = "SELECT name, price FROM products WHERE id=?";
                        try(PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, pid);
                            try(ResultSet rs = ps.executeQuery()) {
                                if(rs.next()) {
                                    String name = rs.getString("name");
                                    double price = rs.getDouble("price");
                                    double total = price * qty;
                                    grandTotal += total;
            %>
            <tr>
                <td><%=name%></td>
                <td>₹<%=price%></td>
                <td><%=qty%></td>
                <td>₹<%=total%></td>
                <td><a class="btn" href="cart.jsp?remove=<%=pid%>">Remove</a></td>
            </tr>
            <%
                                }
                            }
                        }
                    }

                    // Remove product if requested
                    String removeIdStr = request.getParameter("remove");
                    if(removeIdStr != null) {
                        int removeId = Integer.parseInt(removeIdStr);
                        cart.remove(removeId);
                        session.setAttribute("cart", cart);
                        response.sendRedirect("cart.jsp");
                        return;
                    }

                } catch(Exception e) {
                    out.println("<tr><td colspan='5' style='color:red;'>Error: "+e.getMessage()+"</td></tr>");
                }
            %>
            <tr>
                <th colspan="3">Grand Total</th>
                <th colspan="2">₹ <%=grandTotal%></th>
            </tr>
        </table>
        <div style="text-align:center;">
            <a class="checkout-btn" href="checkout.jsp">Proceed to Checkout</a>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>
