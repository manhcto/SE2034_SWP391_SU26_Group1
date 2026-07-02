<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Đặt chỗ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            color: #0f172a;
        }

        .booking-section {
            padding: 38px 0 54px;
        }

        .booking-container {
            max-width: 1180px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .booking-title-area {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 26px;
        }

        .booking-title-area h2 {
            font-size: 34px;
            font-weight: 900;
            margin: 8px 0 8px;
            color: #0f172a;
        }

        .booking-title-area p {
            color: #64748b;
            margin: 0;
            font-weight: 600;
            line-height: 1.6;
        }

        .section-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 9px 16px;
            background: #e0f2fe;
            color: #0369a1;
            font-weight: 900;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .btn-soft-back {
            min-height: 48px;
            border-radius: 999px;
            padding: 12px 18px;
            background: #ffffff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
            text-decoration: none;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn-soft-back:hover {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .booking-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 390px;
            gap: 24px;
            align-items: start;
        }

        .booking-card,
        .summary-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
        }

        .booking-card {
            padding: 28px;
        }

        .summary-card {
            overflow: hidden;
            position: sticky;
            top: 92px;
        }

        .summary-image {
            width: 100%;
            height: 215px;
            background: #e2e8f0;
        }

        .summary-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .summary-body {
            padding: 22px;
        }

        .summary-title {
            color: #0f172a;
            font-size: 22px;
            line-height: 1.35;
            font-weight: 950;
            margin-bottom: 8px;
        }

        .summary-subtitle {
            color: #16a34a;
            font-weight: 850;
            margin-bottom: 16px;
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            padding: 11px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #64748b;
            font-weight: 750;
            line-height: 1.5;
        }

        .summary-line span:first-child {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .summary-line i {
            width: 18px;
            color: #2563eb;
        }

        .summary-line strong {
            color: #0f172a;
            text-align: right;
        }

        .summary-total {
            margin-top: 18px;
            padding: 16px;
            border-radius: 18px;
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
            font-size: 26px;
            font-weight: 950;
        }

        .form-section-title {
            margin: 0 0 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #0f172a;
            font-size: 22px;
            font-weight: 950;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            color: #334155;
            font-size: 14px;
            font-weight: 900;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 14px;
            padding: 12px 14px;
            font: inherit;
            outline: none;
            background: #ffffff;
            font-weight: 650;
            color: #0f172a;
            transition: 0.18s ease;
        }

        .form-group select {
            height: 50px;
        }

        .form-group textarea {
            min-height: 112px;
            resize: vertical;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .form-group input.input-error,
        .form-group textarea.input-error,
        .form-group select.input-error {
            border-color: #ef4444;
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.12);
        }

        .form-group input.input-valid,
        .form-group textarea.input-valid,
        .form-group select.input-valid {
            border-color: #22c55e;
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.10);
        }

        .field-error-message {
            display: none;
            color: #dc2626;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.35;
        }

        .field-error-message.show {
            display: block;
        }

        .checkbox-line {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #334155;
            font-weight: 800;
            margin: 18px 0 0;
        }

        .checkbox-line input {
            width: 18px;
            height: 18px;
        }

        .error-box {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            border-radius: 16px;
            padding: 16px 18px;
            margin-bottom: 22px;
            font-weight: 750;
        }

        .error-box ul {
            margin: 10px 0 0;
            padding-left: 22px;
        }

        .info-note {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e3a8a;
            border-radius: 16px;
            padding: 14px 16px;
            font-weight: 800;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .booking-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 26px;
            flex-wrap: wrap;
        }

        .btn-submit-booking {
            min-height: 52px;
            min-width: 190px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            padding: 13px 22px;
            font-size: 15px;
            font-weight: 950;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            cursor: pointer;
            box-shadow: 0 14px 26px rgba(37, 99, 235, 0.24);
        }

        .btn-submit-booking:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-1px);
        }

        .vehicle-total {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 16px;
            padding: 14px 16px;
            color: #1e3a8a;
            font-weight: 900;
            margin-top: 18px;
        }



        .cart-booking-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 18px;
        }

        .cart-booking-item {
            display: grid;
            grid-template-columns: 78px minmax(0, 1fr);
            gap: 12px;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            background: #f8fafc;
        }

        .cart-booking-item img {
            width: 78px;
            height: 64px;
            border-radius: 14px;
            object-fit: cover;
            background: #e2e8f0;
        }

        .cart-booking-item-name {
            color: #0f172a;
            font-size: 15px;
            font-weight: 950;
            line-height: 1.35;
            margin-bottom: 4px;
        }

        .cart-booking-item-meta {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.5;
        }

        .cart-booking-item-price {
            color: #1d4ed8;
            font-size: 14px;
            font-weight: 950;
            margin-top: 5px;
        }

        .date-group-title {
            grid-column: 1 / -1;
            margin-top: 6px;
            padding: 12px 14px;
            border-radius: 16px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e3a8a;
            font-weight: 950;
            display: flex;
            align-items: center;
            gap: 8px;
        }


        .cart-compact-note {
            display: grid;
            grid-template-columns: 42px minmax(0, 1fr);
            gap: 12px;
            align-items: start;
            padding: 14px 16px;
            margin-bottom: 20px;
            border-radius: 18px;
            background: #f8fafc;
            border: 1px solid #dbeafe;
        }

        .cart-compact-note-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: #eff6ff;
            color: #2563eb;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .cart-compact-note strong {
            display: block;
            color: #0f172a;
            font-weight: 950;
            margin-bottom: 4px;
        }

        .cart-compact-note span {
            display: block;
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.55;
        }

        .readonly-stay-list {
            grid-column: 1 / -1;
            display: grid;
            gap: 10px;
        }

        .readonly-stay-card {
            border: 1px solid #dbeafe;
            background: #f8fafc;
            border-radius: 16px;
            padding: 13px 14px;
        }

        .readonly-stay-card strong {
            display: block;
            color: #0f172a;
            font-weight: 950;
            margin-bottom: 7px;
        }

        .readonly-stay-card span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #475569;
            font-size: 13px;
            font-weight: 800;
            margin-right: 12px;
            line-height: 1.7;
        }

        .readonly-stay-card i {
            color: #2563eb;
        }

        @media (max-width: 992px) {
            .booking-title-area {
                display: block;
            }

            .btn-soft-back {
                margin-top: 16px;
            }

            .booking-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .booking-form-grid {
                grid-template-columns: 1fr;
            }

            .booking-card {
                padding: 22px;
            }

            .booking-actions {
                flex-direction: column;
            }

            .btn-submit-booking,
            .btn-soft-back {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="home-page">
    <section class="section booking-section">
        <div class="booking-container">

            <c:if test="${not empty errorList or not empty error}">
                <div class="error-box">
                    <strong>
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                        Vui lòng kiểm tra lại thông tin:
                    </strong>

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

            <c:choose>


                <c:when test="${bookingMode == 'cart'}">
                    <div class="booking-title-area">
                        <div>
                            <p class="section-kicker">
                                <i class="fa-solid fa-cart-shopping"></i>
                                Giỏ hàng
                            </p>
                            <h2>Hoàn tất đặt đơn từ giỏ hàng</h2>
                            <p>Vui lòng kiểm tra dịch vụ đã chọn và nhập thông tin liên hệ. Ngày lưu trú của phòng sẽ giữ đúng theo lúc bạn thêm vào giỏ hàng.</p>
                        </div>

                        <a class="btn-soft-back" href="${pageContext.request.contextPath}/cart">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại giỏ hàng
                        </a>
                    </div>

                    <div class="booking-layout">
                        <section class="booking-card">
                            <h3 class="form-section-title">
                                <i class="fa-solid fa-user-check"></i>
                                Thông tin người đặt
                            </h3>

                            <form action="${pageContext.request.contextPath}/booking"
                                  method="post"
                                  class="js-realtime-booking-form"
                                  data-mode="cart"
                                  novalidate>

                                <input type="hidden" name="bookingType" value="Cart">
                                <input type="hidden" name="type" value="cart">

                                <c:forEach var="item" items="${cartBookingItems}">
                                    <input type="hidden" name="cartItemID" value="${item.cartItemID}">
                                </c:forEach>

                                <div class="cart-compact-note">
                                    <div class="cart-compact-note-icon">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </div>
                                    <div>
                                        <strong>Lưu ý khi đặt đơn từ giỏ hàng</strong>
                                        <c:if test="${hasRoomItems}">
                                            <span>Phòng sẽ dùng đúng ngày nhận phòng và ngày trả phòng đã chọn khi thêm vào giỏ hàng, không nhập lại ở bước này.</span>
                                        </c:if>
                                        <c:if test="${hasVehicleItems}">
                                            <span>Xe cần chọn ngày nhận xe và ngày trả xe ở bước đặt đơn.</span>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="booking-form-grid">
                                    <div class="form-group">
                                        <label for="firstName">Họ và tên đệm *</label>
                                        <input type="text"
                                               id="firstName"
                                               name="firstName"
                                               value="${firstName}">
                                        <span class="field-error-message" id="firstNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="lastName">Tên *</label>
                                        <input type="text"
                                               id="lastName"
                                               name="lastName"
                                               value="${lastName}">
                                        <span class="field-error-message" id="lastNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email *</label>
                                        <input type="text"
                                               id="email"
                                               name="email"
                                               value="${email}">
                                        <span class="field-error-message" id="emailError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Số điện thoại *</label>
                                        <input type="text"
                                               id="phone"
                                               name="phone"
                                               value="${phone}">
                                        <span class="field-error-message" id="phoneError"></span>
                                    </div>

                                    <c:if test="${hasRoomItems}">
                                        <div class="form-group">
                                            <label for="identityNumber">CCCD / CMND *</label>
                                            <input type="text"
                                                   id="identityNumber"
                                                   name="identityNumber"
                                                   inputmode="numeric"
                                                   value="${identityNumber}"
                                                   placeholder="Nhập 9 hoặc 12 chữ số">
                                            <span class="field-error-message" id="identityNumberError"></span>
                                        </div>
                                    </c:if>

                                    <c:if test="${hasVehicleItems}">
                                        <div class="date-group-title">
                                            <i class="fa-solid fa-car-side"></i>
                                            Thời gian thuê xe
                                        </div>

                                        <div class="form-group">
                                            <label for="pickupDate">Ngày nhận xe *</label>
                                            <input type="date"
                                                   id="pickupDate"
                                                   name="pickupDate"
                                                   value="${not empty pickupDate ? pickupDate : defaultPickupDate}"
                                                   min="${minServiceDate}">
                                            <span class="field-error-message" id="pickupDateError"></span>
                                        </div>

                                        <div class="form-group">
                                            <label for="returnDate">Ngày trả xe *</label>
                                            <input type="date"
                                                   id="returnDate"
                                                   name="returnDate"
                                                   value="${not empty returnDate ? returnDate : defaultReturnDate}"
                                                   min="${minServiceDate}">
                                            <span class="field-error-message" id="returnDateError"></span>
                                        </div>
                                    </c:if>

                                    <c:if test="${hasRoomItems}">
                                        <div class="date-group-title">
                                            <i class="fa-solid fa-bed"></i>
                                            Thời gian lưu trú đã chọn
                                        </div>

                                        <div class="readonly-stay-list">
                                            <c:forEach var="item" items="${cartBookingItems}">
                                                <c:if test="${item.itemType == 'Room'}">
                                                    <div class="readonly-stay-card">
                                                        <strong>${item.itemName}</strong>
                                                        <c:choose>
                                                            <c:when test="${not empty item.startDate && not empty item.endDate}">
                                                                <span>
                                                                    <i class="fa-solid fa-calendar-check"></i>
                                                                    Nhận phòng: <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                                <span>
                                                                    <i class="fa-solid fa-calendar-xmark"></i>
                                                                    Trả phòng: <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                                <span>
                                                                    <i class="fa-solid fa-moon"></i>
                                                                    ${item.nights} đêm
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span>
                                                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                                                    Phòng này chưa có ngày lưu trú. Vui lòng xóa khỏi giỏ hàng và thêm lại.
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="form-group full">
                                        <label for="streetAddress">Số nhà, đường *</label>
                                        <input type="text"
                                               id="streetAddress"
                                               name="streetAddress"
                                               value="${not empty streetAddress ? streetAddress : address}"
                                               maxlength="120"
                                               placeholder="VD: Số 10 Nguyễn Trãi">
                                        <span class="field-error-message" id="streetAddressError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="district">Quận / Huyện *</label>
                                        <select id="district" name="district">
                                            <option value="">-- Chọn quận / huyện --</option>
                                            <option value="Quận Ba Đình" ${district == 'Quận Ba Đình' ? 'selected' : ''}>Quận Ba Đình</option>
                                            <option value="Quận Hoàn Kiếm" ${district == 'Quận Hoàn Kiếm' ? 'selected' : ''}>Quận Hoàn Kiếm</option>
                                            <option value="Quận Tây Hồ" ${district == 'Quận Tây Hồ' ? 'selected' : ''}>Quận Tây Hồ</option>
                                            <option value="Quận Long Biên" ${district == 'Quận Long Biên' ? 'selected' : ''}>Quận Long Biên</option>
                                            <option value="Quận Cầu Giấy" ${district == 'Quận Cầu Giấy' ? 'selected' : ''}>Quận Cầu Giấy</option>
                                            <option value="Quận Đống Đa" ${district == 'Quận Đống Đa' ? 'selected' : ''}>Quận Đống Đa</option>
                                            <option value="Quận Hai Bà Trưng" ${district == 'Quận Hai Bà Trưng' ? 'selected' : ''}>Quận Hai Bà Trưng</option>
                                            <option value="Quận Hoàng Mai" ${district == 'Quận Hoàng Mai' ? 'selected' : ''}>Quận Hoàng Mai</option>
                                            <option value="Quận Thanh Xuân" ${district == 'Quận Thanh Xuân' ? 'selected' : ''}>Quận Thanh Xuân</option>
                                            <option value="Quận Nam Từ Liêm" ${district == 'Quận Nam Từ Liêm' ? 'selected' : ''}>Quận Nam Từ Liêm</option>
                                            <option value="Quận Bắc Từ Liêm" ${district == 'Quận Bắc Từ Liêm' ? 'selected' : ''}>Quận Bắc Từ Liêm</option>
                                            <option value="Quận Hà Đông" ${district == 'Quận Hà Đông' ? 'selected' : ''}>Quận Hà Đông</option>
                                            <option value="Huyện Thanh Trì" ${district == 'Huyện Thanh Trì' ? 'selected' : ''}>Huyện Thanh Trì</option>
                                            <option value="Huyện Gia Lâm" ${district == 'Huyện Gia Lâm' ? 'selected' : ''}>Huyện Gia Lâm</option>
                                            <option value="Huyện Đông Anh" ${district == 'Huyện Đông Anh' ? 'selected' : ''}>Huyện Đông Anh</option>
                                            <option value="Huyện Sóc Sơn" ${district == 'Huyện Sóc Sơn' ? 'selected' : ''}>Huyện Sóc Sơn</option>
                                        </select>
                                        <span class="field-error-message" id="districtError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="city">Tỉnh / Thành phố *</label>
                                        <select id="city" name="city">
                                            <option value="">-- Chọn tỉnh / thành phố --</option>
                                            <option value="Hà Nội" ${city == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                                            <option value="Hồ Chí Minh" ${city == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                                            <option value="Đà Nẵng" ${city == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                                            <option value="Hải Phòng" ${city == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
                                            <option value="Cần Thơ" ${city == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                            <option value="Quảng Ninh" ${city == 'Quảng Ninh' ? 'selected' : ''}>Quảng Ninh</option>
                                            <option value="Ninh Bình" ${city == 'Ninh Bình' ? 'selected' : ''}>Ninh Bình</option>
                                            <option value="Huế" ${city == 'Huế' ? 'selected' : ''}>Huế</option>
                                            <option value="Khánh Hòa" ${city == 'Khánh Hòa' ? 'selected' : ''}>Khánh Hòa</option>
                                            <option value="Lâm Đồng" ${city == 'Lâm Đồng' ? 'selected' : ''}>Lâm Đồng</option>
                                        </select>
                                        <span class="field-error-message" id="cityError"></span>
                                    </div>

                                    <input type="hidden" id="fullAddress" name="address" value="${address}">

                                    <div class="form-group full">
                                        <label for="note">Ghi chú</label>
                                        <textarea id="note"
                                                  name="note"
                                                  maxlength="1000"
                                                  placeholder="Ví dụ: yêu cầu nhận xe, nhận phòng, hỗ trợ khách đi cùng...">${note}</textarea>
                                        <span class="field-error-message" id="noteError"></span>
                                    </div>
                                </div>

                                <label class="checkbox-line">
                                    <input type="checkbox" name="isBookedForOther" <c:if test="${isBookedForOther}">checked</c:if>>
                                    Tôi đang đặt hộ cho người khác
                                </label>

                                <div class="booking-actions">
                                    <a class="btn-soft-back" href="${pageContext.request.contextPath}/cart">
                                        <i class="fa-solid fa-arrow-left"></i>
                                        Quay lại giỏ hàng
                                    </a>

                                    <button type="submit" class="btn-submit-booking">
                                        <i class="fa-solid fa-circle-check"></i>
                                        Đặt đơn
                                    </button>
                                </div>
                            </form>
                        </section>

                        <aside class="summary-card">
                            <div class="summary-body">
                                <div class="summary-title">Dịch vụ đã chọn</div>
                                <div class="summary-subtitle">
                                    <i class="fa-solid fa-cart-shopping me-1"></i>
                                    Tạo đơn riêng cho từng dịch vụ trong giỏ hàng
                                </div>

                                <div class="cart-booking-list">
                                    <c:forEach var="item" items="${cartBookingItems}">
                                        <div class="cart-booking-item">
                                            <img src="${empty item.image ? 'https://placehold.co/300x220?text=WonderVN' : item.image}"
                                                 alt="${item.itemName}"
                                                 onerror="this.src='https://placehold.co/300x220?text=WonderVN';">

                                            <div>
                                                <div class="cart-booking-item-name">${item.itemName}</div>
                                                <div class="cart-booking-item-meta">
                                                    <c:choose>
                                                        <c:when test="${item.itemType == 'Vehicle'}">Xe</c:when>
                                                        <c:when test="${item.itemType == 'Room'}">Phòng</c:when>
                                                        <c:otherwise>Dịch vụ</c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${not empty item.providerName}">
                                                        · ${item.providerName}
                                                    </c:if>
                                                    <c:if test="${not empty item.detailText}">
                                                        <br>${item.detailText}
                                                    </c:if>
                                                </div>
                                                <div class="cart-booking-item-price">
                                                    <fmt:formatNumber value="${item.subTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="summary-total">
                                    <div class="summary-total-label">Tổng tạm tính</div>
                                    <div class="summary-total-value">
                                        <fmt:formatNumber value="${cartBookingTotal}" type="number" maxFractionDigits="0"/> VNĐ
                                    </div>
                                </div>

                                <div class="summary-line" style="border-bottom: none; margin-top: 8px; padding-bottom: 0;">
                                    <span><i class="fa-solid fa-lock"></i> Lịch phòng</span>
                                    <strong>Giữ nguyên từ giỏ hàng</strong>
                                </div>
                            </div>
                        </aside>
                    </div>
                </c:when>

                <c:when test="${bookingMode == 'vehicle'}">
                    <div class="booking-title-area">
                        <div>
                            <p class="section-kicker">
                                <i class="fa-solid fa-car-side"></i>
                                Đặt chỗ
                            </p>
                            <h2>Hoàn tất thông tin đặt xe</h2>
                            <p>Vui lòng kiểm tra thông tin xe, thời gian thuê và thông tin liên hệ trước khi tiếp tục thanh toán.</p>
                        </div>

                        <a class="btn-soft-back" href="${pageContext.request.contextPath}/vehicle/detail?id=${vehicle.serviceID}">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại xe
                        </a>
                    </div>

                    <div class="booking-layout">
                        <section class="booking-card">
                            <h3 class="form-section-title">
                                <i class="fa-solid fa-user"></i>
                                Thông tin khách đặt xe
                            </h3>

                            <form action="${pageContext.request.contextPath}/booking"
                                  method="post"
                                  class="js-realtime-booking-form"
                                  data-mode="vehicle"
                                  novalidate>

                                <input type="hidden" name="bookingType" value="Vehicle">
                                <input type="hidden" name="type" value="vehicle">
                                <input type="hidden" name="vehicleID" value="${vehicle.serviceID}">

                                <div class="booking-form-grid">
                                    <div class="form-group">
                                        <label for="firstName">Họ và tên đệm *</label>
                                        <input type="text"
                                               id="firstName"
                                               name="firstName"
                                               value="${firstName}">
                                        <span class="field-error-message" id="firstNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="lastName">Tên *</label>
                                        <input type="text"
                                               id="lastName"
                                               name="lastName"
                                               value="${lastName}">
                                        <span class="field-error-message" id="lastNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email *</label>
                                        <input type="text"
                                               id="email"
                                               name="email"
                                               value="${email}">
                                        <span class="field-error-message" id="emailError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Số điện thoại *</label>
                                        <input type="text"
                                               id="phone"
                                               name="phone"
                                               value="${phone}">
                                        <span class="field-error-message" id="phoneError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="pickupDate">Ngày nhận xe *</label>
                                        <input type="date"
                                               id="pickupDate"
                                               name="pickupDate"
                                               value="${not empty pickupDate ? pickupDate : defaultPickupDate}"
                                               min="${minPickupDate}">
                                        <span class="field-error-message" id="pickupDateError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="returnDate">Ngày trả xe *</label>
                                        <input type="date"
                                               id="returnDate"
                                               name="returnDate"
                                               value="${not empty returnDate ? returnDate : defaultReturnDate}"
                                               min="${minPickupDate}">
                                        <span class="field-error-message" id="returnDateError"></span>
                                    </div>

                                    <div class="form-group full">
                                        <label for="streetAddress">Số nhà, đường *</label>
                                        <input type="text"
                                               id="streetAddress"
                                               name="streetAddress"
                                               value="${not empty streetAddress ? streetAddress : address}"
                                               maxlength="120"
                                               placeholder="VD: Số 10 Nguyễn Trãi">
                                        <span class="field-error-message" id="streetAddressError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="district">Quận / Huyện *</label>
                                        <select id="district" name="district">
                                            <option value="">-- Chọn quận / huyện --</option>
                                            <option value="Quận Ba Đình" ${district == 'Quận Ba Đình' ? 'selected' : ''}>Quận Ba Đình</option>
                                            <option value="Quận Hoàn Kiếm" ${district == 'Quận Hoàn Kiếm' ? 'selected' : ''}>Quận Hoàn Kiếm</option>
                                            <option value="Quận Tây Hồ" ${district == 'Quận Tây Hồ' ? 'selected' : ''}>Quận Tây Hồ</option>
                                            <option value="Quận Long Biên" ${district == 'Quận Long Biên' ? 'selected' : ''}>Quận Long Biên</option>
                                            <option value="Quận Cầu Giấy" ${district == 'Quận Cầu Giấy' ? 'selected' : ''}>Quận Cầu Giấy</option>
                                            <option value="Quận Đống Đa" ${district == 'Quận Đống Đa' ? 'selected' : ''}>Quận Đống Đa</option>
                                            <option value="Quận Hai Bà Trưng" ${district == 'Quận Hai Bà Trưng' ? 'selected' : ''}>Quận Hai Bà Trưng</option>
                                            <option value="Quận Hoàng Mai" ${district == 'Quận Hoàng Mai' ? 'selected' : ''}>Quận Hoàng Mai</option>
                                            <option value="Quận Thanh Xuân" ${district == 'Quận Thanh Xuân' ? 'selected' : ''}>Quận Thanh Xuân</option>
                                            <option value="Quận Nam Từ Liêm" ${district == 'Quận Nam Từ Liêm' ? 'selected' : ''}>Quận Nam Từ Liêm</option>
                                            <option value="Quận Bắc Từ Liêm" ${district == 'Quận Bắc Từ Liêm' ? 'selected' : ''}>Quận Bắc Từ Liêm</option>
                                            <option value="Quận Hà Đông" ${district == 'Quận Hà Đông' ? 'selected' : ''}>Quận Hà Đông</option>
                                            <option value="Huyện Thanh Trì" ${district == 'Huyện Thanh Trì' ? 'selected' : ''}>Huyện Thanh Trì</option>
                                            <option value="Huyện Gia Lâm" ${district == 'Huyện Gia Lâm' ? 'selected' : ''}>Huyện Gia Lâm</option>
                                            <option value="Huyện Đông Anh" ${district == 'Huyện Đông Anh' ? 'selected' : ''}>Huyện Đông Anh</option>
                                            <option value="Huyện Sóc Sơn" ${district == 'Huyện Sóc Sơn' ? 'selected' : ''}>Huyện Sóc Sơn</option>
                                        </select>
                                        <span class="field-error-message" id="districtError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="city">Tỉnh / Thành phố *</label>
                                        <select id="city" name="city">
                                            <option value="">-- Chọn tỉnh / thành phố --</option>
                                            <option value="Hà Nội" ${city == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                                            <option value="Hồ Chí Minh" ${city == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                                            <option value="Đà Nẵng" ${city == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                                            <option value="Hải Phòng" ${city == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
                                            <option value="Cần Thơ" ${city == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                            <option value="Quảng Ninh" ${city == 'Quảng Ninh' ? 'selected' : ''}>Quảng Ninh</option>
                                            <option value="Ninh Bình" ${city == 'Ninh Bình' ? 'selected' : ''}>Ninh Bình</option>
                                            <option value="Huế" ${city == 'Huế' ? 'selected' : ''}>Huế</option>
                                            <option value="Khánh Hòa" ${city == 'Khánh Hòa' ? 'selected' : ''}>Khánh Hòa</option>
                                            <option value="Lâm Đồng" ${city == 'Lâm Đồng' ? 'selected' : ''}>Lâm Đồng</option>
                                        </select>
                                        <span class="field-error-message" id="cityError"></span>
                                    </div>

                                    <input type="hidden" id="fullAddress" name="address" value="${address}">

                                    <div class="form-group full">
                                        <label for="note">Ghi chú</label>
                                        <textarea id="note"
                                                  name="note"
                                                  maxlength="1000"
                                                  placeholder="Ví dụ: giờ nhận xe mong muốn, yêu cầu hỗ trợ...">${note}</textarea>
                                        <span class="field-error-message" id="noteError"></span>
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
                                    <fmt:formatNumber value="${vehicle.pricePerDay}" type="number" maxFractionDigits="0"/> VNĐ/ngày
                                </div>

                                <div class="booking-actions">
                                    <button type="submit" class="btn-submit-booking">
                                        <i class="fa-solid fa-credit-card"></i>
                                        Tiếp tục thanh toán
                                    </button>
                                </div>
                            </form>
                        </section>

                        <aside class="summary-card">
                            <div class="summary-image">
                                <img src="${empty vehicle.image ? 'https://placehold.co/800x450?text=WonderVN+Xe' : vehicle.image}"
                                     alt="${vehicle.displayName}"
                                     onerror="this.src='https://placehold.co/800x450?text=WonderVN+Xe';">
                            </div>

                            <div class="summary-body">
                                <div class="summary-title">${vehicle.displayName}</div>
                                <div class="summary-subtitle">
                                    <i class="fa-solid fa-location-dot me-1"></i>
                                        ${vehicle.fullPickupAddress}
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-car"></i> Loại xe</span>
                                    <strong>${vehicle.vehicleType}</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-users"></i> Số chỗ</span>
                                    <strong>${vehicle.seatCount}</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-id-card"></i> Biển số</span>
                                    <strong>${vehicle.licensePlate}</strong>
                                </div>

                                <div class="summary-total">
                                    <div class="summary-total-label">Giá thuê</div>
                                    <div class="summary-total-value">
                                        <fmt:formatNumber value="${vehicle.pricePerDay}" type="number" maxFractionDigits="0"/> VNĐ/ngày
                                    </div>
                                </div>
                            </div>
                        </aside>
                    </div>
                </c:when>

                <c:when test="${bookingMode == 'accommodation'}">
                    <div class="booking-title-area">
                        <div>
                            <p class="section-kicker">
                                <i class="fa-solid fa-hotel"></i>
                                Đặt chỗ
                            </p>
                            <h2>Hoàn tất thông tin đặt phòng</h2>
                            <p>Vui lòng kiểm tra thông tin phòng và nhập thông tin khách lưu trú trước khi tiếp tục thanh toán.</p>
                        </div>

                        <a class="btn-soft-back"
                           href="${pageContext.request.contextPath}/accommodation/room/detail?id=${room.roomID}&accommodationId=${accommodation.serviceID}&checkIn=${checkIn}&checkOut=${checkOut}&adults=${adults}&children=${children}&rooms=${rooms}&guests=${guests}">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại phòng
                        </a>
                    </div>

                    <c:if test="${param.status == 'invalidCustomerInfo'}">
                        <div class="error-box">
                            <strong>
                                <i class="fa-solid fa-circle-exclamation me-2"></i>
                                Vui lòng nhập đầy đủ thông tin khách hàng. CCCD/CMND phải gồm 9 hoặc 12 chữ số.
                            </strong>
                        </div>
                    </c:if>

                    <div class="booking-layout">
                        <section class="booking-card">
                            <h3 class="form-section-title">
                                <i class="fa-solid fa-user-shield"></i>
                                Thông tin khách lưu trú
                            </h3>

                            <form action="${pageContext.request.contextPath}/booking/accommodation"
                                  method="post"
                                  class="js-realtime-booking-form"
                                  data-mode="accommodation"
                                  novalidate>

                                <input type="hidden" name="bookingType" value="Accommodation">
                                <input type="hidden" name="type" value="accommodation">
                                <input type="hidden" name="accommodationID" value="${accommodation.serviceID}">
                                <input type="hidden" name="roomID" value="${room.roomID}">
                                <input type="hidden" name="checkIn" value="${checkIn}">
                                <input type="hidden" name="checkOut" value="${checkOut}">
                                <input type="hidden" name="adults" value="${adults}">
                                <input type="hidden" name="children" value="${children}">
                                <input type="hidden" name="rooms" value="${rooms}">
                                <input type="hidden" name="guests" value="${guests}">

                                <div class="booking-form-grid">
                                    <div class="form-group">
                                        <label for="firstName">Họ và tên đệm *</label>
                                        <input type="text"
                                               id="firstName"
                                               name="firstName"
                                               value="${not empty firstName ? firstName : sessionScope.user.firstName}">
                                        <span class="field-error-message" id="firstNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="lastName">Tên *</label>
                                        <input type="text"
                                               id="lastName"
                                               name="lastName"
                                               value="${not empty lastName ? lastName : sessionScope.user.lastName}">
                                        <span class="field-error-message" id="lastNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email *</label>
                                        <input type="text"
                                               id="email"
                                               name="email"
                                               value="${not empty email ? email : sessionScope.user.email}">
                                        <span class="field-error-message" id="emailError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Số điện thoại *</label>
                                        <input type="text"
                                               id="phone"
                                               name="phone"
                                               value="${not empty phone ? phone : sessionScope.user.phone}">
                                        <span class="field-error-message" id="phoneError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="identityNumber">CCCD / CMND *</label>
                                        <input type="text"
                                               id="identityNumber"
                                               name="identityNumber"
                                               inputmode="numeric"
                                               value="${identityNumber}"
                                               placeholder="Nhập 9 hoặc 12 chữ số">
                                        <span class="field-error-message" id="identityNumberError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="bookedFor">Người đại diện nhận phòng</label>
                                        <input type="text"
                                               id="bookedFor"
                                               value="${not empty firstName ? firstName : sessionScope.user.firstName} ${not empty lastName ? lastName : sessionScope.user.lastName}"
                                               readonly>
                                    </div>

                                    <div class="form-group full">
                                        <label for="streetAddress">Số nhà, đường *</label>
                                        <input type="text"
                                               id="streetAddress"
                                               name="streetAddress"
                                               value="${not empty streetAddress ? streetAddress : (not empty address ? address : sessionScope.user.address)}"
                                               maxlength="120"
                                               placeholder="VD: Số 10 Nguyễn Trãi">
                                        <span class="field-error-message" id="streetAddressError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="district">Quận / Huyện *</label>
                                        <select id="district" name="district">
                                            <option value="">-- Chọn quận / huyện --</option>
                                            <option value="Quận Ba Đình" ${district == 'Quận Ba Đình' ? 'selected' : ''}>Quận Ba Đình</option>
                                            <option value="Quận Hoàn Kiếm" ${district == 'Quận Hoàn Kiếm' ? 'selected' : ''}>Quận Hoàn Kiếm</option>
                                            <option value="Quận Tây Hồ" ${district == 'Quận Tây Hồ' ? 'selected' : ''}>Quận Tây Hồ</option>
                                            <option value="Quận Long Biên" ${district == 'Quận Long Biên' ? 'selected' : ''}>Quận Long Biên</option>
                                            <option value="Quận Cầu Giấy" ${district == 'Quận Cầu Giấy' ? 'selected' : ''}>Quận Cầu Giấy</option>
                                            <option value="Quận Đống Đa" ${district == 'Quận Đống Đa' ? 'selected' : ''}>Quận Đống Đa</option>
                                            <option value="Quận Hai Bà Trưng" ${district == 'Quận Hai Bà Trưng' ? 'selected' : ''}>Quận Hai Bà Trưng</option>
                                            <option value="Quận Hoàng Mai" ${district == 'Quận Hoàng Mai' ? 'selected' : ''}>Quận Hoàng Mai</option>
                                            <option value="Quận Thanh Xuân" ${district == 'Quận Thanh Xuân' ? 'selected' : ''}>Quận Thanh Xuân</option>
                                            <option value="Quận Nam Từ Liêm" ${district == 'Quận Nam Từ Liêm' ? 'selected' : ''}>Quận Nam Từ Liêm</option>
                                            <option value="Quận Bắc Từ Liêm" ${district == 'Quận Bắc Từ Liêm' ? 'selected' : ''}>Quận Bắc Từ Liêm</option>
                                            <option value="Quận Hà Đông" ${district == 'Quận Hà Đông' ? 'selected' : ''}>Quận Hà Đông</option>
                                            <option value="Huyện Thanh Trì" ${district == 'Huyện Thanh Trì' ? 'selected' : ''}>Huyện Thanh Trì</option>
                                            <option value="Huyện Gia Lâm" ${district == 'Huyện Gia Lâm' ? 'selected' : ''}>Huyện Gia Lâm</option>
                                            <option value="Huyện Đông Anh" ${district == 'Huyện Đông Anh' ? 'selected' : ''}>Huyện Đông Anh</option>
                                            <option value="Huyện Sóc Sơn" ${district == 'Huyện Sóc Sơn' ? 'selected' : ''}>Huyện Sóc Sơn</option>
                                        </select>
                                        <span class="field-error-message" id="districtError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="city">Tỉnh / Thành phố *</label>
                                        <select id="city" name="city">
                                            <option value="">-- Chọn tỉnh / thành phố --</option>
                                            <option value="Hà Nội" ${city == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                                            <option value="Hồ Chí Minh" ${city == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                                            <option value="Đà Nẵng" ${city == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                                            <option value="Hải Phòng" ${city == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
                                            <option value="Cần Thơ" ${city == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                            <option value="Quảng Ninh" ${city == 'Quảng Ninh' ? 'selected' : ''}>Quảng Ninh</option>
                                            <option value="Ninh Bình" ${city == 'Ninh Bình' ? 'selected' : ''}>Ninh Bình</option>
                                            <option value="Huế" ${city == 'Huế' ? 'selected' : ''}>Huế</option>
                                            <option value="Khánh Hòa" ${city == 'Khánh Hòa' ? 'selected' : ''}>Khánh Hòa</option>
                                            <option value="Lâm Đồng" ${city == 'Lâm Đồng' ? 'selected' : ''}>Lâm Đồng</option>
                                        </select>
                                        <span class="field-error-message" id="cityError"></span>
                                    </div>

                                    <input type="hidden" id="fullAddress" name="address" value="${not empty address ? address : sessionScope.user.address}">

                                    <div class="form-group full">
                                        <label for="note">Ghi chú cho nơi lưu trú</label>
                                        <textarea id="note"
                                                  name="note"
                                                  maxlength="1000"
                                                  placeholder="Ví dụ: nhận phòng muộn, cần phòng yên tĩnh, hỗ trợ trẻ em...">${note}</textarea>
                                        <span class="field-error-message" id="noteError"></span>
                                    </div>
                                </div>

                                <label class="checkbox-line">
                                    <input type="checkbox" name="isBookedForOther" <c:if test="${isBookedForOther}">checked</c:if>>
                                    Tôi đang đặt phòng hộ cho người khác
                                </label>

                                <div class="booking-actions">
                                    <a class="btn-soft-back"
                                       href="${pageContext.request.contextPath}/accommodation/room/detail?id=${room.roomID}&accommodationId=${accommodation.serviceID}&checkIn=${checkIn}&checkOut=${checkOut}&adults=${adults}&children=${children}&rooms=${rooms}&guests=${guests}">
                                        <i class="fa-solid fa-arrow-left"></i>
                                        Quay lại phòng
                                    </a>

                                    <button type="submit" class="btn-submit-booking">
                                        <i class="fa-solid fa-credit-card"></i>
                                        Tiếp tục thanh toán
                                    </button>
                                </div>
                            </form>
                        </section>

                        <aside class="summary-card">
                            <div class="summary-image">
                                <img src="${empty room.image ? 'https://placehold.co/800x450?text=WonderVN+Phong' : room.image}"
                                     alt="${room.roomType}"
                                     onerror="this.src='https://placehold.co/800x450?text=WonderVN+Phong';">
                            </div>

                            <div class="summary-body">
                                <div class="summary-title">${room.roomType}</div>
                                <div class="summary-subtitle">
                                    <i class="fa-solid fa-location-dot me-1"></i>
                                        ${accommodation.name}
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-calendar-check"></i> Nhận phòng</span>
                                    <strong>${checkIn}</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-calendar-xmark"></i> Trả phòng</span>
                                    <strong>${checkOut}</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-moon"></i> Số đêm</span>
                                    <strong>${nights} đêm</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-bed"></i> Số phòng</span>
                                    <strong>${rooms} phòng</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-user-group"></i> Số khách</span>
                                    <strong>${adults} người lớn, ${children} trẻ em</strong>
                                </div>

                                <div class="summary-total">
                                    <div class="summary-total-label">Tổng tiền tạm tính</div>
                                    <div class="summary-total-value">
                                        <fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                    </div>
                                </div>
                            </div>
                        </aside>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="booking-title-area">
                        <div>
                            <p class="section-kicker">
                                <i class="fa-solid fa-map-location-dot"></i>
                                Đặt chỗ
                            </p>
                            <h2>Hoàn tất thông tin đặt tour</h2>
                            <p>Vui lòng nhập thông tin khách hàng để tiếp tục sang bước thanh toán.</p>
                        </div>

                        <a class="btn-soft-back" href="${pageContext.request.contextPath}/tour">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại tour
                        </a>
                    </div>

                    <div class="booking-layout">
                        <section class="booking-card">
                            <h3 class="form-section-title">
                                <i class="fa-solid fa-user"></i>
                                Thông tin khách đặt tour
                            </h3>

                            <form action="${pageContext.request.contextPath}/booking"
                                  method="post"
                                  class="js-realtime-booking-form"
                                  data-mode="tour"
                                  novalidate>

                                <input type="hidden" name="bookingType" value="Tour">
                                <input type="hidden" name="type" value="tour">
                                <input type="hidden" name="tourScheduleID" value="${not empty tourScheduleID ? tourScheduleID : param.tourScheduleID}">
                                <input type="hidden" name="tourName" value="${not empty tourName ? tourName : param.tourName}">

                                <div class="info-note">
                                    <i class="fa-solid fa-circle-info me-2"></i>
                                    Giá tour và tổng tiền sẽ được hệ thống tự tính theo lịch trình, số người lớn và số trẻ em.
                                </div>

                                <div class="booking-form-grid">
                                    <div class="form-group">
                                        <label for="firstName">Họ và tên đệm *</label>
                                        <input type="text"
                                               id="firstName"
                                               name="firstName"
                                               value="${firstName}">
                                        <span class="field-error-message" id="firstNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="lastName">Tên *</label>
                                        <input type="text"
                                               id="lastName"
                                               name="lastName"
                                               value="${lastName}">
                                        <span class="field-error-message" id="lastNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email *</label>
                                        <input type="text"
                                               id="email"
                                               name="email"
                                               value="${email}">
                                        <span class="field-error-message" id="emailError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Số điện thoại *</label>
                                        <input type="text"
                                               id="phone"
                                               name="phone"
                                               value="${phone}">
                                        <span class="field-error-message" id="phoneError"></span>
                                    </div>

                                    <div class="form-group full">
                                        <label for="streetAddress">Số nhà, đường *</label>
                                        <input type="text"
                                               id="streetAddress"
                                               name="streetAddress"
                                               value="${streetAddress}"
                                               maxlength="120"
                                               placeholder="VD: Số 10 Nguyễn Trãi">
                                        <span class="field-error-message" id="streetAddressError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="district">Quận / Huyện *</label>
                                        <select id="district" name="district">
                                            <option value="">-- Chọn quận / huyện --</option>
                                            <option value="Quận Ba Đình" ${district == 'Quận Ba Đình' ? 'selected' : ''}>Quận Ba Đình</option>
                                            <option value="Quận Hoàn Kiếm" ${district == 'Quận Hoàn Kiếm' ? 'selected' : ''}>Quận Hoàn Kiếm</option>
                                            <option value="Quận Tây Hồ" ${district == 'Quận Tây Hồ' ? 'selected' : ''}>Quận Tây Hồ</option>
                                            <option value="Quận Long Biên" ${district == 'Quận Long Biên' ? 'selected' : ''}>Quận Long Biên</option>
                                            <option value="Quận Cầu Giấy" ${district == 'Quận Cầu Giấy' ? 'selected' : ''}>Quận Cầu Giấy</option>
                                            <option value="Quận Đống Đa" ${district == 'Quận Đống Đa' ? 'selected' : ''}>Quận Đống Đa</option>
                                            <option value="Quận Hai Bà Trưng" ${district == 'Quận Hai Bà Trưng' ? 'selected' : ''}>Quận Hai Bà Trưng</option>
                                            <option value="Quận Hoàng Mai" ${district == 'Quận Hoàng Mai' ? 'selected' : ''}>Quận Hoàng Mai</option>
                                            <option value="Quận Thanh Xuân" ${district == 'Quận Thanh Xuân' ? 'selected' : ''}>Quận Thanh Xuân</option>
                                            <option value="Quận Nam Từ Liêm" ${district == 'Quận Nam Từ Liêm' ? 'selected' : ''}>Quận Nam Từ Liêm</option>
                                            <option value="Quận Bắc Từ Liêm" ${district == 'Quận Bắc Từ Liêm' ? 'selected' : ''}>Quận Bắc Từ Liêm</option>
                                            <option value="Quận Hà Đông" ${district == 'Quận Hà Đông' ? 'selected' : ''}>Quận Hà Đông</option>
                                            <option value="Huyện Thanh Trì" ${district == 'Huyện Thanh Trì' ? 'selected' : ''}>Huyện Thanh Trì</option>
                                            <option value="Huyện Gia Lâm" ${district == 'Huyện Gia Lâm' ? 'selected' : ''}>Huyện Gia Lâm</option>
                                            <option value="Huyện Đông Anh" ${district == 'Huyện Đông Anh' ? 'selected' : ''}>Huyện Đông Anh</option>
                                            <option value="Huyện Sóc Sơn" ${district == 'Huyện Sóc Sơn' ? 'selected' : ''}>Huyện Sóc Sơn</option>
                                        </select>
                                        <span class="field-error-message" id="districtError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="city">Tỉnh / Thành phố *</label>
                                        <select id="city" name="city">
                                            <option value="">-- Chọn tỉnh / thành phố --</option>
                                            <option value="Hà Nội" ${city == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                                            <option value="Hồ Chí Minh" ${city == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                                            <option value="Đà Nẵng" ${city == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                                            <option value="Hải Phòng" ${city == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
                                            <option value="Cần Thơ" ${city == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                            <option value="Quảng Ninh" ${city == 'Quảng Ninh' ? 'selected' : ''}>Quảng Ninh</option>
                                            <option value="Ninh Bình" ${city == 'Ninh Bình' ? 'selected' : ''}>Ninh Bình</option>
                                            <option value="Huế" ${city == 'Huế' ? 'selected' : ''}>Huế</option>
                                            <option value="Khánh Hòa" ${city == 'Khánh Hòa' ? 'selected' : ''}>Khánh Hòa</option>
                                            <option value="Lâm Đồng" ${city == 'Lâm Đồng' ? 'selected' : ''}>Lâm Đồng</option>
                                        </select>
                                        <span class="field-error-message" id="cityError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="numberAdult">Số người lớn *</label>
                                        <input type="text"
                                               id="numberAdult"
                                               name="numberAdult"
                                               value="${not empty numberAdult ? numberAdult : '1'}"
                                               inputmode="numeric">
                                        <span class="field-error-message" id="numberAdultError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label for="numberChildren">Số trẻ em *</label>
                                        <input type="text"
                                               id="numberChildren"
                                               name="numberChildren"
                                               value="${not empty numberChildren ? numberChildren : '0'}"
                                               inputmode="numeric">
                                        <span class="field-error-message" id="numberChildrenError"></span>
                                    </div>

                                    <div class="form-group full">
                                        <label for="note">Ghi chú</label>
                                        <textarea id="note"
                                                  name="note"
                                                  maxlength="1000"
                                                  placeholder="Ví dụ: yêu cầu đón, thông tin trẻ em, ghi chú cho nhân viên...">${note}</textarea>
                                        <span class="field-error-message" id="noteError"></span>
                                    </div>
                                </div>

                                <label class="checkbox-line">
                                    <input type="checkbox" name="isBookedForOther" <c:if test="${isBookedForOther}">checked</c:if>>
                                    Tôi đang đặt tour hộ cho người khác
                                </label>

                                <div class="booking-actions">
                                    <button type="submit" class="btn-submit-booking">
                                        <i class="fa-solid fa-credit-card"></i>
                                        Tiếp tục thanh toán
                                    </button>
                                </div>
                            </form>
                        </section>

                        <aside class="summary-card">
                            <div class="summary-image">
                                <img src="https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=900&q=80"
                                     alt="Tour WonderVN">
                            </div>

                            <div class="summary-body">
                                <div class="summary-title">
                                    <c:choose>
                                        <c:when test="${not empty tourName}">
                                            ${tourName}
                                        </c:when>
                                        <c:when test="${not empty param.tourName}">
                                            ${param.tourName}
                                        </c:when>
                                        <c:otherwise>Tour đã chọn</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="summary-subtitle">
                                    <i class="fa-solid fa-location-dot me-1"></i>
                                    Gói tour WonderVN
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-hashtag"></i> Mã lịch tour</span>
                                    <strong>${not empty tourScheduleID ? tourScheduleID : param.tourScheduleID}</strong>
                                </div>

                                <div class="summary-line">
                                    <span><i class="fa-solid fa-user-group"></i> Số khách</span>
                                    <strong>Nhập trong biểu mẫu</strong>
                                </div>

                                <div class="summary-total">
                                    <div class="summary-total-label">Tổng tiền</div>
                                    <div class="summary-total-value" style="font-size: 18px;">
                                        Hệ thống tự tính
                                    </div>
                                </div>
                            </div>
                        </aside>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.querySelector(".js-realtime-booking-form");

        if (!form) {
            return;
        }

        const mode = form.dataset.mode || "";
        const nameRegex = /^[A-Za-zÀ-ỹ\s]+$/;
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
        const phoneRegex = /^0\d{9}$/;
        const streetAddressRegex = /^[A-Za-zÀ-ỹ0-9\s,./-]+$/;

        const districtList = [
            "Quận Ba Đình",
            "Quận Hoàn Kiếm",
            "Quận Tây Hồ",
            "Quận Long Biên",
            "Quận Cầu Giấy",
            "Quận Đống Đa",
            "Quận Hai Bà Trưng",
            "Quận Hoàng Mai",
            "Quận Thanh Xuân",
            "Quận Nam Từ Liêm",
            "Quận Bắc Từ Liêm",
            "Quận Hà Đông",
            "Huyện Thanh Trì",
            "Huyện Gia Lâm",
            "Huyện Đông Anh",
            "Huyện Sóc Sơn"
        ];

        const cityList = [
            "Hà Nội",
            "Hồ Chí Minh",
            "Đà Nẵng",
            "Hải Phòng",
            "Cần Thơ",
            "Quảng Ninh",
            "Ninh Bình",
            "Huế",
            "Khánh Hòa",
            "Lâm Đồng"
        ];

        function getField(id) {
            return document.getElementById(id);
        }

        function setError(input, errorElement, message) {
            input.classList.add("input-error");
            input.classList.remove("input-valid");

            errorElement.textContent = message;
            errorElement.classList.add("show");
        }

        function setValid(input, errorElement) {
            input.classList.remove("input-error");
            input.classList.add("input-valid");

            errorElement.textContent = "";
            errorElement.classList.remove("show");
        }

        function setNeutral(input, errorElement) {
            input.classList.remove("input-error");
            input.classList.remove("input-valid");

            errorElement.textContent = "";
            errorElement.classList.remove("show");
        }

        function validateName(value, fieldName, minLength) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập " + fieldName + ".";
            }

            if (text.length < minLength) {
                return fieldName + " phải có ít nhất " + minLength + " ký tự.";
            }

            if (text.length > 100) {
                return fieldName + " không được vượt quá 100 ký tự.";
            }

            if (!nameRegex.test(text)) {
                return fieldName + " chỉ được chứa chữ cái và khoảng trắng.";
            }

            return "";
        }

        function validateEmail(value) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập email.";
            }

            if (text.length > 255) {
                return "Email không được vượt quá 255 ký tự.";
            }

            if (!emailRegex.test(text)) {
                return "Email không đúng định dạng. Ví dụ: example@gmail.com.";
            }

            return "";
        }

        function validatePhone(value) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập số điện thoại.";
            }

            if (!phoneRegex.test(text)) {
                return "Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0.";
            }

            return "";
        }

        function validateStreetAddress(value) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập số nhà, đường.";
            }

            if (text.length > 120) {
                return "Số nhà, đường không được vượt quá 120 ký tự.";
            }

            if (!streetAddressRegex.test(text)) {
                return "Số nhà, đường chỉ được chứa chữ cái, số, khoảng trắng và các ký tự , . / -";
            }

            return "";
        }

        function validateSelect(value, fieldName, validList) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng chọn " + fieldName + ".";
            }

            if (!validList.includes(text)) {
                return fieldName + " không hợp lệ.";
            }

            return "";
        }

        function validateInteger(value, fieldName, minValue) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập " + fieldName + ".";
            }

            if (!/^\d+$/.test(text)) {
                return fieldName + " chỉ được nhập số tự nhiên.";
            }

            const number = parseInt(text, 10);

            if (number < minValue) {
                return fieldName + " phải lớn hơn hoặc bằng " + minValue + ".";
            }

            return "";
        }

        function validateIdentityNumber(value) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập CCCD / CMND.";
            }

            if (!/^(\d{9}|\d{12})$/.test(text)) {
                return "CCCD / CMND phải gồm 9 hoặc 12 chữ số.";
            }

            return "";
        }

        function validateNote(value) {
            const text = value.trim();

            if (text.length > 1000) {
                return "Ghi chú không được vượt quá 1000 ký tự.";
            }

            return "";
        }

        function validatePickupDate(value) {
            if (!value) {
                return "Vui lòng chọn ngày nhận xe.";
            }

            const today = new Date();
            today.setHours(0, 0, 0, 0);

            const pickup = new Date(value + "T00:00:00");

            if (pickup < today) {
                return "Ngày nhận xe không được nhỏ hơn ngày hiện tại.";
            }

            return "";
        }

        function validateReturnDate(value) {
            const pickupInput = getField("pickupDate");

            if (!value) {
                return "Vui lòng chọn ngày trả xe.";
            }

            if (!pickupInput || !pickupInput.value) {
                return "Vui lòng chọn ngày nhận xe trước.";
            }

            const pickup = new Date(pickupInput.value + "T00:00:00");
            const returnDate = new Date(value + "T00:00:00");

            if (returnDate <= pickup) {
                return "Ngày trả xe phải sau ngày nhận xe.";
            }

            return "";
        }



        function validateCheckInDate(value) {
            if (!value) {
                return "Vui lòng chọn ngày nhận phòng.";
            }

            const today = new Date();
            today.setHours(0, 0, 0, 0);

            const checkIn = new Date(value + "T00:00:00");

            if (checkIn < today) {
                return "Ngày nhận phòng không được nhỏ hơn ngày hiện tại.";
            }

            return "";
        }

        function validateCheckOutDate(value) {
            const checkInInput = getField("checkIn");

            if (!value) {
                return "Vui lòng chọn ngày trả phòng.";
            }

            if (!checkInInput || !checkInInput.value) {
                return "Vui lòng chọn ngày nhận phòng trước.";
            }

            const checkIn = new Date(checkInInput.value + "T00:00:00");
            const checkOut = new Date(value + "T00:00:00");

            if (checkOut <= checkIn) {
                return "Ngày trả phòng phải sau ngày nhận phòng.";
            }

            return "";
        }

        function buildRules() {
            const rules = [
                {
                    id: "firstName",
                    errorId: "firstNameError",
                    validate: function (value) {
                        return validateName(value, "họ và tên đệm", 2);
                    }
                },
                {
                    id: "lastName",
                    errorId: "lastNameError",
                    validate: function (value) {
                        return validateName(value, "tên", 1);
                    }
                },
                {
                    id: "email",
                    errorId: "emailError",
                    validate: validateEmail
                },
                {
                    id: "phone",
                    errorId: "phoneError",
                    validate: validatePhone
                }
            ];

            if (mode === "tour" || mode === "vehicle" || mode === "accommodation" || mode === "cart") {
                rules.push(
                    {
                        id: "streetAddress",
                        errorId: "streetAddressError",
                        validate: validateStreetAddress
                    },
                    {
                        id: "district",
                        errorId: "districtError",
                        validate: function (value) {
                            return validateSelect(value, "quận / huyện", districtList);
                        }
                    },
                    {
                        id: "city",
                        errorId: "cityError",
                        validate: function (value) {
                            return validateSelect(value, "tỉnh / thành phố", cityList);
                        }
                    }
                );
            }

            if (mode === "tour") {
                rules.push(
                    {
                        id: "numberAdult",
                        errorId: "numberAdultError",
                        validate: function (value) {
                            return validateInteger(value, "số người lớn", 1);
                        }
                    },
                    {
                        id: "numberChildren",
                        errorId: "numberChildrenError",
                        validate: function (value) {
                            return validateInteger(value, "số trẻ em", 0);
                        }
                    }
                );
            }

            if (mode === "vehicle" || mode === "cart") {
                if (getField("pickupDate") && getField("returnDate")) {
                    rules.push(
                        {
                            id: "pickupDate",
                            errorId: "pickupDateError",
                            validate: validatePickupDate
                        },
                        {
                            id: "returnDate",
                            errorId: "returnDateError",
                            validate: validateReturnDate
                        }
                    );
                }
            }

            if (mode === "accommodation" || (mode === "cart" && getField("identityNumber"))) {
                rules.push(
                    {
                        id: "identityNumber",
                        errorId: "identityNumberError",
                        validate: validateIdentityNumber
                    }
                );
            }

            rules.push({
                id: "note",
                errorId: "noteError",
                validate: validateNote,
                optional: true
            });

            return rules;
        }

        function updateFullAddressInput() {
            const fullAddress = getField("fullAddress");

            if (!fullAddress) {
                return;
            }

            const streetAddress = getField("streetAddress");
            const district = getField("district");
            const city = getField("city");
            const addressParts = [];

            if (streetAddress && streetAddress.value.trim() !== "") {
                addressParts.push(streetAddress.value.trim());
            }

            if (district && district.value.trim() !== "") {
                addressParts.push(district.value.trim());
            }

            if (city && city.value.trim() !== "") {
                addressParts.push(city.value.trim());
            }

            fullAddress.value = addressParts.join(", ");
        }

        updateFullAddressInput();

        const rules = buildRules();

        function validateOne(rule, showWhenEmpty) {
            const input = getField(rule.id);
            const errorElement = getField(rule.errorId);

            if (!input || !errorElement) {
                return true;
            }

            if (!showWhenEmpty && input.value.trim() === "") {
                setNeutral(input, errorElement);
                return true;
            }

            const message = rule.validate(input.value);

            if (message) {
                setError(input, errorElement, message);
                return false;
            }

            if (rule.optional && input.value.trim() === "") {
                setNeutral(input, errorElement);
                return true;
            }

            setValid(input, errorElement);
            return true;
        }

        rules.forEach(function (rule) {
            const input = getField(rule.id);

            if (!input) {
                return;
            }

            input.addEventListener("input", function () {
                validateOne(rule, true);
                updateFullAddressInput();
                updateVehicleTotalPreview();
            });

            input.addEventListener("change", function () {
                validateOne(rule, true);
                updateFullAddressInput();
                updateVehicleTotalPreview();
            });

            input.addEventListener("blur", function () {
                validateOne(rule, true);
            });
        });

        form.addEventListener("submit", function (event) {
            updateFullAddressInput();

            let isValid = true;
            let firstInvalidInput = null;

            rules.forEach(function (rule) {
                const input = getField(rule.id);

                if (!input) {
                    return;
                }

                const valid = validateOne(rule, true);

                if (!valid && firstInvalidInput === null) {
                    firstInvalidInput = input;
                }

                if (!valid) {
                    isValid = false;
                }
            });

            if (!isValid) {
                event.preventDefault();

                if (firstInvalidInput) {
                    firstInvalidInput.focus();
                    firstInvalidInput.scrollIntoView({
                        behavior: "smooth",
                        block: "center"
                    });
                }
            }
        });

        function updateVehicleTotalPreview() {
            const pickupDate = getField("pickupDate");
            const returnDate = getField("returnDate");
            const preview = getField("vehicleTotalPreview");

            if (!pickupDate || !returnDate || !preview) {
                return;
            }

            const pricePerDay = Number(preview.dataset.price || 0);
            const formatter = new Intl.NumberFormat("vi-VN");

            if (!pickupDate.value || !returnDate.value) {
                preview.textContent = "Giá thuê: " + formatter.format(pricePerDay) + " VNĐ/ngày";
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
                + " VNĐ cho "
                + days
                + " ngày thuê.";
        }

        const pickupInput = getField("pickupDate");
        const returnInput = getField("returnDate");

        if (pickupInput && returnInput) {
            pickupInput.addEventListener("change", function () {
                if (pickupInput.value) {
                    returnInput.min = pickupInput.value;
                }

                updateVehicleTotalPreview();
            });

            returnInput.addEventListener("change", updateVehicleTotalPreview);
            updateVehicleTotalPreview();
        }

        const checkInInput = getField("checkIn");
        const checkOutInput = getField("checkOut");

        if (checkInInput && checkOutInput) {
            checkInInput.addEventListener("change", function () {
                if (checkInInput.value) {
                    checkOutInput.min = checkInInput.value;
                }

                if (checkOutInput.value && checkOutInput.value <= checkInInput.value) {
                    checkOutInput.value = "";
                }
            });
        }
    });
</script>

</body>
</html>