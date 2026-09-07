package com.nis.portal;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AIServlet", urlPatterns = {"/AIServlet"})
public class AIServlet extends HttpServlet {

    // IMPORTANT: Paste your Groq API Key here!
 // GROQ API KEY
String GROQ_API_KEY = System.getenv("GROQ_API_KEY");

if (GROQ_API_KEY == null || GROQ_API_KEY.isBlank()) {
    throw new ServletException("GROQ_API_KEY is not configured");
}
    
    // Groq's OpenAI-compatible endpoint
    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        String userMessage = request.getParameter("message");
        
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("[ERROR] No input detected.");
            return;
        }

        try {
            String safeMessage = escapeJson(userMessage);
            
            // UPDATED: Using the active Llama 3.1 Instant model
            String jsonPayload = "{"
                    + "\"model\": \"openai/gpt-oss-20b","
                    + "\"messages\": ["
                    + "{\"role\": \"system\", \"content\": \"You are Omni-AI, a highly advanced, professional, and concise system concierge for a software agency named Omni Mavens. Keep your answers brief and formatting clean.\"},"
                    + "{\"role\": \"user\", \"content\": \"" + safeMessage + "\"}"
                    + "]"
                    + "}";

            URL url = new URL(GROQ_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Authorization", "Bearer " + GROQ_API_KEY);
            conn.setDoOutput(true);

            // Write the payload
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int statusCode = conn.getResponseCode();
            
            // Read response
            InputStream is = (statusCode >= 200 && statusCode < 300) ? conn.getInputStream() : conn.getErrorStream();
            Scanner scanner = new Scanner(is, StandardCharsets.UTF_8.name());
            String responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
            scanner.close();

            if (statusCode == 200) {
                String extractedText = extractTextFromJson(responseBody);
                response.getWriter().write(extractedText);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Groq API Error (Status " + statusCode + "): " + responseBody);
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[SYSTEM ERROR] Java Exception: " + e.toString());
        }
    }

    // Prevents JSON breaking if user types quotes
    private String escapeJson(String input) {
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", " ")
                    .replace("\r", " ");
    }

    // Extracts the AI's response from Groq's JSON structure
    private String extractTextFromJson(String json) {
        try {
            String target = "\"content\"";
            int targetIndex = json.lastIndexOf(target);
            if (targetIndex == -1) return "Transmission received, but no text found in response.";
            
            int colonIndex = json.indexOf(":", targetIndex);
            int startIndex = json.indexOf("\"", colonIndex) + 1;
            int endIndex = startIndex;
            
            while (endIndex < json.length()) {
                if (json.charAt(endIndex) == '"' && json.charAt(endIndex - 1) != '\\') {
                    break;
                }
                endIndex++;
            }
            
            String rawText = json.substring(startIndex, endIndex);
            return rawText.replace("\\n", "<br>").replace("\\\"", "\"").replace("\\\\", "\\");
        } catch (Exception e) {
            return "Transmission received, but formatting failed: " + e.toString();
        }
    }
}
