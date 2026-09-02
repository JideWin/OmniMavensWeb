package com.omnimavens.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Reads from environment variables if set, otherwise defaults to local configuration
    private static final String DB_URL = System.getenv("DB_URL") != null 
        ? System.getenv("DB_URL") 
        : "jdbc:mysql://localhost:3306/omnimavens?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        
    private static final String DB_USER = System.getenv("DB_USER") != null 
        ? System.getenv("DB_USER") 
        : "root";
        
    private static final String DB_PASS = System.getenv("DB_PASS") != null 
        ? System.getenv("DB_PASS") 
        : "";

    // Explicitly load the MySQL JDBC driver class once when the utility is loaded
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection Error] MySQL JDBC Driver not found in classpath!");
            e.printStackTrace();
        }
    }

    /**
     * Obtains a active connection to the MySQL database.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    /**
     * Standalone Test Method.
     * Right-click this file in NetBeans and select "Run File" (Shift + F6) to test connection.
     */
    public static void main(String[] args) {
        System.out.println("Testing Database Connection...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("SUCCESS: Connected to omnimavens MySQL Database successfully!");
            }
        } catch (SQLException e) {
            System.err.println("FAILURE: Unable to connect to Database.");
            e.printStackTrace();
        }
    }
}