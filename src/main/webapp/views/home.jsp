<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">

    <style>
        .real-tour-image img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .empty-box { padding: 28px; border-radius: 24px; background: #fff; border: 1px dashed #cbd5e1; color: #64748b; font-weight: 800; text-align: center; }
    </style>
</head>
<body>

<jsp:include page="/views/common/client-header.jsp" />

<main class="home-page">

    <section class="hero-v2">
        <div class="hero-bg-shape hero-shape-one"></div>
        <div class="hero-bg-shape hero-shape-two"></div>

        <div class="home-container hero-layout">
            <div class="hero-left">
                <div class="hero-pill">
                    <span>🇻🇳</span>
                    <strong>Khám phá Việt Nam cùng WonderVN</strong>
                </div>

                <h1>
                    Đặt tour, khách sạn,
                    thuê xe và dịch vụ cộng thêm
                    <span>dễ dàng hơn bao giờ hết</span>
                </h1>

                <p class="hero-desc">
                    Tìm chuyến đi phù hợp, chọn nơi lưu trú đẹp, thuê xe linh hoạt và quản lý hành trình
                    trong một hệ thống hiện đại, rõ giá, rõ lịch trình và thân thiện với khách hàng.
                </p>

                <div class="hero-actions">
                    <a class="hero-primary" href="${pageContext.request.contextPath}/tour">
                        Khám phá tour ngay
                    </a>
                    <a class="hero-secondary" href="${pageContext.request.contextPath}/accommodation">
                        Tìm khách sạn
                    </a>
                </div>

                <div class="hero-stats">
                    <div>
                        <strong>30+</strong>
                        <span>Tỉnh thành</span>
                    </div>
                    <div>
                        <strong>500+</strong>
                        <span>Dịch vụ du lịch</span>
                    </div>
                    <div>
                        <strong>24/7</strong>
                        <span>Hỗ trợ khách hàng</span>
                    </div>
                </div>

                <div class="search-panel">
                    <div class="search-tabs">
                        <button class="tab-btn active" type="button" data-tab="tour">Tour trọn gói</button>
                        <button class="tab-btn" type="button" data-tab="hotel">Khách sạn</button>
                    </div>
                    <form class="search-form" id="homeSearchForm" action="${pageContext.request.contextPath}/tour" method="get">
                        <input type="hidden" id="searchType" name="type" value="tour">

                        <label>
                            <span id="fieldOneLabel">Điểm khởi hành</span>
                            <select id="fieldOneInput" name="from">
                                <option value="">Tất cả điểm khởi hành</option>
                                <c:forEach var="place" items="${startPlaces}">
                                    <option value="${place}">${place}</option>
                                </c:forEach>
                            </select>
                        </label>

                        <label>
                            <span id="fieldTwoLabel">Điểm đến</span>
                            <select id="fieldTwoInput" name="destination">
                                <option value="">Chọn điểm đến</option>
                                <c:forEach var="place" items="${destinations}">
                                    <option value="${place}">${place}</option>
                                </c:forEach>
                            </select>
                        </label>

                        <label>
                            <span id="fieldThreeLabel">Ngày đi</span>
                            <input id="fieldThreeInput" type="date" name="startDate">
                        </label>

                        <button class="primary-btn" id="searchSubmitBtn" type="submit">
                            Tìm tour
                        </button>
                    </form>
                </div>
            </div>

            <div class="hero-right">
                <div class="hero-photo-card">
                    <img src="${pageContext.request.contextPath}/assets/images/home/hero-bana.png"
                         alt="Cầu Vàng Bà Nà Hills"
                         onerror="this.src='https://images.unsplash.com/photo-1566139397190-1ca967d5e58d?auto=format&fit=crop&w=1200&q=80';">

                    <div class="photo-gradient"></div>

                    <div class="floating-badge top">
                        <span>⭐</span>
                        <div>
                            <strong>4.9/5</strong>
                            <small>Trải nghiệm nổi bật</small>
                        </div>
                    </div>

                    <div class="floating-badge bottom">
                        <span>📍</span>
                        <div>
                            <strong>Bà Nà Hills, Đà Nẵng</strong>
                            <small>Check-in Cầu Vàng cực hot</small>
                        </div>
                    </div>
                </div>
                <div class="mini-card mini-card-one">
                    <span>🏨</span>
                    <strong>Khách sạn đẹp</strong>
                    <small>Tìm nhanh theo tiện ích</small>
                </div>

            </div>
        </div>
    </section>

    <section class="section quick-service-section">
        <div class="home-container">
            <div class="section-head">
                <div>
                    <p class="section-kicker">Dịch vụ WonderVN</p>
                    <h2>Chọn nhanh dịch vụ bạn cần</h2>
                    <p>Tập trung vào đặt tour và lưu trú với lịch trình, phòng trống và giá rõ ràng.</p>
                </div>
            </div>

            <div class="service-grid">
                <a class="service-card" href="${pageContext.request.contextPath}/tour">
                    <span class="service-icon">🧳</span>
                    <h3>Tour trọn gói</h3>
                    <p>Lịch trình rõ ràng, giá minh bạch, phù hợp nhóm bạn và gia đình.</p>
                </a>

                <a class="service-card" href="${pageContext.request.contextPath}/accommodation">
                    <span class="service-icon">🏨</span>
                    <h3>Khách sạn & Homestay</h3>
                    <p>Lọc theo địa điểm, tiện ích, số khách, giá phòng và đánh giá.</p>
                </a>

            </div>
        </div>
    </section>

    <section class="section">
        <div class="home-container">
            <div class="section-head">
                <div>
                    <p class="section-kicker">Tour nổi bật</p>
                    <h2>Hành trình được nhiều khách quan tâm</h2>
                    <p>Các tour nổi bật do WonderVN trực tiếp thiết kế và quản lý.</p>
                </div>
                <a class="outline-btn" href="${pageContext.request.contextPath}/tour">Xem thêm</a>
            </div>

            <c:choose>
                <c:when test="${empty featuredTours}">
                    <div class="empty-box">Hiện chưa có tour nổi bật đang mở bán.</div>
                </c:when>
                <c:otherwise>
                    <div class="tour-grid">
                        <c:forEach var="tour" items="${featuredTours}">
                            <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                            <c:set var="tourImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                            <c:if test="${not empty tour.image}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="tourImage" value="${tour.image}" /></c:when>
                                    <c:otherwise><c:set var="tourImage" value="${pageContext.request.contextPath}${tour.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <article class="tour-card">
                                <div class="tour-image real-tour-image">
                                    <img src="${tourImage}" alt="${tour.tourName}" onerror="this.src='${pageContext.request.contextPath}/assets/images/home/hero-bana.png';">
                                    <span>${empty tour.regionName ? 'WonderVN' : tour.regionName}</span>
                                </div>
                                <div class="tour-body">
                                    <h3>${tour.tourName}</h3>
                                    <p>Khởi hành: ${tour.startPlace}</p>
                                    <p>Thời lượng: ${tour.numberOfDay} ngày <c:if test="${not empty tour.numberOfNights}">${tour.numberOfNights} đêm</c:if></p>
                                    <p>Lịch gần nhất: <fmt:formatDate value="${firstSchedule.startDate}" pattern="dd/MM/yyyy" /></p>
                                    <div class="tour-price-row">
                                        <div>
                                            <span>Giá từ</span>
                                            <strong><fmt:formatNumber value="${not empty firstSchedule.adultPrice ? firstSchedule.adultPrice : tour.adultPrice}" pattern="#,#00" />đ</strong>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">Xem chi tiết</a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="section package-section">
        <div class="home-container">
            <div class="section-head">
                <div>
                    <p class="section-kicker">Tour đang mở bán</p>
                    <h2>Tour do WonderVN trực tiếp thiết kế và vận hành</h2>
                    <p>Chia nhanh theo miền để khách chọn điểm đến phù hợp, vẫn giữ một danh sách chung ngay trên trang chủ.</p>
                </div>
                <a class="outline-btn" href="${pageContext.request.contextPath}/tours">Xem thêm</a>
            </div>

            <div class="region-tour-grid">
                <article class="region-tour-panel">
                    <div class="region-panel-head">
                        <span>⛰️</span>
                        <div>
                            <h3>Tour miền Bắc</h3>
                            <p>Hạ Long, Ninh Bình, Sa Pa, Hà Giang...</p>
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${empty northTours}">
                            <div class="mini-empty">Chưa có tour miền Bắc đang mở bán.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="region-mini-list">
                                <c:forEach var="tour" items="${northTours}">
                                    <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                                    <a class="region-mini-card" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                        <strong>${tour.tourName}</strong>
                                        <span>${tour.numberOfDay} ngày • từ <fmt:formatNumber value="${not empty firstSchedule.adultPrice ? firstSchedule.adultPrice : tour.adultPrice}" pattern="#,#00" />đ</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </article>

                <article class="region-tour-panel">
                    <div class="region-panel-head">
                        <span>🌉</span>
                        <div>
                            <h3>Tour miền Trung</h3>
                            <p>Đà Nẵng, Huế, Hội An, Nha Trang...</p>
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${empty centralTours}">
                            <div class="mini-empty">Chưa có tour miền Trung đang mở bán.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="region-mini-list">
                                <c:forEach var="tour" items="${centralTours}">
                                    <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                                    <a class="region-mini-card" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                        <strong>${tour.tourName}</strong>
                                        <span>${tour.numberOfDay} ngày • từ <fmt:formatNumber value="${not empty firstSchedule.adultPrice ? firstSchedule.adultPrice : tour.adultPrice}" pattern="#,#00" />đ</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </article>

                <article class="region-tour-panel">
                    <div class="region-panel-head">
                        <span>🏝️</span>
                        <div>
                            <h3>Tour miền Nam</h3>
                            <p>Phú Quốc, Vũng Tàu, Cần Thơ, Cà Mau...</p>
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${empty southTours}">
                            <div class="mini-empty">Chưa có tour miền Nam đang mở bán.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="region-mini-list">
                                <c:forEach var="tour" items="${southTours}">
                                    <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                                    <a class="region-mini-card" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                        <strong>${tour.tourName}</strong>
                                        <span>${tour.numberOfDay} ngày • từ <fmt:formatNumber value="${not empty firstSchedule.adultPrice ? firstSchedule.adultPrice : tour.adultPrice}" pattern="#,#00" />đ</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </article>
            </div>

            <div class="section-subhead">
                <div>
                    <h3>Tour trọn gói mới nhất</h3>
                    <p>Danh sách 10 tour đang mở bán trên hệ thống.</p>
                </div>
            </div>

            <div class="filter-list">
                <button class="filter-btn active" type="button" data-region="all">Tất cả</button>
                <button class="filter-btn" type="button" data-region="Miền Bắc">Miền Bắc</button>
                <button class="filter-btn" type="button" data-region="Miền Trung">Miền Trung</button>
                <button class="filter-btn" type="button" data-region="Miền Nam">Miền Nam</button>
            </div>

            <c:choose>
                <c:when test="${empty packageTours}">
                    <div class="empty-box">Chưa có tour trọn gói đang mở bán.</div>
                </c:when>
                <c:otherwise>
                    <div class="tour-grid">
                        <c:forEach var="tour" items="${packageTours}">
                            <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                            <c:set var="tourImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                            <c:if test="${not empty tour.image}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="tourImage" value="${tour.image}" /></c:when>
                                    <c:otherwise><c:set var="tourImage" value="${pageContext.request.contextPath}${tour.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <article class="tour-card package-card" data-region="${tour.regionName}">
                                <div class="tour-image real-tour-image">
                                    <img src="${tourImage}" alt="${tour.tourName}" onerror="this.src='${pageContext.request.contextPath}/assets/images/home/hero-bana.png';">
                                    <span>${empty tour.regionName ? 'WonderVN' : tour.regionName}</span>
                                </div>
                                <div class="tour-body">
                                    <h3>${tour.tourName}</h3>
                                    <p>Mã chương trình: <strong>${tour.tourCode}</strong></p>
                                    <p>Khởi hành: ${tour.startPlace}</p>
                                    <p>Thời lượng: ${tour.numberOfDay} ngày <c:if test="${not empty tour.numberOfNights}">${tour.numberOfNights} đêm</c:if></p>
                                    <div class="date-list">
                                        <c:forEach var="schedule" items="${tour.scheduleList}">
                                            <span><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM" /></span>
                                        </c:forEach>
                                    </div>
                                    <div class="tour-price-row">
                                        <div><span>Giá từ</span><strong><fmt:formatNumber value="${not empty firstSchedule.adultPrice ? firstSchedule.adultPrice : tour.adultPrice}" pattern="#,#00" />đ</strong></div>
                                        <a href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">Xem chi tiết</a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="popular-searches">
                <span>Tìm kiếm nổi bật:</span>
                <c:forEach var="place" items="${destinations}" begin="0" end="5">
                    <a href="${pageContext.request.contextPath}/tour?destination=${place}">${place}</a>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<c:if test="${not empty sessionScope.successMessage}">
    <div id="successToast" class="success-toast">
        <div class="toast-body">
            <div class="toast-icon">✓</div>
            <div class="toast-content">
                <span class="toast-title">Đặt Tour Thành Công!</span>
                <p class="toast-desc">${sessionScope.successMessage}</p>
            </div>
            <button type="button" class="toast-close-btn" onclick="dismissToast()">×</button>
        </div>
        <div class="toast-progress"></div>
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>

</body>
</html>
