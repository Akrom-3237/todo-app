<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="uz" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tizimga kirish — TaskOS Enterprise</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <style>
        :root[data-theme="dark"] {
            --bg-base: #050811;
            --bg-surface: rgba(13, 18, 30, 0.78);
            --bg-elevated: rgba(22, 30, 49, 0.75);
            --bg-input: rgba(9, 13, 24, 0.92);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --text-dim: #64748b;
            --border: rgba(255, 255, 255, 0.08);
            --border-strong: rgba(255, 255, 255, 0.16);
            --accent: #6366f1;
            --accent-light: #818cf8;
            --accent-glow: rgba(99, 102, 241, 0.38);
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --shadow: 0 30px 70px -15px rgba(0, 0, 0, 0.8);
        }

        :root[data-theme="light"] {
            --bg-base: #eef2f7;
            --bg-surface: rgba(255, 255, 255, 0.88);
            --bg-elevated: rgba(248, 250, 252, 0.95);
            --bg-input: #ffffff;
            --text-main: #0f172a;
            --text-muted: #475569;
            --text-dim: #94a3b8;
            --border: rgba(15, 23, 42, 0.08);
            --border-strong: rgba(15, 23, 42, 0.16);
            --accent: #4f46e5;
            --accent-light: #6366f1;
            --accent-glow: rgba(79, 70, 229, 0.22);
            --success: #059669;
            --warning: #d97706;
            --danger: #dc2626;
            --shadow: 0 25px 60px -15px rgba(15, 23, 42, 0.12);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-base);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            position: relative;
            overflow-x: hidden;
            background-image:
                    radial-gradient(circle at 12% 18%, rgba(99, 102, 241, 0.20), transparent 42%),
                    radial-gradient(circle at 88% 82%, rgba(16, 185, 129, 0.14), transparent 40%),
                    radial-gradient(circle at 55% 20%, rgba(236, 72, 153, 0.12), transparent 45%),
                    linear-gradient(var(--border) 1px, transparent 1px),
                    linear-gradient(90deg, var(--border) 1px, transparent 1px);
            background-size: 100% 100%, 100% 100%, 100% 100%, 38px 38px, 38px 38px;
        }

        /* Animated Floating Orbs */
        .orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(85px);
            pointer-events: none;
            z-index: 0;
            animation: floatOrb 12s ease-in-out infinite alternate;
        }
        .orb-1 { width: 340px; height: 340px; background: rgba(99, 102, 241, 0.22); top: -80px; left: -60px; }
        .orb-2 { width: 300px; height: 300px; background: rgba(16, 185, 129, 0.16); bottom: -70px; right: -50px; animation-delay: -5s; }

        @keyframes floatOrb {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(35px, 25px) scale(1.08); }
        }

        /* Top Quick Controls */
        .top-bar {
            position: fixed;
            top: 22px;
            right: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
            z-index: 20;
        }

        .pill-btn {
            height: 38px;
            padding: 0 14px;
            border-radius: 11px;
            background: var(--bg-surface);
            backdrop-filter: blur(14px);
            border: 1px solid var(--border-strong);
            color: var(--text-main);
            font-size: 12.5px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: all 0.2s;
        }

        .pill-btn:hover {
            border-color: var(--accent);
            transform: translateY(-1px);
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--success);
            box-shadow: 0 0 10px var(--success);
        }

        /* MAIN SPLIT CONTAINER */
        .auth-wrapper {
            width: 100%;
            max-width: 1120px;
            min-height: 650px;
            background: var(--bg-surface);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--border-strong);
            border-radius: 28px;
            box-shadow: var(--shadow);
            display: grid;
            grid-template-columns: 1.12fr 0.88fr;
            overflow: hidden;
            position: relative;
            z-index: 2;
        }

        @media (max-width: 920px) {
            .auth-wrapper { grid-template-columns: 1fr; max-width: 480px; min-height: auto; }
            .showcase-pane { display: none; }
        }

        /* LEFT SHOWCASE PANE */
        .showcase-pane {
            padding: 44px;
            background: linear-gradient(145deg, rgba(99, 102, 241, 0.14) 0%, rgba(15, 23, 42, 0.4) 55%, rgba(16, 185, 129, 0.10) 100%);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .brand-header {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-logo {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: linear-gradient(135deg, #6366f1, #a855f7, #ec4899);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            box-shadow: 0 10px 22px var(--accent-glow);
        }

        .brand-title {
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .version-badge {
            font-size: 10.5px;
            font-weight: 800;
            padding: 3px 9px;
            border-radius: 99px;
            background: rgba(99, 102, 241, 0.2);
            color: var(--accent-light);
            border: 1px solid rgba(99, 102, 241, 0.35);
        }

        /* Interactive 3D Floating Mockup Cards */
        .mockup-stage {
            margin: 28px 0;
            display: flex;
            flex-direction: column;
            gap: 14px;
            perspective: 1000px;
        }

        .mock-card {
            background: var(--bg-elevated);
            border: 1px solid var(--border-strong);
            border-radius: 18px;
            padding: 16px 18px;
            box-shadow: 0 16px 35px -10px rgba(0, 0, 0, 0.45);
            transition: transform 0.25s ease, border-color 0.25s ease;
        }

        .mock-card:hover {
            border-color: var(--accent);
            transform: translateY(-3px) scale(1.01);
        }

        .mock-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .mock-tag {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 9px;
            border-radius: 7px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .tag-red { background: rgba(239, 68, 68, 0.16); color: #f87171; }
        .tag-indigo { background: rgba(99, 102, 241, 0.16); color: var(--accent-light); }
        .tag-green { background: rgba(16, 185, 129, 0.16); color: #34d399; }

        .mock-task-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13.5px;
            font-weight: 600;
        }

        .mock-check {
            width: 20px;
            height: 20px;
            border-radius: 6px;
            background: var(--success);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            flex-shrink: 0;
        }

        .mock-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .mini-stat-val {
            font-family: 'JetBrains Mono', monospace;
            font-size: 22px;
            font-weight: 800;
            margin-top: 4px;
        }

        .mini-stat-label {
            font-size: 11.5px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .showcase-footer h2 {
            font-size: 22px;
            font-weight: 800;
            line-height: 1.3;
            letter-spacing: -0.4px;
            margin-bottom: 8px;
        }

        .showcase-footer p {
            font-size: 13.5px;
            color: var(--text-muted);
            line-height: 1.55;
        }

        .feature-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 14px;
        }

        .f-chip {
            font-size: 11.5px;
            font-weight: 700;
            padding: 5px 11px;
            border-radius: 8px;
            background: var(--bg-input);
            border: 1px solid var(--border);
            color: var(--text-muted);
        }

        /* RIGHT FORM PANE */
        .form-pane {
            padding: 48px 44px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        @media (max-width: 520px) {
            .form-pane { padding: 34px 24px; }
        }

        .form-header {
            margin-bottom: 28px;
        }

        .welcome-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11.5px;
            font-weight: 700;
            color: var(--accent-light);
            background: rgba(99, 102, 241, 0.14);
            border: 1px solid rgba(99, 102, 241, 0.28);
            padding: 5px 12px;
            border-radius: 99px;
            margin-bottom: 12px;
        }

        .form-header h1 {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.6px;
            margin-bottom: 6px;
        }

        .form-header p {
            font-size: 13.5px;
            color: var(--text-muted);
        }

        /* Error Banner */
        .error-alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 13px 15px;
            border-radius: 14px;
            background: rgba(239, 68, 68, 0.14);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #fca5a5;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 20px;
            animation: shakeError 0.4s ease;
        }

        @keyframes shakeError {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-6px); }
            75% { transform: translateX(6px); }
        }

        /* Form Fields */
        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .field-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .field-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12.5px;
            font-weight: 700;
            color: var(--text-main);
        }

        .caps-warning {
            display: none;
            font-size: 11px;
            color: var(--warning);
            font-weight: 700;
            align-items: center;
            gap: 4px;
        }

        .input-box {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            color: var(--text-dim);
            pointer-events: none;
            transition: color 0.2s;
        }

        .form-input {
            width: 100%;
            padding: 13.5px 42px 13.5px 42px;
            border-radius: 13px;
            border: 1.5px solid var(--border-strong);
            background: var(--bg-input);
            color: var(--text-main);
            font-size: 14px;
            font-family: inherit;
            font-weight: 500;
            outline: none;
            transition: all 0.2s;
        }

        .form-input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 4px var(--accent-glow);
        }

        .form-input:focus + .input-icon,
        .input-box:focus-within .input-icon {
            color: var(--accent-light);
        }

        .eye-btn {
            position: absolute;
            right: 12px;
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 4px;
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }

        .eye-btn:hover {
            color: var(--text-main);
        }

        /* Options Row */
        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12.5px;
            margin-top: -2px;
        }

        .remember-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            color: var(--text-muted);
            font-weight: 600;
            user-select: none;
        }

        .remember-label input {
            accent-color: var(--accent);
            width: 15px;
            height: 15px;
            cursor: pointer;
        }

        .kbd-hint {
            font-family: 'JetBrains Mono', monospace;
            font-size: 11px;
            color: var(--text-dim);
        }

        /* Submit Button */
        .submit-btn {
            margin-top: 4px;
            width: 100%;
            padding: 14px 20px;
            border-radius: 14px;
            border: none;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #ec4899 100%);
            background-size: 200% auto;
            color: white;
            font-size: 14.5px;
            font-weight: 800;
            font-family: inherit;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 12px 28px -6px var(--accent-glow);
            transition: all 0.25s ease;
        }

        .submit-btn:hover {
            background-position: right center;
            transform: translateY(-2px);
            box-shadow: 0 18px 34px -6px var(--accent-glow);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .spinner {
            display: none;
            width: 18px;
            height: 18px;
            border: 2.5px solid rgba(255,255,255,0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 0.7s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Divider & Footer */
        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0 18px;
            color: var(--text-dim);
            font-size: 11.5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .divider::before, .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .switch-card {
            padding: 14px 16px;
            border-radius: 14px;
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
        }

        .switch-card span {
            color: var(--text-muted);
            font-weight: 500;
        }

        .switch-link {
            color: var(--accent-light);
            font-weight: 800;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s;
        }

        .switch-link:hover {
            text-decoration: underline;
            transform: translateX(2px);
        }
    </style>
</head>
<body>

<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<!-- Yuqori tezkor panel -->
<div class="top-bar">
    <div class="pill-btn" style="cursor:default;">
        <span class="status-dot"></span>
        <span>PostgreSQL &amp; Hibernate Ready</span>
    </div>
    <button type="button" class="pill-btn" onclick="toggleTheme()" title="Tungi / Kunduzgi mavzu">
        🌓 Mavzu
    </button>
</div>

<div class="auth-wrapper">
    <!-- CHAP TOMON: INTERAKTIV PRODUCT SHOWCASE -->
    <div class="showcase-pane" id="showcasePane">
        <div class="brand-header">
            <div class="brand-logo">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
            </div>
            <span class="brand-title">TaskOS</span>
            <span class="version-badge">ENTERPRISE 3.0</span>
        </div>

        <!-- 3D Visual Preview Cards -->
        <div class="mockup-stage">
            <div class="mock-card">
                <div class="mock-top">
                    <span class="mock-tag tag-red">🔴 Yuqori (High)</span>
                    <span class="mock-tag tag-indigo">#Backend</span>
                </div>
                <div class="mock-task-row">
                    <div class="mock-check">✓</div>
                    <span>Jakarta EE Servlet &amp; Hibernate ORM integratsiyasi</span>
                </div>
            </div>

            <div class="mock-grid-2">
                <div class="mock-card">
                    <span class="mock-tag tag-green">⏱ Fokus Studiyasi</span>
                    <div class="mini-stat-val">25:00</div>
                    <div class="mini-stat-label">Pomodoro + Ambient Sound</div>
                </div>
                <div class="mock-card">
                    <span class="mock-tag tag-indigo">📊 Kunlik Progress</span>
                    <div class="mini-stat-val">98.4%</div>
                    <div class="mini-stat-label">Kanban &amp; List sinxronizatsiya</div>
                </div>
            </div>
        </div>

        <div class="showcase-footer">
            <h2>Dasturchilar va jamoalar uchun keyingi avlod ish stoli.</h2>
            <p>Vazifalaringizni muhimlik darajasi, kategoriyalar va Kanban doskasi orqali maksimal tezlikda boshqaring.</p>
            <div class="feature-chips">
                <span class="f-chip">⚡ Ctrl + K Command Palette</span>
                <span class="f-chip">⊞ Kanban Board</span>
                <span class="f-chip">🎧 Ambient Focus</span>
                <span class="f-chip">⬇ CSV Eksport</span>
            </div>
        </div>
    </div>

    <!-- O'NG TOMON: LOGIN FORMASI -->
    <div class="form-pane">
        <div class="form-header">
            <div class="welcome-badge">🔐 Xavfsiz autentifikatsiya</div>
            <h1>Xush kelibsiz! 👋</h1>
            <p>Shaxsiy TaskOS ish stolingizga kirish uchun ma'lumotlarni kiriting</p>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
        <div class="error-alert">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24" style="flex-shrink:0;">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
            </svg>
            <span><%= error %></span>
        </div>
        <% } %>

        <form class="auth-form" id="loginForm" action="${pageContext.request.contextPath}/login" method="post" onsubmit="handleLoginSubmit()">
            <!-- Username -->
            <div class="field-group">
                <label class="field-label" for="usernameInput">
                    <span>Username (Foydalanuvchi nomi)</span>
                </label>
                <div class="input-box">
                    <svg class="input-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    <input type="text" id="usernameInput" name="username" class="form-input"
                           placeholder="Masalan: akrom_dev" required autocomplete="username" autofocus>
                </div>
            </div>

            <!-- Password -->
            <div class="field-group">
                <label class="field-label" for="passwordInput">
                    <span>Parol</span>
                    <span class="caps-warning" id="capsWarning">⚠ Caps Lock yoqilgan</span>
                </label>
                <div class="input-box">
                    <svg class="input-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                    <input type="password" id="passwordInput" name="password" class="form-input"
                           placeholder="••••••••" required autocomplete="current-password">
                    <button type="button" class="eye-btn" onclick="togglePassword()" title="Parolni ko'rsatish">
                        <svg id="eyeIcon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Remember me & Shortcut -->
            <div class="form-options">
                <label class="remember-label">
                    <input type="checkbox" id="rememberMe" checked>
                    <span>Username eslab qolinsin</span>
                </label>
                <span class="kbd-hint">Enter ↵</span>
            </div>

            <!-- Submit -->
            <button type="submit" class="submit-btn" id="submitBtn">
                <div class="spinner" id="btnSpinner"></div>
                <span id="btnText">Ish stoliga kirish →</span>
            </button>
        </form>

        <div class="divider">YOKI</div>

        <div class="switch-card">
            <span>Hali akkauntingiz yo'qmi?</span>
            <a href="${pageContext.request.contextPath}/register" class="switch-link">
                Ro'yxatdan o'tish →
            </a>
        </div>
    </div>
</div>

<script>
    // 1. Dark / Light Mode sinxronizatsiyasi (todos.jsp bilan bir xil kalitda)
    const savedTheme = localStorage.getItem('taskos_theme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);

    function toggleTheme() {
        const next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        localStorage.setItem('taskos_theme', next);
    }

    // 2. Parolni ko'rsatish / yashirish
    function togglePassword() {
        const passInput = document.getElementById('passwordInput');
        const isPass = passInput.type === 'password';
        passInput.type = isPass ? 'text' : 'password';
    }

    // 3. Caps Lock detektori
    const passField = document.getElementById('passwordInput');
    const capsWarn = document.getElementById('capsWarning');

    passField.addEventListener('keyup', (e) => {
        if (e.getModifierState && e.getModifierState('CapsLock')) {
            capsWarn.style.display = 'inline-flex';
        } else {
            capsWarn.style.display = 'none';
        }
    });

    // 4. "Username eslab qolinsin" (localStorage orqali)
    const userField = document.getElementById('usernameInput');
    const rememberBox = document.getElementById('rememberMe');
    const savedUser = localStorage.getItem('taskos_remembered_user');

    if (savedUser) {
        userField.value = savedUser;
        passField.focus();
    }

    // 5. Submit animatsiyasi
    function handleLoginSubmit() {
        if (rememberBox.checked) {
            localStorage.setItem('taskos_remembered_user', userField.value.trim());
        } else {
            localStorage.removeItem('taskos_remembered_user');
        }
        document.getElementById('btnSpinner').style.display = 'block';
        document.getElementById('btnText').innerText = 'Tekshirilmoqda...';
    }
</script>

</body>
</html>