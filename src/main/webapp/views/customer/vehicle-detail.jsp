<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | ${vehicle.displayName}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --dark: #0f172a;
            --text: #1e293b;
            --muted: #64748b;
            --bg: #f3f6fb;
            --soft: #f8fafc;
            --border: #e2e8f0;
            --warning-bg: #fff7ed;
            --warning-border: #fed7aa;
            --warning-text: #9a3412;
            --shadow: 0 16px 40px rgba(15, 23, 42, 0.10);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--bg);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            color: var(--text);
            font-size: 15px;
            line-height: 1.5;
        }

        .detail-page {
            padding: 30px 0 56px;
        }

        .breadcrumb-line {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 9px;
            margin-bottom: 18px;
            color: var(--muted);
            font-size: 14px;
        }

        .breadcrumb-line a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
        }

        .btn-back-page {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 16px;
            border-radius: 999px;
            background: #ffffff;
            color: #0f172a;
            border: 1px solid #dbe3ef;
            text-decoration: none;
            font-weight: 800;
            box-shadow: 0 8px 18px rgba(15, 23, 42, 0.08);
            cursor: pointer;
        }

        .btn-back-page:hover {
            background: #f8fafc;
            color: var(--primary);
        }

        .detail-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 360px;
            gap: 26px;
            align-items: start;
        }

        .main-card,
        .booking-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 26px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .image-hero {
            height: 390px;
            position: relative;
            overflow: hidden;
            background: #e2e8f0;
        }

        .image-hero img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .image-overlay {
            position: absolute;
            left: 22px;
            right: 22px;
            bottom: 22px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 14px;
        }

        .type-badge,
        .available-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 9px 14px;
            font-size: 13px;
            font-weight: 700;
            backdrop-filter: blur(8px);
        }

        .type-badge {
            background: rgba(15, 23, 42, 0.9);
            color: #ffffff;
        }

        .available-badge {
            background: #22c55e;
            color: #ffffff;
            box-shadow: 0 12px 24px rgba(34, 197, 94, 0.24);
        }

        .main-content {
            padding: 28px;
        }

        .vehicle-title {
            font-size: 32px;
            line-height: 1.22;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin: 0 0 12px;
            color: var(--dark);
        }

        .location-row {
            display: flex;
            align-items: flex-start;
            gap: 11px;
            color: var(--muted);
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 24px;
        }

        .location-row i {
            color: #06b6d4;
            margin-top: 4px;
        }

        .location-row strong {
            color: #334155;
            font-size: 15.5px;
            font-weight: 700;
        }

        .spec-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 13px;
            margin: 22px 0 28px;
        }

        .spec-card {
            border: 1px solid var(--border);
            background: var(--soft);
            border-radius: 18px;
            padding: 16px;
            min-height: 118px;
        }

        .spec-icon {
            width: 38px;
            height: 38px;
            border-radius: 13px;
            background: #e0ecff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 17px;
            margin-bottom: 12px;
        }

        .spec-label {
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 11.5px;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .spec-value {
            font-size: 16px;
            font-weight: 800;
            color: var(--dark);
            line-height: 1.35;
        }

        .section-block {
            margin-top: 26px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 22px;
            line-height: 1.3;
            font-weight: 800;
            margin-bottom: 12px;
            color: var(--dark);
        }

        .section-title i {
            color: var(--primary);
            font-size: 18px;
        }

        .text-box {
            color: #475569;
            font-size: 15.5px;
            line-height: 1.8;
        }

        .note-box {
            color: #334155;
            font-size: 15.5px;
            line-height: 1.8;
            font-weight: 700;
            padding: 0;
            margin-top: 4px;
            background: transparent;
            border: none;
        }

        .note-box i {
            display: none;
        }

        .note-box .note-prefix {
            color: #0f172a;
            font-weight: 900;
        }

        .booking-card {
            position: sticky;
            top: 100px;
            padding: 24px;
        }

        .booking-title {
            color: var(--muted);
            font-weight: 700;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .price-row {
            display: flex;
            align-items: baseline;
            gap: 8px;
            margin-bottom: 20px;
        }

        .price-main {
            font-size: 32px;
            line-height: 1.1;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: var(--dark);
        }

        .price-unit {
            color: var(--muted);
            font-size: 15px;
            font-weight: 500;
        }

        .side-info {
            background: var(--soft);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 16px;
            margin-bottom: 14px;
        }

        .side-info-label {
            color: var(--muted);
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .side-info-value {
            font-weight: 800;
            font-size: 17px;
            color: var(--dark);
        }

        .side-info-sub {
            color: var(--muted);
            margin-top: 4px;
            font-size: 14px;
            line-height: 1.5;
        }

        .btn-book {
            width: 100%;
            border: none;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border-radius: 16px;
            padding: 14px 18px;
            font-weight: 800;
            font-size: 15.5px;
            margin-top: 8px;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.22);
        }

        .btn-book:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
        }

        .btn-back {
            width: 100%;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: var(--dark);
            border-radius: 16px;
            padding: 13px 18px;
            font-weight: 800;
            text-decoration: none;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 12px;
        }

        .btn-back:hover {
            background: #f8fafc;
            color: var(--dark);
        }

        .quick-tips {
            margin-top: 18px;
            padding-top: 18px;
            border-top: 1px dashed #cbd5e1;
        }

        .tip-item {
            display: flex;
            gap: 9px;
            align-items: flex-start;
            color: #475569;
            font-size: 14px;
            line-height: 1.55;
            margin-bottom: 10px;
        }

        .tip-item i {
            color: #22c55e;
            margin-top: 3px;
        }

        @media (max-width: 1100px) {
            .detail-layout {
                grid-template-columns: 1fr;
            }

            .booking-card {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .image-hero {
                height: 300px;
            }

            .main-content {
                padding: 22px;
            }

            .vehicle-title {
                font-size: 27px;
            }

            .spec-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .price-main {
                font-size: 29px;
            }
        }

        @media (max-width: 520px) {
            .spec-grid {
                grid-template-columns: 1fr;
            }

            .image-overlay {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<div class="container detail-page">
    <div class="breadcrumb-line">
        <button type="button" class="btn-back-page" onclick="history.back()">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại trang trước
        </button>

        <a href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-house"></i> Trang chủ
        </a>

        <span>/</span>

        <a href="${pageContext.request.contextPath}/vehicle">Thuê xe</a>

        <span>/</span>

        <span>${vehicle.displayName}</span>
    </div>

    <div class="detail-layout">
        <div class="main-card">
            <div class="image-hero">
                <img src="${vehicle.image}"
                     alt="${vehicle.displayName}"
                     onerror="this.src='https://placehold.co/1200x700?text=WonderVN+Vehicle';">

                <div class="image-overlay">
                    <div class="type-badge">
                        <i class="fa-solid fa-car-side"></i>
                        <c:choose>
                            <c:when test="${vehicle.vehicleType == 'Motorbike'}">Xe máy</c:when>
                            <c:when test="${vehicle.vehicleType == 'Luxury Sedan'}">Sedan hạng sang</c:when>
                            <c:when test="${vehicle.vehicleType == 'Bus'}">Xe khách</c:when>
                            <c:otherwise>${vehicle.vehicleType}</c:otherwise>
                        </c:choose>
                    </div>

                    <div class="available-badge">
                        <i class="fa-solid fa-circle-check"></i>
                        Sẵn sàng cho thuê
                    </div>
                </div>
            </div>

            <div class="main-content">
                <h1 class="vehicle-title">${vehicle.displayName}</h1>

                <div class="location-row">
                    <i class="fa-solid fa-location-dot"></i>
                    <div>
                        <strong>${vehicle.pickupProvince}</strong><br>
                        <span>${vehicle.fullPickupAddress}</span>
                    </div>
                </div>

                <div class="spec-grid">
                    <div class="spec-card">
                        <div class="spec-icon">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div class="spec-label">Số chỗ</div>
                        <div class="spec-value">${vehicle.seatCount} chỗ</div>
                    </div>

                    <div class="spec-card">
                        <div class="spec-icon">
                            <i class="fa-solid fa-gears"></i>
                        </div>
                        <div class="spec-label">Hộp số</div>
                        <div class="spec-value">
                            <c:choose>
                                <c:when test="${vehicle.transmission == 'Automatic'}">Số tự động</c:when>
                                <c:otherwise>Số sàn</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="spec-card">
                        <div class="spec-icon">
                            <i class="fa-solid fa-gas-pump"></i>
                        </div>
                        <div class="spec-label">Nhiên liệu</div>
                        <div class="spec-value">
                            <c:choose>
                                <c:when test="${vehicle.fuelType == 'Gasoline'}">Xăng</c:when>
                                <c:when test="${vehicle.fuelType == 'Diesel'}">Dầu Diesel</c:when>
                                <c:when test="${vehicle.fuelType == 'Electric'}">Điện</c:when>
                                <c:otherwise>Hybrid</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="spec-card">
                        <div class="spec-icon">
                            <i class="fa-solid fa-id-card"></i>
                        </div>
                        <div class="spec-label">Biển số</div>
                        <div class="spec-value">${vehicle.licensePlate}</div>
                    </div>
                </div>

                <div class="section-block">
                    <h2 class="section-title">
                        <i class="fa-solid fa-circle-info"></i>
                        Mô tả phương tiện
                    </h2>

                    <div class="text-box">
                        <c:choose>
                            <c:when test="${not empty vehicle.description}">
                                ${vehicle.description}
                            </c:when>
                            <c:otherwise>
                                Phương tiện phù hợp cho nhu cầu di chuyển du lịch, công tác và các hành trình cá nhân.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="section-block">
                    <h2 class="section-title">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        Lưu ý khi sử dụng
                    </h2>

                    <div class="note-box">
                        <span class="note-prefix">Ghi chú:</span>
                        <c:choose>
                            <c:when test="${not empty vehicle.usageNotes}">
                                ${vehicle.usageNotes}
                            </c:when>
                            <c:otherwise>
                                Khách hàng nên kiểm tra xe trước khi nhận, sử dụng đúng mục đích và hoàn trả đúng thời gian đã thỏa thuận.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <aside class="booking-card">
            <div class="booking-title">Giá thuê</div>

            <div class="price-row">
                <div class="price-main">
                    <fmt:formatNumber value="${vehicle.pricePerDay}" type="number" maxFractionDigits="0"/> đ
                </div>
                <div class="price-unit">/ ngày</div>
            </div>

            <div class="side-info">
                <div class="side-info-label">Tiền đặt cọc</div>
                <div class="side-info-value">
                    <fmt:formatNumber value="${vehicle.depositAmount}" type="number" maxFractionDigits="0"/> đ
                </div>
            </div>

            <div class="side-info">
                <div class="side-info-label">Địa điểm nhận xe</div>
                <div class="side-info-value">${vehicle.pickupProvince}</div>
                <div class="side-info-sub">
                    ${vehicle.pickupDistrict}
                    <c:if test="${not empty vehicle.pickupWard}">
                        , ${vehicle.pickupWard}
                    </c:if>
                </div>
            </div>

            <button type="button" class="btn-book">
                <i class="fa-solid fa-cart-plus me-2"></i>
                Thêm vào giỏ thuê
            </button>

            <a href="${pageContext.request.contextPath}/vehicle" class="btn-back">
                <i class="fa-solid fa-list me-2"></i>
                Xem danh sách xe
            </a>

            <div class="quick-tips">
                <div class="tip-item">
                    <i class="fa-solid fa-check-circle"></i>
                    <span>Kiểm tra thông tin xe và địa điểm nhận trước khi đặt.</span>
                </div>

                <div class="tip-item">
                    <i class="fa-solid fa-check-circle"></i>
                    <span>Giá thuê có thể thay đổi theo thời gian thuê và chính sách dịch vụ.</span>
                </div>

                <div class="tip-item">
                    <i class="fa-solid fa-check-circle"></i>
                    <span>Tiền đặt cọc được dùng để đảm bảo quá trình thuê xe.</span>
                </div>
            </div>
        </aside>
    </div>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>