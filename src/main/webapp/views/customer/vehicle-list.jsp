<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Thuê xe du lịch</title>

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
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
            --shadow-hover: 0 22px 46px rgba(15, 23, 42, 0.14);
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

        .vehicle-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 100%);
            color: #ffffff;
            padding: 54px 0 105px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 15px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.22);
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 18px;
        }

        .vehicle-hero h1 {
            max-width: 760px;
            font-size: 40px;
            line-height: 1.18;
            font-weight: 800;
            letter-spacing: -0.6px;
            margin: 0 0 14px;
        }

        .vehicle-hero p {
            max-width: 760px;
            color: #dbeafe;
            font-size: 16px;
            line-height: 1.75;
            margin: 0;
            font-weight: 400;
        }

        .content-wrap {
            margin-top: -62px;
            position: relative;
            z-index: 5;
        }

        .back-toolbar {
            margin-bottom: 16px;
        }

        .btn-back-page {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 11px 18px;
            border-radius: 999px;
            background: #ffffff;
            color: #0f172a;
            border: 1px solid #dbe3ef;
            text-decoration: none;
            font-weight: 800;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
            cursor: pointer;
        }

        .btn-back-page:hover {
            background: #f8fafc;
            color: var(--primary);
        }

        .search-panel {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 24px;
            box-shadow: var(--shadow);
        }

        .form-label {
            font-size: 13px;
            font-weight: 700;
            color: #475569;
            margin-bottom: 7px;
        }

        .form-control,
        .form-select {
            height: 48px;
            border-radius: 14px;
            border: 1px solid #dbe3ef;
            padding: 10px 14px;
            font-size: 15px;
            color: var(--text);
            box-shadow: none;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .btn-search {
            height: 48px;
            border: none;
            border-radius: 14px;
            background: var(--dark);
            color: #ffffff;
            font-weight: 700;
            width: 100%;
        }

        .btn-search:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .btn-reset-search {
            height: 48px;
            border-radius: 14px;
            border: 1px solid #dbe3ef;
            background: #ffffff;
            color: #475569;
            font-weight: 800;
            width: 100%;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-reset-search:hover {
            background: #f8fafc;
            color: #0f172a;
        }

        .page-heading {
            margin: 44px 0 22px;
        }

        .page-heading h2 {
            font-size: 30px;
            line-height: 1.25;
            font-weight: 800;
            letter-spacing: -0.4px;
            margin: 0 0 6px;
            color: var(--dark);
        }

        .page-heading p {
            color: var(--muted);
            margin: 0;
            font-size: 15px;
        }

        .vehicle-card {
            height: 100%;
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: 0.22s ease;
        }

        .vehicle-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
        }

        .vehicle-img-box {
            height: 220px;
            position: relative;
            overflow: hidden;
            background: #e2e8f0;
        }

        .vehicle-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: 0.35s ease;
        }

        .vehicle-card:hover .vehicle-img-box img {
            transform: scale(1.05);
        }

        .type-badge,
        .available-badge {
            position: absolute;
            top: 16px;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            border-radius: 999px;
            padding: 7px 12px;
            font-size: 12.5px;
            font-weight: 700;
            backdrop-filter: blur(8px);
        }

        .type-badge {
            left: 16px;
            background: rgba(15, 23, 42, 0.9);
            color: #ffffff;
        }

        .available-badge {
            right: 16px;
            background: #22c55e;
            color: #ffffff;
        }

        .vehicle-body {
            padding: 21px;
        }

        .vehicle-name {
            font-size: 21px;
            font-weight: 800;
            line-height: 1.3;
            margin-bottom: 10px;
            color: var(--dark);
            min-height: 54px;
            letter-spacing: -0.2px;
        }

        .vehicle-location {
            display: flex;
            align-items: flex-start;
            gap: 9px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.55;
            margin-bottom: 14px;
        }

        .vehicle-location i {
            color: #06b6d4;
            margin-top: 3px;
        }

        .vehicle-location strong {
            color: #334155;
            font-weight: 700;
        }

        .spec-row {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 14px 0 16px;
        }

        .spec-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #eef2ff;
            color: #3730a3;
            border-radius: 999px;
            padding: 7px 10px;
            font-size: 12.5px;
            font-weight: 700;
        }

        .vehicle-desc {
            color: #475569;
            line-height: 1.65;
            font-size: 14.5px;
            min-height: 72px;
            margin-bottom: 16px;
        }

        .bottom-row {
            border-top: 1px solid var(--border);
            padding-top: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
        }

        .price {
            font-size: 22px;
            font-weight: 800;
            color: var(--dark);
            line-height: 1.1;
            letter-spacing: -0.2px;
        }

        .price-unit {
            font-size: 13px;
            color: var(--muted);
            margin-top: 3px;
        }

        .btn-detail {
            background: var(--primary);
            color: #ffffff;
            border-radius: 14px;
            text-decoration: none;
            padding: 10px 14px;
            font-weight: 700;
            font-size: 14px;
            white-space: nowrap;
        }

        .btn-detail:hover {
            background: var(--primary-dark);
            color: #ffffff;
        }

        .empty-state {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 56px 20px;
            text-align: center;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.06);
        }

        @media (max-width: 768px) {
            .vehicle-hero h1 {
                font-size: 32px;
            }

            .vehicle-img-box {
                height: 210px;
            }

            .bottom-row {
                align-items: flex-start;
                flex-direction: column;
            }

            .btn-detail {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<section class="vehicle-hero">
    <div class="container">
        <div class="hero-badge">
            <i class="fa-solid fa-car-side"></i>
            WonderVN Vehicle Rental
        </div>

        <h1>Thuê xe phù hợp cho hành trình của bạn</h1>

        <p>
            Tìm kiếm phương tiện theo tỉnh/thành, hãng xe, loại xe và số chỗ.
            Mỗi xe đều có thông tin địa điểm nhận, giá thuê, đặt cọc và lưu ý sử dụng rõ ràng.
        </p>
    </div>
</section>

<div class="container content-wrap">
    <div class="back-toolbar">
        <button type="button" class="btn-back-page" onclick="history.back()">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại trang trước
        </button>
    </div>

    <form class="search-panel" action="${pageContext.request.contextPath}/vehicle" method="get">
        <div class="row g-3 align-items-end">
            <div class="col-xl-3 col-lg-4 col-md-6">
                <label class="form-label">Tìm kiếm</label>
                <input type="text"
                       name="keyword"
                       value="${keyword}"
                       class="form-control"
                       placeholder="VD: Honda, Lead, biển số, địa chỉ...">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Tỉnh/thành</label>
                <input type="text"
                       name="province"
                       value="${selectedProvince}"
                       class="form-control"
                       placeholder="VD: Hà Nội">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Quận/huyện</label>
                <input type="text"
                       name="district"
                       value="${selectedDistrict}"
                       class="form-control"
                       placeholder="VD: Hoàn Kiếm">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Hãng xe</label>
                <select name="brandID" class="form-select">
                    <option value="">Tất cả</option>
                    <c:forEach var="b" items="${brandList}">
                        <option value="${b.brandID}"
                                <c:if test="${selectedBrandID == b.brandID}">selected</c:if>>
                                ${b.brandName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Loại xe</label>
                <select name="vehicleType" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="Motorbike" <c:if test="${selectedVehicleType == 'Motorbike'}">selected</c:if>>Xe máy</option>
                    <option value="Sedan" <c:if test="${selectedVehicleType == 'Sedan'}">selected</c:if>>Sedan</option>
                    <option value="SUV" <c:if test="${selectedVehicleType == 'SUV'}">selected</c:if>>SUV</option>
                    <option value="Luxury Sedan" <c:if test="${selectedVehicleType == 'Luxury Sedan'}">selected</c:if>>Sedan hạng sang</option>
                    <option value="Bus" <c:if test="${selectedVehicleType == 'Bus'}">selected</c:if>>Xe khách</option>
                    <option value="Limousine" <c:if test="${selectedVehicleType == 'Limousine'}">selected</c:if>>Limousine</option>
                </select>
            </div>

            <div class="col-xl-1 col-lg-4 col-md-6">
                <label class="form-label">Số chỗ</label>
                <input type="number"
                       name="seatCount"
                       value="${selectedSeatCount}"
                       min="1"
                       class="form-control"
                       placeholder="4">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Hộp số</label>
                <select name="transmission" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="Automatic" <c:if test="${selectedTransmission == 'Automatic'}">selected</c:if>>Số tự động</option>
                    <option value="Manual" <c:if test="${selectedTransmission == 'Manual'}">selected</c:if>>Số sàn</option>
                </select>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Nhiên liệu</label>
                <select name="fuelType" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="Gasoline" <c:if test="${selectedFuelType == 'Gasoline'}">selected</c:if>>Xăng</option>
                    <option value="Diesel" <c:if test="${selectedFuelType == 'Diesel'}">selected</c:if>>Dầu Diesel</option>
                    <option value="Electric" <c:if test="${selectedFuelType == 'Electric'}">selected</c:if>>Điện</option>
                    <option value="Hybrid" <c:if test="${selectedFuelType == 'Hybrid'}">selected</c:if>>Hybrid</option>
                </select>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Giá từ</label>
                <input type="number"
                       name="minPrice"
                       value="${selectedMinPrice}"
                       min="0"
                       step="1000"
                       class="form-control"
                       placeholder="VD: 200000">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Giá đến</label>
                <input type="number"
                       name="maxPrice"
                       value="${selectedMaxPrice}"
                       min="0"
                       step="1000"
                       class="form-control"
                       placeholder="VD: 1000000">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label d-none d-md-block">&nbsp;</label>
                <button class="btn btn-search" type="submit">
                    <i class="fa-solid fa-magnifying-glass me-2"></i>
                    Tìm xe
                </button>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label d-none d-md-block">&nbsp;</label>
                <a href="${pageContext.request.contextPath}/vehicle" class="btn-reset-search">
                    <i class="fa-solid fa-rotate-left me-2"></i>
                    Xóa lọc
                </a>
            </div>
        </div>
    </form>

    <div class="page-heading">
        <h2>Danh sách xe cho thuê</h2>
        <p>Lựa chọn phương tiện phù hợp theo địa điểm nhận xe và nhu cầu di chuyển.</p>
    </div>

    <c:choose>
        <c:when test="${empty vehicleList}">
            <div class="empty-state mb-5">
                <i class="fa-solid fa-car-burst fa-4x text-secondary opacity-50 mb-4"></i>
                <h4 class="fw-bold">Không tìm thấy phương tiện phù hợp</h4>
                <p class="text-muted mb-0">Hãy thử thay đổi tỉnh/thành, hãng xe hoặc loại xe.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row g-4 mb-5">
                <c:forEach var="v" items="${vehicleList}">
                    <div class="col-xl-4 col-lg-6">
                        <div class="vehicle-card">
                            <div class="vehicle-img-box">
                                <img src="${v.image}"
                                     alt="${v.displayName}"
                                     onerror="this.src='https://placehold.co/900x600?text=WonderVN+Vehicle';">

                                <div class="type-badge">
                                    <i class="fa-solid fa-car-side"></i>
                                    <c:choose>
                                        <c:when test="${v.vehicleType == 'Motorbike'}">Xe máy</c:when>
                                        <c:when test="${v.vehicleType == 'Luxury Sedan'}">Sedan hạng sang</c:when>
                                        <c:when test="${v.vehicleType == 'Bus'}">Xe khách</c:when>
                                        <c:otherwise>${v.vehicleType}</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="available-badge">
                                    <i class="fa-solid fa-check"></i>
                                    Có sẵn
                                </div>
                            </div>

                            <div class="vehicle-body">
                                <div class="vehicle-name">${v.displayName}</div>

                                <div class="vehicle-location">
                                    <i class="fa-solid fa-location-dot"></i>
                                    <div>
                                        <strong>${v.pickupProvince}</strong><br>
                                        <span>
                                            ${v.pickupDistrict}
                                            <c:if test="${not empty v.pickupWard}">
                                                , ${v.pickupWard}
                                            </c:if>
                                        </span>
                                    </div>
                                </div>

                                <div class="spec-row">
                                    <span class="spec-pill">
                                        <i class="fa-solid fa-users"></i>
                                        ${v.seatCount} chỗ
                                    </span>

                                    <span class="spec-pill">
                                        <i class="fa-solid fa-gears"></i>
                                        <c:choose>
                                            <c:when test="${v.transmission == 'Automatic'}">Số tự động</c:when>
                                            <c:otherwise>Số sàn</c:otherwise>
                                        </c:choose>
                                    </span>

                                    <span class="spec-pill">
                                        <i class="fa-solid fa-gas-pump"></i>
                                        <c:choose>
                                            <c:when test="${v.fuelType == 'Gasoline'}">Xăng</c:when>
                                            <c:when test="${v.fuelType == 'Diesel'}">Dầu Diesel</c:when>
                                            <c:when test="${v.fuelType == 'Electric'}">Điện</c:when>
                                            <c:otherwise>Hybrid</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="vehicle-desc">
                                    <c:choose>
                                        <c:when test="${not empty v.description}">
                                            ${v.description}
                                        </c:when>
                                        <c:otherwise>
                                            Phương tiện phù hợp cho nhu cầu di chuyển du lịch và công tác.
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="bottom-row">
                                    <div>
                                        <div class="price">
                                            <fmt:formatNumber value="${v.pricePerDay}" type="number" maxFractionDigits="0"/> đ
                                        </div>
                                        <div class="price-unit">mỗi ngày</div>
                                    </div>

                                    <a class="btn-detail"
                                       href="${pageContext.request.contextPath}/vehicle/detail?id=${v.serviceID}">
                                        Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>