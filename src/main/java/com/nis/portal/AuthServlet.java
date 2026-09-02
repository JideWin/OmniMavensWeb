package com.nis.portal;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AuthServlet", urlPatterns = {"/AuthServlet"})
public class AuthServlet extends HttpServlet {

    // 1. Handle direct browser URL access (GET requests)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Prevent users from accessing the servlet directly via URL by sending them to the login page
        response.sendRedirect("login.jsp");
    }

    // 2. Handle the login form submission (POST requests)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Verify credentials using your existing DAO
        boolean isAuthorized = UserDAO.authenticateUser(email, password);

        if (isAuthorized) {
            // Establish a secure session
            HttpSession session = request.getSession(true);
            session.setAttribute("userEmail", email);
            
            // Redirect the user to the DashboardServlet (which maps to "/dashboard")
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Send the user back to the login page and trigger the error banner
            request.setAttribute("errorMessage", "ACCESS DENIED: Invalid Operator Email or Security Access Key.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}