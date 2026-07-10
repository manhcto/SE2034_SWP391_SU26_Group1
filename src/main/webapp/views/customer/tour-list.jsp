<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Tour trọn gói</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">
    <style>
        .customer-tour-page { padding: 42px 0 76px; }
        .tour-list-hero {
            border-radius: 36px;
            padding: 38px;
            background: linear-gradient(135deg, #fff7ed, #eff6ff);
            border: 1px solid #e6edf7;
            box-shadow: 0 18px 44px rgba(15, 23, 42, 0.08);
            margin-bottom: 28px;
        }
        .tour-list-hero h1 { margin: 8px 0 10px; color: #0f172a; font-size: 42px; line-height: 1.15; }
        .tour-list-hero p { margin: 0; color: #64748b; font-weight: 700; }
        .tour-filter-card {
            background: #ffffff;
            border: 1px solid #e5eaf3;
            border-radius: 28px;
            padding: 22px;
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.07);
            margin-bottom: 28px;
        }
        .tour-filter-grid {
            display: grid;
            grid-template-columns: 1.1fr repeat(5, minmax(0, 1fr)) auto;
            gap: 12px;
            align-items: end;
        }
        .tour-filter-grid label { display: flex; flex-direction: column; gap: 7px; color: #334155; font-size: 13px; font-weight: 900; }
        .tour-filter-grid input, .tour-filter-grid select {
            height: 48px;
            border-radius: 14px;
            border: 1px solid #dbe5f2;
            background: #f8fafc;
            padding: 0 13px;
            font: inherit;
            font-weight: 700;
            color: #0f172a;
            outline: none;
        }
        .tour-filter-grid button {
            height: 48px;
            border: 0;
            border-radius: 14px;
            padding: 0 18px;
            color: #ffffff;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            font-weight: 900;
            cursor: pointer;
        }
        .customer-tour-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 24px; }
        .customer-tour-card {
            overflow: hidden;
            border-radius: 28px;
            background: #fff;
            border: 1px solid #e6edf7;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);
        }
        .customer-tour-img { position: relative; height: 230px; background: #dbeafe; overflow: hidden; }
        .customer-tour-img img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .customer-tour-img::after { content: ""; position: absolute; inset: 0; background: linear-gradient(180deg, rgba(15,23,42,0.03), rgba(15,23,42,0.55)); }
        .customer-tour-img span { position: absolute; z-index: 2; top: 15px; left: 15px; padding: 8px 12px; border-radius: 999px; color: #fff; background: rgba(15,23,42,0.76); font-size: 12px; font-weight: 900; }
        .customer-tour-body { padding: 21px; }
        .customer-tour-body h3 { margin: 0 0 10px; color: #0f172a; font-size: 21px; line-height: 1.35; }
        .customer-tour-meta { display: grid; gap: 7px; color: #64748b; font-weight: 700; font-size: 14px; }
        .schedule-chip-row { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
        .schedule-chip { padding: 7px 10px; border-radius: 999px; background: #eff6ff; color: #1d4ed8; font-weight: 900; font-size: 12px; }
        .tour-card-footer { margin-top: 16px; padding-top: 16px; border-top: 1px solid #ecf1f6; display: flex; align-items: center; justify-content: space-between; gap: 14px; }
        .tour-card-footer span { display: block; color: #64748b; font-size: 12px; font-weight: 800; }
        .tour-card-footer strong { color: #ea580c; font-size: 22px; font-weight: 950; }
        .tour-card-footer a { height: 42px; padding: 0 14px; border-radius: 13px; background: #2563eb; color: #fff; display: inline-flex; align-items: center; justify-content: center; font-weight: 900; white-space: nowrap; }
        .empty-box { padding: 34px; border-radius: 24px; background: #fff; border: 1px dashed #cbd5e1; text-align: center; color: #64748b; font-weight: 800; }
        .notice-box { margin-bottom: 20px; padding: 14px 16px; border-radius: 18px; background: #fff7ed; color: #9a3412; font-weight: 800; border: 1px solid #fed7aa; }
        @media (max-width: 1180px) { .tour-filter-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); } .customer-tour-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 760px) { .tour-filter-grid, .customer-tour-grid { grid-template-columns: 1fr; } .tour-list-hero h1 { font-size: 32px; } }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<main class="customer-tour-page">
    <div class="home-container">
        <section class="tour-list-hero">
            <p class="section-kicker">Tour WonderVN</p>
            <h1>Tour trọn gói đang mở bán</h1>
            <p>Chỉ hiển thị các tour đã được duyệt, đang bán và còn lịch khởi hành hợp lệ cho khách đặt.</p>
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

        <section class="tour-filter-card">
            <form class="tour-filter-grid" method="get" action="${pageContext.request.contextPath}/tour">
                <label>Từ khóa
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tên tour, mã tour...">
                </label>
                <label>Điểm khởi hành
                    <select name="from">
                        <option value="">Tất cả</option>
                        <c:forEach var="place" items="${startPlaces}">
                            <option value="${place}" ${selectedFrom == place ? 'selected' : ''}>${place}</option>
                        </c:forEach>
                    </select>
                </label>
                <label>Điểm đến
                    <select name="destination">
                        <option value="">Tất cả</option>
                        <c:forEach var="place" items="${destinations}">
                            <option value="${place}" ${selectedDestination == place ? 'selected' : ''}>${place}</option>
                        </c:forEach>
                    </select>
                </label>
                <label>Khu vực
                    <select name="regionID">
                        <option value="0">Tất cả</option>
                        <c:forEach var="region" items="${regionList}">
                            <option value="${region.regionID}" ${selectedRegionID == region.regionID ? 'selected' : ''}>${region.regionName}</option>
                        </c:forEach>
                    </select>
                </label>
                <label>Danh mục
                    <select name="categoryID">
                        <option value="0">Tất cả</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.tourCategoryID}" ${selectedCategoryID == category.tourCategoryID ? 'selected' : ''}>${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </label>
                <label>Ngày đi
                    <input type="date" name="startDate" value="${selectedStartDate}">
                </label>
                <button type="submit">Tìm tour</button>
            </form>
        </section>

        <c:choose>
            <c:when test="${empty tourList}">
                <div class="empty-box">Chưa có tour phù hợp với điều kiện tìm kiếm.</div>
            </c:when>
            <c:otherwise>
                <div class="customer-tour-grid">
                    <c:forEach var="tour" items="${tourList}">
                        <c:set var="firstSchedule" value="${tour.scheduleList[0]}" />
                        <c:set var="imageSrc" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                        <c:if test="${not empty tour.image}">
                            <c:choose>
                                <c:when test="${fn:startsWith(tour.image, 'http')}"><c:set var="imageSrc" value="${tour.image}" /></c:when>
                                <c:otherwise><c:set var="imageSrc" value="${pageContext.request.contextPath}${tour.image}" /></c:otherwise>
                            </c:choose>
                        </c:if>
                        <article class="customer-tour-card">
                            <div class="customer-tour-img">
                                <img src="${imageSrc}" alt="${tour.tourName}" onerror="this.src='${pageContext.request.contextPath}/assets/images/home/hero-bana.png';">
                                <span>${empty tour.regionName ? 'WonderVN' : tour.regionName}</span>
                            </div>
                            <div class="customer-tour-body">
                                <h3>${tour.tourName}</h3>
                                <div class="customer-tour-meta">
                                    <div>Mã tour: <strong>${tour.tourCode}</strong></div>
                                    <div>Khởi hành: ${tour.startPlace}</div>
                                    <div>Điểm đến: ${tour.endPlace}</div>
                                    <div>Thời lượng: ${tour.numberOfDay} ngày <c:if test="${not empty tour.numberOfNights}">${tour.numberOfNights} đêm</c:if></div>
                                </div>
                                <div class="schedule-chip-row">
                                    <c:forEach var="schedule" items="${tour.scheduleList}">
                                        <span class="schedule-chip"><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy" /></span>
                                    </c:forEach>
                                </div>
                                <div class="tour-card-footer">
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
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
</body>
</html>
