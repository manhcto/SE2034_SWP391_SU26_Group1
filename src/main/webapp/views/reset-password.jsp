<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - WonderVN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">
<main class="auth-page">
    <section class="auth-brand" aria-label="WonderVN">
        <div class="auth-logo">
            <span>Wonder</span><span>VN</span><span class="auth-flag"><i class="fa-solid fa-star"></i></span>
        </div>
        <h1>Thiết lập mật khẩu mới</h1>
        <p>Chọn mật khẩu đủ mạnh để bảo vệ lịch trình, đơn đặt phòng và thông tin thanh toán của bạn.</p>
    </section>

    <section class="auth-panel">
        <div class="auth-card compact">
            <h2>Đặt lại mật khẩu</h2>
            <p class="auth-subtitle">Nhập mật khẩu mới và xác nhận lại để hoàn tất.</p>

            <c:if test="${not empty error}">
                <div class="auth-alert error">${error}</div>
            </c:if>

            <form class="auth-form" action="${pageContext.request.contextPath}/reset-password" method="post">
                <div class="auth-field">
                    <label for="password">Mật khẩu mới</label>
                    <div class="password-wrap">
                        <input class="auth-input" id="password" type="password" name="password" placeholder="Nhập mật khẩu mới" required>
                        <button class="password-toggle" type="button" data-password-toggle="password" aria-label="Hiện mật khẩu">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                </div>

                <div class="auth-field">
                    <label for="confirmPassword">Nhập lại mật khẩu</label>
                    <div class="password-wrap">
                        <input class="auth-input" id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                        <button class="password-toggle" type="button" data-password-toggle="confirmPassword" aria-label="Hiện mật khẩu">
                            <i class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                </div>

                <button class="auth-button" type="submit">Cập nhật mật khẩu</button>
            </form>

            <div class="auth-links center">
                <a class="auth-link" href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
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
