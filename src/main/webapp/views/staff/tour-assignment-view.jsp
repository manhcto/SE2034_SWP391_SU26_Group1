<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Chi tiết phân công tour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>
<body>
<div class="workspace-layout">
    <aside class="workspace-sidebar">
        <div class="brand-box">
            <div class="brand-logo staff">WV</div>
            <h2>WonderVN</h2>
            <p>Khu vực nhân viên</p>
        </div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home"><i class="fa-solid fa-house"></i><span>Trang nhân viên</span></a>
        <div class="nav-section-title">Vận hành</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking"><i class="fa-solid fa-calendar-check"></i><span>Booking</span></a>
        <a class="sidebar-link active staff" href="${pageContext.request.contextPath}/staff/assignment"><i class="fa-solid fa-user-tie"></i><span>Điều phối hướng dẫn viên</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-map-location-dot"></i><span>Tour</span></a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span></a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Chi tiết phân công tour</h1>
                <p>Chi tiết phân công gồm lịch tour, hướng dẫn viên, danh sách khách và tóm tắt booking.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>Quay lại
                </a>
                <a class="top-action-btn btn-primary-action" href="${pageContext.request.contextPath}/staff/assignment?action=edit&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-pen-to-square"></i>Sửa phân công
                </a>
            </div>
        </div>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>${empty assignment.assignmentCode ? assignment.assignmentID : assignment.assignmentCode}</h2>
                    <p>${assignment.tourName}</p>
                </div>
                <span class="status-pill status-assigned">${assignment.assignmentStatusLabel}</span>
            </div>
            <div class="panel-body">
                <div class="detail-grid">
                    <div class="detail-item"><span>Lịch tour</span><strong>#${assignment.tourScheduleID} · ${assignment.scheduleStatus}</strong></div>
                    <div class="detail-item"><span>Tour</span><strong>${assignment.tourName}</strong></div>
                    <div class="detail-item"><span>Tuyến</span><strong>${assignment.startPlace} → ${assignment.endPlace}</strong></div>
                    <div class="detail-item"><span>Thời gian</span><strong><fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy"/> - <fmt:formatDate value="${assignment.endDate}" pattern="dd/MM/yyyy"/></strong></div>
                    <div class="detail-item"><span>Hướng dẫn viên</span><strong>${assignment.guideName}</strong></div>
                    <div class="detail-item"><span>Liên hệ hướng dẫn viên</span><strong>${assignment.guidePhone} · ${assignment.guideEmail}</strong></div>
                    <div class="detail-item"><span>Vai trò</span><strong>${assignment.roleInTour}</strong></div>
                    <div class="detail-item"><span>Người phân công</span><strong>${empty assignment.assignedByName ? 'Chưa lưu' : assignment.assignedByName}</strong></div>
                    <div class="detail-item"><span>Điểm đón</span><strong>${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</strong></div>
                    <div class="detail-item"><span>Giờ đón / hạn check-in</span><strong><fmt:formatDate value="${assignment.pickupTime}" pattern="dd/MM/yyyy HH:mm"/> / <fmt:formatDate value="${assignment.checkInDeadline}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                    <div class="detail-item"><span>Tóm tắt booking</span><strong>${assignment.bookingCount} lượt đặt · ${assignment.totalGuests} khách</strong></div>
                    <div class="detail-item"><span>Sức chứa</span><strong>${assignment.bookedQuantity}/${assignment.maxParticipants}</strong></div>
                    <div class="detail-item"><span>Ghi chú nhân viên</span><strong>${empty assignment.staffNote ? 'Không có' : assignment.staffNote}</strong></div>
                    <div class="detail-item"><span>Ghi chú hướng dẫn viên</span><strong>${empty assignment.guideNote ? 'Không có' : assignment.guideNote}</strong></div>
                    <div class="detail-item"><span>Yêu cầu/ghi chú khách</span><strong>${empty assignment.customerNote ? 'Không có' : assignment.customerNote}</strong></div>
                    <div class="detail-item"><span>Mốc trạng thái</span><strong>Đã nhận: <fmt:formatDate value="${assignment.acceptedAt}" pattern="dd/MM/yyyy HH:mm"/> · Hoàn thành: <fmt:formatDate value="${assignment.completedAt}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                </div>
            </div>
        </section>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>Danh sách khách</h2>
                    <p>Danh sách khách lấy từ Booking_Traveler theo lịch tour.</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Booking</th>
                            <th>Khách</th>
                            <th>Loại</th>
                            <th>Liên hệ</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${travelerList}" var="t">
                            <tr>
                                <td>${t.bookingCode}</td>
                                <td><strong>${t.fullName}</strong><div class="text-muted small">${t.gender}</div></td>
                                <td>${t.travelerType}</td>
                                <td>${empty t.phone ? 'Không có' : t.phone}</td>
                                <td><span class="status-pill status-checked">${t.travelerStatusLabel}</span></td>
                                <td>${empty t.note ? 'Không có' : t.note}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty travelerList}">
                            <tr><td colspan="6" class="text-center text-muted py-5">Chưa có danh sách khách cho tour này.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Nhật ký tiến độ</h2>
                    <p>Nhật ký lịch trình do hướng dẫn viên cập nhật theo thời gian thực.</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>Tiêu đề</th>
                            <th>Nội dung</th>
                            <th>Người ghi</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${progressLogs}" var="log">
                            <tr>
                                <td><fmt:formatDate value="${log.logTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><span class="status-pill status-progress">${log.progressStatusLabel}</span></td>
                                <td><strong>${empty log.title ? 'Cập nhật tour' : log.title}</strong></td>
                                <td>${empty log.content ? 'Không có nội dung' : log.content}</td>
                                <td>${empty log.loggedByName ? log.loggedByUserID : log.loggedByName}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty progressLogs}">
                            <tr><td colspan="5" class="text-center text-muted py-5">Chưa có nhật ký tiến độ.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
