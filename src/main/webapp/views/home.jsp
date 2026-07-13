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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20260713">
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<c:set var="heroImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
<c:if test="${not empty featuredTours and not empty featuredTours[0].image}">
    <c:choose>
        <c:when test="${fn:startsWith(featuredTours[0].image, 'http')}">
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

    <section class="home-section tours-section">
        <div class="home-shell">
            <div class="section-heading compact">
                <div>
                    <p class="section-label">Tour nổi bật</p>
                    <h2>Lịch khởi hành gần nhất</h2>
                </div>
                <a class="text-link" href="${pageContext.request.contextPath}/tour">Xem tất cả <i class="fa-solid fa-arrow-right"></i></a>
            </div>

            <c:choose>
                <c:when test="${empty featuredTours}">
                    <div class="empty-state">Chưa có tour đang mở bán. Staff có thể thêm lịch khởi hành để tour xuất hiện tại đây.</div>
                </c:when>
                <c:otherwise>
                    <div class="product-grid tour-grid">
                        <c:forEach var="tour" items="${featuredTours}">
                            <c:set var="schedule" value="${tour.scheduleList[0]}" />
                            <c:set var="imageUrl" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                            <c:if test="${not empty tour.image}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="imageUrl" value="${tour.image}" /></c:when>
                                    <c:when test="${fn:startsWith(tour.image, '/')}"><c:set var="imageUrl" value="${pageContext.request.contextPath}${tour.image}" /></c:when>
                                    <c:otherwise><c:set var="imageUrl" value="${pageContext.request.contextPath}/${tour.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <article class="product-card tour-card" data-region="${tour.regionName}">
                                <a class="product-image" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                    <img src="${imageUrl}" alt="${fn:escapeXml(tour.tourName)}" loading="lazy">
                                    <span class="image-badge">${empty tour.regionName ? 'WonderVN' : tour.regionName}</span>
                                </a>
                                <div class="product-body">
                                    <p class="product-meta"><i class="fa-solid fa-location-dot"></i> ${tour.startPlace} → ${tour.endPlace}</p>
                                    <h3><a href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}"><c:out value="${tour.tourName}" /></a></h3>
                                    <div class="tour-facts">
                                        <span><i class="fa-regular fa-clock"></i> ${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</span>
                                        <span><i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy" /></span>
                                    </div>
                                    <div class="product-footer">
                                        <div><small>Giá từ</small><strong><fmt:formatNumber value="${not empty schedule.adultPrice ? schedule.adultPrice : tour.adultPrice}" pattern="#,#00" /> đ</strong></div>
                                        <a class="icon-button" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}" title="Xem tour" aria-label="Xem tour ${fn:escapeXml(tour.tourName)}"><i class="fa-solid fa-arrow-right"></i></a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
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
                                    <c:when test="${fn:startsWith(stay.image, '/')}"><c:set var="stayImage" value="${pageContext.request.contextPath}${stay.image}" /></c:when>
                                    <c:otherwise><c:set var="stayImage" value="${pageContext.request.contextPath}/${stay.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <article class="product-card stay-card">
                                <a class="product-image" href="${pageContext.request.contextPath}/accommodation/detail?id=${stay.accommodationID}">
                                    <img src="${stayImage}" alt="${fn:escapeXml(stay.name)}" loading="lazy">
                                    <span class="image-badge rating"><i class="fa-solid fa-star"></i> ${stay.rate}</span>
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
<script src="${pageContext.request.contextPath}/assets/js/home.js?v=20260713"></script>

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
