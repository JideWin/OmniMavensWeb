<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Fetch the current session (false prevents creating a new one if it doesn't exist)
    HttpSession currentSession = request.getSession(false);
    
    // 2. Invalidate it securely
    if (currentSession != null) {
        currentSession.invalidate();
    }
    
    // 3. Reroute back to the authorization portal
    response.sendRedirect("login.jsp");
%>