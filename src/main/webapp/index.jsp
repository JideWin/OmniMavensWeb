<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="includes/header.jsp" />

<style>
    /* =========================================
       ZERO-FLICKER SYSTEM LOADER
       ========================================= */
    #system-loader {
        position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
        background: #0f172a; z-index: 9999999; display: flex; flex-direction: column;
        align-items: center; justify-content: center;
        transition: opacity 0.8s cubic-bezier(0.165, 0.84, 0.44, 1), visibility 0.8s;
    }
    .loader-logo { width: 100px; animation: pulseGlow 1.2s infinite alternate ease-in-out; filter: brightness(2); }
    .loader-text { margin-top: 30px; font-family: 'JetBrains Mono', monospace; font-size: 0.75rem; color: #94a3b8; letter-spacing: 4px; }
    .loader-progress { width: 150px; height: 1px; background: rgba(255,255,255,0.1); margin-top: 15px; position: relative; overflow: hidden; }
    .loader-progress::after {
        content: ''; position: absolute; top: 0; left: 0; height: 100%; width: 0%;
        background: var(--aws-cyan); animation: loadBar 1.5s ease-in-out forwards; box-shadow: 0 0 10px var(--aws-cyan);
    }
    @keyframes pulseGlow {
        0% { filter: drop-shadow(0 0 5px rgba(142, 197, 252, 0.2)) brightness(2); transform: scale(0.98); opacity: 0.8; }
        100% { filter: drop-shadow(0 0 25px rgba(142, 197, 252, 0.8)) brightness(2); transform: scale(1.02); opacity: 1; }
    }
    @keyframes loadBar { 100% { width: 100%; } }
    body.is-loading { overflow: hidden; }

    /* =========================================
       FLOATING TERMINAL UI 
       ========================================= */
    .terminal-launcher {
        position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px;
        background: rgba(15, 23, 42, 0.95); backdrop-filter: blur(10px);
        border: 1px solid var(--aws-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center;
        color: var(--aws-cyan); font-size: 1.5rem; z-index: 9998; box-shadow: 0 10px 25px rgba(15, 23, 42, 0.3); transition: all 0.3s;
    }
    .terminal-launcher:hover { transform: scale(1.1); box-shadow: 0 15px 35px rgba(41, 98, 255, 0.4); cursor: none !important; }

    .cyber-terminal-window {
        position: fixed; bottom: 100px; right: 30px; width: 380px; height: 450px;
        background: rgba(15, 23, 42, 0.98); backdrop-filter: blur(20px); border: 1px solid rgba(41, 98, 255, 0.4);
        border-radius: 12px; z-index: 9998; display: flex; flex-direction: column; overflow: hidden;
        transform: translateY(20px) scale(0.95); opacity: 0; pointer-events: none; transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        font-family: 'JetBrains Mono', monospace; box-shadow: 0 20px 50px rgba(0,0,0,0.5);
    }
    .cyber-terminal-window.open { transform: translateY(0) scale(1); opacity: 1; pointer-events: auto; }

    .terminal-header { background: rgba(255,255,255,0.05); padding: 12px 15px; font-size: 0.75rem; color: #94a3b8; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.05); }
    .terminal-body { flex-grow: 1; padding: 15px; overflow-y: auto; color: #e0fcff; font-size: 0.8rem; line-height: 1.6; }
    .terminal-body::-webkit-scrollbar { width: 4px; }
    .terminal-body::-webkit-scrollbar-thumb { background: var(--aws-cyan); border-radius: 10px; }

    .terminal-input-line { display: flex; padding: 15px; border-top: 1px solid rgba(255,255,255,0.05); background: rgba(0,0,0,0.2); }
    .term-prompt { color: var(--aws-cyan); margin-right: 10px; font-size: 0.8rem; }
    #termInput { background: transparent; border: none; color: white; width: 100%; font-family: 'JetBrains Mono', monospace; font-size: 0.8rem; outline: none; cursor: none !important; }

    /* =========================================
       AMBIENT BACKGROUND
       ========================================= */
    .ambient-background { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; z-index: -1; background: transparent; overflow: hidden; }
    #cyberNetworkCanvas { position: absolute; top: 0; left: 0; width: 100vw; height: 100vh; z-index: 1; pointer-events: none; }

    /* =========================================
       INTERACTIVE IOS AI (APPLE INTELLIGENCE) GLOW
       ========================================= */
    .scale-hero-layout { display: flex; align-items: center; justify-content: space-between; min-height: 85vh; padding-top: 100px; position: relative; }
    .interactive-core { position: relative; width: 350px; height: 350px; display: flex; align-items: center; justify-content: center; margin-left: auto; cursor: pointer; }

    .stream-blob {
        position: absolute; width: 300px; height: 300px;
        background: linear-gradient(135deg, #ff2a5f, #ff9900, #00d4ff, #b975ff); background-size: 300% 300%;
        box-shadow: inset -20px -20px 40px rgba(0,0,0,0.15), inset 20px 20px 50px rgba(255,255,255,0.6), 0 20px 40px rgba(6, 182, 212, 0.3);
        animation: liquidMorph 6s ease-in-out infinite, gradientFlow 4s ease infinite; transition: all 0.6s cubic-bezier(0.165, 0.84, 0.44, 1); z-index: 5;
    }

    .core-logo-reveal {
        position: absolute; width: 180px; opacity: 0; transform: scale(0.5) translateY(30px);
        transition: all 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.27); z-index: 2; pointer-events: none;
    }

    .interactive-core:hover .stream-blob { transform: scale(1.4); opacity: 0; filter: blur(30px); visibility: hidden; }
    .interactive-core:hover .core-logo-reveal { opacity: 1; transform: scale(1) translateY(0); filter: drop-shadow(0 15px 35px rgba(41, 98, 255, 0.4)); z-index: 10; }

    @keyframes liquidMorph {
        0% { border-radius: 40% 60% 70% 30% / 40% 50% 60% 50%; }
        33% { border-radius: 70% 30% 50% 50% / 30% 30% 70% 70%; }
        66% { border-radius: 100% 60% 60% 100% / 100% 100% 60% 60%; }
        100% { border-radius: 40% 60% 70% 30% / 40% 50% 60% 50%; }
    }
    @keyframes gradientFlow { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

    @media (max-width: 991px) {
        .interactive-core { transform: scale(0.75); margin: 0 auto; margin-top: -30px; }
        .scale-hero-layout { padding-top: 60px; padding-bottom: 60px; }
    }

    /* =========================================
       TEXT & UI ELEMENTS
       ========================================= */
    .pulse-dot { display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--aws-blue); box-shadow: 0 0 8px var(--aws-blue); margin-right: 8px; animation: pulse 1.5s infinite alternate; }
    @keyframes pulse { from { opacity: 0.3; transform: scale(0.8); } to { opacity: 1; transform: scale(1.3); } }
    .hero-title { font-size: clamp(3rem, 7vw, 6.5rem); font-weight: 800; letter-spacing: -0.04em; line-height: 1.05; color: var(--text-primary); }
    .text-gradient { background: linear-gradient(135deg, var(--text-primary) 0%, var(--aws-blue) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
    .typing-cursor { display: inline-block; width: 3px; height: 1.2em; background-color: var(--aws-blue); vertical-align: middle; animation: blink 1s step-end infinite; }
    @keyframes blink { 50% { opacity: 0; } }

    .marquee-container { overflow: hidden; white-space: nowrap; padding: 2.5rem 0; background: var(--glass-bg); border-top: 1px solid var(--glass-border); border-bottom: 1px solid var(--glass-border); position: relative; backdrop-filter: blur(10px); }
    .marquee-content { display: inline-block; animation: marquee 35s linear infinite; }
    @keyframes marquee { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
    .client-badge { display: inline-block; padding: 0.6rem 2rem; margin: 0 1rem; font-family: 'JetBrains Mono', monospace; font-weight: 600; color: var(--text-secondary); border: 1px solid var(--glass-border); border-radius: 8px; background: var(--glass-bg); transition: all 0.3s ease; box-shadow: 0 4px 10px rgba(0,0,0,0.02); }
    .client-badge:hover { color: var(--text-primary); border-color: var(--aws-blue); box-shadow: 0 10px 20px rgba(41, 98, 255, 0.15); transform: translateY(-2px); }

    /* =========================================
       ENTERPRISE SOLUTIONS CARDS
       ========================================= */
    .solution-card { background: var(--card-bg); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid var(--glass-border); border-radius: 20px; padding: 2.5rem; transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); position: relative; overflow: hidden; height: 100%; box-shadow: var(--glass-shadow); }
    .solution-card:hover { transform: translateY(-8px); border-color: var(--aws-blue); background: var(--card-hover); box-shadow: 0 20px 40px rgba(6, 182, 212, 0.3), 0 0 20px rgba(168, 85, 247, 0.2); }
    .solution-card h4, .solution-card p, .solution-card li { color: var(--text-primary) !important; }
    .solution-icon { width: 50px; height: 50px; border-radius: 12px; background: rgba(41, 98, 255, 0.1); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: var(--aws-blue); margin-bottom: 1.5rem; border: 1px solid rgba(41, 98, 255, 0.2); }

    .tech-card { background: var(--card-bg); backdrop-filter: blur(10px); border: 1px solid var(--glass-border); border-radius: 16px; padding: 2rem 1.5rem; text-align: center; transition: all 0.3s ease; height: 100%; box-shadow: var(--glass-shadow); }
    .tech-card:hover { background: var(--card-hover); border-color: var(--aws-purple); transform: translateY(-5px); box-shadow: 0 15px 30px rgba(168, 85, 247, 0.3), 0 0 15px rgba(6, 182, 212, 0.2); }
    .tech-card h6, .tech-card p { color: var(--text-primary) !important; }
    .tech-icon { font-size: 2.5rem; color: var(--aws-blue); margin-bottom: 1rem; display: block; }

    .bento-glass { background: var(--card-bg); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid var(--glass-border); border-radius: 24px; padding: 2.5rem; transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1); box-shadow: var(--glass-shadow); height: 100%; position: relative; overflow: hidden; }
    .bento-glass:hover { transform: translateY(-8px); background: var(--card-hover); box-shadow: 0 30px 60px rgba(41, 98, 255, 0.3), 0 0 30px rgba(168, 85, 247, 0.2); }
    .bento-glass h4, .bento-glass p { color: var(--text-primary) !important; }

    .leader-profile-img { width: 190px; height: 190px; border-radius: 50%; object-fit: cover; border: 4px solid var(--glass-border); filter: grayscale(100%); transition: all 0.4s ease; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
    .bento-glass:hover .leader-profile-img { filter: grayscale(0%); border-color: var(--aws-blue); box-shadow: 0 15px 30px rgba(41, 98, 255, 0.3); transform: scale(1.05); }

    /* =========================================
       GLOBAL INFRASTRUCTURE GLOBE
       ========================================= */
    #global-network { position: relative; overflow: hidden; min-height: 60vh; background: var(--glass-bg); display: flex; align-items: center; border-top: 1px solid var(--glass-border); border-bottom: 1px solid var(--glass-border); }
    .globe-canvas { position: absolute; top: 0; right: -5%; width: 65%; height: 100%; z-index: 1; pointer-events: none; opacity: 0.9; }

    /* =========================================
       CYBER COOKIE BANNER & MODALS
       ========================================= */
    .cyber-cookie-banner { position: fixed; bottom: 30px; left: 30px; max-width: 420px; background: rgba(15, 23, 42, 0.95); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid rgba(255, 255, 255, 0.1); border-left: 3px solid var(--aws-blue); padding: 1.5rem; border-radius: 12px; z-index: 9999; box-shadow: 0 20px 40px rgba(0,0,0,0.3); transform: translateY(150%); transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1); }
    .cyber-cookie-banner.show { transform: translateY(0); }
    
    .glass-modal { background: rgba(15, 23, 42, 0.98) !important; backdrop-filter: blur(24px) !important; -webkit-backdrop-filter: blur(24px) !important; border: 1px solid rgba(255, 255, 255, 0.1) !important; border-top: 2px solid var(--aws-blue) !important; border-radius: 16px; color: #cbd5e1; }
    .glass-modal .modal-header { border-bottom: 1px solid rgba(255,255,255,0.05); padding: 1.5rem 2rem; }
    .glass-modal .modal-footer { border-top: 1px solid rgba(255,255,255,0.05); padding: 1.5rem 2rem; background: rgba(0,0,0,0.3); border-bottom-left-radius: 16px; border-bottom-right-radius: 16px; }
    .glass-modal .modal-body { padding: 2rem 2rem 4rem 2rem; overflow-y: auto; max-height: 60vh; }
    .glass-modal .btn-close { filter: invert(1) grayscale(100%) brightness(200%); cursor: none !important; }
    .legal-section-title { color: white; font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; margin-top: 2rem; margin-bottom: 0.8rem; letter-spacing: 1px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 0.5rem; }
    .legal-text { font-size: 0.85rem; line-height: 1.8; }
    .modal-body::-webkit-scrollbar { width: 6px; }
    .modal-body::-webkit-scrollbar-track { background: transparent; }
    .modal-body::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.15); border-radius: 10px; }

    .form-control.light-form { border: none; border-bottom: 1px solid var(--text-secondary); border-radius: 0; padding-left: 0; background-color: transparent !important; color: var(--text-primary) !important; }
    .form-control.light-form:focus { border-color: var(--aws-blue) !important; box-shadow: none !important; }
    .form-control.light-form::placeholder { color: var(--text-secondary) !important; opacity: 0.5; }
</style>

<script>document.body.classList.add('is-loading');</script>

<div id="system-loader">
    <img src="assets/images/logo.png" alt="Omni Mavens" class="loader-logo">
    <div class="loader-text">INITIALIZING PROTOCOL</div>
    <div class="loader-progress"></div>
</div>

<div class="ambient-background">
    <canvas id="cyberNetworkCanvas"></canvas>
</div>

<main class="flex-grow-1 position-relative" style="z-index: 10;">

    <section class="scale-hero-layout container">
        <div class="row align-items-center w-100">
            <!-- Updated classes: text-center for mobile/tablet, text-lg-start for large desktop screens -->
            <div class="col-lg-7 text-center text-lg-start position-relative" style="z-index: 5;">
                <div class="mono-text fw-bold mb-4 border border-secondary border-opacity-25 rounded-pill d-inline-flex align-items-center px-4 py-2" style="font-size: 0.75rem; background: var(--glass-bg); color: var(--text-primary); box-shadow: var(--glass-shadow);">
                    <span class="pulse-dot"></span> System Operational
                </div>
                <h1 class="hero-title mb-4">
                    Architecting.<br>
                    <span class="text-gradient">The Future.</span>
                </h1>
                <!-- Updated classes: justify-content-center for mobile/tablet, justify-content-lg-start for large desktop screens -->
                <div class="fs-4 text-adaptive-secondary mb-5 d-flex align-items-center justify-content-center justify-content-lg-start gap-2" style="height: 40px;">
                    <span>We build</span>
                    <span id="typewriterText" class="text-primary fw-bold" style="color: var(--aws-blue) !important;"></span><span class="typing-cursor"></span>
                </div>

                <div class="d-flex flex-wrap gap-4 justify-content-center justify-content-lg-start">
                    <a href="#contact" class="btn btn-cyber px-5 py-3 fs-6 d-inline-flex align-items-center justify-content-center">
                        <i class="bi bi-power fs-5 me-2"></i> Initialize Project
                    </a>
                    <button class="btn px-5 py-3 fs-6 d-inline-flex align-items-center justify-content-center fw-bold text-adaptive" style="background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 30px; transition: all 0.3s; box-shadow: var(--glass-shadow);" onmouseover="this.style.background = 'var(--aws-blue)'; this.style.color = 'white';" onmouseout="this.style.background = 'var(--glass-bg)'; this.style.color = 'var(--text-primary)';" onclick="forceCloseModal('estimatorModal'); new bootstrap.Modal(document.getElementById('estimatorModal')).show();">
                        <i class="bi bi-sliders text-primary fs-5 me-2" style="color: inherit !important;"></i> System Estimator
                    </button>
                </div>
            </div>

            <div class="col-12 col-lg-5 position-relative mt-5 mt-lg-0 d-flex justify-content-center">
                <div class="interactive-core">
                    <div class="stream-blob"></div>
                    <img src="assets/images/logo.png" alt="Omni Mavens Geometry" class="core-logo-reveal">
                </div>
            </div>
        </div>
    </section>

    <section id="clients" class="mb-5">
        <div class="text-center mb-3 mono-text fw-bold text-adaptive-secondary" style="font-size: 0.75rem; letter-spacing: 2px;">
            INFRASTRUCTURE TRUSTED BY
        </div>
        <div class="marquee-container">
            <div class="marquee-content">
                <span class="client-badge"><i class="bi bi-cpu me-2" style="color: var(--aws-blue);"></i> Generative AI Partners</span>
                <span class="client-badge"><i class="bi bi-compass me-2" style="color: var(--aws-purple);"></i> NIS Ogun State</span>
                <span class="client-badge"><i class="bi bi-bank me-2" style="color: var(--aws-blue);"></i> Government Agencies</span>
                <span class="client-badge"><i class="bi bi-globe me-2" style="color: var(--aws-cyan);"></i> Global Enterprises</span>
                <span class="client-badge"><i class="bi bi-cpu me-2" style="color: var(--aws-blue);"></i> Generative AI Partners</span>
                <span class="client-badge"><i class="bi bi-compass me-2" style="color: var(--aws-purple);"></i> Nigerian Institution of Surveyors Ogun State Branch</span>
                <span class="client-badge"><i class="bi bi-bank me-2" style="color: var(--aws-blue);"></i> Government Agencies</span>
                <span class="client-badge"><i class="bi bi-globe me-2" style="color: var(--aws-cyan);"></i> Global Enterprises</span>
                <span class="client-badge"><i class="bi bi-globe me-2" style="color: var(--aws-cyan);"></i> Fanciecorp Nigeria Limited</span>
            </div>
        </div>
    </section>

    <section id="stack" class="py-5 my-4">
        <div class="container py-4">
            <div class="text-center mb-5" data-aos="fade-up">
                <h2 class="fw-bold display-5 mb-3 text-adaptive">System Capabilities.</h2>
                <p class="text-adaptive-secondary w-75 mx-auto fs-5">Our engineering stack is built to scale, utilizing the most robust frameworks in modern cloud and software development.</p>
            </div>

            <div class="row g-4" data-aos="fade-up" data-aos-delay="100">
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-server tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">Cloud Config</h6><p class="text-adaptive-secondary small mb-0">AWS / Azure</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-database tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">Data Pipelines</h6><p class="text-adaptive-secondary small mb-0">ETL Architecture</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-phone tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">Mobile Apps</h6><p class="text-adaptive-secondary small mb-0">React Native / Expo</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-shield-lock tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">System Security</h6><p class="text-adaptive-secondary small mb-0">AES-256 Auth</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-cpu-fill tech-icon" style="color: var(--aws-purple);"></i><h6 class="text-adaptive fw-bold mono-text">Machine Learning</h6><p class="text-adaptive-secondary small mb-0">AI Integrations</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-braces-asterisk tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">API Architecture</h6><p class="text-adaptive-secondary small mb-0">REST & GraphQL</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-vector-pen tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">UI/UX Systems</h6><p class="text-adaptive-secondary small mb-0">Premium Interfaces</p></div></div>
                <div class="col-md-3 col-6"><div class="tech-card"><i class="bi bi-infinity tech-icon"></i><h6 class="text-adaptive fw-bold mono-text">DevOps Auto</h6><p class="text-adaptive-secondary small mb-0">CI/CD Pipelines</p></div></div>
            </div>
        </div>
    </section>

    <section id="platform" class="py-5">
        <div class="container py-4">
            <div class="text-center mb-5" data-aos="fade-up">
                <span class="mono-text text-adaptive-secondary fw-bold" style="font-size: 0.75rem; letter-spacing: 2px;">PROVEN ARCHITECTURE</span>
                <h2 class="fw-bold display-5 mt-2 text-adaptive">Enterprise Domains.</h2>
                <p class="text-adaptive-secondary fs-5 w-lg-50 mx-auto">We engineer solutions for complex business logic, transforming operational friction into scalable infrastructure.</p>
            </div>

            <div class="row g-4">
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="0"><div class="solution-card"><div class="solution-icon"><i class="bi bi-bank2"></i></div><h4 class="fw-bold text-adaptive mb-3">Fiscal & Accounting</h4><p class="text-adaptive-secondary small mb-4">Secure income and expenditure ledgers, real-time budget allocation routing, and encrypted financial data portals.</p><ul class="list-unstyled mono-text small fw-bold text-adaptive-secondary"><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Automated Ledger Sync</li><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Excel Data Ingestion</li><li><i class="bi bi-check2 text-success me-2 fs-5"></i>Audit-Ready Architecture</li></ul></div></div>
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100"><div class="solution-card"><div class="solution-icon"><i class="bi bi-building"></i></div><h4 class="fw-bold text-adaptive mb-3">Workspace Systems</h4><p class="text-adaptive-secondary small mb-4">Centralized operational hubs for property and facility management, featuring real-time document upload APIs.</p><ul class="list-unstyled mono-text small fw-bold text-adaptive-secondary"><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Multi-Tenant Roles</li><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Secure Document APIs</li><li><i class="bi bi-check2 text-success me-2 fs-5"></i>Hub Manager Dashboards</li></ul></div></div>
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200"><div class="solution-card"><div class="solution-icon"><i class="bi bi-geo-alt"></i></div><h4 class="fw-bold text-adaptive mb-3">Mobile Logistics</h4><p class="text-adaptive-secondary small mb-4">Cross-platform mobile applications designed for rapid deployment, errand routing, and logistical tracking.</p><ul class="list-unstyled mono-text small fw-bold text-adaptive-secondary"><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>React Native Bundling</li><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Live Geo-Tracking</li><li><i class="bi bi-check2 text-success me-2 fs-5"></i>Cross-Platform UX</li></ul></div></div>
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="0"><div class="solution-card"><div class="solution-icon"><i class="bi bi-cpu"></i></div><h4 class="fw-bold text-adaptive mb-3">Applied AI & ML</h4><p class="text-adaptive-secondary small mb-4">Custom integration of Large Language Models (LLMs) and intelligent automation into existing corporate infrastructure.</p><ul class="list-unstyled mono-text small fw-bold text-adaptive-secondary"><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Generative AI APIs</li><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Automated Workflows</li><li><i class="bi bi-check2 text-success me-2 fs-5"></i>Predictive Analytics</li></ul></div></div>
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100"><div class="solution-card"><div class="solution-icon"><i class="bi bi-diagram-3"></i></div><h4 class="fw-bold text-adaptive mb-3">Data Pipelines</h4><p class="text-adaptive-secondary small mb-4">High-throughput ETL architectures and real-time visualization dashboards for enterprise data warehousing.</p><ul class="list-unstyled mono-text small fw-bold text-adaptive-secondary"><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Real-time Telemetry</li><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>Custom ETL Workflows</li><li><i class="bi bi-check2 text-success me-2 fs-5"></i>Data Visualization</li></ul></div></div>
                <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200"><div class="solution-card"><div class="solution-icon"><i class="bi bi-shield-check"></i></div><h4 class="fw-bold text-adaptive mb-3">Zero-Trust Cloud</h4><p class="text-adaptive-secondary small mb-4">Highly available, auto-scaling microservices deployed across global edge networks with military-grade encryption.</p><ul class="list-unstyled mono-text small fw-bold text-adaptive-secondary"><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>CI/CD Automation</li><li class="mb-2"><i class="bi bi-check2 text-success me-2 fs-5"></i>SOC2 Ready Security</li><li><i class="bi bi-check2 text-success me-2 fs-5"></i>High-Availability Clusters</li></ul></div></div>
            </div>
        </div>
    </section>

    <section id="global-network" class="py-5 mt-4">
        <canvas id="globeCanvas" class="globe-canvas"></canvas>

        <div class="container position-relative" style="z-index: 5; pointer-events: none;">
            <div class="row">
                <div class="col-lg-6 my-5 py-5" data-aos="fade-right">
                    <span class="mono-text fw-bold text-adaptive-secondary" style="font-size: 0.75rem; letter-spacing: 2px;">GLOBAL NODE NETWORK</span>
                    <h2 class="fw-bold display-4 mt-2 mb-4 text-adaptive">Borderless Scale.</h2>
                    <p class="text-adaptive-secondary fw-medium fs-5 pe-lg-5">From our core engineering hub, we deploy low-latency, high-availability architecture across AWS and Azure regions, ensuring zero downtime anywhere on Earth.</p>

                    <div class="d-flex flex-column gap-3 mt-5 mono-text small text-adaptive fw-bold">
                        <div class="d-flex align-items-center">
                            <span class="pulse-dot" style="background: var(--aws-purple); box-shadow: 0 0 12px var(--aws-purple);"></span> 
                            <span>Core Operations Hub Active</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="pulse-dot" style="background: var(--aws-blue); box-shadow: 0 0 12px var(--aws-blue);"></span> 
                            <span>128 Edge Nodes Synced globally</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="leadership" class="py-5" style="background: var(--glass-bg);">
        <div class="container py-5">
            <div class="text-center mb-5" data-aos="fade-up">
                <h2 class="fw-bold display-5 mb-3 text-adaptive">Architected by the best.</h2>
                <p class="text-adaptive-secondary w-75 mx-auto fs-5">Led by industry veterans dedicated to pushing the boundaries of software infrastructure.</p>
            </div>

            <div class="row justify-content-center g-5">
                <div class="col-lg-5 col-md-6" data-aos="fade-right">
                    <div class="bento-glass text-center p-5">
                        <div class="mx-auto mb-4 position-relative d-inline-block">
                            <img src="assets/images/Godwin.jpg" alt="Jide Godwin Omolewu" class="leader-profile-img">
                        </div>
                        <h4 class="fw-bold text-adaptive mb-1">Jide Godwin Omolewu</h4>
                        <div class="mono-text small mb-3" style="color: var(--aws-blue); font-weight: 700;">Founding Partner</div>
                        <p class="text-adaptive-secondary small mb-0 fw-medium">Driving the strategic vision, enterprise software architecture, and delivering scalable solutions for global clients.</p>
                    </div>
                </div>
                <div class="col-lg-5 col-md-6" data-aos="fade-left">
                    <div class="bento-glass text-center p-5">
                        <div class="mx-auto mb-4 position-relative d-inline-block">
                            <img src="assets/images/don.jpg" alt="Peter Taiwo Opeyemi" class="leader-profile-img">
                        </div>
                        <h4 class="fw-bold text-adaptive mb-1">Peter Taiwo Opeyemi</h4>
                        <div class="mono-text small mb-3" style="color: var(--aws-blue); font-weight: 700;">Founding Partner</div>
                        <p class="text-adaptive-secondary small mb-0 fw-medium">Spearheading operational excellence, infrastructure deployments, and ensuring zero-downtime execution.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="contact" class="py-5 mb-5 mt-4">
        <div class="container" data-aos="zoom-in">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="bento-glass p-md-5">
                        <div class="text-center mb-5">
                            <img src="assets/images/logo.png" alt="Logo" class="brand-logo mb-4" style="height: 50px;">
                            <h2 class="fw-bold display-6 text-adaptive" style="letter-spacing: -0.03em;">Initialize Protocol.</h2>
                            <p class="text-adaptive-secondary fw-bold mono-text small">SECURE_TRANSMISSION_ENABLED</p>
                        </div>

                        <form id="appContactForm">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <input type="text" class="form-control light-form" id="senderName" name="name" required placeholder="Authorized Name">
                                </div>
                                <div class="col-md-6">
                                    <input type="email" class="form-control light-form" id="senderEmail" name="email" required placeholder="Corporate Email">
                                </div>
                                <div class="col-12 mt-5">
                                    <textarea class="form-control light-form" id="messageBody" name="message" rows="4" required placeholder="Define project parameters..." style="resize: vertical;"></textarea>
                                </div>
                                <div class="col-12 mt-5 text-center">
                                    <button type="submit" class="btn btn-cyber w-100 py-3 fs-6 mono-text" id="submitBtn">
                                        EXECUTE TRANSMISSION
                                    </button>
                                </div>
                            </div>
                        </form>

                        <div id="successAlert" class="alert bg-success bg-opacity-10 text-success mt-4 d-none mb-0 text-center mono-text border-success border-opacity-25 fw-bold" style="border-radius: 12px;" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> [TRANSMISSION SUCCESSFUL] Engineering team notified.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

</main>

<div class="modal fade" id="estimatorModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content glass-modal">
            <div class="modal-header border-bottom border-secondary border-opacity-25 pb-4">
                <div>
                    <h5 class="modal-title text-white fw-bold mono-text fs-5"><i class="bi bi-cpu text-primary me-2"></i> INFRASTRUCTURE ESTIMATOR</h5>
                    <div class="text-secondary small mt-1">Define system parameters to calculate architectural complexity.</div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4">
                    <div class="col-lg-8 border-end border-secondary border-opacity-25 pe-lg-4">
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="text-white mono-text small mb-3 border-bottom border-secondary border-opacity-25 pb-2 w-100">CLIENT NODES (FRONTEND)</label>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estWeb" value="1.5" checked>
                                    <label class="form-check-label text-secondary small" for="estWeb">Enterprise Web Portal</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estMobile" value="2.0">
                                    <label class="form-check-label text-secondary small" for="estMobile">Cross-Platform Mobile App</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estAdmin" value="1.0">
                                    <label class="form-check-label text-secondary small" for="estAdmin">Internal Admin CMS</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-4">
                                <label class="text-white mono-text small mb-3 border-bottom border-secondary border-opacity-25 pb-2 w-100">CORE LOGIC (BACKEND)</label>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estJava" value="1.5" checked>
                                    <label class="form-check-label text-secondary small" for="estJava">Java / Jakarta EE API</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estNode" value="1.0">
                                    <label class="form-check-label text-secondary small" for="estNode">Node.js Microservices</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estSocket" value="1.0">
                                    <label class="form-check-label text-secondary small" for="estSocket">Real-time WebSockets</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="text-white mono-text small mb-3 border-bottom border-secondary border-opacity-25 pb-2 w-100">ADVANCED INTEGRATIONS</label>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estAI" value="2.0">
                                    <label class="form-check-label text-secondary small" for="estAI">Generative AI / LLMs</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estData" value="1.5">
                                    <label class="form-check-label text-secondary small" for="estData">Complex ETL Data Pipelines</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estPay" value="0.5">
                                    <label class="form-check-label text-secondary small" for="estPay">Payment Gateway Auth</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="text-white mono-text small mb-3 border-bottom border-secondary border-opacity-25 pb-2 w-100">INFRASTRUCTURE</label>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estCloud" value="0.5" checked>
                                    <label class="form-check-label text-secondary small" for="estCloud">Standard Cloud Hosting</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estCluster" value="1.5">
                                    <label class="form-check-label text-secondary small" for="estCluster">High-Availability CI/CD Cluster</label>
                                </div>
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input est-toggle" type="checkbox" id="estSoc2" value="1.5">
                                    <label class="form-check-label text-secondary small" for="estSoc2">SOC2 / Enterprise Security</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 ps-lg-4 d-flex flex-column justify-content-center mt-4 mt-lg-0">
                        <div class="text-center p-4 rounded" style="background: rgba(0,0,0,0.3); border: 1px solid rgba(142, 197, 252, 0.2);">
                            <div class="text-secondary mono-text mb-2" style="font-size: 0.7rem;">SYSTEM COMPLEXITY SCORE</div>
                            <div class="display-3 fw-bold text-white mb-0" id="calcScore" style="text-shadow: 0 0 20px var(--aws-cyan);">3.5</div>
                            <div class="text-secondary small mt-1">/ 10.0</div>
                            <hr class="border-secondary opacity-25 my-4">
                            <div class="text-secondary mono-text mb-2" style="font-size: 0.7rem;">ESTIMATED DEPLOYMENT</div>
                            <div class="fs-4 fw-bold" style="color: var(--aws-cyan);" id="calcTime">4 - 8 Weeks</div>
                        </div>
                        <button class="btn btn-cyber w-100 mt-4 py-3 mono-text fs-7" onclick="transferEstimatorData()" style="background: var(--aws-blue); border-color: transparent; color: white;">
                            ATTACH TO SECURE TRANSMISSION
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="terminal-launcher" id="termLauncher" onclick="toggleTerminal()">
    <i class="bi bi-terminal"></i>
</div>

<div id="cyberTerminal" class="cyber-terminal-window">
    <div class="terminal-header">
        <span>root@omnimavens:~</span>
        <i class="bi bi-x" onclick="toggleTerminal()" style="cursor: none !important;"></i>
    </div>
    <div class="terminal-body" id="termBody">
        <div class="mb-2">OmniOS v1.0.0 initialized.</div>
        <div class="mb-2" style="color: #94a3b8;">Type <span class="text-white">help</span> for commands.</div>
    </div>
    <div class="terminal-input-line">
        <span class="term-prompt">$&gt;</span>
        <input type="text" id="termInput" autocomplete="off" spellcheck="false" onkeypress="handleTerm(event)">
    </div>
</div>

<div id="cookieProtocol" class="cyber-cookie-banner">
    <div class="d-flex align-items-center mb-3">
        <i class="bi bi-shield-lock me-2" style="color: var(--aws-cyan); font-size: 1.2rem;"></i>
        <span class="mono-text text-white fw-bold" style="font-size: 0.8rem; letter-spacing: 1px;">DATA_PROCESSING_PROTOCOL</span>
    </div>
    <p class="text-secondary small mb-4" style="line-height: 1.6;">
        This node utilizes encrypted cookies to optimize infrastructure routing and maintain secure session state. Do you authorize this connection?
    </p>
    <div class="d-flex gap-2">
        <button id="acceptCookies" class="btn py-2 px-3 fs-7 mono-text w-100" style="border-radius: 8px; font-size: 0.75rem; background: var(--aws-blue); color: white; border: none;">AUTHORIZE</button>
        <button id="declineCookies" class="btn text-secondary py-2 px-3 mono-text w-100" style="background: rgba(255,255,255,0.05); border-radius: 8px; border: 1px solid rgba(255,255,255,0.1); font-size: 0.75rem;">DECLINE</button>
    </div>
</div>

<script>
    /* --- 1. BULLETPROOF SYSTEM LOADER ENGINE --- */
    function removeSystemLoader() {
        const loader = document.getElementById('system-loader');
        if (loader) {
            loader.style.opacity = '0';
            setTimeout(() => loader.style.visibility = 'hidden', 800);
        }
        document.body.classList.remove('is-loading');
    }
    setTimeout(removeSystemLoader, 1500);
    window.addEventListener('load', removeSystemLoader);

    /* --- 2. MODAL OVERRIDE ENGINE --- */
    window.forceCloseModal = function (modalId) {
        const modalElement = document.getElementById(modalId);
        if (modalElement) {
            if (typeof bootstrap !== 'undefined') {
                const modalInstance = bootstrap.Modal.getInstance(modalElement);
                if (modalInstance) {
                    modalInstance.hide();
                } else {
                    const newInstance = new bootstrap.Modal(modalElement);
                    newInstance.hide();
                }
            } else {
                modalElement.classList.remove('show');
                modalElement.style.display = 'none';
                document.body.classList.remove('modal-open');
                const backdrop = document.querySelector('.modal-backdrop');
                if (backdrop)
                    backdrop.remove();
            }
        }
    };

    /* --- 3. SYSTEM ESTIMATOR ENGINE --- */
    const estToggles = document.querySelectorAll('.est-toggle');
    const scoreDisplay = document.getElementById('calcScore');
    const timeDisplay = document.getElementById('calcTime');
    let currentScore = 3.5;

    function recalculateSystem() {
        let newScore = 0;
        estToggles.forEach(t => {
            if (t.checked)
                newScore += parseFloat(t.value);
        });
        if (newScore > 9.9)
            newScore = 10.0;
        if (newScore < 1.0)
            newScore = 1.0;
        animateValue(scoreDisplay, currentScore, newScore, 500);
        currentScore = newScore;
        if (newScore <= 3.5)
            timeDisplay.innerText = "2 - 4 Weeks";
        else if (newScore <= 6.5)
            timeDisplay.innerText = "4 - 8 Weeks";
        else if (newScore <= 8.5)
            timeDisplay.innerText = "8 - 12 Weeks";
        else if (newScore <= 9.5)
            timeDisplay.innerText = "3 - 5 Months";
        else
            timeDisplay.innerText = "6+ Months";
    }

    function animateValue(obj, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp)
                startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            if (obj)
                obj.innerHTML = (progress * (end - start) + start).toFixed(1);
            if (progress < 1)
                window.requestAnimationFrame(step);
        };
        window.requestAnimationFrame(step);
    }

    estToggles.forEach(t => t.addEventListener('change', recalculateSystem));

    function transferEstimatorData() {
        const estToggles = document.querySelectorAll('.est-toggle');
        let selectedStack = [];
        estToggles.forEach(t => {
            if (t.checked)
                selectedStack.push(t.nextElementSibling.innerText.trim());
        });

        const scoreEl = document.getElementById('calcScore');
        const timeEl = document.getElementById('calcTime');

        let rawScore = scoreEl ? (scoreEl.value || scoreEl.innerText || scoreEl.textContent || "").trim() : "";
        let rawTime = timeEl ? (timeEl.value || timeEl.innerText || timeEl.textContent || "").trim() : "";

        let finalScore = rawScore || "3.5";
        let finalTime = rawTime || "4 - 8 Weeks";
        let finalStack = selectedStack.length > 0 ? selectedStack.join('\n- ') : "Standard Architecture";

        let draftMsg = "[AUTO-GENERATED SYSTEM REPORT]\n" +
                "Complexity Score: " + finalScore + "/10.0\n" +
                "Est. Timeline: " + finalTime + "\n\n" +
                "Required Architecture:\n- " + finalStack + "\n\n" +
                "Additional Requirements:\n";

        if (typeof forceCloseModal === 'function')
            forceCloseModal('estimatorModal');

        const msgBody = document.getElementById('messageBody');
        if (msgBody)
            msgBody.value = draftMsg;

        const contactSec = document.getElementById('contact');
        if (contactSec)
            contactSec.scrollIntoView({behavior: 'smooth'});

        setTimeout(() => {
            const senderEmail = document.getElementById('senderEmail');
            if (senderEmail)
                senderEmail.focus();
        }, 800);
    }

    /* --- 4. UPGRADED LOCAL/AI TERMINAL ENGINE --- */
    function toggleTerminal() {
        const term = document.getElementById('cyberTerminal');
        const launcher = document.getElementById('termLauncher');
        if (!term || !launcher)
            return;

        if (term.classList.contains('open')) {
            term.classList.remove('open');
            launcher.style.transform = "scale(1)";
        } else {
            term.classList.add('open');
            launcher.style.transform = "scale(0)";
            setTimeout(() => {
                document.getElementById('termInput').focus();
            }, 400);

            if (document.getElementById('termBody').innerText.trim() === "") {
                printTerm("OmniOS v2.0.0 Neural-Net Initialized.", "var(--aws-cyan)");
                printTerm("I am the Omni Mavens AI Concierge. How can I assist with your infrastructure today?", "#a5d6ff");
            }
        }
    }

    function printTerm(text, color = "#a5d6ff") {
        const body = document.getElementById('termBody');
        setTimeout(() => {
            const div = document.createElement('div');
            div.className = "mb-2";
            div.style.color = color;
            div.style.lineHeight = "1.5";
            div.innerHTML = text;
            body.appendChild(div);
            body.scrollTop = body.scrollHeight;
        }, 300);
    }

    function handleTerm(e) {
        if (e.key === 'Enter') {
            const input = document.getElementById('termInput');
            const val = input.value.trim();
            input.value = "";
            if (val === "")
                return;
            printTerm(`$&gt; ${val}`, "white");
            processAiResponse(val);
        }
    }

    function processAiResponse(input) {
        const query = input.toLowerCase().trim();
        const body = document.getElementById('termBody');
        const thinkingId = "think-" + Date.now();

        if (query === 'clear') {
            body.innerHTML = "";
            return;
        }
        if (query === 'contact' || query === 'hire' || query === 'initiate') {
            printTerm("Rerouting to secure transmission port...", "var(--aws-cyan)");
            setTimeout(() => {
                toggleTerminal();
                document.getElementById('contact').scrollIntoView({behavior: 'smooth'});
                document.getElementById('senderName').focus();
            }, 1000);
            return;
        }
        if (query === 'help') {
            printTerm("AVAILABLE PROTOCOLS:", "var(--aws-purple)");
            printTerm("&nbsp;&nbsp;<b>help</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Display this command module", "var(--text-secondary)");
            printTerm("&nbsp;&nbsp;<b>status</b>&nbsp;&nbsp;&nbsp;- View live system telemetry", "var(--text-secondary)");
            printTerm("&nbsp;&nbsp;<b>contact</b>&nbsp;&nbsp;- Initialize secure transmission", "var(--text-secondary)");
            printTerm("&nbsp;&nbsp;<b>clear</b>&nbsp;&nbsp;&nbsp;&nbsp;- Purge terminal history", "var(--text-secondary)");
            printTerm("&nbsp;&nbsp;[query]&nbsp;&nbsp;&nbsp;- Send prompt to Omni-AI Core", "var(--text-secondary)");
            return;
        }
        if (query === 'status') {
            printTerm("SYSTEM TELEMETRY:", "var(--aws-cyan)");
            printTerm("> Edge Nodes:&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:#10b981'>128/128 ONLINE</span>", "var(--text-secondary)");
            printTerm("> Encryption:&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:#10b981'>AES-256 ACTIVE</span>", "var(--text-secondary)");
            printTerm("> AI Core Link:&nbsp;&nbsp;<span style='color:#f59e0b'>STANDBY</span>", "var(--text-secondary)");
            return;
        }

        const thinkDiv = document.createElement('div');
        thinkDiv.id = thinkingId;
        thinkDiv.className = "mb-2";
        thinkDiv.style.color = "var(--aws-cyan)";
        thinkDiv.style.opacity = "0.7";
        thinkDiv.innerText = "[Omni-AI is establishing neural link...]";
        body.appendChild(thinkDiv);
        body.scrollTop = body.scrollHeight;

        const formData = new URLSearchParams();
        formData.append('message', input);

        fetch('${pageContext.request.contextPath}/AIServlet', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: formData.toString()
        })
                .then(async response => {
                    const data = await response.text();
                    if (!response.ok) {
                        throw new Error(data || "HTTP Error " + response.status);
                    }
                    return data;
                })
                .then(data => {
                    const tDiv = document.getElementById(thinkingId);
                    if (tDiv)
                        tDiv.remove();
                    let formattedData = data.replace(/\*\*(.*?)\*\*/g, '<strong class="text-white">$1</strong>');
                    printTerm(formattedData, "#e0fcff");
                })
                .catch(error => {
                    const tDiv = document.getElementById(thinkingId);
                    if (tDiv)
                        tDiv.remove();

                    printTerm("<span style='color:#ef4444'>[SERVER EXCEPTION]</span> " + error.message, "var(--text-secondary)");
                    if (error.message.includes("404") || error.message.includes("Unexpected token")) {
                        printTerm("<span style='font-size:0.75rem; color:var(--aws-cyan);'>DIAGNOSTIC: Error 404. The AIServlet endpoint cannot be found. Try 'Clean and Build' then Redeploy your project in NetBeans.</span>", "var(--text-secondary)");
                    }
                });
    }

    /* --- 5. INITIALIZATION SCRIPT BLOCK --- */
    setTimeout(() => {
        if (!localStorage.getItem('omni_cookie_consent')) {
            const cp = document.getElementById('cookieProtocol');
            if (cp)
                cp.classList.add('show');
        }
    }, 2000);

    const btnAccept = document.getElementById('acceptCookies');
    if (btnAccept) {
        btnAccept.addEventListener('click', () => {
            localStorage.setItem('omni_cookie_consent', 'authorized');
            const cp = document.getElementById('cookieProtocol');
            if (cp)
                cp.classList.remove('show');
        });
    }

    const btnDecline = document.getElementById('declineCookies');
    if (btnDecline) {
        btnDecline.addEventListener('click', () => {
            localStorage.setItem('omni_cookie_consent', 'declined');
            const cp = document.getElementById('cookieProtocol');
            if (cp)
                cp.classList.remove('show');
        });
    }

    /* Ambient Background Network */
    const canvas = document.getElementById('cyberNetworkCanvas');
    if (canvas) {
        const ctx = canvas.getContext('2d');
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        let particlesArray = [];
        let mouse = {x: null, y: null, radius: 150};

        window.addEventListener('mousemove', function (event) {
            mouse.x = event.x;
            mouse.y = event.y;
        });
        window.addEventListener('resize', function () {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            initBg();
        });

        class Particle {
            constructor(x, y, directionX, directionY, size) {
                this.x = x;
                this.y = y;
                this.directionX = directionX;
                this.directionY = directionY;
                this.size = size;
            }
            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2, false);
                ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
                ctx.fill();
            }
            update() {
                if (this.x > canvas.width || this.x < 0)
                    this.directionX = -this.directionX;
                if (this.y > canvas.height || this.y < 0)
                    this.directionY = -this.directionY;
                this.x += this.directionX;
                this.y += this.directionY;
                this.draw();
            }
        }

        function initBg() {
            particlesArray = [];
            let numberOfParticles = (canvas.height * canvas.width) / 10000;
            for (let i = 0; i < numberOfParticles; i++) {
                let size = (Math.random() * 2) + 1;
                let x = (Math.random() * ((innerWidth - size * 2) - (size * 2)) + size * 2);
                let y = (Math.random() * ((innerHeight - size * 2) - (size * 2)) + size * 2);
                let directionX = (Math.random() * 1) - 0.5;
                let directionY = (Math.random() * 1) - 0.5;
                particlesArray.push(new Particle(x, y, directionX, directionY, size));
            }
        }

        function connect() {
            let opacityValue = 1;
            for (let a = 0; a < particlesArray.length; a++) {
                for (let b = a; b < particlesArray.length; b++) {
                    let distance = ((particlesArray[a].x - particlesArray[b].x) * (particlesArray[a].x - particlesArray[b].x)) + ((particlesArray[a].y - particlesArray[b].y) * (particlesArray[a].y - particlesArray[b].y));
                    if (distance < (canvas.width / 10) * (canvas.height / 10)) {
                        opacityValue = 1 - (distance / 15000);
                        let dx = mouse.x - particlesArray[a].x;
                        let dy = mouse.y - particlesArray[a].y;
                        let mouseDistance = Math.sqrt(dx * dx + dy * dy);
                        if (mouseDistance < mouse.radius) {
                            ctx.strokeStyle = 'rgba(255, 255, 255, ' + (1 - mouseDistance / mouse.radius) + ')';
                            ctx.lineWidth = 1.5;
                        } else {
                            ctx.strokeStyle = 'rgba(255, 255, 255, ' + (opacityValue * 0.15) + ')';
                            ctx.lineWidth = 0.5;
                        }
                        ctx.beginPath();
                        ctx.moveTo(particlesArray[a].x, particlesArray[a].y);
                        ctx.lineTo(particlesArray[b].x, particlesArray[b].y);
                        ctx.stroke();
                    }
                }
            }
        }

        function animateBg() {
            requestAnimationFrame(animateBg);
            ctx.clearRect(0, 0, innerWidth, innerHeight);
            for (let i = 0; i < particlesArray.length; i++) {
                particlesArray[i].update();
            }
            connect();
        }
        initBg();
        animateBg();
        window.addEventListener('mouseout', function () {
            mouse.x = undefined;
            mouse.y = undefined;
        });
    }

    /* 3D Globe Engine */
    const globeCanvas = document.getElementById('globeCanvas');
    if (globeCanvas) {
        const gCtx = globeCanvas.getContext('2d');
        let globeWidth, globeHeight, globeCenterX, globeCenterY;
        let globeNodes = [];
        let rotationAngle = 0;

        function initGlobe() {
            globeCanvas.width = globeCanvas.offsetWidth || 500;
            globeCanvas.height = globeCanvas.offsetHeight || 500;
            globeWidth = globeCanvas.width;
            globeHeight = globeCanvas.height;
            globeCenterX = globeWidth / 2;
            globeCenterY = globeHeight / 2;
            globeNodes = [];

            for (let i = 0; i < 180; i++) {
                let lat = Math.acos(Math.random() * 2 - 1);
                let lon = Math.random() * 2 * Math.PI;
                let isHub = (Math.random() > 0.98);
                globeNodes.push({lat: lat, lon: lon, isHub: isHub});
            }
        }

        function animateGlobe() {
            requestAnimationFrame(animateGlobe);
            gCtx.clearRect(0, 0, globeWidth, globeHeight);
            rotationAngle += 0.002;
            let scale = globeHeight * 0.45;

            let projectedNodes = [];

            for (let i = 0; i < globeNodes.length; i++) {
                let node = globeNodes[i];
                let rLon = node.lon + rotationAngle;
                let x = Math.sin(node.lat) * Math.cos(rLon);
                let y = Math.cos(node.lat);
                let z = Math.sin(node.lat) * Math.sin(rLon);

                if (z > -0.2) {
                    let px = globeCenterX + x * scale;
                    let py = globeCenterY + y * scale;
                    let alpha = (z + 0.2) / 1.2;
                    projectedNodes.push({x: px, y: py, alpha: alpha, isHub: node.isHub});
                }
            }

            for (let i = 0; i < projectedNodes.length; i++) {
                let n1 = projectedNodes[i];
                gCtx.beginPath();
                gCtx.arc(n1.x, n1.y, n1.isHub ? 2.5 : 1.2, 0, Math.PI * 2);

                gCtx.fillStyle = n1.isHub ? 'rgba(168, 85, 247, ' + n1.alpha + ')' : 'rgba(41, 98, 255, ' + n1.alpha + ')';

                if (n1.isHub) {
                    gCtx.shadowBlur = 10;
                    gCtx.shadowColor = '#a855f7';
                } else {
                    gCtx.shadowBlur = 5;
                    gCtx.shadowColor = '#2962ff';
                }
                gCtx.fill();

                for (let j = i + 1; j < projectedNodes.length; j++) {
                    let n2 = projectedNodes[j];
                    let dist = Math.sqrt(Math.pow(n1.x - n2.x, 2) + Math.pow(n1.y - n2.y, 2));
                    if (dist < 65) {
                        gCtx.beginPath();
                        gCtx.moveTo(n1.x, n1.y);
                        gCtx.lineTo(n2.x, n2.y);

                        let minAlpha = Math.min(n1.alpha, n2.alpha);
                        gCtx.strokeStyle = n1.isHub || n2.isHub ? 'rgba(168, 85, 247, ' + (minAlpha * 0.6) + ')' : 'rgba(41, 98, 255, ' + (minAlpha * 0.3) + ')';

                        gCtx.lineWidth = n1.isHub || n2.isHub ? 1.0 : 0.5;
                        gCtx.stroke();
                    }
                }
            }
            gCtx.shadowBlur = 0;
        }

        initGlobe();
        animateGlobe();
        window.addEventListener('resize', initGlobe);
    }

    /* TYPEWRITER ENGINE */
    const words = ["mission-critical software.", "mobile applications.", "AI-ready pipelines.", "cloud infrastructure."];
    let i = 0, timer, tIndex = 0, isDeleting = false;
    function typeWriter() {
        const textElement = document.getElementById("typewriterText");
        if (!textElement)
            return;
        let currentWord = words[i];
        if (isDeleting) {
            textElement.textContent = currentWord.substring(0, tIndex - 1);
            tIndex--;
        } else {
            textElement.textContent = currentWord.substring(0, tIndex + 1);
            tIndex++;
        }
        let speed = isDeleting ? 40 : 80;
        if (!isDeleting && tIndex === currentWord.length) {
            speed = 2000;
            isDeleting = true;
        } else if (isDeleting && tIndex === 0) {
            isDeleting = false;
            i = (i + 1) % words.length;
            speed = 400;
        }
        timer = setTimeout(typeWriter, speed);
    }
    setTimeout(typeWriter, 1000);

    /* CONTACT FORM ENGINE */
    const contactForm = document.getElementById('appContactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const btn = document.getElementById('submitBtn');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> EXECUTING...';
            btn.disabled = true;

            const formData = new URLSearchParams();
            formData.append('name', document.getElementById('senderName').value);
            formData.append('email', document.getElementById('senderEmail').value);
            formData.append('message', document.getElementById('messageBody').value);

            fetch('${pageContext.request.contextPath}/ContactServlet', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData.toString()
            })
                    .then(response => {
                        if (response.ok) {
                            document.getElementById('appContactForm').reset();
                            document.getElementById('appContactForm').classList.add('d-none');
                            document.getElementById('successAlert').classList.remove('d-none');
                        } else {
                            alert("SYSTEM ERROR: Transmission failed. Please try again.");
                        }
                    })
                    .catch(error => {
                        alert("SYSTEM ERROR: Network disconnect.");
                    })
                    .finally(() => {
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    });
        });
    }
</script>

<jsp:include page="includes/footer.jsp" />