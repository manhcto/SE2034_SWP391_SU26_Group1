<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">

    <style>
        .booking-section {
            padding-top: 38px;
            padding-bottom: 34px;
        }

        .booking-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .booking-title-area {
            width: 100%;
            display: flex;
            justify-content: center;
            text-align: center;
            margin-bottom: 28px;
        }

        .booking-title-area > div {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .booking-title-area .section-kicker {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: auto;
            min-width: 130px;
            padding: 10px 28px;
            margin: 0 auto 12px;
        }

        .booking-title-area h2 {
            width: 100%;
            text-align: center;
            margin: 0 auto 12px;
        }

        .booking-title-area p {
            width: 100%;
            text-align: center;
            max-width: 720px;
            margin: 0 auto;
            color: #64748b;
        }

        .booking-card {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            margin: 0 auto;
        }

        .booking-card h3 {
            margin-top: 0;
            margin-bottom: 14px;
            font-size: 24px;
            color: #111827;
            text-align: left;
        }

        .booking-card > p {
            color: #374151;
            line-height: 1.7;
            text-align: left;
            margin: 0 0 22px;
        }

        .booking-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 22px 0;
            padding: 20px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e5e7eb;
        }

        .booking-info p {
            margin: 0;
            color: #334155;
            text-align: center;
        }

        .price-note {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 10px;
            padding: 16px;
            margin: 20px 0;
            color: #374151;
            font-weight: 700;
            text-align: center;
        }

        .price-note span {
            color: #2563eb;
            font-weight: 800;
        }

        .error-box {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 16px 18px;
            margin-bottom: 22px;
            font-weight: 700;
        }

        .error-box ul {
            margin: 10px 0 0;
            padding-left: 20px;
        }

        .vehicle-summary {
            display: grid;
            grid-template-columns: 180px minmax(0, 1fr);
            gap: 18px;
            padding: 16px;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            background: #f8fafc;
            margin-bottom: 24px;
        }

        .vehicle-summary img {
            width: 100%;
            aspect-ratio: 4 / 3;
            object-fit: cover;
            border-radius: 10px;
            background: #e5e7eb;
        }

        .vehicle-summary h3 {
            margin: 0 0 8px;
        }

        .vehicle-meta {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            color: #475569;
            font-size: 14px;
        }

        .vehicle-meta strong {
            color: #0f172a;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 16px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            color: #374151;
            font-size: 14px;
            font-weight: 800;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 12px 13px;
            font: inherit;
            outline: none;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .checkbox-line {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #374151;
            font-weight: 700;
            margin: 4px 0 18px;
        }

        .checkbox-line input {
            width: 18px;
            height: 18px;
        }

        .vehicle-total {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 10px;
            padding: 14px 16px;
            color: #1e3a8a;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .booking-actions {
            margin-top: 24px;
            width: 100%;
            text-align: center;
        }

        .booking-actions button {
            width: 100%;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: #ffffff;
            padding: 16px;
            font-size: 16px;
            font-weight: 800;
            cursor: pointer;
            transition: 0.2s ease;
            box-shadow: 0 14px 26px rgba(37, 99, 235, 0.22);
        }

        .booking-actions button:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 18px 34px rgba(37, 99, 235, 0.28);
        }

        @media (max-width: 768px) {
            .booking-section {
                padding-top: 28px;
                padding-bottom: 28px;
            }

            .booking-container {
                padding: 0 16px;
            }

            .booking-info {
                grid-template-columns: 1fr;
            }

            .vehicle-summary,
            .booking-form-grid,
            .vehicle-meta {
                grid-template-columns: 1fr;
            }

            .booking-card {
                padding: 24px;
            }

            .booking-card h3,
            .booking-card > p {
                text-align: center;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<c:choose>
    <c:when test="${bookingMode == 'vehicle'}">
        <main class="home-page">
            <section class="section booking-section">
                <div class="booking-container">
                    <div class="section-head booking-title-area">
                        <div>
                            <p class="section-kicker">Booking</p>
                            <h2>Đặt xe ngay</h2>
                            <p>Vui lòng kiểm tra thông tin xe và thời gian thuê trước khi xác nhận booking.</p>
                        </div>
                    </div>

                    <c:if test="${not empty errorList or not empty error}">
                        <div class="error-box">
                            <strong>Vui lòng kiểm tra lại thông tin:</strong>
                            <ul>
                                <c:if test="${not empty error}">
                                    <li>${error}</li>
                                </c:if>

                                <c:forEach items="${errorList}" var="err">
                                    <li>${err}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/booking"
                          method="post"
                          class="booking-card"
                          novalidate>
                        <input type="hidden" name="bookingType" value="Vehicle">
                        <input type="hidden" name="type" value="vehicle">
                        <input type="hidden" name="vehicleID" value="${vehicle.serviceID}">

                        <div class="vehicle-summary">
                            <img src="${empty vehicle.image ? 'https://placehold.co/600x400?text=WonderVN+Vehicle' : vehicle.image}"
                                 alt="${vehicle.displayName}"
                                 onerror="this.src='https://placehold.co/600x400?text=WonderVN+Vehicle';">

                            <div>
                                <h3>${vehicle.displayName}</h3>

                                <div class="vehicle-meta">
                                    <div><strong>Biển số:</strong> ${vehicle.licensePlate}</div>
                                    <div><strong>Số chỗ:</strong> ${vehicle.seatCount}</div>
                                    <div><strong>Loại xe:</strong> ${vehicle.vehicleType}</div>
                                    <div>
                                        <strong>Giá thuê:</strong>
                                        <fmt:formatNumber value="${vehicle.pricePerDay}" type="number" maxFractionDigits="0"/> đ/ngày
                                    </div>
                                    <div class="form-group full">
                                        <strong>Địa điểm nhận:</strong>
                                        ${vehicle.fullPickupAddress}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="booking-form-grid">
                            <div class="form-group">
                                <label for="firstName">Họ và tên đệm *</label>
                                <input type="text" id="firstName" name="firstName" value="${firstName}" required>
                            </div>

                            <div class="form-group">
                                <label for="lastName">Tên *</label>
                                <input type="text" id="lastName" name="lastName" value="${lastName}" required>
                            </div>

                            <div class="form-group">
                                <label for="email">Email *</label>
                                <input type="email" id="email" name="email" value="${email}" required>
                            </div>

                            <div class="form-group">
                                <label for="phone">Số điện thoại *</label>
                                <input type="text" id="phone" name="phone" value="${phone}" required>
                            </div>

                            <div class="form-group">
                                <label for="pickupDate">Ngày nhận xe *</label>
                                <input type="date"
                                       id="pickupDate"
                                       name="pickupDate"
                                       value="${not empty pickupDate ? pickupDate : defaultPickupDate}"
                                       min="${minPickupDate}"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="returnDate">Ngày trả xe *</label>
                                <input type="date"
                                       id="returnDate"
                                       name="returnDate"
                                       value="${not empty returnDate ? returnDate : defaultReturnDate}"
                                       min="${minPickupDate}"
                                       required>
                            </div>

                            <div class="form-group full">
                                <label for="address">Địa chỉ liên hệ *</label>
                                <input type="text" id="address" name="address" value="${address}" required>
                            </div>

                            <div class="form-group full">
                                <label for="note">Ghi chú</label>
                                <textarea id="note"
                                          name="note"
                                          rows="3"
                                          placeholder="Ví dụ: giờ nhận xe mong muốn, yêu cầu hỗ trợ...">${note}</textarea>
                            </div>
                        </div>

                        <label class="checkbox-line">
                            <input type="checkbox" name="isBookedForOther" <c:if test="${isBookedForOther}">checked</c:if>>
                            Tôi đang đặt xe hộ cho người khác
                        </label>

                        <div class="vehicle-total"
                             id="vehicleTotalPreview"
                             data-price="${vehicle.pricePerDay}">
                            Giá thuê:
                            <fmt:formatNumber value="${vehicle.pricePerDay}" type="number" maxFractionDigits="0"/> đ/ngày
                        </div>

                        <div class="booking-actions">
                            <button type="submit">
                                Xác nhận đặt xe
                            </button>
                        </div>
                    </form>
                </div>
            </section>
        </main>
    </c:when>

    <c:otherwise>
<main class="home-page">
    <section class="section booking-section">
        <div class="booking-container">
            <div class="section-head booking-title-area">
                <div>
                    <p class="section-kicker">Booking</p>
                    <h2>Đặt Tour Ngay</h2>
                    <p>Vui lòng kiểm tra thông tin tour trước khi chuyển sang bước Checkout.</p>
                </div>
            </div>

            <div class="booking-card">
                <h3>Hà Nội - Ninh Bình - Hạ Long 4N3Đ</h3>

                <p>
                    Hành trình khám phá miền Bắc với các điểm đến nổi bật như Hà Nội,
                    Ninh Bình và Vịnh Hạ Long. Tour phù hợp cho gia đình, nhóm bạn và khách du lịch muốn
                    trải nghiệm lịch trình rõ ràng, thuận tiện.
                </p>

                <div class="booking-info">
                    <p><strong>Khởi hành:</strong> TP. Hồ Chí Minh</p>
                    <p><strong>Thời lượng:</strong> 4 ngày 3 đêm</p>
                    <p><strong>Ngày đi:</strong> 15/06/2026</p>
                    <p><strong>Số chỗ còn nhận:</strong> 20</p>
                </div>

                <div class="price-note">
                    <span>Giá tour sẽ được hệ thống tính theo lịch trình đã chọn.</span>
                </div>

                <form action="${pageContext.request.contextPath}/views/customer/checkout.jsp"
                      method="get"
                      class="booking-actions">

                    <input type="hidden" name="tourScheduleID" value="1">
                    <input type="hidden" name="tourName" value="Hà Nội - Ninh Bình - Hạ Long 4N3Đ">

                    <button type="submit">
                        Tiếp tục đến Checkout
                    </button>
                </form>
            </div>
        </div>
    </section>
</main>
    </c:otherwise>
</c:choose>

<jsp:include page="/views/common/client-footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const pickupDate = document.getElementById("pickupDate");
        const returnDate = document.getElementById("returnDate");
        const preview = document.getElementById("vehicleTotalPreview");

        if (!pickupDate || !returnDate || !preview) {
            return;
        }

        const pricePerDay = Number(preview.dataset.price || 0);
        const formatter = new Intl.NumberFormat("vi-VN");

        function updateTotalPreview() {
            if (!pickupDate.value || !returnDate.value) {
                preview.textContent = "Giá thuê: " + formatter.format(pricePerDay) + " đ/ngày";
                return;
            }

            const start = new Date(pickupDate.value + "T00:00:00");
            const end = new Date(returnDate.value + "T00:00:00");
            const dayMs = 24 * 60 * 60 * 1000;
            const days = Math.round((end - start) / dayMs);

            if (days <= 0) {
                preview.textContent = "Ngày trả xe phải sau ngày nhận xe.";
                return;
            }

            preview.textContent = "Tổng dự kiến: "
                    + formatter.format(pricePerDay * days)
                    + " đ cho "
                    + days
                    + " ngày thuê.";
        }

        pickupDate.addEventListener("change", function () {
            if (pickupDate.value) {
                returnDate.min = pickupDate.value;
            }

            updateTotalPreview();
        });

        returnDate.addEventListener("change", updateTotalPreview);
        updateTotalPreview();
    });
</script>

</body>
</html>
