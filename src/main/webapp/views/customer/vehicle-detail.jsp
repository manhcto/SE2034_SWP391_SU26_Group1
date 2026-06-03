<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết xe thuê</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            color: #0f172a;
        }

        .vehicle-detail-shell {
            max-width: 1220px;
            margin: 40px auto 72px;
            padding: 0 20px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #1d4ed8;
            text-decoration: none;
            font-weight: 900;
            margin-bottom: 18px;
        }

        .detail-card {
            background: white;
            border-radius: 32px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            box-shadow: 0 22px 50px rgba(15, 23, 42, 0.13);
            border: 1px solid #e2e8f0;
        }

        .detail-image {
            position: relative;
            min-height: 520px;
            background: #e2e8f0;
            overflow: hidden;
        }

        .detail-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .floating-badge {
            position: absolute;
            top: 24px;
            left: 24px;
            background: rgba(15, 23, 42, 0.92);
            color: white;
            padding: 11px 16px;
            border-radius: 16px;
            font-weight: 900;
        }

        .detail-content {
            padding: 36px;
        }

        .service-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #dbeafe;
            padding: 10px 14px;
            border-radius: 999px;
            font-weight: 900;
            margin-bottom: 16px;
        }

        .detail-content h1 {
            font-size: 44px;
            line-height: 1.15;
            font-weight: 900;
            margin: 0 0 12px;
        }

        .sub-info {
            color: #64748b;
            font-weight: 700;
            margin-bottom: 22px;
        }

        .sub-info i {
            color: #2563eb;
            margin-right: 7px;
        }

        .price-box {
            background: linear-gradient(135deg, #0f172a, #1d4ed8);
            color: white;
            border-radius: 24px;
            padding: 24px;
            margin: 22px 0;
        }

        .price-label {
            opacity: 0.85;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .price-value {
            font-size: 42px;
            font-weight: 900;
            line-height: 1;
        }

        .price-note {
            margin-top: 7px;
            color: #dbeafe;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 22px 0;
        }

        .info-item {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 16px;
        }

        .info-item small {
            display: block;
            color: #64748b;
            margin-bottom: 5px;
            font-weight: 800;
        }

        .info-item strong {
            color: #0f172a;
            font-size: 15px;
        }

        .feature-list {
            display: grid;
            gap: 10px;
            margin: 20px 0 26px;
        }

        .feature-list div {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #334155;
            font-weight: 700;
        }

        .feature-list i {
            color: #16a34a;
        }

        .action-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .rent-btn,
        .cart-btn-detail {
            border: none;
            border-radius: 18px;
            padding: 15px 18px;
            font-weight: 900;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
        }

        .rent-btn {
            background: #0f172a;
            color: white;
        }

        .cart-btn-detail {
            background: #e0f2fe;
            color: #075985;
        }

        .rent-btn:disabled,
        .cart-btn-detail.disabled {
            background: #cbd5e1;
            color: #64748b;
            cursor: not-allowed;
        }

        .suggestion-section {
            margin-top: 28px;
            background: white;
            border-radius: 28px;
            padding: 28px;
            box-shadow: 0 18px 42px rgba(15, 23, 42, 0.08);
        }

        .suggestion-section h2 {
            margin: 0 0 16px;
            font-weight: 900;
        }

        .suggestion-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .suggestion-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 18px;
        }

        .suggestion-box i {
            color: #2563eb;
            font-size: 22px;
            margin-bottom: 10px;
        }

        .suggestion-box h4 {
            margin: 0 0 6px;
            font-weight: 900;
        }

        .suggestion-box p {
            margin: 0;
            color: #64748b;
            line-height: 1.6;
            font-size: 14px;
        }

        @media (max-width: 992px) {
            .detail-card {
                grid-template-columns: 1fr;
            }

            .detail-image {
                min-height: 350px;
            }

            .suggestion-grid,
            .info-grid,
            .action-row {
                grid-template-columns: 1fr;
            }

            .detail-content h1 {
                font-size: 34px;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/WEB-INF/common/homepage/header.jsp" />

<section class="vehicle-detail-shell">
    <a class="back-link" href="${pageContext.request.contextPath}/vehicle">
        <i class="fa-solid fa-arrow-left"></i>
        Quay lại danh sách xe
    </a>

    <div class="detail-card">
        <div class="detail-image">
            <img src="${vehicle.image}"
                 alt="${vehicle.vehicleBrand}"
                 onerror="this.src='https://placehold.co/1100x760?text=WonderVN+Vehicle';">

            <div class="floating-badge">
                <i class="fa-solid fa-car-side"></i>
                ${vehicle.vehicleType}
            </div>
        </div>

        <div class="detail-content">
            <div class="service-chip">
                <i class="fa-solid fa-route"></i>
                ${vehicle.serviceDetails.fulfillmentType}
            </div>

            <h1>${vehicle.vehicleBrand}</h1>

            <div class="sub-info">
                <i class="fa-solid fa-id-card"></i>
                Biển số: ${vehicle.licensePlate}
            </div>

            <div class="price-box">
                <div class="price-label">Giá thuê</div>
                <div class="price-value">
                    <fmt:formatNumber value="${vehicle.pricePerDay}" type="number" maxFractionDigits="0"/> đ
                </div>
                <div class="price-note">mỗi ngày</div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <small>Trạng thái</small>
                    <c:choose>
                        <c:when test="${vehicle.status == 'Available'}">
                            <strong>Sẵn sàng cho thuê</strong>
                        </c:when>
                        <c:when test="${vehicle.status == 'Maintenance'}">
                            <strong>Đang bảo trì</strong>
                        </c:when>
                        <c:otherwise>
                            <strong>Tạm không khả dụng</strong>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-item">
                    <small>Mã dịch vụ</small>
                    <strong>#${vehicle.serviceID}</strong>
                </div>

                <div class="info-item">
                    <small>Loại dịch vụ</small>
                    <strong>${vehicle.serviceDetails.serviceType}</strong>
                </div>

                <div class="info-item">
                    <small>Tên dịch vụ</small>
                    <strong>${vehicle.serviceDetails.serviceName}</strong>
                </div>

                <div class="info-item">
                    <small>Số chỗ ngồi</small>
                    <strong>${vehicle.seatCount} chỗ</strong>
                </div>

                <div class="info-item">
                    <small>Loại xe</small>
                    <strong>${vehicle.vehicleType}</strong>
                </div>

                <div class="info-item">
                    <small>Hộp số</small>
                    <strong>${vehicle.transmission}</strong>
                </div>

                <div class="info-item">
                    <small>Nhiên liệu</small>
                    <strong>${vehicle.fuelType}</strong>
                </div>
            </div>

            <div class="feature-list">
                <div>
                    <i class="fa-solid fa-circle-check"></i>
                    Phù hợp di chuyển du lịch, công tác và đưa đón theo lịch trình.
                </div>

                <div>
                    <i class="fa-solid fa-circle-check"></i>
                    Giá thuê rõ ràng theo ngày, dễ tính chi phí trong giỏ hàng.
                </div>

                <div>
                    <i class="fa-solid fa-circle-check"></i>
                    Thông tin xe được đồng bộ trực tiếp từ hệ thống WonderVN.
                </div>
            </div>

            <c:choose>
                <c:when test="${vehicle.status == 'Available'}">
                    <div class="action-row">
                        <button class="rent-btn" type="button"
                                onclick="alert('Chức năng thuê xe sẽ được phát triển ở bước tiếp theo.');">
                            Thuê ngay
                        </button>

                        <button class="cart-btn-detail" type="button"
                                onclick="alert('Chức năng thêm xe vào giỏ hàng sẽ được phát triển ở bước tiếp theo.');">
                            Thêm vào giỏ hàng
                        </button>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="action-row">
                        <button class="rent-btn" type="button" disabled>
                            Tạm không khả dụng
                        </button>

                        <button class="cart-btn-detail disabled" type="button" disabled>
                            Không thể thêm vào giỏ
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="suggestion-section">
        <h2>Thông tin hỗ trợ thuê xe</h2>

        <div class="suggestion-grid">
            <div class="suggestion-box">
                <i class="fa-solid fa-calendar-days"></i>
                <h4>Thuê theo ngày</h4>
                <p>Phù hợp với khách cần xe trong nhiều ngày hoặc theo lịch trình du lịch cá nhân.</p>
            </div>

            <div class="suggestion-box">
                <i class="fa-solid fa-shield-halved"></i>
                <h4>An toàn & rõ ràng</h4>
                <p>Thông tin xe, biển số, giá thuê và trạng thái được kiểm soát từ hệ thống quản trị.</p>
            </div>

            <div class="suggestion-box">
                <i class="fa-solid fa-cart-shopping"></i>
                <h4>Sẵn sàng tích hợp giỏ hàng</h4>
                <p>Bước tiếp theo có thể chọn ngày thuê, số ngày thuê và thêm xe vào cart.</p>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/common/homepage/footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>