<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phân công nhân sự tour - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />

    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>

        <section class="staff-content">
            <div class="breadcrumb">Staff / Phân công nhân sự tour</div>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Phân công nhân sự tour</h1>
                    <div class="page-subtitle">Phân bổ hướng dẫn viên, tài xế, điều phối viên và nhân sự vận hành cho từng lịch khởi hành.</div>
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/staff/resources">Phân bổ tài nguyên →</a>
            </div>

            <c:if test="${not empty systemError}">
                <div class="alert alert-error"><c:out value="${systemError}" /></div>
            </c:if>

            <form class="card filter-card" method="get" action="${pageContext.request.contextPath}/staff/assignments">
                <div class="filter-row staff-assignment-filter-row">
                    <div class="form-group">
                        <label>Tìm tour</label>
                        <input class="form-control" name="keyword" value="${keyword}" placeholder="Mã tour hoặc tên tour">
                    </div>
                    <div class="form-group">
                        <label>Trạng thái lịch</label>
                        <select class="form-select" name="status">
                            <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                            <option value="Draft" ${status == 'Draft' ? 'selected' : ''}>Chưa mở bán</option>
                            <option value="PendingApproval" ${status == 'PendingApproval' ? 'selected' : ''}>Chờ duyệt</option>
                            <option value="Open" ${status == 'Open' ? 'selected' : ''}>Đang mở bán</option>
                            <option value="Full" ${status == 'Full' ? 'selected' : ''}>Đã đủ khách</option>
                            <option value="Closed" ${status == 'Closed' ? 'selected' : ''}>Đã đóng bán</option>
                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="form-group filter-button-group">
                        <label>&nbsp;</label>
                        <button class="btn btn-primary" type="submit">Lọc dữ liệu</button>
                    </div>
                </div>
            </form>

            <div class="card table-card">
                <table class="tour-table compact-table">
                    <thead>
                    <tr>
                        <th>Tour</th>
                        <th>Lịch khởi hành</th>
                        <th>Khách</th>
                        <th>Nhân sự đã phân công</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="schedule" items="${schedules}">
                        <tr>
                            <td>
                                <strong><c:out value="${schedule.tourCode}" /></strong><br>
                                <span class="muted-text"><c:out value="${schedule.tourName}" /></span>
                            </td>
                            <td>
                                <fmt:formatDate value="${schedule.departureDate}" pattern="dd/MM/yyyy" />
                                →
                                <fmt:formatDate value="${schedule.returnDate}" pattern="dd/MM/yyyy" />
                                <br>
                                <span class="muted-text">Hạn chót: <fmt:formatDate value="${schedule.bookingDeadline}" pattern="dd/MM/yyyy HH:mm" /></span>
                            </td>
                            <td>
                                <strong><c:out value="${schedule.passengerSummary}" /></strong><br>
                                <span class="${schedule.belowMinimum ? 'danger-text' : 'success-text'}">
                                    Tối thiểu: <c:out value="${schedule.minParticipants}" /> · <c:out value="${schedule.minimumStatusText}" />
                                </span>
                            </td>
                            <td>
                                <div class="staff-count-grid">
                                    <span>HDV: <strong><c:out value="${schedule.guideCount}" /></strong></span>
                                    <span>Tài xế: <strong><c:out value="${schedule.driverCount}" /></strong></span>
                                </div>
                            </td>
                            <td><span class="status-pill ${schedule.scheduleStatusCssClass}"><c:out value="${schedule.scheduleStatusText}" /></span></td>
                            <td>
                                <a class="btn btn-small btn-primary" href="${pageContext.request.contextPath}/staff/assignments/detail?tourScheduleID=${schedule.tourScheduleID}">Phân công</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty schedules}">
                        <tr><td colspan="6">Chưa có lịch khởi hành phù hợp.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
