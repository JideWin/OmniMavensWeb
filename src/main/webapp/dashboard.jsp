<%@page import="java.util.List"%>
<%@page import="com.nis.portal.ClientLead"%>
<%!
    public String escapeHTML(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#x27;");
    }
%>
<%
    String activeOperator = (String) session.getAttribute("userEmail");
    if (activeOperator == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hub Manager Terminal | Omni Mavens</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <script>
            let currentTheme = localStorage.getItem('omni_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', currentTheme);
        </script>
        <style>
            :root { --bg-color: #020617; --card-bg: #0f172a; --card-border: #1e293b; --top-nav-bg: #000000; --text-main: #f8fafc; --text-muted: #94a3b8; --table-header: #020617; --table-hover: #1e293b; --omni-blue: #3b82f6; --status-bg: rgba(22, 101, 52, 0.4); --status-text: #4ade80; --param-bg: #0f172a; }
            [data-theme="light"] { --bg-color: #e2e8f0; --card-bg: #ffffff; --card-border: #e2e8f0; --top-nav-bg: #0f172a; --text-main: #0f172a; --text-muted: #64748b; --table-header: #f8fafc; --table-hover: #f1f5f9; --omni-blue: #2563eb; --status-bg: #dcfce7; --status-text: #166534; --param-bg: #f8fafc; }
            body { background-color: var(--bg-color); color: var(--text-main); font-family: 'Segoe UI', system-ui, sans-serif; transition: background-color 0.3s, color 0.3s; }
            .top-nav { background-color: var(--top-nav-bg); color: white; padding: 1rem 2rem; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); transition: background-color 0.3s; }
            .dashboard-container { max-width: 1400px; margin: 2rem auto; padding: 0 2rem; }
            .data-card { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 8px; box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1); overflow: hidden; transition: background-color 0.3s, border-color 0.3s; }
            .card-header { background-color: var(--card-bg); padding: 1.5rem; border-bottom: 1px solid var(--card-border); display: flex; justify-content: space-between; align-items: center; transition: background-color 0.3s, border-color 0.3s; }
            .aws-table { width: 100%; border-collapse: collapse; }
            .aws-table th { background-color: var(--table-header); color: var(--text-muted); font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; padding: 1rem 1.5rem; border-bottom: 1px solid var(--card-border); text-align: left; transition: background-color 0.3s, border-color 0.3s; }
            .aws-table td { padding: 1rem 1.5rem; border-bottom: 1px solid var(--card-border); vertical-align: top; color: var(--text-main); transition: background-color 0.3s, border-color 0.3s; }
            .aws-table tr:hover td { background-color: var(--table-hover); }
            .param-box { background: var(--param-bg); border: 1px solid var(--card-border); border-radius: 6px; padding: 1rem; font-family: monospace; font-size: 0.85rem; color: var(--text-main); white-space: pre-wrap; transition: background-color 0.3s, border-color 0.3s; }
            .mono-text { font-family: monospace; }
            .status-badge { background: var(--status-bg); color: var(--status-text); padding: 0.25rem 0.75rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; }
            .text-adaptive { color: var(--text-main) !important; }
            .text-adaptive-muted { color: var(--text-muted) !important; }
            .theme-toggle-btn { background: transparent; border: 1px solid rgba(255,255,255,0.2); color: white; width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease; cursor: pointer; }
            .theme-toggle-btn:hover { background: rgba(255,255,255,0.1); }
        </style>
    </head>
    <body>
        <nav class="top-nav d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-3">
                <i class="bi bi-hdd-network fs-4" style="color: var(--omni-blue);"></i>
                <div>
                    <h5 class="mb-0 fw-bold tracking-tight text-white">OMNI MAVENS</h5>
                    <small class="mono-text" style="color: #94a3b8; font-size: 0.7rem;">HUB MANAGER TERMINAL v2.0</small>
                </div>
            </div>
            <div class="d-flex align-items-center gap-4">
                <button id="dashThemeToggle" class="theme-toggle-btn" title="Toggle Theme">
                    <i class="bi bi-sun-fill" id="dashThemeIcon"></i>
                </button>
                <div class="text-end hidden-mobile">
                    <div style="color: #94a3b8; font-size: 0.75rem; font-weight: 600; letter-spacing: 1px;">ACTIVE OPERATOR</div>
                    <div class="text-light mono-text"><%= escapeHTML(activeOperator) %></div>
                </div>
                <a href="logout.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-box-arrow-right me-2"></i>DISCONNECT</a>
            </div>
        </nav>

        <div class="dashboard-container">
            <div class="data-card">
                <div class="card-header">
                    <div>
                        <h4 class="mb-1 fw-bold text-adaptive">Incoming Protocols</h4>
                        <p class="text-adaptive-muted mb-0" style="font-size: 0.875rem;">System generated proposals and client inquiries from the Data Lake.</p>
                    </div>
                    <div>
                        <button onclick="window.location.reload();" class="btn btn-primary btn-sm" style="background-color: var(--omni-blue); border: none;"><i class="bi bi-arrow-clockwise me-2"></i>SYNC DATA LAKE</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="aws-table">
                        <thead>
                            <tr>
                                <th width="15%">TIMESTAMP</th>
                                <th width="20%">AUTHORIZED CLIENT</th>
                                <th width="20%">COMMUNICATION VECTOR</th>
                                <th width="45%">SYSTEM PARAMETERS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<ClientLead> leads = (List<ClientLead>) request.getAttribute("clientLeads");
                                if (leads != null && !leads.isEmpty()) {
                                    for (ClientLead lead : leads) {
                            %>
                            <tr>
                                <td>
                                    <div class="mono-text text-adaptive fw-medium" style="font-size: 0.75rem;"><%= lead.getTransmissionDate() %></div>
                                    <div class="status-badge mt-2 d-inline-block">CAPTURED</div>
                                </td>
                                <td class="text-adaptive fw-bold"><%= escapeHTML(lead.getName()) %></td>
                                <td>
                                    <a href="mailto:<%= escapeHTML(lead.getEmail()) %>" class="text-decoration-none" style="color: var(--omni-blue); font-weight: 600;">
                                        <i class="bi bi-envelope-at me-1"></i> <%= escapeHTML(lead.getEmail()) %>
                                    </a>
                                </td>
                                <td>
                                    <div class="param-box"><%= escapeHTML(lead.getMessage()).replace("\n", "<br>") %></div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center py-5">
                                    <i class="bi bi-inbox fs-1 text-adaptive-muted mb-3 d-block"></i>
                                    <span class="fw-bold text-adaptive-muted">No transmissions detected in Data Lake.</span>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <script>
            const dashThemeToggleBtn = document.getElementById('dashThemeToggle');
            const dashThemeIcon = document.getElementById('dashThemeIcon');
            function updateDashThemeIcon(theme) {
                if(theme === 'light') dashThemeIcon.className = 'bi bi-moon-stars-fill';
                else dashThemeIcon.className = 'bi bi-sun-fill';
            }
            if (dashThemeToggleBtn) {
                updateDashThemeIcon(document.documentElement.getAttribute('data-theme'));
                dashThemeToggleBtn.addEventListener('click', () => {
                    let current = document.documentElement.getAttribute('data-theme');
                    let targetTheme = current === 'light' ? 'dark' : 'light';
                    document.documentElement.setAttribute('data-theme', targetTheme);
                    localStorage.setItem('omni_theme', targetTheme);
                    updateDashThemeIcon(targetTheme);
                });
            }
        </script>
    </body>
</html>