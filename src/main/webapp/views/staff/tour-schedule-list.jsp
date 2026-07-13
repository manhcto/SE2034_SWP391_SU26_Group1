<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Lịch khởi hành</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root{--primary:#2563eb;--primary-dark:#1d4ed8;--dark:#0f172a;--muted:#64748b;--bg:#f3f6fb;--border:#e2e8f0;--shadow:0 16px 36px rgba(15,23,42,.08)}
        body{margin:0;background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;color:#1e293b}.admin-layout{display:flex;min-height:100vh}.admin-main{flex:1;min-width:0;padding:28px}.page-card{background:#fff;border:1px solid var(--border);border-radius:24px;box-shadow:var(--shadow);margin-bottom:22px;overflow:hidden}.topbar{padding:24px;display:flex;align-items:center;justify-content:space-between;gap:18px}.topbar h1{margin:0;color:var(--dark);font-size:28px;font-weight:900}.topbar p{margin:6px 0 0;color:var(--muted);font-weight:600}.toolbar{display:flex;gap:10px;flex-wrap:wrap}.btn-main,.btn-soft,.btn-outline-soft{border-radius:14px;padding:11px 16px;font-weight:800;text-decoration:none;display:inline-flex;align-items:center;gap:8px;border:0;white-space:nowrap}.btn-main{background:var(--primary);color:#fff}.btn-main:hover{background:var(--primary-dark);color:#fff}.btn-soft{background:#eff6ff;color:#1d4ed8}.btn-soft:hover{background:#dbeafe;color:#1d4ed8}.btn-outline-soft{background:#fff;color:#475569;border:1px solid var(--border)}.btn-outline-soft:hover{background:#f8fafc;color:#0f172a}.table{margin-bottom:0}.table thead th{background:#f8fafc;color:#475569;font-size:12px;text-transform:uppercase;letter-spacing:.04em;border-bottom:1px solid var(--border)}.table td,.table th{vertical-align:middle;padding:15px 16px}.status-badge{border-radius:999px;padding:7px 11px;font-size:12px;font-weight:900;display:inline-flex}.status-Open{background:#dcfce7;color:#166534}.status-Planned{background:#e0f2fe;color:#0369a1}.status-Closed{background:#fef3c7;color:#92400e}.status-Cancelled{background:#fee2e2;color:#991b1b}.status-Completed{background:#ede9fe;color:#5b21b6}.tour-status{background:#f8fafc;border:1px solid var(--border);border-radius:14px;padding:10px 12px;font-weight:800;color:#334155}.action-group{display:flex;gap:8px;justify-content:flex-end;flex-wrap:wrap}.action-btn{border-radius:12px;padding:8px 10px;text-decoration:none;font-weight:800;font-size:13px;display:inline-flex;align-items:center;gap:6px}.action-view{background:#eff6ff;color:#1d4ed8}.action-edit{background:#f8fafc;color:#475569;border:1px solid var(--border)}.empty-box{padding:44px;text-align:center;color:var(--muted)}.muted{color:var(--muted)}@media(max-width:992px){.admin-layout{display:block}.admin-main{padding:18px}.topbar{display:block}.toolbar{margin-top:14px}.action-group{justify-content:flex-start}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp" />
    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>Lịch khởi hành</h1>
                <p>${tour.tourCode} · ${tour.tourName}</p>
                <div class="mt-2 tour-status">Trạng thái tour: ${tour.displayStatus}</div>
            </div>
            <div class="toolbar">
                <a class="btn-outline-soft" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-list"></i> Danh sách tour</a>
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/detail?id=${tour.tourID}"><i class="fa-solid fa-map"></i> Chi tiết tour</a>
                <c:if test="${canManageSchedule}">
                    <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}"><i class="fa-solid fa-plus"></i> Thêm lịch</a>
                </c:if>
            </div>
        </section>

        <c:if test="${!canOpenSchedule}">
            <c:choose>
                <c:when test="${tour.status == 'Inactive'}">
                    <div class="alert alert-warning fw-bold">Tour đang ngừng bán, các lịch đang mở bán sẽ được đồng bộ về Đóng bán để tránh khách đặt nhầm.</div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info fw-bold">Tour chưa ở trạng thái Đang bán, nên lịch khởi hành chỉ được để Chưa mở bán. Lịch sẽ không hiển thị như lịch đang bán.</div>
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${messageCode == 'scheduleAddSuccess'}"><div class="alert alert-success fw-bold">Thêm lịch khởi hành thành công.</div></c:if>
        <c:if test="${messageCode == 'scheduleAddFail'}"><div class="alert alert-danger fw-bold">Thêm lịch khởi hành thất bại.</div></c:if>
        <c:if test="${messageCode == 'scheduleUpdateSuccess'}"><div class="alert alert-success fw-bold">Cập nhật lịch khởi hành thành công.</div></c:if>
        <c:if test="${messageCode == 'noSchedulePermission'}"><div class="alert alert-warning fw-bold">Tour đang ngừng bán nên không được thêm/sửa lịch khởi hành.</div></c:if>

        <section class="page-card">
            <c:choose>
                <c:when test="${empty scheduleList}">
                    <div class="empty-box">
                        <i class="fa-solid fa-calendar-days fa-3x mb-3"></i>
                        <h5 class="fw-bold">Tour chưa có lịch khởi hành</h5>
                        <p>Thêm lịch mới để chuẩn bị mở bán theo ngày/tháng.</p>
                        <c:if test="${canManageSchedule}"><a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}">Thêm lịch</a></c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>Ngày đi</th>
                                <th>Ngày về</th>
                                <th>Giờ</th>
                                <th>Phương tiện</th>
                                <th>Chốt bán</th>
                                <th>Khách</th>
                                <th>Giá người lớn</th>
                                <th>Trạng thái</th>
                                <th class="text-end" style="width:180px">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="schedule" items="${scheduleList}">
                                <tr>
                                    <td><strong><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy"/></strong></td>
                                    <td><fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${empty schedule.departureTime ? '-' : schedule.departureTime}</td>
                                    <td>${empty schedule.scheduleTransportType ? tour.mainTransportType : schedule.scheduleTransportType}</td>
                                    <td><fmt:formatDate value="${schedule.bookingDeadline}" pattern="dd/MM/yyyy"/></td>
                                    <td><strong>${schedule.quantity}</strong>/${schedule.maxParticipants}<br><small class="muted">Tối thiểu ${schedule.minParticipants}</small></td>
                                    <td><fmt:formatNumber value="${empty schedule.adultPrice ? tour.adultPrice : schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${schedule.scheduleStatus == 'Open'}"><span class="status-badge status-Open">Mở bán</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Closed'}"><span class="status-badge status-Closed">Đóng bán</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Cancelled'}"><span class="status-badge status-Cancelled">Đã hủy</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Completed'}"><span class="status-badge status-Completed">Hoàn tất</span></c:when>
                                            <c:otherwise><span class="status-badge status-Planned">Chưa mở bán</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a class="action-btn action-view" href="${pageContext.request.contextPath}/staff/tour/schedule/detail?id=${schedule.tourScheduleID}" title="Xem chi tiết lịch"><i class="fa-solid fa-eye"></i> Xem</a>
                                            <c:if test="${canManageSchedule && schedule.scheduleStatus != 'Cancelled' && schedule.scheduleStatus != 'Completed'}">
                                                <a class="action-btn action-edit" href="${pageContext.request.contextPath}/staff/tour/schedule/edit?id=${schedule.tourScheduleID}" title="Sửa lịch"><i class="fa-solid fa-pen"></i> Sửa</a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
</body>
</html>
