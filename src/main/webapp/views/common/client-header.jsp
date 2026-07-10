<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

<style>
    html,
    body,
    button,
    input,
    select,
    textarea {
        font-family: "Be Vietnam Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
    }

    .wv-header {
        position: sticky;
        top: 0;
        z-index: 9999;
        width: 100%;
        background: rgba(255, 255, 255, 0.96);
        border-bottom: 1px solid #e5eaf3;
        box-shadow: 0 12px 34px rgba(15, 23, 42, 0.055);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
    }

    .wv-header-inner {
        max-width: 1500px;
        min-height: 78px;
        margin: 0 auto;
        padding: 0 28px;
        display: grid;
        grid-template-columns: 210px 310px minmax(0, 1fr) auto;
        align-items: center;
        gap: 18px;
    }

    .wv-logo {
        display: inline-flex;
        align-items: center;
        text-decoration: none;
        white-space: nowrap;
    }

    .wv-logo-text {
        display: inline-flex;
        align-items: baseline;
        gap: 2px;
        font-size: 28px;
        line-height: 1;
        font-weight: 900;
        letter-spacing: 0;
    }

    .wv-logo-text span {
        color: #ef7169;
    }

    .wv-logo-text strong {
        color: #f3b43f;
        font-weight: 900;
    }

    .wv-search {
        height: 46px;
        min-width: 0;
        border-radius: 999px;
        border: 1px solid #dbe5f2;
        background: #f8fafc;
        display: flex;
        align-items: center;
        gap: 11px;
        padding: 0 16px;
        transition: 0.18s ease;
    }

    .wv-search:focus-within {
        border-color: #93c5fd;
        background: #ffffff;
        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
    }

    .wv-search i {
        color: #2563eb;
        font-size: 14px;
        flex: 0 0 auto;
    }

    .wv-search input {
        width: 100%;
        min-width: 0;
        border: 0;
        outline: 0;
        background: transparent;
        color: #0f172a;
        font-size: 13px;
        font-weight: 700;
    }

    .wv-search input::placeholder {
        color: #94a3b8;
        font-weight: 600;
    }

    .wv-nav {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: clamp(18px, 2vw, 30px);
        min-width: 0;
    }

    .wv-nav a {
        position: relative;
        color: #1e293b;
        text-decoration: none;
        white-space: nowrap;
        font-size: 12px;
        font-weight: 900;
        letter-spacing: 0.55px;
        text-transform: uppercase;
        line-height: 1;
        transition: 0.18s ease;
    }

    .wv-nav a::after {
        content: "";
        position: absolute;
        left: 0;
        right: 0;
        bottom: -14px;
        height: 3px;
        border-radius: 999px;
        background: #2563eb;
        opacity: 0;
        transform: scaleX(0.35);
        transition: 0.18s ease;
    }

    .wv-nav a:hover {
        color: #2563eb;
    }

    .wv-nav a:hover::after {
        opacity: 1;
        transform: scaleX(1);
    }

    .wv-actions {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 10px;
        white-space: nowrap;
    }

    .wv-auth-link {
        height: 44px;
        padding: 0 16px;
        border-radius: 999px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        font-size: 12px;
        font-weight: 900;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        transition: 0.18s ease;
    }

    .wv-auth-link.secondary {
        color: #2563eb;
        background: #ffffff;
        border: 1px solid #bfdbfe;
    }

    .wv-auth-link.primary {
        color: #ffffff;
        background: #2563eb;
        border: 1px solid #2563eb;
        box-shadow: 0 12px 22px rgba(37, 99, 235, 0.18);
    }

    .wv-auth-link:hover {
        transform: translateY(-1px);
    }

    .wv-user-menu {
        position: relative;
    }

    .wv-user-trigger {
        height: 48px;
        min-width: 0;
        padding: 0 10px 0 6px;
        border-radius: 999px;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        color: #0f172a;
        text-decoration: none;
        transition: 0.18s ease;
    }

    .wv-user-trigger:hover {
        background: #f1f5f9;
    }

    .wv-avatar {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #e2e8f0;
        background: #f8fafc;
    }

    .wv-user-name {
        max-width: 140px;
        color: #0f172a;
        font-size: 13px;
        font-weight: 900;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .wv-user-chevron {
        color: #64748b;
        font-size: 11px;
        flex: 0 0 auto;
    }

    .wv-dropdown {
        position: absolute;
        top: 56px;
        right: 0;
        width: 260px;
        background: #ffffff;
        border: 1px solid #edf2f7;
        border-radius: 16px;
        box-shadow: 0 22px 44px rgba(15, 23, 42, 0.14);
        overflow: hidden;
        opacity: 0;
        visibility: hidden;
        transform: translateY(10px);
        transition: 0.18s ease;
        z-index: 10000;
    }

    .wv-user-menu:hover .wv-dropdown,
    .wv-user-menu:focus-within .wv-dropdown {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .wv-dropdown-head {
        padding: 16px;
        background: #0f172a;
        color: #ffffff;
    }

    .wv-dropdown-name {
        font-size: 14px;
        font-weight: 900;
        line-height: 1.3;
    }

    .wv-dropdown-role {
        margin-top: 4px;
        color: #cbd5e1;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.45px;
    }

    .wv-dropdown a {
        display: flex;
        align-items: center;
        gap: 11px;
        min-height: 44px;
        padding: 0 16px;
        color: #334155;
        text-decoration: none;
        font-size: 13px;
        font-weight: 800;
        transition: 0.18s ease;
    }

    .wv-dropdown a i {
        width: 18px;
        text-align: center;
        color: #64748b;
    }

    .wv-dropdown a:hover {
        background: #f8fafc;
        color: #2563eb;
    }

    .wv-dropdown a:hover i {
        color: #2563eb;
    }

    .wv-dropdown-divider {
        height: 1px;
        background: #edf2f7;
        margin: 4px 0;
    }

    .wv-dropdown .danger {
        color: #dc2626;
    }

    .wv-dropdown .danger:hover {
        background: #fef2f2;
        color: #dc2626;
    }

    .wv-menu-button {
        display: none;
        width: 44px;
        height: 44px;
        border-radius: 12px;
        border: 1px solid #dbe5f2;
        background: #ffffff;
        color: #0f172a;
        cursor: pointer;
    }

    @media (max-width: 1180px) {
        .wv-header-inner {
            grid-template-columns: 190px 260px minmax(0, 1fr) auto;
            gap: 14px;
            padding: 0 22px;
        }

        .wv-nav {
            gap: 16px;
        }

        .wv-nav a {
            font-size: 11px;
        }
    }

    @media (max-width: 980px) {
        .wv-header-inner {
            min-height: 76px;
            display: flex;
            flex-wrap: wrap;
            padding: 14px 18px;
        }

        .wv-logo {
            flex: 0 0 auto;
        }

        .wv-logo-text {
            font-size: 25px;
        }

        .wv-actions {
            margin-left: auto;
        }

        .wv-search {
            order: 3;
            width: 100%;
            flex: 1 0 100%;
        }

        .wv-nav {
            order: 4;
            width: 100%;
            display: none;
            flex-direction: column;
            align-items: flex-start;
            gap: 16px;
            padding: 12px 0 4px;
        }

        .wv-nav.show {
            display: flex;
        }

        .wv-nav a::after {
            bottom: -7px;
        }

        .wv-user-name {
            display: none;
        }

        .wv-auth-link.secondary {
            display: none;
        }

        .wv-menu-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
    }

    @media (max-width: 560px) {
        .wv-header-inner {
            padding: 12px 14px;
        }

        .wv-auth-link.primary {
            width: 44px;
            padding: 0;
        }

        .wv-auth-link.primary span {
            display: none;
        }

        .wv-dropdown {
            right: -48px;
            width: 246px;
        }
    }
</style>

<header class="wv-header">
    <div class="wv-header-inner">
        <a class="wv-logo" href="${pageContext.request.contextPath}/home">
            <span class="wv-logo-text">
                <span>Wonder</span><strong>VN</strong>
            </span>
        </a>

        <form class="wv-search" action="${pageContext.request.contextPath}/accommodation" method="get">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="keyword" placeholder="Bạn muốn đi đâu?">
        </form>

        <nav class="wv-nav" id="wvMainNav">
            <a href="${pageContext.request.contextPath}/tour">Tour trọn gói</a>
            <a href="${pageContext.request.contextPath}/tour">Đặt tour</a>
            <a href="${pageContext.request.contextPath}/accommodation">Lưu trú</a>
        </nav>

        <div class="wv-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="wv-user-menu">
                        <a class="wv-user-trigger" href="${pageContext.request.contextPath}/profile">
                            <img class="wv-avatar"
                                 src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
                                 alt="Avatar">
                            <span class="wv-user-name">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </span>
                            <i class="fa-solid fa-chevron-down wv-user-chevron"></i>
                        </a>

                        <div class="wv-dropdown">
                            <div class="wv-dropdown-head">
                                <div class="wv-dropdown-name">
                                    ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                                </div>
                                <div class="wv-dropdown-role">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleName == 'Tour Guide' || sessionScope.user.roleID == 3}">Hướng dẫn viên</c:when>
                                        <c:when test="${sessionScope.user.roleID == 1}">Quản trị viên</c:when>
                                        <c:when test="${sessionScope.user.roleID == 2}">Nhân viên</c:when>
                                        <c:otherwise>Khách hàng</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${sessionScope.user.roleName == 'Tour Guide' || sessionScope.user.roleID == 3}">
                                    <a href="${pageContext.request.contextPath}/guide/home">
                                        <i class="fa-solid fa-map-location-dot"></i>
                                        Trang hướng dẫn viên
                                    </a>
                                </c:when>
                                <c:when test="${sessionScope.user.roleID == 1}">
                                    <a href="${pageContext.request.contextPath}/admin/home">
                                        <i class="fa-solid fa-gauge-high"></i>
                                        Trang admin
                                    </a>
                                </c:when>
                                <c:when test="${sessionScope.user.roleID == 2}">
                                    <a href="${pageContext.request.contextPath}/staff/home">
                                        <i class="fa-solid fa-briefcase"></i>
                                        Trang staff
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/profile">
                                        <i class="fa-solid fa-user"></i>
                                        Hồ sơ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/booking-list">
                                        <i class="fa-solid fa-receipt"></i>
                                        Đơn booking
                                    </a>
                                    <a href="${pageContext.request.contextPath}/my-vouchers">
                                        <i class="fa-solid fa-ticket"></i>
                                        Voucher của tôi
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <div class="wv-dropdown-divider"></div>

                            <a href="${pageContext.request.contextPath}/logout" class="danger">
                                <i class="fa-solid fa-right-from-bracket"></i>
                                Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <a class="wv-auth-link secondary" href="${pageContext.request.contextPath}/register">
                        Đăng ký
                    </a>
                    <a class="wv-auth-link primary" id="headerLoginLink" href="${pageContext.request.contextPath}/login">
                        <i class="fa-solid fa-user"></i>
                        <span>Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>

            <button class="wv-menu-button" id="wvMenuButton" type="button" aria-label="Mở menu">
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const loginLink = document.getElementById("headerLoginLink");
        if (loginLink) {
            loginLink.href = "${pageContext.request.contextPath}/login?redirect="
                + encodeURIComponent(window.location.pathname + window.location.search);
        }

        const menuButton = document.getElementById("wvMenuButton");
        const mainNav = document.getElementById("wvMainNav");
        if (menuButton && mainNav) {
            menuButton.addEventListener("click", function () {
                mainNav.classList.toggle("show");
            });
        }
    });
</script>
