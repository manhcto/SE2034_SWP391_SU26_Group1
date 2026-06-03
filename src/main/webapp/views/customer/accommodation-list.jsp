<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Khách sạn & Lưu trú</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            color: #0f172a;
        }

        .page-top-space {
            height: 24px;
        }

        .acc-hero {
            background:
                    radial-gradient(circle at top right, rgba(255,255,255,0.10), transparent 20%),
                    linear-gradient(135deg, #081a4b, #2563eb);
            color: white;
            padding: 64px 0 120px;
        }

        .acc-container {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .acc-breadcrumb {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.16);
            font-weight: 700;
            margin-bottom: 18px;
        }

        .acc-hero h1 {
            font-size: 56px;
            line-height: 1.1;
            margin: 0 0 16px;
            max-width: 780px;
            font-weight: 800;
        }

        .acc-hero p {
            font-size: 18px;
            line-height: 1.8;
            color: #dbeafe;
            max-width: 760px;
            margin: 0;
        }

        .search-wrap {
            max-width: 1240px;
            margin: -56px auto 40px;
            padding: 0 20px;
            position: relative;
            z-index: 5;
        }

        .search-box {
            background: #fff;
            border-radius: 28px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.16);
            padding: 24px;
            display: grid;
            grid-template-columns: 1.6fr 1fr auto;
            gap: 16px;
            align-items: end;
        }

        .search-group label {
            display: block;
            font-weight: 800;
            margin-bottom: 8px;
            color: #1e293b;
        }

        .search-group input,
        .search-group select {
            width: 100%;
            border: 1px solid #dbe4f0;
            border-radius: 16px;
            padding: 14px 16px;
            font-size: 15px;
            outline: none;
            background: #fff;
        }

        .search-group input:focus,
        .search-group select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,0.10);
        }

        .search-btn {
            border: none;
            border-radius: 16px;
            background: #081a4b;
            color: #fff;
            padding: 15px 22px;
            font-weight: 800;
            font-size: 16px;
            min-width: 160px;
            height: 52px;
        }

        .acc-section {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 20px 70px;
        }

        .section-head {
            margin-bottom: 26px;
        }

        .section-head h2 {
            font-size: 44px;
            margin: 0 0 10px;
            font-weight: 800;
        }

        .section-head p {
            margin: 0;
            color: #64748b;
            font-size: 18px;
        }

        .hotel-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 28px;
        }

        .hotel-card {
            background: #fff;
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.10);
            border: 1px solid #e2e8f0;
            transition: all 0.25s ease;
        }

        .hotel-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 24px 50px rgba(15, 23, 42, 0.16);
        }

        .hotel-image {
            position: relative;
            height: 320px;
            overflow: hidden;
            background: #e5e7eb;
        }

        .hotel-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .hotel-badge {
            position: absolute;
            top: 18px;
            left: 18px;
            background: #0f172a;
            color: #fff;
            padding: 9px 14px;
            border-radius: 14px;
            font-weight: 800;
            font-size: 14px;
        }

        .hotel-status {
            position: absolute;
            top: 18px;
            right: 18px;
            background: #22c55e;
            color: #fff;
            padding: 9px 14px;
            border-radius: 14px;
            font-weight: 800;
            font-size: 14px;
        }

        .hotel-body {
            padding: 24px 28px 28px;
        }

        .hotel-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 10px;
        }

        .hotel-top h3 {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            line-height: 1.35;
            flex: 1;
        }

        .hotel-rate {
            white-space: nowrap;
            color: #0f172a;
            font-weight: 800;
            font-size: 18px;
        }

        .hotel-rate i {
            color: #facc15;
            margin-right: 4px;
        }

        .hotel-location {
            color: #64748b;
            font-size: 16px;
            margin-bottom: 14px;
        }

        .hotel-location i {
            color: #0ea5e9;
            margin-right: 8px;
        }

        .hotel-desc {
            color: #475569;
            line-height: 1.8;
            font-size: 16px;
            margin-bottom: 20px;
        }

        .hotel-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .hotel-tags span {
            background: #0f766e;
            color: white;
            padding: 8px 12px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
        }

        .hotel-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 20px;
            color: #64748b;
            font-size: 15px;
        }

        .hotel-meta div i {
            margin-right: 8px;
            color: #2563eb;
        }

        .hotel-footer {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .detail-btn {
            background: linear-gradient(135deg, #0f172a, #1d4ed8);
            color: #fff;
            text-decoration: none;
            padding: 14px 18px;
            border-radius: 14px;
            font-weight: 800;
            transition: all 0.2s ease;
        }

        .detail-btn:hover {
            color: #fff;
            opacity: 0.95;
            transform: translateY(-1px);
        }

        .empty-box {
            background: #fff;
            border-radius: 24px;
            padding: 60px 20px;
            text-align: center;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
        }

        .empty-box i {
            font-size: 48px;
            margin-bottom: 16px;
            color: #94a3b8;
        }

        @media (max-width: 992px) {
            .search-box,
            .hotel-grid {
                grid-template-columns: 1fr;
            }

            .acc-hero h1 {
                font-size: 42px;
            }

            .section-head h2 {
                font-size: 34px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/common/homepage/header.jsp" />

<div class="page-top-space"></div>

<section class="acc-hero">
    <div class="acc-container">
        <div class="acc-breadcrumb">
            <i class="fa-solid fa-hotel"></i>
            WonderVN Accommodation
        </div>
        <h1>Tìm nơi lưu trú phù hợp cho hành trình của bạn</h1>
        <p>
            Khám phá khách sạn, homestay, resort và căn hộ dịch vụ với không gian đẹp,
            mức giá rõ ràng và trải nghiệm lưu trú chỉn chu.
        </p>
    </div>
</section>

<section class="search-wrap">
    <form class="search-box" action="${pageContext.request.contextPath}/accommodation" method="get">
        <div class="search-group">
            <label>Tìm theo tên, địa chỉ hoặc mô tả</label>
            <input type="text" name="keyword" value="${keyword}"
                   placeholder="VD: Đà Nẵng, homestay, resort gần biển...">
        </div>

        <div class="search-group">
            <label>Loại hình lưu trú</label>
            <select name="type">
                <option value="all" ${empty selectedType || selectedType == 'all' ? 'selected' : ''}>Tất cả</option>
                <option value="Khách sạn" ${selectedType == 'Khách sạn' ? 'selected' : ''}>Khách sạn</option>
                <option value="Homestay" ${selectedType == 'Homestay' ? 'selected' : ''}>Homestay</option>
                <option value="Resort" ${selectedType == 'Resort' ? 'selected' : ''}>Resort</option>
                <option value="Apartment" ${selectedType == 'Apartment' ? 'selected' : ''}>Apartment</option>
            </select>
        </div>

        <button class="search-btn" type="submit">
            <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
        </button>
    </form>
</section>

<section class="acc-section">
    <div class="section-head">
        <h2>Danh sách lưu trú</h2>
        <p>Lựa chọn nơi nghỉ phù hợp trước khi tiếp tục đặt dịch vụ.</p>
    </div>

    <c:choose>
        <c:when test="${empty accommodationList}">
            <div class="empty-box">
                <i class="fa-solid fa-hotel"></i>
                <h3>Chưa tìm thấy nơi lưu trú phù hợp</h3>
                <p>Hãy thử thay đổi từ khóa hoặc loại hình lưu trú.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="hotel-grid">
                <c:forEach var="acc" items="${accommodationList}">
                    <div class="hotel-card">
                        <div class="hotel-image">
                            <img src="${acc.image}" alt="${acc.name}"
                                 onerror="this.src='https://placehold.co/900x600?text=WonderVN+Accommodation';">
                            <div class="hotel-badge">${acc.type}</div>
                            <div class="hotel-status">Còn phòng</div>
                        </div>

                        <div class="hotel-body">
                            <div class="hotel-top">
                                <h3>${acc.name}</h3>
                                <div class="hotel-rate">
                                    <i class="fa-solid fa-star"></i> ${acc.rate}
                                </div>
                            </div>

                            <div class="hotel-location">
                                <i class="fa-solid fa-location-dot"></i>${acc.address}
                            </div>

                            <div class="hotel-desc">
                                <c:choose>
                                    <c:when test="${not empty acc.description && acc.description.length() > 140}">
                                        ${acc.description.substring(0, 140)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${acc.description}
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="hotel-tags">
                                <span>WiFi miễn phí</span>
                                <span>Check-in ${acc.checkInTime}</span>
                                <span>Check-out ${acc.checkOutTime}</span>
                            </div>

                            <div class="hotel-meta">
                                <div><i class="fa-solid fa-phone"></i>${acc.phone}</div>
                                <div><i class="fa-solid fa-bed"></i> Xem chi tiết phòng</div>
                            </div>

                            <div class="hotel-footer">
                                <a class="detail-btn"
                                   href="${pageContext.request.contextPath}/accommodation/detail?id=${acc.serviceID}">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<jsp:include page="/WEB-INF/common/homepage/footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>