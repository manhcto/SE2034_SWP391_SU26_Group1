<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="site-header">
    <div class="header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/home">
            <span>Wonder</span><strong>VN</strong>
        </a>

        <form class="header-search" action="${pageContext.request.contextPath}/search" method="get">
            <span>🔎</span>
            <input type="text" name="keyword" placeholder="Bạn muốn đi đâu?">
        </form>

        <nav class="main-nav" id="mainNav">
            <a href="${pageContext.request.contextPath}/tour">Tour trọn gói</a>
            <a href="${pageContext.request.contextPath}/hotel">Khách sạn</a>
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
