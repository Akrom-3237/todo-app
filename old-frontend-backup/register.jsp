<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="uz" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ro'yxatdan o'tish — TaskOS Enterprise</title>
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
                    radial-gradient(circle at 85% 15%, rgba(99, 102, 241, 0.20), transparent 42%),
                    radial-gradient(circle at 15% 85%, rgba(16, 185, 129, 0.14), transparent 40%),
                    radial-gradient(circle at 45% 25%, rgba(236, 72, 153, 0.12), transparent 45%),
                    linear-gradient(var(--border) 1px, transparent 1px),
                    linear-gradient(90deg, var(--border) 1px, transparent 1px);
            background-size: 100% 100%, 100% 100%, 100% 100%, 38px 38px, 38px 38px;
        }

        .orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(85px);
            pointer-events: none;
            z-index: 0;
            animation: floatOrb 12s ease-in-out infinite alternate;
        }
        .orb-1 { width: 340px; height: 340px; background: rgba(168, 85, 247, 0.20); top: -80px; right: -60px; }
        .orb-2 { width: 300px; height: 300px; background: rgba(16, 185, 129, 0.16); bottom: -70px; left: -50px; animation-delay: -5s; }

        @keyframes floatOrb {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(-30px, 25px) scale(1.08); }
        }

        /* Top Bar */
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
            max-width: 1140px;
            min-height: 680px;
            background: var(--bg-surface);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--border-strong);
            border-radius: 28px;
            box-shadow: var(--shadow);
            display: grid;
            grid-template-columns: 1.08fr 0.92fr;
            overflow: hidden;
            position: relative;
            z-index: 2;
        }

        @media (max-width: 920px) {
            .auth-wrapper { grid-template-columns: 1fr; max-width: 490px; min-height: auto; }
            .showcase-pane { display: none; }
        }

        /* LEFT SHOWCASE PANE (LIVE INTERACTIVE PROFILE PREVIEW) */
        .showcase-pane {
            padding: 44px;
            background: linear-gradient(145deg, rgba(16, 185, 129, 0.12) 0%, rgba(15, 23, 42, 0.45) 50%, rgba(99, 102, 241, 0.15) 100%);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
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
            background: rgba(16, 185, 129, 0.18);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.35);
        }

        /* Live Preview Card */
        .preview-stage {
            margin: 24px 0;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .live-badge-card {
            background: var(--bg-elevated);
            border: 1px solid var(--border-strong);
            border-radius: 22px;
            padding: 22px;
            box-shadow: 0 20px 40px -15px rgba(0, 0, 0, 0.5);
            position: relative;
            overflow: hidden;
        }

        .live-badge-card::before {
            content: "LIVE WORKSPACE ID";
            position: absolute;
            top: 14px;
            right: 18px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1px;
            color: var(--accent-light);
            opacity: 0.8;
        }

        .live-user-row {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .live-avatar {
            width: 58px;
            height: 58px;
            border-radius: 16px;
            background: linear-gradient(135deg, #6366f1, #ec4899);
            color: white;
            font-size: 24px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 24px rgba(236, 72, 153, 0.3);
            flex-shrink: 0;
            transition: transform 0.2s ease;
        }

        .live-user-info h3 {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -0.3px;
        }

        .live-user-info p {
            font-family: 'JetBrains Mono', monospace;
            font-size: 12.5px;
            color: var(--accent-light);
            margin-top: 2px;
        }

        .live-perks {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            padding-top: 14px;
            border-top: 1px solid var(--border);
        }

        .perk-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
        }

        .perk-check {
            width: 18px;
            height: 18px;
            border-radius: 6px;
            background: rgba(16, 185, 129, 0.18);
            color: #34d399;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 800;
        }

        /* Checklist steps */
        .onboarding-steps {
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 16px 18px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .step-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12.5px;
            font-weight: 600;
            color: var(--text-muted);
        }

        .step-row.done {
            color: var(--text-main);
        }

        .step-pill {
            font-family: 'JetBrains Mono', monospace;
            font-size: 10.5px;
            padding: 2px 8px;
            border-radius: 6px;
            background: var(--bg-input);
            border: 1px solid var(--border);
        }

        .step-row.done .step-pill {
            background: rgba(16, 185, 129, 0.18);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.35);
        }

        .showcase-footer h2 {
            font-size: 21px;
            font-weight: 800;
            line-height: 1.3;
            margin-bottom: 6px;
        }

        .showcase-footer p {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.5;
        }

        /* RIGHT FORM PANE */
        .form-pane {
            padding: 42px 44px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        @media (max-width: 520px) {
            .form-pane { padding: 32px 22px; }
        }

        .form-header {
            margin-bottom: 22px;
        }

        .welcome-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11.5px;
            font-weight: 700;
            color: #34d399;
            background: rgba(16, 185, 129, 0.14);
            border: 1px solid rgba(16, 185, 129, 0.3);
            padding: 5px 12px;
            border-radius: 99px;
            margin-bottom: 10px;
        }

        .form-header h1 {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.6px;
            margin-bottom: 5px;
        }

        .form-header p {
            font-size: 13.5px;
            color: var(--text-muted);
        }

        .error-alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 14px;
            border-radius: 13px;
            background: rgba(239, 68, 68, 0.14);
            border: 1px solid rgba(239, 68, 68, 0.35);
            color: #fca5a5;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 18px;
        }

        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .field-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .field-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12.5px;
            font-weight: 700;
            color: var(--text-main);
        }

        .auto-gen-btn {
            background: transparent;
            border: none;
            color: var(--accent-light);
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
        }

        .auto-gen-btn:hover {
            text-decoration: underline;
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
            padding: 13px 40px 13px 42px;
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .eye-btn:hover { color: var(--text-main); }

        /* Password Strength Meter */
        .strength-box {
            margin-top: 4px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .strength-bars {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 6px;
        }

        .s-bar {
            height: 5px;
            border-radius: 99px;
            background: var(--border-strong);
            transition: background-color 0.25s ease;
        }

        .strength-meta {
            display: flex;
            justify-content: space-between;
            font-size: 11px;
            color: var(--text-dim);
            font-weight: 600;
        }

        .submit-btn {
            margin-top: 6px;
            width: 100%;
            padding: 14px 20px;
            border-radius: 14px;
            border: none;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #10b981 100%);
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

        @keyframes spin { to { transform: rotate(360deg); } }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0 16px;
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
            padding: 13px 16px;
            border-radius: 14px;
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
        }

        .switch-card span { color: var(--text-muted); font-weight: 500; }

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

<div class="top-bar">
    <div class="pill-btn" style="cursor:default;">
        <span class="status-dot"></span>
        <span>Workspace Provisioning Active</span>
    </div>
    <button type="button" class="pill-btn" onclick="toggleTheme()" title="Tungi / Kunduzgi mavzu">
        🌓 Mavzu
    </button>
</div>

<div class="auth-wrapper">
    <!-- CHAP VITRINA: JONLI PROFIL PREVIEW VA ONBOARDING -->
    <div class="showcase-pane">
        <div class="brand-header">
            <div class="brand-logo">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
            </div>
            <span class="brand-title">TaskOS</span>
            <span class="version-badge">PRO ONBOARDING</span>
        </div>

        <div class="preview-stage">
            <!-- Real-time interactive ID card -->
            <div class="live-badge-card">
                <div class="live-user-row">
                    <div class="live-avatar" id="previewAvatar">A</div>
                    <div class="live-user-info">
                        <h3 id="previewName">Sizning Ismingiz</h3>
                        <p id="previewHandle">@username_workspace</p>
                    </div>
                </div>
                <div class="live-perks">
                    <div class="perk-item"><span class="perk-check">✓</span> Kanban &amp; List</div>
                    <div class="perk-item"><span class="perk-check">✓</span> Pomodoro Studio</div>
                    <div class="perk-item"><span class="perk-check">✓</span> PostgreSQL Sync</div>
                    <div class="perk-item"><span class="perk-check">✓</span> CSV Eksport</div>
                </div>
            </div>

            <!-- Interactive Checklist -->
            <div class="onboarding-steps">
                <div class="step-row" id="stepName">
                    <span>1. To'liq ism-sharifni kiritish</span>
                    <span class="step-pill" id="pillName">Kutilmoqda</span>
                </div>
                <div class="step-row" id="stepUser">
                    <span>2. Unikal username tanlash</span>
                    <span class="step-pill" id="pillUser">Kutilmoqda</span>
                </div>
                <div class="step-row" id="stepPass">
                    <span>3. Xavfsiz parol o'rnatish</span>
                    <span class="step-pill" id="pillPass">Kutilmoqda</span>
                </div>
            </div>
        </div>

        <div class="showcase-footer">
            <h2>30 soniyada shaxsiy Enterprise ish stolingizni yarating.</h2>
            <p>Ma'lumotlaringizni o'ng tomondagi formaga yozishingiz bilan shaxsiy TaskOS profilingiz jonli shakllanadi.</p>
        </div>
    </div>

    <!-- O'NG TOMON: REGISTER FORMASI -->
    <div class="form-pane">
        <div class="form-header">
            <div class="welcome-badge">🚀 Yangi Workspace yaratish</div>
            <h1>Ro'yxatdan o'tish</h1>
            <p>TaskOS tizimida yangi hisob ochish uchun quyidagi maydonlarni to'ldiring</p>
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

        <form class="auth-form" action="${pageContext.request.contextPath}/register" method="post" onsubmit="handleRegisterSubmit()">
            <!-- Full Name -->
            <div class="field-group">
                <label class="field-label" for="fullNameInput">
                    <span>To'liq ismingiz (Full Name)</span>
                </label>
                <div class="input-box">
                    <svg class="input-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <input type="text" id="fullNameInput" name="fullName" class="form-input"
                           placeholder="Masalan: Akrom Shomurodov" required autocomplete="name" autofocus
                           oninput="updateLivePreview()">
                </div>
            </div>

            <!-- Username -->
            <div class="field-group">
                <label class="field-label" for="usernameInput">
                    <span>Username (Login)</span>
                    <button type="button" class="auto-gen-btn" onclick="generateUsername()">⚡ Ismdan yaratish</button>
                </label>
                <div class="input-box">
                    <svg class="input-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"/>
                    </svg>
                    <input type="text" id="usernameInput" name="username" class="form-input"
                           placeholder="Masalan: akrom_dev" required autocomplete="username"
                           oninput="updateLivePreview()">
                </div>
            </div>

            <!-- Password + Strength Meter -->
            <div class="field-group">
                <label class="field-label" for="passwordInput">
                    <span>Parol</span>
                </label>
                <div class="input-box">
                    <svg class="input-icon" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                    <input type="password" id="passwordInput" name="password" class="form-input"
                           placeholder="Kamida 6 ta belgi..." required autocomplete="new-password"
                           oninput="evaluatePassword()">
                    <button type="button" class="eye-btn" onclick="togglePassword()" title="Parolni ko'rsatish">
                        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                    </button>
                </div>

                <!-- 4-Segment Password Strength Bar -->
                <div class="strength-box">
                    <div class="strength-bars">
                        <div class="s-bar" id="bar1"></div>
                        <div class="s-bar" id="bar2"></div>
                        <div class="s-bar" id="bar3"></div>
                        <div class="s-bar" id="bar4"></div>
                    </div>
                    <div class="strength-meta">
                        <span id="strengthText">Parol kiritilmagan</span>
                        <span>Harf + Raqam tavsiya etiladi</span>
                    </div>
                </div>
            </div>

            <button type="submit" class="submit-btn">
                <div class="spinner" id="btnSpinner"></div>
                <span id="btnText">Hisob yaratish va boshlash →</span>
            </button>
        </form>

        <div class="divider">YOKI</div>

        <div class="switch-card">
            <span>Allaqachon hisobingiz bormi?</span>
            <a href="${pageContext.request.contextPath}/login" class="switch-link">
                Tizimga kirish →
            </a>
        </div>
    </div>
</div>

<script>
    // 1. Mavzu (Dark/Light) sinxronizatsiyasi
    const savedTheme = localStorage.getItem('taskos_theme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);

    function toggleTheme() {
        const next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        localStorage.setItem('taskos_theme', next);
    }

    // 2. Jonli Profil Kartasi va Onboarding qadamlarini yangilash
    function updateLivePreview() {
        const fullName = document.getElementById('fullNameInput').value.trim();
        const username = document.getElementById('usernameInput').value.trim();

        document.getElementById('previewName').innerText = fullName || 'Sizning Ismingiz';
        document.getElementById('previewAvatar').innerText = (fullName || username || 'A').substring(0, 1).toUpperCase();
        document.getElementById('previewHandle').innerText = '@' + (username || 'username_workspace');

        // 1-qadam tekshiruvi
        const stepName = document.getElementById('stepName');
        const pillName = document.getElementById('pillName');
        if (fullName.length >= 2) {
            stepName.classList.add('done');
            pillName.innerText = '✓ Tayyor';
        } else {
            stepName.classList.remove('done');
            pillName.innerText = 'Kutilmoqda';
        }

        // 2-qadam tekshiruvi
        const stepUser = document.getElementById('stepUser');
        const pillUser = document.getElementById('pillUser');
        if (username.length >= 3) {
            stepUser.classList.add('done');
            pillUser.innerText = '✓ Tayyor';
        } else {
            stepUser.classList.remove('done');
            pillUser.innerText = 'Kutilmoqda';
        }
    }

    // 3. Ismdan avtomatik chiroyli username yasash
    function generateUsername() {
        const fullName = document.getElementById('fullNameInput').value.trim();
        if (!fullName) {
            document.getElementById('fullNameInput').focus();
            return;
        }
        const slug = fullName.toLowerCase()
            .replace(/[^a-z0-9\s]/g, '')
            .trim()
            .replace(/\s+/g, '_');
        document.getElementById('usernameInput').value = slug || 'user_dev';
        updateLivePreview();
    }

    // 4. Parol kuchliligini hisoblash (4 bosqichli indikator)
    function evaluatePassword() {
        const val = document.getElementById('passwordInput').value;
        let score = 0;
        if (val.length >= 4) score++;
        if (val.length >= 7) score++;
        if (/[0-9]/.test(val) && /[a-zA-Z]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val) || val.length >= 10) score++;

        const colors = ['#ef4444', '#f59e0b', '#3b82f6', '#10b981'];
        const labels = ['Parol kiritilmagan', 'Zaif parol', 'O\'rtacha parol', 'Yaxshi parol', 'Mukammal parol 🔒'];

        for (let i = 1; i <= 4; i++) {
            const bar = document.getElementById('bar' + i);
            bar.style.backgroundColor = (i <= score) ? colors[score - 1] : 'var(--border-strong)';
        }

        const txt = document.getElementById('strengthText');
        txt.innerText = labels[score];
        txt.style.color = score > 0 ? colors[score - 1] : 'var(--text-dim)';

        const stepPass = document.getElementById('stepPass');
        const pillPass = document.getElementById('pillPass');
        if (val.length >= 4) {
            stepPass.classList.add('done');
            pillPass.innerText = '✓ Tayyor';
        } else {
            stepPass.classList.remove('done');
            pillPass.innerText = 'Kutilmoqda';
        }
    }

    // 5. Parolni ko'rsatish / yashirish
    function togglePassword() {
        const input = document.getElementById('passwordInput');
        input.type = input.type === 'password' ? 'text' : 'password';
    }

    // 6. Yuborish animatsiyasi
    function handleRegisterSubmit() {
        const username = document.getElementById('usernameInput').value.trim();
        if (username) {
            localStorage.setItem('taskos_remembered_user', username);
        }
        document.getElementById('btnSpinner').style.display = 'block';
        document.getElementById('btnText').innerText = 'Workspace yaratilmoqda...';
    }
</script>

</body>
</html>