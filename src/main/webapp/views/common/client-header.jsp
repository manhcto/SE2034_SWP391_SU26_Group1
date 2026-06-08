<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

<style>
    .site-header {
        width: 100%;
        background: rgba(255, 255, 255, 0.96);
        border-bottom: 1px solid rgba(226, 232, 240, 0.95);
        position: sticky;
        top: 0;
        z-index: 9999;
        font-family: "Be Vietnam Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        backdrop-filter: blur(18px);
        -webkit-backdrop-filter: blur(18px);
        box-shadow: 0 12px 34px rgba(15, 23, 42, 0.055);
    }

    .header-inner {
        max-width: 1540px;
        margin: 0 auto;
        min-height: 84px;
        padding: 0 28px;
        display: grid;
        grid-template-columns: 250px 330px minmax(0, 1fr) auto;
        align-items: center;
        column-gap: 18px;
    }

    /* ================= LOGO ================= */
    .logo {
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        white-space: nowrap;
        min-width: 0;
    }

    .logo-text {
        display: inline-flex;
        align-items: baseline;
        gap: 2px;
        font-size: 30px;
        font-weight: 900;
        letter-spacing: -1.5px;
        line-height: 1;
    }

    .logo-text span {
        color: #ee8177;
        text-shadow: 0 8px 20px rgba(238, 129, 119, 0.16);
    }

    .logo-text strong {
        color: #f3be4d;
        font-weight: 900;
        text-shadow: 0 8px 20px rgba(243, 190, 77, 0.18);
    }

    .vn-flag {
        position: relative;
        width: 36px;
        height: 23px;
        border-radius: 7px;
        background: linear-gradient(135deg, #ef4444, #dc2626);
        box-shadow: 0 10px 20px rgba(220, 38, 38, 0.20);
        border: 1px solid rgba(255, 255, 255, 0.65);
        overflow: hidden;
        flex: 0 0 auto;
    }

    .vn-flag::before {
        content: "★";
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -54%);
        color: #fde047;
        font-size: 13px;
        line-height: 1;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.14);
    }

    /* ================= SEARCH ================= */
    .header-search {
        height: 50px;
        border-radius: 999px;
        background: linear-gradient(135deg, #f8fafc, #eef4ff);
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 0 18px;
        border: 1px solid #e3ebf7;
        transition: 0.22s ease;
        min-width: 0;
    }

    .header-search:focus-within {
        border-color: #93c5fd;
        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.10);
        background: #ffffff;
    }

    .header-search i {
        color: #2563eb;
        font-size: 15px;
        flex: 0 0 auto;
    }

    .header-search input {
        border: none;
        outline: none;
        background: transparent;
        width: 100%;
        min-width: 0;
        color: #475569;
        font-size: 14px;
        font-weight: 600;
    }

    .header-search input::placeholder {
        color: #94a3b8;
        font-weight: 500;
    }

    /* ================= NAV ================= */
    .main-nav {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: clamp(18px, 1.35vw, 26px);
        min-width: 0;
        overflow: visible;
    }

    .main-nav a {
        color: #0f172a;
        text-decoration: none;
        font-size: clamp(11px, 0.72vw, 12.5px);
        font-weight: 700;
        letter-spacing: 0.1px;
        text-transform: none;
        white-space: nowrap;
        transition: 0.2s ease;
        position: relative;
        line-height: 1;
        flex: 0 0 auto;
    }

    .main-nav a::after {
        content: "";
        position: absolute;
        left: 0;
        bottom: -12px;
        width: 0;
        height: 3px;
        border-radius: 999px;
        background: linear-gradient(90deg, #ee8177, #f3be4d);
        transition: 0.22s ease;
    }

    .main-nav a:hover {
        color: #1d4ed8;
    }

    .main-nav a:hover::after {
        width: 100%;
    }

    /* ================= ACTIONS ================= */
    .header-actions {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 10px;
        white-space: nowrap;
    }

    .register-btn,
    .login-btn {
        height: 48px;
        border-radius: 999px;
        padding: 0 18px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        font-size: 12px;
        font-weight: 900;
        letter-spacing: 0.35px;
        text-transform: uppercase;
        white-space: nowrap;
        transition: 0.2s ease;
    }

    .register-btn {
        background: #ffffff;
        color: #0b63f6;
        border: 1px solid #bfdbfe;
    }

    .login-btn {
        background: linear-gradient(135deg, #eef6ff, #dbeafe);
        color: #0b4ecb;
        border: 1px solid #dbeafe;
        box-shadow: 0 10px 22px rgba(37, 99, 235, 0.08);
    }

    .register-btn:hover,
    .login-btn:hover {
        transform: translateY(-2px);
    }

    .cart-btn {
        position: relative;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: #ffffff;
        border: 1px solid #e2e8f0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        font-size: 16px;
        color: #475569;
        transition: 0.2s ease;
        flex: 0 0 auto;
    }

    .cart-btn:hover {
        background: #f8fafc;
        color: #0b63f6;
        transform: translateY(-2px);
    }

    .cart-count {
        position: absolute;
        top: -7px;
        right: -4px;
        min-width: 21px;
        height: 21px;
        border-radius: 999px;
        background: #ef1023;
        color: #ffffff;
        font-size: 11px;
        font-weight: 900;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 6px;
        border: 2px solid #ffffff;
        box-shadow: 0 8px 16px rgba(239, 16, 35, 0.22);
    }

    .menu-btn {
        display: none;
        width: 46px;
        height: 46px;
        border-radius: 14px;
        border: 1px solid #e2e8f0;
        background: #ffffff;
        font-size: 18px;
        color: #0f172a;
        cursor: pointer;
    }

    /* ================= RESPONSIVE ================= */
    @media (max-width: 1450px) {
        .header-inner {
            grid-template-columns: 230px 290px minmax(0, 1fr) auto;
            column-gap: 14px;
            padding: 0 22px;
        }

        .logo-text {
            font-size: 28px;
        }

        .vn-flag {
            width: 34px;
            height: 22px;
        }

        .main-nav {
            gap: 16px;
        }

        .main-nav a {
            font-size: 11px;
            font-weight: 700;
        }

        .register-btn,
        .login-btn {
            padding: 0 15px;
            font-size: 11.5px;
        }
    }

    @media (max-width: 1280px) {
        .header-inner {
            grid-template-columns: 220px 250px minmax(0, 1fr) auto;
            column-gap: 12px;
        }

        .main-nav {
            gap: 14px;
        }

        .main-nav a {
            font-size: 10.5px;
            letter-spacing: 0;
        }

        .register-btn {
            display: none;
        }
    }

    @media (max-width: 1080px) {
        .header-inner {
            min-height: 82px;
            display: flex;
            flex-wrap: wrap;
            padding: 16px 20px;
            gap: 14px;
        }

        .logo {
            flex: 0 0 auto;
        }

        .header-actions {
            margin-left: auto;
        }

        .header-search {
            order: 3;
            width: 100%;
            flex: 1 0 100%;
        }

        .main-nav {
            order: 4;
            width: 100%;
            display: none;
            flex-direction: column;
            align-items: flex-start;
            gap: 16px;
            padding: 14px 0 4px;
            overflow: visible;
        }

        .main-nav.show {
            display: flex;
        }

        .main-nav a {
            font-size: 13px;
            font-weight: 700;
        }

        .register-btn,
        .login-btn {
            display: none;
        }

        .menu-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
    }

    @media (max-width: 576px) {
        .logo-text {
            font-size: 25px;
        }

        .vn-flag {
            width: 32px;
            height: 21px;
        }

        .cart-btn {
            width: 46px;
            height: 46px;
        }
    }
</style>

<header class="site-header">
    <div class="header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/home">
            <span class="logo-text">
                <span>Wonder</span><strong>VN</strong>
            </span>
            <span class="vn-flag" aria-label="Vietnam flag"></span>
        </a>

        <form class="header-search" action="${pageContext.request.contextPath}/accommodation" method="get">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="keyword" placeholder="Bạn muốn đi đâu?">
        </form>

        <nav class="main-nav" id="mainNav">
            <a href="${pageContext.request.contextPath}/tour">Tour trọn gói</a>
            <a href="${pageContext.request.contextPath}/booking">Đặt Tour Ngay</a>
            <a href="${pageContext.request.contextPath}/booking-list">Đơn của tôi</a>
            <a href="${pageContext.request.contextPath}/accommodation">Khách sạn</a>
            <a href="${pageContext.request.contextPath}/vehicle">Thuê xe</a>
            <a href="${pageContext.request.contextPath}/service">Dịch vụ cộng thêm</a>
        </nav>

        <div class="header-actions">
            <a class="register-btn" href="${pageContext.request.contextPath}/register">
                Đăng ký
            </a>

            <a class="login-btn" href="${pageContext.request.contextPath}/login">
                <i class="fa-solid fa-user"></i>
                Đăng nhập
            </a>

            <a class="cart-btn" href="${pageContext.request.contextPath}/cart" aria-label="Giỏ hàng">
                <i class="fa-solid fa-cart-shopping"></i>
                <span class="cart-count">${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}</span>
            </a>

            <button class="menu-btn" id="menuBtn" type="button" aria-label="Mở menu">
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const menuBtn = document.getElementById("menuBtn");
        const mainNav = document.getElementById("mainNav");

        if (menuBtn && mainNav) {
            menuBtn.addEventListener("click", function () {
                mainNav.classList.toggle("show");
            });
        }
    });
</script>