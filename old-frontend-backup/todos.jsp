<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dasturlash.uz.model.Todo" %>
<%@ page import="dasturlash.uz.model.User" %>
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
    String initial = displayName.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="uz" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskOS Enterprise — <%= displayName %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <style>
        :root[data-theme="dark"] {
            --bg-base: #060911;
            --bg-surface: rgba(13, 18, 30, 0.82);
            --bg-elevated: rgba(22, 30, 49, 0.72);
            --bg-elevated-hover: rgba(30, 41, 66, 0.88);
            --bg-input: rgba(9, 13, 24, 0.9);
            --text-main: #f8fafc;
            --text-muted: #8b9bb4;
            --text-dim: #526079;
            --border: rgba(255, 255, 255, 0.07);
            --border-strong: rgba(255, 255, 255, 0.14);
            --accent: #6366f1;
            --accent-light: #818cf8;
            --accent-glow: rgba(99, 102, 241, 0.32);
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --panel-shadow: 0 30px 60px -15px rgba(0, 0, 0, 0.75);
        }

        :root[data-theme="light"] {
            --bg-base: #eef2f7;
            --bg-surface: rgba(255, 255, 255, 0.88);
            --bg-elevated: #ffffff;
            --bg-elevated-hover: #f8fafc;
            --bg-input: #f1f5f9;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-dim: #94a3b8;
            --border: rgba(15, 23, 42, 0.08);
            --border-strong: rgba(15, 23, 42, 0.15);
            --accent: #4f46e5;
            --accent-light: #6366f1;
            --accent-glow: rgba(79, 70, 229, 0.2);
            --success: #059669;
            --warning: #d97706;
            --danger: #dc2626;
            --panel-shadow: 0 20px 50px -12px rgba(15, 23, 42, 0.1);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-base);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            background-image:
                    radial-gradient(circle at 8% 12%, rgba(99, 102, 241, 0.16), transparent 40%),
                    radial-gradient(circle at 92% 18%, rgba(16, 185, 129, 0.12), transparent 38%),
                    radial-gradient(circle at 50% 95%, rgba(168, 85, 247, 0.14), transparent 45%),
                    linear-gradient(var(--border) 1px, transparent 1px),
                    linear-gradient(90deg, var(--border) 1px, transparent 1px);
            background-size: 100% 100%, 100% 100%, 100% 100%, 40px 40px, 40px 40px;
        }

        /* TOP NAVIGATION BAR */
        .topbar {
            height: 64px;
            padding: 0 28px;
            background: var(--bg-surface);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
            font-weight: 800;
            font-size: 18px;
            letter-spacing: -0.5px;
        }

        .brand-badge {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            background: linear-gradient(135deg, #6366f1, #a855f7, #ec4899);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            box-shadow: 0 6px 18px var(--accent-glow);
        }

        .version-pill {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 9px;
            border-radius: 999px;
            background: rgba(99, 102, 241, 0.15);
            color: var(--accent-light);
            border: 1px solid rgba(99, 102, 241, 0.3);
        }

        .cmd-trigger {
            display: flex;
            align-items: center;
            gap: 28px;
            padding: 8px 14px;
            border-radius: 12px;
            background: var(--bg-input);
            border: 1px solid var(--border);
            color: var(--text-muted);
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .cmd-trigger:hover {
            border-color: var(--accent);
            color: var(--text-main);
        }

        .kbd {
            font-family: 'JetBrains Mono', monospace;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 6px;
            background: var(--bg-elevated);
            border: 1px solid var(--border-strong);
            color: var(--text-muted);
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .live-clock {
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            font-weight: 700;
            padding: 7px 13px;
            border-radius: 10px;
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            color: var(--text-main);
        }

        .icon-btn {
            height: 38px;
            padding: 0 12px;
            border-radius: 10px;
            border: 1px solid var(--border);
            background: var(--bg-elevated);
            color: var(--text-main);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12.5px;
            font-weight: 600;
            font-family: inherit;
            transition: all 0.2s;
        }

        .icon-btn:hover {
            border-color: var(--accent);
            transform: translateY(-1px);
        }

        /* APP SHELL (3-COLUMN ENTERPRISE GRID) */
        .app-shell {
            width: 100%;
            max-width: 1480px;
            margin: 24px auto;
            padding: 0 24px;
            display: grid;
            grid-template-columns: 270px 1fr 310px;
            gap: 22px;
            flex: 1;
        }

        @media (max-width: 1200px) {
            .app-shell { grid-template-columns: 250px 1fr; }
            .right-panel { grid-column: 1 / -1; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        }

        @media (max-width: 860px) {
            .app-shell { grid-template-columns: 1fr; }
            .right-panel { grid-template-columns: 1fr; }
            .cmd-trigger { display: none; }
        }

        .panel {
            background: var(--bg-surface);
            backdrop-filter: blur(22px);
            border: 1px solid var(--border);
            border-radius: 22px;
            box-shadow: var(--panel-shadow);
        }

        /* LEFT NAVIGATION & PROFILE SIDEBAR */
        .left-sidebar {
            padding: 22px 18px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            height: fit-content;
        }

        .user-card {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px;
            border-radius: 16px;
            background: var(--bg-elevated);
            border: 1px solid var(--border);
        }

        .user-avatar {
            width: 44px;
            height: 44px;
            border-radius: 13px;
            background: linear-gradient(135deg, #4f46e5, #ec4899);
            color: white;
            font-weight: 800;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .user-meta h3 {
            font-size: 14.5px;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 155px;
        }

        .user-meta span {
            font-size: 11.5px;
            color: var(--success);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-top: 3px;
        }

        .nav-group-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--text-dim);
            padding: 0 10px;
            margin-bottom: 6px;
        }

        .nav-list {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 12px;
            border-radius: 12px;
            border: 1px solid transparent;
            background: transparent;
            color: var(--text-muted);
            font-size: 13.5px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.18s;
            text-align: left;
            width: 100%;
        }

        .nav-item:hover {
            background: var(--bg-elevated);
            color: var(--text-main);
        }

        .nav-item.active {
            background: rgba(99, 102, 241, 0.15);
            color: var(--accent-light);
            border-color: rgba(99, 102, 241, 0.3);
        }

        .nav-item-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-count {
            font-family: 'JetBrains Mono', monospace;
            font-size: 11.5px;
            padding: 2px 8px;
            border-radius: 99px;
            background: var(--bg-input);
            color: var(--text-muted);
        }

        .dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            display: inline-block;
        }

        .logout-btn {
            margin-top: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px;
            border-radius: 13px;
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.22);
            color: #f87171;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s;
        }

        .logout-btn:hover {
            background: var(--danger);
            color: white;
        }

        /* CENTER MAIN WORKSPACE */
        .center-workspace {
            padding: 26px 28px;
            display: flex;
            flex-direction: column;
            gap: 22px;
        }

        .workspace-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
        }

        .workspace-title h1 {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .workspace-title p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 3px;
        }

        .view-switcher {
            display: flex;
            background: var(--bg-input);
            padding: 4px;
            border-radius: 12px;
            border: 1px solid var(--border);
            gap: 4px;
        }

        .view-btn {
            padding: 7px 13px;
            border-radius: 9px;
            border: none;
            background: transparent;
            color: var(--text-muted);
            font-size: 12.5px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .view-btn.active {
            background: var(--accent);
            color: white;
            box-shadow: 0 4px 12px var(--accent-glow);
        }

        /* KPI ROW */
        .kpi-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        @media (max-width: 700px) {
            .kpi-row { grid-template-columns: repeat(2, 1fr); }
        }

        .kpi-box {
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 14px 16px;
            display: flex;
            flex-direction: column;
            gap: 6px;
            position: relative;
            overflow: hidden;
        }

        .kpi-box::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--kpi-color, var(--accent));
            opacity: 0.7;
        }

        .kpi-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 11.5px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .kpi-val {
            font-size: 24px;
            font-weight: 800;
            font-family: 'JetBrains Mono', monospace;
        }

        /* SMART TASK COMPOSER */
        .composer-box {
            background: var(--bg-elevated);
            border: 1px solid var(--border-strong);
            border-radius: 18px;
            padding: 16px;
            transition: all 0.2s;
        }

        .composer-box:focus-within {
            border-color: var(--accent);
            box-shadow: 0 0 0 4px var(--accent-glow);
        }

        .composer-main {
            display: flex;
            gap: 10px;
        }

        .composer-input {
            flex: 1;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 13px 16px;
            color: var(--text-main);
            font-size: 14.5px;
            font-family: inherit;
            outline: none;
        }

        .composer-submit {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 0 22px;
            font-weight: 700;
            font-size: 13.5px;
            font-family: inherit;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 8px 20px -4px var(--accent-glow);
            transition: all 0.2s;
        }

        .composer-submit:hover {
            transform: translateY(-1px);
            filter: brightness(1.1);
        }

        .composer-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid var(--border);
        }

        .meta-selectors {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .meta-select, .meta-date {
            background: var(--bg-input);
            border: 1px solid var(--border);
            color: var(--text-main);
            padding: 6px 11px;
            border-radius: 9px;
            font-size: 12px;
            font-weight: 600;
            font-family: inherit;
            outline: none;
            cursor: pointer;
        }

        .meta-select:focus, .meta-date:focus {
            border-color: var(--accent);
        }

        .composer-hint {
            font-size: 11.5px;
            color: var(--text-dim);
        }

        /* FILTER & SEARCH BAR */
        .control-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .search-wrap {
            position: relative;
            flex: 1;
            min-width: 220px;
        }

        .search-wrap input {
            width: 100%;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 10px 14px 10px 38px;
            color: var(--text-main);
            font-size: 13px;
            font-family: inherit;
            outline: none;
        }

        .search-wrap input:focus {
            border-color: var(--accent);
        }

        .search-wrap svg {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }

        .sort-select {
            background: var(--bg-input);
            border: 1px solid var(--border);
            color: var(--text-main);
            padding: 9px 13px;
            border-radius: 11px;
            font-size: 12.5px;
            font-weight: 600;
            font-family: inherit;
            outline: none;
            cursor: pointer;
        }

        /* TASK LIST & KANBAN BOARD */
        .tasks-container.list-view {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .tasks-container.kanban-view {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            align-items: start;
        }

        @media (max-width: 700px) {
            .tasks-container.kanban-view { grid-template-columns: 1fr; }
        }

        .kanban-col {
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 14px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-height: 260px;
        }

        .kanban-col-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12.5px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            padding: 4px 6px 10px;
            border-bottom: 1px solid var(--border);
            color: var(--text-muted);
        }

        .task-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 15px 18px;
            border-radius: 15px;
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            transition: all 0.2s ease;
            position: relative;
        }

        .task-card:hover {
            background: var(--bg-elevated-hover);
            border-color: var(--border-strong);
            transform: translateY(-2px);
            box-shadow: 0 12px 24px -10px rgba(0, 0, 0, 0.35);
        }

        .task-card.is-done {
            opacity: 0.68;
        }

        .task-left {
            display: flex;
            align-items: flex-start;
            gap: 13px;
            flex: 1;
            min-width: 0;
        }

        .check-btn {
            width: 24px;
            height: 24px;
            margin-top: 2px;
            border-radius: 8px;
            border: 2px solid var(--text-muted);
            background: transparent;
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: all 0.2s;
        }

        .check-btn:hover {
            border-color: var(--accent);
            transform: scale(1.08);
        }

        .task-card.is-done .check-btn {
            background: var(--success);
            border-color: var(--success);
        }

        .task-body {
            display: flex;
            flex-direction: column;
            gap: 7px;
            min-width: 0;
            flex: 1;
        }

        .task-title {
            font-size: 14.5px;
            font-weight: 600;
            color: var(--text-main);
            word-break: break-word;
            line-height: 1.4;
        }

        .task-card.is-done .task-title {
            text-decoration: line-through;
            color: var(--text-muted);
        }

        .task-badges {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }

        .badge {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 9px;
            border-radius: 7px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .prio-HIGH { background: rgba(239, 68, 68, 0.16); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.3); }
        .prio-MEDIUM { background: rgba(245, 158, 11, 0.16); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.3); }
        .prio-LOW { background: rgba(16, 185, 129, 0.16); color: #34d399; border: 1px solid rgba(16, 185, 129, 0.3); }

        .cat-badge {
            background: rgba(99, 102, 241, 0.14);
            color: var(--accent-light);
            border: 1px solid rgba(99, 102, 241, 0.25);
        }

        .date-badge {
            font-family: 'JetBrains Mono', monospace;
            background: var(--bg-input);
            color: var(--text-muted);
            border: 1px solid var(--border);
        }

        .task-actions {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .del-btn {
            width: 34px;
            height: 34px;
            border-radius: 9px;
            border: 1px solid transparent;
            background: transparent;
            color: var(--text-muted);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .del-btn:hover {
            background: rgba(239, 68, 68, 0.15);
            color: var(--danger);
            border-color: rgba(239, 68, 68, 0.3);
        }

        /* RIGHT ANALYTICS & FOCUS PANEL */
        .right-panel {
            display: flex;
            flex-direction: column;
            gap: 20px;
            height: fit-content;
        }

        .widget-card {
            padding: 22px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .widget-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .widget-title {
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: var(--text-muted);
        }

        /* Ring Progress */
        .ring-box {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .ring-wrap {
            position: relative;
            width: 84px;
            height: 84px;
            flex-shrink: 0;
        }

        .ring-svg {
            transform: rotate(-90deg);
            width: 84px;
            height: 84px;
        }

        .ring-bg { fill: none; stroke: var(--border-strong); stroke-width: 8; }
        .ring-fill {
            fill: none;
            stroke: url(#ringGrad);
            stroke-width: 8;
            stroke-linecap: round;
            stroke-dasharray: 220;
            stroke-dashoffset: <%= 220 - (220 * progressPercent / 100) %>;
            transition: stroke-dashoffset 0.8s ease;
        }

        .ring-center {
            position: absolute;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'JetBrains Mono', monospace;
            font-size: 16px;
            font-weight: 800;
        }

        .ring-details h4 {
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .ring-details p {
            font-size: 12.5px;
            color: var(--text-muted);
            line-height: 1.45;
        }

        /* Pomodoro Focus Studio */
        .pomo-modes {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 6px;
            background: var(--bg-input);
            padding: 4px;
            border-radius: 11px;
            border: 1px solid var(--border);
        }

        .pomo-mode-btn {
            padding: 6px;
            border-radius: 8px;
            border: none;
            background: transparent;
            color: var(--text-muted);
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
        }

        .pomo-mode-btn.active {
            background: var(--accent);
            color: white;
        }

        .pomo-clock {
            font-family: 'JetBrains Mono', monospace;
            font-size: 42px;
            font-weight: 800;
            text-align: center;
            letter-spacing: 2px;
            padding: 10px 0;
            color: var(--text-main);
        }

        .pomo-actions {
            display: flex;
            gap: 8px;
        }

        .pomo-btn {
            flex: 1;
            padding: 10px;
            border-radius: 11px;
            border: 1px solid var(--border);
            background: var(--bg-elevated);
            color: var(--text-main);
            font-weight: 700;
            font-size: 13px;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.2s;
        }

        .pomo-btn.primary {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            border-color: transparent;
            box-shadow: 0 6px 16px var(--accent-glow);
        }

        .sound-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 13px;
            border-radius: 12px;
            background: var(--bg-input);
            border: 1px solid var(--border);
            font-size: 12.5px;
            font-weight: 600;
        }

        .sound-toggle {
            padding: 5px 11px;
            border-radius: 8px;
            border: 1px solid var(--border-strong);
            background: var(--bg-elevated);
            color: var(--text-main);
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
        }

        .sound-toggle.playing {
            background: rgba(16, 185, 129, 0.2);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.4);
        }

        /* Scratchpad Notes */
        .scratchpad {
            width: 100%;
            min-height: 110px;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px;
            color: var(--text-main);
            font-family: inherit;
            font-size: 12.5px;
            line-height: 1.5;
            resize: vertical;
            outline: none;
        }

        .scratchpad:focus {
            border-color: var(--accent);
        }

        /* Empty State */
        .empty-box {
            text-align: center;
            padding: 48px 20px;
            border: 1.5px dashed var(--border-strong);
            border-radius: 18px;
            background: var(--bg-elevated);
        }

        .empty-box h3 { font-size: 17px; font-weight: 700; margin: 12px 0 6px; }
        .empty-box p { font-size: 13px; color: var(--text-muted); }

        /* COMMAND PALETTE MODAL (Ctrl+K) */
        .cmd-overlay {
            position: fixed;
            inset: 0;
            background: rgba(3, 6, 15, 0.72);
            backdrop-filter: blur(8px);
            display: none;
            align-items: flex-start;
            justify-content: center;
            padding-top: 12vh;
            z-index: 100;
        }

        .cmd-overlay.open { display: flex; }

        .cmd-modal {
            width: 100%;
            max-width: 540px;
            background: var(--bg-surface);
            border: 1px solid var(--border-strong);
            border-radius: 20px;
            box-shadow: 0 30px 70px rgba(0, 0, 0, 0.8);
            overflow: hidden;
        }

        .cmd-header {
            padding: 16px 18px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .cmd-header input {
            flex: 1;
            background: transparent;
            border: none;
            color: var(--text-main);
            font-size: 15px;
            font-family: inherit;
            outline: none;
        }

        .cmd-list {
            padding: 10px;
            max-height: 320px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .cmd-item {
            padding: 11px 14px;
            border-radius: 11px;
            border: none;
            background: transparent;
            color: var(--text-main);
            font-size: 13.5px;
            font-weight: 600;
            font-family: inherit;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            text-align: left;
        }

        .cmd-item:hover {
            background: var(--accent);
            color: white;
        }
    </style>
</head>
<body>

<!-- TOPBAR -->
<header class="topbar">
    <div class="topbar-left">
        <div class="brand">
            <div class="brand-badge">
                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
            </div>
            <span>TaskOS</span>
            <span class="version-pill">WORKSPACE 3.0</span>
        </div>

        <div class="cmd-trigger" onclick="openCmdPalette()">
            <span>🔍 Tezkor buyruqlar va qidiruv...</span>
            <span class="kbd">Ctrl + K</span>
        </div>
    </div>

    <div class="topbar-right">
        <div class="live-clock" id="liveClock">00:00:00</div>
        <button type="button" class="icon-btn" onclick="exportTasksCSV()" title="CSV formatda yuklab olish">
            ⬇ Eksport (.CSV)
        </button>
        <button type="button" class="icon-btn" onclick="toggleTheme()" title="Tungi / Kunduzgi rejim">
            🌓 Mavzu
        </button>
    </div>
</header>

<!-- 3-COLUMN ENTERPRISE WORKSPACE -->
<div class="app-shell">

    <!-- 1. LEFT SIDEBAR -->
    <aside class="panel left-sidebar">
        <div class="user-card">
            <div class="user-avatar"><%= initial %></div>
            <div class="user-meta">
                <h3><%= displayName %></h3>
                <span>● Pro Developer</span>
            </div>
        </div>

        <div>
            <div class="nav-group-label">Ko'rinishlar</div>
            <div class="nav-list">
                <button type="button" class="nav-item active" onclick="setStatusFilter('all', this)">
                    <span class="nav-item-left">📥 Barcha vazifalar</span>
                    <span class="nav-count"><%= totalCount %></span>
                </button>
                <button type="button" class="nav-item" onclick="setStatusFilter('active', this)">
                    <span class="nav-item-left">⚡ Jarayonda (Faol)</span>
                    <span class="nav-count"><%= activeCount %></span>
                </button>
                <button type="button" class="nav-item" onclick="setStatusFilter('completed', this)">
                    <span class="nav-item-left">✅ Bajarilganlar</span>
                    <span class="nav-count"><%= completedCount %></span>
                </button>
            </div>
        </div>

        <div>
            <div class="nav-group-label">Muhimlik darajasi</div>
            <div class="nav-list">
                <button type="button" class="nav-item" onclick="setPriorityFilter('HIGH', this)">
                    <span class="nav-item-left"><span class="dot" style="background:#ef4444"></span> Yuqori (High)</span>
                </button>
                <button type="button" class="nav-item" onclick="setPriorityFilter('MEDIUM', this)">
                    <span class="nav-item-left"><span class="dot" style="background:#f59e0b"></span> O'rta (Medium)</span>
                </button>
                <button type="button" class="nav-item" onclick="setPriorityFilter('LOW', this)">
                    <span class="nav-item-left"><span class="dot" style="background:#10b981"></span> Past (Low)</span>
                </button>
            </div>
        </div>

        <div>
            <div class="nav-group-label">Kategoriyalar</div>
            <div class="nav-list">
                <button type="button" class="nav-item" onclick="setCategoryFilter('Backend', this)">
                    <span class="nav-item-left">💻 Backend / Java</span>
                </button>
                <button type="button" class="nav-item" onclick="setCategoryFilter('Frontend', this)">
                    <span class="nav-item-left">🎨 Frontend / UI</span>
                </button>
                <button type="button" class="nav-item" onclick="setCategoryFilter('O\'qish', this)">
                    <span class="nav-item-left">📚 O'qish / Kurs</span>
                </button>
                <button type="button" class="nav-item" onclick="setCategoryFilter('Shaxsiy', this)">
                    <span class="nav-item-left">🎯 Shaxsiy reja</span>
                </button>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            Tizimdan chiqish
        </a>
    </aside>

    <!-- 2. CENTER MAIN WORKSPACE -->
    <main class="panel center-workspace">
        <div class="workspace-header">
            <div class="workspace-title">
                <h1>Xush kelibsiz, <%= displayName.split(" ")[0] %>! 👋</h1>
                <p id="fullDateSub">Bugungi sprint va vazifalar boshqaruv markazi</p>
            </div>

            <div class="view-switcher">
                <button type="button" class="view-btn active" id="btnListView" onclick="switchView('list')">
                    ☰ Ro'yxat
                </button>
                <button type="button" class="view-btn" id="btnKanbanView" onclick="switchView('kanban')">
                    ⊞ Kanban Doska
                </button>
            </div>
        </div>

        <!-- 4 KPI ANALYTICS CARDS -->
        <div class="kpi-row">
            <div class="kpi-box" style="--kpi-color: #6366f1;">
                <div class="kpi-top"><span>Jami</span><span>📋</span></div>
                <div class="kpi-val"><%= totalCount %></div>
            </div>
            <div class="kpi-box" style="--kpi-color: #f59e0b;">
                <div class="kpi-top"><span>Jarayonda</span><span>⏳</span></div>
                <div class="kpi-val"><%= activeCount %></div>
            </div>
            <div class="kpi-box" style="--kpi-color: #10b981;">
                <div class="kpi-top"><span>Bajarildi</span><span>✅</span></div>
                <div class="kpi-val"><%= completedCount %></div>
            </div>
            <div class="kpi-box" style="--kpi-color: #ec4899;">
                <div class="kpi-top"><span>Samaradorlik</span><span>📈</span></div>
                <div class="kpi-val"><%= progressPercent %>%</div>
            </div>
        </div>

        <!-- SMART TASK COMPOSER (Encodes Priority, Category, Date into Title automatically) -->
        <div class="composer-box">
            <form id="smartAddForm" action="${pageContext.request.contextPath}/todos" method="post" onsubmit="prepareSmartTitle(event)">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="title" id="finalEncodedTitle">

                <div class="composer-main">
                    <input type="text" id="rawTitleInput" class="composer-input"
                           placeholder="Yangi vazifa kiriting... (Masalan: Hibernate DAO qatlamini optimallashtirish)" required autocomplete="off">
                    <button type="submit" class="composer-submit">
                        <span>+ Vazifa qo'shish</span>
                    </button>
                </div>

                <div class="composer-meta">
                    <div class="meta-selectors">
                        <select id="prioSelect" class="meta-select" title="Muhimlik darajasi">
                            <option value="HIGH">🔴 Yuqori (High)</option>
                            <option value="MEDIUM" selected>🟡 O'rta (Medium)</option>
                            <option value="LOW">🟢 Past (Low)</option>
                        </select>

                        <select id="catSelect" class="meta-select" title="Kategoriya">
                            <option value="Backend">💻 Backend</option>
                            <option value="Frontend">🎨 Frontend</option>
                            <option value="O'qish">📚 O'qish</option>
                            <option value="Shaxsiy">🎯 Shaxsiy</option>
                        </select>

                        <input type="date" id="dateSelect" class="meta-date" title="Muddat (ixtiyoriy)">
                    </div>
                    <span class="composer-hint">Tezkor qo'shish uchun <b>Enter</b> bosing</span>
                </div>
            </form>
        </div>

        <!-- SEARCH & SORT TOOLBAR -->
        <div class="control-bar">
            <div class="search-wrap">
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                <input type="text" id="searchBox" placeholder="Vazifa nomi, teg yoki sana bo'yicha qidirish... ('/' bosing)" oninput="applyAllFilters()">
            </div>

            <select id="sortSelect" class="sort-select" onchange="sortTasks()">
                <option value="default">🔃 Tartib: Standart</option>
                <option value="priority">🔥 Muhimligi bo'yicha</option>
                <option value="alpha">🔤 Alifbo (A-Z)</option>
            </select>
        </div>

        <!-- TASKS CONTAINER (Supports both List & Kanban Board) -->
        <% if (todos == null || todos.isEmpty()) { %>
        <div class="empty-box">
            <div style="font-size: 42px;">🚀</div>
            <h3>Ish stoli hozircha toza!</h3>
            <p>Yuqoridagi paneldan muhimlik darajasi va kategoriyani tanlab birinchi vazifangizni yarating.</p>
        </div>
        <% } else { %>
        <div id="tasksViewport" class="tasks-container list-view">
            <div id="colActive" class="kanban-col-wrapper">
                <div class="kanban-col-header" style="display:none;" id="headerActive">
                    <span>⚡ JARAYONDA</span>
                    <span><%= activeCount %></span>
                </div>
                <div id="listActive" style="display:flex; flex-direction:column; gap:10px;">
                    <% for (Todo todo : todos) {
                        if (!todo.isCompleted()) { %>
                    <div class="task-card"
                         data-id="<%= todo.getId() %>"
                         data-status="active"
                         data-raw="<%= todo.getTitle().replace("\"", "&quot;") %>">
                        <div class="task-left">
                            <form action="${pageContext.request.contextPath}/todos" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="<%= todo.getId() %>">
                                <button type="submit" class="check-btn" title="Bajarildi deb belgilash"></button>
                            </form>
                            <div class="task-body">
                                <div class="task-title"><%= todo.getTitle() %></div>
                                <div class="task-badges"></div>
                            </div>
                        </div>
                        <div class="task-actions">
                            <form action="${pageContext.request.contextPath}/todos" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= todo.getId() %>">
                                <button type="submit" class="del-btn" title="O'chirish">
                                    <svg width="17" height="17" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                    </svg>
                                </button>
                            </form>
                        </div>
                    </div>
                    <%  }
                    } %>
                </div>
            </div>

            <div id="colCompleted" class="kanban-col-wrapper">
                <div class="kanban-col-header" style="display:none;" id="headerCompleted">
                    <span>✅ BAJARILGAN</span>
                    <span><%= completedCount %></span>
                </div>
                <div id="listCompleted" style="display:flex; flex-direction:column; gap:10px;">
                    <% for (Todo todo : todos) {
                        if (todo.isCompleted()) { %>
                    <div class="task-card is-done"
                         data-id="<%= todo.getId() %>"
                         data-status="completed"
                         data-raw="<%= todo.getTitle().replace("\"", "&quot;") %>">
                        <div class="task-left">
                            <form action="${pageContext.request.contextPath}/todos" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="<%= todo.getId() %>">
                                <button type="submit" class="check-btn" title="Faol holatga qaytarish">
                                    <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                                    </svg>
                                </button>
                            </form>
                            <div class="task-body">
                                <div class="task-title"><%= todo.getTitle() %></div>
                                <div class="task-badges"></div>
                            </div>
                        </div>
                        <div class="task-actions">
                            <form action="${pageContext.request.contextPath}/todos" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= todo.getId() %>">
                                <button type="submit" class="del-btn" title="O'chirish">
                                    <svg width="17" height="17" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                    </svg>
                                </button>
                            </form>
                        </div>
                    </div>
                    <%  }
                    } %>
                </div>
            </div>
        </div>
        <% } %>
    </main>

    <!-- 3. RIGHT ANALYTICS & FOCUS STUDIO -->
    <aside class="right-panel">
        <!-- Ring Progress Widget -->
        <div class="panel widget-card">
            <div class="widget-header">
                <span class="widget-title">📊 Kunlik Progress</span>
                <span class="version-pill"><%= completedCount %> / <%= totalCount %></span>
            </div>
            <div class="ring-box">
                <div class="ring-wrap">
                    <svg class="ring-svg" viewBox="0 0 84 84">
                        <defs>
                            <linearGradient id="ringGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                <stop offset="0%" stop-color="#6366f1"/>
                                <stop offset="100%" stop-color="#10b981"/>
                            </linearGradient>
                        </defs>
                        <circle class="ring-bg" cx="42" cy="42" r="35"></circle>
                        <circle class="ring-fill" cx="42" cy="42" r="35"></circle>
                    </svg>
                    <div class="ring-center"><%= progressPercent %>%</div>
                </div>
                <div class="ring-details">
                    <h4><%= progressPercent == 100 && totalCount > 0 ? "Ajoyib natija! 🎉" : "Davom eting!" %></h4>
                    <p>Yana <%= activeCount %> ta vazifa bajarilsa kunlik reja 100% yopiladi.</p>
                </div>
            </div>
        </div>

        <!-- Pomodoro & Ambient Sound Studio -->
        <div class="panel widget-card">
            <div class="widget-header">
                <span class="widget-title">⏱ Fokus Studiyasi</span>
            </div>

            <div class="pomo-modes">
                <button type="button" class="pomo-mode-btn active" onclick="setPomoMode(25, this)">Pomodoro 25</button>
                <button type="button" class="pomo-mode-btn" onclick="setPomoMode(50, this)">Deep 50</button>
                <button type="button" class="pomo-mode-btn" onclick="setPomoMode(5, this)">Dam 5</button>
            </div>

            <div class="pomo-clock" id="pomoClock">25:00</div>

            <div class="pomo-actions">
                <button type="button" class="pomo-btn primary" id="pomoStartBtn" onclick="togglePomo()">▶ Boshlash</button>
                <button type="button" class="pomo-btn" onclick="resetPomo()">↺ Qayta</button>
            </div>

            <div class="sound-bar">
                <span>🎧 Fokus shovqini (Ambient)</span>
                <button type="button" class="sound-toggle" id="soundBtn" onclick="toggleAmbientNoise()">Yoqish</button>
            </div>
        </div>

        <!-- Quick Scratchpad (Local Storage) -->
        <div class="panel widget-card">
            <div class="widget-header">
                <span class="widget-title">📝 Tezkor Qaydlar (Scratchpad)</span>
            </div>
            <textarea id="quickNotes" class="scratchpad" placeholder="Muhim kod parchalari, fikrlar yoki eslatmalarni shu yerga yozing (avtomatik saqlanadi)..."></textarea>
        </div>
    </aside>
</div>

<!-- COMMAND PALETTE MODAL (Ctrl + K) -->
<div class="cmd-overlay" id="cmdOverlay" onclick="if(event.target===this) closeCmdPalette()">
    <div class="cmd-modal">
        <div class="cmd-header">
            <span>⚡</span>
            <input type="text" id="cmdInput" placeholder="Buyruqni tanlang yoki qidiring..." oninput="filterCmdList()">
            <span class="kbd" onclick="closeCmdPalette()" style="cursor:pointer;">ESC</span>
        </div>
        <div class="cmd-list" id="cmdList">
            <button type="button" class="cmd-item" onclick="document.getElementById('rawTitleInput').focus(); closeCmdPalette();">
                <span>➕ Yangi vazifa yaratish</span><span class="kbd">N</span>
            </button>
            <button type="button" class="cmd-item" onclick="switchView('kanban'); closeCmdPalette();">
                <span>⊞ Kanban Doska rejimiga o'tish</span><span class="kbd">Board</span>
            </button>
            <button type="button" class="cmd-item" onclick="switchView('list'); closeCmdPalette();">
                <span>☰ Ro'yxat rejimiga o'tish</span><span class="kbd">List</span>
            </button>
            <button type="button" class="cmd-item" onclick="togglePomo(); closeCmdPalette();">
                <span>⏱ Fokus taymerni boshlash / to'xtatish</span><span class="kbd">Timer</span>
            </button>
            <button type="button" class="cmd-item" onclick="toggleTheme(); closeCmdPalette();">
                <span>🌓 Tungi / Kunduzgi mavzuni almashtirish</span><span class="kbd">Theme</span>
            </button>
            <button type="button" class="cmd-item" onclick="exportTasksCSV(); closeCmdPalette();">
                <span>⬇ Vazifalarni CSV (Excel) formatda yuklash</span><span class="kbd">Export</span>
            </button>
        </div>
    </div>
</div>

<script>
    // 1. THEME ENGINE
    const savedTheme = localStorage.getItem('taskos_theme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);

    function toggleTheme() {
        const next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        localStorage.setItem('taskos_theme', next);
    }

    // 2. LIVE CLOCK & UZBEK DATE
    function updateClock() {
        const now = new Date();
        document.getElementById('liveClock').innerText = now.toTimeString().split(' ')[0];
    }
    setInterval(updateClock, 1000);
    updateClock();

    // 3. SMART METADATA ENCODER & PARSER ([HIGH][Backend][2026-11-20] Title)
    function prepareSmartTitle(e) {
        const raw = document.getElementById('rawTitleInput').value.trim();
        const prio = document.getElementById('prioSelect').value;
        const cat = document.getElementById('catSelect').value;
        const date = document.getElementById('dateSelect').value;

        let prefix = '[' + prio + '][' + cat + ']';
        if (date) prefix += '[' + date + ']';

        document.getElementById('finalEncodedTitle').value = prefix + ' ' + raw;
    }

    function parseAllTaskCards() {
        const regex = /^\[(HIGH|MEDIUM|LOW)\]\[([^\]]+)\](?:\[(\d{4}-\d{2}-\d{2})\])?\s*(.*)$/;
        const prioLabels = { HIGH: '🔴 Yuqori', MEDIUM: '🟡 O\'rta', LOW: '🟢 Past' };
        const prioWeights = { HIGH: 3, MEDIUM: 2, LOW: 1 };

        document.querySelectorAll('.task-card').forEach(card => {
            const raw = card.getAttribute('data-raw') || '';
            const match = raw.match(regex);
            const titleEl = card.querySelector('.task-title');
            const badgesEl = card.querySelector('.task-badges');

            if (match) {
                const prio = match[1];
                const cat = match[2];
                const date = match[3] || '';
                const cleanTitle = match[4];

                card.dataset.prio = prio;
                card.dataset.prioWeight = prioWeights[prio] || 1;
                card.dataset.cat = cat;
                card.dataset.cleanTitle = cleanTitle;

                titleEl.innerText = cleanTitle;
                let badgesHTML = '<span class="badge prio-' + prio + '">' + prioLabels[prio] + '</span>' +
                    '<span class="badge cat-badge">#' + cat + '</span>';
                if (date) {
                    badgesHTML += '<span class="badge date-badge">📅 ' + date + '</span>';
                }
                badgesEl.innerHTML = badgesHTML;
            } else {
                card.dataset.prio = 'MEDIUM';
                card.dataset.prioWeight = 2;
                card.dataset.cat = 'Umumiy';
                card.dataset.cleanTitle = raw;
                badgesEl.innerHTML = '<span class="badge cat-badge">#Vazifa</span>';
            }
        });
    }
    parseAllTaskCards();

    // 4. LIST vs KANBAN VIEW SWITCHER
    function switchView(mode) {
        const vp = document.getElementById('tasksViewport');
        if (!vp) return;
        const colA = document.getElementById('colActive');
        const colC = document.getElementById('colCompleted');
        const headA = document.getElementById('headerActive');
        const headC = document.getElementById('headerCompleted');

        document.getElementById('btnListView').classList.toggle('active', mode === 'list');
        document.getElementById('btnKanbanView').classList.toggle('active', mode === 'kanban');

        if (mode === 'kanban') {
            vp.className = 'tasks-container kanban-view';
            colA.classList.add('kanban-col');
            colC.classList.add('kanban-col');
            headA.style.display = 'flex';
            headC.style.display = 'flex';
        } else {
            vp.className = 'tasks-container list-view';
            colA.classList.remove('kanban-col');
            colC.classList.remove('kanban-col');
            headA.style.display = 'none';
            headC.style.display = 'none';
        }
    }

    // 5. FILTERING & SORTING
    let activeStatus = 'all';
    let activePrio = 'all';
    let activeCat = 'all';

    function clearNavActive() {
        document.querySelectorAll('.nav-item').forEach(b => b.classList.remove('active'));
    }

    function setStatusFilter(status, btn) {
        activeStatus = status; activePrio = 'all'; activeCat = 'all';
        clearNavActive(); btn.classList.add('active');
        applyAllFilters();
    }

    function setPriorityFilter(prio, btn) {
        activeStatus = 'all'; activePrio = prio; activeCat = 'all';
        clearNavActive(); btn.classList.add('active');
        applyAllFilters();
    }

    function setCategoryFilter(cat, btn) {
        activeStatus = 'all'; activePrio = 'all'; activeCat = cat;
        clearNavActive(); btn.classList.add('active');
        applyAllFilters();
    }

    function applyAllFilters() {
        const q = (document.getElementById('searchBox')?.value || '').toLowerCase();
        document.querySelectorAll('.task-card').forEach(card => {
            const st = card.dataset.status;
            const pr = card.dataset.prio;
            const ct = card.dataset.cat;
            const raw = (card.dataset.raw || '').toLowerCase();

            const okStatus = (activeStatus === 'all' || st === activeStatus);
            const okPrio = (activePrio === 'all' || pr === activePrio);
            const okCat = (activeCat === 'all' || ct === activeCat);
            const okSearch = raw.includes(q);

            card.style.display = (okStatus && okPrio && okCat && okSearch) ? 'flex' : 'none';
        });
    }

    function sortTasks() {
        const mode = document.getElementById('sortSelect').value;
        ['listActive', 'listCompleted'].forEach(listId => {
            const container = document.getElementById(listId);
            if (!container) return;
            const items = Array.from(container.querySelectorAll('.task-card'));
            items.sort((a, b) => {
                if (mode === 'priority') {
                    return (Number(b.dataset.prioWeight) || 0) - (Number(a.dataset.prioWeight) || 0);
                } else if (mode === 'alpha') {
                    return (a.dataset.cleanTitle || '').localeCompare(b.dataset.cleanTitle || '');
                }
                return Number(a.dataset.id) - Number(b.dataset.id);
            });
            items.forEach(el => container.appendChild(el));
        });
    }

    // 6. POMODORO & WEB AUDIO AMBIENT FOCUS SOUND
    let pomoTotal = 25 * 60;
    let pomoLeft = 25 * 60;
    let pomoTimer = null;

    function renderPomo() {
        const m = String(Math.floor(pomoLeft / 60)).padStart(2, '0');
        const s = String(pomoLeft % 60).padStart(2, '0');
        document.getElementById('pomoClock').innerText = m + ':' + s;
    }

    function setPomoMode(mins, btn) {
        clearInterval(pomoTimer); pomoTimer = null;
        document.querySelectorAll('.pomo-mode-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        pomoTotal = mins * 60; pomoLeft = pomoTotal;
        renderPomo();
        document.getElementById('pomoStartBtn').innerText = '▶ Boshlash';
    }

    function togglePomo() {
        const btn = document.getElementById('pomoStartBtn');
        if (pomoTimer) {
            clearInterval(pomoTimer); pomoTimer = null;
            btn.innerText = '▶ Davom etish';
        } else {
            btn.innerText = '⏸ To\'xtatish';
            pomoTimer = setInterval(() => {
                if (pomoLeft > 0) {
                    pomoLeft--; renderPomo();
                } else {
                    clearInterval(pomoTimer); pomoTimer = null;
                    btn.innerText = '▶ Boshlash';
                    alert('Fokus sessiyasi yakunlandi!');
                }
            }, 1000);
        }
    }

    function resetPomo() {
        clearInterval(pomoTimer); pomoTimer = null;
        pomoLeft = pomoTotal; renderPomo();
        document.getElementById('pomoStartBtn').innerText = '▶ Boshlash';
    }

    // Web Audio API Brown/White Noise Generator for Deep Focus
    let audioCtx = null;
    let noiseNode = null;
    let isPlayingNoise = false;

    function toggleAmbientNoise() {
        const btn = document.getElementById('soundBtn');
        if (!isPlayingNoise) {
            audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            const bufferSize = 2 * audioCtx.sampleRate;
            const buffer = audioCtx.createBuffer(1, bufferSize, audioCtx.sampleRate);
            const output = buffer.getChannelData(0);
            let lastOut = 0.0;
            for (let i = 0; i < bufferSize; i++) {
                const white = Math.random() * 2 - 1;
                output[i] = (lastOut + (0.02 * white)) / 1.02;
                lastOut = output[i];
                output[i] *= 0.15; // soft comfortable volume
            }
            noiseNode = audioCtx.createBufferSource();
            noiseNode.buffer = buffer;
            noiseNode.loop = true;
            noiseNode.connect(audioCtx.destination);
            noiseNode.start(0);
            isPlayingNoise = true;
            btn.innerText = 'O\'chirish';
            btn.classList.add('playing');
        } else {
            if (noiseNode) noiseNode.stop();
            if (audioCtx) audioCtx.close();
            isPlayingNoise = false;
            btn.innerText = 'Yoqish';
            btn.classList.remove('playing');
        }
    }

    // 7. LOCALSTORAGE SCRATCHPAD
    const notesArea = document.getElementById('quickNotes');
    notesArea.value = localStorage.getItem('taskos_scratchpad') || '';
    notesArea.addEventListener('input', () => {
        localStorage.setItem('taskos_scratchpad', notesArea.value);
    });

    // 8. EXPORT TO CSV
    function exportTasksCSV() {
        let csv = 'ID,Vazifa,Muhimlik,Kategoriya,Holati\n';
        document.querySelectorAll('.task-card').forEach(c => {
            const id = c.dataset.id;
            const title = '"' + (c.dataset.cleanTitle || '').replace(/"/g, '""') + '"';
            const prio = c.dataset.prio || 'MEDIUM';
            const cat = c.dataset.cat || 'Umumiy';
            const st = c.dataset.status === 'completed' ? 'Bajarilgan' : 'Jarayonda';
            csv += [id, title, prio, cat, st].join(',') + '\n';
        });
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'taskos_vazifalar.csv';
        link.click();
    }

    // 9. COMMAND PALETTE (Ctrl + K) & SHORTCUTS
    function openCmdPalette() {
        document.getElementById('cmdOverlay').classList.add('open');
        document.getElementById('cmdInput').value = '';
        filterCmdList();
        setTimeout(() => document.getElementById('cmdInput').focus(), 50);
    }

    function closeCmdPalette() {
        document.getElementById('cmdOverlay').classList.remove('open');
    }

    function filterCmdList() {
        const q = document.getElementById('cmdInput').value.toLowerCase();
        document.querySelectorAll('.cmd-item').forEach(item => {
            item.style.display = item.innerText.toLowerCase().includes(q) ? 'flex' : 'none';
        });
    }

    document.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
            e.preventDefault();
            openCmdPalette();
        } else if (e.key === 'Escape') {
            closeCmdPalette();
        } else if (e.key === '/' && document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') {
            e.preventDefault();
            document.getElementById('searchBox')?.focus();
        }
    });
</script>

</body>
</html>