<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Staff Edit Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

        .staff-layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 292px;
            background: #0f172a;
            color: #ffffff;
            position: fixed;
            inset: 0 auto 0 0;
            overflow-y: auto;
            padding: 26px 18px;
            box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18);
        }

        .sidebar::-webkit-scrollbar {
            width: 7px;
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: #334155;
            border-radius: 20px;
        }

        .brand-box {
            padding: 8px 10px 22px;
            margin-bottom: 12px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
        }

        .brand-logo {
            width: 52px;
            height: 52px;
            border-radius: 18px;
            background: linear-gradient(135deg, #06b6d4, #4e46dc);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 20px;
            margin-bottom: 12px;
        }

        .brand-box h2 {
            font-size: 26px;
            font-weight: 800;
            margin: 0;
            letter-spacing: -0.6px;
        }

        .brand-box p {
            color: #cbd5e1;
            margin: 5px 0 0;
            font-size: 14px;
        }

        .nav-section-title {
            font-size: 11px;
            text-transform: uppercase;
            color: #94a3b8;
            letter-spacing: 1.2px;
            margin: 22px 12px 10px;
            font-weight: 800;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 14px;
            border-radius: 15px;
            color: #e2e8f0;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 8px;
            transition: all 0.2s ease;
        }

        .sidebar-link i {
            width: 22px;
            text-align: center;
            font-size: 16px;
        }

        .sidebar-link:hover {
            background: #1e293b;
            color: white;
            transform: translateX(4px);
        }

        .sidebar-link.active {
            background: linear-gradient(135deg, #06b6d4, #4e46dc);
            color: white;
            box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22);
        }

        .admin-user {
            margin-top: 26px;
            border-top: 1px solid rgba(148, 163, 184, 0.25);
            padding: 18px 8px 4px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #06b6d4, #22c55e);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            color: white;
        }

        .admin-user small {
            color: #94a3b8;
        }

        .main-content {
            margin-left: 292px;
            width: calc(100% - 292px);
            padding: 34px 42px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 26px;
        }

        .topbar h1 {
            font-size: 34px;
            font-weight: 900;
            margin: 0;
            letter-spacing: -0.8px;
        }

        .topbar p {
            color: #64748b;
            margin: 6px 0 0;
            font-size: 15px;
        }

        .top-action-btn {
            border: none;
            border-radius: 16px;
            padding: 12px 18px;
            text-decoration: none;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
            background: #0f172a;
            color: #ffffff;
        }

        .top-action-btn:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .error-box {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #f87171;
            border-radius: 18px;
            padding: 18px 22px;
            margin-bottom: 22px;
            font-weight: 700;
            line-height: 1.7;
        }

        .error-box ul {
            margin: 8px 0 0;
            padding-left: 22px;
        }

        .edit-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 26px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .booking-info {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 18px;
            margin-bottom: 24px;
        }

        .info-label {
            display: block;
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .info-value {
            color: #0f172a;
            font-size: 15px;
            font-weight: 900;
        }

        .form-label {
            font-weight: 800;
            color: #334155;
        }

        .form-control,
        .form-select {
            border-radius: 14px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            font-weight: 600;
            transition: 0.18s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #4e46dc;
            box-shadow: 0 0 0 0.2rem rgba(78, 70, 220, 0.12);
        }

        .form-control.input-error,
        .form-select.input-error {
            border-color: #ef4444;
            box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.12);
        }

        .form-control.input-error:focus,
        .form-select.input-error:focus {
            border-color: #ef4444;
            box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.12);
        }

        .form-control.input-valid,
        .form-select.input-valid {
            border-color: #22c55e;
        }

        .form-control.input-valid:focus,
        .form-select.input-valid:focus {
            border-color: #22c55e;
            box-shadow: 0 0 0 0.2rem rgba(34, 197, 94, 0.12);
        }

        .field-error-message {
            display: none;
            color: #dc2626;
            font-size: 12px;
            font-weight: 600;
            margin-top: 6px;
            line-height: 1.35;
        }

        .field-error-message.show {
            display: block;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 26px;
        }

        .btn-save,
        .btn-back {
            min-width: 170px;
            border-radius: 999px;
            padding: 12px 22px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: none;
        }

        .btn-save {
            background: #4e46dc;
            color: #ffffff;
        }

        .btn-save:hover {
            background: #3730a3;
            color: #ffffff;
        }

        .btn-back {
            background: #ffffff;
            color: #4e46dc;
            border: 1px solid #4e46dc;
        }

        .btn-back:hover {
            background: #eef2ff;
            color: #4e46dc;
        }

        .form-section-title {
            font-size: 18px;
            font-weight: 900;
            color: #0f172a;
            margin: 6px 0 4px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e2e8f0;
        }

        @media (max-width: 992px) {
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .staff-layout {
                display: block;
            }

            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .topbar {
                display: block;
            }

            .top-action-btn {
                margin-top: 16px;
            }
        }
    </style>
</head>

<body>
<div class="staff-layout">

    <aside class="sidebar">
        <div class="brand-box">
            <div class="brand-logo">WV</div>
            <h2>WonderVN</h2>
            <p>Travel ERP System</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ nhân viên</span>
        </a>

        <div class="nav-section-title">Dịch vụ du lịch</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
            <i class="fa-solid fa-map-location-dot"></i>
            <span>Quản lý Tour</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
            <i class="fa-solid fa-hotel"></i>
            <span>Quản lý lưu trú</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/vehicle?action=list">
            <i class="fa-solid fa-car-side"></i>
            <span>Quản lý phương tiện</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/service">
            <i class="fa-solid fa-briefcase"></i>
            <span>Quản lý dịch vụ</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/external-ticket">
            <i class="fa-solid fa-ticket"></i>
            <span>Vé tham quan bên ngoài</span>
        </a>

        <div class="nav-section-title">Vận hành booking</div>

        <a class="sidebar-link ${selectedBookingType == 'Tour' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/staff/booking?type=Tour">
            <i class="fa-solid fa-map-location-dot"></i>            <span>Quản lý đặt tour</span>
        </a>

        <a class="sidebar-link ${selectedBookingType == 'Accommodation' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/staff/booking?type=Accommodation">
            <i class="fa-solid fa-hotel"></i>
            <span>Quản lý đặt phòng</span>
        </a>

        <a class="sidebar-link ${selectedBookingType == 'Vehicle' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/staff/booking?type=Vehicle">
            <i class="fa-solid fa-car-side"></i>
            <span>Quản lý đặt xe</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/payment">
            <i class="fa-solid fa-credit-card"></i>
            <span>Quản lý thanh toán</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/voucher">
            <i class="fa-solid fa-gift"></i>
            <span>Quản lý Voucher</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/assignment">
            <i class="fa-solid fa-user-tie"></i>
            <span>Điều phối hướng dẫn viên</span>
        </a>

        <div class="nav-section-title">Nội dung & CSKH</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/blog">
            <i class="fa-solid fa-newspaper"></i>
            <span>Quản lý Blog</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
            <i class="fa-solid fa-comments"></i>
            <span>Đánh giá khách hàng</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/notification">
            <i class="fa-solid fa-bell"></i>
            <span>Cấu hình thông báo</span>
        </a>

        <div class="admin-user">
            <div class="avatar">ST</div>
            <div>
                <div class="fw-bold">Nhân viên</div>
                <small>Staff</small>
            </div>
        </div>
    </aside>

    <c:set var="backUrl" value="${backToBookingListUrl}" />
    <c:if test="${empty backUrl}">
        <c:set var="backUrl" value="${pageContext.request.contextPath}/staff/booking?type=${selectedBookingType}" />
    </c:if>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Sửa Booking</h1>
                <p>
                    Cập nhật thông tin khách hàng, số khách và trạng thái booking.
                </p>
            </div>

            <a class="top-action-btn" href="${backUrl}">
                <i class="fa-solid fa-arrow-left"></i>
                Quay lại danh sách
            </a>
        </div>

        <c:if test="${not empty error}">
        <div class="error-box">
                ${error}
        </div>
        </c:if>

        <c:if test="${not empty errors}">
        <div class="error-box">
            <div>
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Vui lòng kiểm tra lại các thông tin sau:
            </div>

            <ul>
                <c:forEach items="${errors}" var="err">
                    <li>${err}</li>
                </c:forEach>
            </ul>
        </div>
        </c:if>

        <c:if test="${not empty booking}">
        <div class="edit-card">
            <div class="booking-info">
                <div class="row g-3">
                    <div class="col-md-3">
                        <span class="info-label">Booking ID</span>
                        <span class="info-value">${booking.bookingID}</span>
                    </div>

                    <div class="col-md-3">
                        <span class="info-label">Mã Booking</span>
                        <span class="info-value">${booking.bookingCode}</span>
                    </div>

                    <div class="col-md-3">
                        <span class="info-label">Ngày đặt</span>
                        <span class="info-value">
                                <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                    </div>

                    <div class="col-md-3">
                        <span class="info-label">Tổng tiền</span>
                        <span class="info-value">
                                <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                            </span>
                    </div>
                </div>

                <div class="row g-3 mt-1">
                    <div class="col-md-2">
                        <span class="info-label">Loại booking</span>
                        <span class="info-value">
                                <c:choose>
                                    <c:when test="${booking.bookingType == 'Tour'}">Đặt tour</c:when>
                                    <c:when test="${booking.bookingType == 'Accommodation'}">Đặt phòng</c:when>
                                    <c:when test="${selectedBookingType == 'Vehicle'}">Đặt xe</c:when>
                                    <c:otherwise>${booking.displayType}</c:otherwise>
                                </c:choose>
                            </span>
                    </div>

                    <div class="col-md-4">
                        <span class="info-label">Dịch vụ</span>
                        <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty booking.serviceName}">
                                        ${booking.serviceName}
                                    </c:when>
                                    <c:otherwise>Chưa có dịch vụ</c:otherwise>
                                </c:choose>
                            </span>
                    </div>

                    <div class="col-md-3">
                        <span class="info-label">Lịch sử dụng</span>
                        <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty booking.serviceStartDate || not empty booking.serviceEndDate}">
                                        <fmt:formatDate value="${booking.serviceStartDate}" pattern="dd/MM/yyyy"/>
                                        <c:if test="${not empty booking.serviceEndDate}">
                                            - <fmt:formatDate value="${booking.serviceEndDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>Chưa có lịch</c:otherwise>
                                </c:choose>
                            </span>
                    </div>

                    <div class="col-md-3">
                        <span class="info-label">Số khách</span>
                        <span class="info-value">${booking.totalGuests} khách (${booking.numberAdult} NL, ${booking.numberChildren} TE)</span>
                    </div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/staff/booking-edit"
                  method="post"
                  id="staffEditBookingForm"
                  data-booking-type="${selectedBookingType}"
                  novalidate>
                <input type="hidden" name="bookingID" value="${booking.bookingID}">
                <input type="hidden" name="type" value="${selectedBookingType}">

                <div class="row g-4">
                    <div class="col-12">
                        <div class="form-section-title">Thông tin khách hàng</div>
                    </div>

                    <div class="col-md-6">
                        <label for="firstName" class="form-label">Họ và tên đệm *</label>
                        <input type="text"
                               class="form-control"
                               id="firstName"
                               name="firstName"
                               value="${booking.firstName}">
                        <span class="field-error-message" id="firstNameError"></span>
                    </div>

                    <div class="col-md-6">
                        <label for="lastName" class="form-label">Tên *</label>
                        <input type="text"
                               class="form-control"
                               id="lastName"
                               name="lastName"
                               value="${booking.lastName}">
                        <span class="field-error-message" id="lastNameError"></span>
                    </div>

                    <div class="col-md-6">
                        <label for="email" class="form-label">Email *</label>
                        <input type="text"
                               class="form-control"
                               id="email"
                               name="email"
                               value="${booking.email}">
                        <span class="field-error-message" id="emailError"></span>
                    </div>

                    <div class="col-md-6">
                        <label for="phone" class="form-label">Số điện thoại *</label>
                        <input type="text"
                               class="form-control"
                               id="phone"
                               name="phone"
                               value="${booking.phone}">
                        <span class="field-error-message" id="phoneError"></span>
                    </div>

                    <c:if test="${selectedBookingType == 'Vehicle'}">
                        <fmt:formatDate value="${booking.serviceStartDate}" pattern="yyyy-MM-dd" var="vehiclePickupDateValue"/>
                        <fmt:formatDate value="${booking.serviceEndDate}" pattern="yyyy-MM-dd" var="vehicleReturnDateValue"/>

                    <div class="col-md-6">
                        <label for="pickupDate" class="form-label">Ngày nhận xe *</label>
                        <input type="date"
                               class="form-control"
                               id="pickupDate"
                               name="pickupDate"
                               value="${not empty pickupDate ? pickupDate : vehiclePickupDateValue}">
                        <span class="field-error-message" id="pickupDateError"></span>
                    </div>

                    <div class="col-md-6">
                        <label for="returnDate" class="form-label">Ngày trả xe *</label>
                        <input type="date"
                               class="form-control"
                               id="returnDate"
                               name="returnDate"
                               value="${not empty returnDate ? returnDate : vehicleReturnDateValue}">
                        <span class="field-error-message" id="returnDateError"></span>
                    </div>
                    </c:if>

                    <div class="col-12">
                        <div class="form-section-title">Địa chỉ khách hàng</div>
                    </div>

                    <div class="col-md-12">
                        <label for="streetAddress" class="form-label">Số nhà, đường *</label>
                        <input type="text"
                               class="form-control"
                               id="streetAddress"
                               name="streetAddress"
                               value="${streetAddress}"
                               maxlength="120"
                               placeholder="VD: Số 10 Nguyễn Trãi">
                        <span class="field-error-message" id="streetAddressError"></span>
                    </div>

                    <div class="col-md-6">
                        <label for="district" class="form-label">Quận / Huyện *</label>
                        <select class="form-select" id="district" name="district">
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

                    <div class="col-md-6">
                        <label for="city" class="form-label">Tỉnh / Thành phố *</label>
                        <select class="form-select" id="city" name="city">
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
                    </div>                        <div class="col-12">
                    <div class="form-section-title">Thông tin booking</div>
                </div>

                    <c:choose>
                        <c:when test="${selectedBookingType == 'Vehicle'}">
                            <input type="hidden" id="numberAdult" name="numberAdult" value="${not empty booking.numberAdult ? booking.numberAdult : 1}">
                            <input type="hidden" id="numberChildren" name="numberChildren" value="${not empty booking.numberChildren ? booking.numberChildren : 0}">
                        </c:when>

                        <c:otherwise>
                            <div class="col-md-6">
                                <label for="numberAdult" class="form-label">Số người lớn *</label>
                                <input type="text"
                                       class="form-control"
                                       id="numberAdult"
                                       name="numberAdult"
                                       value="${booking.numberAdult}"
                                       inputmode="numeric"
                                       pattern="[0-9]*">
                                <span class="field-error-message" id="numberAdultError"></span>
                            </div>

                            <div class="col-md-6">
                                <label for="numberChildren" class="form-label">Số trẻ em *</label>
                                <input type="text"
                                       class="form-control"
                                       id="numberChildren"
                                       name="numberChildren"
                                       value="${booking.numberChildren}"
                                       inputmode="numeric"
                                       pattern="[0-9]*">
                                <span class="field-error-message" id="numberChildrenError"></span>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="col-md-6">
                        <label for="isBookedForOther" class="form-label">Đặt hộ người khác</label>
                        <select class="form-select" id="isBookedForOther" name="isBookedForOther">
                            <option value="false" ${booking.bookedForOther == false ? 'selected' : ''}>Không</option>
                            <option value="true" ${booking.bookedForOther == true ? 'selected' : ''}>Có</option>
                        </select>
                        <span class="field-error-message" id="isBookedForOtherError"></span>
                    </div>

                    <div class="col-md-6">
                        <label for="status" class="form-label">Trạng thái Booking *</label>
                        <select class="form-select" id="status" name="status">
                            <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                            <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        </select>
                        <span class="field-error-message" id="statusError"></span>
                    </div>

                    <div class="col-md-12">
                        <label for="note" class="form-label">Ghi chú</label>
                        <textarea class="form-control"
                                  id="note"
                                  name="note"
                                  maxlength="1000">${booking.note}</textarea>
                        <span class="field-error-message" id="noteError"></span>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save">
                        <i class="fa-solid fa-floppy-disk"></i>
                        Lưu thay đổi
                    </button>

                    <a href="${backUrl}" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>
                </div>
            </form>
        </div>
        </c:if>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("staffEditBookingForm");

        if (!form) {
            return;
        }

        const bookingType = form.dataset.bookingType || "";
        const vietnameseNameRegex = /^[A-Za-zÀ-ỹ\s]+$/;
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

            if (!vietnameseNameRegex.test(text)) {
                return fieldName + " chỉ được chứa chữ cái và khoảng trắng.";
            }

            return "";        }

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

        function validateAddress(value) {
            const text = value.trim();

            if (text === "") {
                return "Vui lòng nhập địa chỉ liên hệ.";
            }

            if (text.length > 255) {
                return "Địa chỉ liên hệ không được vượt quá 255 ký tự.";
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

        function validatePickupDate(value) {
            if (!value) {
                return "Vui lòng chọn ngày nhận xe.";
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

            const pickupDate = new Date(pickupInput.value + "T00:00:00");
            const returnDate = new Date(value + "T00:00:00");

            if (returnDate <= pickupDate) {
                return "Ngày trả xe phải sau ngày nhận xe.";
            }

            return "";
        }

        function validateStatus(value) {
            const validStatusList = ["Pending", "Confirmed", "Cancelled", "Completed"];

            if (!validStatusList.includes(value)) {
                return "Trạng thái booking không hợp lệ.";
            }

            return "";
        }

        function validateBookedForOther(value) {
            const validValues = ["true", "false"];

            if (!validValues.includes(value)) {
                return "Giá trị đặt hộ người khác không hợp lệ.";
            }

            return "";
        }

        function validateNote(value) {
            const text = value.trim();

            if (text === "") {
                return "";
            }

            if (text.length > 1000) {
                return "Ghi chú không được vượt quá 1000 ký tự.";
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

            if (bookingType === "Vehicle") {
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
            } else {
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

            rules.push(
                {
                    id: "isBookedForOther",
                    errorId: "isBookedForOtherError",
                    validate: validateBookedForOther
                },
                {
                    id: "status",
                    errorId: "statusError",
                    validate: validateStatus
                },
                {
                    id: "note",
                    errorId: "noteError",
                    validate: validateNote,
                    optional: true
                }
            );

            return rules;
        }

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
            });

            input.addEventListener("change", function () {
                validateOne(rule, true);
            });

            input.addEventListener("blur", function () {
                validateOne(rule, true);
            });
        });

        form.addEventListener("submit", function (event) {
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
    });
</script>

</body>
</html>