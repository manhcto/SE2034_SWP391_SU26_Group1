<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết đánh giá</title>
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

        .detail-page {
            width: min(1120px, calc(100% - 32px));
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
                    url("${empty feedbackDetail.serviceImage ? 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=80' : feedbackDetail.serviceImage}");
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

        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .back-actions,
        .right-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-back,
        .btn-edit {
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

        .btn-edit {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border: none;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.20);
        }

        .btn-edit:hover {
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 16px 30px rgba(37, 99, 235, 0.24);
        }

        .detail-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 28px;
            padding: 28px;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.08);
            margin-bottom: 22px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 18px;
            font-size: 22px;
            font-weight: 900;
            color: #0f172a;
        }

        .section-title i {
            color: #2563eb;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .customer-box {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .avatar {
            width: 58px;
            height: 58px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 900;
            font-size: 20px;
            flex: 0 0 auto;
        }

        .customer-name {
            font-size: 20px;
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 5px;
        }

        .review-date {
            color: #64748b;
            font-size: 14px;
            font-weight: 700;
        }

        .rate-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px 16px;
            border-radius: 999px;
            background: #fef3c7;
            color: #92400e;
            font-size: 16px;
            font-weight: 900;
            white-space: nowrap;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }

        .info-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 16px;
        }

        .info-label {
            font-size: 12px;
            font-weight: 900;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .info-value {
            color: #0f172a;
            font-size: 16px;
            font-weight: 900;
            word-break: break-word;
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

        .content-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 22px;
            color: #334155;
            font-size: 16px;
            font-weight: 600;
            line-height: 1.9;
            white-space: pre-wrap;
            margin-bottom: 24px;
        }

        .feedback-image {
            width: 100%;
            max-width: 620px;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            display: block;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.12);
        }

        .no-image {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 24px;
            color: #64748b;
            font-weight: 800;
            text-align: center;
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
            .info-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 620px) {
            .detail-page {
                width: calc(100% - 20px);
                padding-top: 20px;
            }

            .page-hero {
                padding: 24px;
                border-radius: 24px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .top-actions,
            .back-actions,
            .right-actions,
            .btn-back,
            .btn-edit {
                width: 100%;
            }

            .review-header {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<div class="detail-page">

    <c:choose>
        <c:when test="${not empty feedbackDetail}">
            <section class="page-hero">
                <div class="hero-badge">
                    <i class="fa-solid fa-star"></i>
                    <span>Chi tiết đánh giá</span>
                </div>

                <h1>Đánh giá về ${feedbackDetail.serviceName}</h1>

                <p>
                    Đây là đánh giá chi tiết từ khách hàng đã sử dụng dịch vụ trên WonderVN.
                    Các đánh giá đang ẩn chỉ hiển thị với người đã viết đánh giá đó.
                </p>

                <div class="hero-info-row">
                    <div class="hero-info-pill">
                        <i class="fa-solid fa-layer-group"></i>
                        <span>${feedbackDetail.serviceTypeText}</span>
                    </div>

                    <div class="hero-info-pill">
                        <i class="fa-solid fa-user"></i>
                        <span>${feedbackDetail.customerName}</span>
                    </div>

                    <div class="hero-info-pill">
                        <i class="fa-solid fa-ticket"></i>
                        <span>${feedbackDetail.bookingCode}</span>
                    </div>
                </div>
            </section>

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
                        <c:when test="${serviceID > 0}">
                            <a class="btn-back"
                               href="${pageContext.request.contextPath}/feedback-list?type=${type}&serviceID=${serviceID}">
                                <i class="fa-solid fa-arrow-left"></i>
                                Quay lại danh sách đánh giá
                            </a>
                        </c:when>

                        <c:otherwise>
                            <a class="btn-back"
                               href="${pageContext.request.contextPath}/feedback-list">
                                <i class="fa-solid fa-arrow-left"></i>
                                Quay lại danh sách đánh giá
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${type == 'Accommodation' && serviceID > 0}">
                            <a class="btn-back"
                               href="${pageContext.request.contextPath}/accommodation/detail?id=${serviceID}">
                                <i class="fa-solid fa-hotel"></i>
                                Quay lại khách sạn
                            </a>
                        </c:when>

                    </c:choose>
                </div>

                <div class="right-actions">
                    <c:if test="${canEditFeedback}">
                        <a class="btn-edit"
                           href="${pageContext.request.contextPath}/feedback-edit?feedbackID=${feedbackDetail.feedbackID}&type=${type}&serviceID=${serviceID}">
                            <i class="fa-solid fa-pen"></i>
                            Sửa đánh giá
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="detail-card">
                <div class="review-header">
                    <div class="customer-box">
                        <div class="avatar">
                            <i class="fa-solid fa-user"></i>
                        </div>

                        <div>
                            <div class="customer-name">
                                    ${feedbackDetail.customerName}
                                <c:if test="${canEditFeedback}">
                                    <span style="color:#2563eb;">(Bạn)</span>
                                </c:if>
                            </div>

                            <div class="review-date">
                                <i class="fa-regular fa-clock"></i>
                                <fmt:formatDate value="${feedbackDetail.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                    </div>

                    <div class="rate-badge">
                        <i class="fa-solid fa-star"></i>
                        <fmt:formatNumber value="${feedbackDetail.rate}" maxFractionDigits="0"/> / 5
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-box">
                        <div class="info-label">Dịch vụ</div>
                        <div class="info-value">${feedbackDetail.serviceName}</div>
                    </div>

                    <div class="info-box">
                        <div class="info-label">Loại dịch vụ</div>
                        <div class="info-value">${feedbackDetail.serviceTypeText}</div>
                    </div>

                    <div class="info-box">
                        <div class="info-label">Trạng thái</div>
                        <c:choose>
                            <c:when test="${feedbackDetail.status == 'Visible'}">
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
                    </div>

                    <div class="info-box">
                        <div class="info-label">Mã đặt chỗ</div>
                        <div class="info-value">${feedbackDetail.bookingCode}</div>
                    </div>

                    <div class="info-box">
                        <div class="info-label">Số lượng</div>
                        <div class="info-value">${feedbackDetail.quantity}</div>
                    </div>

                    <div class="info-box">
                        <div class="info-label">Tổng tiền đặt chỗ</div>
                        <div class="info-value">
                            <fmt:formatNumber value="${feedbackDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </div>
                    </div>
                </div>

                <h2 class="section-title">
                    <i class="fa-solid fa-align-left"></i>
                    Nội dung đánh giá
                </h2>

                <div class="content-box">${feedbackDetail.content}</div>

                <h2 class="section-title">
                    <i class="fa-solid fa-image"></i>
                    Hình ảnh đánh giá
                </h2>

                <c:choose>
                    <c:when test="${not empty feedbackDetail.image}">
                        <img class="feedback-image"
                             src="${feedbackDetail.image}"
                             alt="Ảnh đánh giá"
                             onerror="this.style.display='none';">
                    </c:when>

                    <c:otherwise>
                        <div class="no-image">
                            Đánh giá này không có hình ảnh.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:when>

        <c:otherwise>
            <c:if test="${not empty error}">
                <div class="notice-box notice-error">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                        ${error}
                </div>
            </c:if>

            <div class="empty-box">
                <i class="fa-regular fa-comment-dots"></i>
                <h3>Không tìm thấy đánh giá</h3>
                <p>Đánh giá này không tồn tại hoặc bạn không có quyền xem.</p>
            </div>

            <div style="margin-top: 18px;">
                <a class="btn-back" href="${pageContext.request.contextPath}/feedback-list">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại danh sách đánh giá
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

</body>
</html>
