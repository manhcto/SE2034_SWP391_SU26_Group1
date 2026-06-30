<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Profile | WonderVN</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:"Be Vietnam Pro",sans-serif;
        }

        body{
            background:#f5f7fb;
        }

        .profile-container{
            max-width:900px;
            margin:40px auto;
            padding:0 20px;
        }

        .profile-card{
            background:#fff;
            border-radius:20px;
            overflow:hidden;
            box-shadow:0 15px 35px rgba(0,0,0,.08);
        }

        .profile-header{
            background:linear-gradient(135deg,#2563eb,#3b82f6);
            padding:40px;
            text-align:center;
            color:white;
        }

        .avatar{
            width:120px;
            height:120px;
            border-radius:50%;
            object-fit:cover;
            border:5px solid rgba(255,255,255,.3);
            margin-bottom:15px;
        }

        .profile-header h2{
            margin-bottom:8px;
            font-size:28px;
        }

        .profile-header p{
            opacity:.9;
        }

        .profile-body{
            padding:35px;
        }

        .section-title{
            font-size:22px;
            font-weight:700;
            color:#1e293b;
            margin-bottom:25px;
        }

        .info-grid{
            display:grid;
            grid-template-columns:repeat(2,1fr);
            gap:20px;
        }

        .info-box{
            background:#f8fafc;
            border:1px solid #e2e8f0;
            border-radius:12px;
            padding:16px;
        }

        .info-label{
            color:#64748b;
            font-size:13px;
            margin-bottom:6px;
        }

        .info-value{
            color:#0f172a;
            font-size:16px;
            font-weight:600;
        }

        .action{
            margin-top:30px;
            text-align:center;
        }

        .btn{
            display:inline-block;
            padding:12px 24px;
            border-radius:10px;
            text-decoration:none;
            font-weight:600;
            transition:.2s;
        }

        .btn-home{
            background:#2563eb;
            color:white;
        }

        .btn-home:hover{
            background:#1d4ed8;
        }
        .action{
            margin-top:30px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:15px;
        }

        @media(max-width:768px){
            .action{
                flex-direction:column;
            }

            .action .btn{
                width:100%;
                text-align:center;
            }
        }
        .address-box{
            margin-top:20px;
        }
    </style>

</head>

<body>

`
<!-- Header -->
<jsp:include page="/views/common/customer-header.jsp"/>

<div class="profile-container">

    <div class="profile-card">

        <div class="profile-header">

            <img
                    class="avatar"
                    src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
                    alt="Avatar">

            <h2>
                ${sessionScope.user.firstName}
                ${sessionScope.user.lastName}
            </h2>

            <p>${sessionScope.user.email}</p>

        </div>

        <div class="profile-body">

            <div class="section-title">
                Thông tin cá nhân
            </div>

            <div class="info-grid">

                <div class="info-box">
                    <div class="info-label">Email</div>
                    <div class="info-value">
                        ${sessionScope.user.email}
                    </div>
                </div>
                <div class="info-box">
                    <div class="info-label">Số điện thoại</div>
                    <div class="info-value">
                        ${sessionScope.user.phone}
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-label">Tên</div>
                    <div class="info-value">
                        ${sessionScope.user.firstName}
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-label">Họ</div>
                    <div class="info-value">
                        ${sessionScope.user.lastName}
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-label">Giới tính</div>
                    <div class="info-value">
                        ${sessionScope.user.gender}
                    </div>
                </div>

                <div class="info-box">
                    <div class="info-label">Ngày sinh</div>
                    <div class="info-value">
                        ${sessionScope.user.dob}
                    </div>
                </div>

            </div>

            <div class="info-box address-box">
                <div class="info-label">Địa chỉ</div>
                <div class="info-value">
                    ${sessionScope.user.address}
                </div>
            </div>
            <div class="action">
                <a href="${pageContext.request.contextPath}/edit-profile"
                   class="btn btn-edit">
                    ✏️ Sửa hồ sơ
                </a>

                <a href="${pageContext.request.contextPath}/home"
                   class="btn btn-home">
                    🏠 Quay về trang chủ
                </a>

            </div>


        </div>

            </div>




        </div>

    </div>

</div>

</body>
</html>
