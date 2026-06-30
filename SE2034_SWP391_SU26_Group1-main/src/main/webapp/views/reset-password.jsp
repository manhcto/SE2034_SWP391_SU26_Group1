<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đặt lại mật khẩu</title>

  <style>
    body {
      margin: 0;
      font-family: "Segoe UI", Arial, sans-serif;
      background: linear-gradient(135deg, #e0f2fe, #f8fafc);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .container {
      width: 380px;
      background: #ffffff;
      padding: 30px;
      border-radius: 14px;
      box-shadow: 0 20px 50px rgba(2, 132, 199, 0.15);
      border: 1px solid #e0f2fe;
    }

    h2 {
      text-align: center;
      color: #0284c7;
      font-weight: 800;
      margin-bottom: 6px;
    }

    .title-line {
      width: 60px;
      height: 4px;
      margin: 0 auto 18px auto;
      border-radius: 999px;
      background: linear-gradient(90deg, #2563eb, #0ea5e9);
    }

    form {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    label {
      font-size: 13px;
      font-weight: 600;
      color: #334155;
    }

    input {
      width: 100%;
      height: 44px;
      padding: 0 12px;
      border-radius: 10px;
      border: 1px solid #dbeafe;
      background: #f8fafc;
      font-size: 14px;
      outline: none;
      transition: 0.2s;
    }

    input:focus {
      border-color: #3b82f6;
      background: #fff;
      box-shadow: 0 0 0 3px rgba(59,130,246,0.15);
    }

    button {
      margin-top: 6px;
      height: 46px;
      border: none;
      border-radius: 10px;
      background: linear-gradient(135deg, #2563eb, #0ea5e9);
      color: white;
      font-weight: 700;
      cursor: pointer;
      transition: 0.2s;
    }

    button:hover {
      transform: translateY(-1px);
      box-shadow: 0 10px 20px rgba(37,99,235,0.25);
    }

    .error {
      color: #ef4444;
      text-align: center;
      font-size: 14px;
      margin-top: 10px;
      font-weight: 600;
    }

    .hint {
      font-size: 12px;
      color: #64748b;
    }
  </style>
</head>

<body>

<div class="container">

  <h2>Đặt lại mật khẩu</h2>
  <div class="title-line"></div>

  <form action="${pageContext.request.contextPath}/reset-password" method="post">

    <label>Mật khẩu mới</label>
    <input type="password" name="password" placeholder="Nhập mật khẩu mới" required>

    <label>Xác nhận mật khẩu</label>
    <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>

    <button type="submit">Đặt lại mật khẩu</button>
  </form>

  <c:if test="${not empty error}">
    <p class="error">${error}</p>
  </c:if>

</div>

</body>
</html>