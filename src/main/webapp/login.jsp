<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    String error = (String) request.getAttribute("error");
    String lastUsername = request.getParameter("username");
%>
<!DOCTYPE html>
<html lang="uz">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kirish — Tartib</title>
    <script>
        (function () {
            try {
                var t = localStorage.getItem('theme');
                if (t) document.documentElement.setAttribute('data-theme', t);
            } catch (e) {}
        })();
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            color-scheme: dark;
            --bg: #070618;
            --card-bg: linear-gradient(160deg, rgba(24, 21, 66, .88) 0%, rgba(11, 10, 34, .95) 100%);
            --input-bg: rgba(16, 15, 46, .86);
            --pill-bg: rgba(24, 20, 62, .78);
            --social-bg: rgba(24, 20, 58, .85);
            --feat-bg: rgba(34, 26, 86, .55);
            --text: #f8f7ff;
            --text-2: #b4afd8;
            --text-3: #837ca8;
            --border: rgba(155, 118, 255, .26);
            --border-glow: rgba(154, 108, 255, .62);
            --accent: #7c3aed;
            --accent-2: #9d5cff;
            --success: #39dc91;
            --danger: #ff6b7a;
            --danger-soft: rgba(255, 92, 117, .14);
            --ring: rgba(145, 76, 255, .28);
        }

        :root[data-theme="light"] {
            color-scheme: light;
            --bg: #eef0ff;
            --card-bg: linear-gradient(160deg, rgba(255, 255, 255, .94) 0%, rgba(242, 240, 255, .95) 100%);
            --input-bg: #ffffff;
            --pill-bg: rgba(255, 255, 255, .86);
            --social-bg: #ffffff;
            --feat-bg: rgba(255, 255, 255, .78);
            --text: #161233;
            --text-2: #555078;
            --text-3: #7f78a3;
            --border: rgba(110, 75, 210, .2);
            --border-glow: rgba(124, 72, 245, .42);
            --accent: #6d28d9;
            --accent-2: #7c3aed;
            --success: #149661;
            --danger: #d12e4f;
            --danger-soft: rgba(209, 46, 79, .1);
            --ring: rgba(110, 52, 240, .18);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { min-height: 100%; }

        body {
            min-height: 100vh;
            font-family: 'Manrope', system-ui, sans-serif;
            color: var(--text);
            background:
                    radial-gradient(55% 45% at 15% 15%, rgba(112, 48, 255, .34), transparent 65%),
                    radial-gradient(50% 50% at 85% 65%, rgba(92, 42, 245, .32), transparent 65%),
                    radial-gradient(35% 35% at 50% 50%, rgba(64, 28, 180, .18), transparent 70%),
                    var(--bg);
            -webkit-font-smoothing: antialiased;
            line-height: 1.5;
            overflow-x: hidden;
            position: relative;
        }

        /* Orqa fon bezagi */
        body::before {
            content: "";
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            background:
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 900' preserveAspectRatio='none'%3E%3Cdefs%3E%3ClinearGradient id='g' x1='0%25' y1='0%25' x2='100%25' y2='100%25'%3E%3Cstop offset='0%25' stop-color='%238b5cf6' stop-opacity='0'/%3E%3Cstop offset='50%25' stop-color='%23a855f7' stop-opacity='0.45'/%3E%3Cstop offset='100%25' stop-color='%236324f2' stop-opacity='0'/%3E%3C/linearGradient%3E%3Cfilter id='b'%3E%3CfeGaussianBlur stdDeviation='10'/%3E%3C/filter%3E%3C/defs%3E%3Cpath d='M-100 720 Q 260 640, 620 880' stroke='url(%23g)' stroke-width='5' fill='none' filter='url(%23b)'/%3E%3Cpath d='M820 880 Q 1120 560, 1520 640' stroke='url(%23g)' stroke-width='6' fill='none' filter='url(%23b)'/%3E%3C/svg%3E") center / cover no-repeat;
        }

        /* Yuqori panel */
        .topbar {
            position: absolute;
            z-index: 10;
            top: 24px;
            left: 3.5%;
            right: 3.5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 11px;
            color: var(--text);
            text-decoration: none;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: -.03em;
        }

        .brand-mark {
            width: 38px;
            height: 38px;
            display: grid;
            place-items: center;
            border-radius: 11px;
            color: #fff;
            background: linear-gradient(140deg, #9d4eff, #5d24ef);
            box-shadow: 0 0 22px rgba(132, 60, 255, .55), inset 0 1px 0 rgba(255, 255, 255, .35);
        }

        /* Tema almashtirish pill tugmasi */
        .theme-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: var(--pill-bg);
            backdrop-filter: blur(14px);
            cursor: pointer;
        }

        .theme-opt {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: grid;
            place-items: center;
            color: var(--text-3);
            transition: .2s;
        }

        .theme-opt.active {
            background: linear-gradient(135deg, #9345ff, #6324f2);
            color: #fff;
            box-shadow: 0 0 14px rgba(135, 65, 255, .6);
        }

        /* Asosiy 3 ustunli tarmoq */
        .page {
            position: relative;
            z-index: 1;
            min-height: 100vh;
            width: min(1560px, 100%);
            margin: 0 auto;
            padding: 90px 3.5% 56px;
            display: grid;
            grid-template-columns: minmax(210px, .72fr) minmax(380px, 1.02fr) minmax(440px, 1.38fr);
            gap: 32px;
            align-items: center;
        }

        /* 1-USTUN: Chap salomlashish */
        .welcome-side {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding-right: 10px;
        }

        .welcome-side h1 {
            font-size: clamp(28px, 2.5vw, 38px);
            line-height: 1.18;
            letter-spacing: -.04em;
            font-weight: 800;
            margin-bottom: 16px;
        }

        .welcome-side p {
            color: var(--text-2);
            font-size: 14.5px;
            max-width: 260px;
            line-height: 1.55;
        }

        /* 2-USTUN: Login kartasi */
        .form-card {
            position: relative;
            padding: 28px 28px 24px;
            border-radius: 24px;
            background: var(--card-bg);
            border: 1px solid var(--border-glow);
            box-shadow:
                    0 0 0 1px rgba(130, 62, 255, .15),
                    0 24px 54px -16px rgba(0, 0, 0, .55),
                    0 0 42px rgba(114, 48, 255, .22),
                    inset 0 1px 0 rgba(255, 255, 255, .12);
            backdrop-filter: blur(18px);
            animation: rise .5s ease both;
        }

        /* Karta ichidagi Tablar */
        .tabs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            padding: 5px;
            margin-bottom: 24px;
            border-radius: 15px;
            background: rgba(15, 13, 42, .65);
            border: 1px solid var(--border);
        }

        :root[data-theme="light"] .tabs { background: rgba(235, 230, 255, .75); }

        .tab {
            height: 40px;
            border-radius: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            color: var(--text-2);
            transition: .2s;
        }

        .tab:hover { color: var(--text); }

        .tab.active {
            color: #fff;
            background: linear-gradient(95deg, #8b42ff, #6528f0);
            box-shadow: 0 4px 16px rgba(124, 58, 237, .45);
        }

        .alert {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            padding: 11px 14px;
            margin-bottom: 18px;
            border-radius: 12px;
            color: var(--danger);
            background: var(--danger-soft);
            border: 1px solid rgba(255, 107, 122, .25);
            font-size: 12.5px;
            font-weight: 700;
            animation: shake .38s ease;
        }

        .field { margin-bottom: 18px; }

        label {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin: 0 0 7px 2px;
            font-size: 12.5px;
            font-weight: 700;
            color: var(--text);
        }

        .input-wrap { position: relative; }

        .input {
            width: 100%;
            height: 46px;
            padding: 0 44px 0 42px;
            border-radius: 13px;
            border: 1px solid var(--border);
            background: var(--input-bg);
            color: var(--text);
            font: inherit;
            font-size: 14px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .input::placeholder { color: var(--text-3); }
        .input:focus { border-color: #a855f7; box-shadow: 0 0 0 3.5px var(--ring); }
        .input.err { border-color: var(--danger); }

        .field-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #a295d6;
            display: grid;
            place-items: center;
            pointer-events: none;
        }

        .valid-badge {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%) scale(.8);
            color: var(--success);
            display: grid;
            place-items: center;
            opacity: 0;
            pointer-events: none;
            transition: .2s;
        }

        .valid-badge.show { opacity: 1; transform: translateY(-50%) scale(1); }

        .eye-btn {
            position: absolute;
            right: 7px;
            top: 50%;
            transform: translateY(-50%);
            width: 34px;
            height: 34px;
            border: 0;
            border-radius: 9px;
            color: #a295d6;
            background: transparent;
            cursor: pointer;
            display: grid;
            place-items: center;
        }

        .eye-btn:hover { background: rgba(155, 95, 255, .14); color: var(--text); }

        .caps {
            display: none;
            font-size: 11.5px;
            color: var(--danger);
            margin: 6px 4px 0;
            font-weight: 700;
        }
        .caps.show { display: block; }

        .btn {
            width: 100%;
            height: 48px;
            margin-top: 6px;
            border: 1px solid rgba(255, 255, 255, .24);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            cursor: pointer;
            color: #fff;
            font: inherit;
            font-size: 14.5px;
            font-weight: 800;
            background: linear-gradient(95deg, #8b42ff 0%, #6d28f0 60%, #5b21d6 100%);
            box-shadow: 0 8px 26px rgba(124, 58, 237, .46), inset 0 1px 0 rgba(255, 255, 255, .3);
            transition: transform .15s, filter .15s;
        }

        .btn:hover { filter: brightness(1.1); transform: translateY(-1px); }
        .btn:active { transform: scale(.985); }
        .btn:disabled { opacity: .75; cursor: progress; }

        .spinner {
            display: none;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255, 255, 255, .4);
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin .7s linear infinite;
        }
        .btn.loading .spinner { display: block; }
        .btn.loading .btn-icon { display: none; }

        .or {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 18px 0 14px;
            color: var(--text-3);
            font-size: 12px;
        }
        .or::before, .or::after { content: ""; height: 1px; flex: 1; background: var(--border); }

        .socials { display: flex; justify-content: center; gap: 14px; }
        .social {
            width: 50px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--social-bg);
            text-decoration: none;
            transition: transform .15s, border-color .2s;
        }
        .social:hover { border-color: var(--border-glow); transform: translateY(-2px); }

        .switch { margin-top: 18px; text-align: center; color: var(--text-2); font-size: 12.5px; }
        .switch a { color: var(--accent-2); font-weight: 800; text-decoration: none; margin-left: 4px; }
        .switch a:hover { text-decoration: underline; }

        /* 3-USTUN: Motivatsiya va 3D-uslubdagi illustratsiya */
        .showcase {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 16px 0 16px 16px;
        }

        .showcase-text { position: relative; z-index: 2; max-width: 340px; }

        .showcase h2 {
            font-size: clamp(26px, 2.3vw, 35px);
            line-height: 1.18;
            letter-spacing: -.04em;
            font-weight: 800;
            margin-bottom: 16px;
        }

        .showcase h2 span { color: var(--accent-2); }

        .showcase-text > p {
            color: var(--text-2);
            font-size: 14px;
            line-height: 1.55;
            margin-bottom: 28px;
        }

        .features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        .feat {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 9px;
        }

        .feat-box {
            width: 50px;
            height: 50px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            color: #d7c3ff;
            background: var(--feat-bg);
            border: 1px solid var(--border);
            box-shadow: 0 8px 20px rgba(0, 0, 0, .24);
        }

        :root[data-theme="light"] .feat-box { color: #6d28d9; }

        .feat span {
            font-size: 11.5px;
            font-weight: 700;
            color: var(--text-2);
            line-height: 1.3;
        }

        /* O'ng chekkadagi planshet va soat bezagi */
        .art {
            position: relative;
            width: 240px;
            height: 310px;
            flex-shrink: 0;
            pointer-events: none;
        }

        .art-glow {
            position: absolute;
            inset: 20px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(124, 58, 237, .48), transparent 70%);
            filter: blur(22px);
        }

        .clipboard {
            position: absolute;
            top: 14px;
            left: 16px;
            width: 176px;
            height: 232px;
            padding: 36px 20px 18px;
            border-radius: 20px;
            transform: rotate(10deg);
            background: linear-gradient(155deg, #6078ff 0%, #5046e5 55%, #3725a8 100%);
            border: 2px solid rgba(190, 208, 255, .65);
            box-shadow: 0 22px 48px rgba(0, 0, 0, .5), 0 0 38px rgba(96, 120, 255, .42);
        }

        .clip {
            position: absolute;
            width: 58px;
            height: 22px;
            top: -11px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 9px 9px 4px 4px;
            background: linear-gradient(90deg, #8ba4ff, #5b52f0);
            border: 2px solid #c9d6ff;
        }

        .check-row { display: flex; align-items: center; gap: 10px; margin: 11px 0 14px; }
        .check {
            width: 24px;
            height: 24px;
            flex-shrink: 0;
            display: grid;
            place-items: center;
            border-radius: 7px;
            background: rgba(255, 255, 255, .92);
            color: #4f46e5;
            font-size: 13px;
            font-weight: 900;
        }
        .lines { display: grid; gap: 5px; flex: 1; }
        .line { height: 5px; border-radius: 99px; background: rgba(255, 255, 255, .36); }
        .line.short { width: 62%; }

        .clock {
            position: absolute;
            right: 6px;
            bottom: 20px;
            width: 132px;
            height: 132px;
            border-radius: 50%;
            border: 7px solid #8b7bff;
            background: radial-gradient(circle at 35% 28%, #2e246e, #0e0c2b 78%);
            box-shadow:
                    0 0 0 2px rgba(215, 205, 255, .65),
                    0 16px 36px rgba(0, 0, 0, .6),
                    0 0 32px rgba(124, 92, 255, .65);
        }

        .clock-ticks { position: absolute; inset: 7px; }
        .clock-hand-h {
            position: absolute;
            left: 50%;
            top: 24px;
            width: 4px;
            height: 36px;
            border-radius: 9px;
            background: #e9ddff;
            transform: translateX(-50%) rotate(-38deg);
            transform-origin: bottom center;
        }
        .clock-hand-m {
            position: absolute;
            left: 50%;
            top: 50%;
            width: 34px;
            height: 4px;
            border-radius: 9px;
            background: #e9ddff;
            transform: translateY(-50%) rotate(-24deg);
            transform-origin: left center;
        }
        .clock-dot {
            position: absolute;
            left: 50%;
            top: 50%;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #fff;
            transform: translate(-50%, -50%);
        }

        .foot {
            position: absolute;
            left: 3.5%;
            bottom: 20px;
            z-index: 5;
            color: var(--text-3);
            font-size: 11.5px;
        }

        @keyframes rise { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: none; } }
        @keyframes spin { to { transform: rotate(360deg); } }
        @keyframes shake { 0%, 100% { transform: none; } 25% { transform: translateX(-5px); } 75% { transform: translateX(5px); } }

        @media (max-width: 1320px) {
            .page { grid-template-columns: minmax(190px, .6fr) minmax(360px, 1fr) minmax(360px, 1.15fr); gap: 22px; }
            .art { display: none; }
        }

        @media (max-width: 1024px) {
            .page { grid-template-columns: minmax(0, 440px); justify-content: center; padding-top: 96px; }
            .welcome-side, .showcase { display: none; }
        }

        @media (max-width: 480px) {
            .form-card { padding: 24px 18px 20px; }
        }
    </style>
</head>
<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/login">
        <span class="brand-mark">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>
        </span>
        Tartib
    </a>

    <button class="theme-pill" type="button" id="themeBtn" aria-label="Mavzuni almashtirish">
        <span class="theme-opt" id="moonOpt">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M21 12.8A9 9 0 1111.2 3a7 7 0 009.8 9.8z"/></svg>
        </span>
        <span class="theme-opt" id="sunOpt">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2m0 16v2M4.93 4.93l1.42 1.42m11.3 11.3 1.42 1.42M2 12h2m16 0h2M4.93 19.07l1.42-1.42m11.3-11.3 1.42-1.42"/></svg>
        </span>
    </button>
</header>

<main class="page">
    <!-- Chap ustun -->
    <section class="welcome-side">
        <h1>Qaytganingizdan<br>xursandmiz! 👋</h1>
        <p>Rejalaringizni davom ettirish uchun hisobingizga kiring.</p>
    </section>

    <!-- Markaziy login kartasi -->
    <section class="form-card">
        <div class="tabs">
            <a class="tab active" href="${pageContext.request.contextPath}/login">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4.5 4.5 0 100-9 4.5 4.5 0 000 9zm0 2c-4.4 0-8 2.2-8 5v2h16v-2c0-2.8-3.6-5-8-5z"/></svg>
                Hisobga kirish
            </a>
            <a class="tab" href="${pageContext.request.contextPath}/register">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><path d="M12 8v8M8 12h8"/></svg>
                Ro'yxatdan o'tish
            </a>
        </div>

        <% if (error != null) { %>
        <div class="alert" role="alert">
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><path d="M12 8v5M12 16.5v.01"/></svg>
            <span><%= esc(error) %></span>
        </div>
        <% } %>

        <form id="authForm" action="${pageContext.request.contextPath}/login" method="post" novalidate>
            <div class="field">
                <label for="username">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4.5 4.5 0 100-9 4.5 4.5 0 000 9zm0 2c-4.4 0-8 2.2-8 5v2h16v-2c0-2.8-3.6-5-8-5z"/></svg>
                    Foydalanuvchi nomi
                </label>
                <div class="input-wrap">
                    <span class="field-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4.5 4.5 0 100-9 4.5 4.5 0 000 9zm0 2c-4.4 0-8 2.2-8 5v2h16v-2c0-2.8-3.6-5-8-5z"/></svg>
                    </span>
                    <input class="input" type="text" id="username" name="username"
                           value="<%= esc(lastUsername) %>"
                           placeholder="masalan, akrom" autocomplete="username" required autofocus>
                    <span class="valid-badge" id="userValidIcon" aria-hidden="true">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M8.5 12.5l2.3 2.3 4.7-5"/></svg>
                    </span>
                </div>
            </div>

            <div class="field">
                <label for="password">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M17 9h-1V7a4 4 0 00-8 0v2H7a2 2 0 00-2 2v9a2 2 0 002 2h10a2 2 0 002-2v-9a2 2 0 00-2-2zM10 7a2 2 0 114 0v2h-4V7z"/></svg>
                    Parol
                </label>
                <div class="input-wrap">
                    <span class="field-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M7 14a2 2 0 110-4 2 2 0 010 4zm5.65-4A6 6 0 107 18a6 6 0 005.65-4H17v3h3v-3h2v-4h-9.35z"/></svg>
                    </span>
                    <input class="input" type="password" id="password" name="password"
                           placeholder="••••••••" autocomplete="current-password" required>
                    <button type="button" class="eye-btn" id="eyeBtn" aria-label="Parolni ko'rsatish">
                        <svg id="eyeIcon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/>
                            <line x1="1" y1="1" x2="23" y2="23"/>
                        </svg>
                    </button>
                </div>
                <div class="caps" id="capsWarn">Caps Lock yoqilgan</div>
            </div>

            <button class="btn" type="submit" id="submitBtn">
                <span class="spinner"></span>
                <svg class="btn-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M10 12h6m-2.5-2.5L16 12l-2.5 2.5"/></svg>
                <span class="btn-text">Kirish</span>
            </button>
        </form>

        <div class="or">yoki</div>
        <div class="socials" aria-label="Ijtimoiy tarmoqlar">
            <a class="social" href="javascript:void(0)" aria-label="Google">
                <svg width="19" height="19" viewBox="0 0 24 24"><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/></svg>
            </a>
            <a class="social" href="javascript:void(0)" aria-label="Telegram">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="#2AABEE"><path d="M21.93 3.24a1.5 1.5 0 00-1.6-.22L2.6 10.48a1.4 1.4 0 00.12 2.63l4.64 1.5 1.77 5.5a1.2 1.2 0 002 .44l2.58-2.54 4.65 3.43a1.4 1.4 0 002.2-.84l2.9-15.86a1.5 1.5 0 00-.53-1.5zM9.6 14.3l8.1-6.9-6.4 8.2-.4 3.1-1.3-4.4z"/></svg>
            </a>
            <a class="social" href="javascript:void(0)" aria-label="GitHub">
                <svg width="19" height="19" viewBox="0 0 24 24" fill="currentColor"><path d="M12 1.5a10.5 10.5 0 00-3.32 20.46c.53.1.72-.23.72-.5v-1.76c-2.92.64-3.54-1.4-3.54-1.4-.48-1.22-1.17-1.54-1.17-1.54-.95-.65.07-.64.07-.64 1.05.08 1.6 1.08 1.6 1.08.94 1.6 2.46 1.14 3.06.87.1-.68.37-1.14.67-1.4-2.33-.27-4.78-1.17-4.78-5.18 0-1.15.41-2.08 1.08-2.82-.11-.27-.47-1.33.1-2.78 0 0 .88-.28 2.89 1.08a10 10 0 015.26 0c2-1.36 2.88-1.08 2.88-1.08.58 1.45.22 2.51.11 2.78.67.74 1.08 1.67 1.08 2.82 0 4.02-2.46 4.91-4.8 5.17.38.32.71.96.71 1.94v2.88c0 .28.19.61.73.5A10.5 10.5 0 0012 1.5z"/></svg>
            </a>
        </div>

        <p class="switch">Hisobingiz yo'qmi? <a href="${pageContext.request.contextPath}/register">Ro'yxatdan o'ting ›</a></p>
    </section>

    <!-- O'ng ustun -->
    <aside class="showcase" aria-hidden="true">
        <div class="showcase-text">
            <h2>Katta maqsadlar<br>kichik qadamlardan<br><span>boshlanadi.</span></h2>
            <p>Bugungi qadamingizni belgilang va o'z ustingizda ishlashni davom ettiring.</p>

            <div class="features">
                <div class="feat">
                    <div class="feat-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M13 2L3 14h7l-1 8 10-12h-7l1-8z"/></svg>
                    </div>
                    <span>Tez va qulay</span>
                </div>
                <div class="feat">
                    <div class="feat-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M5 13h3v7H5v-7zm5.5-4h3v11h-3V9zM16 5h3v15h-3V5z"/></svg>
                    </div>
                    <span>Samarali<br>rejalashtirish</span>
                </div>
                <div class="feat">
                    <div class="feat-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M19 5h-2V3H7v2H5a2 2 0 00-2 2v1a5 5 0 004 4.9A6 6 0 0011 15.9V19H8v2h8v-2h-3v-3.1a6 6 0 004-3A5 5 0 0021 8V7a2 2 0 00-2-2zM5 8V7h2v3.8A3 3 0 015 8zm14 0a3 3 0 01-2 2.8V7h2v1z"/></svg>
                    </div>
                    <span>Muvaffaqiyatga<br>bir qadam</span>
                </div>
            </div>
        </div>

        <div class="art">
            <div class="art-glow"></div>
            <div class="clipboard">
                <div class="clip"></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
            </div>
            <div class="clock">
                <svg class="clock-ticks" viewBox="0 0 100 100" stroke="rgba(220,210,255,.65)" stroke-width="2" stroke-linecap="round">
                    <line x1="50" y1="4" x2="50" y2="11"/><line x1="50" y1="89" x2="50" y2="96"/>
                    <line x1="4" y1="50" x2="11" y2="50"/><line x1="89" y1="50" x2="96" y2="50"/>
                    <line x1="27" y1="10" x2="30" y2="15"/><line x1="73" y1="10" x2="70" y2="15"/>
                    <line x1="10" y1="27" x2="15" y2="30"/><line x1="90" y1="27" x2="85" y2="30"/>
                    <line x1="10" y1="73" x2="15" y2="70"/><line x1="90" y1="73" x2="85" y2="70"/>
                    <line x1="27" y1="90" x2="30" y2="85"/><line x1="73" y1="90" x2="70" y2="85"/>
                </svg>
                <span class="clock-hand-h"></span>
                <span class="clock-hand-m"></span>
                <span class="clock-dot"></span>
            </div>
        </div>
    </aside>
</main>

<div class="foot">© 2026 Tartib. Barcha huquqlar himoyalangan.</div>

<script>
    (function () {
        var form = document.getElementById('authForm');
        var pwd = document.getElementById('password');
        var user = document.getElementById('username');
        var btn = document.getElementById('submitBtn');
        var userValidIcon = document.getElementById('userValidIcon');
        var eyeIcon = document.getElementById('eyeIcon');

        if (user.value) pwd.focus();

        function updateValidIcon() {
            user.classList.remove('err');
            userValidIcon.classList.toggle('show', user.value.trim().length >= 3);
        }
        user.addEventListener('input', updateValidIcon);
        updateValidIcon();

        document.getElementById('eyeBtn').addEventListener('click', function () {
            var show = pwd.type === 'password';
            pwd.type = show ? 'text' : 'password';
            this.setAttribute('aria-label', show ? 'Parolni yashirish' : "Parolni ko'rsatish");
            eyeIcon.innerHTML = show
                ? '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>'
                : '<path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
            pwd.focus();
        });

        pwd.addEventListener('keyup', function (e) {
            if (e.getModifierState) {
                document.getElementById('capsWarn').classList.toggle('show', e.getModifierState('CapsLock'));
            }
        });

        form.addEventListener('submit', function (e) {
            var bad = null;
            [user, pwd].forEach(function (el) {
                if (!el.value.trim()) {
                    el.classList.add('err');
                    bad = bad || el;
                } else {
                    el.classList.remove('err');
                }
            });
            if (bad) { e.preventDefault(); bad.focus(); return; }
            btn.disabled = true;
            btn.classList.add('loading');
            btn.querySelector('.btn-text').textContent = 'Kirishmoqda...';
        });

        // Mavzu (Dark / Light)
        var root = document.documentElement;
        var moonOpt = document.getElementById('moonOpt');
        var sunOpt = document.getElementById('sunOpt');

        function current() { return root.getAttribute('data-theme') || 'dark'; }
        function syncThemeUI() {
            var dark = current() === 'dark';
            moonOpt.classList.toggle('active', dark);
            sunOpt.classList.toggle('active', !dark);
        }
        syncThemeUI();

        document.getElementById('themeBtn').addEventListener('click', function () {
            var next = current() === 'dark' ? 'light' : 'dark';
            root.setAttribute('data-theme', next);
            try { localStorage.setItem('theme', next); } catch (e) {}
            syncThemeUI();
        });
    })();
</script>
</body>
</html>