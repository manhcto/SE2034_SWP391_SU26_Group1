<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    .site-header {
        position: sticky;
        top: 0;
        z-index: 9999;
        background: rgba(255, 255, 255, 0.96);
        border-bottom: 1px solid #e5e7eb;
        box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
        backdrop-filter: blur(12px);
        font-family: "Be Vietnam Pro", Arial, sans-serif;
    }

    .header-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 14px 24px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 24px;
    }

    .logo {
        display: flex;
        align-items: center;
        gap: 10px;
        text-decoration: none;
        color: #0f172a;
        font-size: 22px;
        font-weight: 900;
        white-space: nowrap;
    }

    .logo-icon {
        width: 42px;
        height: 42px;
        border-radius: 14px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: #ffffff;
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        box-shadow: 0 10px 24px rgba(37, 99, 235, 0.22);
    }

    .main-nav {
        display: flex;
        align-items: center;
        gap: 24px;
    }

    .main-nav a {
        text-decoration: none;
        color: #334155;
        font-size: 15px;
        font-weight: 700;
        transition: 0.2s ease;
        white-space: nowrap;
    }

    .main-nav a:hover {
        color: #2563eb;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 14px;
    }

    .user-box {
        position: relative;
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 6px 12px;
        border-radius: 999px;
        cursor: pointer;
        transition: 0.25s ease;
    }

    .user-box:hover {
        background: #f8fafc;
    }

    .avatar {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #e2e8f0;
    }

    .user-name {
        color: #0f172a;
        font-size: 14px;
        font-weight: 800;
        white-space: nowrap;
    }

    .dropdown-menu {
        position: absolute;
        top: 58px;
        right: 0;
        width: 260px;
        background: #ffffff;
        border-radius: 18px;
        border: 1px solid #edf2f7;
        box-shadow:
                0 20px 40px rgba(15, 23, 42, 0.12),
                0 4px 12px rgba(15, 23, 42, 0.08);
        overflow: hidden;
        opacity: 0;
        visibility: hidden;
        transform: translateY(12px);
        transition: all 0.25s ease;
        z-index: 99999;
    }

    .user-box:hover .dropdown-menu {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .dropdown-user {
        padding: 16px;
        color: #ffffff;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
    }

    .dropdown-user-name {
        font-size: 15px;
        font-weight: 800;
    }

    .dropdown-user-role {
        font-size: 12px;
        opacity: 0.9;
        margin-top: 4px;
    }

    .dropdown-menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 16px;
        text-decoration: none;
        color: #334155;
        font-size: 14px;
        font-weight: 600;
        transition: 0.2s ease;
    }

    .dropdown-menu a:hover {
        background: #f8fafc;
        color: #2563eb;
    }

    .dropdown-menu a i {
        width: 18px;
        text-align: center;
    }

    .dropdown-divider {
        height: 1px;
        background: #edf2f7;
        margin: 4px 0;
    }

    .logout-link {
        color: #dc2626 !important;
    }

    .logout-link:hover {
        background: #fef2f2 !important;
    }

    .menu-btn {
        display: none;
        width: 42px;
        height: 42px;
        border-radius: 10px;
        border: 1px solid #e5e7eb;
        background: #ffffff;
        color: #0f172a;
        cursor: pointer;
    }

    @media (max-width: 1024px) {
        .header-container {
            flex-wrap: wrap;
        }

        .menu-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .main-nav {
            display: none;
            width: 100%;
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
            padding-top: 12px;
            border-top: 1px solid #e5e7eb;
        }

        .main-nav.show {
            display: flex;
        }

        .header-actions {
            margin-left: auto;
        }
    }

    @media (max-width: 640px) {
        .header-container {
            padding: 12px 16px;
        }

        .user-name {
            display: none;
        }

        .dropdown-menu {
            right: -8px;
            width: 240px;
        }
    }
</style>

<header class="site-header">
    <div class="header-container">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <span class="logo-icon">
                <i class="fa-solid fa-location-dot"></i>
            </span>
            <span>WonderVN</span>
        </a>

        <nav class="main-nav" id="mainNav">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/tour">Tour</a>
            <a href="${pageContext.request.contextPath}/booking">Đặt tour</a>
            <a href="${pageContext.request.contextPath}/accommodation">Khách sạn</a>
            <a href="${pageContext.request.contextPath}/vehicle">Thuê xe</a>
        </nav>

        <div class="header-actions">
            <button class="menu-btn" type="button" onclick="toggleCustomerMenu()">
                <i class="fa-solid fa-bars"></i>
            </button>

            <div class="user-box">
                <img class="avatar"
                     src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
                     alt="Avatar">

                <span class="user-name">
                    ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                </span>

                <i class="fa-solid fa-chevron-down"
                   style="font-size:12px;color:#64748b;"></i>

                <div class="dropdown-menu">
                    <div class="dropdown-user">
                        <div class="dropdown-user-name">
                            ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                        </div>
                        <div class="dropdown-user-role">
                            Tài khoản khách hàng
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/profile">
                        <i class="fa-solid fa-user"></i>
                        Xem hồ sơ
                    </a>

                    <a href="${pageContext.request.contextPath}/booking-list">
                        <i class="fa-solid fa-receipt"></i>
                        Đơn của tôi
                    </a>

                    <div class="dropdown-divider"></div>

                    <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    function toggleCustomerMenu() {
        const mainNav = document.getElementById("mainNav");
        if (mainNav) {
            mainNav.classList.toggle("show");
        }
    }
</script>