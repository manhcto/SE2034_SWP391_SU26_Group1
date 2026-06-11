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

        .room-card {
            border: 1px solid var(--border);
            border-radius: 22px;
            overflow: hidden;
            background: white;
            height: 100%;
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
        }

        .section-card {
            padding: 24px;
            margin-top: 24px;
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
                <img class="hero-img" src="${accommodation.image}" alt="${accommodation.name}"
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
                                    <span class="facility-pill">${f.icon} ${f.facilityName}</span>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="section-card">
                <h2 class="section-title mt-0">
                    <i class="fa-solid fa-bed text-primary"></i>
                    Phòng đang có sẵn
                </h2>

                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty roomList}">
                            <div class="col-12 text-center text-muted py-4">
                                Hiện chưa có phòng phù hợp.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${roomList}">
                                <div class="col-lg-6">
                                    <div class="room-card">
                                        <img class="room-img" src="${r.image}" alt="${r.roomType}"
                                             onerror="this.src='https://placehold.co/800x500?text=WonderVN+Room';">

                                        <div class="room-body">
                                            <div class="room-title">${r.roomType}</div>
                                            <div class="text-muted">${r.description}</div>

                                            <div class="room-specs">
                                                <span class="pill"><i class="fa-solid fa-bed me-1"></i>${r.bedCount} ${r.displayBedType}</span>
                                                <span class="pill"><i class="fa-solid fa-user me-1"></i>${r.maxAdults} người lớn</span>
                                                <span class="pill"><i class="fa-solid fa-child me-1"></i>${r.maxChildren} trẻ em</span>
                                                <span class="pill"><i class="fa-solid fa-ruler-combined me-1"></i>${r.roomSize} m²</span>
                                            </div>

                                            <c:if test="${not empty r.facilityList}">
                                                <div class="facility-wrap my-3">
                                                    <c:forEach var="rf" items="${r.facilityList}" varStatus="st">
                                                        <c:if test="${st.index < 4}">
                                                            <span class="facility-pill">${rf.icon} ${rf.facilityName}</span>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </c:if>

                                            <div class="d-flex justify-content-between align-items-end mt-3">
                                                <div>
                                                    <div class="price-main fs-4">
                                                        <fmt:formatNumber value="${r.priceOfRoom}" type="number" maxFractionDigits="0"/> đ
                                                    </div>
                                                    <div class="text-muted small">
                                                        Còn ${r.roomAvailability} phòng
                                                    </div>
                                                </div>

                                                <button class="btn btn-primary rounded-4 fw-bold">
                                                    Chọn phòng
                                                </button>
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

            <div class="border rounded-4 p-3 mt-4 bg-light">
                <div class="fw-bold mb-1">Địa điểm</div>
                <div>${accommodation.province}</div>
                <div class="text-muted">${accommodation.district}</div>
            </div>

            <div class="border rounded-4 p-3 mt-3 bg-light">
                <div class="fw-bold mb-1">Thời gian</div>
                <div>Nhận phòng: ${accommodation.checkInText}</div>
                <div>Trả phòng: ${accommodation.checkOutText}</div>
            </div>

            <button class="btn-book">
                <i class="fa-solid fa-cart-plus me-2"></i>
                Thêm vào giỏ đặt phòng
            </button>

            <a class="btn-list" href="${pageContext.request.contextPath}/accommodation">
                <i class="fa-solid fa-list"></i>
                Xem danh sách lưu trú
            </a>
        </aside>
    </div>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>