<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | ${tour.tourName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">
    <style>
        .tour-detail-page { padding: 34px 0 76px; }
        .detail-hero {
            overflow: hidden;
            border-radius: 34px;
            background: #ffffff;
            border: 1px solid #e6edf7;
            box-shadow: 0 18px 44px rgba(15, 23, 42, 0.09);
            margin-bottom: 28px;
        }
        .detail-hero-img { position: relative; height: 430px; background: #dbeafe; }
        .detail-hero-img img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .detail-hero-img::after { content: ""; position: absolute; inset: 0; background: linear-gradient(180deg, rgba(15,23,42,0.08), rgba(15,23,42,0.62)); }
        .detail-hero-content { position: absolute; left: 30px; right: 30px; bottom: 28px; z-index: 2; color: #fff; }
        .detail-hero-content h1 { margin: 10px 0 10px; font-size: 42px; line-height: 1.14; max-width: 920px; }
        .detail-tags { display: flex; flex-wrap: wrap; gap: 9px; }
        .detail-tags span { padding: 8px 12px; border-radius: 999px; background: rgba(255,255,255,0.18); backdrop-filter: blur(10px); font-weight: 900; font-size: 13px; }
        .detail-layout { display: grid; grid-template-columns: minmax(0, 1fr) 380px; gap: 26px; align-items: start; }
        .detail-card { background: #fff; border: 1px solid #e6edf7; border-radius: 28px; padding: 26px; box-shadow: 0 12px 28px rgba(15,23,42,0.07); margin-bottom: 24px; }
        .detail-card h2 { margin: 0 0 16px; color: #0f172a; font-size: 26px; }
        .info-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
        .info-item { padding: 15px; border-radius: 18px; background: #f8fafc; border: 1px solid #e5eaf3; }
        .info-item span { display: block; color: #64748b; font-size: 12px; font-weight: 900; text-transform: uppercase; margin-bottom: 5px; }
        .info-item strong { color: #0f172a; }
        .highlight-box { white-space: pre-line; line-height: 1.8; color: #334155; font-weight: 650; }
        .intro-image { width: 100%; max-height: 360px; object-fit: cover; border-radius: 22px; margin-top: 16px; }
        .itinerary-list { display: grid; gap: 16px; }
        .itinerary-item { border: 1px solid #e5eaf3; border-radius: 24px; overflow: hidden; background: #ffffff; }
        .itinerary-img { width: 100%; height: 240px; object-fit: cover; display: block; background: #dbeafe; }
        .itinerary-body { padding: 20px; }
        .itinerary-body h3 { margin: 0 0 10px; color: #0f172a; }
        .itinerary-body p { margin: 0; color: #475569; line-height: 1.75; white-space: pre-line; font-weight: 650; }
        .schedule-list { display: grid; gap: 14px; }
        .schedule-card { border: 1px solid #e5eaf3; border-radius: 22px; padding: 18px; background: #f8fafc; }
        .schedule-card h3 { margin: 0 0 10px; color: #0f172a; font-size: 18px; }
        .schedule-meta { display: grid; gap: 7px; color: #475569; font-weight: 750; font-size: 14px; }
        .schedule-price { margin-top: 12px; color: #ea580c; font-size: 24px; font-weight: 950; }
        .schedule-card form { margin-top: 14px; }
        .book-btn { width: 100%; height: 46px; border: 0; border-radius: 15px; color: #fff; background: linear-gradient(135deg, #2563eb, #1d4ed8); font-weight: 950; cursor: pointer; }
        .back-row { display: flex; justify-content: space-between; gap: 12px; margin-bottom: 18px; }
        .back-link { display: inline-flex; height: 44px; align-items: center; justify-content: center; border-radius: 999px; padding: 0 16px; background: #fff; border: 1px solid #c7d8ff; color: #1d4ed8; font-weight: 900; }
        .empty-box { padding: 22px; border-radius: 20px; background: #fff7ed; border: 1px solid #fed7aa; color: #9a3412; font-weight: 800; }
        @media (max-width: 1020px) { .detail-layout { grid-template-columns: 1fr; } .detail-hero-img { height: 360px; } }
        @media (max-width: 720px) { .info-grid { grid-template-columns: 1fr; } .detail-hero-content h1 { font-size: 30px; } .detail-hero-content { left: 20px; right: 20px; } }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<c:set var="heroImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
<c:if test="${not empty tour.image}">
    <c:choose>
        <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="heroImage" value="${tour.image}" /></c:when>
        <c:otherwise><c:set var="heroImage" value="${pageContext.request.contextPath}${tour.image}" /></c:otherwise>
    </c:choose>
</c:if>

<main class="tour-detail-page">
    <div class="home-container">
        <div class="back-row">
            <a class="back-link" href="${pageContext.request.contextPath}/tour">← Danh sách tour</a>
            <a class="back-link" href="${pageContext.request.contextPath}/home">Trang chủ</a>
        </div>

        <section class="detail-hero">
            <div class="detail-hero-img">
                <img src="${heroImage}" alt="${tour.tourName}" onerror="this.src='${pageContext.request.contextPath}/assets/images/home/hero-bana.png';">
                <div class="detail-hero-content">
                    <div class="detail-tags">
                        <span>${tour.displayTourType}</span>
                        <span>${tour.regionName}</span>
                        <span>${tour.numberOfDay} ngày <c:if test="${not empty tour.numberOfNights}">${tour.numberOfNights} đêm</c:if></span>
                    </div>
                    <h1>${tour.tourName}</h1>
                    <div class="detail-tags">
                        <span>Mã tour: ${tour.tourCode}</span>
                        <span>Khởi hành: ${tour.startPlace}</span>
                        <span>Điểm đến: ${tour.endPlace}</span>
                    </div>
                </div>
            </div>
        </section>

        <div class="detail-layout">
            <div>
                <section class="detail-card">
                    <h2>Thông tin tour</h2>
                    <div class="info-grid">
                        <div class="info-item"><span>Điểm khởi hành</span><strong>${tour.startPlace}</strong></div>
                        <div class="info-item"><span>Điểm đến</span><strong>${tour.endPlace}</strong></div>
                        <div class="info-item"><span>Phương tiện</span><strong>${tour.mainTransportType}</strong></div>
                        <div class="info-item"><span>Thời lượng</span><strong>${tour.numberOfDay} ngày <c:if test="${not empty tour.numberOfNights}">${tour.numberOfNights} đêm</c:if></strong></div>
                        <div class="info-item"><span>Giá trẻ em 5-10 tuổi</span><strong><fmt:formatNumber value="${tour.childrenPrice}" pattern="#,#00" />đ</strong></div>
                        <div class="info-item"><span>Trẻ em dưới 5 tuổi</span><strong><fmt:formatNumber value="${tour.infantPrice}" pattern="#,#00" />đ</strong></div>
                    </div>
                </section>

                <c:if test="${not empty tour.tourInclude}">
                    <section class="detail-card">
                        <h2>Điểm nổi bật</h2>
                        <div class="highlight-box">${tour.tourInclude}</div>
                        <c:if test="${not empty tour.introImage}">
                            <c:set var="introImage" value="${pageContext.request.contextPath}${tour.introImage}" />
                            <c:if test="${fn:startsWith(tour.introImage, 'http')}"><c:set var="introImage" value="${tour.introImage}" /></c:if>
                            <img class="intro-image" src="${introImage}" alt="Ảnh giới thiệu tour" onerror="this.style.display='none';">
                        </c:if>
                    </section>
                </c:if>

                <section class="detail-card">
                    <h2>Lịch trình từng ngày</h2>
                    <c:choose>
                        <c:when test="${empty tour.itineraryList}">
                            <div class="empty-box">Tour này chưa cập nhật lịch trình chi tiết.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="itinerary-list">
                                <c:forEach var="item" items="${tour.itineraryList}">
                                    <article class="itinerary-item">
                                        <c:if test="${not empty item.imageUrl}">
                                            <c:set var="itemImage" value="${pageContext.request.contextPath}${item.imageUrl}" />
                                            <c:if test="${fn:startsWith(item.imageUrl, 'http')}"><c:set var="itemImage" value="${item.imageUrl}" /></c:if>
                                            <img class="itinerary-img" src="${itemImage}" alt="Ngày ${item.dayNumber}" onerror="this.style.display='none';">
                                        </c:if>
                                        <div class="itinerary-body">
                                            <h3>Ngày ${item.dayNumber}: ${item.title}</h3>
                                            <p>${item.description}</p>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>

            <aside>
                <section class="detail-card">
                    <h2>Lịch khởi hành</h2>
                    <c:choose>
                        <c:when test="${empty tour.scheduleList}">
                            <div class="empty-box">Tour hiện chưa có lịch khởi hành đang mở bán.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="schedule-list">
                                <c:forEach var="schedule" items="${tour.scheduleList}">
                                    <article class="schedule-card">
                                        <h3><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy" /></h3>
                                        <div class="schedule-meta">
                                            <div>Giờ đi: <fmt:formatDate value="${schedule.departureTime}" pattern="HH:mm" /></div>
                                            <div>Phương tiện: ${empty schedule.scheduleTransportType ? tour.mainTransportType : schedule.scheduleTransportType}</div>
                                            <div>Còn chỗ: ${schedule.remainingSeats}/${schedule.maxParticipants}</div>
                                        </div>
                                        <div class="schedule-price"><fmt:formatNumber value="${schedule.adultPrice}" pattern="#,#00" />đ</div>
                                        <form method="get" action="${pageContext.request.contextPath}/booking">
                                            <input type="hidden" name="tourScheduleID" value="${schedule.tourScheduleID}">
                                            <button class="book-btn" type="submit">Chọn lịch này</button>
                                        </form>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </aside>
        </div>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>
