<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phân bổ tài nguyên - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />

    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>

        <section class="staff-content">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Phân bổ tài nguyên</h1>
                    <div class="page-subtitle">Chọn lịch khởi hành để phân bổ xe, phòng, bữa ăn và dịch vụ vận hành nội bộ.</div>
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/staff/tours">← Quản lý tour</a>
            </div>

            <c:if test="${not empty systemError}">
                <div class="alert alert-error"><c:out value="${systemError}" /></div>
            </c:if>

            <form class="card filter-card" method="get" action="${pageContext.request.contextPath}/staff/resources">
                <div class="filter-row">
                    <input class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo mã tour hoặc tên tour...">
                    <select class="form-select" name="status">
                        <option value="">Tất cả trạng thái lịch</option>
                        <option value="Draft" ${status == 'Draft' ? 'selected' : ''}>Chưa mở bán</option>
                        <option value="PendingApproval" ${status == 'PendingApproval' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="Open" ${status == 'Open' ? 'selected' : ''}>Đang mở bán</option>
                        <option value="Full" ${status == 'Full' ? 'selected' : ''}>Đã đủ khách</option>
                        <option value="Closed" ${status == 'Closed' ? 'selected' : ''}>Đã đóng bán</option>
                        <option value="Departed" ${status == 'Departed' ? 'selected' : ''}>Đã khởi hành</option>
                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                    <button class="btn" type="submit">Lọc</button>
                </div>
            </form>

            <div class="card table-card">
                <table class="tour-table">
                    <thead>
                    <tr>
                        <th>Tour</th>
                        <th>Khởi hành</th>
                        <th>Hạn chót bán</th>
                        <th>Khách</th>
                        <th>Tối thiểu</th>
                        <th>Tài nguyên</th>
                        <th>Trạng thái lịch</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty schedules}">
                            <tr><td colspan="8">Chưa có lịch khởi hành nào để phân bổ tài nguyên.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="schedule" items="${schedules}">
                                <tr>
                                    <td>
                                        <strong><c:out value="${schedule.tourCode}" /></strong><br>
                                        <small><c:out value="${schedule.tourName}" /></small>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${schedule.departureDate}" pattern="dd/MM/yyyy" />
                                        <br><small>về <fmt:formatDate value="${schedule.returnDate}" pattern="dd/MM/yyyy" /></small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty schedule.bookingDeadline}">
                                                <fmt:formatDate value="${schedule.bookingDeadline}" pattern="dd/MM/yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong><c:out value="${schedule.passengerSummary}" /></strong>
                                        <c:if test="${schedule.belowMinimum}">
                                            <br><small class="field-error">Chưa đủ tối thiểu</small>
                                        </c:if>
                                    </td>
                                    <td><c:out value="${schedule.minParticipants}" /> khách</td>
                                    <td><c:out value="${schedule.resourceCount}" /> mục</td>
                                    <td><span class="status-pill ${schedule.scheduleStatusCssClass}"><c:out value="${schedule.scheduleStatusText}" /></span></td>
                                    <td>
                                        <a class="btn btn-small btn-primary" href="${pageContext.request.contextPath}/staff/resources/assign?tourScheduleID=${schedule.tourScheduleID}">Phân bổ</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
