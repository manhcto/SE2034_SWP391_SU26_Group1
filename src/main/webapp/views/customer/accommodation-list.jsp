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


        .page-shell {
            width: 100%;
            margin: 0 auto;
        }


        .hero {
            position: relative;
            margin: 0;
            min-height: auto;
            border-radius: 0;
            padding: 0;
            color: #101828;
            overflow: hidden;
            background: #eef4fb;
            border-bottom: 1px solid #dce5f0;
        }


        .hero::before {
            display: none;
        }


        .hero::after {
            display: none;
        }


        .hero-content {
            position: relative;
            z-index: 2;
            width: min(1180px, calc(100% - 40px));
            margin: 0 auto;
            padding: 34px 0 30px;
        }


        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 7px 10px;
            border-radius: 6px;
            background: #fff7e6;
            border: 1px solid #f4cf83;
            color: #8a5a00;
            font-weight: 900;
            font-size: 11px;
            margin-bottom: 10px;
        }


        .hero-badge i {
            color: #facc15;
        }


        .hero h1 {
            margin: 0 0 8px;
            max-width: 880px;
            font-size: 32px;
            line-height: 1.2;
            font-weight: 950;
            letter-spacing: 0;
            color: #101828;
            text-shadow: none;
        }


        .hero p {
            margin: 0;
            max-width: 760px;
            font-size: 14px;
            line-height: 1.6;
            font-weight: 600;
            color: #667085;
            text-shadow: none;
        }


        .filter-panel {
            width: min(1180px, calc(100% - 40px));
            margin: 24px auto 30px;
            background: rgba(255, 255, 255, 0.97);
            border-radius: 8px;
            padding: 24px;
            position: relative;
            z-index: 10;
            box-shadow: 0 28px 76px rgba(15, 23, 42, 0.18);
            border: 1px solid rgba(226, 232, 240, 0.95);
            backdrop-filter: blur(18px);
        }


        .filter-form {
            display: grid;
            grid-template-columns: 1.4fr 1fr 1fr 0.9fr 0.9fr;
            gap: 16px;
            align-items: end;
        }


        .filter-form-row-2 {
            margin-top: 16px;
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr auto;
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
            font-weight: 800;
            color: #1e293b;
        }


        .form-control {
            width: 100%;
            height: 58px;
            border-radius: 6px;
            border: 1px solid #dbe3f0;
            background: #ffffff;
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


        .required-note {
            margin-top: 12px;
            font-size: 13px;
            color: #64748b;
            font-weight: 700;
        }


        .required-note i {
            color: #2563eb;
        }


        .search-btn {
            height: 58px;
            min-width: 176px;
            border: none;
            border-radius: 6px;
            background: #175cd3;
            color: #fff;
            font-weight: 900;
            font-size: 17px;
            cursor: pointer;
            padding: 0 28px;
            transition: transform .18s ease, box-shadow .18s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }


        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 30px rgba(15, 23, 42, 0.18);
        }


        .facility-strip {
            display: flex;
            gap: 12px;
            overflow-x: auto;
            width: min(1180px, calc(100% - 40px));
            padding: 4px 0 8px;
            margin: 0 auto 22px;
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
            padding: 13px 19px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid #dbe3f0;
            color: #334155;
            font-weight: 800;
            font-size: 14px;
            transition: all .2s ease;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04);
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
            width: min(1180px, calc(100% - 40px));
            margin: 8px auto 22px;
        }


        .section-head h2 {
            margin: 0 0 6px;
            font-size: 40px;
            font-weight: 900;
            color: #0f172a;
            letter-spacing: 0;
        }


        .section-head p {
            margin: 0;
            color: #64748b;
            font-size: 18px;
            line-height: 1.65;
        }


        .result-badge {
            background: #fff;
            border: 1px solid #e2e8f0;
            padding: 13px 17px;
            border-radius: 8px;
            font-weight: 800;
            color: #334155;
            white-space: nowrap;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
        }


        .result-badge i {
            color: #2563eb;
        }


        .selected-trip-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e3a8a;
            border-radius: 8px;
            padding: 16px 18px;
            width: min(1180px, calc(100% - 40px));
            margin: 0 auto 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            align-items: center;
            font-weight: 800;
        }


        .selected-trip-box span {
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }


        .selected-trip-box i {
            color: #2563eb;
        }


        .accommodation-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 28px;
            width: min(1180px, calc(100% - 40px));
            margin: 0 auto 44px;
        }


        .accommodation-card {
            background: #fff;
            border-radius: 8px;
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
            display: flex;
            gap: 10px;
        }




        .detail-btn {
            flex: 1;
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
            border-radius: 8px;
            padding: 50px 22px;
            text-align: center;
            color: #64748b;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
            width: min(1180px, calc(100% - 40px));
            margin: 0 auto 40px;
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


        .pagination-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
            margin: 32px auto 8px;
        }


        .page-link-custom {
            min-width: 42px;
            height: 42px;
            padding: 0 13px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            background: #fff;
            color: #334155;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-weight: 800;
        }


        .page-link-custom:hover,
        .page-link-custom.active {
            border-color: #2563eb;
            background: #2563eb;
            color: #fff;
        }


        @media (max-width: 1280px) {
            .accommodation-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }


        @media (max-width: 1080px) {
            .filter-form,
            .filter-form-row-2 {
                grid-template-columns: repeat(2, 1fr);
            }


            .accommodation-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
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
                width: 100%;
            }


            .hero {
                min-height: auto;
                padding: 0;
                border-radius: 0;
            }


            .hero-content {
                width: calc(100% - 32px);
                padding: 28px 0 24px;
            }


            .hero h1 {
                font-size: 36px;
                letter-spacing: 0;
            }


            .hero p {
                font-size: 16px;
            }


            .filter-panel {
                width: calc(100% - 32px);
                margin: 18px auto 22px;
                padding: 16px;
                border-radius: 8px;
            }


            .filter-form,
            .filter-form-row-2 {
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


<main class="page-shell">
    <section class="hero">
        <div class="hero-content">
            <div class="hero-badge">
                <i class="fa-solid fa-location-dot"></i>
                <span>Khám phá Việt Nam cùng WonderVN</span>
            </div>


            <h1>
                Tìm homestay, khách sạn và resort phù hợp cho chuyến đi của bạn
            </h1>


            <p>
                Chọn ngày nhận phòng, ngày trả phòng, số khách và số phòng để hệ thống hiển thị các nơi lưu trú phù hợp.
            </p>


        </div>
    </section>


    <section class="filter-panel" aria-label="Bộ lọc nơi lưu trú">
        <form action="${pageContext.request.contextPath}/accommodation" method="get" id="accommodationSearchForm">
            <div class="filter-form">
                <div class="form-group">
                    <label for="accommodationKeyword">Từ khóa / địa điểm</label>
                    <input type="text"
                           class="form-control"
                           id="accommodationKeyword"
                           name="keyword"
                           value="${fn:escapeXml(keyword)}"
                           placeholder="VD: Hạ Long, Cao Bằng, homestay view biển...">
                </div>


                <div class="form-group">
                    <label for="accommodationProvince">Tỉnh/thành</label>
                    <select class="form-control" id="accommodationProvince" name="province">
                        <option value="">Tất cả tỉnh/thành</option>
                        <c:forEach var="provinceName" items="${provinceList}">
                            <option value="${fn:escapeXml(provinceName)}"
                                ${selectedProvince == provinceName ? 'selected' : ''}>
                                <c:out value="${provinceName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>


                <div class="form-group">
                    <label for="accommodationType">Loại lưu trú</label>
                    <select class="form-control" id="accommodationType" name="type">
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
                    <label for="accommodationAdults">Người lớn</label>
                    <input type="number"
                           class="form-control"
                           id="accommodationAdults"
                           min="1"
                           name="adults"
                           value="${empty selectedAdults ? 2 : selectedAdults}"
                           required>
                </div>


                <div class="form-group">
                    <label for="accommodationChildren">Trẻ em</label>
                    <input type="number"
                           class="form-control"
                           id="accommodationChildren"
                           min="0"
                           name="children"
                           value="${empty selectedChildren ? 0 : selectedChildren}"
                           required>
                </div>
            </div>


            <div class="filter-form-row-2">
                <div class="form-group">
                    <label for="checkInInput">Ngày nhận phòng</label>
                    <input type="date"
                           class="form-control"
                           name="checkIn"
                           id="checkInInput"
                           value="${selectedCheckIn}"
                           required>
                </div>


                <div class="form-group">
                    <label for="checkOutInput">Ngày trả phòng</label>
                    <input type="date"
                           class="form-control"
                           name="checkOut"
                           id="checkOutInput"
                           value="${selectedCheckOut}"
                           required>
                </div>


                <div class="form-group">
                    <label for="accommodationRooms">Số phòng</label>
                    <input type="number"
                           class="form-control"
                           id="accommodationRooms"
                           min="1"
                           name="rooms"
                           value="${empty selectedRooms ? 1 : selectedRooms}"
                           required>
                </div>


                <div class="form-group">
                    <label for="accommodationGuests">Số khách tổng</label>
                    <input type="number"
                           class="form-control"
                           id="accommodationGuests"
                           min="1"
                           name="guests"
                           value="${empty selectedGuests ? 2 : selectedGuests}"
                           readonly
                           aria-readonly="true">
                </div>


                <button type="submit" class="search-btn">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Tìm phòng
                </button>
            </div>


            <div class="required-note">
                <i class="fa-solid fa-circle-info"></i>
                Vui lòng chọn ngày nhận phòng và ngày trả phòng để kiểm tra nơi lưu trú còn phòng.
            </div>
        </form>
    </section>


    <c:if test="${not empty selectedCheckIn && not empty selectedCheckOut}">
        <div class="selected-trip-box">
           <span>
               <i class="fa-solid fa-calendar-check"></i>
               Nhận phòng: ${selectedCheckIn}
           </span>


            <span>
               <i class="fa-solid fa-calendar-xmark"></i>
               Trả phòng: ${selectedCheckOut}
           </span>


            <span>
               <i class="fa-solid fa-user-group"></i>
               ${selectedAdults} người lớn, ${selectedChildren} trẻ em
           </span>


            <span>
               <i class="fa-solid fa-bed"></i>
               ${selectedRooms} phòng
           </span>
        </div>
    </c:if>


    <c:if test="${not empty accommodationFacilityOptions}">
        <div class="facility-strip">
            <a class="facility-chip ${empty selectedFacilityId ? 'active' : ''}"
               href="${pageContext.request.contextPath}/accommodation?keyword=${fn:escapeXml(keyword)}&province=${fn:escapeXml(selectedProvince)}&district=${fn:escapeXml(selectedDistrict)}&type=${fn:escapeXml(selectedType)}&guests=${selectedGuests}&adults=${selectedAdults}&children=${selectedChildren}&rooms=${selectedRooms}&checkIn=${selectedCheckIn}&checkOut=${selectedCheckOut}&minRate=${selectedMinRate}&minPrice=${selectedMinPrice}&maxPrice=${selectedMaxPrice}">
                <i class="fa-solid fa-house"></i>
                <span>Tất cả</span>
            </a>


            <c:forEach var="facility" items="${accommodationFacilityOptions}">
                <a class="facility-chip ${selectedFacilityId == facility.facilityID ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/accommodation?keyword=${fn:escapeXml(keyword)}&province=${fn:escapeXml(selectedProvince)}&district=${fn:escapeXml(selectedDistrict)}&type=${fn:escapeXml(selectedType)}&guests=${selectedGuests}&adults=${selectedAdults}&children=${selectedChildren}&rooms=${selectedRooms}&checkIn=${selectedCheckIn}&checkOut=${selectedCheckOut}&minRate=${selectedMinRate}&minPrice=${selectedMinPrice}&maxPrice=${selectedMaxPrice}&facilityId=${facility.facilityID}">


                    <c:choose>
                        <c:when test="${empty facility.icon}">
                            <i class="fa-solid fa-circle-check"></i>
                        </c:when>
                        <c:when test="${fn:contains(facility.icon, 'fa-solid') || fn:contains(facility.icon, 'fa-regular') || fn:contains(facility.icon, 'fa-brands')}">
                            <i class="${fn:escapeXml(facility.icon)}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid ${fn:escapeXml(facility.icon)}"></i>
                        </c:otherwise>
                    </c:choose>


                    <span><c:out value="${facility.facilityName}"/></span>
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
            Tìm thấy <strong>${totalResults}</strong> nơi lưu trú
        </div>
    </div>


    <c:choose>
        <c:when test="${not empty accommodationList}">
            <section class="accommodation-grid" aria-label="Danh sách nơi lưu trú">
                <c:forEach var="acc" items="${accommodationList}">
                    <article class="accommodation-card">
                        <div class="card-media">
                            <img src="${empty acc.image ? 'https://placehold.co/900x600?text=WonderVN+Accommodation' : fn:escapeXml(acc.image)}"
                                 alt="${fn:escapeXml(acc.name)}"
                                 onerror="this.src='https://placehold.co/900x600?text=WonderVN+Accommodation';">


                            <div class="media-overlay"></div>


                            <div class="type-badge">
                                <i class="fa-solid fa-hotel"></i>
                                <span><c:out value="${empty acc.displayType ? acc.type : acc.displayType}"/></span>
                            </div>


                            <div class="rating-badge">
                                <i class="fa-solid fa-star" style="color:#facc15;"></i>
                                <span>
                                   <fmt:formatNumber value="${acc.averageRate}" pattern="0.0"/>
                                   (${acc.reviewCount})
                               </span>
                            </div>


                            <div class="price-highlight">
                                <c:choose>
                                    <c:when test="${not empty acc.roomList}">
                                        <span class="price-label">Giá phòng từ</span>
                                        <span class="price-value">
                                           <fmt:formatNumber value="${acc.minRoomPrice}" pattern="#,##0"/>
                                       </span>
                                        <span class="price-night">đ / đêm</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price-value">Chưa có phòng</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>


                        <div class="card-body">
                            <h3 class="card-title"><c:out value="${acc.name}"/></h3>


                            <div class="location-primary">
                                <i class="fa-solid fa-location-dot"></i>
                                <span><c:out value="${acc.province}"/></span>
                            </div>


                            <div class="location-secondary">
                                <c:out value="${acc.fullAddress}"/>
                            </div>


                            <div class="meta-row">
                                <div class="meta-pill">
                                    <i class="fa-solid fa-bed"></i>
                                    <span>
                                       <c:choose>
                                           <c:when test="${not empty acc.roomList}">
                                               ${acc.totalAvailableRooms} phòng trống
                                           </c:when>
                                           <c:otherwise>Chưa cập nhật phòng</c:otherwise>
                                       </c:choose>
                                   </span>
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
                                                            <i class="${fn:escapeXml(facility.icon)}"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa-solid ${fn:escapeXml(facility.icon)}"></i>
                                                        </c:otherwise>
                                                    </c:choose>


                                                    <span><c:out value="${facility.facilityName}"/></span>
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
                                   href="${pageContext.request.contextPath}/accommodation/detail?id=${acc.accommodationID}&checkIn=${selectedCheckIn}&checkOut=${selectedCheckOut}&adults=${selectedAdults}&children=${selectedChildren}&rooms=${selectedRooms}&guests=${selectedGuests}">
                                    Xem chi tiết
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </section>


            <c:if test="${totalPages > 1}">
                <nav class="pagination-wrap" aria-label="Phân trang nơi lưu trú">
                    <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                        <c:url var="pageUrl" value="/accommodation">
                            <c:param name="page" value="${pageNumber}"/>
                            <c:param name="keyword" value="${keyword}"/>
                            <c:param name="province" value="${selectedProvince}"/>
                            <c:param name="district" value="${selectedDistrict}"/>
                            <c:param name="type" value="${selectedType}"/>
                            <c:param name="guests" value="${selectedGuests}"/>
                            <c:param name="adults" value="${selectedAdults}"/>
                            <c:param name="children" value="${selectedChildren}"/>
                            <c:param name="rooms" value="${selectedRooms}"/>
                            <c:param name="checkIn" value="${selectedCheckIn}"/>
                            <c:param name="checkOut" value="${selectedCheckOut}"/>
                            <c:param name="minRate" value="${selectedMinRate}"/>
                            <c:param name="minPrice" value="${selectedMinPrice}"/>
                            <c:param name="maxPrice" value="${selectedMaxPrice}"/>
                            <c:param name="facilityId" value="${selectedFacilityId}"/>
                            <c:param name="facilityName" value="${selectedFacilityName}"/>
                        </c:url>
                        <a class="page-link-custom${pageNumber == currentPage ? ' active' : ''}"
                           href="${pageUrl}"
                           aria-current="${pageNumber == currentPage ? 'page' : ''}">
                                ${pageNumber}
                        </a>
                    </c:forEach>
                </nav>
            </c:if>
        </c:when>


        <c:otherwise>
            <div class="empty-box">
                <i class="fa-solid fa-hotel"></i>
                <h3>Không tìm thấy nơi lưu trú phù hợp</h3>
                <p>Hãy thử thay đổi từ khóa, ngày lưu trú, số khách hoặc khu vực tìm kiếm để xem thêm kết quả khác.</p>
            </div>
        </c:otherwise>
    </c:choose>
</main>


<jsp:include page="/views/common/client-footer.jsp" />


<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("accommodationSearchForm");
        const checkInInput = document.getElementById("checkInInput");
        const checkOutInput = document.getElementById("checkOutInput");
        const adultsInput = form ? form.querySelector("[name='adults']") : null;
        const childrenInput = form ? form.querySelector("[name='children']") : null;
        const guestsInput = form ? form.querySelector("[name='guests']") : null;


        const today = new Date();
        today.setHours(0, 0, 0, 0);


        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, "0");
        const dd = String(today.getDate()).padStart(2, "0");
        const todayText = yyyy + "-" + mm + "-" + dd;


        if (checkInInput) {
            checkInInput.min = todayText;
        }


        if (checkOutInput) {
            checkOutInput.min = todayText;
        }


        if (checkInInput && checkOutInput) {
            checkInInput.addEventListener("change", function () {
                checkOutInput.min = checkInInput.value;


                if (checkOutInput.value && checkOutInput.value <= checkInInput.value) {
                    checkOutInput.value = "";
                }
            });
        }


        function syncGuests() {
            if (!adultsInput || !childrenInput || !guestsInput) {
                return;
            }


            const adults = parseInt(adultsInput.value || "0", 10);
            const children = parseInt(childrenInput.value || "0", 10);
            guestsInput.value = Math.max(1, adults + children);
        }


        if (adultsInput && childrenInput && guestsInput) {
            adultsInput.addEventListener("input", syncGuests);
            childrenInput.addEventListener("input", syncGuests);
        }


        if (form) {
            form.addEventListener("submit", function (event) {
                syncGuests();


                if (!checkInInput.value || !checkOutInput.value) {
                    event.preventDefault();
                    alert("Vui lòng chọn ngày nhận phòng và ngày trả phòng trước khi tìm kiếm.");
                    return;
                }


                if (checkOutInput.value <= checkInInput.value) {
                    event.preventDefault();
                    alert("Ngày trả phòng phải sau ngày nhận phòng.");
                }
            });
        }
    });
</script>


</body>
</html>
