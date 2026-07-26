<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>WonderVN | Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <style>
        .payment-page {
            min-height: calc(100vh - 160px);
            padding: 48px 20px;
            background: #f4f7fb;
        }

        .payment-shell {
            width: min(980px, 100%);
            margin: 0 auto;
            background: #fff;
            border: 1px solid #dce4ef;
            border-radius: 8px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .payment-heading {
            padding: 28px 32px 22px;
            border-bottom: 1px solid #e5eaf1;
        }

        .payment-heading h1 {
            margin: 0 0 6px;
            color: #0f172a;
            font-size: 28px;
        }

        .payment-heading p {
            margin: 0;
            color: #64748b;
        }

        .payment-alert {
            margin: 20px 32px 0;
            padding: 13px 15px;
            border: 1px solid transparent;
            border-radius: 6px;
            font-weight: 700;
        }

        .payment-alert.success {
            color: #166534;
            background: #ecfdf3;
            border-color: #bbf7d0;
        }

        .payment-alert.error {
            color: #b42318;
            background: #fff1f0;
            border-color: #fecaca;
        }

        .payment-content {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 320px;
            gap: 32px;
            padding: 28px 32px 32px;
        }

        .payment-details {
            min-width: 0;
        }

        .payment-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px 28px;
        }

        .payment-label {
            display: block;
            margin-bottom: 5px;
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
        }

        .payment-value {
            color: #0f172a;
            font-size: 16px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .payment-status {
            display: inline-flex;
            align-items: center;
            min-height: 30px;
            padding: 5px 11px;
            border-radius: 999px;
            color: #92400e;
            background: #fef3c7;
            font-size: 13px;
            font-weight: 800;
        }

        .payment-status.paid {
            color: #166534;
            background: #dcfce7;
        }

        .payment-total-row {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-top: 28px;
            padding-top: 22px;
            border-top: 1px solid #e5eaf1;
        }

        .payment-total {
            color: #dc2626;
            font-size: 30px;
            font-weight: 900;
        }

        .payment-qr {
            padding-left: 30px;
            border-left: 1px solid #e5eaf1;
            text-align: center;
        }

        .payment-qr h2 {
            margin: 0 0 6px;
            color: #0f172a;
            font-size: 19px;
        }

        .payment-qr p {
            margin: 0 0 18px;
            color: #64748b;
            font-size: 14px;
        }

        .payment-qr img {
            display: block;
            width: min(280px, 100%);
            aspect-ratio: 1;
            margin: 0 auto 14px;
            border: 1px solid #dce4ef;
            border-radius: 6px;
        }

        .payment-countdown {
            margin: 0 auto 16px;
            padding: 10px 14px;
            width: fit-content;
            border-radius: 10px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 14px;
            font-weight: 800;
        }

        .payment-countdown.expired {
            background: #fff1f0;
            color: #b42318;
        }

        .payment-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 28px;
        }

        .payment-btn {
            min-height: 44px;
            padding: 0 18px;
            border: 1px solid #2563eb;
            border-radius: 6px;
            background: #fff;
            color: #1d4ed8;
            font: inherit;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .payment-btn.primary {
            color: #fff;
            background: #2563eb;
        }

        .bank-transfer {
            margin: 16px 0;
            padding-top: 16px;
            border-top: 1px solid #e5eaf1;
            text-align: left;
        }

        .bank-row {
            display: grid;
            gap: 3px;
            margin-bottom: 12px;
        }

        .bank-row:last-child {
            margin-bottom: 0;
        }

        .bank-label {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
        }

        .bank-value {
            color: #0f172a;
            font-size: 14px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .payment-note {
            margin-top: 12px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.5;
        }

        @media (max-width: 780px) {
            .payment-content {
                grid-template-columns: 1fr;
                padding: 24px 20px;
            }

            .payment-heading {
                padding: 24px 20px 20px;
            }

            .payment-alert {
                margin-inline: 20px;
            }

            .payment-qr {
                padding: 24px 0 0;
                border-top: 1px solid #e5eaf1;
                border-left: 0;
            }
        }

        @media (max-width: 540px) {
            .payment-grid {
                grid-template-columns: 1fr;
            }

            .payment-total-row {
                align-items: flex-start;
                flex-direction: column;
            }

            .payment-btn,
            .payment-actions form {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<main class="payment-page">
    <section class="payment-shell">
        <header class="payment-heading">
            <h1>Thanh toán booking</h1>
        </header>

        <c:if test="${not empty message}">
            <div class="payment-alert success"><c:out value="${message}" /></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="payment-alert error"><c:out value="${error}" /></div>
        </c:if>
        <c:if test="${not payosConfigured && not payment.paid}">
            <div class="payment-alert error">
                PayOS chưa được cấu hình. Vui lòng kiểm tra cấu hình kết nối thanh toán.
            </div>
        </c:if>

        <div class="payment-content">
            <div class="payment-details">
                <div class="payment-grid">
                    <div>
                        <span class="payment-label">Mã booking</span>
                        <span class="payment-value"><c:out value="${bookingSummary.bookingCode}" /></span>
                    </div>
                    <div>
                        <span class="payment-label">Dịch vụ</span>
                        <span class="payment-value"><c:out value="${bookingSummary.itemName}" /></span>
                    </div>
                    <div>
                        <span class="payment-label">Khách hàng</span>
                        <span class="payment-value">
                            <c:out value="${bookingSummary.firstName}" /> <c:out value="${bookingSummary.lastName}" />
                        </span>
                    </div>
                    <div>
                        <span class="payment-label">Trạng thái booking</span>
                        <span class="payment-value">
                            <c:choose>
                                <c:when test="${bookingSummary.status == 'Đang xử lý' || bookingSummary.status == 'Pending'}">Đang xử lý</c:when>
                                <c:when test="${bookingSummary.status == 'Đã duyệt' || bookingSummary.status == 'Confirmed'}">Đã xác nhận</c:when>
                                <c:when test="${bookingSummary.status == 'Đã hủy' || bookingSummary.status == 'Cancelled'}">Đã hủy</c:when>
                                <c:when test="${bookingSummary.status == 'Hoàn thành' || bookingSummary.status == 'Completed'}">Hoàn tất</c:when>
                                <c:otherwise><c:out value="${bookingSummary.status}" /></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div>
                        <span class="payment-label">Trạng thái thanh toán</span>
                        <span class="payment-status ${payment.paid ? 'paid' : ''}">${payment.displayStatus}</span>
                    </div>
                    <div>
                        <span class="payment-label">Giữ chỗ đến</span>
                        <span class="payment-value">
                            <c:choose>
                                <c:when test="${payment.reservationReleased}">Đã hoàn chỗ</c:when>
                                <c:when test="${not empty payment.expiredAt}">
                                    <fmt:formatDate value="${payment.expiredAt}" pattern="HH:mm dd/MM/yyyy" />
                                </c:when>
                                <c:otherwise>Không áp dụng</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="payment-total-row">
                    <div>
                        <span class="payment-label">Tổng thanh toán</span>
                        <span class="payment-total">
                            <fmt:formatNumber value="${bookingSummary.totalPrice}" type="number" maxFractionDigits="0" /> đ
                        </span>
                    </div>
                </div>

                <div class="payment-actions">
                    <a class="payment-btn"
                       href="${pageContext.request.contextPath}/booking-summary?bookingID=${bookingSummary.bookingID}">
                        Xem booking
                    </a>
                    <a class="payment-btn" href="${pageContext.request.contextPath}/booking-list">
                        Danh sách booking
                    </a>
                </div>
                <p class="payment-note">
                    Thanh toán PayOS không tự động duyệt booking. Nhân viên vẫn xử lý booking theo quy trình riêng.
                </p>
            </div>

            <aside class="payment-qr">
                <c:choose>
                    <c:when test="${payment.paid}">
                        <h2>Thanh toán thành công</h2>
                        <p>Mã QR và liên kết PayOS đã được xóa khỏi phiên hiện tại.</p>
                    </c:when>
                    <c:when test="${payment.reservationReleased}">
                        <h2>Đã hết thời gian giữ chỗ</h2>
                        <p>Payment không còn hiệu lực, slot hoặc phòng đã được hoàn lại.</p>
                    </c:when>
                    <c:when test="${paymentQrAvailable}">
                        <h2>Quét mã QR PayOS</h2>
                        <p>Mã có hiệu lực trong 15 phút kể từ khi được tạo.</p>
                        <c:if test="${not empty payment.expiredAt}">
                            <div class="payment-countdown" id="payment-countdown"
                                 data-expired-at="${payment.expiredAt.time}">
                                Còn lại --:--
                            </div>
                        </c:if>
                        <img src="${pageContext.request.contextPath}/payment/qr?bookingID=${bookingSummary.bookingID}"
                             alt="Mã QR thanh toán PayOS">
                        <div class="bank-transfer">
                            <div class="bank-row">
                                <span class="bank-label">Ngân hàng</span>
                                <span class="bank-value"><c:out value="${paymentBankName}" /></span>
                            </div>
                            <div class="bank-row">
                                <span class="bank-label">Chủ tài khoản</span>
                                <span class="bank-value"><c:out value="${paymentAccountName}" /></span>
                            </div>
                            <div class="bank-row">
                                <span class="bank-label">Số tài khoản</span>
                                <span class="bank-value"><c:out value="${paymentAccountNumber}" /></span>
                            </div>
                            <div class="bank-row">
                                <span class="bank-label">Số tiền</span>
                                <span class="bank-value">
                                    <fmt:formatNumber value="${paymentTransferAmount}" type="number" maxFractionDigits="0" /> đ
                                </span>
                            </div>
                            <div class="bank-row">
                                <span class="bank-label">Nội dung chuyển khoản</span>
                                <span class="bank-value"><c:out value="${paymentTransferDescription}" /></span>
                            </div>
                        </div>
                        <c:if test="${not empty paymentCheckoutUrl}">
                            <a class="payment-btn primary" target="_blank" rel="noopener noreferrer"
                               href="<c:out value='${paymentCheckoutUrl}' />">Mở trang PayOS</a>
                        </c:if>
                    </c:when>
                    <c:when test="${not empty paymentCheckoutUrl}">
                        <h2>Thanh toán qua PayOS</h2>
                        <p>PayOS không trả QR, hãy tiếp tục bằng liên kết bảo mật.</p>
                        <a class="payment-btn primary" target="_blank" rel="noopener noreferrer"
                           href="<c:out value='${paymentCheckoutUrl}' />">Mở trang PayOS</a>
                    </c:when>
                    <c:otherwise>
                        <h2>Chưa có mã thanh toán</h2>
                        <p>Kiểm tra cấu hình PayOS hoặc tạo lại phiên thanh toán.</p>
                    </c:otherwise>
                </c:choose>
            </aside>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script>
    (function () {
        const bookingId = "${bookingSummary.bookingID}";
        const statusUrl = "${pageContext.request.contextPath}/payment/status?bookingID=" + encodeURIComponent(bookingId);
        const countdown = document.getElementById("payment-countdown");
        let syncInFlight = false;

        function syncPaymentStatus(onChanged) {
            if (!bookingId || syncInFlight) {
                return;
            }
            syncInFlight = true;
            fetch(statusUrl, {
                method: "GET",
                headers: {
                    "X-Requested-With": "XMLHttpRequest"
                },
                cache: "no-store"
            }).then(function (response) {
                if (!response.ok) {
                    return null;
                }
                return response.json();
            }).then(function (data) {
                if (data && data.success && data.changed) {
                    window.location.reload();
                    return;
                }
                if (typeof onChanged === "function") {
                    onChanged(data);
                }
            }).catch(function () {
                // Ignore transient polling errors.
            }).finally(function () {
                syncInFlight = false;
            });
        }

        const pollTimer = window.setInterval(function () {
            syncPaymentStatus();
        }, 8000);

        if (!countdown) {
            return;
        }

        const expiredAt = Number(countdown.dataset.expiredAt);
        if (!Number.isFinite(expiredAt) || expiredAt <= 0) {
            countdown.remove();
            return;
        }

        function renderCountdown() {
            const remainingMs = expiredAt - Date.now();
            if (remainingMs <= 0) {
                countdown.textContent = "Mã thanh toán đã hết hạn";
                countdown.classList.add("expired");
                syncPaymentStatus(function (data) {
                    if (data && (data.changed
                            || data.bookingStatus === "Cancelled"
                            || data.paymentStatus === "Cancelled"
                            || data.bookingStatus === "Đã hủy"
                            || data.paymentStatus === "Đã hủy")) {
                        window.location.reload();
                    }
                });
                return false;
            }

            const totalSeconds = Math.floor(remainingMs / 1000);
            const minutes = Math.floor(totalSeconds / 60);
            const seconds = totalSeconds % 60;
            countdown.textContent = "Còn lại "
                + String(minutes).padStart(2, "0")
                + ":"
                + String(seconds).padStart(2, "0");
            return true;
        }

        if (!renderCountdown()) {
            return;
        }

        const timer = window.setInterval(function () {
            if (!renderCountdown()) {
                window.clearInterval(timer);
                window.clearInterval(pollTimer);
            }
        }, 1000);
    })();
</script>
</body>
</html>
