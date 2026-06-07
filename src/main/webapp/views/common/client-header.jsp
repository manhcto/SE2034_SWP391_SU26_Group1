<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .site-header {
        width: 100%;
        background: rgba(255, 255, 255, 0.86);
        border-bottom: 1px solid rgba(226, 232, 240, 0.9);
        position: sticky;
        top: 0;
        z-index: 9999;
        font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        backdrop-filter: blur(18px);
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.04);
    }

    .header-inner {
        max-width: 1500px;
        margin: 0 auto;
        min-height: 88px;
        padding: 0 28px;
        display: flex;
        align-items: center;
        gap: 24px;
    }

    .logo {
        text-decoration: none;
        font-size: 32px;
        font-weight: 950;
        letter-spacing: -1.3px;
        white-space: nowrap;
        display: inline-flex;
        align-items: center;
        gap: 4px;
    }

    .logo span {
        color: #ef7f72;
        text-shadow: 0 8px 22px rgba(239, 127, 114, 0.16);
    }

    .logo strong {
        color: #f4bf4f;
        text-shadow: 0 8px 22px rgba(244, 191, 79, 0.18);
    }

    .logo-flag {
        font-size: 19px;
        margin-left: 5px;
        filter: drop-shadow(0 6px 10px rgba(239, 68, 68, 0.20));
    }

    .header-search {
        width: 390px;
        height: 50px;
        border-radius: 999px;
        background: linear-gradient(135deg, #f8fafc, #eef2ff);
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 0 18px;
        margin-left: 10px;
        border: 1px solid #e6edf7;
    }

    .header-search span {
        font-size: 18px;
        color: #2563eb;
    }

    .header-search input {
        border: none;
        outline: none;
        background: transparent;
        width: 100%;
        color: #475569;
        font-size: 15px;
    }

    .main-nav {
        display: flex;
        align-items: center;
        gap: 18px;
        margin-left: auto;
    }

    .main-nav a {
        color: #020617;
        text-decoration: none;
        font-size: 13px;
        font-weight: 800;
        white-space: nowrap;
        transition: 0.2s ease;
        position: relative;
    }

    .main-nav a::after {
        content: "";
        position: absolute;
        left: 0;
        bottom: -8px;
        width: 0;
        height: 3px;
        border-radius: 999px;
        background: linear-gradient(90deg, #ef7f72, #f4bf4f);
        transition: 0.22s ease;
    }

    .main-nav a:hover {
        color: #2563eb;
    }

    .main-nav a:hover::after {
        width: 100%;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-left: 8px;
    }

    .language-select {
        height: 48px;
        border-radius: 999px;
        border: 1px solid #dbeafe;
        background: #ffffff;
        padding: 0 16px;
        font-size: 15px;
        font-weight: 800;
        color: #020617;
        outline: none;
    }

    .register-btn,
    .login-btn {
        height: 48px;
        border-radius: 999px;
        padding: 0 18px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        font-size: 15px;
        font-weight: 900;
        white-space: nowrap;
        transition: 0.2s ease;
    }

    .register-btn {
        background: #ffffff;
        color: #0b63f6;
        border: 1px solid #bfdbfe;
    }

    .login-btn {
        background: linear-gradient(135deg, #eaf3ff, #dbeafe);
        color: #0b4ecb;
        border: 1px solid #dbeafe;
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
        font-size: 20px;
        color: #0f172a;
    }

    .cart-count {
        position: absolute;
        top: -6px;
        right: -4px;
        min-width: 19px;
        height: 19px;
        border-radius: 999px;
        background: #ef1023;
        color: #ffffff;
        font-size: 12px;
        font-weight: 900;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 5px;
    }

    .menu-btn {
        display: none;
        width: 44px;
        height: 44px;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        background: #ffffff;
        font-size: 22px;
        color: #0f172a;
    }

    @media (max-width: 1200px) {
        .header-search {
            width: 300px;
        }

        .main-nav {
            gap: 14px;
        }

        .main-nav a {
            font-size: 12px;
        }
    }

    @media (max-width: 992px) {
        .header-inner {
            min-height: 80px;
            flex-wrap: wrap;
            padding: 16px 20px;
        }

        .header-search {
            order: 3;
            width: 100%;
            margin-left: 0;
        }

        .main-nav {
            order: 4;
            width: 100%;
            display: none;
            flex-direction: column;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 0 4px;
            margin-left: 0;
        }

        .main-nav.show {
            display: flex;
        }

        .header-actions {
            margin-left: auto;
        }

        .language-select,
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
</style>

<header class="site-header">
    <div class="header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/home">
            <span>Wonder</span><strong>VN</strong><em class="logo-flag">🇻🇳</em>
        </a>

        <form class="header-search" action="${pageContext.request.contextPath}/accommodation" method="get">
            <span>🔎</span>
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
            <select class="language-select" aria-label="Chọn ngôn ngữ">
                <option>Tiếng Việt</option>
                <option>English</option>
            </select>

            <a class="register-btn" href="${pageContext.request.contextPath}/register">Đăng ký</a>
            <a class="login-btn" href="${pageContext.request.contextPath}/login">👤 Đăng nhập</a>

            <a class="cart-btn" href="${pageContext.request.contextPath}/cart" aria-label="Giỏ hàng">
                🛒
                <span class="cart-count">${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}</span>
            </a>

            <button class="menu-btn" id="menuBtn" type="button" aria-label="Mở menu">☰</button>
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