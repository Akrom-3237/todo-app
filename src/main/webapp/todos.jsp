<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dasturlash.uz.model.Todo" %>
<%@ page import="dasturlash.uz.model.User" %>
<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Todo> todos = (List<Todo>) request.getAttribute("todos");

    int totalCount = (todos != null) ? todos.size() : 0;
    int completedCount = 0;
    if (todos != null) {
        for (Todo t : todos) {
            if (t.isCompleted()) completedCount++;
        }
    }
    int activeCount = totalCount - completedCount;
    int progressPercent = (totalCount > 0) ? (completedCount * 100 / totalCount) : 0;

    String displayName = (currentUser.getFullName() != null && !currentUser.getFullName().isBlank())
            ? currentUser.getFullName() : currentUser.getUsername();
    String firstName = displayName.trim().split("\\s+")[0];
    String initial = displayName.substring(0, 1).toUpperCase();

    // progress ring: r=26 -> circumference ~163.36
    double circ = 163.36;
    double dashOffset = circ - (circ * progressPercent / 100.0);
%>
<!DOCTYPE html>
<html lang="uz">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vazifalar — Tartib</title>
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
            --surface: rgba(20, 17, 54, .78);
            --surface-solid: #151238;
            --surface-2: rgba(31, 26, 78, .72);
            --surface-3: rgba(45, 38, 108, .72);
            --text: #f8f7ff;
            --text-2: #b4afd8;
            --text-3: #837ca8;
            --border: rgba(155, 118, 255, .22);
            --border-strong: rgba(164, 118, 255, .48);
            --accent: #8238ff;
            --accent-2: #a855f7;
            --accent-hover: #964dff;
            --accent-soft: rgba(130, 56, 255, .18);
            --accent-text: #ffffff;
            --danger: #ff6b7a;
            --danger-soft: rgba(255, 92, 117, .14);
            --warning: #ffc15c;
            --warning-soft: rgba(255, 193, 92, .14);
            --success: #39dc91;
            --success-soft: rgba(57, 220, 145, .14);
            --ring: rgba(145, 76, 255, .28);
            --shadow-sm: 0 4px 16px rgba(0, 0, 0, .28);
            --shadow-md: 0 12px 36px -10px rgba(0, 0, 0, .55), 0 0 28px rgba(114, 48, 255, .12);
            --shadow-pop: 0 14px 44px -8px rgba(0, 0, 0, .7);
        }

        :root[data-theme="light"] {
            color-scheme: light;
            --bg: #f2efff;
            --surface: rgba(255, 255, 255, .88);
            --surface-solid: #ffffff;
            --surface-2: rgba(242, 237, 255, .92);
            --surface-3: rgba(230, 222, 255, .92);
            --text: #161233;
            --text-2: #5b547d;
            --text-3: #7f78a3;
            --border: rgba(110, 75, 210, .18);
            --border-strong: rgba(110, 75, 210, .4);
            --accent: #6d28d9;
            --accent-2: #8b3dff;
            --accent-hover: #7c3aed;
            --accent-soft: rgba(109, 40, 217, .11);
            --accent-text: #ffffff;
            --danger: #d12e4f;
            --danger-soft: rgba(209, 46, 79, .1);
            --warning: #b87000;
            --warning-soft: rgba(184, 112, 0, .12);
            --success: #149661;
            --success-soft: rgba(20, 150, 97, .12);
            --ring: rgba(110, 52, 240, .2);
            --shadow-sm: 0 2px 10px rgba(30, 20, 80, .05);
            --shadow-md: 0 12px 32px -12px rgba(40, 25, 110, .14);
            --shadow-pop: 0 14px 40px -10px rgba(40, 25, 110, .22);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Manrope', system-ui, -apple-system, 'Segoe UI', sans-serif;
            background:
                    radial-gradient(55% 40% at 12% 8%, rgba(124, 52, 255, .28), transparent 65%),
                    radial-gradient(48% 42% at 88% 88%, rgba(100, 38, 245, .24), transparent 65%),
                    var(--bg);
            color: var(--text);
            -webkit-font-smoothing: antialiased;
            line-height: 1.5;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            background:
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 900' preserveAspectRatio='none'%3E%3Cdefs%3E%3ClinearGradient id='g' x1='0%25' y1='0%25' x2='100%25' y2='100%25'%3E%3Cstop offset='0%25' stop-color='%239b4dff' stop-opacity='0'/%3E%3Cstop offset='50%25' stop-color='%23a855f7' stop-opacity='0.35'/%3E%3Cstop offset='100%25' stop-color='%236324f2' stop-opacity='0'/%3E%3C/linearGradient%3E%3Cfilter id='b'%3E%3CfeGaussianBlur stdDeviation='10'/%3E%3C/filter%3E%3C/defs%3E%3Cpath d='M-100 720 Q 260 650, 620 900' stroke='url(%23g)' stroke-width='5' fill='none' filter='url(%23b)'/%3E%3Cpath d='M920 -40 Q 1180 260, 1520 380' stroke='url(%23g)' stroke-width='5' fill='none' filter='url(%23b)'/%3E%3C/svg%3E") center / cover no-repeat;
        }

        :root[data-theme="light"] body::before { opacity: .22; }

        button, input, select { font: inherit; }
        a { color: inherit; text-decoration: none; }

        /* ---------- Top bar ---------- */
        .topbar {
            position: sticky; top: 0; z-index: 40;
            background: rgba(10, 8, 30, .72);
            backdrop-filter: blur(18px);
            border-bottom: 1px solid var(--border);
        }
        :root[data-theme="light"] .topbar { background: rgba(242, 239, 255, .82); }

        .topbar-in {
            max-width: 1120px; margin: 0 auto;
            padding: 13px 24px;
            display: flex; align-items: center; gap: 14px;
        }
        .brand { display: flex; align-items: center; gap: 11px; font-weight: 800; font-size: 19px; letter-spacing: -.03em; }
        .brand-mark {
            width: 36px; height: 36px; border-radius: 11px;
            background: linear-gradient(140deg, #9f4dff, #6324f2);
            display: grid; place-items: center; color: #fff;
            box-shadow: 0 0 20px rgba(132, 60, 255, .5), inset 0 1px 0 rgba(255, 255, 255, .35);
        }
        .spacer { flex: 1; }

        .icon-btn {
            width: 40px; height: 40px; border-radius: 50%;
            border: 1px solid var(--border); background: var(--surface);
            color: var(--text-2); cursor: pointer;
            display: grid; place-items: center;
            backdrop-filter: blur(12px);
            transition: color .15s, border-color .15s, transform .15s;
        }
        .icon-btn:hover { color: var(--text); border-color: var(--border-strong); transform: translateY(-1px); }
        .icon-btn:focus-visible { outline: none; box-shadow: 0 0 0 3px var(--ring); }

        .user-chip {
            display: flex; align-items: center; gap: 10px;
            padding: 4px 6px 4px 5px; border-radius: 999px;
            border: 1px solid var(--border); background: var(--surface);
            backdrop-filter: blur(12px);
        }
        .avatar {
            width: 31px; height: 31px; border-radius: 50%;
            background: linear-gradient(135deg, #b15cff, #5d29e8);
            color: #fff; font-weight: 800; font-size: 13px;
            display: grid; place-items: center; flex-shrink: 0;
        }
        .user-chip .uname { font-size: 13px; font-weight: 700; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .logout {
            width: 30px; height: 30px; border-radius: 50%;
            display: grid; place-items: center; color: var(--text-3);
            transition: color .15s, background .15s;
        }
        .logout:hover { color: var(--danger); background: var(--danger-soft); }

        /* ---------- Layout ---------- */
        .shell { position: relative; z-index: 1; max-width: 1120px; margin: 0 auto; padding: 34px 24px 80px; }

        .hero { display: flex; align-items: flex-end; justify-content: space-between; gap: 24px; margin-bottom: 26px; flex-wrap: wrap; }
        .hero h1 { font-size: clamp(26px, 2.8vw, 34px); font-weight: 800; letter-spacing: -.035em; line-height: 1.18; }
        .hero h1 span { color: var(--accent-2); }
        .hero p { color: var(--text-2); font-size: 14.5px; margin-top: 6px; }

        .ring-card {
            display: flex; align-items: center; gap: 15px;
            background: var(--surface); border: 1px solid var(--border);
            backdrop-filter: blur(16px);
            border-radius: 18px; padding: 12px 20px 12px 14px;
            box-shadow: var(--shadow-sm);
        }
        .ring { position: relative; width: 60px; height: 60px; flex-shrink: 0; }
        .ring svg { transform: rotate(-90deg); display: block; }
        .ring-track { stroke: var(--surface-3); }
        .ring-fill { stroke: url(#ringGrad); stroke-linecap: round; transition: stroke-dashoffset .8s cubic-bezier(.2,.8,.2,1); }
        .ring-num {
            position: absolute; inset: 0; display: grid; place-items: center;
            font-size: 13.5px; font-weight: 800; letter-spacing: -.02em;
        }
        .ring-text b { display: block; font-size: 14px; font-weight: 800; }
        .ring-text span { font-size: 12.5px; color: var(--text-2); font-weight: 600; }

        /* ---------- Stats ---------- */
        .stats { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .stat {
            position: relative; overflow: hidden;
            display: flex; align-items: center; justify-content: space-between; gap: 14px;
            background: var(--surface); border: 1px solid var(--border);
            backdrop-filter: blur(16px);
            border-radius: 18px; padding: 18px 20px;
            box-shadow: var(--shadow-sm);
            transition: border-color .2s, transform .2s, box-shadow .2s;
        }
        .stat:hover { border-color: var(--border-strong); transform: translateY(-2px); box-shadow: var(--shadow-md); }
        .stat-label { font-size: 11.5px; font-weight: 800; color: var(--text-3); text-transform: uppercase; letter-spacing: .07em; margin-bottom: 6px; }
        .stat-val { font-size: 30px; font-weight: 800; letter-spacing: -.04em; line-height: 1; }
        .stat.is-active .stat-val { color: var(--accent-2); }
        .stat.is-done .stat-val { color: var(--success); }

        .stat-icon {
            width: 44px; height: 44px; border-radius: 14px; flex-shrink: 0;
            display: grid; place-items: center;
            background: var(--surface-2); color: var(--text-2);
            border: 1px solid var(--border);
        }
        .stat.is-active .stat-icon { background: var(--accent-soft); color: var(--accent-2); border-color: rgba(168, 85, 247, .3); }
        .stat.is-done .stat-icon { background: var(--success-soft); color: var(--success); border-color: rgba(57, 220, 145, .3); }

        /* ---------- Composer ---------- */
        .composer {
            background: var(--surface); border: 1px solid var(--border);
            backdrop-filter: blur(18px);
            border-radius: 20px; padding: 16px 18px;
            box-shadow: var(--shadow-md); margin-bottom: 22px;
            transition: border-color .2s, box-shadow .2s;
        }
        .composer:focus-within { border-color: var(--accent-2); box-shadow: var(--shadow-md), 0 0 0 4px var(--ring); }
        .composer-row { display: flex; gap: 12px; align-items: center; }
        .composer-input {
            flex: 1; min-width: 0; height: 48px;
            border: 0; background: transparent; color: var(--text);
            font-size: 16px; font-weight: 600; padding: 0 6px;
        }
        .composer-input::placeholder { color: var(--text-3); font-weight: 500; }
        .composer-input:focus { outline: none; }

        .add-btn {
            height: 46px; padding: 0 22px; border: 1px solid rgba(255, 255, 255, .22); border-radius: 14px;
            background: linear-gradient(95deg, #9b42ff 0%, #7c30ff 55%, #6525f0 100%);
            color: #fff;
            font-size: 14.5px; font-weight: 800; cursor: pointer;
            display: inline-flex; align-items: center; gap: 8px;
            transition: filter .15s, transform .12s;
            box-shadow: 0 8px 22px -4px rgba(124, 48, 255, .52), inset 0 1px 0 rgba(255, 255, 255, .28);
            white-space: nowrap;
        }
        .add-btn:hover { filter: brightness(1.1); transform: translateY(-1px); }
        .add-btn:active { transform: scale(.97); }
        .add-btn:focus-visible { outline: none; box-shadow: 0 0 0 4px var(--ring); }

        .composer-meta {
            display: flex; align-items: center; gap: 9px;
            margin-top: 12px; padding-top: 12px;
            border-top: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .pill-select, .pill-date {
            height: 35px; padding: 0 12px;
            border: 1px solid var(--border); border-radius: 999px;
            background: var(--surface-2); color: var(--text-2);
            font-size: 12.5px; font-weight: 700; cursor: pointer;
            transition: border-color .15s, color .15s;
        }
        .pill-select option { background: var(--surface-solid); color: var(--text); }
        .pill-select:hover, .pill-date:hover { border-color: var(--border-strong); color: var(--text); }
        .pill-select:focus, .pill-date:focus { outline: none; border-color: var(--accent-2); box-shadow: 0 0 0 3px var(--ring); }

        .kbd-hint { margin-left: auto; font-size: 12px; color: var(--text-3); font-weight: 600; }
        kbd {
            font: inherit; font-size: 11px; font-weight: 700; color: var(--text-2);
            background: var(--surface-2); border: 1px solid var(--border-strong);
            border-bottom-width: 2px; border-radius: 6px; padding: 1px 6px;
        }

        /* ---------- Toolbar ---------- */
        .toolbar { display: flex; gap: 10px; align-items: center; margin-bottom: 14px; flex-wrap: wrap; }
        .search { position: relative; flex: 1; min-width: 200px; }
        .search svg { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-3); pointer-events: none; }
        .search input {
            width: 100%; height: 42px; padding: 0 14px 0 40px;
            border: 1px solid var(--border); border-radius: 13px;
            background: var(--surface); color: var(--text); font-size: 14px;
            backdrop-filter: blur(12px);
            transition: border-color .15s, box-shadow .15s;
        }
        .search input::placeholder { color: var(--text-3); }
        .search input:focus { outline: none; border-color: var(--accent-2); box-shadow: 0 0 0 3px var(--ring); }

        .segmented {
            display: inline-flex; gap: 3px; padding: 4px;
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 13px; backdrop-filter: blur(12px);
        }
        .segmented button {
            height: 32px; padding: 0 14px; border: 0; border-radius: 9px;
            background: transparent; color: var(--text-2);
            font-size: 13px; font-weight: 700; cursor: pointer;
            transition: background .15s, color .15s;
        }
        .segmented button:hover { color: var(--text); }
        .segmented button[aria-pressed="true"] {
            background: linear-gradient(95deg, #8b42ff, #6528f0);
            color: #fff;
            box-shadow: 0 4px 12px rgba(124, 58, 237, .4);
        }

        .sort-select {
            height: 42px; padding: 0 13px;
            border: 1px solid var(--border); border-radius: 13px;
            background: var(--surface); color: var(--text-2);
            font-size: 13px; font-weight: 700; cursor: pointer;
            backdrop-filter: blur(12px);
        }
        .sort-select option { background: var(--surface-solid); color: var(--text); }
        .sort-select:hover { color: var(--text); border-color: var(--border-strong); }
        .sort-select:focus { outline: none; border-color: var(--accent-2); box-shadow: 0 0 0 3px var(--ring); }

        .chips { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 22px; }
        .chip {
            height: 33px; padding: 0 14px;
            border: 1px solid var(--border); border-radius: 999px;
            background: var(--surface); color: var(--text-2);
            font-size: 12.5px; font-weight: 700; cursor: pointer;
            display: inline-flex; align-items: center; gap: 7px;
            transition: all .15s;
        }
        .chip:hover { border-color: var(--border-strong); color: var(--text); }
        .chip[aria-pressed="true"] { background: var(--accent-soft); border-color: var(--accent-2); color: var(--text); }
        .chip .dot { width: 7px; height: 7px; border-radius: 50%; }
        .dot-HIGH { background: var(--danger); box-shadow: 0 0 8px var(--danger); }
        .dot-MEDIUM { background: var(--warning); box-shadow: 0 0 8px var(--warning); }
        .dot-LOW { background: var(--success); box-shadow: 0 0 8px var(--success); }

        /* ---------- Task groups ---------- */
        .group { margin-bottom: 28px; }
        .group-head {
            display: flex; align-items: center; gap: 10px;
            font-size: 12px; font-weight: 800;
            text-transform: uppercase; letter-spacing: .08em;
            color: var(--text-3); margin-bottom: 12px;
        }
        .group-count {
            background: var(--surface-2); border: 1px solid var(--border);
            color: var(--text-2);
            border-radius: 999px; padding: 1px 9px;
            font-size: 11.5px; letter-spacing: 0;
        }
        .group-line { flex: 1; height: 1px; background: var(--border); }

        .task-list { display: flex; flex-direction: column; gap: 10px; }

        .task {
            display: flex; align-items: flex-start; gap: 14px;
            background: var(--surface); border: 1px solid var(--border);
            backdrop-filter: blur(14px);
            border-radius: 16px; padding: 15px 16px;
            box-shadow: var(--shadow-sm);
            transition: border-color .18s, box-shadow .18s, transform .15s, opacity .2s;
            animation: pop .35s cubic-bezier(.2,.8,.2,1) both;
        }
        .task:hover { border-color: var(--border-strong); box-shadow: var(--shadow-md); transform: translateY(-1px); }
        .task.done { opacity: .68; }
        .task.hidden { display: none; }
        .task.leaving { opacity: 0; transform: scale(.97); }

        .check-form { margin: 0; display: flex; flex-shrink: 0; }
        .check {
            width: 23px; height: 23px; margin-top: 1px;
            border: 2px solid var(--border-strong); border-radius: 50%;
            background: transparent; cursor: pointer; padding: 0;
            display: grid; place-items: center; color: transparent;
            transition: border-color .15s, background .15s, color .15s, transform .1s;
        }
        .check:hover { border-color: var(--accent-2); background: var(--accent-soft); }
        .check:active { transform: scale(.9); }
        .check:focus-visible { outline: none; box-shadow: 0 0 0 3px var(--ring); }
        .task.done .check { background: var(--success); border-color: var(--success); color: #fff; box-shadow: 0 0 12px rgba(57, 220, 145, .4); }

        .task-body { flex: 1; min-width: 0; }
        .task-title {
            font-size: 15.5px; font-weight: 700; letter-spacing: -.01em;
            word-break: break-word; line-height: 1.4;
        }
        .task.done .task-title { text-decoration: line-through; text-decoration-thickness: 1.5px; color: var(--text-2); }
        .badges { display: flex; gap: 7px; flex-wrap: wrap; margin-top: 8px; }
        .badge {
            font-size: 11.5px; font-weight: 700;
            padding: 3px 9px; border-radius: 999px;
            border: 1px solid transparent;
            display: inline-flex; align-items: center; gap: 4px;
        }
        .badge.prio-HIGH { background: var(--danger-soft); color: var(--danger); }
        .badge.prio-MEDIUM { background: var(--warning-soft); color: var(--warning); }
        .badge.prio-LOW { background: var(--success-soft); color: var(--success); }
        .badge.cat { background: var(--surface-2); color: var(--text-2); border-color: var(--border); }
        .badge.date { background: var(--surface-2); color: var(--text-2); border-color: var(--border); }
        .badge.date.overdue { background: var(--danger-soft); color: var(--danger); border-color: transparent; }

        .del-form { margin: 0; flex-shrink: 0; }
        .del-btn {
            width: 34px; height: 34px; border: 0; border-radius: 10px;
            background: transparent; color: var(--text-3); cursor: pointer;
            display: grid; place-items: center;
            opacity: 0; transition: opacity .15s, color .15s, background .15s;
        }
        .task:hover .del-btn, .del-btn:focus-visible { opacity: 1; }
        .del-btn:hover { color: var(--danger); background: var(--danger-soft); }
        .del-btn:focus-visible { outline: none; box-shadow: 0 0 0 3px var(--ring); }

        /* ---------- Empty states ---------- */
        .empty {
            text-align: center; padding: 64px 24px;
            background: var(--surface); border: 1px dashed var(--border-strong);
            backdrop-filter: blur(14px);
            border-radius: 22px;
        }
        .empty-art {
            width: 62px; height: 62px; margin: 0 auto 18px;
            border-radius: 18px;
            background: linear-gradient(145deg, rgba(163, 76, 255, .24), rgba(94, 34, 236, .18));
            border: 1px solid rgba(168, 85, 247, .35);
            color: var(--accent-2);
            display: grid; place-items: center;
            box-shadow: 0 0 28px rgba(130, 56, 255, .24);
        }
        .empty h3 { font-size: 19px; font-weight: 800; letter-spacing: -.02em; margin-bottom: 8px; }
        .empty p { color: var(--text-2); font-size: 14px; max-width: 380px; margin: 0 auto; line-height: 1.55; }
        .no-results { display: none; }
        .no-results.show { display: block; }

        .done-banner {
            display: flex; align-items: center; gap: 12px;
            background: var(--success-soft); color: var(--success);
            border: 1px solid rgba(57, 220, 145, .25);
            border-radius: 16px; padding: 14px 18px; margin-bottom: 20px;
            font-weight: 700; font-size: 14.5px;
        }

        /* ---------- Toast ---------- */
        .toast {
            position: fixed; left: 50%; bottom: 28px;
            transform: translate(-50%, 20px);
            background: var(--surface-solid); color: var(--text);
            border: 1px solid var(--border-strong);
            border-radius: 12px; padding: 11px 20px;
            font-size: 13.5px; font-weight: 700;
            box-shadow: var(--shadow-pop);
            opacity: 0; pointer-events: none;
            transition: opacity .2s, transform .2s;
            z-index: 80;
        }
        .toast.show { opacity: 1; transform: translate(-50%, 0); }

        @keyframes pop { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }

        @media (max-width: 760px) {
            .topbar-in, .shell { padding-left: 16px; padding-right: 16px; }
            .user-chip .uname { display: none; }
            .stats { grid-template-columns: 1fr; }
            .composer-row { flex-direction: column; align-items: stretch; }
            .add-btn { width: 100%; justify-content: center; }
            .kbd-hint { display: none; }
            .del-btn { opacity: 1; }
        }
        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after { animation: none !important; transition: none !important; }
        }
    </style>
</head>
<body>

<header class="topbar">
    <div class="topbar-in">
        <a class="brand" href="${pageContext.request.contextPath}/todos">
            <span class="brand-mark">
                <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>
            </span>
            Tartib
        </a>
        <div class="spacer"></div>
        <button class="icon-btn" type="button" id="themeBtn" aria-label="Mavzuni almashtirish" title="Mavzu">
            <svg id="themeIcon" width="17" height="17" viewBox="0 0 24 24" fill="currentColor"><path d="M21 12.8A9 9 0 1111.2 3a7 7 0 009.8 9.8z"/></svg>
        </button>
        <div class="user-chip">
            <span class="avatar"><%= esc(initial) %></span>
            <span class="uname"><%= esc(displayName) %></span>
            <a class="logout" href="${pageContext.request.contextPath}/logout" title="Chiqish" aria-label="Chiqish">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 17l5-5-5-5M20 12H9M12 3H6a2 2 0 00-2 2v14a2 2 0 002 2h6"/></svg>
            </a>
        </div>
    </div>
</header>

<main class="shell">

    <section class="hero">
        <div>
            <h1>Assalomu alaykum, <span><%= esc(firstName) %></span></h1>
            <p id="heroSub">
                <% if (totalCount == 0) { %>
                Bugun hali vazifa qo'shilmagan — birinchisini yozing.
                <% } else if (activeCount == 0) { %>
                Hamma vazifa bajarildi. Ajoyib ish!
                <% } else { %>
                Bajarilishi kerak: <%= activeCount %> ta vazifa.
                <% } %>
            </p>
        </div>

        <% if (totalCount > 0) { %>
        <div class="ring-card">
            <div class="ring">
                <svg width="60" height="60" viewBox="0 0 60 60" aria-hidden="true">
                    <defs>
                        <linearGradient id="ringGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="#a855f7"/>
                            <stop offset="100%" stop-color="#6324f2"/>
                        </linearGradient>
                    </defs>
                    <circle class="ring-track" cx="30" cy="30" r="26" fill="none" stroke-width="6"/>
                    <circle class="ring-fill" cx="30" cy="30" r="26" fill="none" stroke-width="6"
                            stroke-dasharray="<%= String.format(java.util.Locale.US, "%.2f", circ) %>"
                            stroke-dashoffset="<%= String.format(java.util.Locale.US, "%.2f", dashOffset) %>"/>
                </svg>
                <span class="ring-num"><%= progressPercent %>%</span>
            </div>
            <div class="ring-text">
                <b><%= completedCount %> / <%= totalCount %> bajarildi</b>
                <span><%= progressPercent == 100 ? "Reja to'liq yopildi" : activeCount + " ta qoldi" %></span>
            </div>
        </div>
        <% } %>
    </section>

    <section class="stats">
        <div class="stat">
            <div>
                <div class="stat-label">Jami</div>
                <div class="stat-val"><%= totalCount %></div>
            </div>
            <div class="stat-icon" aria-hidden="true">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg>
            </div>
        </div>
        <div class="stat is-active">
            <div>
                <div class="stat-label">Bajarilmagan</div>
                <div class="stat-val"><%= activeCount %></div>
            </div>
            <div class="stat-icon" aria-hidden="true">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
            </div>
        </div>
        <div class="stat is-done">
            <div>
                <div class="stat-label">Bajarilgan</div>
                <div class="stat-val"><%= completedCount %></div>
            </div>
            <div class="stat-icon" aria-hidden="true">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M8.5 12.5l2.3 2.3 4.7-5"/></svg>
            </div>
        </div>
    </section>

    <!-- Composer: metadata is encoded into the title as [PRIO][Category][date] -->
    <form class="composer" id="addForm" action="${pageContext.request.contextPath}/todos" method="post">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="title" id="encodedTitle">

        <div class="composer-row">
            <input type="text" id="rawTitle" class="composer-input" maxlength="180"
                   placeholder="Nima qilish kerak?" autocomplete="off" required autofocus>
            <button type="submit" class="add-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
                Qo'shish
            </button>
        </div>

        <div class="composer-meta">
            <select id="prioSelect" class="pill-select" aria-label="Muhimlik darajasi">
                <option value="HIGH">Muhimligi: yuqori</option>
                <option value="MEDIUM" selected>Muhimligi: o'rta</option>
                <option value="LOW">Muhimligi: past</option>
            </select>
            <select id="catSelect" class="pill-select" aria-label="Kategoriya">
                <option value="Ish">Kategoriya: Ish</option>
                <option value="O'qish">Kategoriya: O'qish</option>
                <option value="Shaxsiy">Kategoriya: Shaxsiy</option>
                <option value="Uy">Kategoriya: Uy</option>
            </select>
            <input type="date" id="dateSelect" class="pill-date" aria-label="Muddat (ixtiyoriy)">
            <span class="kbd-hint"><kbd>Enter</kbd> — qo'shish, <kbd>/</kbd> — qidirish</span>
        </div>
    </form>

    <% if (totalCount > 0) { %>
    <div class="toolbar">
        <div class="search">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.2-5.2M17 10a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
            <input type="text" id="searchBox" placeholder="Vazifalar orasidan qidirish..." aria-label="Qidirish">
        </div>
        <div class="segmented" id="statusSeg" role="group" aria-label="Holat bo'yicha filtr">
            <button type="button" data-status="all" aria-pressed="true">Hammasi</button>
            <button type="button" data-status="active" aria-pressed="false">Faol</button>
            <button type="button" data-status="done" aria-pressed="false">Bajarilgan</button>
        </div>
        <select id="sortSelect" class="sort-select" aria-label="Tartiblash">
            <option value="default">Tartib: standart</option>
            <option value="priority">Tartib: muhimligi</option>
            <option value="alpha">Tartib: A–Z</option>
            <option value="date">Tartib: muddati</option>
        </select>
    </div>

    <div class="chips" id="prioChips" role="group" aria-label="Muhimlik bo'yicha filtr">
        <button type="button" class="chip" data-prio="all" aria-pressed="true">Barcha darajalar</button>
        <button type="button" class="chip" data-prio="HIGH" aria-pressed="false"><span class="dot dot-HIGH"></span>Yuqori</button>
        <button type="button" class="chip" data-prio="MEDIUM" aria-pressed="false"><span class="dot dot-MEDIUM"></span>O'rta</button>
        <button type="button" class="chip" data-prio="LOW" aria-pressed="false"><span class="dot dot-LOW"></span>Past</button>
    </div>
    <% } %>

    <% if (totalCount == 0) { %>
    <div class="empty">
        <div class="empty-art">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3 8-8"/><path d="M20 12v7a2 2 0 01-2 2H6a2 2 0 01-2-2V6a2 2 0 012-2h9"/></svg>
        </div>
        <h3>Ro'yxat hozircha bo'sh</h3>
        <p>Yuqoridagi maydonga birinchi vazifangizni yozing — muhimlik darajasi va muddatini ham belgilab qo'yishingiz mumkin.</p>
    </div>
    <% } else { %>

    <% if (activeCount == 0) { %>
    <div class="done-banner">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>
        Barcha vazifalar bajarildi — bugungi reja yopildi.
    </div>
    <% } %>

    <% if (activeCount > 0) { %>
    <section class="group" id="groupActive">
        <div class="group-head">
            <span>Bajarilishi kerak</span>
            <span class="group-count"><%= activeCount %></span>
            <span class="group-line"></span>
        </div>
        <div class="task-list" id="listActive">
            <% int i = 0; for (Todo todo : todos) { if (todo.isCompleted()) continue; i++; %>
            <article class="task" data-id="<%= todo.getId() %>" data-order="<%= i %>"
                     data-raw="<%= esc(todo.getTitle()) %>" style="animation-delay: <%= Math.min(i, 10) * 25 %>ms">
                <form class="check-form" action="${pageContext.request.contextPath}/todos" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= todo.getId() %>">
                    <button class="check" type="submit" aria-label="Bajarildi deb belgilash">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>
                    </button>
                </form>
                <div class="task-body">
                    <div class="task-title"><%= esc(todo.getTitle()) %></div>
                    <div class="badges"></div>
                </div>
                <form class="del-form" action="${pageContext.request.contextPath}/todos" method="post" data-confirm="1">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= todo.getId() %>">
                    <button class="del-btn" type="submit" aria-label="O'chirish" title="O'chirish">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M8 6V4h8v2M6 6l1 14h10l1-14M10 11v5M14 11v5"/></svg>
                    </button>
                </form>
            </article>
            <% } %>
        </div>
    </section>
    <% } %>

    <% if (completedCount > 0) { %>
    <section class="group" id="groupDone">
        <div class="group-head">
            <span>Bajarilgan</span>
            <span class="group-count"><%= completedCount %></span>
            <span class="group-line"></span>
        </div>
        <div class="task-list" id="listDone">
            <% int j = 0; for (Todo todo : todos) { if (!todo.isCompleted()) continue; j++; %>
            <article class="task done" data-id="<%= todo.getId() %>" data-order="<%= j %>"
                     data-raw="<%= esc(todo.getTitle()) %>" style="animation-delay: <%= Math.min(j, 10) * 25 %>ms">
                <form class="check-form" action="${pageContext.request.contextPath}/todos" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= todo.getId() %>">
                    <button class="check" type="submit" aria-label="Bajarilmagan deb belgilash">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>
                    </button>
                </form>
                <div class="task-body">
                    <div class="task-title"><%= esc(todo.getTitle()) %></div>
                    <div class="badges"></div>
                </div>
                <form class="del-form" action="${pageContext.request.contextPath}/todos" method="post" data-confirm="1">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= todo.getId() %>">
                    <button class="del-btn" type="submit" aria-label="O'chirish" title="O'chirish">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M8 6V4h8v2M6 6l1 14h10l1-14M10 11v5M14 11v5"/></svg>
                    </button>
                </form>
            </article>
            <% } %>
        </div>
    </section>
    <% } %>

    <div class="empty no-results" id="noResults">
        <div class="empty-art">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 21l-5.2-5.2M17 10a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        </div>
        <h3>Hech narsa topilmadi</h3>
        <p>Qidiruv so'zini yoki filtrlarni o'zgartirib ko'ring.</p>
    </div>

    <% } %>
</main>

<div class="toast" id="toast" role="status" aria-live="polite"></div>

<script>
    (function () {
        'use strict';

        var PRIO_LABEL = { HIGH: 'Yuqori', MEDIUM: "O'rta", LOW: 'Past' };
        var PRIO_WEIGHT = { HIGH: 3, MEDIUM: 2, LOW: 1 };

        /* ---------- Toast ---------- */
        var toastEl = document.getElementById('toast');
        var toastTimer;
        function toast(msg) {
            toastEl.textContent = msg;
            toastEl.classList.add('show');
            clearTimeout(toastTimer);
            toastTimer = setTimeout(function () { toastEl.classList.remove('show'); }, 2200);
        }

        /* ---------- Theme ---------- */
        var root = document.documentElement;
        var themeBtn = document.getElementById('themeBtn');
        var themeIcon = document.getElementById('themeIcon');

        function currentTheme() {
            return root.getAttribute('data-theme') || 'dark';
        }
        function syncThemeIcon() {
            var dark = currentTheme() === 'dark';
            if (themeIcon) {
                themeIcon.innerHTML = dark
                    ? '<path d="M21 12.8A9 9 0 1111.2 3a7 7 0 009.8 9.8z"/>'
                    : '<circle cx="12" cy="12" r="4" fill="none" stroke="currentColor" stroke-width="2"/><path d="M12 2v2m0 16v2M4.93 4.93l1.42 1.42m11.3 11.3 1.42 1.42M2 12h2m16 0h2M4.93 19.07l1.42-1.42m11.3-11.3 1.42-1.42" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>';
            }
        }
        syncThemeIcon();

        if (themeBtn) {
            themeBtn.addEventListener('click', function () {
                var next = currentTheme() === 'dark' ? 'light' : 'dark';
                root.setAttribute('data-theme', next);
                try { localStorage.setItem('theme', next); } catch (e) {}
                syncThemeIcon();
                toast(next === 'dark' ? "Qorong'i rejim" : "Yorug' rejim");
            });
        }

        /* ---------- Composer: encode metadata into the title ---------- */
        var addForm = document.getElementById('addForm');
        var rawTitle = document.getElementById('rawTitle');
        if (addForm) {
            addForm.addEventListener('submit', function (e) {
                var raw = rawTitle.value.trim();
                if (!raw) { e.preventDefault(); rawTitle.focus(); return; }
                var prio = document.getElementById('prioSelect').value;
                var cat = document.getElementById('catSelect').value;
                var date = document.getElementById('dateSelect').value;
                var prefix = '[' + prio + '][' + cat + ']' + (date ? '[' + date + ']' : '');
                document.getElementById('encodedTitle').value = prefix + ' ' + raw;
            });
        }

        /* ---------- Parse metadata out of stored titles ---------- */
        var META_RE = /^\[(HIGH|MEDIUM|LOW)\]\[([^\]]+)\](?:\[(\d{4}-\d{2}-\d{2})\])?\s*([\s\S]*)$/;
        var today = new Date(); today.setHours(0, 0, 0, 0);

        function badge(cls, text) {
            var el = document.createElement('span');
            el.className = 'badge ' + cls;
            el.textContent = text;
            return el;
        }

        var tasks = Array.prototype.slice.call(document.querySelectorAll('.task'));
        tasks.forEach(function (card) {
            var raw = card.getAttribute('data-raw') || '';
            var m = raw.match(META_RE);
            var titleEl = card.querySelector('.task-title');
            var badgesEl = card.querySelector('.badges');
            var prio = 'MEDIUM', cat = '', date = '', clean = raw;

            if (m) {
                prio = m[1];
                cat = m[2];
                date = m[3] || '';
                clean = (m[4] || '').trim() || raw;
            }

            card.dataset.prio = prio;
            card.dataset.weight = PRIO_WEIGHT[prio] || 2;
            card.dataset.cat = cat;
            card.dataset.date = date;
            card.dataset.clean = clean;
            titleEl.textContent = clean;

            badgesEl.textContent = '';
            if (m) {
                badgesEl.appendChild(badge('prio-' + prio, PRIO_LABEL[prio]));
                if (cat) badgesEl.appendChild(badge('cat', '#' + cat));
                if (date) {
                    var d = new Date(date + 'T00:00:00');
                    var overdue = !card.classList.contains('done') && d < today;
                    var b = badge('date' + (overdue ? ' overdue' : ''), (overdue ? 'Muddati o‘tgan: ' : 'Muddat: ') + date);
                    badgesEl.appendChild(b);
                }
            }
        });

        /* ---------- Filtering ---------- */
        var statusFilter = 'all';
        var prioFilter = 'all';
        var searchBox = document.getElementById('searchBox');
        var noResults = document.getElementById('noResults');
        var groupActive = document.getElementById('groupActive');
        var groupDone = document.getElementById('groupDone');

        function apply() {
            var q = (searchBox ? searchBox.value : '').trim().toLowerCase();
            var shown = 0;

            tasks.forEach(function (card) {
                var isDone = card.classList.contains('done');
                var ok = true;
                if (statusFilter === 'active' && isDone) ok = false;
                if (statusFilter === 'done' && !isDone) ok = false;
                if (ok && prioFilter !== 'all' && card.dataset.prio !== prioFilter) ok = false;
                if (ok && q) {
                    var hay = (card.dataset.clean + ' ' + card.dataset.cat + ' ' + card.dataset.date).toLowerCase();
                    if (hay.indexOf(q) === -1) ok = false;
                }
                card.classList.toggle('hidden', !ok);
                if (ok) shown++;
            });

            [groupActive, groupDone].forEach(function (g) {
                if (!g) return;
                var any = g.querySelectorAll('.task:not(.hidden)').length;
                g.style.display = any ? '' : 'none';
            });
            if (noResults) noResults.classList.toggle('show', shown === 0);
        }

        var seg = document.getElementById('statusSeg');
        if (seg) {
            seg.addEventListener('click', function (e) {
                var b = e.target.closest('button[data-status]');
                if (!b) return;
                statusFilter = b.dataset.status;
                seg.querySelectorAll('button').forEach(function (x) {
                    x.setAttribute('aria-pressed', String(x === b));
                });
                apply();
            });
        }

        var chips = document.getElementById('prioChips');
        if (chips) {
            chips.addEventListener('click', function (e) {
                var b = e.target.closest('button[data-prio]');
                if (!b) return;
                prioFilter = b.dataset.prio;
                chips.querySelectorAll('.chip').forEach(function (x) {
                    x.setAttribute('aria-pressed', String(x === b));
                });
                apply();
            });
        }

        if (searchBox) searchBox.addEventListener('input', apply);

        /* ---------- Sorting ---------- */
        var sortSelect = document.getElementById('sortSelect');
        if (sortSelect) {
            sortSelect.addEventListener('change', function () {
                var mode = sortSelect.value;
                ['listActive', 'listDone'].forEach(function (id) {
                    var list = document.getElementById(id);
                    if (!list) return;
                    var items = Array.prototype.slice.call(list.children);
                    items.sort(function (a, b) {
                        if (mode === 'priority') return (+b.dataset.weight) - (+a.dataset.weight);
                        if (mode === 'alpha') return a.dataset.clean.localeCompare(b.dataset.clean, 'uz');
                        if (mode === 'date') {
                            var da = a.dataset.date || '9999-12-31';
                            var db = b.dataset.date || '9999-12-31';
                            return da.localeCompare(db);
                        }
                        return (+a.dataset.order) - (+b.dataset.order);
                    });
                    items.forEach(function (it) { it.style.animationDelay = '0ms'; list.appendChild(it); });
                });
            });
        }

        /* ---------- Delete confirmation ---------- */
        document.querySelectorAll('form[data-confirm]').forEach(function (f) {
            f.addEventListener('submit', function (e) {
                var card = f.closest('.task');
                var name = card ? card.dataset.clean : 'vazifa';
                if (!window.confirm('"' + name + '" o‘chirilsinmi? Bu amalni qaytarib bo‘lmaydi.')) {
                    e.preventDefault();
                    return;
                }
                if (card) card.classList.add('leaving');
            });
        });

        /* ---------- Keyboard shortcuts ---------- */
        document.addEventListener('keydown', function (e) {
            var tag = (e.target.tagName || '').toLowerCase();
            var typing = tag === 'input' || tag === 'textarea' || tag === 'select';
            if (e.key === '/' && !typing && searchBox) { e.preventDefault(); searchBox.focus(); }
            if (e.key === 'n' && !typing && rawTitle) { e.preventDefault(); rawTitle.focus(); }
            if (e.key === 'Escape' && searchBox && document.activeElement === searchBox) {
                searchBox.value = ''; apply(); searchBox.blur();
            }
        });
    })();
</script>
</body>
</html>