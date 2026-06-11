<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Login - WonderVN</title>

    <style>
        body {
            margin: 0;
            font-family: Arial;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg,#4facfe,#00f2fe);
        }

        .card {
            width: 380px;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        button {
            width: 100%;
            padding: 10px;
            border: none;
            background: #007bff;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background: #0056b3;
        }

        .error {
            color: red;
            text-align: center;
        }

        .links {
            display: flex;
            justify-content: space-between;
            margin-top: 12px;
            font-size: 14px;
        }

        .links a {
            color: #007bff;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="card">

    <h2>Đăng nhập</h2>

    <c:if test="${not empty successMsg}">
        <div class="success">
                ${successMsg}
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="error">
                ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">

        <input type="email" name="email" placeholder="Email" required />

        <input type="password" name="password" placeholder="Password" required />

        <button type="submit">Đăng nhập</button>

    </form>

    <div class="links">

        <a href="${pageContext.request.contextPath}/forgot-password">
            Quên mật khẩu?
        </a>

        <a href="${pageContext.request.contextPath}/register">
            Đăng ký
        </a>

    </div>

</div>

</body>
</html>