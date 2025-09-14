<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - E-Commerce</title>
    <style>
        /* Reset */
        * { margin:0; padding:0; box-sizing:border-box; }

        /* Background */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* Purple-blue gradient background */
            background: linear-gradient(135deg, #6c63d3 0%, #6f4dbd 100%);
            padding: 20px;
            color: #fff;
            min-height: 100vh;
        }

        /* Navbar */
        .navbar {
            text-align: center;
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            border-radius: 15px;
            margin-bottom: 40px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }
        .navbar a {
            color: #fff;
            margin: 0 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: 0.3s;
        }
        .navbar a:hover {
            color: #ff6f61;
        }

        /* Title */
        h2 {
            text-align: center;
            color: #ffffff;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
            margin-bottom: 25px;
            font-size: 2.2em;
        }

        /* Products Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            width: 90%;
            max-width: 1100px;
            margin: auto;
        }

        /* Product Card */
        .product-card {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            padding: 20px;
            color: #fff;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 320px;
            transition: transform 0.3s ease;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(255, 111, 97, 0.6);
        }
        .product-card h3 {
            margin-bottom: 10px;
            font-size: 1.5em;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.3);
        }
        .product-card .desc {
            flex-grow: 1;
            font-size: 0.95em;
            margin-bottom: 15px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
        }
        .product-card .price {
            font-weight: 700;
            font-size: 1.2em;
            margin-bottom: 8px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
        }
        .product-card .stock {
            font-size: 0.9em;
            margin-bottom: 15px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }

        .add-cart-form {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .add-cart-form input[type="number"] {
            width: 60px;
            padding: 6px;
            border-radius: 8px;
            border: none;
            text-align: center;
            font-weight: 600;
        }
        .add-cart-form button.btn {
            padding: 8px 14px;
            background: #ff6f61;
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease;
        }
        .add-cart-form button.btn:hover {
            background: #6c63d3;
        }

        /* Responsive Navbar */
        @media(max-width:768px){
            .navbar a { margin: 0 10px; font-size: 14px; }
            h2 { font-size: 1.8em; }
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

    <h2>Available Products</h2>

    <div class="products-grid">
        <%
            try (Connection conn = DBConnection.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM products")) {

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String desc = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
        %>
        <div class="product-card">
            <h3><%= name %></h3>
            <p class="desc"><%= desc %></p>
            <p class="price">₹<%= price %></p>
            <p class="stock">In stock: <%= stock %></p>

            <form action="cart.jsp" method="get" class="add-cart-form">
                <input type="number" name="quantity" value="1" min="1" max="<%= stock %>" required>
                <input type="hidden" name="productId" value="<%= id %>">
                <button type="submit" class="btn">Add to Cart</button>
            </form>
        </div>
        <%
                }
            } catch (Exception e) {
        %>
        <p style="color:red; text-align:center;">Error: <%= e.getMessage() %></p>
        <%
            }
        %>
    </div>
</body>
</html>
