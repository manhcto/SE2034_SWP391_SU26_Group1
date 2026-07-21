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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=20260721">
    <style>
        .tour-detail-page { padding: 22px 0 70px; background: #ffffff; color: #111827; }
        .tour-title { margin: 0 0 14px; max-width: 940px; color: #111827; font-size: 20px; line-height: 1.35; font-weight: 900; text-transform: uppercase; }
        .tour-top { display: grid; grid-template-columns: minmax(0, 1fr) 220px; gap: 14px; align-items: start; }
        .tour-hero-image { min-height: 275px; border: 1px solid #dddddd; background: #e5e7eb; overflow: hidden; }
        .tour-hero-image img { width: 100%; height: 100%; display: block; object-fit: cover; }
        .tour-info-box { padding: 10px; border: 1px solid #d8d8d8; background: #ffffff; }
        .tour-info-box h2 { margin: 0 0 6px; padding-bottom: 7px; border-bottom: 1px solid #dddddd; color: #e6007e; font-size: 11px; line-height: 1.35; text-transform: uppercase; display: -webkit-box; overflow: hidden; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .info-row { display: grid; grid-template-columns: 68px minmax(0, 1fr); gap: 7px; padding: 6px 0; border-bottom: 1px solid #dddddd; color: #111827; font-size: 10.5px; }
        .info-row:last-child { border-bottom: 0; }
        .info-row span { font-weight: 800; }
        .detail-layout { display: grid; grid-template-columns: minmax(0, 1fr) 240px; gap: 14px; align-items: start; margin-top: 16px; }
        .detail-section { margin-bottom: 24px; background: #ffffff; }
        .section-title { margin: 0 0 12px; padding-bottom: 9px; border-bottom: 1px solid #dddddd; color: #111827; font-size: 16px; line-height: 1.35; font-weight: 700; }
        .section-title i { color: #e6007e; margin-right: 8px; }
        .highlight-table { width: 100%; border-collapse: collapse; color: #111827; font-size: 12px; }
        .highlight-table th { width: 108px; padding: 4px 0; text-align: left; vertical-align: top; font-weight: 800; }
        .highlight-table td { padding: 4px 0; vertical-align: top; }
        .rich-text { color: #111827; font-size: 12px; line-height: 1.75; white-space: pre-line; }
        .read-more-link { color: #e6007e; font-size: 12px; font-style: italic; font-weight: 800; text-decoration: none; }
        .collapsible-section { margin-bottom: 18px; }
        .collapsible-section > summary { cursor: pointer; list-style: none; }
        .collapsible-section > summary::-webkit-details-marker { display: none; }
        .collapsible-section > summary .section-title::after { content: " (Xem Thêm)"; color: #111827; font-size: 12px; font-weight: 500; }
        .collapsible-section[open] > summary .section-title::after { content: " (Thu gọn)"; }
        .itinerary-list { display: grid; gap: 8px; }
        .itinerary-day { border-left: 1px dotted #0ea5e9; padding-left: 12px; position: relative; }
        .itinerary-day::before { content: ""; position: absolute; left: -7px; top: 3px; width: 13px; height: 13px; border-radius: 50%; border: 2px solid #e6007e; background: #ffffff; }
        .day-heading { margin: 0 0 8px; padding: 5px 10px; border-radius: 4px; color: #ffffff; background: #e6007e; font-size: 12px; line-height: 1.3; font-weight: 900; text-transform: uppercase; cursor: pointer; list-style: none; }
        .day-heading::-webkit-details-marker { display: none; }
        .day-heading::after { content: "+"; float: right; font-weight: 900; }
        .itinerary-day[open] .day-heading::after { content: "-"; }
        .day-body { padding: 10px 12px; background: #f8fafc; color: #111827; font-size: 12px; line-height: 1.75; white-space: pre-line; }
        .day-body img { width: 100%; max-height: 260px; margin-top: 10px; object-fit: cover; border: 1px solid #dddddd; }
        .service-block { margin-bottom: 16px; color: #111827; font-size: 12px; line-height: 1.75; }
        .schedule-table { width: 100%; border-collapse: collapse; font-size: 12px; }
        .schedule-table th { padding: 9px 8px; border-bottom: 1px solid #dddddd; color: #111827; text-align: left; font-weight: 800; }
        .schedule-table td { padding: 9px 8px; border-bottom: 1px solid #eeeeee; color: #334155; }
        .schedule-table strong { color: #111827; }
        .schedule-main-row.active { background: #fff1f8; }
        .schedule-main-row.active td { color: #111827; }
        .detail-price-row td { padding: 0; border-bottom: 0; }
        .price-detail-box { display: none; margin: 0 8px 10px; border: 1px solid #e6007e; background: #ffffff; }
        .price-detail-box.open { display: block; }
        .price-detail-title { padding: 7px 8px; color: #111827; font-size: 12px; font-weight: 900; border-bottom: 1px solid #dddddd; display: flex; justify-content: space-between; gap: 12px; }
        .price-detail-title button { border: 0; background: transparent; color: #e6007e; cursor: pointer; font-weight: 900; }
        .price-detail-table { width: 100%; border-collapse: collapse; font-size: 11px; }
        .price-detail-table th, .price-detail-table td { padding: 7px 8px; border: 1px solid #dddddd; text-align: right; }
        .price-detail-table th:first-child, .price-detail-table td:first-child { text-align: left; }
        .contact-btn, .table-detail-btn { min-height: 26px; padding: 0 9px; border-radius: 4px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; font-size: 11px; font-weight: 800; }
        .contact-btn { color: #ffffff; background: #e6007e; }
        .table-detail-btn { color: #e6007e; border: 1px solid #e6007e; background: #ffffff; }
        .booking-side { position: sticky; top: 16px; display: grid; gap: 12px; }
        .price-card { background: #e6007e; color: #ffffff; }
        .price-card-head { padding: 10px 12px; font-size: 12px; font-weight: 900; }
        .price-card-head strong { font-size: 20px; }
        .price-card-body { padding: 12px; background: #e6007e; }
        .side-highlight { max-height: 210px; overflow: auto; padding: 12px; border-radius: 4px; background: #fff1f8; color: #111827; font-size: 12px; line-height: 1.65; }
        .side-highlight h3 { margin: 0 0 8px; color: #e6007e; font-size: 12px; }
        .schedule-select { width: 100%; height: 34px; margin-top: 10px; border: 0; border-radius: 4px; padding: 0 10px; color: #374151; background: #ffffff; font-size: 12px; }
        .book-button { width: 100%; height: 34px; margin-top: 8px; border: 0; border-radius: 3px; color: #ffffff; background: #009ee3; font-size: 12px; font-weight: 900; cursor: pointer; }
        .side-nav { background: #eeeeee; }
        .side-nav a { min-height: 34px; padding: 0 12px; display: flex; align-items: center; gap: 9px; border-bottom: 1px solid #dddddd; color: #333333; text-decoration: none; font-size: 12px; font-weight: 700; }
        .side-nav a:first-child { color: #e6007e; }
        .side-nav i { width: 14px; }
        .related-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 8px; }
        .related-card { border: 1px solid #dddddd; color: #333333; text-decoration: none; background: #ffffff; }
        .related-card img { width: 100%; aspect-ratio: 4 / 3; object-fit: cover; display: block; }
        .related-card strong { display: block; padding: 8px; font-size: 12px; line-height: 1.45; text-transform: uppercase; }
        @media (max-width: 1020px) {
            .tour-top, .detail-layout { grid-template-columns: 1fr; }
            .booking-side { position: static; }
        }
        @media (max-width: 760px) {
            .tour-title { font-size: 18px; }
            .schedule-table { min-width: 620px; }
            .table-scroll { overflow-x: auto; }
            .related-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/client-header.jsp" />

<c:set var="heroImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
<c:if test="${not empty tour.image}">
    <c:choose>
        <c:when test="${fn:startsWith(tour.image, 'http://') or fn:startsWith(tour.image, 'https://')}"><c:set var="heroImage" value="${tour.image}" /></c:when>
        <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(tour.image, pageContext.request.contextPath)}"><c:set var="heroImage" value="${tour.image}" /></c:when>
        <c:when test="${fn:startsWith(tour.image, '/')}"><c:set var="heroImage" value="${pageContext.request.contextPath}${tour.image}" /></c:when>
        <c:otherwise><c:set var="heroImage" value="${pageContext.request.contextPath}/${tour.image}" /></c:otherwise>
    </c:choose>
</c:if>
<c:set var="fromSchedule" value="${empty tour.scheduleList ? null : tour.scheduleList[0]}" />
<c:set var="fromPrice" value="${empty fromSchedule ? tour.adultPrice : fromSchedule.adultPrice}" />
<c:forEach var="schedule" items="${tour.scheduleList}">
    <c:if test="${not empty schedule.adultPrice and (empty fromPrice or schedule.adultPrice lt fromPrice)}">
        <c:set var="fromPrice" value="${schedule.adultPrice}" />
    </c:if>
</c:forEach>

<main class="tour-detail-page">
    <div class="home-shell">
        <h1 class="tour-title"><c:out value="${tour.tourName}" /></h1>

        <section class="tour-top">
            <div class="tour-hero-image">
                <img src="${heroImage}" alt="${fn:escapeXml(tour.tourName)}" onerror="this.src='${pageContext.request.contextPath}/assets/images/home/hero-bana.png';">
            </div>
            <aside class="tour-info-box">
                <h2><c:out value="${tour.tourName}" /></h2>
                <div class="info-row"><span>Mã tour:</span><strong><c:out value="${tour.tourCode}" /></strong></div>
                <div class="info-row"><span>Thời gian:</span><strong>${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</strong></div>
                <div class="info-row"><span>Vận chuyển:</span><strong><c:out value="${empty fromSchedule.scheduleTransportType ? tour.mainTransportType : fromSchedule.scheduleTransportType}" /></strong></div>
                <div class="info-row"><span>Xuất phát:</span><strong>Từ <c:out value="${tour.startPlace}" /></strong></div>
            </aside>
        </section>

        <div class="detail-layout">
            <div>
                <section class="detail-section" id="diem-nhan">
                    <h2 class="section-title"><i class="fa-solid fa-circle-info"></i>Điểm nhấn hành trình</h2>
                    <table class="highlight-table">
                        <tr><th>Hành trình</th><td><c:out value="${tour.startPlace}" /> - <c:out value="${tour.endPlace}" /></td></tr>
                        <tr><th>Lịch trình</th><td>${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</td></tr>
                        <tr><th>Khởi hành</th><td><c:forEach var="schedule" items="${tour.scheduleList}" varStatus="loop"><c:if test="${loop.index < 6}"><fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy" />${loop.index < 5 ? ', ' : ''}</c:if></c:forEach></td></tr>
                        <tr><th>Vận chuyển</th><td><c:out value="${empty fromSchedule.scheduleTransportType ? tour.mainTransportType : fromSchedule.scheduleTransportType}" /></td></tr>
                    </table>
                    <div class="rich-text">
                        <c:choose>
                            <c:when test="${not empty tour.tourInclude}"><c:out value="${tour.tourInclude}" /></c:when>
                            <c:otherwise>WonderVN đang cập nhật điểm nhấn chi tiết cho hành trình này.</c:otherwise>
                        </c:choose>
                    </div>
                    <a class="read-more-link" href="#lich-trinh">Xem thêm tour tại đây được quyền (Click Ngay)</a>
                </section>

                <section class="detail-section" id="lich-trinh">
                    <h2 class="section-title"><i class="fa-regular fa-map"></i>Lịch trình <span style="color:#009ee3;font-size:11px;">Lịch khởi hành cập nhật tự động</span></h2>
                    <c:choose>
                        <c:when test="${empty tour.itineraryList}">
                            <div class="rich-text">Tour này chưa cập nhật lịch trình chi tiết.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="itinerary-list">
                                <c:forEach var="item" items="${tour.itineraryList}">
                                    <details class="itinerary-day" ${item.dayNumber == 1 ? 'open' : ''}>
                                        <summary class="day-heading">Ngày ${item.dayNumber} | <c:out value="${item.title}" /></summary>
                                        <div class="day-body">
                                            <c:out value="${item.description}" />
                                            <c:if test="${not empty item.imageUrl}">
                                                <c:set var="itemImage" value="${item.imageUrl}" />
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(item.imageUrl, 'http://') or fn:startsWith(item.imageUrl, 'https://')}"><c:set var="itemImage" value="${item.imageUrl}" /></c:when>
                                                    <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(item.imageUrl, pageContext.request.contextPath)}"><c:set var="itemImage" value="${item.imageUrl}" /></c:when>
                                                    <c:when test="${fn:startsWith(item.imageUrl, '/')}"><c:set var="itemImage" value="${pageContext.request.contextPath}${item.imageUrl}" /></c:when>
                                                    <c:otherwise><c:set var="itemImage" value="${pageContext.request.contextPath}/${item.imageUrl}" /></c:otherwise>
                                                </c:choose>
                                                <img src="${itemImage}" alt="Ngày ${item.dayNumber}" onerror="this.style.display='none';">
                                            </c:if>
                                        </div>
                                    </details>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <details class="detail-section collapsible-section" id="dich-vu" open>
                    <summary><h2 class="section-title"><i class="fa-solid fa-paperclip"></i>Dịch vụ bao gồm và không bao gồm</h2></summary>
                    <div class="service-block">
                        <strong>Giá tour bao gồm:</strong>
                        <ul>
                            <li>Lịch trình tour trọn gói theo chương trình đã công bố trên WonderVN.</li>
                            <li>Phương tiện theo từng lịch khởi hành: <c:out value="${empty fromSchedule.scheduleTransportType ? tour.mainTransportType : fromSchedule.scheduleTransportType}" />.</li>
                            <li>Giá người lớn, trẻ em, VAT và phụ thu phòng đơn được áp dụng theo từng lịch khởi hành.</li>
                            <li>Thông tin số chỗ còn lại được đồng bộ từ lịch tour đang mở bán.</li>
                        </ul>
                    </div>
                    <div class="service-block">
                        <strong>Không bao gồm:</strong>
                        <ul>
                            <li>Chi phí cá nhân phát sinh ngoài chương trình.</li>
                            <li>Các dịch vụ không được ghi rõ trong thông tin tour hoặc lịch khởi hành.</li>
                            <li>Phụ thu phòng đơn nếu khách có nhu cầu ở riêng.</li>
                        </ul>
                    </div>
                    <c:if test="${not empty tour.tourNonInclude}">
                        <div class="service-block"><c:out value="${tour.tourNonInclude}" /></div>
                    </c:if>
                </details>

                <details class="detail-section collapsible-section" id="ghi-chu" open>
                    <summary><h2 class="section-title"><i class="fa-regular fa-note-sticky"></i>Ghi chú</h2></summary>
                    <div class="service-block">
                        <strong>Giá vé dành cho trẻ em:</strong>
                        <ul>
                            <li>Trẻ em từ 10 tuổi trở lên áp dụng giá người lớn.</li>
                            <li>Trẻ em 5-10 tuổi áp dụng giá trẻ em theo công thức của hệ thống ở từng lịch khởi hành.</li>
                            <li>Trẻ em dưới 5 tuổi áp dụng giá em bé theo từng lịch, trẻ thứ 2 tính theo quy định giá em bé của tour.</li>
                        </ul>
                    </div>
                    <div class="service-block">
                        <strong>Quy định thanh toán:</strong>
                        <ul>
                            <li>Khách chọn đúng lịch khởi hành, số lượng người lớn/trẻ em rồi tạo booking trên WonderVN.</li>
                            <li>Hệ thống tạo yêu cầu thanh toán theo tổng tiền booking và chuyển sang cổng thanh toán PayOS.</li>
                            <li>Booking chỉ được ghi nhận là đã thanh toán khi cổng thanh toán trả về trạng thái thành công.</li>
                            <li>Nếu thanh toán quá hạn hoặc chưa hoàn tất, hệ thống có thể đưa booking về trạng thái chờ/xử lý theo quy trình vận hành.</li>
                            <li>VAT được áp dụng theo lịch khởi hành tại thời điểm staff tạo lịch tour.</li>
                        </ul>
                    </div>
                    <c:if test="${not empty tour.childPolicyNote}">
                        <div class="service-block"><c:out value="${tour.childPolicyNote}" /></div>
                    </c:if>
                </details>

                <section class="detail-section" id="ngay-khac">
                    <h2 class="section-title"><i class="fa-regular fa-calendar-check"></i>Ngày khởi hành khác</h2>
                    <div class="table-scroll">
                        <table class="schedule-table">
                            <thead>
                            <tr>
                                <th>STT</th>
                                <th>Ngày khởi hành</th>
                                <th>Đặc điểm</th>
                                <th>Giá từ</th>
                                <th>Số chỗ</th>
                                <th>Book tour</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="schedule" items="${tour.scheduleList}" varStatus="loop">
                                <fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy" var="scheduleDateText" />
                                <fmt:formatNumber value="${schedule.adultPrice}" pattern="#,##0" var="adultPriceText" />
                                <fmt:formatNumber value="${schedule.childPrice}" pattern="#,##0" var="childPriceText" />
                                <fmt:formatNumber value="${schedule.infantPrice}" pattern="#,##0" var="infantPriceText" />
                                <fmt:formatNumber value="${schedule.singleRoomSurcharge}" pattern="#,##0" var="singleRoomText" />
                                <tr class="schedule-main-row ${loop.first ? 'active' : ''}"
                                    data-schedule-id="${schedule.tourScheduleID}"
                                    data-price-text="${adultPriceText} đ"
                                    data-date-text="${scheduleDateText}">
                                    <td>${loop.count}</td>
                                    <td>${scheduleDateText}</td>
                                    <td>${tour.numberOfDay} ngày ${tour.numberOfNights} đêm · <c:out value="${empty schedule.scheduleTransportType ? tour.mainTransportType : schedule.scheduleTransportType}" /></td>
                                    <td><strong>${adultPriceText}đ</strong></td>
                                    <td>Còn ${schedule.remainingSeats} chỗ</td>
                                    <td>
                                        <a class="contact-btn" href="${pageContext.request.contextPath}/booking?tourScheduleID=${schedule.tourScheduleID}">Book</a>
                                        <button class="table-detail-btn" type="button" data-price-detail-target="price-detail-${schedule.tourScheduleID}">Chi tiết</button>
                                    </td>
                                </tr>
                                <tr class="detail-price-row">
                                    <td colspan="6">
                                        <div class="price-detail-box" id="price-detail-${schedule.tourScheduleID}">
                                            <div class="price-detail-title">
                                                <span>Bảng chi tiết giá tour (<c:out value="${empty schedule.scheduleTransportType ? tour.mainTransportType : schedule.scheduleTransportType}" />) ${scheduleDateText}</span>
                                                <button type="button" data-price-detail-close="price-detail-${schedule.tourScheduleID}">x</button>
                                            </div>
                                            <table class="price-detail-table">
                                                <thead>
                                                <tr>
                                                    <th>Loại giá/Độ tuổi</th>
                                                    <th>Người lớn (Từ 11 tuổi)</th>
                                                    <th>Trẻ em (5-10 tuổi)</th>
                                                    <th>Trẻ nhỏ (2-5 tuổi)</th>
                                                    <th>Sơ sinh/nhỏ hơn 2 tuổi</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tr>
                                                    <td>Giá</td>
                                                    <td>${adultPriceText}đ</td>
                                                    <td>${childPriceText}đ</td>
                                                    <td>${infantPriceText}đ</td>
                                                    <td>0đ</td>
                                                </tr>
                                                <tr>
                                                    <td>Phụ thu nước ngoài</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                </tr>
                                                <tr>
                                                    <td>Phụ thu Việt Kiều</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                </tr>
                                                <tr>
                                                    <td>Phụ thu phòng đơn</td>
                                                    <td>${singleRoomText}đ</td>
                                                    <td colspan="3">Áp dụng khi khách yêu cầu phòng riêng.</td>
                                                </tr>
                                                <tr>
                                                    <td>VAT</td>
                                                    <td colspan="4">${schedule.vatPercent}% đã tính theo lịch khởi hành này.</td>
                                                </tr>
                                                <tr>
                                                    <td>Giảm giá</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                    <td>0đ</td>
                                                </tr>
                                                </tbody>
                                            </table>
                                            <div class="service-block" style="padding:8px;margin:0;"><strong>Ghi chú:</strong> Giá thanh toán cuối cùng phụ thuộc số khách, VAT, phụ thu phòng đơn và dữ liệu booking tại thời điểm đặt tour.</div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>

            <aside class="booking-side" id="lich-khoi-hanh">
                <section class="price-card">
                    <div class="price-card-head">Giá từ <strong id="selectedSchedulePrice"><fmt:formatNumber value="${fromPrice}" pattern="#,##0" /> đ</strong></div>
                    <div class="price-card-body">
                        <div class="side-highlight">
                            <h3><i class="fa-solid fa-play"></i> Trải nghiệm:</h3>
                            <c:choose>
                                <c:when test="${not empty tour.tourInclude}"><c:out value="${tour.tourInclude}" /></c:when>
                                <c:otherwise>Hành trình trọn gói, lịch rõ ràng và giá bán theo từng ngày khởi hành.</c:otherwise>
                            </c:choose>
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/booking">
                            <select class="schedule-select" id="schedulePicker" name="tourScheduleID" required>
                                <c:forEach var="schedule" items="${tour.scheduleList}">
                                    <fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy" var="pickerDateText" />
                                    <fmt:formatNumber value="${schedule.adultPrice}" pattern="#,##0" var="pickerPriceText" />
                                    <option value="${schedule.tourScheduleID}" data-price-text="${pickerPriceText} đ" data-date-text="${pickerDateText}">${pickerDateText}</option>
                                </c:forEach>
                            </select>
                            <button class="book-button" type="submit">ĐẶT TOUR</button>
                        </form>
                    </div>
                </section>
                <nav class="side-nav">
                    <a href="#diem-nhan"><i class="fa-solid fa-circle-info"></i> Điểm nhấn hành trình</a>
                    <a href="#lich-trinh"><i class="fa-solid fa-book-open"></i> Lịch trình</a>
                    <a href="#dich-vu"><i class="fa-solid fa-paperclip"></i> Dịch vụ bao gồm và không bao gồm</a>
                    <a href="#ghi-chu"><i class="fa-solid fa-note-sticky"></i> Ghi chú</a>
                    <a href="#ngay-khac"><i class="fa-regular fa-calendar-check"></i> Ngày khởi hành khác</a>
                </nav>
            </aside>
        </div>

        <c:if test="${not empty relatedTours}">
            <section class="detail-section">
                <h2 class="section-title"><i class="fa-solid fa-location-dot"></i>Tour cùng khu vực</h2>
                <div class="related-grid">
                    <c:forEach var="related" items="${relatedTours}">
                        <c:if test="${related.tourID != tour.tourID}">
                            <c:set var="relatedImage" value="${pageContext.request.contextPath}/assets/images/home/hero-bana.png" />
                            <c:if test="${not empty related.image}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(related.image, 'http://') or fn:startsWith(related.image, 'https://')}"><c:set var="relatedImage" value="${related.image}" /></c:when>
                                    <c:when test="${not empty pageContext.request.contextPath and fn:startsWith(related.image, pageContext.request.contextPath)}"><c:set var="relatedImage" value="${related.image}" /></c:when>
                                    <c:when test="${fn:startsWith(related.image, '/')}"><c:set var="relatedImage" value="${pageContext.request.contextPath}${related.image}" /></c:when>
                                    <c:otherwise><c:set var="relatedImage" value="${pageContext.request.contextPath}/${related.image}" /></c:otherwise>
                                </c:choose>
                            </c:if>
                            <a class="related-card" href="${pageContext.request.contextPath}/tour-detail?id=${related.tourID}">
                                <img src="${relatedImage}" alt="${fn:escapeXml(related.tourName)}" loading="lazy">
                                <strong><c:out value="${related.tourName}" /></strong>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </section>
        </c:if>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/home.js?v=20260721"></script>
<script>
(function () {
    const priceText = document.getElementById('selectedSchedulePrice');
    const picker = document.getElementById('schedulePicker');
    const rows = Array.from(document.querySelectorAll('.schedule-main-row'));

    function selectSchedule(row) {
        if (!row) return;
        rows.forEach(function (item) { item.classList.toggle('active', item === row); });
        if (priceText && row.dataset.priceText) {
            priceText.textContent = row.dataset.priceText;
        }
        if (picker && row.dataset.scheduleId) {
            picker.value = row.dataset.scheduleId;
        }
    }

    rows.forEach(function (row) {
        row.addEventListener('mouseenter', function () { selectSchedule(row); });
        row.addEventListener('focusin', function () { selectSchedule(row); });
        row.addEventListener('click', function () { selectSchedule(row); });
    });

    if (picker) {
        picker.addEventListener('change', function () {
            const row = rows.find(function (item) { return item.dataset.scheduleId === picker.value; });
            if (row) {
                selectSchedule(row);
            } else {
                const selected = picker.options[picker.selectedIndex];
                if (priceText && selected && selected.dataset.priceText) {
                    priceText.textContent = selected.dataset.priceText;
                }
            }
        });
    }

    document.querySelectorAll('[data-price-detail-target]').forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            const target = document.getElementById(button.getAttribute('data-price-detail-target'));
            if (!target) return;
            document.querySelectorAll('.price-detail-box.open').forEach(function (box) {
                if (box !== target) box.classList.remove('open');
            });
            target.classList.toggle('open');
            const parentRow = button.closest('.schedule-main-row');
            selectSchedule(parentRow);
        });
    });

    document.querySelectorAll('[data-price-detail-close]').forEach(function (button) {
        button.addEventListener('click', function () {
            const target = document.getElementById(button.getAttribute('data-price-detail-close'));
            if (target) target.classList.remove('open');
        });
    });
})();
</script>
</body>
</html>
