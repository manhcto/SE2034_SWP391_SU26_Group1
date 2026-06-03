<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Thuê xe du lịch</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            color: #0f172a;
        }

        .vehicle-hero {
            background:
                    radial-gradient(circle at top right, rgba(255, 255, 255, 0.14), transparent 25%),
                    linear-gradient(135deg, #0f172a, #2563eb);
            color: white;
            padding: 72px 0 120px;
        }

        .vehicle-container {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .vehicle-breadcrumb {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.18);
            font-weight: 800;
            margin-bottom: 18px;
        }

        .vehicle-hero h1 {
            font-size: 56px;
            line-height: 1.1;
            margin: 0 0 16px;
            max-width: 820px;
            font-weight: 900;
        }

        .vehicle-hero p {
            font-size: 18px;
            line-height: 1.8;
            color: #dbeafe;
            max-width: 780px;
            margin: 0;
        }

        .vehicle-search-wrap {
            max-width: 1240px;
            margin: -56px auto 40px;
            padding: 0 20px;
            position: relative;
            z-index: 5;
        }

        .vehicle-search {
            background: white;
            border-radius: 28px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.16);
            padding: 24px;
            display: grid;
            grid-template-columns: 1.4fr 0.7fr auto;
            gap: 16px;
            align-items: end;
        }

        .search-group label {
            display: block;
            font-weight: 900;
            margin-bottom: 8px;
            color: #1e293b;
        }

        .search-group input,
        .search-group select {
            width: 100%;
            border: 1px solid #dbe4f0;
            border-radius: 16px;
            padding: 15px 16px;
            font-size: 15px;
            outline: none;
            background: white;
        }

        .search-group input:focus,
        .search-group select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.11);
        }

        .search-btn {
            border: none;
            border-radius: 16px;
            background: #0f172a;
            color: white;
            padding: 15px 24px;
            font-weight: 900;
            font-size: 16px;
            min-width: 160px;
            height: 54px;
        }

        .vehicle-section {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 20px 75px;
        }

        .section-head {
            margin-bottom: 26px;
        }

        .section-head h2 {
            font-size: 44px;
            margin: 0 0 10px;
            font-weight: 900;
        }

        .section-head p {
            margin: 0;
            color: #64748b;
            font-size: 18px;
        }

        .vehicle-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 26px;
        }

        .vehicle-card {
            background: white;
            border-radius: 28px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.10);
            transition: all 0.25s ease;
        }

        .vehicle-card:hover {
            transform: translateY(-7px);
            box-shadow: 0 26px 54px rgba(15, 23, 42, 0.16);
        }

        .vehicle-image {
            position: relative;
            height: 245px;
            overflow: hidden;
            background: #e2e8f0;
        }

        .vehicle-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .vehicle-type-badge {
            position: absolute;
            top: 16px;
            left: 16px;
            background: #0f172a;
            color: white;
            padding: 9px 13px;
            border-radius: 13px;
            font-weight: 900;
            font-size: 13px;
        }

        .vehicle-status {
            position: absolute;
            top: 16px;
            right: 16px;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 9px 13px;
            border-radius: 13px;
            font-weight: 900;
            font-size: 13px;
        }

        .vehicle-status.available {
            background: #22c55e;
            color: white;
        }

        .vehicle-status.maintenance {
            background: #f59e0b;
            color: white;
        }

        .vehicle-status.unavailable {
            background: #ef4444;
            color: white;
        }

        .vehicle-body {
            padding: 24px;
        }

        .vehicle-body h3 {
            margin: 0 0 10px;
            font-size: 24px;
            line-height: 1.35;
            font-weight: 900;
        }

        .vehicle-plate {
            color: #64748b;
            margin-bottom: 16px;
            font-size: 15px;
            font-weight: 700;
        }

        .vehicle-plate i {
            color: #2563eb;
            margin-right: 7px;
        }

        .vehicle-features {
            display: flex;
            flex-wrap: wrap;
            gap: 9px;
            margin-bottom: 18px;
        }

        .vehicle-features span {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #dbeafe;
            padding: 8px 10px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 800;
        }

        .vehicle-price-row {
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 16px;
            padding-top: 16px;
            border-top: 1px solid #e2e8f0;
        }

        .vehicle-price {
            font-size: 30px;
            font-weight: 900;
            color: #0f172a;
            line-height: 1;
        }

        .vehicle-note {
            color: #64748b;
            font-size: 13px;
            margin-top: 4px;
        }

        .detail-btn {
            background: linear-gradient(135deg, #0f172a, #1d4ed8);
            color: white;
            text-decoration: none;
            padding: 13px 15px;
            border-radius: 14px;
            font-weight: 900;
            white-space: nowrap;
            transition: all 0.2s ease;
        }

        .detail-btn:hover {
            color: white;
            opacity: 0.95;
            transform: translateY(-2px);
        }

        .empty-box {
            background: white;
            border-radius: 26px;
            padding: 64px 22px;
            text-align: center;
            box-shadow: 0 18px 42px rgba(15, 23, 42, 0.08);
        }

        .empty-box i {
            font-size: 50px;
            color: #94a3b8;
            margin-bottom: 16px;
        }

        @media (max-width: 1100px) {
            .vehicle-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 720px) {
            .vehicle-search,
            .vehicle-grid {
                grid-template-columns: 1fr;
            }

            .vehicle-hero h1 {
                font-size: 40px;
            }

            .section-head h2 {
                font-size: 34px;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/WEB-INF/common/homepage/header.jsp" />

<section class="vehicle-hero">
    <div class="vehicle-container">
        <div class="vehicle-breadcrumb">
            <i class="fa-solid fa-car-side"></i>
            WonderVN Vehicle Rental
        </div>

        <h1>Thuê xe linh hoạt cho mọi hành trình</h1>

        <p>
            Lựa chọn phương tiện phù hợp để di chuyển trong chuyến đi. Xem ảnh xe, số chỗ ngồi,
            loại xe, hộp số, nhiên liệu và giá thuê mỗi ngày.
        </p>
    </div>
</section>

<section class="vehicle-search-wrap">
    <form class="vehicle-search" action="${pageContext.request.contextPath}/vehicle" method="get">
        <div class="search-group">
            <label>Tìm theo hãng xe, biển số, loại xe</label>
            <input type="text"
                   name="keyword"
                   value="${keyword}"
                   placeholder="VD: Honda, Sedan, Automatic, 29K1-9123...">
        </div>

        <div class="search-group">
            <label>Loại xe</label>
            <select name="type">
                <option value="all" <c:if test="${empty selectedType || selectedType == 'all'}">selected</c:if>>Tất cả</option>
                <option value="Sedan" <c:if test="${selectedType == 'Sedan'}">selected</c:if>>Sedan</option>
                <option value="SUV" <c:if test="${selectedType == 'SUV'}">selected</c:if>>SUV</option>
                <option value="Luxury Sedan" <c:if test="${selectedType == 'Luxury Sedan'}">selected</c:if>>Luxury Sedan</option>
                <option value="Motorbike" <c:if test="${selectedType == 'Motorbike'}">selected</c:if>>Motorbike</option>
                <option value="Bus" <c:if test="${selectedType == 'Bus'}">selected</c:if>>Bus</option>
                <option value="Limousine" <c:if test="${selectedType == 'Limousine'}">selected</c:if>>Limousine</option>
            </select>
        </div>

        <button class="search-btn" type="submit">
            <i class="fa-solid fa-magnifying-glass"></i>
            Tìm kiếm
        </button>
    </form>
</section>

<section class="vehicle-section">
    <div class="section-head">
        <h2>Danh sách xe thuê</h2>
        <p>Chọn phương tiện phù hợp trước khi tiếp tục đặt dịch vụ.</p>
    </div>

    <c:choose>
        <c:when test="${empty vehicleList}">
            <div class="empty-box">
                <i class="fa-solid fa-car-burst"></i>
                <h3>Chưa tìm thấy phương tiện phù hợp</h3>
                <p>Hãy thử thay đổi từ khóa tìm kiếm hoặc quay lại sau.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="vehicle-grid">
                <c:forEach var="v" items="${vehicleList}">
                    <article class="vehicle-card">
                        <div class="vehicle-image">
                            <img src="${v.image}"
                                 alt="${v.vehicleBrand}"
                                 onerror="this.src='https://placehold.co/900x600?text=WonderVN+Vehicle';">

                            <div class="vehicle-type-badge">
                                <i class="fa-solid fa-car"></i>
                                    ${v.vehicleType}
                            </div>

                            <c:choose>
                                <c:when test="${v.status == 'Available'}">
                                    <div class="vehicle-status available">
                                        <i class="fa-solid fa-circle-check"></i>
                                        Còn xe
                                    </div>
                                </c:when>

                                <c:when test="${v.status == 'Maintenance'}">
                                    <div class="vehicle-status maintenance">
                                        <i class="fa-solid fa-screwdriver-wrench"></i>
                                        Bảo trì
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="vehicle-status unavailable">
                                        <i class="fa-solid fa-circle-xmark"></i>
                                        Tạm ngưng
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="vehicle-body">
                            <h3>${v.vehicleBrand}</h3>

                            <div class="vehicle-plate">
                                <i class="fa-solid fa-id-card"></i>
                                Biển số: ${v.licensePlate}
                            </div>

                            <div class="vehicle-features">
                                <span><i class="fa-solid fa-user-group"></i> ${v.seatCount} chỗ</span>
                                <span><i class="fa-solid fa-car"></i> ${v.vehicleType}</span>
                                <span><i class="fa-solid fa-gears"></i> ${v.transmission}</span>
                                <span><i class="fa-solid fa-gas-pump"></i> ${v.fuelType}</span>
                            </div>

                            <div class="vehicle-price-row">
                                <div>
                                    <div class="vehicle-price">
                                        <fmt:formatNumber value="${v.pricePerDay}" type="number" maxFractionDigits="0"/> đ
                                    </div>
                                    <div class="vehicle-note">mỗi ngày</div>
                                </div>

                                <a class="detail-btn"
                                   href="${pageContext.request.contextPath}/vehicle/detail?id=${v.serviceID}">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<jsp:include page="/WEB-INF/common/homepage/footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>