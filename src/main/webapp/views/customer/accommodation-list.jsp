<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Khách sạn & Lưu trú</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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

        .page-shell {
            width: min(1440px, calc(100% - 32px));
            margin: 0 auto;
        }

        .hero {
            margin: 18px auto 16px;
            background: linear-gradient(135deg, rgba(10, 25, 78, 0.98), rgba(37, 99, 235, 0.92));
            border-radius: 28px;
            padding: 34px 34px 86px;
            color: #fff;
            position: relative;
            overflow: visible;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.14);
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            border-radius: 999px;
            background: rgba(255,255,255,0.14);
            border: 1px solid rgba(255,255,255,0.18);
            font-weight: 700;
            font-size: 15px;
            margin-bottom: 18px;
        }

        .hero h1 {
            margin: 0 0 14px;
            font-size: clamp(32px, 4vw, 56px);
            line-height: 1.12;
            font-weight: 800;
            max-width: 820px;
        }

        .hero p {
            margin: 0;
            max-width: 760px;
            font-size: 18px;
            line-height: 1.8;
            color: rgba(255,255,255,0.92);
        }

        .filter-panel {
            width: calc(100% - 60px);
            margin: -58px auto 24px;
            background: #fff;
            border-radius: 28px;
            padding: 22px;
            position: relative;
            z-index: 5;
            box-shadow: 0 16px 40px rgba(15, 23, 42, 0.12);
        }

        .filter-form {
            display: grid;
            grid-template-columns: 1.4fr 1fr 1fr 1fr auto;
            gap: 16px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 700;
            color: #334155;
        }

        .form-control {
            width: 100%;
            height: 56px;
            border-radius: 18px;
            border: 1px solid #dbe3f0;
            background: #fdfefe;
            padding: 0 18px;
            font-size: 16px;
            font-family: inherit;
            color: #0f172a;
            outline: none;
            transition: all .2s ease;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,0.10);
        }

        .search-btn {
            height: 56px;
            min-width: 170px;
            border: none;
            border-radius: 18px;
            background: linear-gradient(135deg, #0f172a, #0b1f5f);
            color: #fff;
            font-weight: 800;
            font-size: 17px;
            cursor: pointer;
            padding: 0 26px;
            transition: transform .18s ease, box-shadow .18s ease;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(15, 23, 42, 0.16);
        }

        .facility-strip {
            display: flex;
            gap: 12px;
            overflow-x: auto;
            padding: 4px 0 6px;
            margin-bottom: 20px;
            scrollbar-width: thin;
        }

        .facility-strip::-webkit-scrollbar {
            height: 8px;
        }

        .facility-strip::-webkit-scrollbar-thumb {
            background: #d7deea;
            border-radius: 999px;
        }

        .facility-chip {
            flex: 0 0 auto;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 18px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid #dbe3f0;
            color: #334155;
            font-weight: 700;
            font-size: 14px;
            transition: all .2s ease;
        }

        .facility-chip i {
            width: 18px;
            text-align: center;
            color: #1d4ed8;
        }

        .facility-chip:hover,
        .facility-chip.active {
            background: #eff6ff;
            border-color: #93c5fd;
            color: #1d4ed8;
            transform: translateY(-1px);
        }

        .section-head {
            display: flex;
            justify-content: space-between;
            align-items: end;
            gap: 16px;
            margin: 8px 0 20px;
        }

        .section-head h2 {
            margin: 0 0 6px;
            font-size: clamp(28px, 3vw, 42px);
            font-weight: 800;
            color: #0f172a;
        }

        .section-head p {
            margin: 0;
            color: #64748b;
            font-size: 18px;
        }

        .result-badge {
            background: #fff;
            border: 1px solid #e2e8f0;
            padding: 12px 16px;
            border-radius: 16px;
            font-weight: 700;
            color: #334155;
            white-space: nowrap;
        }

        .accommodation-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 28px;
            margin-bottom: 40px;
        }

        .accommodation-card {
            background: #fff;
            border-radius: 28px;
            overflow: hidden;
            border: 1px solid #e6edf5;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.07);
            transition: transform .22s ease, box-shadow .22s ease;
            display: flex;
            flex-direction: column;
            min-height: 100%;
        }

        .accommodation-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 44px rgba(15, 23, 42, 0.12);
        }

        .card-media {
            position: relative;
            height: 270px;
            overflow: hidden;
            background: #e2e8f0;
        }

        .card-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform .35s ease;
        }

        .accommodation-card:hover .card-media img {
            transform: scale(1.05);
        }

        .media-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(2, 6, 23, 0.78), rgba(2, 6, 23, 0.05) 55%);
        }

        .type-badge {
            position: absolute;
            top: 18px;
            left: 18px;
            z-index: 2;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(15, 23, 42, 0.88);
            color: #fff;
            font-size: 14px;
            font-weight: 800;
            box-shadow: 0 8px 20px rgba(0,0,0,0.18);
        }

        .rating-badge {
            position: absolute;
            top: 18px;
            right: 18px;
            z-index: 2;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,0.96);
            color: #0f172a;
            font-size: 15px;
            font-weight: 800;
            box-shadow: 0 8px 20px rgba(0,0,0,0.10);
        }

        .price-highlight {
            position: absolute;
            left: 22px;
            bottom: 22px;
            z-index: 2;
            color: #fff;
        }

        .price-highlight .price-label {
            display: block;
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 2px;
            opacity: .95;
        }

        .price-highlight .price-value {
            font-size: 24px;
            font-weight: 900;
            line-height: 1.15;
            text-shadow: 0 3px 12px rgba(0,0,0,0.24);
        }

        .price-highlight .price-night {
            font-size: 15px;
            font-weight: 700;
            margin-left: 4px;
            opacity: .95;
        }

        .card-body {
            padding: 22px 22px 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .card-title {
            margin: 0 0 14px;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.35;
            color: #0f172a;
            min-height: 60px;
        }

        .location-primary {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 17px;
            font-weight: 800;
            color: #16a34a;
            margin-bottom: 8px;
        }

        .location-secondary {
            font-size: 15px;
            line-height: 1.7;
            color: #64748b;
            margin-bottom: 16px;
            min-height: 52px;
        }

        .meta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 16px;
        }

        .meta-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #eef2ff;
            color: #312e81;
            border-radius: 999px;
            padding: 10px 14px;
            font-size: 14px;
            font-weight: 800;
        }

        .facility-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
            min-height: 48px;
        }

        .facility-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            border: 1px solid #bfe7dc;
            background: #f0fdf9;
            color: #0f766e;
            font-size: 14px;
            font-weight: 700;
        }

        .facility-pill i,
        .facility-empty i {
            width: 18px;
            text-align: center;
        }

        .facility-empty {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            border: 1px solid #cce8df;
            background: #f2fbf8;
            color: #0f766e;
            font-size: 14px;
            font-weight: 700;
        }

        .card-actions {
            margin-top: auto;
        }

        .detail-btn {
            width: 100%;
            height: 56px;
            border: none;
            border-radius: 18px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff;
            font-size: 18px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.20);
            transition: transform .18s ease, box-shadow .18s ease;
        }

        .detail-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 30px rgba(37, 99, 235, 0.24);
            color: #fff;
        }

        .empty-box {
            background: #fff;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 50px 22px;
            text-align: center;
            color: #64748b;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
            margin-bottom: 40px;
        }

        .empty-box i {
            font-size: 44px;
            color: #94a3b8;
            margin-bottom: 14px;
        }

        .empty-box h3 {
            margin: 0 0 10px;
            font-size: 24px;
            color: #0f172a;
        }

        .empty-box p {
            margin: 0;
            font-size: 16px;
        }

        @media (max-width: 1280px) {
            .accommodation-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 1080px) {
            .filter-form {
                grid-template-columns: repeat(2, 1fr);
            }

            .search-btn {
                width: 100%;
            }

            .accommodation-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 768px) {
            .page-shell {
                width: calc(100% - 20px);
            }

            .hero {
                padding: 26px 20px 78px;
            }

            .filter-panel {
                width: calc(100% - 12px);
                padding: 16px;
            }

            .filter-form {
                grid-template-columns: 1fr;
            }

            .section-head {
                flex-direction: column;
                align-items: flex-start;
            }

            .accommodation-grid {
                grid-template-columns: 1fr;
                gap: 22px;
            }

            .card-media {
                height: 240px;
            }

            .card-title {
                min-height: auto;
            }

            .location-secondary {
                min-height: auto;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<div class="page-shell">
    <section class="hero">
        <div class="hero-badge">
            <i class="fa-solid fa-hotel"></i>
            <span>WonderVN Accommodation</span>
        </div>

        <h1>Tìm homestay, khách sạn và resort phù hợp cho chuyến đi của bạn</h1>

        <p>
            Tìm nơi lưu trú theo địa điểm, loại hình, mức giá, số khách và tiện ích yêu thích.
            Giao diện hiển thị rõ ràng, hiện đại và dễ chọn hơn cho khách hàng.
        </p>
    </section>

    <div class="filter-panel">
        <form action="${pageContext.request.contextPath}/accommodation" method="get" class="filter-form">
            <div class="form-group">
                <label>Từ khóa</label>
                <input type="text"
                       class="form-control"
                       name="keyword"
                       value="${keyword}"
                       placeholder="VD: Hạ Long, homestay view biển...">
            </div>

            <div class="form-group">
                <label>Tỉnh/thành</label>
                <input type="text"
                       class="form-control"
                       name="province"
                       value="${selectedProvince}"
                       placeholder="VD: Hà Nội">
            </div>

            <div class="form-group">
                <label>Loại lưu trú</label>
                <select class="form-control" name="type">
                    <option value="">Tất cả</option>
                    <option value="Homestay" ${selectedType == 'Homestay' ? 'selected' : ''}>Homestay</option>
                    <option value="Khách sạn" ${selectedType == 'Khách sạn' ? 'selected' : ''}>Khách sạn</option>
                    <option value="Hotel" ${selectedType == 'Hotel' ? 'selected' : ''}>Hotel</option>
                    <option value="Resort" ${selectedType == 'Resort' ? 'selected' : ''}>Resort</option>
                    <option value="Căn hộ" ${selectedType == 'Căn hộ' ? 'selected' : ''}>Căn hộ</option>
                    <option value="Apartment" ${selectedType == 'Apartment' ? 'selected' : ''}>Apartment</option>
                    <option value="Villa" ${selectedType == 'Villa' ? 'selected' : ''}>Villa</option>
                </select>
            </div>

            <div class="form-group">
                <label>Số khách</label>
                <input type="number"
                       class="form-control"
                       min="1"
                       name="guests"
                       value="${selectedGuests}"
                       placeholder="VD: 2">
            </div>

            <button type="submit" class="search-btn">
                <i class="fa-solid fa-magnifying-glass"></i>
                Tìm kiếm
            </button>
        </form>
    </div>

    <c:if test="${not empty accommodationFacilityOptions}">
        <div class="facility-strip">
            <a class="facility-chip ${empty selectedFacilityId ? 'active' : ''}"
               href="${pageContext.request.contextPath}/accommodation?keyword=${fn:escapeXml(keyword)}&province=${fn:escapeXml(selectedProvince)}&district=${fn:escapeXml(selectedDistrict)}&type=${fn:escapeXml(selectedType)}&guests=${selectedGuests}&minRate=${selectedMinRate}&minPrice=${selectedMinPrice}&maxPrice=${selectedMaxPrice}">
                <i class="fa-solid fa-house"></i>
                <span>Tất cả</span>
            </a>

            <c:forEach var="facility" items="${accommodationFacilityOptions}">
                <a class="facility-chip ${selectedFacilityId == facility.facilityID ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/accommodation?keyword=${fn:escapeXml(keyword)}&province=${fn:escapeXml(selectedProvince)}&district=${fn:escapeXml(selectedDistrict)}&type=${fn:escapeXml(selectedType)}&guests=${selectedGuests}&minRate=${selectedMinRate}&minPrice=${selectedMinPrice}&maxPrice=${selectedMaxPrice}&facilityId=${facility.facilityID}">

                    <c:choose>
                        <c:when test="${empty facility.icon}">
                            <i class="fa-solid fa-circle-check"></i>
                        </c:when>
                        <c:when test="${fn:contains(facility.icon, 'fa-solid') || fn:contains(facility.icon, 'fa-regular') || fn:contains(facility.icon, 'fa-brands')}">
                            <i class="${facility.icon}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid ${facility.icon}"></i>
                        </c:otherwise>
                    </c:choose>

                    <span>${facility.facilityName}</span>
                </a>
            </c:forEach>
        </div>
    </c:if>

    <div class="section-head">
        <div>
            <h2>Danh sách lưu trú nổi bật</h2>
            <p>Khám phá những homestay, khách sạn và resort phù hợp nhất với nhu cầu của bạn.</p>
        </div>

        <div class="result-badge">
            <i class="fa-solid fa-layer-group"></i>
            Tìm thấy <strong>${fn:length(accommodationList)}</strong> nơi lưu trú
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty accommodationList}">
            <div class="accommodation-grid">
                <c:forEach var="acc" items="${accommodationList}">
                    <div class="accommodation-card">
                        <div class="card-media">
                            <img src="${empty acc.image ? 'https://placehold.co/900x600?text=WonderVN+Accommodation' : acc.image}"
                                 alt="${acc.name}"
                                 onerror="this.src='https://placehold.co/900x600?text=WonderVN+Accommodation';">

                            <div class="media-overlay"></div>

                            <div class="type-badge">
                                <i class="fa-solid fa-hotel"></i>
                                <span>${empty acc.displayType ? acc.type : acc.displayType}</span>
                            </div>

                            <div class="rating-badge">
                                <i class="fa-solid fa-star" style="color:#facc15;"></i>
                                <span>
                                    <fmt:formatNumber value="${acc.rate}" pattern="0.0"/>
                                </span>
                            </div>

                            <div class="price-highlight">
                                <span class="price-label">Giá phòng từ</span>
                                <span class="price-value">
                                    <fmt:formatNumber value="${acc.minRoomPrice}" pattern="#,##0"/>
                                </span>
                                <span class="price-night">đ / đêm</span>
                            </div>
                        </div>

                        <div class="card-body">
                            <h3 class="card-title">${acc.name}</h3>

                            <div class="location-primary">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>${acc.province}</span>
                            </div>

                            <div class="location-secondary">
                                    ${acc.fullAddress}
                            </div>

                            <div class="meta-row">
                                <div class="meta-pill">
                                    <i class="fa-solid fa-bed"></i>
                                    <span>${acc.totalAvailableRooms} phòng trống</span>
                                </div>

                                <div class="meta-pill">
                                    <i class="fa-solid fa-clock"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty acc.checkInText}">
                                                ${acc.checkInText}
                                            </c:when>
                                            <c:otherwise>
                                                ${acc.checkInTime}
                                            </c:otherwise>
                                        </c:choose>
                                        nhận
                                    </span>
                                </div>
                            </div>

                            <div class="facility-list">
                                <c:choose>
                                    <c:when test="${not empty acc.facilityList}">
                                        <c:forEach var="facility" items="${acc.facilityList}" varStatus="loop">
                                            <c:if test="${loop.index < 4}">
                                                <div class="facility-pill">
                                                    <c:choose>
                                                        <c:when test="${empty facility.icon}">
                                                            <i class="fa-solid fa-circle-check"></i>
                                                        </c:when>
                                                        <c:when test="${fn:contains(facility.icon, 'fa-solid') || fn:contains(facility.icon, 'fa-regular') || fn:contains(facility.icon, 'fa-brands')}">
                                                            <i class="${facility.icon}"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa-solid ${facility.icon}"></i>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <span>${facility.facilityName}</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${fn:length(acc.facilityList) > 4}">
                                            <div class="facility-pill">
                                                <i class="fa-solid fa-plus"></i>
                                                <span>+${fn:length(acc.facilityList) - 4} tiện ích</span>
                                            </div>
                                        </c:if>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="facility-empty">
                                            <i class="fa-solid fa-circle-info"></i>
                                            <span>Chưa cập nhật tiện ích</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="card-actions">
                                <a class="detail-btn"
                                   href="${pageContext.request.contextPath}/accommodation/detail?id=${acc.serviceID}">
                                    Xem chi tiết
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-box">
                <i class="fa-solid fa-hotel"></i>
                <h3>Không tìm thấy nơi lưu trú phù hợp</h3>
                <p>Hãy thử thay đổi từ khóa, loại hình hoặc khu vực tìm kiếm để xem thêm kết quả khác.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/views/common/client-footer.jsp" />

</body>
</html>