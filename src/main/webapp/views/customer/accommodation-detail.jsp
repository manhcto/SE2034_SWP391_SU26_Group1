<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết lưu trú</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            color: #0f172a;
        }

        .detail-shell {
            max-width: 1240px;
            margin: 40px auto 70px;
            padding: 0 20px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #1d4ed8;
            font-weight: 800;
            margin-bottom: 18px;
        }

        .hero-card {
            background: #fff;
            border-radius: 32px;
            overflow: hidden;
            box-shadow: 0 22px 50px rgba(15, 23, 42, 0.12);
            margin-bottom: 30px;
        }

        .hero-image {
            position: relative;
            height: 480px;
            overflow: hidden;
            background: #e5e7eb;
        }

        .hero-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .hero-overlay {
            position: absolute;
            inset: auto 24px 24px 24px;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 22px 24px;
            box-shadow: 0 16px 40px rgba(15, 23, 42, 0.12);
        }

        .hero-overlay-top {
            display: flex;
            justify-content: space-between;
            gap: 18px;
            align-items: flex-start;
        }

        .hero-overlay h1 {
            margin: 0 0 8px;
            font-size: 42px;
            line-height: 1.2;
            font-weight: 800;
        }

        .hero-badge {
            display: inline-flex;
            gap: 8px;
            align-items: center;
            padding: 10px 14px;
            border-radius: 999px;
            background: #eff6ff;
            color: #2563eb;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .hero-rate {
            white-space: nowrap;
            font-weight: 800;
            font-size: 20px;
        }

        .hero-rate i {
            color: #facc15;
        }

        .hero-location {
            color: #64748b;
            font-size: 16px;
            margin-top: 6px;
        }

        .hero-location i {
            color: #0ea5e9;
            margin-right: 8px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 28px;
            margin-bottom: 32px;
        }

        .info-card,
        .side-card,
        .room-card {
            background: #fff;
            border-radius: 28px;
            box-shadow: 0 18px 42px rgba(15, 23, 42, 0.08);
            padding: 28px;
        }

        .info-card h2,
        .side-card h3,
        .room-section h2 {
            margin-top: 0;
            margin-bottom: 16px;
            font-weight: 800;
        }

        .info-card p {
            color: #475569;
            line-height: 1.9;
            font-size: 16px;
        }

        .side-list {
            display: grid;
            gap: 14px;
        }

        .side-item {
            padding: 14px 16px;
            border-radius: 18px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }

        .side-item small {
            display: block;
            color: #64748b;
            margin-bottom: 5px;
            font-weight: 700;
        }

        .side-item strong {
            color: #0f172a;
            font-size: 15px;
        }

        .room-section h2 {
            font-size: 34px;
            margin-bottom: 20px;
        }

        .room-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .room-card {
            padding: 24px;
            transition: all 0.25s ease;
        }

        .room-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 22px 45px rgba(15, 23, 42, 0.12);
        }

        .room-icon {
            width: 60px;
            height: 60px;
            border-radius: 18px;
            background: linear-gradient(135deg, #0f172a, #2563eb);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            margin-bottom: 16px;
        }

        .room-card h3 {
            margin: 0 0 14px;
            font-size: 24px;
            font-weight: 800;
        }

        .room-meta {
            display: grid;
            gap: 10px;
            margin-bottom: 18px;
        }

        .room-meta div {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 8px;
            color: #475569;
        }

        .room-price {
            font-size: 34px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .room-note {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .book-btn {
            width: 100%;
            border: none;
            border-radius: 16px;
            background: linear-gradient(135deg, #0f172a, #1d4ed8);
            color: white;
            padding: 14px 16px;
            font-weight: 800;
        }

        .book-btn:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
        }

        .empty-box {
            background: #fff;
            border-radius: 24px;
            text-align: center;
            padding: 50px 20px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
        }

        @media (max-width: 992px) {
            .detail-grid,
            .room-grid {
                grid-template-columns: 1fr;
            }

            .hero-image {
                height: 340px;
            }

            .hero-overlay h1 {
                font-size: 30px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/common/homepage/header.jsp" />

<section class="detail-shell">
    <a class="back-link" href="${pageContext.request.contextPath}/accommodation">
        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách lưu trú
    </a>

    <div class="hero-card">
        <div class="hero-image">
            <img src="${accommodation.image}" alt="${accommodation.name}"
                 onerror="this.src='https://placehold.co/1200x700?text=WonderVN+Accommodation';">

            <div class="hero-overlay">
                <div class="hero-overlay-top">
                    <div>
                        <div class="hero-badge">
                            <i class="fa-solid fa-hotel"></i> ${accommodation.type}
                        </div>
                        <h1>${accommodation.name}</h1>
                        <div class="hero-location">
                            <i class="fa-solid fa-location-dot"></i> ${accommodation.address}
                        </div>
                    </div>

                    <div class="hero-rate">
                        <i class="fa-solid fa-star"></i> ${accommodation.rate}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="detail-grid">
        <div class="info-card">
            <h2>Thông tin nơi lưu trú</h2>
            <p>${accommodation.description}</p>
        </div>

        <div class="side-card">
            <h3>Thông tin nhanh</h3>
            <div class="side-list">
                <div class="side-item">
                    <small>Điện thoại</small>
                    <strong>${accommodation.phone}</strong>
                </div>
                <div class="side-item">
                    <small>Check-in</small>
                    <strong>${accommodation.checkInTime}</strong>
                </div>
                <div class="side-item">
                    <small>Check-out</small>
                    <strong>${accommodation.checkOutTime}</strong>
                </div>
                <div class="side-item">
                    <small>Trạng thái</small>
                    <strong>${accommodation.status}</strong>
                </div>
                <div class="side-item">
                    <small>Mã dịch vụ</small>
                    <strong>#${accommodation.serviceID}</strong>
                </div>
            </div>
        </div>
    </div>

    <div class="room-section">
        <h2>Danh sách phòng</h2>

        <c:choose>
            <c:when test="${empty roomList}">
                <div class="empty-box">
                    <h3>Hiện chưa có phòng khả dụng</h3>
                    <p>Vui lòng quay lại sau hoặc chọn nơi lưu trú khác.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="room-grid">
                    <c:forEach var="room" items="${roomList}">
                        <div class="room-card">
                            <div class="room-icon">
                                <i class="fa-solid fa-bed"></i>
                            </div>

                            <h3>${room.roomType}</h3>

                            <div class="room-meta">
                                <div><span>Tổng số phòng</span><strong>${room.numberOfRooms}</strong></div>
                                <div><span>Còn trống</span><strong>${room.roomAvailability}</strong></div>
                                <div><span>Trạng thái</span><strong>${room.status}</strong></div>
                            </div>

                            <div class="room-price">
                                <fmt:formatNumber value="${room.priceOfRoom}" type="number" maxFractionDigits="0"/> đ
                            </div>
                            <div class="room-note">mỗi đêm</div>

                            <c:choose>
                                <c:when test="${room.status == 'Available' && room.roomAvailability > 0}">
                                    <button class="book-btn" type="button"
                                            onclick="alert('Chức năng thêm vào giỏ hàng sẽ làm ở bước tiếp theo.');">
                                        Thêm vào giỏ hàng
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="book-btn" type="button" disabled>Hết phòng</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="/WEB-INF/common/homepage/footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>