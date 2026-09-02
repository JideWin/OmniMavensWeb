<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="includes/header.jsp" />

<style>
    .auth-layout { min-height: 80vh; display: flex; align-items: center; justify-content: center; position: relative; z-index: 10; padding: 2rem 1rem; }
    @keyframes mirrorShine { 0% { left: -100%; } 100% { left: 200%; } }
    .auth-glass-card { background: var(--glass-bg); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid var(--glass-border); border-top: 3px solid var(--aws-blue); border-radius: 16px; padding: 3rem 2.5rem; width: 100%; max-width: 450px; box-shadow: var(--glass-shadow); position: relative; overflow: hidden; transition: all 0.4s ease; }
    .auth-glass-card::after { content: ''; position: absolute; top: 0; left: -100%; width: 50%; height: 100%; background: linear-gradient(to right, rgba(255,255,255,0) 0%, rgba(255,255,255,0.4) 50%, rgba(255,255,255,0) 100%); transform: skewX(-25deg); z-index: 10; pointer-events: none; }
    .auth-glass-card:hover { background: var(--card-hover); border-color: var(--aws-blue); box-shadow: 0 20px 50px rgba(6, 182, 212, 0.2), 0 0 30px rgba(41, 98, 255, 0.2); }
    .auth-glass-card:hover::after { animation: mirrorShine 0.8s ease forwards; }
    .auth-input { background: var(--card-bg) !important; border: 1px solid var(--glass-border) !important; color: var(--text-primary) !important; padding: 0.8rem 1.2rem; border-radius: 8px; font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; position: relative; z-index: 11; font-weight: 600; }
    .auth-input:focus { border-color: var(--aws-blue) !important; background: transparent !important; box-shadow: 0 0 0 3px rgba(41, 98, 255, 0.15) !important; }
    .auth-input::placeholder { color: var(--text-secondary); opacity: 0.6; }
    .auth-label { color: var(--text-secondary); font-weight: bold; font-size: 0.75rem; margin-bottom: 0.5rem; position: relative; z-index: 11; letter-spacing: 1px; }
    .login-logo { height: 50px; transition: all 0.3s ease; }
    .auth-glass-card:hover .login-logo { filter: drop-shadow(0 4px 10px rgba(41, 98, 255, 0.3)); transform: scale(1.05); }
</style>

<main class="flex-grow-1 auth-layout">
    <div class="auth-glass-card">
        <div class="text-center mb-4">
            <img src="assets/images/logo.png" alt="Omni Mavens Logo" class="login-logo mb-3">
            <h3 class="fw-bold text-adaptive mb-1" style="font-size: 1.5rem;">OPERATOR ACCESS</h3>
            <p class="mono-text text-adaptive-secondary small mb-0">AUTHENTICATION_REQUIRED</p>
        </div>

        <% 
            String errorMsg = (String) request.getAttribute("errorMessage");
            if (errorMsg != null) { 
        %>
            <div class="alert alert-danger mono-text small border-0 text-center py-2 mb-4" style="background: rgba(239, 68, 68, 0.2); color: #fca5a5; border-radius: 8px;">
                <i class="bi bi-shield-exclamation me-1"></i> <%= errorMsg %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/AuthServlet" method="POST" id="loginForm">
            <div class="mb-3">
                <label for="userEmail" class="auth-label mono-text">OPERATOR EMAIL</label>
                <input type="email" class="form-control auth-input" id="userEmail" name="email" required placeholder="email" autocomplete="email">
            </div>

            <div class="mb-4">
                <label for="userPassword" class="auth-label mono-text">SECURITY ACCESS KEY</label>
                <input type="password" class="form-control auth-input" id="userPassword" name="password" required placeholder="**********" autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-cyber w-100 py-3 mono-text fw-bold fs-7">
                AUTHENTICATE & ACCESS TERMINAL
            </button>
        </form>

        <div class="text-center mt-4 pt-2 border-top border-secondary border-opacity-25">
            <a href="index.jsp" class="text-adaptive-secondary text-decoration-none small mono-text">
                <i class="bi bi-arrow-left me-1"></i> RETURN TO PUBLIC NODE
            </a>
        </div>
    </div>
</main>

<jsp:include page="includes/footer.jsp" />