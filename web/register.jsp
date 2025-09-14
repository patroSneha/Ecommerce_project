<%@ page import="java.sql.*, com.ecommerce.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
    <style>
    /* Reset */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* Background */
    body {
        background: linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #333;
    }

    /* Form container with glass effect */
    .form-container {
        background: rgba(255,255,255,0.9);
        padding: 40px 35px;
        border-radius: 20px;
        box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        width: 420px;
        backdrop-filter: blur(8px);
        animation: fadeIn 1s ease-in-out;
    }

    .form-container h2 {
        text-align: center;
        color: #0062ff;
        font-size: 2em;
        font-weight: 700;
        margin-bottom: 25px;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
    }

    label {
        display: block;
        margin-top: 15px;
        font-weight: 500;
        color: #444;
    }

    input, textarea, select {
        width: 100%;
        padding: 10px 12px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 10px;
        font-size: 0.95em;
        transition: all 0.3s ease;
    }

    input:focus, textarea:focus, select:focus {
        outline: none;
        border-color: #0062ff;
        box-shadow: 0 0 8px rgba(0,98,255,0.2);
    }

    button {
        margin-top: 25px;
        padding: 14px;
        width: 100%;
        border: none;
        background: #0062ff;
        color: white;
        font-weight: bold;
        font-size: 1em;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
        letter-spacing: .5px;
    }

    button:hover {
        background: #0044cc;
        transform: translateY(-2px);
        box-shadow: 0 8px 18px rgba(0,0,0,0.15);
    }

    .success, .error {
        text-align: center;
        margin-top: 15px;
        font-weight: 500;
    }

    .success { color: #2f9e44; } /* green */
    .error { color: #e03131; } /* red */

    a {
        color: #0062ff;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    a:hover {
        color: #0044cc;
        text-decoration: underline;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media(max-width: 420px) {
        .form-container {
            width: 90%;
            padding: 30px 20px;
        }
    }
</style>
</head>
<body>
    <div class="form-container">
        <h2>User Registration</h2>
        <form method="post" action="register.jsp">
            <label>Full Name:</label>
            <input type="text" name="fullname" required>

            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Password:</label>
            <input type="password" name="password" required>

            <label>Gender:</label>
            <select name="gender" required>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
            </select>

            <label>Date of Birth:</label>
            <input type="date" name="dob" required>

            <label>Phone:</label>
            <input type="text" name="phone" required>

            <label>Address:</label>
            <textarea name="address" rows="3"></textarea>

            <label>Role:</label>
            <select name="role" required>
                <option value="User" selected>User</option>
                <option value="Admin">Admin</option>
                <option value="Guest">Guest</option>
            </select>

            <button type="submit">Register</button>
        </form>

        <%
            // Process registration only if form is submitted
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String dob = request.getParameter("dob");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");

            if (fullname != null && email != null && password != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                try {
                    conn = DBConnection.getConnection();

                    // Check if email already exists
                    ps = conn.prepareStatement("SELECT * FROM users WHERE email=?");
                    ps.setString(1, email);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        out.println("<p class='error'>Email already exists! Try another.</p>");
                    } else {
                        // Insert new user
                        ps = conn.prepareStatement(
                            "INSERT INTO users(fullname,email,password,gender,dob,phone,address,role) VALUES (?,?,?,?,?,?,?,?)"
                        );
                        ps.setString(1, fullname);
                        ps.setString(2, email);
                        ps.setString(3, password); 
                        ps.setString(4, gender);
                        ps.setString(5, dob);
                        ps.setString(6, phone);
                        ps.setString(7, address);
                        ps.setString(8, role);

                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            out.println("<p class='success'>Registration successful! <a href='login.jsp'>Login here</a></p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try { if (ps != null) ps.close(); } catch (Exception ex) {}
                    try { if (conn != null) conn.close(); } catch (Exception ex) {}
                }
            }
        %>
    </div>
</body>
</html>
