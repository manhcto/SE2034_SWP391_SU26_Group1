<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - WonderVN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">
<main class="auth-page">
    <section class="auth-brand" aria-label="WonderVN">
        <div class="auth-logo">
            <span>Wonder</span><span>VN</span><span class="auth-flag"><i class="fa-solid fa-star"></i></span>
        </div>
        <h1>Lấy lại quyền truy cập an toàn</h1>
        <p>Nhập email và số điện thoại đã đăng ký để hệ thống xác minh trước khi cho phép đặt lại mật khẩu.</p>
    </section>

    <section class="auth-panel">
        <div class="auth-card compact">
            <h2>Quên mật khẩu</h2>
            <p class="auth-subtitle">Thông tin xác minh giúp bảo vệ tài khoản của bạn khỏi truy cập không hợp lệ.</p>

            <c:if test="${not empty error}">
                <div class="auth-alert error">${error}</div>
            </c:if>

            <form class="auth-form" action="${pageContext.request.contextPath}/forgot-password" method="post">
                <div class="auth-field">
                    <label for="email">Email</label>
                    <input class="auth-input" id="email" type="email" name="email" value="${param.email}" placeholder="you@example.com" required>
                </div>

                <div class="auth-field">
                    <label for="phone">Số điện thoại</label>
                    <input class="auth-input" id="phone" type="text" name="phone" value="${param.phone}" placeholder="Nhập số điện thoại" required>
                </div>

                <button class="auth-button" type="submit">Xác minh</button>
            </form>

            <div class="auth-note">
                Sau khi xác minh thành công, WonderVN sẽ chuyển bạn sang bước đặt mật khẩu mới.
            </div>

            <div class="auth-links center">
                <a class="auth-link" href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
            </div>
        </div>
    </section>
</main>
</body>
</html>
