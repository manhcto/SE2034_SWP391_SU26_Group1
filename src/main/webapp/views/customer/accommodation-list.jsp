<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Khách sạn & Lưu trú</title>

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
            --border: #e2e8f0;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
            --shadow-hover: 0 22px 46px rgba(15, 23, 42, 0.14);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            font-size: 15px;
        }

        .accom-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 100%);
            color: white;
            padding: 54px 0 105px;
        }

        .hero-badge {
            display: inline-flex;
            gap: 8px;
            align-items: center;
            padding: 9px 15px;
            border-radius: 999px;
            background: rgba(255,255,255,0.14);
            border: 1px solid rgba(255,255,255,0.22);
            font-weight: 800;
            margin-bottom: 18px;
        }

        .accom-hero h1 {
            max-width: 780px;
            font-size: 40px;
            font-weight: 900;
            line-height: 1.18;
            letter-spacing: -0.6px;
            margin-bottom: 14px;
        }

        .accom-hero p {
            max-width: 780px;
            color: #dbeafe;
            font-size: 16px;
            line-height: 1.75;
            margin: 0;
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
            background: white;
            color: var(--dark);
            border: 1px solid #dbe3ef;
            text-decoration: none;
            font-weight: 800;
            box-shadow: var(--shadow);
            cursor: pointer;
        }

        .search-panel {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 24px;
            box-shadow: var(--shadow);
        }

        .form-label {
            font-size: 13px;
            font-weight: 800;
            color: #475569;
            margin-bottom: 7px;
        }

        .form-control,
        .form-select {
            height: 48px;
            border-radius: 14px;
            border: 1px solid #dbe3ef;
            font-size: 15px;
        }

        .btn-search {
            height: 48px;
            border: none;
            border-radius: 14px;
            background: var(--dark);
            color: white;
            font-weight: 800;
            width: 100%;
        }

        .btn-reset {
            height: 48px;
            border-radius: 14px;
            border: 1px solid #dbe3ef;
            background: white;
            color: #475569;
            font-weight: 800;
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .page-heading {
            margin: 44px 0 22px;
        }

        .page-heading h2 {
            font-size: 30px;
            font-weight: 900;
            color: var(--dark);
            margin-bottom: 6px;
        }

        .page-heading p {
            color: var(--muted);
            margin: 0;
        }

        .accom-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow: hidden;
            height: 100%;
            box-shadow: var(--shadow);
            transition: 0.22s ease;
        }

        .accom-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
        }

        .accom-img-box {
            height: 230px;
            position: relative;
            overflow: hidden;
            background: #e2e8f0;
        }

        .accom-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.35s ease;
        }

        .accom-card:hover .accom-img-box img {
            transform: scale(1.05);
        }

        .type-badge,
        .rating-badge {
            position: absolute;
            top: 16px;
            border-radius: 999px;
            padding: 7px 12px;
            font-size: 12.5px;
            font-weight: 800;
            display: inline-flex;
            gap: 7px;
            align-items: center;
        }

        .type-badge {
            left: 16px;
            background: rgba(15, 23, 42, 0.9);
            color: white;
        }

        .rating-badge {
            right: 16px;
            background: #facc15;
            color: #713f12;
        }

        .accom-body {
            padding: 21px;
        }

        .accom-name {
            font-size: 21px;
            font-weight: 900;
            color: var(--dark);
            line-height: 1.3;
            min-height: 54px;
            margin-bottom: 10px;
        }

        .location {
            display: flex;
            gap: 9px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.55;
            margin-bottom: 14px;
        }

        .location i {
            color: #06b6d4;
            margin-top: 3px;
        }

        .facility-row {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 14px 0 16px;
        }

        .facility-pill {
            background: #ecfeff;
            color: #155e75;
            border-radius: 999px;
            padding: 7px 10px;
            font-size: 12.5px;
            font-weight: 800;
        }

        .desc {
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
            font-weight: 900;
            color: var(--dark);
            line-height: 1.1;
        }

        .price-unit {
            font-size: 13px;
            color: var(--muted);
            margin-top: 3px;
        }

        .btn-detail {
            background: var(--primary);
            color: white;
            border-radius: 14px;
            text-decoration: none;
            padding: 10px 14px;
            font-weight: 800;
            font-size: 14px;
            white-space: nowrap;
        }

        .empty-state {
            background: white;
            border-radius: 24px;
            border: 1px solid var(--border);
            padding: 56px 20px;
            text-align: center;
            box-shadow: var(--shadow);
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<section class="accom-hero">
    <div class="container">
        <div class="hero-badge">
            <i class="fa-solid fa-hotel"></i>
            WonderVN Accommodation
        </div>

        <h1>Tìm nơi lưu trú phù hợp cho hành trình của bạn</h1>

        <p>
            Khám phá khách sạn, homestay, resort và căn hộ dịch vụ với thông tin phòng,
            tiện ích, giá và vị trí rõ ràng.
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

    <form class="search-panel" action="${pageContext.request.contextPath}/accommodation" method="get">
        <div class="row g-3 align-items-end">
            <div class="col-xl-3 col-lg-4 col-md-6">
                <label class="form-label">Tìm kiếm</label>
                <input class="form-control" name="keyword" value="${keyword}"
                       placeholder="VD: Hà Nội, resort, gần biển...">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Tỉnh/thành</label>
                <input class="form-control" name="province" value="${selectedProvince}" placeholder="VD: Hà Nội">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Quận/huyện</label>
                <input class="form-control" name="district" value="${selectedDistrict}" placeholder="VD: Hoàn Kiếm">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Loại lưu trú</label>
                <select class="form-select" name="type">
                    <option value="">Tất cả</option>
                    <option value="Hotel" ${selectedType == 'Hotel' ? 'selected' : ''}>Khách sạn</option>
                    <option value="Homestay" ${selectedType == 'Homestay' ? 'selected' : ''}>Homestay</option>
                    <option value="Resort" ${selectedType == 'Resort' ? 'selected' : ''}>Resort</option>
                    <option value="Apartment" ${selectedType == 'Apartment' ? 'selected' : ''}>Căn hộ</option>
                    <option value="Villa" ${selectedType == 'Villa' ? 'selected' : ''}>Villa</option>
                </select>
            </div>

            <div class="col-xl-1 col-lg-4 col-md-6">
                <label class="form-label">Khách</label>
                <input class="form-control" type="number" min="1" name="guests" value="${selectedGuests}" placeholder="2">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Giá từ</label>
                <input class="form-control" type="number" min="0" step="1000" name="minPrice" value="${selectedMinPrice}">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Giá đến</label>
                <input class="form-control" type="number" min="0" step="1000" name="maxPrice" value="${selectedMaxPrice}">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label">Đánh giá từ</label>
                <input class="form-control" type="number" min="0" max="5" step="0.1" name="minRate" value="${selectedMinRate}">
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label d-none d-md-block">&nbsp;</label>
                <button class="btn-search" type="submit">
                    <i class="fa-solid fa-magnifying-glass me-2"></i>Tìm kiếm
                </button>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <label class="form-label d-none d-md-block">&nbsp;</label>
                <a class="btn-reset" href="${pageContext.request.contextPath}/accommodation">
                    <i class="fa-solid fa-rotate-left me-2"></i>Xóa lọc
                </a>
            </div>
        </div>
    </form>

    <div class="page-heading">
        <h2>Danh sách lưu trú</h2>
        <p>Lựa chọn nơi nghỉ phù hợp trước khi tiếp tục đặt dịch vụ.</p>
    </div>

    <c:choose>
        <c:when test="${empty accommodationList}">
            <div class="empty-state mb-5">
                <i class="fa-solid fa-hotel fa-4x text-secondary opacity-50 mb-4"></i>
                <h4 class="fw-bold">Không tìm thấy nơi lưu trú phù hợp</h4>
                <p class="text-muted mb-0">Hãy thử thay đổi khu vực, loại lưu trú hoặc khoảng giá.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row g-4 mb-5">
                <c:forEach var="a" items="${accommodationList}">
                    <div class="col-xl-4 col-lg-6">
                        <div class="accom-card">
                            <div class="accom-img-box">
                                <img src="${a.image}" alt="${a.name}"
                                     onerror="this.src='https://placehold.co/900x600?text=WonderVN+Accommodation';">

                                <div class="type-badge">
                                    <i class="fa-solid fa-hotel"></i>${a.displayType}
                                </div>

                                <div class="rating-badge">
                                    <i class="fa-solid fa-star"></i>${a.rate}
                                </div>
                            </div>

                            <div class="accom-body">
                                <div class="accom-name">${a.name}</div>

                                <div class="location">
                                    <i class="fa-solid fa-location-dot"></i>
                                    <div>
                                        <strong>${a.province}</strong><br>
                                            ${a.district}
                                        <c:if test="${not empty a.ward}">, ${a.ward}</c:if>
                                    </div>
                                </div>

                                <div class="facility-row">
                                    <c:forEach var="f" items="${a.facilityList}" varStatus="st">
                                        <c:if test="${st.index < 3}">
                                            <span class="facility-pill">${f.icon} ${f.facilityName}</span>
                                        </c:if>
                                    </c:forEach>
                                </div>

                                <div class="desc">
                                    <c:choose>
                                        <c:when test="${not empty a.description}">
                                            ${a.description}
                                        </c:when>
                                        <c:otherwise>
                                            Nơi lưu trú phù hợp cho du lịch, công tác và kỳ nghỉ cùng gia đình.
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="bottom-row">
                                    <div>
                                        <div class="price">
                                            <fmt:formatNumber value="${a.minRoomPrice}" type="number" maxFractionDigits="0"/> đ
                                        </div>
                                        <div class="price-unit">từ / đêm</div>
                                    </div>

                                    <a class="btn-detail"
                                       href="${pageContext.request.contextPath}/accommodation/detail?id=${a.serviceID}">
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