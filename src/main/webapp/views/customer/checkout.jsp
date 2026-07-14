<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Xác nhận đặt tour</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --dark: #0f172a;
            --muted: #64748b;
            --border: #e2e8f0;
            --soft: #f8fafc;
            --bg: #eef3f8;
            --shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: #1e293b;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .booking-page {
            padding: 28px 0 56px;
        }

        .page-head {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .page-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #e8f0ff;
            color: #1d4ed8;
            font-weight: 900;
            margin-bottom: 12px;
        }

        .page-title {
            margin: 0;
            color: var(--dark);
            font-size: 32px;
            line-height: 1.18;
            font-weight: 950;
        }

        .page-subtitle {
            color: var(--muted);
            margin: 10px 0 0;
            font-weight: 650;
            line-height: 1.6;
        }

        .booking-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 380px;
            gap: 22px;
            align-items: start;
        }

        .form-card,
        .summary-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        .form-card {
            padding: 26px;
            border-top: 4px solid var(--primary);
        }

        .summary-card {
            position: sticky;
            top: 96px;
            overflow: hidden;
        }

        .summary-image {
            height: 190px;
            background: #e2e8f0;
        }

        .summary-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .summary-body {
            padding: 22px 22px 24px;
        }

        .form-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 18px;
            color: var(--dark);
            font-size: 21px;
            font-weight: 950;
        }

        .form-section-note {
            margin: -8px 0 20px;
            color: var(--muted);
            font-size: 14px;
            font-weight: 650;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            display: block;
            margin-bottom: 7px;
            color: #27364f;
            font-size: 13px;
            font-weight: 900;
        }

        .form-control,
        .form-select {
            height: 50px;
            border-radius: 8px;
            border: 1px solid #dbe3ef;
            background: #ffffff;
            color: var(--dark);
            font-weight: 700;
        }

        input[type="file"].form-control {
            padding: 11px 14px;
        }

        input[type="number"].form-control::-webkit-inner-spin-button,
        input[type="number"].form-control::-webkit-outer-spin-button {
            opacity: 1;
            height: 34px;
        }

        textarea.form-control {
            min-height: 112px;
            padding-top: 14px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #7aa2ff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .summary-title {
            color: var(--dark);
            font-size: 22px;
            font-weight: 950;
            line-height: 1.3;
            margin-bottom: 6px;
        }

        .summary-place {
            color: #16a34a;
            font-weight: 850;
            margin-bottom: 16px;
        }

        .summary-line {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #526079;
            font-weight: 750;
        }

        .summary-line span:first-child {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .summary-line i {
            width: 18px;
            color: var(--primary);
        }

        .summary-line strong {
            color: var(--dark);
            text-align: right;
        }

        .summary-total {
            margin-top: 18px;
            padding: 16px;
            border-radius: 8px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

        .summary-total-label {
            color: #1e3a8a;
            font-weight: 900;
            margin-bottom: 5px;
        }

        .summary-total-value {
            color: #1d4ed8;
            font-size: 28px;
            font-weight: 950;
        }

        .form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .btn-submit-booking,
        .btn-soft-back {
            min-height: 52px;
            border-radius: 8px;
            padding: 13px 20px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
        }

        .btn-submit-booking {
            border: none;
            background: var(--primary);
            color: #ffffff;
            min-width: 180px;
        }

        .btn-submit-booking:hover {
            background: var(--primary-dark);
            color: #ffffff;
        }

        .btn-soft-back {
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: var(--dark);
        }

        .field-hint {
            display: block;
            margin-top: 7px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 650;
        }

        .field-message {
            display: block;
            min-height: 18px;
            margin-top: 6px;
            font-size: 12px;
            font-weight: 750;
        }

        .field-message.error {
            color: #dc2626;
        }

        .field-message.success {
            color: #16a34a;
        }

        .voucher-picker {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--border);
        }

        .voucher-picker-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: var(--dark);
            font-size: 14px;
            font-weight: 900;
        }

        .voucher-picker-title i {
            color: #15803d;
        }

        .voucher-option {
            display: grid;
            grid-template-columns: 18px minmax(0, 1fr);
            gap: 10px;
            align-items: start;
            padding: 10px 4px;
            border-bottom: 1px solid #edf2f7;
            cursor: pointer;
        }

        .voucher-option.disabled {
            opacity: 0.45;
            cursor: not-allowed;
        }

        .voucher-option input {
            margin-top: 3px;
            accent-color: #16a34a;
        }

        .voucher-option strong,
        .voucher-option small {
            display: block;
        }

        .voucher-option strong {
            color: #166534;
            font-size: 13px;
        }

        .voucher-option small,
        .voucher-empty {
            margin-top: 3px;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.5;
        }

        .voucher-discount {
            display: none;
        }

        .voucher-discount span,
        .voucher-discount strong,
        .voucher-discount i {
            color: #15803d;
        }

        .form-control.is-invalid,
        .form-select.is-invalid {
            border-color: #ef4444;
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1);
        }

        .form-control.is-valid,
        .form-select.is-valid {
            border-color: #22c55e;
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.1);
        }

        .identity-preview {
            display: none;
            margin-top: 10px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            overflow: hidden;
            background: #f8fafc;
            max-width: 260px;
        }

        .identity-preview img {
            width: 100%;
            max-height: 150px;
            object-fit: cover;
            display: block;
        }

        .booking-alert {
            border-radius: 8px;
            border: 1px solid #fecaca;
            background: #fee2e2;
            color: #7f1d1d;
            font-weight: 750;
        }

        .booking-alert ul {
            margin: 8px 0 0;
            padding-left: 22px;
        }

        @media (max-width: 992px) {
            .booking-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .page-head,
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .booking-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="container booking-page">
    <header class="page-head">
        <div>
            <div class="page-kicker">
                <i class="fa-solid fa-clipboard-check"></i>
                Xác nhận thông tin
            </div>
            <h1 class="page-title">Hoàn tất thông tin đặt tour</h1>
            <p class="page-subtitle">
                Thông tin được tự động lấy từ tài khoản của bạn. Bạn có thể chỉnh lại trước khi gửi yêu cầu đặt tour.
            </p>
        </div>

        <a class="btn-soft-back" href="${pageContext.request.contextPath}/tour-detail?id=${selectedTour.tourID}">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại tour
        </a>
    </header>

    <c:if test="${not empty errorList or not empty error}">
        <div class="alert booking-alert shadow-sm" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i>
            <strong>Vui lòng kiểm tra lại các thông tin sau:</strong>
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

    <div class="booking-layout">
        <section class="form-card">
            <h2 class="form-section-title">
                <i class="fa-solid fa-user-shield"></i>
                Thông tin khách đặt tour
            </h2>
            <p class="form-section-note">
                Thông tin được lấy từ tài khoản của bạn, có thể chỉnh lại nếu người đi tour dùng thông tin khác.
            </p>

            <form id="tourCheckoutForm"
                  action="${pageContext.request.contextPath}/booking"
                  method="post"
                  enctype="multipart/form-data"
                  accept-charset="UTF-8">

                <input type="hidden" name="tourScheduleID" value="${selectedSchedule.tourScheduleID}">

                <div class="booking-form-grid">
                    <div class="field">
                        <label for="firstName">Họ và tên đệm</label>
                        <input class="form-control" id="firstName" name="firstName"
                               value="${fn:escapeXml(firstName)}"
                               placeholder="VD: Nguyễn Văn" autocomplete="family-name" required>
                    </div>

                    <div class="field">
                        <label for="lastName">Tên</label>
                        <input class="form-control" id="lastName" name="lastName"
                               value="${fn:escapeXml(lastName)}"
                               placeholder="VD: A" autocomplete="given-name" required>
                    </div>

                    <div class="field">
                        <label for="email">Email</label>
                        <input class="form-control" id="email" type="email" name="email"
                               value="${fn:escapeXml(email)}"
                               placeholder="example@gmail.com" autocomplete="email" required>
                    </div>

                    <div class="field">
                        <label for="phone">Số điện thoại</label>
                        <input class="form-control" id="phone" name="phone"
                               value="${fn:escapeXml(phone)}"
                               placeholder="Nhập số điện thoại" autocomplete="tel" required>
                    </div>

                    <div class="field">
                        <label for="identityNumber">CCCD / CMND</label>
                        <input class="form-control"
                               id="identityNumber"
                               name="identityNumber"
                               value="${fn:escapeXml(identityNumber)}"
                               inputmode="numeric"
                               maxlength="23"
                               placeholder="Nhập 9 hoặc 12 chữ số"
                               required>
                        <span class="field-hint">Có thể nhập liền hoặc có khoảng trắng, hệ thống sẽ tự chuẩn hóa.</span>
                        <span class="field-message" id="identityNumberMessage"></span>
                    </div>

                    <div class="field">
                        <label for="identityImage">Ảnh CCCD / CMND</label>
                        <input class="form-control"
                               id="identityImage"
                               name="identityImage"
                               type="file"
                               accept=".jpg,.jpeg,.png,.webp,image/png,image/jpeg,image/webp"
                               required>
                        <span class="field-hint">JPG, JPEG, PNG hoặc WEBP; tối đa 5MB.</span>
                        <span class="field-message" id="identityImageMessage"></span>
                        <div class="identity-preview" id="identityPreview">
                            <img id="identityPreviewImage" alt="Ảnh CCCD / CMND đã chọn">
                        </div>
                    </div>

                    <div class="field">
                        <label for="city">Tỉnh/Thành phố</label>
                        <select class="form-select" id="city" name="provinceCode" required>
                            <option value="">Chọn tỉnh/thành phố</option>
                        </select>
                        <span class="field-message" id="cityMessage"></span>
                    </div>

                    <div class="field">
                        <label for="administrativeUnitID">Phường/Xã</label>
                        <select class="form-select" id="administrativeUnitID" name="administrativeUnitID" required disabled>
                            <option value="">Chọn phường/xã</option>
                        </select>
                        <span class="field-message" id="wardMessage"></span>
                    </div>

                    <div class="field full">
                        <label for="streetAddress">Số nhà, đường</label>
                        <input class="form-control"
                               id="streetAddress"
                               name="streetAddress"
                               value="${fn:escapeXml(streetAddress)}"
                               maxlength="120"
                               placeholder="VD: 12 Tràng Tiền"
                               autocomplete="street-address"
                               required>
                        <span class="field-hint">Chỉ nhập chữ, số, khoảng trắng và các ký tự , . / -</span>
                        <span class="field-message" id="streetAddressMessage"></span>
                    </div>

                    <div class="field">
                        <label for="numberAdult">Số người lớn</label>
                        <input class="form-control"
                               id="numberAdult"
                               name="numberAdult"
                               type="number"
                               min="1"
                               max="${selectedSchedule.remainingSeats}"
                               step="1"
                               value="${not empty numberAdult ? numberAdult : 1}"
                               required>
                        <span class="field-hint">Dùng mũi tên lên/xuống để chọn số lượng.</span>
                        <span class="field-message" id="numberAdultMessage"></span>
                    </div>

                    <div class="field">
                        <label for="numberChildren">Số trẻ em</label>
                        <input class="form-control"
                               id="numberChildren"
                               name="numberChildren"
                               type="number"
                               min="0"
                               max="${selectedSchedule.remainingSeats}"
                               step="1"
                               value="${not empty numberChildren ? numberChildren : 0}"
                               required>
                        <span class="field-hint">Dùng mũi tên lên/xuống để chọn số lượng.</span>
                        <span class="field-message" id="numberChildrenMessage"></span>
                    </div>

                    <div class="field full">
                        <label for="note">Ghi chú cho tour (nếu có)</label>
                        <textarea class="form-control" id="note" name="note"
                                  placeholder="Ví dụ: Ăn chay, yêu cầu xe lăn, ghép phòng...">${fn:escapeXml(note)}</textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <a class="btn-soft-back" href="${pageContext.request.contextPath}/tour-detail?id=${selectedTour.tourID}">
                        Hủy
                    </a>
                    <button class="btn-submit-booking" type="submit">
                        <i class="fa-solid fa-credit-card"></i>
                        Thanh toán
                    </button>
                </div>
            </form>
        </section>

        <aside class="summary-card">
            <div class="summary-image">
                <img src="${fn:escapeXml(selectedTour.image)}"
                     alt="${fn:escapeXml(selectedTour.tourName)}"
                     onerror="this.src='https://placehold.co/800x450?text=WonderVN+Tour';">
            </div>

            <div class="summary-body">
                <div class="summary-title"><c:out value="${selectedTour.tourName}"/></div>
                <div class="summary-place">
                    <i class="fa-solid fa-location-dot me-1"></i>
                    <c:out value="${selectedTour.startPlace}"/>
                    <c:if test="${not empty selectedTour.endPlace}">
                        &rarr; <c:out value="${selectedTour.endPlace}"/>
                    </c:if>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-calendar-check"></i> Khởi hành</span>
                    <strong><fmt:formatDate value="${selectedSchedule.startDate}" pattern="dd/MM/yyyy"/></strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-calendar-xmark"></i> Kết thúc</span>
                    <strong><fmt:formatDate value="${selectedSchedule.endDate}" pattern="dd/MM/yyyy"/></strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-chair"></i> Chỗ còn lại</span>
                    <strong>${selectedSchedule.remainingSeats} chỗ</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-user-group"></i> Số khách</span>
                    <strong id="guestSummary">1 người lớn, 0 trẻ em</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-tag"></i> Giá người lớn</span>
                    <strong><fmt:formatNumber value="${checkoutAdultPrice}" type="number" maxFractionDigits="0"/> đ</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-child"></i> Giá trẻ em</span>
                    <strong><fmt:formatNumber value="${checkoutChildPrice}" type="number" maxFractionDigits="0"/> đ</strong>
                </div>

                <div class="voucher-picker" aria-labelledby="voucherPickerTitle">
                    <div class="voucher-picker-title" id="voucherPickerTitle">
                        <i class="fa-solid fa-ticket"></i>
                        Chọn voucher
                    </div>

                    <label class="voucher-option">
                        <input type="radio"
                               name="userVoucherID"
                               value=""
                               form="tourCheckoutForm"
                               checked>
                        <span>
                            <strong>Không sử dụng voucher</strong>
                            <small>Thanh toán theo giá gốc.</small>
                        </span>
                    </label>

                    <c:forEach var="voucher" items="${applicableVouchers}">
                        <label class="voucher-option">
                            <input type="radio"
                                   name="userVoucherID"
                                   value="${voucher.userVoucherID}"
                                   form="tourCheckoutForm"
                                   data-code="${fn:escapeXml(voucher.code)}"
                                   data-percent="${voucher.percentDiscount}"
                                   data-amount="${voucher.amountDiscount}"
                                   data-min="${voucher.minOrderAmount}"
                                ${not empty selectedUserVoucherID and selectedUserVoucherID == voucher.userVoucherID ? 'checked' : ''}>
                            <span>
                                <strong><c:out value="${voucher.code}"/></strong>
                                <small>
                                    <c:choose>
                                        <c:when test="${not empty voucher.percentDiscount}">
                                            Giảm <fmt:formatNumber value="${voucher.percentDiscount}" maxFractionDigits="0"/>%
                                        </c:when>
                                        <c:otherwise>
                                            Giảm <fmt:formatNumber value="${voucher.amountDiscount}" type="number" maxFractionDigits="0"/> đ
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty voucher.minOrderAmount}">
                                        &middot; Đơn tối thiểu <fmt:formatNumber value="${voucher.minOrderAmount}" type="number" maxFractionDigits="0"/> đ
                                    </c:if>
                                </small>
                            </span>
                        </label>
                    </c:forEach>

                    <c:if test="${empty applicableVouchers}">
                        <div class="voucher-empty">Bạn chưa có voucher phù hợp với đơn đặt tour này.</div>
                    </c:if>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-money-bill-wave"></i> Giá gốc</span>
                    <strong id="baseTotalValue">0 đ</strong>
                </div>

                <div class="summary-line voucher-discount" id="voucherDiscountLine">
                    <span><i class="fa-solid fa-ticket"></i> <span id="voucherDiscountLabel">Voucher</span></span>
                    <strong id="voucherDiscountValue">-0 đ</strong>
                </div>

                <div class="summary-total">
                    <div class="summary-total-label">Tổng thanh toán (tạm tính)</div>
                    <div class="summary-total-value" id="bookingTotalValue">0 đ</div>
                </div>
            </div>
        </aside>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("tourCheckoutForm");
        const citySelect = document.getElementById("city");
        const wardSelect = document.getElementById("administrativeUnitID");
        const identityNumberInput = document.getElementById("identityNumber");
        const identityImageInput = document.getElementById("identityImage");
        const identityNumberMessage = document.getElementById("identityNumberMessage");
        const identityImageMessage = document.getElementById("identityImageMessage");
        const cityMessage = document.getElementById("cityMessage");
        const wardMessage = document.getElementById("wardMessage");
        const identityPreview = document.getElementById("identityPreview");
        const identityPreviewImage = document.getElementById("identityPreviewImage");
        const streetAddressInput = document.getElementById("streetAddress");
        const streetAddressMessage = document.getElementById("streetAddressMessage");
        const numberAdultInput = document.getElementById("numberAdult");
        const numberChildrenInput = document.getElementById("numberChildren");
        const numberAdultMessage = document.getElementById("numberAdultMessage");
        const numberChildrenMessage = document.getElementById("numberChildrenMessage");
        const guestSummary = document.getElementById("guestSummary");
        const baseTotalValue = document.getElementById("baseTotalValue");
        const voucherDiscountLine = document.getElementById("voucherDiscountLine");
        const voucherDiscountLabel = document.getElementById("voucherDiscountLabel");
        const voucherDiscountValue = document.getElementById("voucherDiscountValue");
        const bookingTotalValue = document.getElementById("bookingTotalValue");

        const administrativeUnits = ${administrativeUnitsJson};
        const selectedUnitID = "${selectedAdministrativeUnitID}";

        const ADULT_PRICE = Number("${checkoutAdultPrice}") || 0;
        const CHILD_PRICE = Number("${checkoutChildPrice}") || 0;
        const MAX_SEATS = Number("${selectedSchedule.remainingSeats}") || 1;

        const currency = new Intl.NumberFormat("vi-VN", { maximumFractionDigits: 0 });
        let previewObjectUrl = null;

        function getVoucherInputs() {
            return Array.from(document.querySelectorAll("input[name='userVoucherID']"));
        }

        /* ---------- Guest count spinners (arrow keys / spinner only) ---------- */

        function clampCount(input, min) {
            let value = parseInt(input.value, 10);

            if (isNaN(value)) {
                value = min;
            }

            const otherInput = input === numberAdultInput ? numberChildrenInput : numberAdultInput;
            const otherValue = parseInt(otherInput.value, 10) || 0;
            const maxForThis = Math.max(min, MAX_SEATS - otherValue);

            if (value < min) {
                value = min;
            }

            if (value > maxForThis) {
                value = maxForThis;
            }

            input.value = value;
            input.max = maxForThis;
        }

        function blockTyping(event) {
            const allowedKeys = ["ArrowUp", "ArrowDown", "Tab"];

            if (!allowedKeys.includes(event.key)) {
                event.preventDefault();
            }
        }

        function getCounts() {
            return {
                adults: parseInt(numberAdultInput.value, 10) || 1,
                children: parseInt(numberChildrenInput.value, 10) || 0
            };
        }

        function validateGuestCounts(showError) {
            const counts = getCounts();
            let valid = true;

            if (counts.adults < 1) {
                if (showError) {
                    setFieldState(numberAdultInput, numberAdultMessage, false, "Số người lớn phải lớn hơn hoặc bằng 1.");
                }
                valid = false;
            } else {
                clearFieldState(numberAdultInput, numberAdultMessage);
            }

            if (counts.children < 0) {
                if (showError) {
                    setFieldState(numberChildrenInput, numberChildrenMessage, false, "Số trẻ em không được nhỏ hơn 0.");
                }
                valid = false;
            } else {
                clearFieldState(numberChildrenInput, numberChildrenMessage);
            }

            if (counts.adults + counts.children > MAX_SEATS) {
                setFieldState(numberChildrenInput, numberChildrenMessage, false,
                    "Tổng số khách vượt quá số chỗ còn lại (" + MAX_SEATS + " chỗ).");
                valid = false;
            }

            return valid;
        }

        /* ---------- Price + voucher summary ---------- */

        function getBaseTotal() {
            const counts = getCounts();
            return counts.adults * ADULT_PRICE + counts.children * CHILD_PRICE;
        }

        function refreshVoucherAvailability(baseTotal) {
            getVoucherInputs().forEach(function (input) {
                if (!input.value) {
                    return;
                }

                const minOrder = Number(input.dataset.min) || 0;
                const usable = minOrder <= baseTotal;
                input.disabled = !usable;
                input.closest(".voucher-option").classList.toggle("disabled", !usable);

                if (!usable && input.checked) {
                    input.checked = false;
                    const noVoucher = getVoucherInputs().find(function (item) {
                        return item.value === "";
                    });
                    if (noVoucher) {
                        noVoucher.checked = true;
                    }
                }
            });
        }

        function updateSummary() {
            const counts = getCounts();
            const baseTotal = getBaseTotal();

            guestSummary.textContent = counts.adults + " người lớn, " + counts.children + " trẻ em";
            baseTotalValue.textContent = currency.format(baseTotal) + " đ";

            refreshVoucherAvailability(baseTotal);

            const selectedVoucher = getVoucherInputs().find(function (input) {
                return input.checked;
            });
            const percent = Number(selectedVoucher ? selectedVoucher.dataset.percent : 0) || 0;
            const amount = Number(selectedVoucher ? selectedVoucher.dataset.amount : 0) || 0;
            const voucherCode = selectedVoucher ? selectedVoucher.dataset.code : "";
            const discount = Math.min(baseTotal, amount > 0 ? amount : baseTotal * percent / 100);
            const finalTotal = Math.max(0, baseTotal - discount);

            bookingTotalValue.textContent = currency.format(finalTotal) + " đ";
            voucherDiscountLabel.textContent = voucherCode ? "Voucher " + voucherCode : "Voucher";
            voucherDiscountValue.textContent = "-" + currency.format(discount) + " đ";
            voucherDiscountLine.style.display = discount > 0 ? "flex" : "none";
        }

        /* ---------- Field state helpers ---------- */

        function setFieldState(input, messageEl, valid, message) {
            if (!input || !messageEl) {
                return;
            }

            input.classList.toggle("is-valid", valid);
            input.classList.toggle("is-invalid", !valid);
            messageEl.classList.toggle("success", valid);
            messageEl.classList.toggle("error", !valid);
            messageEl.textContent = message;
        }

        function clearFieldState(input, messageEl) {
            if (!input || !messageEl) {
                return;
            }

            input.classList.remove("is-valid", "is-invalid");
            messageEl.classList.remove("success", "error");
            messageEl.textContent = "";
        }

        /* ---------- Identity number ---------- */

        function normalizeIdentityNumber(value) {
            return (value || "").replace(/\D/g, "");
        }

        function validateIdentityNumber(showEmptyError) {
            const digits = normalizeIdentityNumber(identityNumberInput.value);

            if (!digits) {
                if (showEmptyError) {
                    setFieldState(identityNumberInput, identityNumberMessage, false, "Vui lòng nhập CCCD/CMND.");
                } else {
                    clearFieldState(identityNumberInput, identityNumberMessage);
                }
                return false;
            }

            if (digits.length !== 9 && digits.length !== 12) {
                setFieldState(identityNumberInput, identityNumberMessage, false, "CCCD/CMND phải gồm đúng 9 hoặc 12 chữ số.");
                return false;
            }

            setFieldState(identityNumberInput, identityNumberMessage, true, "CCCD/CMND hợp lệ.");
            return true;
        }

        function normalizeIdentityInput() {
            const digits = normalizeIdentityNumber(identityNumberInput.value);
            if (digits) {
                identityNumberInput.value = digits;
            }
            validateIdentityNumber(false);
        }

        /* ---------- Identity image ---------- */

        function validateIdentityImage(showEmptyError) {
            const file = identityImageInput.files && identityImageInput.files[0];

            if (!file) {
                if (previewObjectUrl) {
                    URL.revokeObjectURL(previewObjectUrl);
                    previewObjectUrl = null;
                }
                identityPreview.style.display = "none";
                identityPreviewImage.removeAttribute("src");

                if (showEmptyError) {
                    setFieldState(identityImageInput, identityImageMessage, false, "Vui lòng chọn ảnh CCCD/CMND.");
                } else {
                    clearFieldState(identityImageInput, identityImageMessage);
                }
                return false;
            }

            const allowedTypes = ["image/jpeg", "image/jpg", "image/pjpeg", "image/png", "image/webp"];
            const allowedExtensions = /\.(jpe?g|png|webp)$/i;
            const validType = allowedTypes.includes((file.type || "").toLowerCase()) || allowedExtensions.test(file.name || "");
            const validSize = file.size <= 5 * 1024 * 1024;

            if (!validType) {
                identityPreview.style.display = "none";
                setFieldState(identityImageInput, identityImageMessage, false, "Ảnh CCCD phải là JPG, JPEG, PNG hoặc WEBP.");
                return false;
            }

            if (!validSize) {
                identityPreview.style.display = "none";
                setFieldState(identityImageInput, identityImageMessage, false, "Ảnh CCCD không được vượt quá 5MB.");
                return false;
            }

            if (previewObjectUrl) {
                URL.revokeObjectURL(previewObjectUrl);
            }

            previewObjectUrl = URL.createObjectURL(file);
            identityPreviewImage.src = previewObjectUrl;
            identityPreview.style.display = "block";
            setFieldState(identityImageInput, identityImageMessage, true, "Ảnh CCCD hợp lệ.");
            return true;
        }

        /* ---------- Street address ---------- */

        function validateStreetAddress(showEmptyError) {
            const value = (streetAddressInput.value || "").trim();
            const validPattern = /^[\p{L}0-9\s,./-]+$/u;

            if (!value) {
                if (showEmptyError) {
                    setFieldState(streetAddressInput, streetAddressMessage, false, "Vui lòng nhập số nhà, đường.");
                } else {
                    clearFieldState(streetAddressInput, streetAddressMessage);
                }
                return false;
            }

            if (value.length > 120 || !validPattern.test(value)) {
                setFieldState(streetAddressInput, streetAddressMessage, false, "Chỉ dùng chữ, số, khoảng trắng và ký tự , . / -");
                return false;
            }

            setFieldState(streetAddressInput, streetAddressMessage, true, "Địa chỉ cụ thể hợp lệ.");
            return true;
        }

        /* ---------- Province / ward selects ---------- */

        function groupUnitsByProvince(units) {
            const provinceMap = new Map();

            (units || []).forEach(function (unit) {
                const provinceCode = (unit.provinceCode || "").trim();
                const provinceName = (unit.provinceName || "").trim();
                const wardName = (unit.wardName || "").trim();
                const administrativeUnitID = Number(unit.administrativeUnitID);

                if (!provinceCode || !provinceName || !wardName || !administrativeUnitID) {
                    return;
                }

                if (!provinceMap.has(provinceCode)) {
                    provinceMap.set(provinceCode, {
                        provinceName: provinceName,
                        wards: []
                    });
                }

                provinceMap.get(provinceCode).wards.push({
                    administrativeUnitID: administrativeUnitID,
                    wardName: wardName,
                    wardType: (unit.wardType || "").trim()
                });
            });

            return provinceMap;
        }

        const provinceMap = groupUnitsByProvince(administrativeUnits);

        function populateProvinceOptions() {
            citySelect.innerHTML = '<option value="">Chọn tỉnh/thành phố</option>';

            Array.from(provinceMap.entries()).forEach(function ([provinceCode, province]) {
                const option = document.createElement("option");
                option.value = provinceCode;
                option.textContent = province.provinceName;
                citySelect.appendChild(option);
            });
        }

        function resetWardOptions(disabled) {
            wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
            wardSelect.disabled = disabled;
        }

        function populateWardOptions(provinceCode, selectedID) {
            resetWardOptions(true);

            const province = provinceMap.get(provinceCode);
            const wards = province ? province.wards : [];
            if (!wards.length) {
                return;
            }

            wards.forEach(function (ward) {
                const option = document.createElement("option");
                option.value = ward.administrativeUnitID;
                const normalizedWardName = ward.wardName.toLowerCase();
                const normalizedWardType = ward.wardType.toLowerCase();
                option.textContent = ward.wardType && !normalizedWardName.startsWith(normalizedWardType + " ")
                    ? ward.wardType + " " + ward.wardName
                    : ward.wardName;
                option.selected = String(ward.administrativeUnitID) === String(selectedID);
                wardSelect.appendChild(option);
            });

            wardSelect.disabled = false;
        }

        function preselectUnit(unitID) {
            if (!unitID) {
                return;
            }

            const selectedUnit = (administrativeUnits || []).find(function (unit) {
                return String(unit.administrativeUnitID) === String(unitID);
            });

            if (selectedUnit) {
                citySelect.value = selectedUnit.provinceCode;
                populateWardOptions(selectedUnit.provinceCode, unitID);
            }
        }

        function validateAddressSelect(select, messageEl, emptyMessage, validMessage, showEmptyError) {
            if (!select.value) {
                if (showEmptyError) {
                    setFieldState(select, messageEl, false, emptyMessage);
                } else {
                    clearFieldState(select, messageEl);
                }
                return false;
            }

            setFieldState(select, messageEl, true, validMessage);
            return true;
        }

        function validateCity(showEmptyError) {
            return validateAddressSelect(
                citySelect,
                cityMessage,
                "Vui lòng chọn tỉnh/thành phố.",
                "Tỉnh/thành phố hợp lệ.",
                showEmptyError
            );
        }

        function validateWard(showEmptyError) {
            return validateAddressSelect(
                wardSelect,
                wardMessage,
                "Vui lòng chọn phường/xã.",
                "Phường/xã hợp lệ.",
                showEmptyError
            );
        }

        /* ---------- Event wiring ---------- */

        identityNumberInput.addEventListener("input", function () {
            validateIdentityNumber(false);
        });

        identityNumberInput.addEventListener("blur", normalizeIdentityInput);
        identityImageInput.addEventListener("change", function () {
            validateIdentityImage(true);
        });
        streetAddressInput.addEventListener("input", function () {
            validateStreetAddress(false);
        });
        streetAddressInput.addEventListener("blur", function () {
            streetAddressInput.value = (streetAddressInput.value || "").trim();
            validateStreetAddress(true);
        });

        citySelect.addEventListener("change", function () {
            clearFieldState(wardSelect, wardMessage);
            validateCity(false);
            populateWardOptions(citySelect.value, "");
        });

        wardSelect.addEventListener("change", function () {
            validateWard(false);
        });

        [numberAdultInput, numberChildrenInput].forEach(function (input) {
            input.addEventListener("keydown", blockTyping);
            input.addEventListener("paste", function (event) {
                event.preventDefault();
            });
            input.addEventListener("change", function () {
                clampCount(numberAdultInput, 1);
                clampCount(numberChildrenInput, 0);
                validateGuestCounts(true);
                updateSummary();
            });
            input.addEventListener("input", function () {
                clampCount(numberAdultInput, 1);
                clampCount(numberChildrenInput, 0);
                validateGuestCounts(false);
                updateSummary();
            });
        });

        getVoucherInputs().forEach(function (input) {
            input.addEventListener("change", updateSummary);
        });

        populateProvinceOptions();
        resetWardOptions(true);
        preselectUnit(selectedUnitID);

        if (identityNumberInput.value) {
            normalizeIdentityInput();
        }

        clampCount(numberAdultInput, 1);
        clampCount(numberChildrenInput, 0);
        updateSummary();

        form.addEventListener("submit", function (event) {
            const isIdentityValid = validateIdentityNumber(true);
            const isImageValid = validateIdentityImage(true);
            const isCityValid = validateCity(true);
            const isWardValid = validateWard(true);
            const isStreetValid = validateStreetAddress(true);
            const areGuestsValid = validateGuestCounts(true);

            if (!isIdentityValid || !isImageValid || !isCityValid || !isWardValid
                || !isStreetValid || !areGuestsValid) {
                event.preventDefault();
                const firstInvalid = form.querySelector(".is-invalid");
                if (firstInvalid) {
                    firstInvalid.focus();
                }
            } else {
                identityNumberInput.value = normalizeIdentityNumber(identityNumberInput.value);
            }
        });
    });
</script>
</body>
</html>
