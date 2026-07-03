<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .site-footer {
        background: #0f172a;
        color: #cbd5e1;
        padding: 56px 0 20px;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        margin-top: 60px;
    }

    .footer-inner {
        max-width: 1500px;
        margin: 0 auto;
        padding: 0 28px;
        display: grid;
        grid-template-columns: 1.6fr 1fr 1fr 1.2fr;
        gap: 36px;
    }

    .footer-logo {
        display: inline-block;
        text-decoration: none;
        font-size: 30px;
        font-weight: 900;
        letter-spacing: -1px;
        margin-bottom: 14px;
    }

    .footer-logo span {
        color: #3b82f6;
    }

    .footer-logo strong {
        color: #ef4444;
    }

    .site-footer p {
        color: #94a3b8;
        line-height: 1.7;
        margin: 0 0 8px;
        font-size: 15px;
    }

    .site-footer h4 {
        color: #ffffff;
        font-size: 17px;
        font-weight: 800;
        margin: 0 0 16px;
    }

    .site-footer a {
        display: block;
        color: #cbd5e1;
        text-decoration: none;
        margin-bottom: 10px;
        font-size: 15px;
        transition: 0.2s ease;
    }

    .site-footer a:hover {
        color: #60a5fa;
        transform: translateX(3px);
    }

    .copyright {
        max-width: 1500px;
        margin: 34px auto 0;
        padding: 20px 28px 0;
        border-top: 1px solid rgba(148, 163, 184, 0.22);
        text-align: center;
        color: #94a3b8;
        font-size: 14px;
    }

    @media (max-width: 992px) {
        .footer-inner {
            grid-template-columns: 1fr 1fr;
        }
    }

    @media (max-width: 576px) {
        .footer-inner {
            grid-template-columns: 1fr;
        }
    }
</style>

<footer class="site-footer">
    <div class="footer-inner">
        <div>
            <a class="footer-logo" href="${pageContext.request.contextPath}/home">
                <span>Wonder</span><strong>VN</strong>
            </a>
            <p>
                WonderVN cung cấp tour trọn gói, khách sạn, thuê xe và dịch vụ cộng thêm
                cho chuyến đi của bạn.
            </p>
        </div>

        <div>
            <h4>WonderVN</h4>
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a href="#">Về chúng tôi</a>
            <a href="#">Liên hệ</a>
            <a href="#">Tin du lịch</a>
        </div>

        <div>
            <h4>Dịch vụ</h4>
            <a href="${pageContext.request.contextPath}/tour">Tour trọn gói</a>
            <a href="${pageContext.request.contextPath}/accommodation">Khách sạn</a>
        </div>

        <div>
            <h4>Hỗ trợ</h4>
            <p>Hotline: 1900 0000</p>
            <p>Email: support@wondervn.vn</p>
            <p>Thời gian hỗ trợ: 08:00 - 22:00</p>
        </div>
    </div>

    <div class="copyright">
        © 2026 WonderVN. All rights reserved.
    </div>
</footer>
