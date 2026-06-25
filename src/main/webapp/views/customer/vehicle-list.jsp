<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Thuê xe</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Be Vietnam Pro", sans-serif;
            background: #f4f7fb;
            color: #0f172a;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .vehicle-page {
            width: min(1540px, calc(100% - 32px));
            margin: 0 auto;
            padding: 18px 0 50px;
        }

        /* ================= HERO IMAGE ================= */
        .vehicle-hero {
            position: relative;
            min-height: 400px;
            color: #fff;
            border-radius: 34px;
            padding: 46px 48px 88px;
            box-shadow: 0 28px 76px rgba(15, 23, 42, 0.22);
            overflow: hidden;
            background:
                    linear-gradient(
                            90deg,
                            rgba(2, 6, 23, 0.90) 0%,
                            rgba(2, 6, 23, 0.74) 38%,
                            rgba(2, 6, 23, 0.46) 68%,
                            rgba(2, 6, 23, 0.20) 100%
                    ),
                    url("${pageContext.request.contextPath}/assets/images/vehicle/vehicle.png");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .vehicle-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                    radial-gradient(circle at 18% 22%, rgba(255, 255, 255, 0.16), transparent 28%),
                    linear-gradient(to bottom, rgba(15, 23, 42, 0.04), rgba(15, 23, 42, 0.30));
            pointer-events: none;
        }

        .vehicle-hero::after {
            content: "";
            position: absolute;
            right: -90px;
            bottom: -120px;
            width: 360px;
            height: 360px;
            border-radius: 999px;
            background: rgba(37, 99, 235, 0.30);
            filter: blur(18px);
            pointer-events: none;
        }

        .vehicle-hero > * {
            position: relative;
            z-index: 2;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 11px 18px;
            border-radius: 999px;
            background: rgba(255,255,255,0.18);
            border: 1px solid rgba(255,255,255,0.30);
            font-weight: 900;
            font-size: 14px;
            margin-bottom: 18px;
            backdrop-filter: blur(14px);
            box-shadow: 0 14px 34px rgba(15, 23, 42, 0.22);
        }

        .hero-badge i {
            color: #facc15;
        }

        .vehicle-hero h1 {
            margin: 0 0 18px;
            font-size: clamp(34px, 4.2vw, 58px);
            line-height: 1.08;
            font-weight: 950;
            letter-spacing: -2px;
            max-width: 820px;
            color: #ffffff;
            text-shadow: 0 12px 34px rgba(0, 0, 0, 0.42);
        }

        .vehicle-hero p {
            margin: 0;
            max-width: 760px;
            font-size: 18px;
            line-height: 1.65;
            font-weight: 600;
            color: rgba(255,255,255,0.94);
            text-shadow: 0 5px 20px rgba(0, 0, 0, 0.34);
        }

        .hero-quick-info {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 26px;
        }

        .hero-info-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 11px 15px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.26);
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
            backdrop-filter: blur(12px);
        }

        .hero-info-pill i {
            color: #fde68a;
        }

        /* ================= SEARCH ================= */
        .search-panel {
            width: calc(100% - 96px);
            margin: -58px auto 28px;
            background: rgba(255, 255, 255, 0.97);
            border-radius: 32px;
            padding: 24px;
            position: relative;
            z-index: 10;
            box-shadow: 0 28px 76px rgba(15, 23, 42, 0.18);
            border: 1px solid rgba(226, 232, 240, 0.95);
            backdrop-filter: blur(18px);
        }

        .search-form {
            display: grid;
            grid-template-columns: 1.35fr 1fr 1fr 1fr 0.7fr auto;
            gap: 14px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 800;
            color: #334155;
        }

        .form-control {
            width: 100%;
            height: 52px;
            border-radius: 16px;
            border: 1px solid #dbe3f0;
            padding: 0 15px;
            font-size: 14px;
            font-family: inherit;
            color: #0f172a;
            outline: none;
            background: #fff;
            transition: 0.2s ease;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,0.10);
        }

        .search-btn {
            height: 52px;
            min-width: 132px;
            border: none;
            border-radius: 16px;
            background: #0f172a;
            color: #fff;
            font-weight: 900;
            font-size: 15px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            transition: 0.2s ease;
        }

        .search-btn:hover {
            background: #020617;
            transform: translateY(-1px);
            box-shadow: 0 14px 28px rgba(15, 23, 42, 0.16);
        }

        .section-head {
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 16px;
            margin: 10px 0 20px;
        }

        .section-head h2 {
            margin: 0 0 5px;
            font-size: clamp(28px, 3vw, 42px);
            font-weight: 900;
            color: #0f172a;
            letter-spacing: -0.8px;
        }

        .section-head p {
            margin: 0;
            color: #64748b;
            font-size: 16px;
            line-height: 1.6;
        }

        .result-badge {
            background: #fff;
            border: 1px solid #e2e8f0;
            padding: 11px 15px;
            border-radius: 16px;
            font-weight: 800;
            color: #334155;
            white-space: nowrap;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.05);
        }

        .result-badge i {
            color: #2563eb;
        }

        .vehicle-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(0, 1fr));
            gap: 18px;
        }

        .vehicle-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 22px;
            overflow: hidden;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.07);
            display: flex;
            flex-direction: column;
            min-height: 100%;
            transition: 0.22s ease;
        }

        .vehicle-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 42px rgba(15, 23, 42, 0.12);
        }

        .vehicle-image-box {
            height: 150px;
            position: relative;
            overflow: hidden;
            background: #e5e7eb;
        }

        .vehicle-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: 0.32s ease;
        }

        .vehicle-card:hover .vehicle-image-box img {
            transform: scale(1.06);
        }

        .vehicle-type-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: rgba(15, 23, 42, 0.90);
            color: #fff;
            padding: 7px 11px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            max-width: calc(100% - 24px);
        }

        .vehicle-status-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background: #22c55e;
            color: #fff;
            padding: 7px 11px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .vehicle-status-badge.maintenance {
            background: #f59e0b;
        }

        .vehicle-status-badge.unavailable {
            background: #ef4444;
        }

        .vehicle-body {
            padding: 15px 15px 14px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .vehicle-title {
            font-size: 17px;
            font-weight: 900;
            color: #0f172a;
            margin: 0 0 10px;
            line-height: 1.35;
            min-height: 46px;
        }

        .location-line {
            display: flex;
            align-items: flex-start;
            gap: 7px;
            color: #0891b2;
            font-weight: 800;
            font-size: 13px;
            margin-bottom: 4px;
        }

        .location-line i {
            margin-top: 2px;
        }

        .location-sub {
            color: #64748b;
            font-size: 12.5px;
            line-height: 1.45;
            margin: 0 0 10px 20px;
            min-height: 34px;
        }

        .spec-list {
            display: flex;
            flex-wrap: wrap;
            gap: 7px;
            margin-bottom: 10px;
        }

        .spec-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #eef2ff;
            color: #312e81;
            padding: 6px 8px;
            border-radius: 999px;
            font-size: 11.5px;
            font-weight: 850;
            max-width: 100%;
        }

        .vehicle-desc {
            color: #475569;
            font-size: 12.5px;
            line-height: 1.55;
            margin: 0 0 12px;
            min-height: 40px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .price-box {
            margin-top: auto;
            border-top: 1px solid #e2e8f0;
            padding-top: 12px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .price-highlight {
            background: linear-gradient(135deg, #fff7ed, #ffedd5);
            border: 1px solid #fed7aa;
            border-radius: 16px;
            padding: 10px 12px;
        }

        .price-label {
            display: block;
            color: #9a3412;
            font-size: 11.5px;
            font-weight: 850;
            margin-bottom: 2px;
        }

        .price-value {
            color: #ea580c;
            font-size: 20px;
            font-weight: 950;
            line-height: 1.1;
        }

        .price-unit {
            color: #9a3412;
            font-size: 12px;
            font-weight: 750;
            margin-left: 2px;
        }

        .detail-btn {
            width: 100%;
            height: 42px;
            border-radius: 14px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 13.5px;
            font-weight: 900;
            box-shadow: 0 10px 22px rgba(37, 99, 235, 0.20);
            transition: 0.2s ease;
        }

        .detail-btn:hover {
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 14px 26px rgba(37, 99, 235, 0.25);
        }

        .empty-box {
            background: #fff;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 48px 20px;
            text-align: center;
            color: #64748b;
        }

        .empty-box i {
            font-size: 42px;
            color: #94a3b8;
            margin-bottom: 12px;
        }

        .empty-box h3 {
            margin: 0 0 8px;
            color: #0f172a;
            font-size: 24px;
            font-weight: 900;
        }

        .empty-box p {
            margin: 0;
        }

        @media (max-width: 1500px) {
            .vehicle-grid {
                grid-template-columns: repeat(5, minmax(0, 1fr));
            }
        }

        @media (max-width: 1280px) {
            .vehicle-grid {
                grid-template-columns: repeat(4, minmax(0, 1fr));
            }

            .search-form {
                grid-template-columns: repeat(3, 1fr);
            }

            .search-btn {
                width: 100%;
            }
        }

        @media (max-width: 992px) {
            .vehicle-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .search-form {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .vehicle-page {
                width: calc(100% - 20px);
            }

            .vehicle-hero {
                min-height: 340px;
                padding: 30px 22px 78px;
                border-radius: 24px;
                background-position: center;
            }

            .vehicle-hero h1 {
                font-size: 36px;
                letter-spacing: -1px;
            }

            .vehicle-hero p {
                font-size: 16px;
            }

            .hero-quick-info {
                gap: 10px;
                margin-top: 24px;
            }

            .hero-info-pill {
                padding: 11px 14px;
                font-size: 13px;
            }

            .search-panel {
                width: calc(100% - 12px);
                margin: -48px auto 22px;
                padding: 16px;
                border-radius: 22px;
            }

            .search-form {
                grid-template-columns: 1fr;
            }

            .section-head {
                flex-direction: column;
                align-items: flex-start;
            }

            .vehicle-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
            }

            .vehicle-image-box {
                height: 135px;
            }
        }

        @media (max-width: 520px) {
            .vehicle-grid {
                grid-template-columns: 1fr;
            }

            .vehicle-image-box {
                height: 190px;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<div class="vehicle-page">

    <section class="vehicle-hero">
        <div class="hero-badge">
            <i class="fa-solid fa-car-side"></i>
            <span>WonderVN Vehicle Rental</span>
        </div>

        <h1>Thuê xe phù hợp cho hành trình của bạn</h1>

        <p>
            Tìm phương tiện theo tỉnh/thành, hãng xe, loại xe, số chỗ và địa điểm nhận xe.
            Giá thuê, đặt cọc và lưu ý sử dụng được hiển thị rõ ràng.
        </p>

        <div class="hero-quick-info">
            <div class="hero-info-pill">
                <i class="fa-solid fa-motorcycle"></i>
                <span>Xe máy, ô tô, SUV</span>
            </div>

            <div class="hero-info-pill">
                <i class="fa-solid fa-location-dot"></i>
                <span>Nhận xe theo địa điểm</span>
            </div>

            <div class="hero-info-pill">
                <i class="fa-solid fa-money-bill-wave"></i>
                <span>Giá thuê rõ ràng</span>
            </div>
        </div>
    </section>

    <div class="search-panel">
        <form class="search-form" action="${pageContext.request.contextPath}/vehicle" method="get">
            <div class="form-group">
                <label>Tìm kiếm</label>
                <input class="form-control"
                       type="text"
                       name="keyword"
                       value="${param.keyword}"
                       placeholder="VD: Honda, Lead, Hà Nội...">
            </div>

            <div class="form-group">
                <label>Tỉnh/thành</label>
                <input class="form-control"
                       type="text"
                       name="province"
                       value="${param.province}"
                       placeholder="VD: Hà Nội">
            </div>

            <div class="form-group">
                <label>Hãng xe</label>
                <select class="form-control" name="brandID">
                    <option value="">Tất cả</option>
                    <c:forEach var="brand" items="${brandList}">
                        <option value="${brand.brandID}" ${param.brandID == brand.brandID ? 'selected' : ''}>
                                ${brand.brandName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Loại xe</label>
                <select class="form-control" name="vehicleType">
                    <option value="">Tất cả</option>
                    <option value="Motorbike" ${param.vehicleType == 'Motorbike' ? 'selected' : ''}>Xe máy</option>
                    <option value="Sedan" ${param.vehicleType == 'Sedan' ? 'selected' : ''}>Sedan</option>
                    <option value="SUV" ${param.vehicleType == 'SUV' ? 'selected' : ''}>SUV</option>
                    <option value="Luxury Sedan" ${param.vehicleType == 'Luxury Sedan' ? 'selected' : ''}>Sedan hạng sang</option>
                    <option value="Bus" ${param.vehicleType == 'Bus' ? 'selected' : ''}>Xe khách</option>
                </select>
            </div>

            <div class="form-group">
                <label>Số chỗ</label>
                <input class="form-control"
                       type="number"
                       name="seatCount"
                       min="1"
                       value="${param.seatCount}"
                       placeholder="4">
            </div>

            <button class="search-btn" type="submit">
                <i class="fa-solid fa-magnifying-glass"></i>
                Tìm xe
            </button>
        </form>
    </div>

    <div class="section-head">
        <div>
            <h2>Danh sách xe cho thuê</h2>
            <p>Lựa chọn phương tiện phù hợp theo địa điểm nhận xe và nhu cầu di chuyển.</p>
        </div>

        <div class="result-badge">
            <i class="fa-solid fa-layer-group"></i>
            Tìm thấy <strong>${fn:length(vehicleList)}</strong> phương tiện
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty vehicleList}">
            <div class="vehicle-grid">
                <c:forEach var="v" items="${vehicleList}">
                    <article class="vehicle-card">

                        <div class="vehicle-image-box">
                            <img src="${empty v.image ? 'https://placehold.co/600x400?text=WonderVN+Vehicle' : v.image}"
                                 alt="${v.vehicleModel}"
                                 onerror="this.src='https://placehold.co/600x400?text=WonderVN+Vehicle';">

                            <div class="vehicle-type-badge">
                                <i class="fa-solid fa-car-side"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${v.vehicleType == 'Motorbike'}">Xe máy</c:when>
                                        <c:when test="${v.vehicleType == 'Luxury Sedan'}">Sedan hạng sang</c:when>
                                        <c:when test="${v.vehicleType == 'Bus'}">Xe khách</c:when>
                                        <c:otherwise>${v.vehicleType}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <c:choose>
                                <c:when test="${v.status == 'Available'}">
                                    <div class="vehicle-status-badge">
                                        <i class="fa-solid fa-check"></i>
                                        Có sẵn
                                    </div>
                                </c:when>
                                <c:when test="${v.status == 'Maintenance'}">
                                    <div class="vehicle-status-badge maintenance">
                                        <i class="fa-solid fa-screwdriver-wrench"></i>
                                        Bảo trì
                                    </div>
                                </c:when>
                                <c:when test="${v.status == 'Rented'}">
                                    <div class="vehicle-status-badge unavailable">
                                        <i class="fa-solid fa-key"></i>
                                        Đã thuê
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="vehicle-status-badge unavailable">
                                        <i class="fa-solid fa-xmark"></i>
                                        Tạm hết
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="vehicle-body">
                            <h3 class="vehicle-title">
                                    ${v.vehicleModel}
                            </h3>

                            <div class="location-line">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>${empty v.pickupProvince ? 'Chưa cập nhật' : v.pickupProvince}</span>
                            </div>

                            <p class="location-sub">
                                <c:choose>
                                    <c:when test="${not empty v.pickupDistrict || not empty v.pickupWard}">
                                        ${empty v.pickupDistrict ? 'Chưa cập nhật' : v.pickupDistrict},
                                        ${empty v.pickupWard ? 'Chưa cập nhật' : v.pickupWard}
                                    </c:when>
                                    <c:otherwise>
                                        ${empty v.pickupAddress ? 'Liên hệ nhân viên để xác nhận địa chỉ nhận xe' : v.pickupAddress}
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <div class="spec-list">
                                <span class="spec-pill">
                                    <i class="fa-solid fa-users"></i>
                                    ${v.seatCount} chỗ
                                </span>

                                <span class="spec-pill">
                                    <i class="fa-solid fa-gears"></i>
                                    <c:choose>
                                        <c:when test="${v.transmission == 'Automatic'}">Số tự động</c:when>
                                        <c:when test="${v.transmission == 'Manual'}">Số sàn</c:when>
                                        <c:otherwise>${v.transmission}</c:otherwise>
                                    </c:choose>
                                </span>

                                <span class="spec-pill">
                                    <i class="fa-solid fa-gas-pump"></i>
                                    <c:choose>
                                        <c:when test="${v.fuelType == 'Gasoline'}">Xăng</c:when>
                                        <c:when test="${v.fuelType == 'Diesel'}">Dầu</c:when>
                                        <c:when test="${v.fuelType == 'Electric'}">Điện</c:when>
                                        <c:when test="${v.fuelType == 'Hybrid'}">Hybrid</c:when>
                                        <c:otherwise>${v.fuelType}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <p class="vehicle-desc">
                                <c:choose>
                                    <c:when test="${not empty v.description}">
                                        ${v.description}
                                    </c:when>
                                    <c:otherwise>
                                        Phương tiện phù hợp cho nhu cầu di chuyển du lịch và công tác.
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <div class="price-box">
                                <div class="price-highlight">
                                    <span class="price-label">Giá thuê nổi bật</span>
                                    <span class="price-value">
                                        <fmt:formatNumber value="${v.pricePerDay}" pattern="#,##0"/>
                                        đ
                                    </span>
                                    <span class="price-unit">/ ngày</span>
                                </div>

                                <a class="detail-btn"
                                   href="${pageContext.request.contextPath}/vehicle/detail?id=${v.serviceID}">
                                    Xem chi tiết
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>

                    </article>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-box">
                <i class="fa-solid fa-car-side"></i>
                <h3>Không tìm thấy phương tiện phù hợp</h3>
                <p>Hãy thử thay đổi từ khóa, địa điểm, loại xe hoặc số chỗ để xem thêm kết quả.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/views/common/client-footer.jsp"/>

</body>
</html>
