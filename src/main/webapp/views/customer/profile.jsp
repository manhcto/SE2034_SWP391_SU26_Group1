<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ | WonderVN</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f7fb;
            color: #0f172a;
        }

        .profile-hero {
            padding: 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            background: linear-gradient(135deg, #0f172a, #1d4ed8);
            color: #ffffff;
        }

        .profile-main {
            display: flex;
            align-items: center;
            gap: 18px;
            min-width: 0;
        }

        .profile-avatar {
            width: 82px;
            height: 82px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255, 255, 255, 0.28);
            background: #ffffff;
            flex: 0 0 auto;
        }

        .profile-name {
            margin: 0;
            font-size: 26px;
            font-weight: 900;
            line-height: 1.2;
            letter-spacing: 0;
        }

        .profile-email {
            margin-top: 8px;
            color: #dbeafe;
            font-size: 14px;
            font-weight: 700;
        }

        .profile-edit {
            min-height: 44px;
            padding: 0 16px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 9px;
            background: #ffffff;
            color: #1d4ed8;
            text-decoration: none;
            font-size: 12px;
            font-weight: 900;
            letter-spacing: 0.45px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .profile-body {
            padding: 26px 28px 30px;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
        }

        .info-box {
            min-height: 88px;
            border: 1px solid #e5eaf3;
            border-radius: 14px;
            background: #f8fafc;
            padding: 16px;
        }

        .info-label {
            margin-bottom: 8px;
            color: #64748b;
            font-size: 11px;
            font-weight: 900;
            letter-spacing: 0.55px;
            text-transform: uppercase;
        }

        .info-value {
            color: #0f172a;
            font-size: 15px;
            font-weight: 800;
            line-height: 1.5;
            word-break: break-word;
        }

        .info-box.full {
            grid-column: 1 / -1;
        }

        @media (max-width: 720px) {
            .profile-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .profile-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="account-page">
    <div class="account-shell">
        <jsp:include page="/views/common/account-sidebar.jsp"/>

        <section class="account-content">
            <article class="account-panel">
                <div class="profile-hero">
                    <div class="profile-main">
                        <img class="profile-avatar"
                             src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
                             alt="Avatar">
                        <div>
                            <h1 class="profile-name">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </h1>
                            <div class="profile-email">${sessionScope.user.email}</div>
                        </div>
                    </div>

                    <a class="profile-edit" href="${pageContext.request.contextPath}/edit-profile">
                        <i class="fa-solid fa-pen-to-square"></i>
                        Chỉnh sửa
                    </a>
                </div>

                <div class="account-panel-head">
                    <p class="account-kicker">Tài khoản</p>
                    <h2 class="account-title">Thông tin cá nhân</h2>
                    <p class="account-subtitle">Thông tin này được dùng để tự điền nhanh khi bạn đặt tour hoặc đặt phòng.</p>
                </div>

                <div class="profile-body">
                    <div class="profile-grid">
                        <div class="info-box">
                            <div class="info-label">Email</div>
                            <div class="info-value">${sessionScope.user.email}</div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.phone}">${sessionScope.user.phone}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Họ</div>
                            <div class="info-value">${sessionScope.user.lastName}</div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Tên</div>
                            <div class="info-value">${sessionScope.user.firstName}</div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Giới tính</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.gender}">${sessionScope.user.gender}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Ngày sinh</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.dob}">${sessionScope.user.dob}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-box full">
                            <div class="info-label">Địa chỉ</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.address}">${sessionScope.user.address}</c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </article>
        </section>
    </div>
</main>
</body>
</html>
