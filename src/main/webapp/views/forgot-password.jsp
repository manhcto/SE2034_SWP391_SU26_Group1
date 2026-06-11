<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quên mật khẩu</title>

  <style>
    * {
      box-sizing: border-box;
      font-family: Arial, sans-serif;
    }

    body {
      margin: 0;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background: linear-gradient(135deg, #f5f7fa, #e4e8f0);
    }

    .card {
      width: 100%;
      max-width: 420px;
      background: #fff;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.08);
    }

    .card h2 {
      text-align: center;
      margin-bottom: 20px;
      color: #333;
    }

    .form-group {
      margin-bottom: 15px;
    }

    label {
      display: block;
      margin-bottom: 6px;
      font-size: 14px;
      color: #444;
    }

    input {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 8px;
      outline: none;
      transition: 0.2s;
    }

    input:focus {
      border-color: #099ade;
      box-shadow: 0 0 0 2px rgba(255,165,0,0.2);
    }

    button {
      width: 100%;
      padding: 12px;
      margin-top: 10px;
      background: #099ade;
      border: none;
      border-radius: 8px;
      color: white;
      font-weight: bold;
      cursor: pointer;
      transition: 0.2s;
    }

    button:hover {
      background: darkorange;
    }

    .error {
      background: #ffe6e6;
      color: #d60000;
      padding: 10px;
      border-radius: 8px;
      margin-bottom: 15px;
      font-size: 14px;
      text-align: center;
    }

    .hint {
      text-align: center;
      font-size: 12px;
      color: #777;
      margin-top: 10px;
    }
  </style>
</head>

<body>

<div class="card">

  <h2>Quên mật khẩu</h2>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/forgot-password" method="post">

    <div class="form-group">
      <label>Email</label>
      <input type="email" name="email" placeholder="Nhập email của bạn" required>
    </div>

    <div class="form-group">
      <label>Số điện thoại</label>
      <input type="text" name="phone" placeholder="Nhập số điện thoại" required>
    </div>

    <button type="submit">Xác nhận</button>

  </form>

  <div class="hint">
    Hệ thống sẽ kiểm tra thông tin để đặt lại mật khẩu
  </div>

</div>

</body>
</html>