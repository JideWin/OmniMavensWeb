package com.nis.portal;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ContactServlet", urlPatterns = {"/ContactServlet"})
public class ContactServlet extends HttpServlet {

    // PRESERVED EMAIL CONFIGURATION
    private static final String TO_EMAIL = "omnimavenscompany@gmail.com";
    private static final String FROM_EMAIL = "omnimavenscompany@gmail.com";
    private static final String APP_PASSWORD = "wqdchvlgwwhmblpe";
    
    // =====================================================================
    // PRODUCTION MYSQL CREDENTIALS
    // =====================================================================
    private static final String DB_URL = "jdbc:mysql://localhost:3306/omnimavens?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "omni_admin";
    private static final String DB_PASS = "OmniMavens@2026";
    // =====================================================================

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        System.out.println("=========================================");
        System.out.println("INCOMING TRANSMISSION:");
        System.out.println("NAME: " + name);
        System.out.println("EMAIL: " + email);
        System.out.println("MESSAGE: " + message);

        // 1. Save to Database
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement stmt = conn.prepareStatement("INSERT INTO client_leads (client_name, corporate_email, project_parameters) VALUES (?, ?, ?)")) {
                
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, message);
                stmt.executeUpdate();
                System.out.println("[DB SUCCESS] Client Lead committed to Database.");
            }
        } catch (Exception e) {
            System.err.println("[SEVERE DB ERROR] " + e.getMessage());
            e.printStackTrace();
        }

        // 2. Respond immediately to Frontend
        response.setStatus(200);
        try (PrintWriter out = response.getWriter()) {
            out.write("success");
        }

        // 3. Send Email Notification in the background
        new Thread(() -> {
            try {
                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");

                Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                    }
                });

                Message mimeMessage = new MimeMessage(session);
                mimeMessage.setFrom(new InternetAddress(FROM_EMAIL));
                mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(TO_EMAIL));
                mimeMessage.setSubject("New Omni Mavens Protocol from: " + name);
                
                String emailContent = "SYSTEM ALERT: New Client Inquiry\n\n"
                        + "Client Name: " + name + "\n"
                        + "Corporate Email: " + email + "\n\n"
                        + "Project Parameters:\n" + message;
                        
                mimeMessage.setText(emailContent);
                Transport.send(mimeMessage);
                System.out.println("[EMAIL SUCCESS] Notification delivered.");
                
            } catch (Exception e) {
                System.err.println("[EMAIL ERROR] Failed to send: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }
}