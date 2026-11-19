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
    String oldFullName = request.getParameter("fullName");
    String oldUsername = request.getParameter("username");
%>
<!DOCTYPE html>
<html lang="uz">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ro'yxatdan o'tish — Tartib</title>
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
            --bg: #060514;
            --card-bg: linear-gradient(160deg, rgba(28, 22, 72, .88) 0%, rgba(11, 10, 34, .95) 100%);
            --showcase-bg: radial-gradient(circle at 82% 48%, rgba(135, 62, 255, .36), transparent 46%),
            linear-gradient(150deg, rgba(34, 21, 96, .9) 0%, rgba(11, 10, 38, .96) 72%);
            --input-bg: rgba(17, 15, 48, .85);
            --pill-bg: rgba(24, 20, 60, .75);
            --social-bg: rgba(24, 20, 58, .85);
            --benefits-bg: rgba(34, 24, 92, .48);
            --text: #f8f7ff;
            --text-2: #b4afd8;
            --text-3: #837ca8;
            --border: rgba(155, 118, 255, .28);
            --border-glow: rgba(164, 112, 255, .68);
            --accent: #8238ff;
            --accent-2: #a855f7;
            --success: #39dc91;
            --danger: #ff6b7a;
            --danger-soft: rgba(255, 92, 117, .14);
            --ring: rgba(145, 76, 255, .26);
        }

        :root[data-theme="light"] {
            color-scheme: light;
            --bg: #f2efff;
            --card-bg: linear-gradient(160deg, rgba(255, 255, 255, .96) 0%, rgba(244, 239, 255, .96) 100%);
            --showcase-bg: radial-gradient(circle at 82% 48%, rgba(135, 62, 255, .14), transparent 48%),
            linear-gradient(150deg, rgba(255, 255, 255, .96) 0%, rgba(238, 231, 255, .96) 72%);
            --input-bg: #ffffff;
            --pill-bg: rgba(255, 255, 255, .88);
            --social-bg: #ffffff;
            --benefits-bg: rgba(255, 255, 255, .78);
            --text: #161233;
            --text-2: #5b547d;
            --text-3: #7f78a3;
            --border: rgba(110, 75, 210, .22);
            --border-glow: rgba(124, 72, 245, .45);
            --accent: #6d28d9;
            --accent-2: #8b3dff;
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
                    radial-gradient(60% 45% at 12% 10%, rgba(124, 52, 255, .36), transparent 65%),
                    radial-gradient(50% 45% at 88% 85%, rgba(108, 38, 255, .32), transparent 65%),
                    radial-gradient(35% 35% at 50% 50%, rgba(76, 29, 196, .18), transparent 70%),
                    var(--bg);
            -webkit-font-smoothing: antialiased;
            line-height: 1.5;
            overflow-x: hidden;
            position: relative;
        }

        /* Orqa fondagi neon to'lqinlar va yorug'lik nurlari */
        body::before {
            content: "";
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            background:
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 900' preserveAspectRatio='none'%3E%3Cdefs%3E%3ClinearGradient id='g1' x1='0%25' y1='0%25' x2='100%25' y2='100%25'%3E%3Cstop offset='0%25' stop-color='%239b4dff' stop-opacity='0'/%3E%3Cstop offset='50%25' stop-color='%23a855f7' stop-opacity='0.55'/%3E%3Cstop offset='100%25' stop-color='%236324f2' stop-opacity='0'/%3E%3C/linearGradient%3E%3Cfilter id='blur'%3E%3CfeGaussianBlur stdDeviation='8'/%3E%3C/filter%3E%3C/defs%3E%3Cpath d='M-100 680 Q 220 790, 520 920' stroke='url(%23g1)' stroke-width='4' fill='none' filter='url(%23blur)'/%3E%3Cpath d='M-80 650 Q 240 770, 560 910' stroke='url(%23g1)' stroke-width='1.5' fill='none'/%3E%3Cpath d='M900 -50 Q 1180 280, 1520 420' stroke='url(%23g1)' stroke-width='6' fill='none' filter='url(%23blur)'/%3E%3Cpath d='M1050 920 Q 1260 660, 1520 520' stroke='url(%23g1)' stroke-width='5' fill='none' filter='url(%23blur)'/%3E%3C/svg%3E") center / cover no-repeat;
        }

        /* Mayda porlovchi nuqtalar (yulduzcha effekti) */
        body::after {
            content: "";
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            opacity: .45;
            background-image:
                    radial-gradient(1.5px 1.5px at 14% 26%, rgba(210, 185, 255, .9), transparent),
                    radial-gradient(1px 1px at 32% 14%, rgba(255, 255, 255, .7), transparent),
                    radial-gradient(2px 2px at 48% 82%, rgba(168, 85, 247, .85), transparent),
                    radial-gradient(1.5px 1.5px at 74% 18%, rgba(220, 200, 255, .8), transparent),
                    radial-gradient(1px 1px at 86% 64%, rgba(255, 255, 255, .75), transparent),
                    radial-gradient(1.5px 1.5px at 22% 76%, rgba(180, 130, 255, .8), transparent);
        }

        :root[data-theme="light"] body::before,
        :root[data-theme="light"] body::after {
            opacity: .18;
        }

        /* Yuqori panel */
        .topbar {
            position: absolute;
            z-index: 10;
            top: 22px;
            left: 3%;
            right: 3%;
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
            width: 40px;
            height: 40px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            color: #fff;
            background: linear-gradient(140deg, #9f4dff, #6324f2);
            box-shadow: 0 0 24px rgba(132, 60, 255, .52), inset 0 1px 0 rgba(255, 255, 255, .35);
        }

        .top-actions { display: flex; align-items: center; gap: 12px; }

        .theme-btn, .profile {
            border: 1px solid var(--border);
            background: var(--pill-bg);
            color: var(--text);
            backdrop-filter: blur(14px);
            cursor: pointer;
            transition: border-color .2s;
        }

        .theme-btn:hover, .profile:hover { border-color: var(--border-glow); }

        .theme-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: grid;
            place-items: center;
        }

        .profile {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 5px 14px 5px 6px;
            border-radius: 999px;
            font-size: 12.5px;
            font-weight: 700;
        }

        .avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, #b15cff, #5d29e8);
            color: #fff;
            font-size: 13px;
            font-weight: 800;
        }

        /* Asosiy 3 ustunli tarmoq */
        .page {
            position: relative;
            z-index: 1;
            min-height: 100vh;
            width: min(1560px, 100%);
            margin: 0 auto;
            padding: 86px 3% 44px;
            display: grid;
            grid-template-columns: minmax(195px, .62fr) minmax(390px, 1.05fr) minmax(490px, 1.48fr);
            gap: 24px;
            align-items: center;
        }

        /* 1-USTUN: Iqtibos va kitoblar */
        .quote-side {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 580px;
            padding: 28px 0 10px;
            position: relative;
        }

        .quote-mark {
            font-size: 56px;
            line-height: .7;
            font-weight: 800;
            color: #9e47ff;
            margin-bottom: 16px;
        }

        .quote-side h2 {
            max-width: 240px;
            font-size: clamp(20px, 1.7vw, 25px);
            line-height: 1.3;
            letter-spacing: -.03em;
            font-weight: 800;
        }

        .quote-side p {
            color: var(--text-2);
            margin-top: 18px;
            font-size: 14px;
            max-width: 210px;
        }

        .books-scene {
            position: relative;
            margin-top: 90px;
            width: 220px;
        }

        .books-scene::after {
            content: "";
            position: absolute;
            left: -40px;
            right: -30px;
            bottom: -14px;
            height: 2px;
            background: linear-gradient(90deg, transparent, rgba(168, 85, 247, .85), transparent);
            box-shadow: 0 0 18px rgba(155, 72, 255, .9);
            transform: rotate(10deg);
        }

        .pencil-cup {
            position: absolute;
            left: 14px;
            bottom: 118px;
            width: 52px;
            height: 68px;
            border-radius: 6px 6px 8px 8px;
            border: 1.5px solid rgba(176, 128, 255, .7);
            background: linear-gradient(120deg, #1d1646, #3e257d 70%, #161136);
            box-shadow: 0 8px 20px rgba(0, 0, 0, .45), inset 0 1px 0 rgba(255, 255, 255, .25);
            z-index: 2;
        }

        .pencil-cup::before {
            content: "";
            position: absolute;
            left: 11px;
            top: -34px;
            width: 5px;
            height: 40px;
            border-radius: 4px;
            background: linear-gradient(180deg, #e3d0ff, #8a56ff);
            transform: rotate(-14deg);
            box-shadow: 13px 2px 0 #9f6bff, 25px -3px 0 #d5beff;
        }

        .book {
            position: relative;
            height: 36px;
            margin-top: 5px;
            padding: 0 16px;
            display: flex;
            align-items: center;
            border-radius: 6px 10px 10px 6px;
            color: #d6c8ff;
            font-size: 13.5px;
            font-weight: 700;
            background: linear-gradient(90deg, #1b1644, #32246e 72%, #151133);
            border-left: 5px solid #9652ff;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .14), 0 6px 14px rgba(0, 0, 0, .45);
        }

        .book:nth-of-type(2) { width: 92%; margin-left: 6px; }
        .book:nth-of-type(3) { width: 86%; margin-left: 2px; }

        /* 2-USTUN: Forma kartasi */
        .form-card {
            position: relative;
            padding: 32px 32px 26px;
            border-radius: 24px;
            background: var(--card-bg);
            border: 1px solid var(--border-glow);
            box-shadow:
                    0 0 0 1px rgba(130, 62, 255, .15),
                    0 0 46px rgba(114, 48, 255, .24),
                    inset 0 1px 0 rgba(255, 255, 255, .14);
            animation: rise .5s ease both;
        }

        .form-card::before {
            content: "";
            position: absolute;
            inset: 0;
            border-radius: inherit;
            pointer-events: none;
            background: radial-gradient(340px 140px at 50% 0%, rgba(154, 76, 255, .2), transparent 72%);
        }

        .form-card > * { position: relative; }

        .plus-icon {
            width: 50px;
            height: 50px;
            margin: -6px auto 14px;
            border-radius: 15px;
            display: grid;
            place-items: center;
            color: #fff;
            background: linear-gradient(145deg, #a34cff, #5e22ec);
            box-shadow: 0 0 26px rgba(145, 62, 255, .68), inset 0 1px 0 rgba(255, 255, 255, .4);
        }

        h1 {
            text-align: center;
            font-size: clamp(26px, 2.2vw, 33px);
            line-height: 1.2;
            letter-spacing: -.04em;
            font-weight: 800;
        }

        h1 span { color: var(--accent-2); }

        .subtitle {
            text-align: center;
            color: var(--text-2);
            font-size: 13px;
            margin: 6px 0 24px;
        }

        .alert {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            padding: 11px 14px;
            margin-bottom: 16px;
            border-radius: 12px;
            color: var(--danger);
            background: var(--danger-soft);
            border: 1px solid rgba(255, 107, 122, .25);
            font-size: 12.5px;
            font-weight: 700;
        }

        .field { margin-bottom: 16px; }

        label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 7px 2px;
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
        }

        label svg { color: var(--text); opacity: .9; }

        .input-wrap { position: relative; }

        .input {
            width: 100%;
            height: 48px;
            padding: 0 46px 0 44px;
            border-radius: 14px;
            border: 1px solid var(--border);
            background: var(--input-bg);
            color: var(--text);
            font: inherit;
            font-size: 14px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .input.no-left-icon { padding-left: 16px; }
        .input::placeholder { color: var(--text-3); }
        .input:focus { border-color: #a855f7; box-shadow: 0 0 0 3.5px var(--ring); }
        .input.err { border-color: var(--danger); }

        .field-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #9e8fd0;
            display: grid;
            place-items: center;
            pointer-events: none;
        }

        .valid-badge {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%) scale(.8);
            color: var(--success);
            display: grid;
            place-items: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity .2s, transform .2s;
        }

        .valid-badge.show { opacity: 1; transform: translateY(-50%) scale(1); }

        .eye-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            width: 34px;
            height: 34px;
            border: 0;
            border-radius: 10px;
            color: #a799d8;
            background: transparent;
            cursor: pointer;
            display: grid;
            place-items: center;
        }

        .eye-btn:hover { background: rgba(155, 95, 255, .14); color: var(--text); }

        .msg {
            min-height: 16px;
            margin: 5px 4px 0;
            font-size: 11.5px;
            font-weight: 600;
            color: var(--text-3);
            display: none;
        }
        .msg.bad { display: block; color: var(--danger); }

        .btn {
            width: 100%;
            height: 50px;
            margin-top: 8px;
            border: 1px solid rgba(255, 255, 255, .25);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
            color: #fff;
            font: inherit;
            font-size: 15px;
            font-weight: 800;
            background: linear-gradient(95deg, #9b42ff 0%, #7c30ff 55%, #6525f0 100%);
            box-shadow: 0 8px 26px rgba(124, 48, 255, .45), inset 0 1px 0 rgba(255, 255, 255, .3);
            transition: transform .15s, filter .15s;
        }

        .btn:hover { filter: brightness(1.1); transform: translateY(-1px); }
        .btn:active { transform: scale(.985); }
        .btn:disabled { opacity: .75; cursor: progress; }

        .spinner {
            display: none;
            width: 17px;
            height: 17px;
            border: 2px solid rgba(255, 255, 255, .4);
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin .7s linear infinite;
        }
        .btn.loading .spinner { display: block; }
        .btn.loading .rocket-icon { display: none; }

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
            width: 52px;
            height: 44px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--social-bg);
            text-decoration: none;
            transition: transform .15s, border-color .2s;
        }
        .social:hover { border-color: var(--border-glow); transform: translateY(-2px); }

        .switch { margin-top: 18px; text-align: center; color: var(--text-2); font-size: 13px; }
        .switch a { color: var(--accent-2); font-weight: 800; text-decoration: none; margin-left: 4px; }
        .switch a:hover { text-decoration: underline; }

        /* 3-USTUN: Showcase kartasi */
        .showcase {
            min-height: 610px;
            position: relative;
            overflow: hidden;
            padding: 34px 32px 96px;
            border-radius: 24px;
            border: 1px solid var(--border-glow);
            background: var(--showcase-bg);
            box-shadow: 0 0 46px rgba(102, 46, 255, .2), inset 0 1px 0 rgba(255, 255, 255, .12);
        }

        /* Orqa fondagi o'sish grafiki */
        .bg-chart {
            position: absolute;
            right: 26px;
            top: 42px;
            width: 130px;
            height: 120px;
            opacity: .35;
            pointer-events: none;
        }

        .showcase-content { position: relative; z-index: 2; max-width: 340px; }

        .how-label {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 7px 14px;
            border: 1px solid rgba(164, 126, 255, .26);
            border-radius: 999px;
            color: var(--text);
            background: rgba(94, 58, 198, .28);
            font-size: 12px;
            font-weight: 700;
        }

        .play-tri { color: #d8c4ff; font-size: 11px; }

        .showcase h2 {
            margin: 22px 0 28px;
            font-size: clamp(24px, 2.2vw, 34px);
            line-height: 1.18;
            letter-spacing: -.04em;
            font-weight: 800;
        }

        .showcase h2 span { color: var(--accent-2); }

        /* 1-2-3 qadamlar va bog'lovchi chiziq */
        .steps {
            position: relative;
            display: grid;
            gap: 22px;
        }

        .steps::before {
            content: "";
            position: absolute;
            left: 15px;
            top: 22px;
            bottom: 26px;
            width: 1.5px;
            background: linear-gradient(180deg, rgba(168, 115, 255, .55), rgba(168, 115, 255, .15));
        }

        .step {
            position: relative;
            display: grid;
            grid-template-columns: 32px 42px 1fr;
            gap: 12px;
            align-items: start;
        }

        .step-num {
            position: relative;
            z-index: 1;
            width: 32px;
            height: 32px;
            border: 1px solid rgba(175, 130, 255, .6);
            border-radius: 50%;
            display: grid;
            place-items: center;
            color: var(--text);
            background: #1b1347;
            font-size: 12.5px;
            font-weight: 800;
            box-shadow: 0 0 14px rgba(132, 68, 255, .32);
        }

        :root[data-theme="light"] .step-num { background: #ede6ff; }

        .step-icon {
            width: 42px;
            height: 42px;
            border-radius: 13px;
            display: grid;
            place-items: center;
            color: #c9a8ff;
            background: linear-gradient(145deg, rgba(128, 70, 255, .28), rgba(50, 30, 128, .55));
            border: 1px solid rgba(160, 112, 255, .28);
        }

        :root[data-theme="light"] .step-icon {
            color: #6d28d9;
            background: rgba(124, 58, 237, .12);
        }

        .step b { display: block; margin: 1px 0 3px; font-size: 14px; font-weight: 800; }
        .step p { color: var(--text-2); font-size: 12px; line-height: 1.48; }

        /* O'ng tarafdagi planshet, soat va neon halqa */
        .art {
            position: absolute;
            z-index: 1;
            right: 16px;
            top: 150px;
            width: 270px;
            height: 340px;
            pointer-events: none;
        }

        .orbit-ring {
            position: absolute;
            width: 340px;
            height: 165px;
            right: -45px;
            top: 95px;
            border-radius: 50%;
            border: 2.5px solid rgba(188, 122, 255, .75);
            box-shadow: 0 0 28px rgba(160, 76, 255, .85), inset 0 0 24px rgba(160, 76, 255, .45);
            transform: rotate(-18deg);
        }

        .clipboard {
            position: absolute;
            top: 22px;
            right: 62px;
            width: 176px;
            height: 228px;
            padding: 40px 20px 18px;
            border-radius: 20px;
            transform: rotate(9deg);
            background: linear-gradient(155deg, #f0e9ff 0%, #bca3ff 60%, #8b62f5 100%);
            border: 2px solid rgba(255, 255, 255, .78);
            box-shadow: 0 22px 46px rgba(0, 0, 0, .42), 0 0 34px rgba(140, 78, 255, .42);
        }

        .clip {
            position: absolute;
            width: 56px;
            height: 24px;
            top: -12px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 10px 10px 5px 5px;
            background: linear-gradient(90deg, #8e5eff, #5d28e8);
            border: 2px solid #dfd3ff;
        }

        .clip::after {
            content: "";
            position: absolute;
            width: 14px;
            height: 14px;
            top: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 50%;
            border: 3px solid #cbb6ff;
            background: #5e2ae6;
        }

        .check-row { display: flex; align-items: center; gap: 11px; margin: 11px 0 16px; }
        .check {
            width: 28px;
            height: 28px;
            flex-shrink: 0;
            display: grid;
            place-items: center;
            border-radius: 8px;
            background: linear-gradient(145deg, #8342ff, #4c1fd6);
            color: #fff;
            font-size: 14px;
            font-weight: 900;
            box-shadow: 0 4px 10px rgba(72, 31, 179, .35);
        }
        .lines { display: grid; gap: 5px; flex: 1; }
        .line { height: 5px; border-radius: 99px; background: rgba(88, 52, 185, .36); }
        .line.short { width: 65%; }

        .clock {
            position: absolute;
            right: 8px;
            bottom: 36px;
            width: 138px;
            height: 138px;
            border-radius: 50%;
            border: 7px solid #9664ff;
            background: radial-gradient(circle at 35% 28%, #3a2682, #120e3a 76%);
            box-shadow:
                    0 0 0 3px rgba(215, 194, 255, .7),
                    0 14px 36px rgba(0, 0, 0, .55),
                    0 0 34px rgba(136, 70, 255, .72),
                    inset 0 0 20px rgba(0, 0, 0, .55);
        }

        .clock-ticks { position: absolute; inset: 7px; }
        .clock-hand-h {
            position: absolute;
            left: 50%;
            top: 26px;
            width: 4.5px;
            height: 38px;
            border-radius: 9px;
            background: #e9ddff;
            transform: translateX(-50%) rotate(12deg);
            transform-origin: bottom center;
        }
        .clock-hand-m {
            position: absolute;
            left: 50%;
            top: 50%;
            width: 38px;
            height: 4.5px;
            border-radius: 9px;
            background: #e9ddff;
            transform: translateY(-50%) rotate(-32deg);
            transform-origin: left center;
        }
        .clock-dot {
            position: absolute;
            left: 50%;
            top: 50%;
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: #fff;
            transform: translate(-50%, -50%);
            box-shadow: 0 0 8px #fff;
        }

        /* Pastki afzalliklar paneli */
        .benefits {
            position: absolute;
            z-index: 2;
            bottom: 22px;
            left: 28px;
            right: 28px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            border: 1px solid rgba(155, 114, 255, .28);
            border-radius: 18px;
            background: var(--benefits-bg);
            backdrop-filter: blur(14px);
            padding: 11px 8px;
        }

        .benefit {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 9px;
            color: var(--text);
            font-size: 12px;
            font-weight: 700;
        }

        .benefit + .benefit { border-left: 1px solid rgba(155, 118, 255, .22); }

        .benefit-icon {
            width: 34px;
            height: 34px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            color: #c8a4ff;
            background: rgba(126, 68, 255, .24);
        }

        :root[data-theme="light"] .benefit-icon { color: #6d28d9; background: rgba(124, 58, 237, .12); }

        @keyframes rise { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: none; } }
        @keyframes spin { to { transform: rotate(360deg); } }

        @media (max-width: 1320px) {
            .page { grid-template-columns: minmax(170px, .55fr) minmax(370px, 1fr) minmax(430px, 1.25fr); gap: 18px; }
            .art { transform: scale(.82); transform-origin: right center; right: 4px; }
        }

        @media (max-width: 1024px) {
            .page { grid-template-columns: minmax(0, 480px); justify-content: center; padding-top: 96px; }
            .quote-side, .showcase { display: none; }
        }

        @media (max-width: 480px) {
            .profile-name, .profile-chevron { display: none; }
            .profile { padding: 5px; }
            .form-card { padding: 26px 20px 22px; }
        }
    </style>
</head>
<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/login">
        <span class="brand-mark">
            <svg width="21" height="21" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>
        </span>
        Tartib
    </a>
    <div class="top-actions">
        <button class="theme-btn" type="button" id="themeBtn" aria-label="Mavzuni almashtirish">
            <svg id="themeIcon" width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M21 12.8A9 9 0 1111.2 3a7 7 0 009.8 9.8z"/></svg>
        </button>
        <div class="profile">
            <span class="avatar">A</span>
            <span class="profile-name">Akrom Shomurodov</span>
            <svg class="profile-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>
        </div>
    </div>
</header>

<main class="page">
    <!-- Chap ustun -->
    <section class="quote-side">
        <div>
            <div class="quote-mark">“</div>
            <h2>Katta maqsadlar kichik qadamlar bilan boshlanadi.</h2>
            <p>Intizom — muvaffaqiyat kalitidir.</p>
        </div>
        <div class="books-scene" aria-hidden="true">
            <div class="pencil-cup"></div>
            <div class="book">Focus</div>
            <div class="book">Discipline</div>
            <div class="book">Success</div>
        </div>
    </section>

    <!-- Markaziy forma -->
    <section class="form-card">
        <div class="plus-icon" aria-hidden="true">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
        </div>
        <h1>Hisob <span>yarataylik</span></h1>
        <p class="subtitle">Bir daqiqa — va vazifalaringiz tartibga tushadi.</p>

        <% if (error != null) { %>
        <div class="alert" role="alert">
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><path d="M12 8v5M12 16.5v.01"/></svg>
            <span><%= esc(error) %></span>
        </div>
        <% } %>

        <form id="regForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
            <div class="field">
                <label for="fullName">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4.5 4.5 0 100-9 4.5 4.5 0 000 9zm0 2c-4.4 0-8 2.2-8 5v2h16v-2c0-2.8-3.6-5-8-5z"/></svg>
                    To'liq ism
                </label>
                <div class="input-wrap">
                    <span class="field-icon">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4.5 4.5 0 100-9 4.5 4.5 0 000 9zm0 2c-4.4 0-8 2.2-8 5v2h16v-2c0-2.8-3.6-5-8-5z"/></svg>
                    </span>
                    <input class="input" type="text" id="fullName" name="fullName" value="<%= esc(oldFullName) %>" placeholder="Akrom Valiyev" autocomplete="name" autofocus>
                </div>
            </div>

            <div class="field">
                <label for="username">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M20 4H4a2 2 0 00-2 2v12a2 2 0 002 2h16a2 2 0 002-2V6a2 2 0 00-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                    Foydalanuvchi nomi
                </label>
                <div class="input-wrap">
                    <span class="field-icon">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a4.5 4.5 0 100-9 4.5 4.5 0 000 9zm0 2c-4.4 0-8 2.2-8 5v2h16v-2c0-2.8-3.6-5-8-5z"/></svg>
                    </span>
                    <input class="input" type="text" id="username" name="username" value="<%= esc(oldUsername) %>" placeholder="akrom" autocomplete="username" required>
                    <span class="valid-badge" id="userValidIcon" aria-hidden="true">
                        <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M8.5 12.5l2.3 2.3 4.7-5"/></svg>
                    </span>
                </div>
                <div class="msg" id="userMsg"></div>
            </div>

            <div class="field">
                <label for="password">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M17 9h-1V7a4 4 0 00-8 0v2H7a2 2 0 00-2 2v9a2 2 0 002 2h10a2 2 0 002-2v-9a2 2 0 00-2-2zM10 7a2 2 0 114 0v2h-4V7z"/></svg>
                    Parol
                </label>
                <div class="input-wrap">
                    <input class="input no-left-icon" type="password" id="password" name="password" placeholder="••••••••" autocomplete="new-password" required>
                    <button type="button" class="eye-btn" id="eyeBtn" aria-label="Parolni ko'rsatish">
                        <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/>
                            <line x1="1" y1="1" x2="23" y2="23"/>
                        </svg>
                    </button>
                </div>
                <div class="msg" id="pwdMsg"></div>
            </div>

            <button class="btn" type="submit" id="submitBtn">
                <span class="spinner"></span>
                <svg class="rocket-icon" width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M13.13 22.19L11.5 18.36C13.07 17.78 14.54 17 15.9 16.09L13.13 22.19M5.64 12.5L1.81 10.87L7.91 8.1C7 9.46 6.22 10.93 5.64 12.5M21.61 2.39C21.61 2.39 16.66 .269 11 5.93C8.81 8.12 7.5 10.53 6.65 12.64C6.37 13.39 6.56 14.21 7.11 14.77L9.24 16.89C9.79 17.45 10.61 17.63 11.36 17.35C13.5 16.53 15.88 15.19 18.07 13C23.73 7.34 21.61 2.39 21.61 2.39M14.54 9.46C13.76 8.68 13.76 7.41 14.54 6.63S16.59 5.85 17.37 6.63C18.14 7.41 18.15 8.68 17.37 9.46C16.59 10.24 15.32 10.24 14.54 9.46M8.88 16.53L7.47 15.12L8.88 16.53M6.24 22L9.88 18.36C9.54 18.27 9.21 18.12 8.91 17.91L4.83 22H6.24M2 22H3.41L8.18 17.24L6.76 15.83L2 20.59V22M2 19.17L6.09 15.09C5.88 14.79 5.73 14.47 5.64 14.12L2 17.76V19.17Z"/></svg>
                <span class="btn-text">Ro'yxatdan o'tish&nbsp; →</span>
            </button>
        </form>

        <div class="or">yoki</div>
        <div class="socials" aria-label="Ijtimoiy tarmoqlar">
            <a class="social" href="javascript:void(0)" aria-label="Google">
                <svg width="20" height="20" viewBox="0 0 24 24"><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/></svg>
            </a>
            <a class="social" href="javascript:void(0)" aria-label="Telegram">
                <svg width="21" height="21" viewBox="0 0 24 24" fill="#2AABEE"><path d="M21.93 3.24a1.5 1.5 0 00-1.6-.22L2.6 10.48a1.4 1.4 0 00.12 2.63l4.64 1.5 1.77 5.5a1.2 1.2 0 002 .44l2.58-2.54 4.65 3.43a1.4 1.4 0 002.2-.84l2.9-15.86a1.5 1.5 0 00-.53-1.5zM9.6 14.3l8.1-6.9-6.4 8.2-.4 3.1-1.3-4.4z"/></svg>
            </a>
            <a class="social" href="javascript:void(0)" aria-label="GitHub">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 1.5a10.5 10.5 0 00-3.32 20.46c.53.1.72-.23.72-.5v-1.76c-2.92.64-3.54-1.4-3.54-1.4-.48-1.22-1.17-1.54-1.17-1.54-.95-.65.07-.64.07-.64 1.05.08 1.6 1.08 1.6 1.08.94 1.6 2.46 1.14 3.06.87.1-.68.37-1.14.67-1.4-2.33-.27-4.78-1.17-4.78-5.18 0-1.15.41-2.08 1.08-2.82-.11-.27-.47-1.33.1-2.78 0 0 .88-.28 2.89 1.08a10 10 0 015.26 0c2-1.36 2.88-1.08 2.88-1.08.58 1.45.22 2.51.11 2.78.67.74 1.08 1.67 1.08 2.82 0 4.02-2.46 4.91-4.8 5.17.38.32.71.96.71 1.94v2.88c0 .28.19.61.73.5A10.5 10.5 0 0012 1.5z"/></svg>
            </a>
        </div>
        <p class="switch">Hisobingiz bormi? <a href="${pageContext.request.contextPath}/login">Kirish</a></p>
    </section>

    <!-- O'ng ustun: Showcase -->
    <aside class="showcase" aria-label="Tartib qanday ishlaydi">
        <svg class="bg-chart" viewBox="0 0 140 120" fill="none">
            <rect x="26" y="74" width="16" height="42" rx="4" fill="#8b5cf6"/>
            <rect x="52" y="58" width="16" height="58" rx="4" fill="#8b5cf6"/>
            <rect x="78" y="38" width="16" height="78" rx="4" fill="#a855f7"/>
            <path d="M22 60 C52 52, 78 36, 108 12 M108 12 H88 M108 12 V32" stroke="#c084fc" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>

        <div class="showcase-content">
            <div class="how-label"><span class="play-tri">▶</span> Qanday ishlaydi?</div>
            <h2>Rejasiz kun —<br>yo'qolgan kun.<br><span>Tartib bilan har kun hisobga olinadi.</span></h2>

            <div class="steps">
                <div class="step">
                    <span class="step-num">1</span>
                    <span class="step-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M19 4h-1V2h-2v2H8V2H6v2H5a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2V6a2 2 0 00-2-2zm0 16H5V10h14v10zM7 12h3v3H7v-3zm4 0h3v3h-3v-3zm4 0h3v3h-3v-3z"/></svg>
                    </span>
                    <div><b>Hisob yarating</b><p>Faqat bir necha soniyada hisob oching.</p></div>
                </div>
                <div class="step">
                    <span class="step-num">2</span>
                    <span class="step-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2a10 10 0 1010 10A10 10 0 0012 2zm-1.1 14.3l-4.2-4.2 1.4-1.4 2.8 2.8 5.6-5.6 1.4 1.4-7 7z"/></svg>
                    </span>
                    <div><b>Vazifalarni yozing</b><p>Kunlik rejangizni qo'shing va ustuvorlik belgilang.</p></div>
                </div>
                <div class="step">
                    <span class="step-num">3</span>
                    <span class="step-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M5 13h3v7H5v-7zm5.5-4h3v11h-3V9zM16 5h3v15h-3V5z"/></svg>
                    </span>
                    <div><b>Natijani kuzating</b><p>Bajarilgan ishlar statistikasi bilan o'sishingizni ko'ring.</p></div>
                </div>
            </div>
        </div>

        <div class="art" aria-hidden="true">
            <div class="orbit-ring"></div>
            <div class="clipboard">
                <div class="clip"></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
                <div class="check-row"><span class="check">✓</span><div class="lines"><span class="line"></span><span class="line short"></span></div></div>
            </div>
            <div class="clock">
                <svg class="clock-ticks" viewBox="0 0 100 100" stroke="rgba(216,198,255,.6)" stroke-width="2" stroke-linecap="round">
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

        <div class="benefits">
            <div class="benefit">
                <span class="benefit-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M13 2L3 14h7l-1 8 10-12h-7l1-8z"/></svg>
                </span>
                Tez va qulay
            </div>
            <div class="benefit">
                <span class="benefit-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L4 5v6.09c0 5.05 3.41 9.76 8 10.91 4.59-1.15 8-5.86 8-10.91V5l-8-3zm-1.1 13.6L7.5 12.2l1.4-1.4 2 2 4.6-4.6 1.4 1.4-6 6z"/></svg>
                </span>
                Xavfsiz
            </div>
            <div class="benefit">
                <span class="benefit-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M6 3h12l4 6-10 12L2 9l4-6zm1.5 2L5 8.5h14L16.5 5h-9z"/></svg>
                </span>
                Samarali
            </div>
        </div>
    </aside>
</main>

<script>
    (function () {
        var form = document.getElementById('regForm');
        var full = document.getElementById('fullName');
        var user = document.getElementById('username');
        var pwd = document.getElementById('password');
        var btn = document.getElementById('submitBtn');
        var userMsg = document.getElementById('userMsg');
        var pwdMsg = document.getElementById('pwdMsg');
        var userValidIcon = document.getElementById('userValidIcon');
        var eyeIcon = document.getElementById('eyeIcon');

        document.getElementById('eyeBtn').addEventListener('click', function () {
            var show = pwd.type === 'password';
            pwd.type = show ? 'text' : 'password';
            this.setAttribute('aria-label', show ? 'Parolni yashirish' : "Parolni ko'rsatish");
            eyeIcon.innerHTML = show
                ? '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>'
                : '<path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
            pwd.focus();
        });

        function checkUser() {
            var v = user.value.trim();
            user.classList.remove('err');
            if (!v) {
                userMsg.className = 'msg';
                userValidIcon.classList.remove('show');
                return false;
            }
            if (v.length < 3) {
                userMsg.className = 'msg bad';
                userMsg.textContent = 'Kamida 3 belgi kiriting';
                userValidIcon.classList.remove('show');
                return false;
            }
            if (!/^[A-Za-z0-9_]+$/.test(v)) {
                userMsg.className = 'msg bad';
                userMsg.textContent = 'Faqat lotin harflari, raqam va _ ishlatilsin';
                userValidIcon.classList.remove('show');
                return false;
            }
            userMsg.className = 'msg';
            userValidIcon.classList.add('show');
            return true;
        }
        user.addEventListener('input', checkUser);
        checkUser();

        function checkPwd() {
            var v = pwd.value;
            pwd.classList.remove('err');
            if (v.length < 6) {
                pwdMsg.className = 'msg bad';
                pwdMsg.textContent = 'Parol kamida 6 belgidan iborat bo‘lishi kerak';
                return false;
            }
            pwdMsg.className = 'msg';
            return true;
        }
        pwd.addEventListener('input', function () {
            if (pwd.value.length >= 6) {
                pwd.classList.remove('err');
                pwdMsg.className = 'msg';
            }
        });

        form.addEventListener('submit', function (e) {
            var okUser = checkUser();
            var okPwd = checkPwd();
            if (!okUser) {
                e.preventDefault();
                user.classList.add('err');
                if (!user.value.trim()) {
                    userMsg.className = 'msg bad';
                    userMsg.textContent = 'Foydalanuvchi nomini kiriting';
                }
                user.focus();
                return;
            }
            if (!okPwd) {
                e.preventDefault();
                pwd.classList.add('err');
                pwd.focus();
                return;
            }
            if (!full.value.trim()) full.value = user.value.trim();
            btn.disabled = true;
            btn.classList.add('loading');
            btn.querySelector('.btn-text').textContent = 'Hisob yaratilmoqda...';
        });

        var root = document.documentElement;
        function current() { return root.getAttribute('data-theme') || 'dark'; }
        function updateThemeButton() {
            var dark = current() === 'dark';
            document.getElementById('themeBtn').title = dark ? "Yorug' rejim" : "Qorong'i rejim";
            document.getElementById('themeIcon').innerHTML = dark
                ? '<path d="M21 12.8A9 9 0 1111.2 3a7 7 0 009.8 9.8z"/>'
                : '<circle cx="12" cy="12" r="4" fill="none" stroke="currentColor" stroke-width="2"/><path d="M12 2v2m0 16v2M4.93 4.93l1.42 1.42m11.3 11.3 1.42 1.42M2 12h2m16 0h2M4.93 19.07l1.42-1.42m11.3-11.3 1.42-1.42" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>';
        }
        updateThemeButton();
        document.getElementById('themeBtn').addEventListener('click', function () {
            var next = current() === 'dark' ? 'light' : 'dark';
            root.setAttribute('data-theme', next);
            try { localStorage.setItem('theme', next); } catch (e) {}
            updateThemeButton();
        });
    })();
</script>
</body>
</html>