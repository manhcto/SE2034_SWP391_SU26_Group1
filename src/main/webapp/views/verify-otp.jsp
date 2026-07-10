<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Xác thực OTP - WonderVN</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">
<main class="auth-page">
  <section class="auth-brand" aria-label="WonderVN">
    <div class="auth-logo">
      <span>Wonder</span><span>VN</span><span class="auth-flag"><i class="fa-solid fa-star"></i></span>
    </div>
    <h1>Xác thực tài khoản an toàn</h1>
    <p>Nhập mã OTP đã gửi tới email để tiếp tục đặt lại mật khẩu và bảo vệ thông tin chuyến đi của bạn.</p>
  </section>

  <section class="auth-panel">
    <div class="auth-card compact otp-card">
      <div class="otp-card-head">
        <div class="otp-icon">
          <i class="fa-solid fa-lock"></i>
        </div>
        <span>Mã xác thực gồm 6 chữ số</span>
      </div>

      <h2>Xác thực OTP</h2>
      <p class="auth-subtitle">Vui lòng nhập mã OTP đã được gửi tới email của bạn.</p>


      <c:if test="${not empty error}">
        <div class="auth-alert error">${error}</div>
      </c:if>

      <form class="auth-form" action="${pageContext.request.contextPath}/verify-otp" method="post">
        <div class="auth-field">
          <label for="otp">Mã OTP</label>
          <input class="auth-input otp-input"
                 id="otp"
                 type="text"
                 name="otp"
                 maxlength="6"
                 inputmode="numeric"
                 pattern="[0-9]{6}"
                 placeholder="000000"
                 autocomplete="one-time-code"
                 required
                 autofocus>
        </div>

        <button class="auth-button" type="submit">Xác nhận</button>
      </form>

      <div class="auth-links center">
        <a class="auth-link" href="${pageContext.request.contextPath}/forgot-password">
          <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
      </div>
    </div>
  </section>
</main>

<script>
  const otpInput = document.getElementById("otp");
  otpInput.addEventListener("input", function () {
    otpInput.value = otpInput.value.replace(/\D/g, "").slice(0, 6);
  });
</script>
</body>
</html>
