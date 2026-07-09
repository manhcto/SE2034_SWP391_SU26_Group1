<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | ${room.roomType}</title>

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

        .room-detail-page {
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

        .room-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 370px;
            gap: 26px;
            align-items: start;
        }

        .main-card,
        .booking-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 26px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .room-img {
            height: 430px;
            width: 100%;
            object-fit: cover;
            background: #e2e8f0;
        }

        .main-content {
            padding: 28px;
        }

        .room-badge {
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

        .sub-text {
            color: var(--muted);
            line-height: 1.7;
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

        .section-title {
            font-size: 22px;
            font-weight: 900;
            color: var(--dark);
            margin: 28px 0 12px;
            display: flex;
            align-items: center;
            gap: 10px;
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
            font-size: 34px;
            font-weight: 900;
            color: var(--dark);
            line-height: 1.1;
        }

        .booking-box {
            border: 1px solid var(--border);
            background: var(--soft);
            border-radius: 18px;
            padding: 16px;
            margin-top: 18px;
        }

        .booking-search-form {
            display: grid;
            gap: 12px;
            margin-bottom: 16px;
        }

        .booking-search-form label {
            color: var(--dark);
            font-size: 13px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .booking-search-form .form-control {
            height: 46px;
            border-radius: 14px;
            border: 1px solid #dbe3ef;
            font-weight: 700;
        }

        .booking-form-grid {
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

        .booking-line {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #475569;
            font-weight: 700;
        }

        .booking-line:last-child {
            border-bottom: none;
        }

        .booking-line span:first-child {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .booking-line i {
            color: var(--primary);
            width: 18px;
        }

        .booking-line strong {
            color: var(--dark);
            text-align: right;
        }

        .total-box {
            margin-top: 18px;
            padding: 16px;
            border-radius: 18px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

        .total-label {
            color: #1e3a8a;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .total-value {
            font-size: 26px;
            font-weight: 950;
            color: #1d4ed8;
        }

        .btn-direct-book {
            width: 100%;
            border: none;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            border-radius: 16px;
            padding: 14px 18px;
            font-weight: 900;
            margin-top: 16px;
        }

        .btn-direct-book:hover {
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

        .missing-date-alert {
            background: #fff7ed;
            border: 1px solid #fed7aa;
            color: #9a3412;
            border-radius: 18px;
            padding: 14px 16px;
            margin-top: 16px;
            font-weight: 800;
            line-height: 1.6;
        }

        .missing-date-alert i {
            color: #f97316;
            margin-right: 6px;
        }

        @media (max-width: 1100px) {
            .room-layout {
                grid-template-columns: 1fr;
            }

            .booking-card {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .room-img {
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

<div class="container room-detail-page">

    <div class="breadcrumb-line">
        <button type="button" class="btn-back-page" onclick="history.back()">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại trang lưu trú
        </button>

        <a href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-house"></i> Trang chủ
        </a>
        <span>/</span>

        <a href="${pageContext.request.contextPath}/accommodation">Khách sạn</a>
        <span>/</span>

        <a href="${pageContext.request.contextPath}/accommodation/detail?id=${accommodation.accommodationID}&checkIn=${checkIn}&checkOut=${checkOut}&adults=${adults}&children=${children}&rooms=${rooms}&guests=${guests}">
            ${accommodation.name}
        </a>
        <span>/</span>

        <span>${room.roomType}</span>
    </div>

    <c:if test="${not empty param.status}">
        <c:choose>
            <c:when test="${param.status == 'bookingSuccess'}">
                <div class="alert alert-success rounded-4 border-0 shadow-sm">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    Đặt phòng thành công. Phòng đã được ghi nhận theo ngày bạn chọn.
                </div>
            </c:when>
            <c:when test="${param.status == 'roomUnavailable'}">
                <div class="alert alert-warning rounded-4 border-0 shadow-sm">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    Phòng vừa được người khác đặt hoặc không còn đủ số lượng cho ngày này.
                </div>
            </c:when>
            <c:when test="${param.status == 'invalidBooking'}">
                <div class="alert alert-danger rounded-4 border-0 shadow-sm">
                    <i class="fa-solid fa-circle-xmark me-2"></i>
                    Thông tin đặt phòng chưa hợp lệ. Vui lòng kiểm tra lại ngày và số phòng.
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-danger rounded-4 border-0 shadow-sm">
                    <i class="fa-solid fa-circle-xmark me-2"></i>
                    Chưa thể đặt phòng lúc này. Vui lòng thử lại sau.
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <div class="room-layout">
        <div>
            <div class="main-card">
                <img class="room-img"
                     src="${room.image}"
                     alt="${room.roomType}"
                     onerror="this.src='https://placehold.co/1200x700?text=WonderVN+Room';">

                <div class="main-content">
                    <div class="room-badge">
                        <i class="fa-solid fa-bed"></i>
                        Chi tiết phòng
                    </div>

                    <h1 class="title">${room.roomType}</h1>

                    <div class="sub-text">
                        ${room.description}
                    </div>

                    <div class="info-grid">
                        <div class="info-card">
                            <i class="fa-solid fa-bed"></i>
                            <div class="info-label">Loại giường</div>
                            <div class="info-value">${room.bedCount} ${room.displayBedType}</div>
                        </div>

                        <div class="info-card">
                            <i class="fa-solid fa-user"></i>
                            <div class="info-label">Người lớn</div>
                            <div class="info-value">${room.maxAdults} người lớn</div>
                        </div>

                        <div class="info-card">
                            <i class="fa-solid fa-child"></i>
                            <div class="info-label">Trẻ em</div>
                            <div class="info-value">${room.maxChildren} trẻ em</div>
                        </div>

                        <div class="info-card">
                            <i class="fa-solid fa-ruler-combined"></i>
                            <div class="info-label">Diện tích</div>
                            <div class="info-value">${room.roomSize} m²</div>
                        </div>
                    </div>

                    <h2 class="section-title">
                        <i class="fa-solid fa-wand-magic-sparkles text-primary"></i>
                        Tiện ích phòng
                    </h2>

                    <div class="facility-wrap">
                        <c:choose>
                            <c:when test="${empty room.facilityList}">
                                <span class="text-muted">Chưa có thông tin tiện ích phòng.</span>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="rf" items="${room.facilityList}">
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
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h2 class="section-title">
                        <i class="fa-solid fa-hotel text-primary"></i>
                        Thuộc nơi lưu trú
                    </h2>

                    <div class="sub-text mb-0">
                        <strong>${accommodation.name}</strong><br>
                        ${accommodation.fullAddress}
                    </div>
                </div>
            </div>
        </div>

        <aside class="booking-card">
            <div class="text-muted fw-bold mb-2">Giá phòng</div>

            <div class="price-main">
                <fmt:formatNumber value="${room.priceOfRoom}" type="number" maxFractionDigits="0"/> đ
            </div>
            <div class="text-muted">/ đêm</div>

            <div class="booking-box">
                <div class="fw-bold mb-3">Thông tin đặt phòng</div>

                <form class="booking-search-form"
                      id="roomStayForm"
                      action="${pageContext.request.contextPath}/accommodation/room/detail"
                      method="get">
                    <input type="hidden" name="id" value="${room.roomID}">
                    <input type="hidden" name="accommodationId" value="${accommodation.accommodationID}">

                    <div>
                        <label for="roomCheckIn">Ngày nhận phòng</label>
                        <input type="date"
                               class="form-control"
                               id="roomCheckIn"
                               name="checkIn"
                               value="${checkIn}"
                               required>
                    </div>

                    <div>
                        <label for="roomCheckOut">Ngày trả phòng</label>
                        <input type="date"
                               class="form-control"
                               id="roomCheckOut"
                               name="checkOut"
                               value="${checkOut}"
                               required>
                    </div>

                    <div class="booking-form-grid">
                        <div>
                            <label for="roomAdults">Người lớn</label>
                            <input type="number"
                                   class="form-control"
                                   id="roomAdults"
                                   name="adults"
                                   min="1"
                                   value="${empty adults ? 2 : adults}"
                                   required>
                        </div>

                        <div>
                            <label for="roomChildren">Trẻ em</label>
                            <input type="number"
                                   class="form-control"
                                   id="roomChildren"
                                   name="children"
                                   min="0"
                                   value="${empty children ? 0 : children}"
                                   required>
                        </div>

                        <div>
                            <label for="roomQuantity">Số phòng</label>
                            <input type="number"
                                   class="form-control"
                                   id="roomQuantity"
                                   name="rooms"
                                   min="1"
                                   max="${room.roomAvailability}"
                                   value="${empty rooms ? 1 : rooms}"
                                   required>
                        </div>

                        <div>
                            <label for="roomGuests">Tổng khách</label>
                            <input type="number"
                                   class="form-control"
                                   id="roomGuests"
                                   name="guests"
                                   min="1"
                                   value="${empty guests ? 2 : guests}"
                                   required>
                        </div>
                    </div>

                    <button type="submit" class="btn-update-stay">
                        <i class="fa-solid fa-calendar-check me-2"></i>
                        Cập nhật lịch lưu trú
                    </button>
                </form>

                <c:choose>
                    <c:when test="${not empty checkIn && not empty checkOut}">
                        <div class="booking-line">
                            <span>
                                <i class="fa-solid fa-calendar-check"></i>
                                Ngày nhận phòng
                            </span>
                            <strong>${checkIn}</strong>
                        </div>

                        <div class="booking-line">
                            <span>
                                <i class="fa-solid fa-calendar-xmark"></i>
                                Ngày trả phòng
                            </span>
                            <strong>${checkOut}</strong>
                        </div>

                        <div class="booking-line">
                            <span>
                                <i class="fa-solid fa-moon"></i>
                                Số đêm
                            </span>
                            <strong>${nights} đêm</strong>
                        </div>

                        <div class="booking-line">
                            <span>
                                <i class="fa-solid fa-bed"></i>
                                Số phòng
                            </span>
                            <strong>${rooms} phòng</strong>
                        </div>

                        <div class="booking-line">
                            <span>
                                <i class="fa-solid fa-user-group"></i>
                                Số khách
                            </span>
                            <strong>${adults} người lớn, ${children} trẻ em</strong>
                        </div>

                        <div class="booking-line">
                            <span>
                                <i class="fa-solid fa-door-open"></i>
                                Phòng còn trống
                            </span>
                            <strong>${room.roomAvailability} phòng</strong>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="missing-date-alert">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Bạn chưa chọn ngày nhận phòng và ngày trả phòng. Chọn lịch ngay tại đây để xem tạm tính và thanh toán đặt phòng.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty checkIn && not empty checkOut}">
                <div class="total-box">
                    <div class="total-label">Tổng tiền tạm tính</div>
                    <div class="total-value">
                        <fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0"/> đ
                    </div>
                </div>

                <form id="roomBookingForm"
                      action="${pageContext.request.contextPath}/booking/accommodation/form"
                      method="get"
                      class="m-0">
                    <input type="hidden" name="accommodationID" value="${accommodation.accommodationID}">
                    <input type="hidden" name="roomID" value="${room.roomID}">
                    <input type="hidden" name="checkIn" value="${checkIn}">
                    <input type="hidden" name="checkOut" value="${checkOut}">
                    <input type="hidden" name="adults" value="${adults}">
                    <input type="hidden" name="children" value="${children}">
                    <input type="hidden" name="rooms" value="${rooms}">
                    <input type="hidden" name="guests" value="${guests}">

                    <button type="submit" class="btn-direct-book">
                        <i class="fa-solid fa-credit-card me-2"></i>
                        Thanh toán
                    </button>
                </form>

            </c:if>

            <a class="btn-list"
               href="${pageContext.request.contextPath}/accommodation/detail?id=${accommodation.accommodationID}&checkIn=${checkIn}&checkOut=${checkOut}&adults=${adults}&children=${children}&rooms=${rooms}&guests=${guests}">
                <i class="fa-solid fa-arrow-left"></i>
                Quay lại lưu trú
            </a>
        </aside>
    </div>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("roomStayForm");
        const checkInInput = document.getElementById("roomCheckIn");
        const checkOutInput = document.getElementById("roomCheckOut");
        const adultsInput = document.getElementById("roomAdults");
        const childrenInput = document.getElementById("roomChildren");
        const guestsInput = document.getElementById("roomGuests");

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
