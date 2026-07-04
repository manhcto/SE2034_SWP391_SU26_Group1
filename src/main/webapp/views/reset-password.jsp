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
    <h1>Tạo mật khẩu mới cho tài khoản</h1>
    <p>OTP đã được xác thực. Đây là bước cuối để bảo vệ tài khoản trước khi bạn đăng nhập lại WonderVN.</p>
  </section>

  <section class="auth-panel">
    <div class="auth-card compact">
      <div class="reset-card-top">
        <div class="reset-status">
          <span class="reset-status-icon"><i class="fa-solid fa-check"></i></span>
          <div>
            <span>OTP đã xác thực</span>
            <strong>Bạn có thể thiết lập mật khẩu mới.</strong>
          </div>
        </div>

        <c:if test="${not empty sessionScope.resetEmail}">
          <div class="reset-account">
            <i class="fa-regular fa-envelope"></i>
            <div>
              <span>Tài khoản đang đổi mật khẩu</span>
              <strong><c:out value="${sessionScope.resetEmail}" /></strong>
            </div>
          </div>
        </c:if>
      </div>

      <h2>Đặt lại mật khẩu</h2>
      <p class="auth-subtitle">Mật khẩu mới sẽ được áp dụng ngay sau khi cập nhật thành công.</p>

      <c:if test="${not empty error}">
        <div class="auth-alert error">${error}</div>
      </c:if>

      <form class="auth-form" action="${pageContext.request.contextPath}/reset-password" method="post" data-reset-form>
        <div class="auth-field">
          <label for="password">Mật khẩu mới</label>
          <div class="password-wrap">
            <input class="auth-input" id="password" type="password" name="password" placeholder="Nhập mật khẩu mới" autocomplete="new-password" minlength="6" required>
            <button class="password-toggle" type="button" data-password-toggle="password" aria-label="Hiện mật khẩu">
              <i class="fa-regular fa-eye"></i>
            </button>
          </div>
        </div>

        <div class="auth-field">
          <label for="confirmPassword">Nhập lại mật khẩu</label>
          <div class="password-wrap">
            <input class="auth-input" id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" autocomplete="new-password" minlength="6" required>
            <button class="password-toggle" type="button" data-password-toggle="confirmPassword" aria-label="Hiện mật khẩu">
              <i class="fa-regular fa-eye"></i>
            </button>
          </div>
        </div>

        <div class="password-rules" aria-live="polite">
          <div class="password-rules-title">Yêu cầu mật khẩu</div>
          <ul>
            <li data-rule="length"><i class="fa-solid fa-circle"></i> Tối thiểu 6 ký tự</li>
            <li data-rule="match"><i class="fa-solid fa-circle"></i> Hai mật khẩu phải trùng nhau</li>
          </ul>
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

  const resetForm = document.querySelector("[data-reset-form]");
  const passwordInput = document.getElementById("password");
  const confirmInput = document.getElementById("confirmPassword");
  const lengthRule = document.querySelector("[data-rule='length']");
  const matchRule = document.querySelector("[data-rule='match']");

  function setRuleState(rule, isValid) {
    const icon = rule.querySelector("i");
    rule.classList.toggle("valid", isValid);
    icon.className = isValid ? "fa-solid fa-check" : "fa-solid fa-circle";
  }

  function validateResetForm() {
    const hasLength = passwordInput.value.length >= 6;
    const isMatched = confirmInput.value.length > 0 && passwordInput.value === confirmInput.value;
    setRuleState(lengthRule, hasLength);
    setRuleState(matchRule, isMatched);
    return hasLength && isMatched;
  }

  [passwordInput, confirmInput].forEach(function (input) {
    input.addEventListener("input", validateResetForm);
  });

  resetForm.addEventListener("submit", function (event) {
    if (!validateResetForm()) {
      event.preventDefault();
      confirmInput.focus();
    }
  });
</script>
</body>
</html>
