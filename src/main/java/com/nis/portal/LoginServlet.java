package com.omnimavens.servlet;

import com.omnimavens.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid Operator Credentials.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Query matching your exact 'system_users' table schema
        String sql = "SELECT email FROM system_users WHERE email = ? AND password_hash = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email.trim());
            stmt.setString(2, password.trim());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userEmail", rs.getString("email"));
                    session.setMaxInactiveInterval(1800); // 30 minutes
                    
                    response.sendRedirect("dashboard.jsp");
                    return;
                }
            }
        } catch (Exception e) {
            System.err.println("[AUTH ERROR] " + e.getMessage());
        }

        request.setAttribute("errorMessage", "Access Denied: Invalid Operator or Security Key.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}