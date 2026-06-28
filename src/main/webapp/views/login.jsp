<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - WonderVN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">
<main class="auth-page">
    <section class="auth-brand" aria-label="WonderVN">
        <div class="auth-logo">
            <span>Wonder</span><span>VN</span><span class="auth-flag"><i class="fa-solid fa-star"></i></span>
        </div>
        <h1>Tiếp tục hành trình cùng WonderVN</h1>
        <p>Đăng nhập để đặt phòng, thuê xe, theo dõi đơn và quản lý thông tin chuyến đi của bạn trong một nơi duy nhất.</p>
    </section>

    <section class="auth-panel">
        <div class="auth-card compact">
            <h2>Đăng nhập</h2>
            <p class="auth-subtitle">Chào mừng bạn quay lại. Thông tin của bạn luôn được bảo vệ cẩn thận.</p>

            <c:if test="${not empty successMsg}">
                <div class="auth-alert success">${successMsg}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="auth-alert error">${error}</div>
            </c:if>

            <form class="auth-form" action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="redirect" value="${redirectAfterLogin}" />

                <div class="auth-field">
                    <label for="email">Email</label>
                    <input class="auth-input" id="email" type="email" name="email" placeholder="you@example.com" required>
                </div>

                <div class="auth-field">
                    <label for="password">Mật khẩu</label>
                    <div class="password-wrap">
                        <input class="auth-input" id="password" type="password" name="password" placeholder="Nhập mật khẩu" required>
                        <button class="password-toggle" type="button" data-password-toggle="password" aria-label="Hiện mật khẩu">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                </div>

                <button class="auth-button" type="submit">Đăng nhập</button>
            </form>

            <div class="auth-links">
                <a class="auth-link" href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                <span>Chưa có tài khoản? <a class="auth-link" href="${pageContext.request.contextPath}/register">Đăng ký</a></span>
            </div>
        </div>
    </section>
</main>

<script>
    document.querySelectorAll("[data-password-toggle]").forEach(function (button) {
        button.addEventListener("click", function () {
            const input = document.getElementById(button.dataset.passwordToggle);
            const icon = button.querySelector("i");
            const isHidden = input.type === "password";
            input.type = isHidden ? "text" : "password";
            icon.className = isHidden ? "fa-regular fa-eye-slash" : "fa-regular fa-eye";
            button.setAttribute("aria-label", isHidden ? "Ẩn mật khẩu" : "Hiện mật khẩu");
        });
    });
</script>
</body>
</html>
