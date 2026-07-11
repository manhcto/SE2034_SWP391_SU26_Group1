<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ho so | WonderVN</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: #f5f7fb;
            color: #0f172a;
            font-family: "Be Vietnam Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        }

        .customer-theme { --theme-main: #1d4ed8; --theme-dark: #0f172a; }
        .staff-theme { --theme-main: #0f766e; --theme-dark: #134e4a; }
        .guide-theme { --theme-main: #7c3aed; --theme-dark: #4c1d95; }
        .admin-theme { --theme-main: #dc2626; --theme-dark: #7f1d1d; }

        .profile-hero {
            padding: 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            background: linear-gradient(135deg, var(--theme-dark), var(--theme-main));
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
            color: var(--theme-main);
            text-decoration: none;
            font-size: 12px;
            font-weight: 900;
            letter-spacing: 0.45px;
            text-transform: uppercase;
            white-space: nowrap;
            border: 1px solid var(--theme-main);
        }

        .profile-edit.secondary {
            background: #ffffff;
            color: var(--theme-main);
            border: 1px solid var(--theme-main);
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

        .workspace-page {
            min-height: 100vh;
            background: #f5f7fb;
            padding: 28px 24px 40px;
        }

        .workspace-shell {
            max-width: 1140px;
            margin: 0 auto;
        }

        .workspace-content {
            min-width: 0;
        }

        .account-panel {
            background: #ffffff;
            border: 1px solid #e5eaf3;
            border-radius: 18px;
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.07);
            overflow: hidden;
        }

        .account-panel-head {
            padding: 24px 28px;
            border-bottom: 1px solid #edf2f7;
        }

        .account-kicker {
            margin: 0 0 8px;
            color: var(--theme-main);
            font-size: 11px;
            font-weight: 900;
            letter-spacing: 0.9px;
            text-transform: uppercase;
        }

        .account-title {
            margin: 0;
            color: #0f172a;
            font-size: 26px;
            font-weight: 900;
            line-height: 1.2;
        }

        .account-subtitle {
            margin: 8px 0 0;
            color: #64748b;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.6;
        }

        .profile-actions {
            padding: 0 28px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }

        .profile-actions-left,
        .profile-actions-right {
            display: flex;
        }

        .profile-actions-right {
            margin-left: auto;
        }

        @media (max-width: 900px) {
            .workspace-page { padding: 22px 14px 36px; }
        }

        @media (max-width: 720px) {
            .profile-hero { align-items: flex-start; flex-direction: column; }
            .profile-grid { grid-template-columns: 1fr; }
            .profile-actions {
                flex-direction: column;
                align-items: stretch;
            }
            .profile-actions-left,
            .profile-actions-right {
                width: 100%;
            }
            .profile-actions .profile-edit {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>

<body class="${empty profileTheme ? 'customer-theme' : profileTheme.concat('-theme')}">
<c:if test="${empty profileTheme || profileTheme == 'customer'}">
    <jsp:include page="/views/common/client-header.jsp"/>
</c:if>

<main class="workspace-page">
    <div class="workspace-shell">
        <section class="workspace-content">
            <article class="account-panel">
                <div class="profile-hero">
                    <div class="profile-main">
                        <img class="profile-avatar"
                             src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
                             alt="Avatar">
                        <div>
                            <h1 class="profile-name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</h1>
                            <div class="profile-email">${sessionScope.user.email}</div>
                        </div>
                    </div>
                </div>

                <div class="account-panel-head">
                    <p class="account-kicker">${profileKicker}</p>
                    <h2 class="account-title">${profileTitle}</h2>
                    <p class="account-subtitle">${profileSubtitle}</p>
                </div>

                <div class="profile-body">
                    <div class="profile-grid">
                        <div class="info-box">
                            <div class="info-label">Email</div>
                            <div class="info-value">${sessionScope.user.email}</div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">So dien thoai</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.phone}">${sessionScope.user.phone}</c:when>
                                    <c:otherwise>Chua cap nhat</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Ho</div>
                            <div class="info-value">${sessionScope.user.lastName}</div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Ten</div>
                            <div class="info-value">${sessionScope.user.firstName}</div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Gioi tinh</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.gender}">${sessionScope.user.gender}</c:when>
                                    <c:otherwise>Chua cap nhat</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Ngay sinh</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.dob}">${sessionScope.user.dob}</c:when>
                                    <c:otherwise>Chua cap nhat</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-box full">
                            <div class="info-label">Dia chi</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.address}">${sessionScope.user.address}</c:when>
                                    <c:otherwise>Chua cap nhat</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="profile-actions">
                    <div class="profile-actions-left">
                        <a class="profile-edit secondary" href="${profileHomePath}">
                            <i class="fa-solid fa-house"></i>
                            Quay ve trang chu
                        </a>
                    </div>

                    <div class="profile-actions-right">
                        <a class="profile-edit" href="${profileEditPath}">
                            <i class="fa-solid fa-pen-to-square"></i>
                            Chinh sua
                        </a>
                    </div>
                </div>
            </article>
        </section>
    </div>
</main>
</body>
</html>
