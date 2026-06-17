<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Login - WonderVN</title>

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Arial,sans-serif;
        }

        body{
            min-height:100vh;
            display:flex;
            justify-content:center;
            align-items:center;
            background:linear-gradient(135deg,#4facfe,#00f2fe);
        }

        .card{
            width:420px;
            background:#fff;
            padding:35px;
            border-radius:18px;
            box-shadow:0 15px 35px rgba(0,0,0,.15);
        }

        h2{
            text-align:center;
            margin-bottom:25px;
            color:#111827;
            font-size:34px;
            font-weight:700;
        }

        form{
            width:100%;
        }

        input{
            width:100%;
            padding:14px 16px;
            margin-bottom:15px;
            border:1px solid #d1d5db;
            border-radius:10px;
            font-size:15px;
            outline:none;
            transition:.2s;
        }

        input:focus{
            border-color:#3b82f6;
            box-shadow:0 0 0 3px rgba(59,130,246,.15);
        }

        button{
            width:100%;
            padding:14px;
            border:none;
            border-radius:10px;
            background:#1677ff;
            color:white;
            font-size:16px;
            font-weight:700;
            cursor:pointer;
            transition:.2s;
        }

        button:hover{
            background:#0958d9;
        }

        .error{
            text-align:center;
            color:#dc2626;
            background:#fee2e2;
            padding:10px;
            border-radius:8px;
            margin-bottom:15px;
        }

        .success{
            text-align:center;
            color:#16a34a;
            background:#dcfce7;
            padding:10px;
            border-radius:8px;
            margin-bottom:15px;
        }

        .links{
            margin-top:18px;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }

        .links a{
            text-decoration:none;
            color:#1677ff;
            font-size:14px;
            transition:.2s;
        }

        .links a:hover{
            text-decoration:underline;
        }

        @media(max-width:500px){

            .card{
                width:90%;
                padding:25px;
            }

            h2{
                font-size:28px;
            }

            .links{
                flex-direction:column;
                gap:10px;
            }
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