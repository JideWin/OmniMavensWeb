package com.nis.portal;

import java.io.IOException;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. SECURE THE NODE (Verify clearance level)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isAuthenticated") == null || !(boolean) session.getAttribute("isAuthenticated")) {
            // Unauthorized! Kick them back to login.
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. CONNECT TO DATA LAKE
        EntityManagerFactory emf = null;
        EntityManager em = null;
        
        try {
            emf = Persistence.createEntityManagerFactory("my_persistence_unit");
            em = emf.createEntityManager();
            
            // 3. PULL ALL TRANSMISSIONS (Newest First)
            TypedQuery<ClientLead> query = em.createQuery("SELECT c FROM ClientLead c ORDER BY c.transmissionDate DESC", ClientLead.class);
            List<ClientLead> leads = query.getResultList();
            
            // 4. ATTACH DATA TO THE REQUEST
            request.setAttribute("clientLeads", leads);
            
            // 5. ROUTE TO THE UI
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("SYSTEM ERROR: Cannot access Data Lake.");
        } finally {
            if (em != null) em.close();
            if (emf != null) emf.close();
        }
    }
}