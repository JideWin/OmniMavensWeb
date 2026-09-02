<footer class="pt-5" style="background: var(--glass-bg); backdrop-filter: blur(24px); border-top: 1px solid var(--glass-border); padding-bottom: 90px !important;">
    <div class="container pb-4">
        <div class="row gy-5 mb-4 mt-2">
            <div class="col-lg-4">
                <div class="d-flex align-items-center mb-4 gap-2">
                    <img src="assets/images/logo.png" alt="Omni Mavens" class="brand-logo" style="height: 45px; filter: brightness(1.5) drop-shadow(0px 0px 5px rgba(255, 255, 255, 0.3));">
                    <span class="sleek-logo-text" style="color: var(--text-primary) !important;">Omni Mavens</span>
                </div>
                <p class="text-adaptive-secondary small pe-lg-4" style="line-height: 1.8;">
                    Architecting the data engines and high-performance software infrastructure for the next generation of enterprises.
                </p>
                <div class="mono-text text-adaptive-secondary" style="font-size: 0.7rem; opacity: 0.5;">RC: 7327052</div>
            </div>
            
            <div class="col-lg-2 offset-lg-2">
                <h6 class="text-adaptive fw-bold mb-4 mono-text" style="font-size: 0.75rem;">SYSTEMS</h6>
                <ul class="list-unstyled d-flex flex-column gap-3">
                    <li><a href="#platform" class="text-adaptive-secondary text-decoration-none small transition-white fw-medium">Enterprise Eng.</a></li>
                    <li><a href="#stack" class="text-adaptive-secondary text-decoration-none small transition-white fw-medium">Tech Stack</a></li>
                    <li><a href="#leadership" class="text-adaptive-secondary text-decoration-none small transition-white fw-medium">Leadership</a></li>
                    <li>
                        <a class="text-adaptive-secondary text-decoration-none small transition-white fw-medium" href="#" onclick="event.preventDefault(); if(document.getElementById('estimatorModal')){ new bootstrap.Modal(document.getElementById('estimatorModal')).show(); } else { window.location.href='index.jsp'; }">
                            Estimator
                        </a>
                    </li>
                </ul>
            </div>
            
            <div class="col-lg-4">
                <h6 class="text-adaptive fw-bold mb-4 mono-text" style="font-size: 0.75rem;">DIRECT CHANNELS</h6>
                <ul class="list-unstyled text-adaptive-secondary small d-flex flex-column gap-3 fw-medium">
                    <li class="d-flex align-items-start gap-3">
                        <i class="bi bi-geo-alt mt-1 fs-5" style="color: var(--aws-cyan);"></i>
                        <a href="https://www.google.com/maps/search/?api=1&query=2nd+Floor,+97B,+Surveyors+House,+Ijeja,+Abeokuta,+Ogun+State" target="_blank" class="text-adaptive-secondary text-decoration-none transition-white">
                            2nd Floor, 97B, Surveyors' House,<br>Ijeja, Abeokuta, Ogun State.
                        </a>
                    </li>
                    <li class="d-flex align-items-center gap-3">
                        <i class="bi bi-envelope fs-5" style="color: var(--aws-cyan);"></i>
                        <a href="mailto:omnimavenscompany@gmail.com" class="text-adaptive-secondary text-decoration-none transition-white">omnimavenscompany@gmail.com</a>
                    </li>
                    <li class="d-flex align-items-center gap-3">
                        <i class="bi bi-whatsapp text-success fs-5"></i>
                        <a href="https://wa.me/2348167829803" target="_blank" class="text-adaptive-secondary text-decoration-none transition-white">+234 816 782 9803</a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex flex-wrap gap-3 align-items-center border border-secondary border-opacity-25 rounded p-3" style="background: rgba(255,255,255,0.02);">
                    <span class="mono-text text-adaptive-secondary me-3" style="font-size: 0.7rem; letter-spacing: 1px;">INFRASTRUCTURE STANDARDS:</span>
                    <div class="d-flex align-items-center gap-2 text-adaptive-secondary fw-medium" style="font-size: 0.8rem;">
                        <i class="bi bi-shield-check text-success"></i> SOC2 Ready
                    </div>
                    <div class="d-flex align-items-center gap-2 text-adaptive-secondary px-3 border-start border-secondary border-opacity-25 fw-medium" style="font-size: 0.8rem;">
                        <i class="bi bi-lock text-adaptive"></i> AES-256 Encrypted
                    </div>
                    <div class="d-flex align-items-center gap-2 text-adaptive-secondary px-3 border-start border-secondary border-opacity-25 fw-medium" style="font-size: 0.8rem;">
                        <i class="bi bi-file-earmark-lock" style="color: var(--aws-cyan);"></i> GDPR Compliant Data
                    </div>
                </div>
            </div>
        </div>
        
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center text-adaptive-secondary border-top pt-4 mt-2" style="border-color: var(--glass-border) !important; font-size: 0.75rem;">
            <div class="mono-text">
                © <%= java.time.Year.now().getValue() %> OMNI MAVENS // ALL RIGHTS RESERVED.
            </div>
            <div class="d-flex gap-4 mt-3 mt-md-0 mono-text fw-bold">
                <a href="#" data-bs-toggle="modal" data-bs-target="#privacyModal" class="text-adaptive-secondary text-decoration-none transition-white" style="cursor: pointer;">PRIVACY</a>
                <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal" class="text-adaptive-secondary text-decoration-none transition-white" style="cursor: pointer;">TERMS</a>
            </div>
        </div>
    </div>
</footer>

<button id="backToTopBtn" class="back-to-top" onclick="scrollToTop()">
    <i class="bi bi-arrow-up"></i>
</button>

<div class="cyber-cursor" id="globalCyberCursor"></div>
<div class="cyber-cursor-dot" id="globalCyberCursorDot"></div>

<style>
    .transition-white { transition: color 0.3s; }
    .transition-white:hover { color: var(--aws-cyan) !important; }

    /* =========================================
       BACK TO TOP BUTTON
       ========================================= */
    .back-to-top {
        position: fixed; bottom: 30px; right: 105px; width: 50px; height: 50px;
        background: var(--glass-bg); backdrop-filter: blur(10px);
        border: 1px solid var(--aws-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center;
        color: var(--aws-cyan); font-size: 1.2rem; z-index: 9997; box-shadow: 0 5px 15px rgba(15, 23, 42, 0.3);
        opacity: 0; visibility: hidden; transform: translateY(20px); transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        cursor: none !important;
    }
    .back-to-top.show { opacity: 1; visibility: visible; transform: translateY(0); }
    .back-to-top:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(41, 98, 255, 0.4); background: var(--aws-blue); color: white; }

    /* =========================================
       GLOBAL CYBER CURSOR CSS & ADAPTIVE DARK MODE
       ========================================= */
    @media (pointer: fine) {
        body, a, button, input, textarea, .btn-close, .form-check-input { cursor: none !important; }
    }
    .cyber-cursor {
        position: fixed; top: 0; left: 0; width: 24px; height: 24px;
        border: 1.5px solid var(--text-primary); border-radius: 50%;
        pointer-events: none; z-index: 99999999; transform: translate(-50%, -50%);
        transition: width 0.3s cubic-bezier(0.165, 0.84, 0.44, 1), height 0.3s cubic-bezier(0.165, 0.84, 0.44, 1), background-color 0.3s, border-color 0.3s;
    }
    .cyber-cursor-dot {
        position: fixed; top: 0; left: 0; width: 4px; height: 4px;
        background: var(--text-primary); border-radius: 50%;
        pointer-events: none; z-index: 99999999; transform: translate(-50%, -50%);
        transition: background-color 0.3s;
    }
    
    .cyber-cursor.hovering {
        width: 50px; height: 50px; background-color: rgba(41, 98, 255, 0.1); border-color: var(--aws-blue);
    }
    .cyber-cursor-dot.hovering { background-color: var(--aws-blue); }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

<script>
    if (typeof AOS !== 'undefined') {
        AOS.init({ once: true, offset: 50, duration: 1200, easing: 'cubic-bezier(0.165, 0.84, 0.44, 1)' });
    }

    /* --- THEME TOGGLE ENGINE --- */
    const themeToggleBtn = document.getElementById('themeToggleBtn');
    const themeIcon = document.getElementById('themeIcon');
    
    function updateThemeIcon(theme) {
        if(theme === 'light') {
            themeIcon.className = 'bi bi-moon-stars-fill'; // Show moon in light mode to switch to dark
        } else {
            themeIcon.className = 'bi bi-sun-fill'; // Show sun in dark mode to switch to light
        }
    }
    
    if (themeToggleBtn) {
        updateThemeIcon(document.documentElement.getAttribute('data-theme'));
        
        themeToggleBtn.addEventListener('click', () => {
            let current = document.documentElement.getAttribute('data-theme');
            let targetTheme = current === 'light' ? 'dark' : 'light';
            
            document.documentElement.setAttribute('data-theme', targetTheme);
            localStorage.setItem('omni_theme', targetTheme);
            updateThemeIcon(targetTheme);
        });
    }

    /* --- GLOBAL CYBER CURSOR ENGINE (Adaptive) --- */
    if(window.matchMedia("(pointer: fine)").matches) {
        const cursor = document.getElementById('globalCyberCursor');
        const cursorDot = document.getElementById('globalCyberCursorDot');
        
        if(cursor && cursorDot) {
            document.addEventListener('mousemove', (e) => {
                cursor.style.left = e.clientX + 'px';
                cursor.style.top = e.clientY + 'px';
                cursorDot.style.left = e.clientX + 'px';
                cursorDot.style.top = e.clientY + 'px';
            });

            document.addEventListener('mouseover', (e) => {
                const t = e.target;
                if(t.tagName==='A' || t.tagName==='BUTTON' || t.tagName==='INPUT' || t.tagName==='TEXTAREA' || t.classList.contains('terminal-launcher') || t.classList.contains('btn-close') || t.classList.contains('form-check-input') || t.closest('a') || t.closest('button')) {
                    cursor.classList.add('hovering');
                    cursorDot.classList.add('hovering');
                }
            });
            document.addEventListener('mouseout', (e) => {
                const t = e.target;
                if(t.tagName==='A' || t.tagName==='BUTTON' || t.tagName==='INPUT' || t.tagName==='TEXTAREA' || t.classList.contains('terminal-launcher') || t.classList.contains('btn-close') || t.classList.contains('form-check-input') || t.closest('a') || t.closest('button')) {
                    cursor.classList.remove('hovering');
                    cursorDot.classList.remove('hovering');
                }
            });
        }
    }

    /* SCROLL LISTENER ENGINE */
    window.addEventListener('scroll', () => {
        const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
        const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
        const scrolled = (winScroll / height) * 100;
        const scrollBar = document.getElementById("scrollBar");
        if(scrollBar) scrollBar.style.width = scrolled + "%";
        const bttBtn = document.getElementById("backToTopBtn");
        if (bttBtn) {
            if (winScroll > 300) { bttBtn.classList.add("show"); } else { bttBtn.classList.remove("show"); }
        }
    });

    function scrollToTop() { window.scrollTo({ top: 0, behavior: 'smooth' }); }
</script>