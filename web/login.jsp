<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // If user already logged in, redirect to index.jsp
    if (session.getAttribute("userEmail") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - E-Commerce</title>
<style>
/* Google font */
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');

/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}

/* Background */
body {
    background: linear-gradient(135deg, #667eea, #764ba2);
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #333;
}

/* Login container */
.login-box {
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(15px);
    padding: 40px 30px;
    border-radius: 20px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.2);
    width: 350px;
    text-align: center;
    animation: fadeIn 1s ease-in-out;
}

/* Heading */
.login-box h2 {
    margin-bottom: 25px;
    font-size: 2em;
    font-weight: 700;
    background: linear-gradient(90deg, #f9d423, #ff4e50);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* Inputs */
input {
    width: 100%;
    padding: 12px 15px;
    margin: 10px 0;
    border: 1px solid rgba(255,255,255,0.4);
    background: rgba(255,255,255,0.2);
    border-radius: 10px;
    font-size: 1em;
    color: #fff;
    transition: all 0.3s ease;
}

input::placeholder {
    color: #f0f0f0;
}

input:focus {
    outline: none;
    border-color: #fff;
    box-shadow: 0 0 8px rgba(255,255,255,0.3);
}

/* Button */
button {
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    background: linear-gradient(45deg, #43cea2, #185a9d);
    color: white;
    font-weight: bold;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    font-size: 1em;
    transition: all 0.3s ease;
}

button:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 18px rgba(0,0,0,0.3);
}

/* Error message */
.error {
    color: #ffdddd;
    background: rgba(255,0,0,0.2);
    padding: 8px;
    margin-top: 15px;
    border-radius: 8px;
    font-weight: 500;
}

/* Register link */
.register-link {
    display: block;
    margin-top: 15px;
    font-size: 0.9em;
    color: #fff;
    text-decoration: none;
    transition: color 0.3s ease;
}

.register-link:hover {
    color: #f9d423;
    text-decoration: underline;
}

/* Animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

/* Responsive */
@media(max-width: 400px) {
    .login-box {
        width: 90%;
        padding: 30px 20px;
    }
}
</style>
</head>
<body>
    <div class="login-box">
        <h2>Login</h2>
        <form method="post" action="login.jsp">
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <a href="register.jsp" class="register-link">New user? Register here</a>

        <%
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    ps = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
                    ps.setString(1, email);
                    ps.setString(2, password); // plain text for simplicity
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        session.setAttribute("userEmail", email); // store session
                        response.sendRedirect("index.jsp");
                    } else {
                        out.println("<p class='error'>Invalid email or password!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ex) {}
                    try { if (ps != null) ps.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            }
        %>
    </div>
</body>
</html>
