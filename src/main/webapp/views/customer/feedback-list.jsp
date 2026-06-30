<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Đánh giá khách hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            font-family: "Be Vietnam Pro", Arial, sans-serif;
            color: #0f172a;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .feedback-page {
            width: min(1180px, calc(100% - 32px));
            margin: 0 auto;
            padding: 32px 0 56px;
        }

        .page-hero {
            position: relative;
            overflow: hidden;
            border-radius: 32px;
            padding: 34px;
            color: #ffffff;
            background:
                    linear-gradient(135deg, rgba(15, 23, 42, 0.94), rgba(30, 64, 175, 0.86)),
                    url("${empty serviceImage ? 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=80' : serviceImage}");
            background-size: cover;
            background-position: center;
            box-shadow: 0 22px 55px rgba(15, 23, 42, 0.20);
            margin-bottom: 24px;
        }

        .page-hero::after {
            content: "";
            position: absolute;
            right: -80px;
            bottom: -110px;
            width: 280px;
            height: 280px;
            border-radius: 999px;
            background: rgba(37, 99, 235, 0.34);
            filter: blur(12px);
        }

        .page-hero > * {
            position: relative;
            z-index: 2;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 15px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.24);
            font-size: 14px;
            font-weight: 900;
            margin-bottom: 16px;
            backdrop-filter: blur(12px);
        }

        .hero-badge i {
            color: #facc15;
        }

        .page-hero h1 {
            margin: 0 0 12px;
            font-size: clamp(30px, 4vw, 48px);
            line-height: 1.15;
            font-weight: 950;
            letter-spacing: -1px;
            max-width: 820px;
        }

        .page-hero p {
            margin: 0;
            max-width: 760px;
            color: rgba(255, 255, 255, 0.92);
            font-size: 16px;
            line-height: 1.7;
            font-weight: 600;
        }

        .hero-info-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 22px;
        }

        .hero-info-pill {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.24);
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
        }

        .hero-info-pill i {
            color: #fde68a;
        }

        .notice-box {
            border-radius: 18px;
            padding: 15px 18px;
            margin-bottom: 18px;
            font-size: 14px;
            font-weight: 800;
            line-height: 1.6;
        }

        .notice-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }

        .notice-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .notice-info {
            background: #eff6ff;
            color: #1e3a8a;
            border: 1px solid #bfdbfe;
        }

        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .back-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-back,
        .btn-add,
        .btn-login,
        .btn-disabled {
            min-height: 46px;
            border-radius: 999px;
            padding: 11px 18px;
            font-size: 14px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: 0.18s ease;
        }

        .btn-back {
            background: #ffffff;
            border: 1px solid #dbe3ef;
            color: #0f172a;
            box-shadow: 0 8px 18px rgba(15, 23, 42, 0.06);
        }

        .btn-back:hover {
            background: #f8fafc;
            transform: translateY(-1px);
        }

        .btn-add {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border: none;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.20);
        }

        .btn-add:hover {
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 16px 30px rgba(37, 99, 235, 0.24);
        }

        .btn-login {
            background: #0f172a;
            color: #ffffff;
            border: none;
        }

        .btn-login:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .btn-disabled {
            background: #e2e8f0;
            color: #64748b;
            border: 1px solid #cbd5e1;
            cursor: default;
        }

        .summary-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 22px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.07);
            margin-bottom: 22px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .summary-item {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 16px;
        }

        .summary-label {
            font-size: 12px;
            font-weight: 900;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .summary-value {
            color: #0f172a;
            font-size: 16px;
            font-weight: 900;
            word-break: break-word;
        }

        .feedback-list {
            display: grid;
            gap: 18px;
        }

        .feedback-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 22px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.07);
        }

        .feedback-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 14px;
        }

        .customer-box {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 900;
            flex: 0 0 auto;
        }

        .customer-name {
            font-size: 16px;
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .feedback-date {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
        }

        .rate-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #fef3c7;
            color: #92400e;
            font-size: 14px;
            font-weight: 900;
            white-space: nowrap;
        }

        .service-line {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 12px;
            padding: 8px 12px;
            border-radius: 999px;
            background: #eef2ff;
            color: #312e81;
            font-size: 13px;
            font-weight: 800;
        }

        .content-box {
            color: #334155;
            font-size: 15px;
            line-height: 1.8;
            font-weight: 600;
            white-space: pre-wrap;
            margin-bottom: 14px;
        }

        .feedback-image {
            width: 100%;
            max-width: 520px;
            border-radius: 18px;
            border: 1px solid #e2e8f0;
            display: block;
            margin-top: 12px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.10);
        }

        .feedback-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            border-top: 1px dashed #cbd5e1;
            padding-top: 14px;
            margin-top: 14px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
        }

        .status-visible {
            background: #dcfce7;
            color: #166534;
        }

        .status-hidden {
            background: #fee2e2;
            color: #991b1b;
        }

        .feedback-actions {
            display: flex;
            align-items: center;
            gap: 9px;
            flex-wrap: wrap;
        }

        .btn-small {
            min-height: 38px;
            padding: 8px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }

        .btn-view {
            background: #4f46e5;
            color: #ffffff;
        }

        .btn-view:hover {
            color: #ffffff;
            background: #3730a3;
        }

        .btn-edit {
            background: #0f172a;
            color: #ffffff;
        }

        .btn-edit:hover {
            color: #ffffff;
            background: #1e293b;
        }

        .empty-box {
            background: #ffffff;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 52px 20px;
            text-align: center;
            color: #64748b;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
        }

        .empty-box i {
            font-size: 46px;
            color: #94a3b8;
            margin-bottom: 14px;
        }

        .empty-box h3 {
            color: #0f172a;
            margin: 0 0 8px;
            font-size: 24px;
            font-weight: 900;
        }

        .empty-box p {
            margin: 0;
            font-size: 15px;
            line-height: 1.7;
        }

        @media (max-width: 900px) {
            .summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .feedback-head {
                flex-direction: column;
            }
        }

        @media (max-width: 620px) {
            .feedback-page {
                width: calc(100% - 20px);
                padding-top: 20px;
            }

            .page-hero {
                padding: 24px;
                border-radius: 24px;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .top-actions {
                align-items: stretch;
            }

            .back-actions,
            .btn-back,
            .btn-add,
            .btn-login,
            .btn-disabled {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<div class="feedback-page">

    <section class="page-hero">
        <div class="hero-badge">
            <i class="fa-solid fa-star"></i>
            <span>Đánh giá khách hàng</span>
        </div>

        <c:choose>
            <c:when test="${not empty serviceName}">
                <h1>Đánh giá về ${serviceName}</h1>
                <p>
                    Xem nhận xét của những khách hàng đã sử dụng dịch vụ.
                    Bạn cũng có thể gửi đánh giá của mình sau khi đã đặt dịch vụ này.
                </p>
            </c:when>

            <c:otherwise>
                <h1>Danh sách đánh giá khách hàng</h1>
                <p>
                    Tổng hợp các đánh giá đã được công khai từ khách hàng trên hệ thống WonderVN.
                </p>
            </c:otherwise>
        </c:choose>

        <div class="hero-info-row">
            <div class="hero-info-pill">
                <i class="fa-solid fa-comments"></i>
                <span>${fn:length(feedbackList)} đánh giá</span>
            </div>

            <c:if test="${not empty serviceTypeText}">
                <div class="hero-info-pill">
                    <i class="fa-solid fa-layer-group"></i>
                    <span>${serviceTypeText}</span>
                </div>
            </c:if>

            <c:if test="${not empty serviceInfo.province}">
                <div class="hero-info-pill">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>${serviceInfo.province}</span>
                </div>
            </c:if>
        </div>
    </section>

    <c:if test="${param.success == 'add'}">
        <div class="notice-box notice-success">
            <i class="fa-solid fa-circle-check"></i>
            Gửi đánh giá thành công. Đánh giá của bạn đang chờ nhân viên duyệt trước khi công khai.
        </div>
    </c:if>

    <c:if test="${param.success == 'edit'}">
        <div class="notice-box notice-success">
            <i class="fa-solid fa-circle-check"></i>
            Cập nhật đánh giá thành công. Đánh giá của bạn đang chờ nhân viên duyệt lại.
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="notice-box notice-error">
            <i class="fa-solid fa-triangle-exclamation"></i>
                ${error}
        </div>
    </c:if>

    <div class="top-actions">
        <div class="back-actions">
            <c:choose>
                <c:when test="${type == 'Accommodation' && serviceID > 0}">
                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/accommodation/detail?id=${serviceID}">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại khách sạn
                    </a>

                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/accommodation">
                        <i class="fa-solid fa-list"></i>
                        Danh sách khách sạn
                    </a>
                </c:when>

                <c:when test="${type == 'Vehicle' && serviceID > 0}">
                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/vehicle/detail?id=${serviceID}">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại xe
                    </a>

                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/vehicle">
                        <i class="fa-solid fa-list"></i>
                        Danh sách xe
                    </a>
                </c:when>

                <c:otherwise>
                    <a class="btn-back" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-house"></i>
                        Về trang chủ
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${serviceID > 0}">
            <c:choose>
                <c:when test="${not isLoggedIn}">
                    <a class="btn-login"
                       href="${pageContext.request.contextPath}/login">
                        <i class="fa-solid fa-right-to-bracket"></i>
                        Đăng nhập để đánh giá
                    </a>
                </c:when>

                <c:when test="${canAddFeedback}">
                    <a class="btn-add"
                       href="${pageContext.request.contextPath}/feedback-add?type=${type}&serviceID=${serviceID}">
                        <i class="fa-solid fa-pen-to-square"></i>
                        Viết đánh giá
                    </a>
                </c:when>

                <c:when test="${not empty userFeedback}">
                    <a class="btn-add"
                       href="${pageContext.request.contextPath}/feedback-edit?feedbackID=${userFeedback.feedbackID}&type=${type}&serviceID=${serviceID}">
                        <i class="fa-solid fa-pen"></i>
                        Sửa đánh giá của tôi
                    </a>
                </c:when>

                <c:otherwise>
                    <span class="btn-disabled">
                        <i class="fa-solid fa-circle-info"></i>
                        Cần đặt dịch vụ trước khi đánh giá
                    </span>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>

    <c:if test="${serviceID > 0 && isLoggedIn && empty userFeedback && not canAddFeedback}">
        <div class="notice-box notice-info">
            <i class="fa-solid fa-circle-info"></i>
            Bạn cần đặt dịch vụ này trước khi gửi đánh giá.
        </div>
    </c:if>

    <c:if test="${not empty serviceInfo}">
        <div class="summary-card">
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">Dịch vụ</div>
                    <div class="summary-value">${serviceName}</div>
                </div>

                <div class="summary-item">
                    <div class="summary-label">Loại</div>
                    <div class="summary-value">${serviceTypeText}</div>
                </div>

                <div class="summary-item">
                    <div class="summary-label">Khu vực</div>
                    <div class="summary-value">
                        <c:choose>
                            <c:when test="${not empty serviceInfo.province}">
                                ${serviceInfo.province}
                            </c:when>
                            <c:otherwise>Chưa cập nhật</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="summary-item">
                    <div class="summary-label">Số đánh giá</div>
                    <div class="summary-value">${fn:length(feedbackList)} đánh giá</div>
                </div>
            </div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty feedbackList}">
            <div class="feedback-list">
                <c:forEach var="feedback" items="${feedbackList}">
                    <div class="feedback-card">
                        <div class="feedback-head">
                            <div class="customer-box">
                                <div class="avatar">
                                    <i class="fa-solid fa-user"></i>
                                </div>

                                <div>
                                    <div class="customer-name">
                                            ${feedback.customerName}
                                        <c:if test="${feedback.owner}">
                                            <span style="color:#2563eb;">(Bạn)</span>
                                        </c:if>
                                    </div>

                                    <div class="feedback-date">
                                        <i class="fa-regular fa-clock"></i>
                                        <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>

                            <div class="rate-badge">
                                <i class="fa-solid fa-star"></i>
                                <fmt:formatNumber value="${feedback.rate}" maxFractionDigits="0"/> / 5
                            </div>
                        </div>

                        <c:if test="${empty serviceInfo}">
                            <div class="service-line">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>${feedback.serviceTypeText}: ${feedback.serviceName}</span>
                            </div>
                        </c:if>

                        <div class="content-box">${feedback.content}</div>

                        <c:if test="${not empty feedback.image}">
                            <img class="feedback-image"
                                 src="${feedback.image}"
                                 alt="Ảnh đánh giá"
                                 onerror="this.style.display='none';">
                        </c:if>

                        <div class="feedback-footer">
                            <c:choose>
                                <c:when test="${feedback.status == 'Visible'}">
                                    <span class="status-badge status-visible">
                                        <i class="fa-solid fa-circle-check"></i>
                                        Hiển thị
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="status-badge status-hidden">
                                        <i class="fa-solid fa-eye-slash"></i>
                                        Đang chờ duyệt
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <div class="feedback-actions">
                                <a class="btn-small btn-view"
                                   href="${pageContext.request.contextPath}/feedback-detail?feedbackID=${feedback.feedbackID}&type=${feedback.serviceType}&serviceID=${feedback.serviceID}">
                                    <i class="fa-solid fa-eye"></i>
                                    Xem chi tiết
                                </a>

                                <c:if test="${feedback.owner}">
                                    <a class="btn-small btn-edit"
                                       href="${pageContext.request.contextPath}/feedback-edit?feedbackID=${feedback.feedbackID}&type=${feedback.serviceType}&serviceID=${feedback.serviceID}">
                                        <i class="fa-solid fa-pen"></i>
                                        Sửa
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-box">
                <i class="fa-regular fa-comments"></i>

                <c:choose>
                    <c:when test="${not empty serviceName}">
                        <h3>Chưa có đánh giá nào</h3>
                        <p>Dịch vụ này chưa có đánh giá được công khai. Bạn có thể là người đầu tiên đánh giá sau khi đặt dịch vụ.</p>
                    </c:when>

                    <c:otherwise>
                        <h3>Chưa có đánh giá nào</h3>
                        <p>Hiện chưa có đánh giá nào được công khai trong hệ thống.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

</body>
</html>