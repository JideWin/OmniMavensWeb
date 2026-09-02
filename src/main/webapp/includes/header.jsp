<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Omni Mavens | Next-Gen Infrastructure</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo.png?v=2">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/logo.png?v=2">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;700&family=Poiret+One&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- THEME INITIALIZATION SCRIPT (Prevents FOUC/Flashing) -->
    <script>
        let currentTheme = localStorage.getItem('omni_theme') || 'dark';
        document.documentElement.setAttribute('data-theme', currentTheme);
    </script>

    <style>
        :root {
            /* --- DARK MODE (DEFAULT) --- */
            --bg-gradient: linear-gradient(135deg, #020617 0%, #0f172a 50%, #082f49 100%);
            --text-primary: #f8fafc;   
            --text-secondary: #94a3b8; 
            
            --glass-bg: rgba(15, 23, 42, 0.6); 
            --glass-border: rgba(255, 255, 255, 0.1);
            --glass-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            
            --card-bg: rgba(30, 41, 59, 0.5);
            --card-hover: rgba(30, 41, 59, 0.8);
            
            --aws-cyan: #06b6d4;  
            --aws-purple: #a855f7; 
            --aws-blue: #3b82f6;
        }

        [data-theme="light"] {
            /* --- LIGHT MODE (ORIGINAL) --- */
            --bg-gradient: linear-gradient(90deg, #b975ff 0%, #f8f4ff 35%, #e0fcff 65%, #00d4ff 100%);
            --text-primary: #0f172a;   
            --text-secondary: #475569; 
            
            --glass-bg: rgba(255, 255, 255, 0.6); 
            --glass-border: rgba(255, 255, 255, 0.8);
            --glass-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            
            --card-bg: rgba(255, 255, 255, 0.5);
            --card-hover: rgba(255, 255, 255, 0.9);
            
            --aws-cyan: #06b6d4;  
            --aws-purple: #a855f7; 
            --aws-blue: #2962ff;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-gradient);
            color: var(--text-primary);
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            transition: background 0.4s ease, color 0.4s ease;
        }

        /* Adaptive Utility Classes */
        .text-adaptive { color: var(--text-primary) !important; transition: color 0.3s ease; }
        .text-adaptive-secondary { color: var(--text-secondary) !important; transition: color 0.3s ease; }

        .scroll-progress-bar {
            position: fixed;
            top: 0; left: 0; height: 3px;
            background: var(--aws-blue); width: 0%; z-index: 9999;
            box-shadow: 0 0 10px var(--aws-blue);
            transition: width 0.1s ease-out;
        }

        .navbar-glass {
            background: var(--glass-bg) !important;
            backdrop-filter: saturate(180%) blur(24px);
            -webkit-backdrop-filter: saturate(180%) blur(24px);
            border-bottom: 1px solid var(--glass-border);
            box-shadow: var(--glass-shadow);
            transition: all 0.4s ease;
        }
        
        .nav-link {
            color: var(--text-secondary) !important;
            font-size: 0.85rem; font-weight: 600;
            letter-spacing: 0.02em; padding: 0.5rem 1.5rem !important; transition: color 0.3s ease;
        }
        .nav-link:hover { color: var(--aws-blue) !important; }

        .mono-text { font-family: 'JetBrains Mono', monospace; text-transform: uppercase; letter-spacing: 0.05em; }

        .brand-logo {
            height: 45px; 
            border-radius: 6px; 
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .brand-logo:hover {
            transform: scale(1.05);
            filter: drop-shadow(0 4px 10px rgba(41, 98, 255, 0.3));
        }

        .sleek-logo-text {
            font-family: 'Poiret One', sans-serif;
            font-weight: 700; 
            font-size: 1.5rem; 
            letter-spacing: 0.05em; 
            color: var(--text-primary); 
            margin-left: 10px;
            line-height: 1;
        }

        .btn-cyber {
            background: var(--text-primary); 
            color: var(--glass-bg); border: 1px solid transparent;
            border-radius: 30px; padding: 0.6rem 1.8rem; font-size: 0.85rem; font-weight: 600;
            transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .btn-cyber:hover {
            background: var(--aws-blue);
            color: white; box-shadow: 0 8px 25px rgba(41, 98, 255, 0.3); transform: translateY(-2px);
        }
        
        .theme-toggle-btn {
            background: transparent;
            border: 1px solid var(--glass-border);
            color: var(--text-primary);
            width: 40px; height: 40px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .theme-toggle-btn:hover {
            background: var(--aws-blue);
            color: white;
            border-color: var(--aws-blue);
        }
    </style>
</head>
<body>

<div class="scroll-progress-bar" id="scrollBar"></div>

<nav class="navbar navbar-expand-lg sticky-top navbar-glass py-3">
  <div class="container-fluid px-lg-5">
    
    <!-- 1. Brand & Logo -->
    <a class="navbar-brand d-flex align-items-center gap-1" href="index.jsp">
      <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Omni Mavens Logo" class="brand-logo">
      <span class="sleek-logo-text">Omni Mavens</span>
    </a>

    <!-- 2. Right Side Action Group (Always visible Theme Toggle + Desktop Action Button + Mobile Hamburger) -->
    <div class="d-flex align-items-center gap-3 ms-auto ms-lg-0 order-lg-3">
        <button id="themeToggleBtn" class="theme-toggle-btn" title="Toggle Theme">
            <i class="bi bi-sun-fill" id="themeIcon"></i>
        </button>
        <a href="#contact" class="btn btn-cyber fw-semibold d-none d-lg-inline-flex" style="color: var(--bg-gradient);">
            <i class="bi bi-power fs-5 me-2"></i>Initialize Protocol
        </a>
        <button class="navbar-toggler border-0 shadow-none d-lg-none ms-1" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <i class="bi bi-grid text-adaptive fs-2"></i>
        </button>
    </div>

    <!-- 3. Collapsible Center Navigation -->
    <div class="collapse navbar-collapse justify-content-center order-lg-2" id="navbarNav">
      <ul class="navbar-nav gap-3 align-items-center">
        <li class="nav-item"><a class="nav-link" href="#platform">Platform</a></li>
        <li class="nav-item"><a class="nav-link" href="#stack">Tech Stack</a></li>
        <li class="nav-item"><a class="nav-link" href="#leadership">Leadership</a></li>
        <li class="nav-item">
            <a class="nav-link" href="#" onclick="event.preventDefault(); if(document.getElementById('estimatorModal')){ new bootstrap.Modal(document.getElementById('estimatorModal')).show(); } else { window.location.href='index.jsp'; }">
                Estimator
            </a>
        </li>
      </ul>
    </div>
    
  </div>
</nav>