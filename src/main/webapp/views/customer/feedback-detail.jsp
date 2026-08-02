<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết đánh giá</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .feedback-detail-container {
            max-width: 950px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .detail-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
        }

        .detail-card h3 {
            margin-top: 0;
            margin-bottom: 18px;
            color: #111827;
            font-size: 20px;
            border-bottom: 1px solid #f3f4f6;
            padding-bottom: 12px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px 28px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .detail-label {
            color: #6b7280;
            font-size: 14px;
        }

        .detail-value {
            color: #111827;
            font-size: 16px;
            font-weight: 600;
            word-break: break-word;
        }

        .rate-value {
            color: #f59e0b;
            font-size: 22px;
            font-weight: 800;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: fit-content;
            padding: 6px 12px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 14px;
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
            color: #111827;
            font-size: 16px;
            line-height: 1.7;
            white-space: pre-line;
            margin: 0;
        }

        .feedback-image {
            width: 100%;
            max-height: 380px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            margin-top: 12px;
        }

        .error-box {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 16px 20px;
            border-radius: 8px;
            border: 1px solid #f87171;
            margin-bottom: 24px;
            font-weight: 700;
        }

        .detail-actions {
            display: flex;
            gap: 14px;
            justify-content: center;
            align-items: center;
            margin-top: 28px;
            flex-wrap: wrap;
        }

        .detail-btn {
            min-width: 170px;
            height: 48px;
            padding: 0 22px;
            border-radius: 999px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
            cursor: pointer;
            transition: 0.2s;
            box-sizing: border-box;
        }

        .detail-btn-primary {
            background: #2563eb;
            color: #ffffff;
            border: 1px solid #2563eb;
        }

        .detail-btn-primary:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: #ffffff;
        }

        .detail-btn-warning {
            background: #f59e0b;
            color: #ffffff;
            border: 1px solid #f59e0b;
        }

        .detail-btn-warning:hover {
            background: #d97706;
            border-color: #d97706;
            color: #ffffff;
        }

        .detail-btn-outline {
            background: #ffffff;
            color: #2563eb;
            border: 1px solid #2563eb;
        }

        .detail-btn-outline:hover {
            background: #eff6ff;
            color: #2563eb;
        }

        @media (max-width: 768px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }

            .detail-actions {
                flex-direction: column;
            }

            .detail-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="feedback-detail-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Chi tiết đánh giá</p>
                <h2>Chi tiết đánh giá</h2>
                <p>Thông tin chi tiết về đánh giá của khách hàng.</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="error-box">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty feedbackDetail}">
            <div class="detail-card">
                <h3>1. Thông tin đánh giá</h3>

                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">Mã đánh giá</span>
                        <span class="detail-value">${feedbackDetail.feedbackID}</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Điểm đánh giá</span>
                        <span class="detail-value rate-value">${feedbackDetail.rate} / 5</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Ngày tạo</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${feedbackDetail.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Trạng thái</span>
                        <span class="status-badge ${feedbackDetail.status == 'Visible' ? 'status-visible' : 'status-hidden'}">
                                ${feedbackDetail.status}
                        </span>
                    </div>
                </div>
            </div>

            <div class="detail-card">
                <h3>2. Nội dung đánh giá</h3>

                <p class="content-box">
                    <c:choose>
                        <c:when test="${not empty feedbackDetail.content}">
                            ${feedbackDetail.content}
                        </c:when>
                        <c:otherwise>Không có nội dung đánh giá.</c:otherwise>
                    </c:choose>
                </p>

                <c:if test="${not empty feedbackDetail.image}">
                    <img class="feedback-image"
                         src="${feedbackDetail.image}"
                         alt="Hình ảnh đánh giá">
                </c:if>
            </div>

            <div class="detail-card">
                <h3>3. Thông tin khách hàng</h3>

                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">User ID</span>
                        <span class="detail-value">${feedbackDetail.userID}</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Họ tên</span>
                        <span class="detail-value">${feedbackDetail.firstName} ${feedbackDetail.lastName}</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Email</span>
                        <span class="detail-value">${feedbackDetail.email}</span>
                    </div>
                </div>
            </div>

            <div class="detail-card">
                <h3>4. Thông tin Booking</h3>

                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">Booking ID</span>
                        <span class="detail-value">${feedbackDetail.bookingID}</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Mã đơn</span>
                        <span class="detail-value">${feedbackDetail.bookingCode}</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Loại đơn</span>
                        <span class="detail-value">${feedbackDetail.bookingType}</span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Tổng tiền</span>
                        <span class="detail-value">
                            <fmt:formatNumber value="${feedbackDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
                    </div>
                </div>
            </div>

            <div class="detail-actions">
                <a href="${pageContext.request.contextPath}/feedback-list"
                   class="detail-btn detail-btn-primary">
                    Danh sách đánh giá
                </a>

                <a href="${pageContext.request.contextPath}/home"
                   class="detail-btn detail-btn-outline">
                    Về trang chủ
                </a>
            </div>
        </c:if>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>