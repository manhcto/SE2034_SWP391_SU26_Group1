<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tour - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />
    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>
        <section class="staff-content">
            <div class="breadcrumb">Quản lý tour / Chi tiết tour</div>
            <div class="page-header">
                <div>
                    <h1 class="page-title"><c:out value="${tour.tourName}" /></h1>
                    <div class="page-subtitle">
                        <c:out value="${tour.tourCode}" /> ·
                        <span class="status-pill ${tour.statusCssClass}"><c:out value="${tour.tourStatusText}" /></span>
                    </div>
                </div>
                <div class="form-actions-right">
                    <a class="btn" href="${pageContext.request.contextPath}/staff/tours">Quay lại</a>
                    <c:if test="${tour.canEditBasic || tour.canAddOrEditSchedule}"><a class="btn btn-outline-green" href="${pageContext.request.contextPath}/staff/tours/edit?id=${tour.tourID}">Sửa tour</a></c:if>
                    <c:if test="${tour.canSubmitForApproval}"><form method="post" action="${pageContext.request.contextPath}/staff/tours/submit"><input type="hidden" name="tourID" value="${tour.tourID}"><button class="btn btn-primary" type="submit">Gửi duyệt</button></form></c:if>
                    <c:if test="${tour.tourStatus == 'Selling' || tour.tourStatus == 'Approved'}"><form method="post" action="${pageContext.request.contextPath}/staff/tours/mark-sold"><input type="hidden" name="tourID" value="${tour.tourID}"><button class="btn" type="submit">Chuyển đã bán</button></form></c:if>
                </div>
            </div>

            <c:if test="${not empty param.success}"><div class="card info-box success-box"><c:out value="${param.success}" /></div></c:if>
            <c:if test="${not empty param.notice}"><div class="card info-box warning-box"><c:out value="${param.notice}" /></div></c:if>
            <c:if test="${not empty param.errorMessage}"><div class="card info-box error-box"><c:out value="${param.errorMessage}" /></div></c:if>
            <c:if test="${tour.tourStatus == 'PendingApproval'}">
                <div class="card info-box warning-box">Tour đang chờ Admin duyệt. Staff chưa được mở bán tour này. Nếu cần kiểm tra tiến độ duyệt, hãy liên hệ Admin.</div>
            </c:if>

            <div class="card card-section">
                <h2 class="section-title"><span class="section-index">1</span>Thông tin cơ bản</h2>
                <div class="form-grid grid-4">
                    <div><small class="help-text">Danh mục</small><strong><c:out value="${tour.tourCategoryName}" /></strong></div>
                    <div><small class="help-text">Khu vực</small><strong><c:out value="${tour.regionName}" /></strong></div>
                    <div><small class="help-text">Điểm khởi hành</small><strong><c:out value="${tour.departurePlace}" /></strong></div>
                    <div><small class="help-text">Điểm đến</small><strong><c:out value="${tour.destination}" /></strong></div>
                </div>
                <div class="form-grid grid-4" style="margin-top:16px;">
                    <div><small class="help-text">Điểm tập kết</small><strong><c:out value="${tour.pickupPointName}" /></strong></div>
                    <div><small class="help-text">Giờ tập kết</small><strong><fmt:formatDate value="${tour.pickupTime}" pattern="HH:mm" /></strong></div>
                    <div><small class="help-text">Thời lượng</small><strong><c:out value="${tour.numberOfDays}" /> ngày <c:out value="${tour.numberOfNights}" /> đêm</strong></div>
                    <div><small class="help-text">Phương tiện</small><strong><c:out value="${tour.mainTransportType}" /> <c:if test="${not empty tour.vehicleSeatCount}">- <c:out value="${tour.vehicleSeatCount}" /> chỗ</c:if></strong></div>
                </div>
                <c:if test="${not empty tour.coverImageUrl}"><img src="${pageContext.request.contextPath}/${tour.coverImageUrl}" alt="Ảnh bìa" style="margin-top:16px; max-width:360px; border-radius:12px;"></c:if>
                <c:if test="${not empty tour.shortDescription}"><p style="margin-bottom:0;"><c:out value="${tour.shortDescription}" /></p></c:if>
            </div>

            <div class="card card-section">
                <h2 class="section-title"><span class="section-index">2</span>Lịch khởi hành & giá</h2>
                <table class="tour-table compact-table">
                    <thead><tr><th>Ngày đi</th><th>Ngày về</th><th>Hạn chót bán</th><th>Tối thiểu</th><th>Đã đặt/Tối đa</th><th>Đủ tối thiểu?</th><th>Hướng dẫn viên</th><th>Lái xe</th><th>Giá</th><th>Trạng thái</th><th>Sửa</th></tr></thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty tour.schedules}"><tr><td colspan="11">Chưa có lịch khởi hành.</td></tr></c:when>
                        <c:otherwise>
                            <c:forEach var="schedule" items="${tour.schedules}">
                                <tr>
                                    <td><fmt:formatDate value="${schedule.departureDate}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatDate value="${schedule.returnDate}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatDate value="${schedule.bookingCloseDate}" pattern="dd/MM/yyyy" /><br><small>${schedule.saleDeadlineText}</small><c:if test="${not empty schedule.saleWarning}"><br><small class="field-error">${schedule.saleWarning}</small></c:if></td>
                                    <td><c:out value="${schedule.minParticipants}" /></td>
                                    <td><span class="capacity ${schedule.minimumStatusCssClass}">${schedule.capacityText}</span></td>
                                    <td><small>${schedule.minimumStatusText}</small></td>
                                    <td><c:out value="${schedule.guideDisplay}" /></td>
                                    <td><c:out value="${schedule.driverDisplay}" /></td>
                                    <td><span class="price-summary" data-tooltip="${fn:escapeXml(schedule.priceTooltip)}"><c:out value="${schedule.displayPriceText}" /> VND</span></td>
                                    <td><span class="status-pill ${schedule.scheduleStatusCssClass}"><c:out value="${schedule.scheduleStatusText}" /></span></td>
                                    <td><c:choose><c:when test="${schedule.editable && tour.canAddOrEditSchedule}"><a href="${pageContext.request.contextPath}/staff/tours/edit?id=${tour.tourID}">Sửa</a></c:when><c:otherwise><span class="text-muted" title="${schedule.lockedReason}">Đã khóa</span></c:otherwise></c:choose></td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="card card-section"><h2 class="section-title"><span class="section-index">3</span>Lịch trình theo ngày</h2><div class="day-grid"><c:forEach var="item" items="${tour.itineraries}"><div class="day-card"><div class="day-card-header"><div class="day-title">Ngày <c:out value="${item.dayNumber}" /></div></div><p><strong>Di chuyển:</strong> <c:out value="${item.transportDescription}" /></p><p><strong>Hoạt động:</strong><br><c:out value="${item.experienceActivities}" /></p><c:if test="${not empty item.accommodationDescription}"><p><strong>Lưu trú:</strong> <c:out value="${item.accommodationDescription}" /></p></c:if><c:if test="${not empty item.note}"><p><strong>Lưu ý:</strong> <c:out value="${item.note}" /></p></c:if></div></c:forEach></div></div>

            <div class="card card-section"><h2 class="section-title"><span class="section-index">4</span>Dịch vụ cộng thêm</h2><c:choose><c:when test="${empty tour.optionalServices}"><p class="help-text">Chưa có dịch vụ cộng thêm.</p></c:when><c:otherwise><div class="addon-list"><c:forEach var="service" items="${tour.optionalServices}"><div class="addon-item"><span>＋</span><span><c:out value="${service.serviceName}" /></span><span class="addon-price"><fmt:formatNumber value="${service.price}" type="number" groupingUsed="true" /> VND</span></div></c:forEach></div></c:otherwise></c:choose></div>
        </section>
    </main>
</div>
<jsp:include page="/WEB-INF/views/staff/fragments/system-error-modal.jsp" />
</body>
</html>
