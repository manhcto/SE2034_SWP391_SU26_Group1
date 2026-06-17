<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: "Be Vietnam Pro", sans-serif;
    }

    /* ===== HEADER ===== */
    .site-header {
        width: 100%;
        position: sticky;
        top: 0;
        z-index: 9999;
        background: rgba(255,255,255,0.92);
        backdrop-filter: blur(16px);
        border-bottom: 1px solid #eaeef5;
    }

    .header-inner {
        max-width: 1500px;
        margin: auto;
        display: flex;
        align-items: center;
        gap: 18px;
        padding: 14px 24px;
    }

    /* ===== LOGO ===== */
    .logo-text {
        font-size: 26px;
        font-weight: 900;
        display: flex;
        gap: 3px;
        white-space: nowrap;
    }

    .logo-text span { color: #ff6b6b; }
    .logo-text strong { color: #f7b731; }

    /* ===== SEARCH ===== */
    .header-search {
        flex: 1;
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 16px;
        border-radius: 999px;
        border: 1px solid #e6eaf0;
        background: #f8fafc;
        transition: .2s;
        min-width: 0;
    }

    .header-search:focus-within {
        background: #fff;
        border-color: #93c5fd;
        box-shadow: 0 0 0 3px rgba(59,130,246,.15);
    }

    .header-search input {
        border: none;
        outline: none;
        width: 100%;
        background: transparent;
        font-weight: 500;
    }

    /* ===== NAV ===== */
    .main-nav {
        display: flex;
        gap: 18px;
        align-items: center;
    }

    .main-nav a {
        text-decoration: none;
        font-weight: 600;
        font-size: 13px;
        color: #334155;
        position: relative;
        white-space: nowrap;
    }

    .main-nav a:hover {
        color: #2563eb;
    }

    .main-nav a::after {
        content: "";
        position: absolute;
        bottom: -6px;
        left: 0;
        width: 0;
        height: 2px;
        background: #2563eb;
        transition: .2s;
    }

    .main-nav a:hover::after {
        width: 100%;
    }

    /* ===== RIGHT BOX ===== */
    .right-box {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    /* CART */
    .cart-btn {
        position: relative;
        width: 42px;
        height: 42px;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        background: #fff;
        border: 1px solid #e5e7eb;
        text-decoration: none;
        color: #334155;
    }

    .cart-count {
        position: absolute;
        top: -6px;
        right: -6px;
        background: #ef4444;
        color: #fff;
        font-size: 11px;
        font-weight: bold;
        padding: 2px 6px;
        border-radius: 999px;
    }

    /* USER */
    .user-box {
        position: relative;
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        padding: 6px 10px;
        border-radius: 999px;
        transition: .2s;
    }

    .user-box:hover {
        background: #f1f5f9;
    }

    .avatar {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        object-fit: cover;
    }

    /* DROPDOWN */
    .dropdown-menu {
        position: absolute;
        top: 52px;
        right: 0;
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        width: 160px;
        display: none;
        flex-direction: column;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        overflow: hidden;
    }

    .user-box:hover .dropdown-menu {
        display: flex;
    }

    .dropdown-menu a {
        padding: 10px 12px;
        text-decoration: none;
        color: #334155;
        font-size: 13px;
    }

    .dropdown-menu a:hover {
        background: #f1f5f9;
    }

    /* MOBILE */
    .menu-btn {
        display: none;
        width: 42px;
        height: 42px;
        border-radius: 10px;
        border: 1px solid #e5e7eb;
        background: #fff;
        cursor: pointer;
    }

    @media (max-width: 1024px) {
        .main-nav {
            display: none;
            position: absolute;
            top: 70px;
            left: 0;
            right: 0;
            background: #fff;
            flex-direction: column;
            padding: 16px;
            border-bottom: 1px solid #eaeef5;
        }

        .main-nav.show {
            display: flex;
        }

        .menu-btn {
            display: flex;
            align-items: center;
            justify-content: center;
        }
    }
</style>

<header class="site-header">
    <div class="header-inner">

        <!-- LOGO -->
        <a href="${pageContext.request.contextPath}/home">
            <div class="logo-text">
                <span>Wonder</span><strong>VN</strong>
            </div>
        </a>

        <!-- SEARCH -->
        <form class="header-search" action="${pageContext.request.contextPath}/accommodation" method="get">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input name="keyword" placeholder="Bạn muốn đi đâu?">
        </form>

        <!-- NAV -->
        <nav class="main-nav" id="mainNav">
            <a href="${pageContext.request.contextPath}/tour">Tour</a>
            <a href="${pageContext.request.contextPath}/booking">Đặt tour</a>
            <a href="${pageContext.request.contextPath}/booking-list">Đơn của tôi</a>
            <a href="${pageContext.request.contextPath}/accommodation">Khách sạn</a>
            <a href="${pageContext.request.contextPath}/vehicle">Thuê xe</a>
        </nav>

        <!-- RIGHT -->
        <div class="right-box">

            <!-- CART -->
            <a class="cart-btn" href="${pageContext.request.contextPath}/cart">
                <i class="fa-solid fa-cart-shopping"></i>
                <span class="cart-count">
                    ${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}
                </span>
            </a>

            <!-- USER -->
            <div class="user-box">
                <img class="avatar"
                     src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg">

                <span>${sessionScope.user.firstName}</span>

                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/edit-profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
            </div>

            <!-- MENU BTN -->
            <button class="menu-btn" id="menuBtn">
                <i class="fa-solid fa-bars"></i>
            </button>

        </div>

    </div>
</header>

<script>
    const menuBtn = document.getElementById("menuBtn");
    const mainNav = document.getElementById("mainNav");

    menuBtn?.addEventListener("click", () => {
        mainNav.classList.toggle("show");
    });
</script>