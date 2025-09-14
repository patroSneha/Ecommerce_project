<%-- 
    Document   : index
    Author     : patro
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>E-Commerce Home</title>
<style>
/* Import Google Font */
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');

/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}

/* Body with a new gradient background */
body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: #fff;
}

/* Glassmorphic Navbar */
.navbar {
    width: 90%;
    margin: 20px auto;
    padding: 15px 30px;
    display: flex;
    justify-content: center;
    gap: 25px;
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(12px);
    border-radius: 15px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.15);
    transition: all 0.3s ease;
}

.navbar a {
    color: #fff;
    text-decoration: none;
    font-weight: 600;
    padding: 8px 20px;
    border-radius: 12px;
    transition: all 0.3s ease;
}

.navbar a:hover {
    background: rgba(255,255,255,0.3);
    color: #000;
    transform: scale(1.05);
}

/* Welcome card in the center */
.welcome-card {
    margin-top: 60px;
    width: 90%;
    max-width: 700px;
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(15px);
    border-radius: 25px;
    padding: 50px 40px;
    text-align: center;
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
    transition: transform 0.5s ease, box-shadow 0.5s ease;
    animation: float 4s ease-in-out infinite;
}

.welcome-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 25px 60px rgba(0,0,0,0.2);
}

/* Floating animation */
@keyframes float {
    0% { transform: translateY(0); }
    50% { transform: translateY(-12px); }
    100% { transform: translateY(0); }
}

.welcome-card h1 {
    font-size: 3em;
    font-weight: 700;
    background: linear-gradient(90deg, #f9d423, #ff4e50);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 20px;
}

.welcome-card p {
    font-size: 1.2em;
    color: #f3f3f3;
    line-height: 1.6;
    margin-bottom: 30px;
}

/* Gradient Call-to-action Button */
.cta-btn {
    display: inline-block;
    padding: 15px 40px;
    border-radius: 50px;
    border: none;
    background: linear-gradient(45deg, #43cea2, #185a9d);
    color: #fff;
    font-weight: 700;
    font-size: 1.1em;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 10px 20px rgba(0,0,0,0.2);
    text-decoration: none;
}

.cta-btn:hover {
    transform: translateY(-5px) scale(1.05);
    box-shadow: 0 15px 30px rgba(0,0,0,0.3);
}

/* Responsive */
@media(max-width:768px) {
    .welcome-card {
        padding: 35px 20px;
    }
    .welcome-card h1 {
        font-size: 2.2em;
    }
    .welcome-card p {
        font-size: 1em;
    }
    .navbar {
        flex-wrap: wrap;
        gap: 15px;
    }
    .navbar a {
        padding: 6px 15px;
    }
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

    <div class="welcome-card">
        <h1>Welcome to Your TrendHive👋</h1>
        <p>Explore hand-picked products, add your favorites to the cart, and enjoy a seamless shopping journey!</p>
        <a class="cta-btn" href="products.jsp">Start Shopping</a>
    </div>
</body>
</html>
