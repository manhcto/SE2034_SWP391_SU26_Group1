<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <style>
        .payment-container {
            max-width: 860px;
            margin: 0 auto;
            padding: 44px 20px;
        }

        .payment-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
        }

        .payment-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px 28px;
            margin: 22px 0;
        }

        .payment-label {
            display: block;
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 4px;
        }

        .payment-value {
            color: #111827;
            font-size: 16px;
            font-weight: 700;
        }

        .payment-total {
            color: #dc2626;
            font-size: 28px;
            font-weight: 800;
        }

        .payment-status {
            display: inline-flex;
            padding: 6px 12px;
            border-radius: 999px;
            background: #fef3c7;
            color: #92400e;
            font-weight: 800;
            font-size: 14px;
        }

        .payment-status.paid {
            background: #dcfce7;
            color: #166534;
        }

        .payment-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        .payment-btn {
            min-width: 170px;
            height: 46px;
            padding: 0 22px;
            border-radius: 999px;
            border: 1px solid #2563eb;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
        }

        .payment-btn-primary {
            background: #2563eb;
            color: #ffffff;
        }

        .payment-btn-outline {
            background: #ffffff;
            color: #2563eb;
        }

        .payment-alert {
            padding: 14px 16px;
            border-radius: 10px;
            margin-bottom: 18px;
            border: 1px solid transparent;
        }

        .payment-alert.error {
            background: #fee2e2;
            color: #b91c1c;
            border-color: #fecaca;
        }

        .payment-alert.success {
            background: #dcfce7;
            color: #166534;
            border-color: #bbf7d0;
        }

        @media (max-width: 720px) {
            .payment-grid {
                grid-template-columns: 1fr;
            }

            .payment-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="payment-container">
        <div class="payment-card">
            <p class="section-kicker">Payment</p>
            <h2>Thanh toán booking</h2>

            <c:if test="${not empty message}">
                <div class="payment-alert success">${message}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="payment-alert error">${error}</div>
            </c:if>

            <c:if test="${not payosConfigured}">
                <div class="payment-alert error">
                    Chưa cấu hình PayOS. Cần PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY và APP_BASE_URL.
                </div>
            </c:if>

            <c:if test="${mockPaymentEnabled}">
                <div class="payment-alert success">
                    Mock payment mode is enabled for dev/test.
                </div>
            </c:if>

            <div class="payment-grid">
                <div>
                    <span class="payment-label">Mã booking</span>
                    <span class="payment-value">${bookingSummary.bookingCode}</span>
                </div>

                <div>
                    <span class="payment-label">Dịch vụ</span>
                    <span class="payment-value">${bookingSummary.itemName}</span>
                </div>

                <div>
                    <span class="payment-label">Loại booking</span>
                    <span class="payment-value">${bookingSummary.bookingType}</span>
                </div>

                <div>
                    <span class="payment-label">Trạng thái thanh toán</span>
                    <span class="payment-status ${payment.paid ? 'paid' : ''}">
                        <c:choose>
                            <c:when test="${payment.status == 'Paid'}">Đã thanh toán</c:when>
                            <c:when test="${payment.status == 'Failed'}">Thất bại</c:when>
                            <c:when test="${payment.status == 'Cancelled'}">Đã hủy</c:when>
                            <c:otherwise>Chờ thanh toán</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div>
                    <span class="payment-label">Khách hàng</span>
                    <span class="payment-value">${bookingSummary.firstName} ${bookingSummary.lastName}</span>
                </div>

                <div>
                    <span class="payment-label">Tổng tiền</span>
                    <span class="payment-total">
                        <fmt:formatNumber value="${bookingSummary.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                    </span>
                </div>
            </div>

            <div class="payment-actions">
                <c:if test="${payment.status != 'Paid' && bookingSummary.status == 'Pending'}">
                    <form action="${pageContext.request.contextPath}/payment" method="post">
                        <input type="hidden" name="bookingID" value="${bookingSummary.bookingID}">
                        <button class="payment-btn payment-btn-primary" type="submit" ${payosConfigured ? '' : 'disabled'}>
                            Thanh toán qua PayOS
                        </button>
                    </form>

                    <c:if test="${mockPaymentEnabled}">
                        <form action="${pageContext.request.contextPath}/payment" method="post">
                            <input type="hidden" name="bookingID" value="${bookingSummary.bookingID}">
                            <input type="hidden" name="action" value="mockSuccess">
                            <button class="payment-btn payment-btn-outline" type="submit">
                                Mock thanh toan thanh cong
                            </button>
                        </form>
                    </c:if>
                </c:if>

                <a class="payment-btn payment-btn-outline"
                   href="${pageContext.request.contextPath}/booking-summary?bookingID=${bookingSummary.bookingID}">
                    Xem booking
                </a>

                <a class="payment-btn payment-btn-outline"
                   href="${pageContext.request.contextPath}/booking-list">
                    Danh sách booking
                </a>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>
