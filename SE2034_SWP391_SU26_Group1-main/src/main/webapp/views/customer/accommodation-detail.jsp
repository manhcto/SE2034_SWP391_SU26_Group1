<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | ${accommodation.name}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --dark: #0f172a;
            --muted: #64748b;
            --bg: #f3f6fb;
            --border: #e2e8f0;
            --soft: #f8fafc;
            --shadow: 0 16px 40px rgba(15, 23, 42, 0.10);
        }

        body {
            margin: 0;
            background: var(--bg);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            color: #1e293b;
            font-size: 15px;
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
            font-weight: 800;
        }

        .btn-back-page {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 16px;
            border-radius: 999px;
            background: white;
            color: var(--dark);
            border: 1px solid #dbe3ef;
            font-weight: 800;
            box-shadow: 0 8px 18px rgba(15, 23, 42, 0.08);
            cursor: pointer;
        }

        .detail-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 360px;
            gap: 26px;
            align-items: start;
        }

        .main-card,
        .booking-card,
        .section-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 26px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .hero-img {
            height: 420px;
            width: 100%;
            object-fit: cover;
            background: #e2e8f0;
        }

        .main-content {
            padding: 28px;
        }

        .type-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #eef2ff;
            color: #3730a3;
            border-radius: 999px;
            padding: 9px 14px;
            font-weight: 900;
            margin-bottom: 16px;
        }

        .title {
            font-size: 34px;
            font-weight: 900;
            color: var(--dark);
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .location {
            color: var(--muted);
            line-height: 1.65;
            margin-bottom: 24px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 13px;
            margin: 22px 0 28px;
        }

        .info-card {
            border: 1px solid var(--border);
            background: var(--soft);
            border-radius: 18px;
            padding: 16px;
            min-height: 118px;
        }

        .info-card i {
            color: var(--primary);
            font-size: 19px;
            margin-bottom: 12px;
        }

        .info-label {
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 11.5px;
            font-weight: 900;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            font-weight: 900;
            color: var(--dark);
        }

        .selected-trip-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e3a8a;
            border-radius: 20px;
            padding: 16px 18px;
            margin: 24px 0;
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
            color: var(--primary);
        }

        .section-title {
            font-size: 22px;
            font-weight: 900;
            color: var(--dark);
            margin: 28px 0 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .text-box {
            color: #475569;
            line-height: 1.8;
            font-size: 15.5px;
        }

        .facility-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .facility-pill {
            background: #ecfeff;
            color: #155e75;
            border-radius: 999px;
            padding: 9px 12px;
            font-size: 13px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .facility-pill i {
            color: #0891b2;
        }

        .booking-card {
            position: sticky;
            top: 100px;
            padding: 24px;
        }

        .price-main {
            font-size: 32px;
            font-weight: 900;
            color: var(--dark);
            line-height: 1.1;
        }

        .btn-book {
            width: 100%;
            border: none;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            border-radius: 16px;
            padding: 14px 18px;
            font-weight: 900;
            margin-top: 14px;
        }

        .btn-book:hover {
            filter: brightness(0.95);
        }

        .btn-list {
            width: 100%;
            border: 1px solid #cbd5e1;
            background: white;
            color: var(--dark);
            border-radius: 16px;
            padding: 13px 18px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            justify-content: center;
            gap: 8px;
            margin-top: 12px;
        }

        .side-info-box {
            border: 1px solid var(--border);
            background: var(--soft);
            border-radius: 18px;
            padding: 16px;
            margin-top: 14px;
        }

        .stay-search-form {
            border: 1px solid var(--border);
            background: var(--soft);
            border-radius: 18px;
            padding: 16px;
            margin-top: 14px;
            display: grid;
            gap: 12px;
        }

        .stay-search-form label {
            color: var(--dark);
            font-size: 13px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .stay-search-form .form-control {
            height: 46px;
            border-radius: 14px;
            border: 1px solid #dbe3ef;
            font-weight: 700;
        }

        .stay-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
        }

        .btn-update-stay {
            width: 100%;
            border: none;
            background: #0f172a;
            color: white;
            border-radius: 14px;
            padding: 12px 14px;
            font-weight: 900;
        }

        .side-info-title {
            font-weight: 900;
            margin-bottom: 8px;
            color: var(--dark);
        }

        .side-info-line {
            color: #475569;
            font-weight: 700;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .side-info-line i {
            color: var(--primary);
            width: 18px;
        }

        .room-card {
            border: 1px solid var(--border);
            border-radius: 22px;
            overflow: hidden;
            background: white;
            height: 100%;
            transition: 0.2s ease;
        }

        .room-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.12);
        }

        .room-img {
            height: 190px;
            width: 100%;
            object-fit: cover;
            background: #e2e8f0;
        }

        .room-body {
            padding: 18px;
        }

        .room-title {
            font-size: 20px;
            font-weight: 900;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .room-description {
            min-height: 48px;
            color: var(--muted);
            line-height: 1.55;
        }

        .room-specs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 12px 0;
        }

        .pill {
            background: #eef2ff;
            color: #3730a3;
            border-radius: 999px;
            padding: 7px 10px;
            font-size: 12.5px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .section-card {
            padding: 24px;
            margin-top: 24px;
        }

        .btn-view-room {
            border-radius: 16px;
            font-weight: 900;
            padding: 10px 16px;
            white-space: nowrap;
            text-decoration: none;
        }

        .missing-date-alert {
            background: #fff7ed;
            border: 1px solid #fed7aa;
            color: #9a3412;
            border-radius: 20px;
            padding: 16px 18px;
            margin-bottom: 22px;
            font-weight: 800;
            line-height: 1.6;
        }

        .missing-date-alert i {
            color: #f97316;
            margin-right: 6px;
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
            .hero-img {
                height: 300px;
            }

            .info-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .title {
                font-size: 28px;
            }
        }

        @media (max-width: 520px) {
            .info-grid {
                grid-template-columns: 1fr;
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

        <a href="${pageContext.request.contextPath}/accommodation">Khách sạn</a>
        <span>/</span>

        <span>${accommodation.name}</span>
    </div>

    <div class="detail-layout">
        <div>
            <div class="main-card">
                <img class="hero-img"
                     src="${accommodation.image}"
                     alt="${accommodation.name}"
                     onerror="this.src='https://placehold.co/1200x700?text=WonderVN+Accommodation';">

                <div class="main-content">
                    <div class="type-badge">
                        <i class="fa-solid fa-hotel"></i>
                        ${accommodation.displayType}
                    </div>

                    <h1 class="title">${accommodation.name}</h1>

                    <div class="location">
                        <i class="fa-solid fa-location-dot text-info me-1"></i>
                        <strong>${accommodation.province}</strong><br>
                        ${accommodation.fullAddress}
                    </div>

                    <div class="info-grid">
                        <div class="info-card">
                            <i class="fa-solid fa-star"></i>
                            <div class="info-label">Đánh giá</div>
                            <div class="info-value">${accommodation.rate}/5</div>
                        </div>

                        <div class="info-card">
                            <i class="fa-solid fa-clock"></i>
                            <div class="info-label">Nhận phòng</div>
                            <div class="info-value">${accommodation.checkInText}</div>
                        </div>

                        <div class="info-card">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                            <div class="info-label">Trả phòng</div>
                            <div class="info-value">${accommodation.checkOutText}</div>
                        </div>

                        <div class="info-card">
                            <i class="fa-solid fa-phone"></i>
                            <div class="info-label">Liên hệ</div>
                            <div class="info-value">${accommodation.phone}</div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty checkIn && not empty checkOut}">
                            <div class="selected-trip-box">
                                <span>
                                    <i class="fa-solid fa-calendar-check"></i>
                                    Nhận phòng: ${checkIn}
                                </span>

                                <span>
                                    <i class="fa-solid fa-calendar-xmark"></i>
                                    Trả phòng: ${checkOut}
                                </span>

                                <span>
                                    <i class="fa-solid fa-user-group"></i>
                                    ${adults} người lớn, ${children} trẻ em
                                </span>

                                <span>
                                    <i class="fa-solid fa-bed"></i>
                                    ${rooms} phòng
                                </span>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="missing-date-alert">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                                Bạn chưa chọn ngày nhận phòng và ngày trả phòng. Hãy chọn lịch ở khung bên phải để lọc phòng phù hợp ngay trên trang này.
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <h2 class="section-title">
                        <i class="fa-solid fa-circle-info text-primary"></i>
                        Mô tả nơi lưu trú
                    </h2>

                    <div class="text-box">
                        ${accommodation.description}
                    </div>

                    <h2 class="section-title">
                        <i class="fa-solid fa-wand-magic-sparkles text-primary"></i>
                        Tiện ích nổi bật
                    </h2>

                    <div class="facility-wrap">
                        <c:choose>
                            <c:when test="${empty accommodation.facilityList}">
                                <span class="text-muted">Chưa có thông tin tiện ích.</span>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="f" items="${accommodation.facilityList}">
                                    <span class="facility-pill">
                                        <c:choose>
                                            <c:when test="${empty f.icon}">
                                                <i class="fa-solid fa-circle-check"></i>
                                            </c:when>
                                            <c:when test="${f.icon.contains('fa-solid') || f.icon.contains('fa-regular') || f.icon.contains('fa-brands')}">
                                                <i class="${f.icon}"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid ${f.icon}"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        ${f.facilityName}
                                    </span>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="section-card" id="roomSection">
                <h2 class="section-title mt-0">
                    <i class="fa-solid fa-bed text-primary"></i>
                    Phòng còn phù hợp với ngày đã chọn
                </h2>

                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty roomList}">
                            <div class="col-12 text-center text-muted py-4">
                                Hiện chưa có phòng phù hợp với số khách, số phòng hoặc ngày bạn đã chọn.
                            </div>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="r" items="${roomList}">
                                <div class="col-lg-6">
                                    <div class="room-card">
                                        <img class="room-img"
                                             src="${r.image}"
                                             alt="${r.roomType}"
                                             onerror="this.src='https://placehold.co/800x500?text=WonderVN+Room';">

                                        <div class="room-body">
                                            <div class="room-title">${r.roomType}</div>

                                            <div class="room-description">
                                                    ${r.description}
                                            </div>

                                            <div class="room-specs">
                                                <span class="pill">
                                                    <i class="fa-solid fa-bed"></i>
                                                    ${r.bedCount} ${r.displayBedType}
                                                </span>

                                                <span class="pill">
                                                    <i class="fa-solid fa-user"></i>
                                                    ${r.maxAdults} người lớn
                                                </span>

                                                <span class="pill">
                                                    <i class="fa-solid fa-child"></i>
                                                    ${r.maxChildren} trẻ em
                                                </span>

                                                <span class="pill">
                                                    <i class="fa-solid fa-ruler-combined"></i>
                                                    ${r.roomSize} m²
                                                </span>
                                            </div>

                                            <c:if test="${not empty r.facilityList}">
                                                <div class="facility-wrap my-3">
                                                    <c:forEach var="rf" items="${r.facilityList}" varStatus="st">
                                                        <c:if test="${st.index < 4}">
                                                            <span class="facility-pill">
                                                                <c:choose>
                                                                    <c:when test="${empty rf.icon}">
                                                                        <i class="fa-solid fa-circle-check"></i>
                                                                    </c:when>
                                                                    <c:when test="${rf.icon.contains('fa-solid') || rf.icon.contains('fa-regular') || rf.icon.contains('fa-brands')}">
                                                                        <i class="${rf.icon}"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="fa-solid ${rf.icon}"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                ${rf.facilityName}
                                                            </span>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </c:if>

                                            <div class="d-flex justify-content-between align-items-end mt-3 gap-3">
                                                <div>
                                                    <div class="price-main fs-4">
                                                        <fmt:formatNumber value="${r.priceOfRoom}" type="number" maxFractionDigits="0"/> đ
                                                    </div>

                                                    <div class="text-muted small">
                                                        Còn ${r.roomAvailability} phòng
                                                    </div>
                                                </div>

                                                <a href="${pageContext.request.contextPath}/accommodation/room/detail?id=${r.roomID}&accommodationId=${accommodation.serviceID}&checkIn=${checkIn}&checkOut=${checkOut}&adults=${adults}&children=${children}&rooms=${rooms}&guests=${guests}"
                                                   class="btn btn-primary btn-view-room">
                                                    <i class="fa-solid fa-eye me-1"></i>
                                                    Xem phòng
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <aside class="booking-card">
            <div class="text-muted fw-bold mb-2">Giá phòng từ</div>

            <div class="price-main">
                <fmt:formatNumber value="${accommodation.minRoomPrice}" type="number" maxFractionDigits="0"/> đ
            </div>

            <div class="text-muted">/ đêm</div>

            <form class="stay-search-form"
                  id="staySearchForm"
                  action="${pageContext.request.contextPath}/accommodation/detail"
                  method="get">
                <input type="hidden" name="id" value="${accommodation.serviceID}">

                <div>
                    <label for="stayCheckIn">Ngày nhận phòng</label>
                    <input type="date"
                           class="form-control"
                           id="stayCheckIn"
                           name="checkIn"
                           value="${checkIn}"
                           required>
                </div>

                <div>
                    <label for="stayCheckOut">Ngày trả phòng</label>
                    <input type="date"
                           class="form-control"
                           id="stayCheckOut"
                           name="checkOut"
                           value="${checkOut}"
                           required>
                </div>

                <div class="stay-form-grid">
                    <div>
                        <label for="stayAdults">Người lớn</label>
                        <input type="number"
                               class="form-control"
                               id="stayAdults"
                               name="adults"
                               min="1"
                               value="${empty adults ? 2 : adults}"
                               required>
                    </div>

                    <div>
                        <label for="stayChildren">Trẻ em</label>
                        <input type="number"
                               class="form-control"
                               id="stayChildren"
                               name="children"
                               min="0"
                               value="${empty children ? 0 : children}"
                               required>
                    </div>

                    <div>
                        <label for="stayRooms">Số phòng</label>
                        <input type="number"
                               class="form-control"
                               id="stayRooms"
                               name="rooms"
                               min="1"
                               value="${empty rooms ? 1 : rooms}"
                               required>
                    </div>

                    <div>
                        <label for="stayGuests">Tổng khách</label>
                        <input type="number"
                               class="form-control"
                               id="stayGuests"
                               name="guests"
                               min="1"
                               value="${empty guests ? 2 : guests}"
                               required>
                    </div>
                </div>

                <button type="submit" class="btn-update-stay">
                    <i class="fa-solid fa-magnifying-glass me-2"></i>
                    Kiểm tra phòng
                </button>
            </form>

            <div class="side-info-box">
                <div class="side-info-title">Địa điểm</div>

                <div class="side-info-line">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>${accommodation.province}</span>
                </div>

                <div class="side-info-line">
                    <i class="fa-solid fa-map"></i>
                    <span>${accommodation.district}</span>
                </div>
            </div>

            <div class="side-info-box">
                <div class="side-info-title">Thời gian khách sạn</div>

                <div class="side-info-line">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    <span>Nhận phòng: ${accommodation.checkInText}</span>
                </div>

                <div class="side-info-line">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span>Trả phòng: ${accommodation.checkOutText}</span>
                </div>
            </div>

            <c:if test="${not empty checkIn && not empty checkOut}">
                <div class="side-info-box">
                    <div class="side-info-title">Lịch bạn đã chọn</div>

                    <div class="side-info-line">
                        <i class="fa-solid fa-calendar-check"></i>
                        <span>${checkIn}</span>
                    </div>

                    <div class="side-info-line">
                        <i class="fa-solid fa-calendar-xmark"></i>
                        <span>${checkOut}</span>
                    </div>

                    <div class="side-info-line">
                        <i class="fa-solid fa-user-group"></i>
                        <span>${adults} người lớn, ${children} trẻ em</span>
                    </div>

                    <div class="side-info-line">
                        <i class="fa-solid fa-bed"></i>
                        <span>${rooms} phòng</span>
                    </div>
                </div>
            </c:if>

            <button type="button" class="btn-book" onclick="scrollToRooms()">
                <i class="fa-solid fa-bed me-2"></i>
                Xem phòng còn trống
            </button>

            <a class="btn-list"
               href="${pageContext.request.contextPath}/accommodation?checkIn=${checkIn}&checkOut=${checkOut}&adults=${adults}&children=${children}&rooms=${rooms}&guests=${guests}">
                <i class="fa-solid fa-list"></i>
                Quay lại danh sách
            </a>
        </aside>
    </div>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function scrollToRooms() {
        const roomSection = document.getElementById("roomSection");

        if (roomSection) {
            roomSection.scrollIntoView({
                behavior: "smooth",
                block: "start"
            });
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("staySearchForm");
        const checkInInput = document.getElementById("stayCheckIn");
        const checkOutInput = document.getElementById("stayCheckOut");
        const adultsInput = document.getElementById("stayAdults");
        const childrenInput = document.getElementById("stayChildren");
        const guestsInput = document.getElementById("stayGuests");

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const todayText = today.getFullYear()
            + "-" + String(today.getMonth() + 1).padStart(2, "0")
            + "-" + String(today.getDate()).padStart(2, "0");

        if (checkInInput) {
            checkInInput.min = todayText;
        }

        if (checkOutInput) {
            checkOutInput.min = todayText;
        }

        function syncGuests() {
            const adults = parseInt(adultsInput.value || "0", 10);
            const children = parseInt(childrenInput.value || "0", 10);
            guestsInput.value = Math.max(1, adults + children);
        }

        if (checkInInput && checkOutInput) {
            checkInInput.addEventListener("change", function () {
                checkOutInput.min = checkInInput.value || todayText;

                if (checkOutInput.value && checkOutInput.value <= checkInInput.value) {
                    checkOutInput.value = "";
                }
            });
        }

        if (adultsInput && childrenInput && guestsInput) {
            adultsInput.addEventListener("input", syncGuests);
            childrenInput.addEventListener("input", syncGuests);
        }

        if (form) {
            form.addEventListener("submit", function (event) {
                if (!checkInInput.value || !checkOutInput.value) {
                    event.preventDefault();
                    alert("Vui lòng chọn ngày nhận phòng và ngày trả phòng.");
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
