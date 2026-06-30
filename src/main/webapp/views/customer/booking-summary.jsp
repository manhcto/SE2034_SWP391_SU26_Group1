<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết đơn đặt chỗ</title>
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

        .summary-page {
            padding: 42px 0 60px;
        }

        .summary-container {
            max-width: 1120px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .success-hero {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border-radius: 28px;
            padding: 34px;
            box-shadow: 0 18px 44px rgba(37, 99, 235, 0.22);
            margin-bottom: 26px;
            display: flex;
            justify-content: space-between;
            gap: 24px;
            align-items: center;
        }

        .success-left {
            display: flex;
            gap: 18px;
            align-items: flex-start;
        }

        .success-icon {
            width: 64px;
            height: 64px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            flex-shrink: 0;
        }

        .success-hero h1 {
            margin: 0 0 8px;
            font-size: 34px;
            font-weight: 950;
            letter-spacing: -0.6px;
        }

        .success-hero p {
            margin: 0;
            opacity: 0.92;
            font-size: 15px;
            line-height: 1.7;
            font-weight: 650;
        }

        .hero-code {
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 18px;
            padding: 14px 18px;
            text-align: right;
            min-width: 220px;
        }

        .hero-code span {
            display: block;
            font-size: 12px;
            opacity: 0.86;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            margin-bottom: 5px;
        }

        .hero-code strong {
            font-size: 22px;
            font-weight: 950;
        }

        .alert-box {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            border-radius: 18px;
            padding: 18px 22px;
            font-weight: 800;
            margin-bottom: 22px;
        }

        .summary-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 360px;
            gap: 24px;
            align-items: start;
        }

        .summary-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
            padding: 26px;
            margin-bottom: 24px;
        }

        .summary-card h2 {
            font-size: 21px;
            font-weight: 950;
            margin: 0 0 18px;
            padding-bottom: 14px;
            border-bottom: 1px solid #e2e8f0;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .summary-card h2 i {
            color: #2563eb;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px 24px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .detail-label {
            color: #64748b;
            font-size: 13px;
            font-weight: 850;
        }

        .detail-value {
            color: #0f172a;
            font-size: 15px;
            font-weight: 850;
            line-height: 1.6;
            word-break: break-word;
        }

        .type-pill,
        .status-badge {
            display: inline-flex;
            width: fit-content;
            align-items: center;
            justify-content: center;
            gap: 7px;
            border-radius: 999px;
            padding: 7px 12px;
            font-size: 13px;
            font-weight: 900;
        }

        .type-pill {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .status-badge {
            background: #e0f2fe;
            color: #075985;
        }

        .status-badge.pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-badge.confirmed {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-badge.completed {
            background: #dcfce7;
            color: #166534;
        }

        .status-badge.cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        .price-card {
            position: sticky;
            top: 94px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
            overflow: hidden;
        }

        .price-header {
            background: #0f172a;
            color: #ffffff;
            padding: 22px;
        }

        .price-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 950;
        }

        .price-body {
            padding: 22px;
        }

        .price-line {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            border-bottom: 1px solid #e2e8f0;
            padding: 12px 0;
            color: #64748b;
            font-weight: 750;
            line-height: 1.5;
        }

        .price-line strong {
            color: #0f172a;
            text-align: right;
        }

        .total-box {
            margin-top: 18px;
            padding: 18px;
            border-radius: 18px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

        .total-label {
            color: #1e3a8a;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .total-value {
            color: #1d4ed8;
            font-size: 28px;
            font-weight: 950;
        }

        .note-box {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 18px;
            padding: 18px;
            color: #475569;
            font-weight: 700;
            line-height: 1.7;
            white-space: pre-line;
        }

        .action-row {
            display: flex;
            justify-content: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        .btn-main,
        .btn-secondary-soft,
        .btn-staff-back {
            min-width: 190px;
            min-height: 50px;
            border-radius: 999px;
            padding: 13px 22px;
            text-decoration: none;
            font-weight: 950;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
        }

        .btn-main {
            background: #2563eb;
            color: #ffffff;
            border: 1px solid #2563eb;
        }

        .btn-main:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        .btn-secondary-soft {
            background: #ffffff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
        }

        .btn-secondary-soft:hover {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .btn-staff-back {
            background: #0f172a;
            color: #ffffff;
            border: 1px solid #0f172a;
        }

        .btn-staff-back:hover {
            background: #1e293b;
            color: #ffffff;
        }

        @media (max-width: 992px) {
            .success-hero {
                display: block;
            }

            .hero-code {
                margin-top: 20px;
                text-align: left;
            }

            .summary-layout {
                grid-template-columns: 1fr;
            }

            .price-card {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .success-left {
                display: block;
            }

            .success-icon {
                margin-bottom: 16px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .success-hero h1 {
                font-size: 28px;
            }

            .action-row {
                flex-direction: column;
            }

            .btn-main,
            .btn-secondary-soft,
            .btn-staff-back {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="summary-page">
    <div class="summary-container">

        <c:choose>
            <c:when test="${empty bookingSummary}">
                <div class="alert-box">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    Không tìm thấy thông tin đơn đặt chỗ.
                </div>

                <div class="action-row">
                    <c:if test="${param.back == 'staff'}">
                        <a href="${pageContext.request.contextPath}/staff/booking?type=${param.type}" class="btn-staff-back">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại danh sách Staff
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/home" class="btn-main">
                        <i class="fa-solid fa-house"></i>
                        Về trang chủ
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <c:set var="statusClass" value="" />
                <c:if test="${bookingSummary.status == 'Pending'}">
                    <c:set var="statusClass" value="pending" />
                </c:if>
                <c:if test="${bookingSummary.status == 'Confirmed'}">
                    <c:set var="statusClass" value="confirmed" />
                </c:if>
                <c:if test="${bookingSummary.status == 'Completed'}">
                    <c:set var="statusClass" value="completed" />
                </c:if>
                <c:if test="${bookingSummary.status == 'Cancelled'}">
                    <c:set var="statusClass" value="cancelled" />
                </c:if>

                <div class="success-hero">
                    <div class="success-left">
                        <div class="success-icon">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>

                        <div>
                            <h1>Đặt chỗ thành công</h1>
                            <p>
                                Cảm ơn bạn đã sử dụng WonderVN. Dưới đây là thông tin chi tiết đơn đặt chỗ của bạn.
                                Vui lòng lưu lại mã booking để tiện tra cứu hoặc liên hệ hỗ trợ.
                            </p>
                        </div>
                    </div>

                    <div class="hero-code">
                        <span>Mã booking</span>
                        <strong>${bookingSummary.bookingCode}</strong>
                    </div>
                </div>

                <div class="summary-layout">
                    <div>
                        <section class="summary-card">
                            <h2>
                                <i class="fa-solid fa-receipt"></i>
                                1. Thông tin đơn đặt chỗ
                            </h2>

                            <div class="detail-grid">
                                <div class="detail-item">
                                    <span class="detail-label">Booking ID</span>
                                    <span class="detail-value">${bookingSummary.bookingID}</span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Mã booking</span>
                                    <span class="detail-value">${bookingSummary.bookingCode}</span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Loại booking</span>
                                    <span class="detail-value">
                                        <span class="type-pill">
                                            <c:choose>
                                                <c:when test="${bookingSummary.bookingType == 'Tour'}">
                                                    <i class="fa-solid fa-map-location-dot"></i>
                                                    Đặt tour
                                                </c:when>
                                                <c:when test="${bookingSummary.bookingType == 'Accommodation'}">
                                                    <i class="fa-solid fa-hotel"></i>
                                                    Đặt phòng
                                                </c:when>
                                                <c:when test="${bookingSummary.bookingType == 'Vehicle'}">
                                                    <i class="fa-solid fa-car-side"></i>
                                                    Đặt xe
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-briefcase"></i>
                                                    ${bookingSummary.bookingType}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Trạng thái</span>
                                    <span class="detail-value">
                                        <span class="status-badge ${statusClass}">
                                            <c:choose>
                                                <c:when test="${bookingSummary.status == 'Pending'}">Chờ xử lý</c:when>
                                                <c:when test="${bookingSummary.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${bookingSummary.status == 'Completed'}">Hoàn thành</c:when>
                                                <c:when test="${bookingSummary.status == 'Cancelled'}">Đã hủy</c:when>
                                                <c:otherwise>${bookingSummary.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Ngày đặt</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${bookingSummary.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Đặt hộ người khác</span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${bookingSummary.isBookedForOther == true || bookingSummary.bookedForOther == true}">
                                                Có
                                            </c:when>
                                            <c:otherwise>Không</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </section>

                        <section class="summary-card">
                            <h2>
                                <i class="fa-solid fa-user"></i>
                                2. Thông tin khách hàng
                            </h2>

                            <div class="detail-grid">
                                <div class="detail-item">
                                    <span class="detail-label">Họ tên</span>
                                    <span class="detail-value">${bookingSummary.firstName} ${bookingSummary.lastName}</span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Email</span>
                                    <span class="detail-value">${bookingSummary.email}</span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Số điện thoại</span>
                                    <span class="detail-value">${bookingSummary.phone}</span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Địa chỉ</span>
                                    <span class="detail-value">
                                        <c:choose>
                                            <c:when test="${not empty bookingSummary.address}">
                                                ${bookingSummary.address}
                                            </c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </section>

                        <section class="summary-card">
                            <c:choose>
                                <c:when test="${bookingSummary.bookingType == 'Accommodation'}">
                                    <h2>
                                        <i class="fa-solid fa-hotel"></i>
                                        3. Thông tin đặt phòng
                                    </h2>

                                    <div class="detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Nơi lưu trú</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.accommodationName}">
                                                        ${bookingSummary.accommodationName}
                                                    </c:when>
                                                    <c:when test="${not empty bookingSummary.itemName}">
                                                        ${bookingSummary.itemName}
                                                    </c:when>
                                                    <c:otherwise>${bookingSummary.serviceName}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Service ID</span>
                                            <span class="detail-value">${bookingSummary.serviceID}</span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Ngày nhận phòng</span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${bookingSummary.startDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Ngày trả phòng</span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${bookingSummary.endDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Số phòng</span>
                                            <span class="detail-value">${bookingSummary.quantity}</span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Số khách</span>
                                            <span class="detail-value">
                                                ${bookingSummary.numberAdult} người lớn, ${bookingSummary.numberChildren} trẻ em
                                            </span>
                                        </div>
                                    </div>
                                </c:when>

                                <c:when test="${bookingSummary.bookingType == 'Vehicle'}">
                                    <h2>
                                        <i class="fa-solid fa-car-side"></i>
                                        3. Thông tin đặt xe
                                    </h2>

                                    <div class="detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Tên xe</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.itemName}">
                                                        ${bookingSummary.itemName}
                                                    </c:when>
                                                    <c:when test="${not empty bookingSummary.vehicleModel}">
                                                        ${bookingSummary.vehicleModel}
                                                    </c:when>
                                                    <c:otherwise>${bookingSummary.serviceName}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Hãng xe</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.brandName}">
                                                        ${bookingSummary.brandName}
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Biển số</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.licensePlate}">
                                                        ${bookingSummary.licensePlate}
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Service ID</span>
                                            <span class="detail-value">${bookingSummary.serviceID}</span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Ngày nhận xe</span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${bookingSummary.startDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Ngày trả xe</span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${bookingSummary.endDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Địa điểm nhận xe</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.pickupAddress}">
                                                        ${bookingSummary.pickupAddress}
                                                    </c:when>
                                                    <c:when test="${not empty bookingSummary.pickupDistrict || not empty bookingSummary.pickupProvince}">
                                                        ${bookingSummary.pickupDistrict}, ${bookingSummary.pickupProvince}
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <h2>
                                        <i class="fa-solid fa-map-location-dot"></i>
                                        3. Thông tin tour
                                    </h2>

                                    <div class="detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Tên tour</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.tourName}">
                                                        ${bookingSummary.tourName}
                                                    </c:when>
                                                    <c:otherwise>${bookingSummary.serviceName}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Tour Schedule ID</span>
                                            <span class="detail-value">${bookingSummary.tourScheduleID}</span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Điểm khởi hành</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.startPlace}">
                                                        ${bookingSummary.startPlace}
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Điểm đến</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${not empty bookingSummary.endPlace}">
                                                        ${bookingSummary.endPlace}
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Ngày bắt đầu</span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${bookingSummary.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Ngày kết thúc</span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${bookingSummary.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Số khách</span>
                                            <span class="detail-value">
                                                ${bookingSummary.numberAdult} người lớn, ${bookingSummary.numberChildren} trẻ em
                                            </span>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </section>

                        <section class="summary-card">
                            <h2>
                                <i class="fa-solid fa-note-sticky"></i>
                                4. Ghi chú
                            </h2>

                            <div class="note-box">
                                <c:choose>
                                    <c:when test="${not empty bookingSummary.note}">
                                        ${bookingSummary.note}
                                    </c:when>
                                    <c:otherwise>Không có ghi chú.</c:otherwise>
                                </c:choose>
                            </div>
                        </section>
                    </div>

                    <aside class="price-card">
                        <div class="price-header">
                            <h3>
                                <i class="fa-solid fa-money-bill-wave me-2"></i>
                                Thanh toán
                            </h3>
                        </div>

                        <div class="price-body">
                            <c:choose>
                                <c:when test="${bookingSummary.bookingType == 'Accommodation'}">
                                    <div class="price-line">
                                        <span>Số phòng</span>
                                        <strong>${bookingSummary.quantity}</strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Đơn giá/phòng/đêm</span>
                                        <strong>
                                            <fmt:formatNumber value="${bookingSummary.unitPrice}" type="number" maxFractionDigits="0"/> đ
                                        </strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Tạm tính</span>
                                        <strong>
                                            <fmt:formatNumber value="${bookingSummary.subTotal}" type="number" maxFractionDigits="0"/> đ
                                        </strong>
                                    </div>
                                </c:when>

                                <c:when test="${bookingSummary.bookingType == 'Vehicle'}">
                                    <div class="price-line">
                                        <span>Số ngày thuê</span>
                                        <strong>${bookingSummary.quantity}</strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Đơn giá/ngày</span>
                                        <strong>
                                            <fmt:formatNumber value="${bookingSummary.unitPrice}" type="number" maxFractionDigits="0"/> đ
                                        </strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Tạm tính</span>
                                        <strong>
                                            <fmt:formatNumber value="${bookingSummary.subTotal}" type="number" maxFractionDigits="0"/> đ
                                        </strong>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="price-line">
                                        <span>Số người lớn</span>
                                        <strong>${bookingSummary.numberAdult}</strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Số trẻ em</span>
                                        <strong>${bookingSummary.numberChildren}</strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Tổng số khách</span>
                                        <strong>${bookingSummary.quantity}</strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Đơn giá trung bình</span>
                                        <strong>
                                            <fmt:formatNumber value="${bookingSummary.unitPrice}" type="number" maxFractionDigits="0"/> đ
                                        </strong>
                                    </div>

                                    <div class="price-line">
                                        <span>Tạm tính</span>
                                        <strong>
                                            <fmt:formatNumber value="${bookingSummary.subTotal}" type="number" maxFractionDigits="0"/> đ
                                        </strong>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="total-box">
                                <div class="total-label">Tổng tiền</div>
                                <div class="total-value">
                                    <fmt:formatNumber value="${bookingSummary.totalPrice}" type="number" maxFractionDigits="0"/> đ
                                </div>
                            </div>
                        </div>
                    </aside>
                </div>

                <div class="action-row">
                    <c:if test="${param.back == 'staff'}">
                        <a href="${pageContext.request.contextPath}/staff/booking?type=${param.type}" class="btn-staff-back">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại danh sách Staff
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/home" class="btn-main">
                        <i class="fa-solid fa-house"></i>
                        Về trang chủ
                    </a>

                    <c:choose>
                        <c:when test="${bookingSummary.bookingType == 'Accommodation'}">
                            <a href="${pageContext.request.contextPath}/accommodation" class="btn-secondary-soft">
                                <i class="fa-solid fa-hotel"></i>
                                Xem thêm lưu trú
                            </a>
                        </c:when>

                        <c:when test="${bookingSummary.bookingType == 'Vehicle'}">
                            <a href="${pageContext.request.contextPath}/vehicle" class="btn-secondary-soft">
                                <i class="fa-solid fa-car-side"></i>
                                Xem thêm xe
                            </a>
                        </c:when>

                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/tour" class="btn-secondary-soft">
                                <i class="fa-solid fa-map-location-dot"></i>
                                Xem thêm tour
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>