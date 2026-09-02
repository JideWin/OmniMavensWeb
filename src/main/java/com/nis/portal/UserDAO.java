package com.nis.portal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    
    // =====================================================================
    // PRODUCTION MYSQL CREDENTIALS
    // =====================================================================
    private static final String DB_URL = "jdbc:mysql://localhost:3306/omnimavens?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "omni_admin";
    private static final String DB_PASS = "OmniMavens@2026"; 
    // =====================================================================

    public static boolean authenticateUser(String email, String password) {
        boolean isValid = false;
        
        System.out.println("--- LOGIN ATTEMPT INITIATED ---");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement stmt = conn.prepareStatement("SELECT password_hash FROM system_users WHERE email = ?")) {
                
                stmt.setString(1, email);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("password_hash");
                        
                        if (storedPassword.equals(password)) {
                            System.out.println("[SUCCESS] Passwords match. User authenticated.");
                            isValid = true;
                        } else {
                            System.out.println("[FAILED] Password mismatch.");
                        }
                    } else {
                        System.out.println("[FAILED] USER NOT FOUND IN DATABASE!");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[DATABASE ERROR] Connection failed!");
            System.err.println("Details: " + e.getMessage());
            e.printStackTrace();
        }
        
        return isValid;
    }
}