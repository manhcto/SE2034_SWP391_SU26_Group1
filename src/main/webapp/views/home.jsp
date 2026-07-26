<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Khám phá Việt Nam</title>
    <meta name="description" content="Đặt tour và phòng lưu trú trên WonderVN với lịch khởi hành, giá và phòng trống rõ ràng.">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20260721">
    <style>
        .tour-showcase-section { padding: 58px 0; background: #ffffff; }
        .tour-showcase-section + .tour-showcase-section { padding-top: 16px; }
        .tour-showcase-head { margin-bottom: 14px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
        .tour-showcase-head h2 { margin: 0; color: #0b55a0; font-size: 20px; line-height: 1.25; font-weight: 800; text-transform: uppercase; }
        .tour-showcase-head a { color: #e6007e; font-size: 13px; font-weight: 700; text-decoration: none; white-space: nowrap; }
        .tour-rail-wrap { position: relative; }
        .tour-rail { display: grid; grid-auto-flow: column; grid-auto-columns: minmax(260px, 1fr); gap: 7px; overflow-x: auto; scroll-snap-type: x mandatory; scrollbar-width: none; padding-bottom: 4px; }
        .tour-rail::-webkit-scrollbar { display: none; }
        .home-tour-card { scroll-snap-align: start; min-width: 0; border: 1px solid #dddddd; background: #ffffff; text-decoration: none; color: #333333; display: flex; flex-direction: column; }
        .home-tour-card:hover { box-shadow: 0 10px 24px rgba(16,24,40,.12); transform: translateY(-2px); }
        .home-tour-image { position: relative; height: 172px; overflow: hidden; background: #e5e7eb; }
        .home-tour-image img { width: 100%; height: 100%; display: block; object-fit: cover; transition: transform .25s ease; }
        .home-tour-card:hover .home-tour-image img { transform: scale(1.04); }
        .home-tour-origin { position: absolute; left: 0; right: 0; bottom: 0; padding: 8px 10px; color: #ffffff; background: linear-gradient(180deg, transparent, rgba(0,0,0,.82)); font-size: 13px; font-weight: 800; }
        .home-tour-title { min-height: 58px; padding: 9px 10px; background: #eeeeee; color: #3f3f46; font-size: 16px; line-height: 1.32; font-weight: 800; text-transform: uppercase; display: -webkit-box; overflow: hidden; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .home-tour-body { padding: 12px 10px 14px; display: grid; gap: 7px; font-size: 13px; color: #3f3f46; }
        .home-tour-body span { display: flex; align-items: center; gap: 8px; }
        .home-tour-footer { margin-top: 2px; display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .home-tour-price { margin-left: auto; color: #175CD3; font-size: 17px; font-weight: 500; white-space: nowrap; }
        .tour-rail-btn { position: absolute; top: 68px; z-index: 2; width: 32px; height: 58px; border: 0; color: #ffffff; background: rgba(0,0,0,.38); font-size: 34px; line-height: 1; display: grid; place-items: center; cursor: pointer; }
        .tour-rail-btn:hover { background: rgba(0,0,0,.58); }
        .tour-rail-btn.prev { left: 0; }
        .tour-rail-btn.next { right: 0; }
        @media (min-width: 1180px) { .tour-rail { grid-auto-columns: calc((100% - 21px) / 4); } }
        @media (max-width: 760px) {
            .tour-showcase-section { padding: 38px 0; }
            .tour-rail { grid-auto-columns: minmax(250px, 82vw); }
            .tour-rail-btn { display: none; }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<c:set var="heroImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
<c:if test="${not empty featuredTours and not empty featuredTours[0].image}">
    <c:choose>
        <c:when test="${fn:startsWith(featuredTours[0].image, 'http')}">
            <c:set var="heroImage" value="${featuredTours[0].image}" />
        </c:when>
        <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(featuredTours[0].image, pageContext.request.contextPath)}">
            <c:set var="heroImage" value="${featuredTours[0].image}" />
        </c:when>
        <c:when test="${fn:startsWith(featuredTours[0].image, '/')}">
            <c:set var="heroImage" value="${pageContext.request.contextPath}${featuredTours[0].image}" />
        </c:when>
        <c:otherwise>
            <c:set var="heroImage" value="${pageContext.request.contextPath}/${featuredTours[0].image}" />
        </c:otherwise>
    </c:choose>
</c:if>

<main class="home-page">
    <section class="home-hero" aria-labelledby="homeHeroTitle">
        <img class="home-hero-media" src="${heroImage}" alt="Điểm đến nổi bật của WonderVN">
        <div class="home-hero-overlay"></div>
        <div class="home-shell home-hero-content">
            <p class="eyebrow"><i class="fa-solid fa-location-dot"></i> Hành trình Việt Nam của bạn</p>
            <h1 id="homeHeroTitle">WonderVN</h1>
            <p class="hero-lead">Tour có lịch rõ ràng, nơi lưu trú còn phòng và mọi thông tin cần thiết cho một chuyến đi nhẹ đầu hơn.</p>
            <div class="hero-actions">
                <a class="button button-primary" href="${pageContext.request.contextPath}/tour">
                    Khám phá tour <i class="fa-solid fa-arrow-right"></i>
                </a>
                <a class="button button-light" href="${pageContext.request.contextPath}/accommodation">
                    Tìm nơi lưu trú
                </a>
            </div>

            <dl class="hero-metrics">
                <div><dt>${activeTourCount}</dt><dd>tour đang mở bán</dd></div>
                <div><dt>${accommodationCount}</dt><dd>nơi lưu trú</dd></div>
                <div><dt>${publishedBlogCount}</dt><dd>bài viết hữu ích</dd></div>
            </dl>
        </div>
    </section>

    <section class="search-band" aria-label="Tìm kiếm dịch vụ">
        <div class="home-shell">
            <div class="search-tabs" role="tablist" aria-label="Loại dịch vụ">
                <button class="search-tab active" type="button" role="tab" aria-selected="true" data-search-target="tourSearch">
                    <i class="fa-solid fa-route"></i> Tour
                </button>
                <button class="search-tab" type="button" role="tab" aria-selected="false" data-search-target="staySearch">
                    <i class="fa-solid fa-hotel"></i> Lưu trú
                </button>
            </div>

            <form class="home-search-form active" id="tourSearch" action="${pageContext.request.contextPath}/tour" method="get">
                <label>
                    <span>Khởi hành từ</span>
                    <select name="from">
                        <option value="">Tất cả điểm khởi hành</option>
                        <c:forEach var="place" items="${startPlaces}">
                            <option value="${place}"><c:out value="${place}" /></option>
                        </c:forEach>
                    </select>
                </label>
                <label>
                    <span>Điểm đến</span>
                    <select name="destination">
                        <option value="">Chọn điểm đến</option>
                        <c:forEach var="place" items="${destinations}">
                            <option value="${place}"><c:out value="${place}" /></option>
                        </c:forEach>
                    </select>
                </label>
                <label>
                    <span>Ngày khởi hành</span>
                    <input type="date" name="startDate">
                </label>
                <button class="button button-primary" type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm tour
                </button>
            </form>

            <form class="home-search-form" id="staySearch" action="${pageContext.request.contextPath}/accommodation" method="get" hidden>
                <label class="search-grow">
                    <span>Tỉnh/thành phố</span>
                    <select name="province">
                        <option value="">Tất cả tỉnh/thành phố</option>
                        <c:forEach var="province" items="${provinceList}">
                            <option value="${province}"><c:out value="${province}" /></option>
                        </c:forEach>
                    </select>
                </label>
                <label>
                    <span>Nhận phòng</span>
                    <input type="date" name="checkIn" data-min-today>
                </label>
                <label>
                    <span>Trả phòng</span>
                    <input type="date" name="checkOut" data-min-today>
                </label>
                <input type="hidden" name="adults" value="2">
                <input type="hidden" name="children" value="0">
                <input type="hidden" name="rooms" value="1">
                <button class="button button-primary" type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm phòng
                </button>
            </form>
        </div>
    </section>

    <section class="home-section service-section">
        <div class="home-shell">
            <div class="section-heading">
                <div>
                    <p class="section-label">Bắt đầu nhanh</p>
                    <h2>Chọn đúng thứ bạn đang cần</h2>
                </div>
                <p>Đi thẳng đến dịch vụ, lịch đặt và nội dung hướng dẫn mà không phải tìm qua nhiều màn hình.</p>
            </div>
            <div class="service-grid">
                <a class="service-card" href="${pageContext.request.contextPath}/tour">
                    <span class="service-icon tour"><i class="fa-solid fa-route"></i></span>
                    <span><strong>Tour trọn gói</strong><small>Xem hành trình và chọn lịch khởi hành.</small></span>
                    <i class="fa-solid fa-arrow-right"></i>
                </a>
                <a class="service-card" href="${pageContext.request.contextPath}/accommodation">
                    <span class="service-icon stay"><i class="fa-solid fa-hotel"></i></span>
                    <span><strong>Khách sạn & homestay</strong><small>Tìm phòng theo ngày và số khách thực tế.</small></span>
                    <i class="fa-solid fa-arrow-right"></i>
                </a>
                <a class="service-card" href="${pageContext.request.contextPath}/blog">
                    <span class="service-icon blog"><i class="fa-solid fa-newspaper"></i></span>
                    <span><strong>Cẩm nang du lịch</strong><small>Đọc kinh nghiệm đã được WonderVN duyệt.</small></span>
                    <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <section class="tour-showcase-section tours-section">
        <div class="home-shell">
            <div class="tour-showcase-head">
                <h2>Tour nổi bật</h2>
                <a href="${pageContext.request.contextPath}/tour"><i class="fa-regular fa-pen-to-square"></i> Xem tất cả</a>
            </div>

            <c:choose>
                <c:when test="${empty featuredTours}">
                    <div class="empty-state">Chưa có tour đang mở bán. Staff có thể thêm lịch khởi hành để tour xuất hiện tại đây.</div>
                </c:when>
                <c:otherwise>
                    <div class="tour-rail-wrap">
                        <button class="tour-rail-btn prev" type="button" data-rail-prev aria-label="Tour trước">‹</button>
                        <div class="tour-rail" data-tour-rail>
                            <c:forEach var="tour" items="${featuredTours}">
                                <c:set var="schedule" value="${tour.scheduleList[0]}" />
                                <c:set var="imageUrl" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                                <c:if test="${not empty tour.image}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="imageUrl" value="${tour.image}" /></c:when>
                                        <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(tour.image, pageContext.request.contextPath)}"><c:set var="imageUrl" value="${tour.image}" /></c:when>
                                        <c:when test="${fn:startsWith(tour.image, '/')}"><c:set var="imageUrl" value="${pageContext.request.contextPath}${tour.image}" /></c:when>
                                        <c:otherwise><c:set var="imageUrl" value="${pageContext.request.contextPath}/${tour.image}" /></c:otherwise>
                                    </c:choose>
                                </c:if>
                                <a class="home-tour-card" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                    <div class="home-tour-image">
                                        <img src="${imageUrl}" alt="${fn:escapeXml(tour.tourName)}" loading="lazy">
                                        <div class="home-tour-origin">Từ <c:out value="${tour.startPlace}" /></div>
                                    </div>
                                    <div class="home-tour-title"><c:out value="${tour.tourName}" /></div>
                                    <div class="home-tour-body">
                                        <span><i class="fa-regular fa-clock"></i> ${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</span>
                                        <span><i class="fa-regular fa-calendar-check"></i> <fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy" /></span>
                                        <div class="home-tour-footer">
                                            <span><i class="fa-regular fa-user"></i> Còn ${schedule.remainingSeats} chỗ</span>
                                            <strong class="home-tour-price"><fmt:formatNumber value="${not empty schedule.adultPrice ? schedule.adultPrice : tour.adultPrice}" pattern="#,##0" /> đ</strong>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                        <button class="tour-rail-btn next" type="button" data-rail-next aria-label="Tour sau">›</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="tour-showcase-section domestic-tour-section">
        <div class="home-shell">
            <div class="tour-showcase-head">
                <h2>Tour trong nước</h2>
                <a href="${pageContext.request.contextPath}/tour"><i class="fa-regular fa-pen-to-square"></i> Xem tất cả</a>
            </div>

            <c:choose>
                <c:when test="${empty domesticTours}">
                    <div class="empty-state">Chưa có tour trong nước đang mở bán. Staff cần thêm lịch khởi hành và giá bán để tour hiển thị tại đây.</div>
                </c:when>
                <c:otherwise>
                    <div class="tour-rail-wrap">
                        <button class="tour-rail-btn prev" type="button" data-rail-prev aria-label="Tour trước">‹</button>
                        <div class="tour-rail" data-tour-rail>
                            <c:forEach var="tour" items="${domesticTours}">
                                <c:set var="schedule" value="${tour.scheduleList[0]}" />
                                <c:set var="imageUrl" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                                <c:if test="${not empty tour.image}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="imageUrl" value="${tour.image}" /></c:when>
                                        <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(tour.image, pageContext.request.contextPath)}"><c:set var="imageUrl" value="${tour.image}" /></c:when>
                                        <c:when test="${fn:startsWith(tour.image, '/')}"><c:set var="imageUrl" value="${pageContext.request.contextPath}${tour.image}" /></c:when>
                                        <c:otherwise><c:set var="imageUrl" value="${pageContext.request.contextPath}/${tour.image}" /></c:otherwise>
                                    </c:choose>
                                </c:if>
                                <a class="home-tour-card" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                    <div class="home-tour-image">
                                        <img src="${imageUrl}" alt="${fn:escapeXml(tour.tourName)}" loading="lazy">
                                        <div class="home-tour-origin">Từ <c:out value="${tour.startPlace}" /></div>
                                    </div>
                                    <div class="home-tour-title"><c:out value="${tour.tourName}" /></div>
                                    <div class="home-tour-body">
                                        <span><i class="fa-regular fa-clock"></i> ${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</span>
                                        <span><i class="fa-regular fa-calendar-check"></i> <fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy" /></span>
                                        <div class="home-tour-footer">
                                            <span><i class="fa-regular fa-user"></i> Còn ${schedule.remainingSeats} chỗ</span>
                                            <strong class="home-tour-price"><fmt:formatNumber value="${not empty schedule.adultPrice ? schedule.adultPrice : tour.adultPrice}" pattern="#,##0" /> đ</strong>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                        <button class="tour-rail-btn next" type="button" data-rail-next aria-label="Tour sau">›</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="home-section stay-section">
        <div class="home-shell">
            <div class="section-heading compact">
                <div>
                    <p class="section-label">Lưu trú được quan tâm</p>
                    <h2>Chọn nơi ở phù hợp hành trình</h2>
                </div>
                <a class="text-link" href="${pageContext.request.contextPath}/accommodation">Xem tất cả <i class="fa-solid fa-arrow-right"></i></a>
            </div>

            <c:choose>
                <c:when test="${empty featuredAccommodations}">
                    <div class="empty-state">Chưa có nơi lưu trú đang hoạt động.</div>
                </c:when>
                <c:otherwise>
                    <div class="product-grid stay-grid">
                        <c:forEach var="stay" items="${featuredAccommodations}">
                            <c:set var="stayImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                            <c:if test="${not empty stay.image}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(stay.image, 'http')}"><c:set var="stayImage" value="${stay.image}" /></c:when>
                                    <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(stay.image, pageContext.request.contextPath)}"><c:set var="stayImage" value="${stay.image}" /></c:when>
                                    <c:when test="${fn:startsWith(stay.image, '/')}"><c:set var="stayImage" value="${pageContext.request.contextPath}${stay.image}" /></c:when>
                                    <c:otherwise><c:set var="stayImage" value="${pageContext.request.contextPath}/${stay.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <article class="product-card stay-card">
                                <a class="product-image" href="${pageContext.request.contextPath}/accommodation/detail?id=${stay.accommodationID}">
                                    <img src="${stayImage}" alt="${fn:escapeXml(stay.name)}" loading="lazy">
                                    <span class="image-badge rating">
                                        <i class="fa-solid fa-star"></i>
                                        <fmt:formatNumber value="${stay.averageRate}" pattern="0.0"/>
                                        (${stay.reviewCount})
                                    </span>
                                </a>
                                <div class="product-body">
                                    <p class="product-meta"><i class="fa-solid fa-location-dot"></i> ${stay.province}</p>
                                    <h3><a href="${pageContext.request.contextPath}/accommodation/detail?id=${stay.accommodationID}"><c:out value="${stay.name}" /></a></h3>
                                    <p class="stay-address"><c:out value="${stay.fullAddress}" /></p>
                                    <div class="product-footer">
                                        <div>
                                            <small>${stay.totalAvailableRooms} phòng còn trống</small>
                                            <strong><fmt:formatNumber value="${stay.minRoomPrice}" pattern="#,#00" /> đ<em>/đêm</em></strong>
                                        </div>
                                        <a class="icon-button" href="${pageContext.request.contextPath}/accommodation/detail?id=${stay.accommodationID}" title="Xem nơi lưu trú" aria-label="Xem ${fn:escapeXml(stay.name)}"><i class="fa-solid fa-arrow-right"></i></a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="home-section blog-section">
        <div class="home-shell">
            <div class="section-heading compact">
                <div>
                    <p class="section-label">Cẩm nang WonderVN</p>
                    <h2>Chuẩn bị tốt trước khi lên đường</h2>
                </div>
                <a class="text-link" href="${pageContext.request.contextPath}/blog">Đọc tất cả <i class="fa-solid fa-arrow-right"></i></a>
            </div>

            <c:choose>
                <c:when test="${empty latestBlogs}">
                    <div class="empty-state">Chưa có bài viết đã duyệt.</div>
                </c:when>
                <c:otherwise>
                    <div class="blog-grid">
                        <c:forEach var="post" items="${latestBlogs}">
                            <c:set var="blogImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                            <c:if test="${not empty post.image}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(post.image, 'http')}"><c:set var="blogImage" value="${post.image}" /></c:when>
                                    <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(post.image, pageContext.request.contextPath)}"><c:set var="blogImage" value="${post.image}" /></c:when>
                                    <c:when test="${fn:startsWith(post.image, '/')}"><c:set var="blogImage" value="${pageContext.request.contextPath}${post.image}" /></c:when>
                                    <c:otherwise><c:set var="blogImage" value="${pageContext.request.contextPath}/${post.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <article class="blog-card">
                                <a class="blog-image" href="${pageContext.request.contextPath}/blog-detail?slug=${post.slug}">
                                    <img src="${blogImage}" alt="${fn:escapeXml(post.title)}" loading="lazy">
                                </a>
                                <div class="blog-body">
                                    <p class="product-meta"><i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${post.createAt}" pattern="dd/MM/yyyy" /></p>
                                    <h3><a href="${pageContext.request.contextPath}/blog-detail?slug=${post.slug}"><c:out value="${post.title}" /></a></h3>
                                    <p><c:out value="${post.summary}" /></p>
                                    <a class="text-link" href="${pageContext.request.contextPath}/blog-detail?slug=${post.slug}">Đọc bài viết <i class="fa-solid fa-arrow-right"></i></a>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="home-cta">
        <div class="home-shell cta-inner">
            <div>
                <p class="section-label">Sẵn sàng khởi hành?</p>
                <h2>Chọn lịch, chọn phòng và quản lý booking trong một tài khoản.</h2>
            </div>
            <a class="button button-light" href="${pageContext.request.contextPath}/tour">Bắt đầu khám phá <i class="fa-solid fa-arrow-right"></i></a>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<button class="scroll-top" id="scrollTop" type="button" title="Lên đầu trang" aria-label="Lên đầu trang"><i class="fa-solid fa-arrow-up"></i></button>
<script src="${pageContext.request.contextPath}/assets/js/home.js?v=20260721"></script>

<c:if test="${not empty sessionScope.successMessage}">
    <div class="success-toast" id="successToast">
        <i class="fa-solid fa-circle-check"></i>
        <div><strong>Booking thành công</strong><span><c:out value="${sessionScope.successMessage}" /></span></div>
        <button type="button" data-dismiss-toast aria-label="Đóng"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>
</body>
</html>
