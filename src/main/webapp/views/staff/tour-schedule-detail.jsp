<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết lịch khởi hành</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root{--primary:#2563eb;--primary-dark:#1d4ed8;--dark:#0f172a;--muted:#64748b;--bg:#f3f6fb;--border:#e2e8f0;--shadow:0 16px 36px rgba(15,23,42,.08)}
        body{margin:0;background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;color:#1e293b}.admin-layout{display:flex;min-height:100vh}.admin-main{flex:1;min-width:0;padding:28px}.page-card{background:#fff;border:1px solid var(--border);border-radius:24px;box-shadow:var(--shadow);margin-bottom:22px;overflow:hidden}.topbar{padding:24px;display:flex;align-items:center;justify-content:space-between;gap:18px}.topbar h1{margin:0;color:var(--dark);font-size:28px;font-weight:900}.topbar p{margin:6px 0 0;color:var(--muted);font-weight:600}.toolbar{display:flex;gap:10px;flex-wrap:wrap}.btn-main,.btn-soft,.btn-outline-soft{border-radius:14px;padding:11px 16px;font-weight:800;text-decoration:none;display:inline-flex;align-items:center;gap:8px;border:0;white-space:nowrap}.btn-main{background:var(--primary);color:#fff}.btn-main:hover{background:var(--primary-dark);color:#fff}.btn-soft{background:#eff6ff;color:#1d4ed8}.btn-soft:hover{background:#dbeafe;color:#1d4ed8}.btn-outline-soft{background:#fff;color:#475569;border:1px solid var(--border)}.btn-outline-soft:hover{background:#f8fafc;color:#0f172a}.section-title{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px}.section-title h5{margin:0;font-weight:900;color:var(--dark)}.section-body{padding:22px}.info-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}.info-item{border:1px solid var(--border);border-radius:16px;padding:14px;background:#fbfdff}.info-item small{display:block;color:var(--muted);font-weight:800;margin-bottom:5px}.info-item strong{color:var(--dark)}.status-badge{border-radius:999px;padding:7px 11px;font-size:12px;font-weight:900;display:inline-flex}.status-Open{background:#dcfce7;color:#166534}.status-Planned{background:#e0f2fe;color:#0369a1}.status-Closed{background:#fef3c7;color:#92400e}.status-Cancelled{background:#fee2e2;color:#991b1b}.status-Completed{background:#ede9fe;color:#5b21b6}.policy-box{background:#f8fafc;border:1px solid var(--border);border-radius:16px;padding:16px;color:#475569;line-height:1.6}.tour-note{background:#f8fafc;border:1px solid var(--border);border-radius:14px;padding:10px 12px;font-weight:800;color:#334155;margin-top:10px}@media(max-width:1100px){.info-grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:700px){.admin-layout{display:block}.admin-main{padding:18px}.topbar{display:block}.toolbar{margin-top:14px}.info-grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp" />
    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>Chi tiết lịch khởi hành</h1>
                <p>${tour.tourCode} · ${tour.tourName}</p>
                <div class="tour-note">Trạng thái tour: ${tour.displayStatus}</div>
            </div>
            <div class="toolbar">
                <a class="btn-outline-soft" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-list"></i> Danh sách tour</a>
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}"><i class="fa-solid fa-calendar-days"></i> Danh sách lịch</a>
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/detail?id=${tour.tourID}"><i class="fa-solid fa-map"></i> Chi tiết tour</a>
                <c:if test="${canEditSchedule}"><a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/schedule/edit?id=${schedule.tourScheduleID}"><i class="fa-solid fa-pen"></i> Sửa lịch</a></c:if>
            </div>
        </section>

        <c:if test="${tour.status != 'Active'}">
            <c:choose>
                <c:when test="${tour.status == 'Inactive'}">
                    <div class="alert alert-warning fw-bold">Tour đang ngừng bán, lịch đang mở bán sẽ được đồng bộ về Đóng bán để tránh khách đặt nhầm.</div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info fw-bold">Tour chưa ở trạng thái Đang bán, nên lịch này được hiển thị là Chưa mở bán để tránh nhầm với lịch đã bán được.</div>
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${messageCode == 'scheduleUpdateSuccess'}"><div class="alert alert-success fw-bold">Cập nhật lịch khởi hành thành công.</div></c:if>
        <c:if test="${messageCode == 'scheduleUpdateFail'}"><div class="alert alert-danger fw-bold">Cập nhật lịch khởi hành thất bại.</div></c:if>
        <c:if test="${messageCode == 'noScheduleEditPermission'}"><div class="alert alert-warning fw-bold">Lịch này không được sửa do tour đang ngừng bán hoặc lịch đã hủy/hoàn tất.</div></c:if>

        <section class="page-card">
            <div class="section-title"><i class="fa-solid fa-calendar-check text-primary"></i><h5>Thông tin vận hành</h5></div>
            <div class="section-body">
                <div class="info-grid">
                    <div class="info-item"><small>Trạng thái lịch</small>
                        <c:choose>
                            <c:when test="${schedule.scheduleStatus == 'Open'}"><span class="status-badge status-Open">Mở bán</span></c:when>
                            <c:when test="${schedule.scheduleStatus == 'Closed'}"><span class="status-badge status-Closed">Đóng bán</span></c:when>
                            <c:when test="${schedule.scheduleStatus == 'Cancelled'}"><span class="status-badge status-Cancelled">Đã hủy</span></c:when>
                            <c:when test="${schedule.scheduleStatus == 'Completed'}"><span class="status-badge status-Completed">Hoàn tất</span></c:when>
                            <c:otherwise><span class="status-badge status-Planned">Chưa mở bán</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="info-item"><small>Ngày xuất phát</small><strong><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy"/></strong></div>
                    <div class="info-item"><small>Ngày kết thúc</small><strong><fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy"/></strong></div>
                    <div class="info-item"><small>Ngày chốt bán</small><strong><fmt:formatDate value="${schedule.bookingDeadline}" pattern="dd/MM/yyyy"/></strong></div>
                    <div class="info-item"><small>Giờ xuất phát</small><strong>${empty schedule.departureTime ? '-' : schedule.departureTime}</strong></div>
                    <div class="info-item"><small>Giờ về dự kiến</small><strong>${empty schedule.expectedReturnTime ? '-' : schedule.expectedReturnTime}</strong></div>
                    <div class="info-item"><small>Phương tiện</small><strong>${empty schedule.scheduleTransportType ? tour.mainTransportType : schedule.scheduleTransportType}</strong></div>
                    <div class="info-item"><small>Số khách tối thiểu</small><strong>${schedule.minParticipants}</strong></div>
                    <div class="info-item"><small>Đã đặt / Tối đa</small><strong>${schedule.quantity} / ${schedule.maxParticipants}</strong></div>
                    <div class="info-item"><small>Còn chỗ</small><strong>${schedule.remainingSeats}</strong></div>
                    <div class="info-item"><small>Tối đa mỗi booking</small><strong>${schedule.maxParticipantsPerBooking}</strong></div>
                    <div class="info-item"><small>Ngày tạo</small><strong><fmt:formatDate value="${schedule.createdAt}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                    <div class="info-item"><small>Cập nhật</small><strong><fmt:formatDate value="${schedule.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                </div>
            </div>
        </section>

        <section class="page-card">
            <div class="section-title"><i class="fa-solid fa-money-bill-wave text-primary"></i><h5>Giá theo lịch</h5></div>
            <div class="section-body">
                <div class="info-grid">
                    <div class="info-item"><small>Người lớn</small><strong><fmt:formatNumber value="${schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Trẻ em 5–10 tuổi</small><strong><fmt:formatNumber value="${schedule.childPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Trẻ em dưới 5 tuổi</small><strong><fmt:formatNumber value="${schedule.infantPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Trẻ em từ 10 tuổi</small><strong><fmt:formatNumber value="${schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Phụ thu phòng đơn</small><strong><fmt:formatNumber value="${schedule.singleRoomSurcharge}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>VAT</small><strong>${schedule.vatPercent}%</strong></div>
                </div>
            </div>
        </section>

        <section class="page-card">
            <div class="section-title"><i class="fa-solid fa-file-lines text-primary"></i><h5>Chính sách hủy</h5></div>
            <div class="section-body"><div class="policy-box">${empty schedule.cancellationPolicy ? 'Chưa nhập chính sách riêng cho lịch này.' : schedule.cancellationPolicy}</div></div>
        </section>
    </main>
</div>
</body>
</html>
