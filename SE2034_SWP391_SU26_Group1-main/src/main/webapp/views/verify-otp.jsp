<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Xác thực OTP - WonderVN</title>

  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background: linear-gradient(135deg,#4facfe,#00f2fe);
    }

    .card {
      width: 400px;
      background: white;
      padding: 35px;
      border-radius: 15px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      text-align: center;
    }

    h2 {
      margin-bottom: 10px;
      color: #333;
    }

    .desc {
      color: #666;
      font-size: 14px;
      margin-bottom: 20px;
    }

    input {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 8px;
      text-align: center;
      font-size: 18px;
      letter-spacing: 4px;
      box-sizing: border-box;
    }

    input:focus {
      outline: none;
      border-color: #4facfe;
      box-shadow: 0 0 8px rgba(79,172,254,0.4);
    }

    button {
      width: 100%;
      padding: 12px;
      border: none;
      border-radius: 8px;
      background: #007bff;
      color: white;
      font-size: 15px;
      font-weight: bold;
      cursor: pointer;
      margin-top: 10px;
    }

    button:hover {
      background: #0056b3;
    }

    .error {
      color: red;
      margin-top: 15px;
      font-size: 14px;
    }

    .back-link {
      display: inline-block;
      margin-top: 15px;
      text-decoration: none;
      color: #007bff;
      font-size: 14px;
    }

    .back-link:hover {
      text-decoration: underline;
    }

    .otp-icon {
      font-size: 45px;
      margin-bottom: 10px;
    }
  </style>
</head>

<body>

<div class="card">

  <div class="otp-icon">🔐</div>

  <h2>Xác thực OTP</h2>

  <p class="desc">
    Vui lòng nhập mã OTP gồm 6 chữ số đã được gửi tới email của bạn.
  </p>

  <form action="${pageContext.request.contextPath}/verify-otp"
        method="post">

    <input type="text"
           name="otp"
           maxlength="6"
           placeholder="Nhập OTP"
           required>

    <button type="submit">
      Xác nhận
    </button>

  </form>

  <c:if test="${not empty error}">
    <p class="error">${error}</p>
  </c:if>

  <a class="back-link"
     href="${pageContext.request.contextPath}/forgot-password">
    ← Quay lại
  </a>

</div>

</body>
</html>