<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Tour trong nước</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20260721">
    <style>
        .tour-list-page { padding: 38px 0 76px; background: #ffffff; }
        .tour-intro { padding: 4px 0 34px; border-bottom: 1px solid #dddddd; }
        .tour-intro h1 { margin: 0 0 14px; color: #0b55a0; text-align: center; font-size: 24px; line-height: 1.3; text-transform: uppercase; }
        .tour-rating { margin: 0 0 16px; color: #111827; font-size: 13px; font-weight: 700; }
        .tour-rating i { color: #f5b301; }
        .tour-intro p { margin: 0 0 10px; color: #111827; font-size: 13px; line-height: 1.75; }
        .tour-intro a { color: #0068bd; font-weight: 800; text-decoration: none; }
        .tour-more { display: block; margin-top: 10px; color: var(--blue) !important; text-align: right; font-size: 13px; font-weight: 700; }
        .tour-list-layout { display: grid; grid-template-columns: 300px minmax(0, 1fr); gap: 28px; align-items: start; padding-top: 20px; }
        .tour-list-title { margin: 0 0 20px; padding-bottom: 18px; border-bottom: 1px solid #dddddd; color: #0b55a0; font-size: 23px; line-height: 1.35; font-weight: 800; }
        .tour-count-title { margin: 0 0 16px; padding-bottom: 8px; border-bottom: 1px solid #b2ccff; color: var(--blue); font-size: 18px; line-height: 1.3; text-transform: uppercase; }
        .tour-result-list { display: grid; gap: 16px; }
        .tour-result-card { display: grid; grid-template-columns: 290px minmax(0, 1fr); gap: 16px; padding: 14px; border: 1px solid #dddddd; background: #ffffff; }
        .tour-result-image { min-width: 0; height: 182px; background: #e5e7eb; overflow: hidden; }
        .tour-result-image img { width: 100%; height: 100%; display: block; object-fit: cover; transition: transform .24s ease; }
        .tour-result-card:hover .tour-result-image img { transform: scale(1.035); }
        .tour-result-body { min-width: 0; display: flex; flex-direction: column; }
        .tour-result-body h3 { margin: 0 0 12px; color: #111827; font-size: 17px; line-height: 1.45; font-weight: 900; text-transform: uppercase; }
        .tour-result-body h3 a { color: inherit; text-decoration: none; }
        .tour-info-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px 18px; color: #3f3f46; font-size: 13px; }
        .tour-info-grid i { width: 18px; color: #666666; }
        .tour-info-grid strong, .tour-info-grid a { color: #0068bd; text-decoration: none; }
        .tour-category-line { margin: 0 0 10px; color: var(--green); font-size: 12px; font-weight: 800; }
        .departures { margin-top: 12px; display: flex; flex-wrap: wrap; align-items: center; gap: 7px; color: #111827; font-size: 13px; font-weight: 800; }
        .departure-chip { padding: 6px 8px; border: 1px solid #b2ccff; border-radius: 5px; color: var(--blue); background: #eff4ff; font-size: 12px; line-height: 1; }
        .tour-result-footer { margin-top: auto; padding-top: 14px; display: flex; align-items: end; justify-content: space-between; gap: 16px; }
        .tour-price-label { margin: 0; color: #3f3f46; font-size: 13px; }
        .tour-result-price { display: block; color: var(--coral); font-size: 23px; line-height: 1.1; font-weight: 800; }
        .tour-result-actions { display: flex; align-items: center; justify-content: flex-end; gap: 8px; flex-wrap: wrap; }
        .detail-button { min-width: 100px; min-height: 38px; padding: 0 14px; border-radius: 8px; color: #ffffff; background: var(--blue); display: inline-flex; align-items: center; justify-content: center; text-decoration: none; font-size: 13px; font-weight: 900; }
        .detail-button:hover { background: var(--blue-dark); color: #ffffff; }
        .detail-button.feedback-button { color: var(--blue); background: #ffffff; border: 1px solid var(--blue); }
        .detail-button.feedback-button:hover { color: #ffffff; background: var(--blue); }
        .tour-filter-side { position: sticky; top: 18px; padding: 24px 18px; background: #f4f4f4; border: 1px solid #e5e7eb; }
        .tour-filter-side h2 { margin: 0 0 22px; color: #111827; text-align: center; font-size: 16px; font-weight: 900; text-transform: uppercase; }
        .filter-form { display: grid; gap: 15px; }
        .filter-form label { display: grid; gap: 8px; color: #111827; font-size: 13px; font-weight: 800; }
        .filter-form input, .filter-form select { width: 100%; height: 42px; border: 1px solid #cfcfcf; background: #ffffff; padding: 0 12px; color: #4b5563; font-size: 13px; outline: none; }
        .price-filter-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .filter-form button { height: 42px; border: 0; border-radius: 4px; color: #ffffff; background: var(--blue); font-weight: 900; cursor: pointer; }
        .filter-form button:hover { background: var(--blue-dark); }
        .notice-box, .empty-box { margin-bottom: 16px; padding: 16px; border: 1px solid #fed7aa; background: #fff7ed; color: #9a3412; font-weight: 800; line-height: 1.55; }
        @media (max-width: 1020px) {
            .tour-list-layout { grid-template-columns: 1fr; }
            .tour-filter-side { position: static; }
        }
        @media (max-width: 760px) {
            .tour-result-card, .tour-info-grid { grid-template-columns: 1fr; }
            .tour-result-image { height: 210px; }
            .tour-result-footer { align-items: flex-start; flex-direction: column; }
        }
        .tour-intro { display: none; }
        .tour-list-page { padding-top: 28px; background: var(--canvas); }
        .tour-list-layout { display: flex; flex-direction: column; gap: 24px; padding-top: 0; }
        .tour-filter-side { position: static; width: 100%; padding: 22px; border: 1px solid var(--line); border-radius: 8px; background: var(--surface); box-shadow: var(--shadow); }
        .tour-filter-side h2 { margin-bottom: 16px; text-align: left; color: var(--ink); }
        .filter-form { grid-template-columns: repeat(6, minmax(135px, 1fr)); align-items: end; gap: 14px; }
        .filter-form label { min-width: 0; }
        .filter-form input, .filter-form select { height: 48px; border-color: #d0d5dd; border-radius: 7px; color: var(--ink); }
        .filter-form button { height: 48px; border-radius: 7px; background: var(--blue); }
        .price-filter-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        .tour-list-title { margin-top: 4px; color: var(--blue); border-bottom-color: var(--line); }
        .tour-count-title { color: var(--ink); border-bottom-color: var(--line); text-transform: none; }
        .tour-result-list { gap: 18px; }
        .tour-result-card { grid-template-columns: 300px minmax(0, 1fr); gap: 18px; padding: 14px; border-color: var(--line); border-radius: 8px; box-shadow: 0 10px 24px rgba(16,24,40,.06); transition: transform .22s ease, box-shadow .22s ease; }
        .tour-result-card:hover { transform: translateY(-2px); box-shadow: 0 16px 30px rgba(16,24,40,.1); }
        .tour-result-image { height: 190px; border-radius: 6px; }
        .tour-result-body h3 { font-size: 18px; color: var(--ink); }
        .tour-category-line { color: var(--green); }
        .departure-chip { border-color: #b2ccff; background: #eff4ff; color: var(--blue); }
        .tour-result-price { color: var(--blue); font-weight: 900; }
        .detail-button { border-radius: 7px; background: var(--blue); }
        @media (max-width: 1100px) {
            .filter-form { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 760px) {
            .filter-form { grid-template-columns: 1fr; }
            .tour-result-card { grid-template-columns: 1fr; }
        }
        .tour-results-head { margin-top: 4px; display: flex; align-items: flex-start; justify-content: space-between; gap: 18px; }
        .tour-results-head h2 { margin-bottom: 8px; padding-bottom: 0; border: 0; font-size: 36px; line-height: 1.15; color: var(--ink); text-transform: none; }
        .tour-results-head p { margin: 0 0 22px; color: #52637f; font-size: 16px; line-height: 1.6; }
        .tour-total-badge { margin-top: 6px; min-height: 46px; padding: 0 18px; border: 1px solid #dbe3ef; border-radius: 7px; background: #ffffff; color: var(--ink); box-shadow: 0 10px 22px rgba(16,24,40,.06); display: inline-flex; align-items: center; gap: 8px; white-space: nowrap; font-weight: 900; }
        .tour-total-badge i { color: var(--blue); }
        .tour-count-title { display: none; }
        .tour-result-list { grid-template-columns: repeat(auto-fill, minmax(286px, 1fr)); align-items: stretch; gap: 22px; }
        .tour-result-card { display: flex; flex-direction: column; min-height: 560px; padding: 0; overflow: hidden; border: 0; border-radius: 8px; background: #ffffff; box-shadow: 0 18px 34px rgba(16,24,40,.08); }
        .tour-result-image { position: relative; width: 100%; height: 230px; border-radius: 0; }
        .tour-result-image::after { content: ""; position: absolute; inset: auto 0 0; height: 54%; background: linear-gradient(180deg, rgba(15,23,42,0), rgba(15,23,42,.68)); pointer-events: none; }
        .tour-result-body { flex: 1; padding: 20px; }
        .tour-result-body h3 { min-height: 74px; margin-bottom: 12px; font-size: 18px; line-height: 1.35; }
        .tour-category-line { margin-bottom: 13px; font-size: 13px; }
        .tour-info-grid { grid-template-columns: 1fr; gap: 8px; font-size: 13px; }
        .tour-info-grid div { display: flex; align-items: flex-start; gap: 8px; }
        .tour-info-grid i { flex: 0 0 18px; margin-top: 2px; color: var(--blue); }
        .departures { margin-top: 15px; gap: 8px; }
        .departures > span:first-child { flex-basis: 100%; color: var(--ink); }
        .departure-chip { border-radius: 999px; }
        .tour-result-footer { padding-top: 18px; align-items: center; }
        .detail-button { min-height: 46px; padding: 0 18px; border-radius: 8px; box-shadow: 0 10px 20px rgba(23,92,211,.18); }
        .pagination-bar { margin-top: 28px; display: flex; align-items: center; justify-content: center; gap: 8px; flex-wrap: wrap; }
        .page-link-soft { min-width: 40px; height: 40px; padding: 0 13px; border: 1px solid #dbe3ef; border-radius: 8px; background: #ffffff; color: var(--ink); text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 7px; font-weight: 800; }
        .page-link-soft:hover, .page-link-soft.active { background: var(--blue); border-color: var(--blue); color: #ffffff; }
        .page-link-soft.disabled { pointer-events: none; opacity: .45; background: #f2f4f7; }
        @media (max-width: 760px) {
            .tour-results-head { display: block; }
            .tour-results-head h2 { font-size: 28px; }
            .tour-total-badge { margin-bottom: 18px; }
            .tour-result-card { min-height: 0; }
        }
        .tour-list-page .home-shell { width: min(1440px, calc(100% - 48px)); }
        .tour-result-list { grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 18px; }
        .tour-result-card { min-height: 0; border-radius: 8px; }
        .tour-result-image { height: 176px; }
        .tour-result-body { padding: 15px 16px 16px; }
        .tour-result-body h3 {
            min-height: 0;
            margin: 0 0 7px;
            font-size: 16px;
            line-height: 1.35;
            display: -webkit-box;
            overflow: hidden;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .tour-category-line { margin: 0 0 8px; font-size: 13px; }
        .tour-info-grid { gap: 6px; font-size: 13px; line-height: 1.42; }
        .tour-info-grid i { flex-basis: 16px; width: 16px; }
        .departures { margin-top: 10px; gap: 6px; font-size: 13px; }
        .departure-chip { padding: 5px 7px; font-size: 11.5px; }
        .departures:not(.expanded) .departure-chip.is-extra { display: none; }
        .departure-toggle {
            width: 27px;
            height: 27px;
            border: 1px solid #b2ccff;
            border-radius: 999px;
            background: #ffffff;
            color: var(--blue);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background .2s ease, color .2s ease, transform .2s ease;
        }
        .departure-toggle:hover { background: var(--blue); color: #ffffff; }
        .departure-toggle i { font-size: 11px; transition: transform .2s ease; }
        .departures.expanded .departure-toggle i { transform: rotate(180deg); }
        .tour-result-footer { padding-top: 12px; gap: 10px; }
        .tour-price-label { font-size: 13px; }
        .tour-result-price { font-size: 19px; }
        .detail-button { min-width: 96px; min-height: 40px; padding: 0 13px; font-size: 12.5px; }
        @media (min-width: 1380px) {
            .tour-result-list { grid-template-columns: repeat(5, minmax(0, 1fr)); }
            .tour-result-image { height: 154px; }
            .tour-result-body { padding: 14px; }
            .tour-result-body h3 { font-size: 14px; }
            .tour-info-grid, .departures, .tour-price-label { font-size: 12px; }
            .detail-button { min-width: 90px; padding: 0 11px; }
        }
        @media (max-width: 1180px) {
            .tour-result-list { grid-template-columns: repeat(3, minmax(0, 1fr)); }
        }
        @media (max-width: 900px) {
            .tour-result-list { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 640px) {
            .tour-list-page .home-shell { width: min(100% - 32px, 520px); }
            .tour-result-list { grid-template-columns: 1fr; }
            .tour-result-image { height: 210px; }
            .tour-result-body h3 { font-size: 16px; }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<main class="tour-list-page">
    <div class="home-shell">
        <section class="tour-intro">
            <h1>Du lịch trong nước</h1>
            <p class="tour-rating">
                Đánh giá:
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                4.9/5 trong hệ thống WonderVN
            </p>
            <p><a href="${pageContext.request.contextPath}/tour">Tour du lịch trong nước</a> là lựa chọn phù hợp để khám phá Việt Nam theo lịch trình rõ ràng, giá bán theo từng ngày khởi hành và số chỗ còn lại minh bạch.</p>
            <p>WonderVN chỉ hiển thị các tour đã được duyệt, đang mở bán và còn lịch hợp lệ để khách dễ chọn hành trình phù hợp với thời gian, điểm khởi hành và ngân sách.</p>
            <a class="tour-more" href="#tour-results">Xem thêm »</a>
        </section>

        <c:if test="${param.message == 'selectSchedule'}">
            <div class="notice-box">Vui lòng chọn một lịch khởi hành trước khi đặt tour.</div>
        </c:if>
        <c:if test="${param.message == 'scheduleUnavailable'}">
            <div class="notice-box">Lịch khởi hành này hiện không còn nhận booking. Vui lòng chọn lịch khác.</div>
        </c:if>
        <c:if test="${param.message == 'notFound'}">
            <div class="notice-box">Không tìm thấy tour phù hợp hoặc tour chưa được mở bán.</div>
        </c:if>

        <div class="tour-list-layout" id="tour-results">
            <aside class="tour-filter-side">
                <h2>Lọc tour theo</h2>
                <form class="filter-form" method="get" action="${pageContext.request.contextPath}/tour">
                    <label>Bạn muốn đến đâu?
                        <select name="destination">
                            <option value="">Trong Nước</option>
                            <c:forEach var="place" items="${destinations}">
                                <option value="${place}" ${selectedDestination == place ? 'selected' : ''}>${place}</option>
                            </c:forEach>
                        </select>
                    </label>
                    <label>Nơi khởi hành
                        <select name="from">
                            <option value="">Tất cả nơi khởi hành</option>
                            <c:forEach var="place" items="${startPlaces}">
                                <option value="${place}" ${selectedFrom == place ? 'selected' : ''}>${place}</option>
                            </c:forEach>
                        </select>
                    </label>
                    <label>Loại tour
                        <select name="categoryID">
                            <option value="0">Tất cả loại tour</option>
                            <c:forEach var="category" items="${categoryList}">
                                <option value="${category.tourCategoryID}" ${selectedCategoryID == category.tourCategoryID ? 'selected' : ''}>${category.categoryName}</option>
                            </c:forEach>
                        </select>
                    </label>
                    <label>Khu vực
                        <select name="regionID">
                            <option value="0">Tất cả khu vực</option>
                            <c:forEach var="region" items="${regionList}">
                                <option value="${region.regionID}" ${selectedRegionID == region.regionID ? 'selected' : ''}>${region.regionName}</option>
                            </c:forEach>
                        </select>
                    </label>
                    <label>Ngày khởi hành
                        <input type="date" name="startDate" value="${selectedStartDate}">
                    </label>
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
                </form>
            </aside>

            <section>
                <div class="tour-results-head">
                    <div>
                        <h2 class="tour-list-title">Danh sách tour đang bán</h2>
                        <p>Khám phá các tour trọn gói có lịch khởi hành, giá bán và số chỗ rõ ràng.</p>
                    </div>
                    <span class="tour-total-badge"><i class="fa-solid fa-layer-group"></i> Tìm thấy ${totalTourCount} tour</span>
                </div>
                <h3 class="tour-count-title">Các tour còn lịch khởi hành (${totalTourCount})</h3>
                <c:choose>
                    <c:when test="${empty tourList}">
                        <div class="empty-box">Chưa có tour phù hợp với điều kiện tìm kiếm.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="tour-result-list">
                            <c:forEach var="tour" items="${tourList}">
                                <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                                <c:set var="imageSrc" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                                <c:if test="${not empty tour.image}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="imageSrc" value="${tour.image}" /></c:when>
                                        <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(tour.image, pageContext.request.contextPath)}"><c:set var="imageSrc" value="${tour.image}" /></c:when>
                                        <c:when test="${fn:startsWith(tour.image, '/')}"><c:set var="imageSrc" value="${pageContext.request.contextPath}${tour.image}" /></c:when>
                                        <c:otherwise><c:set var="imageSrc" value="${pageContext.request.contextPath}/${tour.image}" /></c:otherwise>
                                    </c:choose>
                                </c:if>
                                <article class="tour-result-card">
                                    <a class="tour-result-image" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">
                                        <img src="${imageSrc}" alt="${fn:escapeXml(tour.tourName)}" onerror="this.src='${pageContext.request.contextPath}/assets/images/home/hero-bana.png';">
                                    </a>
                                    <div class="tour-result-body">
                                        <h3><a href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}"><c:out value="${tour.tourName}" /></a></h3>
                                        <p class="tour-category-line"><i class="fa-solid fa-layer-group"></i> Danh mục: <c:out value="${empty tour.categoryName ? 'Tour trọn gói' : tour.categoryName}" /></p>
                                        <div class="tour-info-grid">
                                            <div><i class="fa-solid fa-ticket"></i> Mã tour: <strong><c:out value="${tour.tourCode}" /></strong></div>
                                            <div><i class="fa-solid fa-location-dot"></i> Khởi hành: <a href="${pageContext.request.contextPath}/tour?from=${fn:escapeXml(tour.startPlace)}"><c:out value="${tour.startPlace}" /></a></div>
                                            <div><i class="fa-regular fa-clock"></i> Thời gian: <strong>${tour.numberOfDay}N${tour.numberOfNights}Đ</strong></div>
                                            <div><i class="fa-solid fa-bus"></i> Phương tiện: <strong><c:out value="${empty firstSchedule.scheduleTransportType ? tour.mainTransportType : firstSchedule.scheduleTransportType}" /></strong></div>
                                        </div>
                                        <div class="departures">
                                            <span><i class="fa-solid fa-bus"></i> Ngày khởi hành:</span>
                                            <c:forEach var="schedule" items="${tour.scheduleList}" varStatus="loop">
                                                <span class="departure-chip ${loop.index >= 4 ? 'is-extra' : ''}"><fmt:formatDate value="${schedule.startDate}" pattern="dd-MM" /></span>
                                            </c:forEach>
                                            <c:if test="${fn:length(tour.scheduleList) > 4}">
                                                <button class="departure-toggle" type="button" aria-expanded="false" aria-label="Xem thêm ngày khởi hành">
                                                    <i class="fa-solid fa-chevron-down"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                        <div class="tour-result-footer">
                                            <div>
                                                <p class="tour-price-label">Giá từ:</p>
                                                <strong class="tour-result-price"><fmt:formatNumber value="${empty firstSchedule ? tour.adultPrice : firstSchedule.adultPrice}" pattern="#,##0" /> đ</strong>
                                            </div>
                                            <div class="tour-result-actions">
                                                <a class="detail-button feedback-button" href="${pageContext.request.contextPath}/feedback-list?tourID=${tour.tourID}">Đánh giá</a>
                                                <a class="detail-button" href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourID}">Xem chi tiết</a>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                        <c:if test="${totalPages > 1}">
                            <nav class="pagination-bar" aria-label="Phân trang tour">
                                <a class="page-link-soft ${hasPreviousPage ? '' : 'disabled'}" href="${pageContext.request.contextPath}/tour?page=${previousPage}${paginationQuery}">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                                <c:forEach begin="1" end="${totalPages}" var="pageNo">
                                    <a class="page-link-soft ${pageNo == currentPage ? 'active' : ''}" href="${pageContext.request.contextPath}/tour?page=${pageNo}${paginationQuery}">${pageNo}</a>
                                </c:forEach>
                                <a class="page-link-soft ${hasNextPage ? '' : 'disabled'}" href="${pageContext.request.contextPath}/tour?page=${nextPage}${paginationQuery}">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js?v=20260721"></script>
<script>
document.querySelectorAll('.departure-toggle').forEach(function (button) {
    button.addEventListener('click', function () {
        var departureList = button.closest('.departures');
        if (!departureList) return;
        var expanded = departureList.classList.toggle('expanded');
        button.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    });
});
</script>
</body>
</html>
