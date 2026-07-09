<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | EditTourAssignment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>
<body>
<fmt:formatDate value="${assignment.pickupTime}" pattern="yyyy-MM-dd'T'HH:mm" var="pickupTimeValue"/>
<fmt:formatDate value="${assignment.checkInDeadline}" pattern="yyyy-MM-dd'T'HH:mm" var="checkInDeadlineValue"/>
<fmt:formatDate value="${assignment.actualStartAt}" pattern="yyyy-MM-dd'T'HH:mm" var="actualStartAtValue"/>
<fmt:formatDate value="${assignment.actualEndAt}" pattern="yyyy-MM-dd'T'HH:mm" var="actualEndAtValue"/>

<div class="workspace-layout">
    <aside class="workspace-sidebar">
        <div class="brand-box">
            <div class="brand-logo staff">WV</div>
            <h2>WonderVN</h2>
            <p>Staff Workspace</p>
        </div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home"><i class="fa-solid fa-house"></i><span>Trang staff</span></a>
        <div class="nav-section-title">Vận hành</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking"><i class="fa-solid fa-calendar-check"></i><span>Booking</span></a>
        <a class="sidebar-link active staff" href="${pageContext.request.contextPath}/staff/assignment"><i class="fa-solid fa-user-tie"></i><span>Tour assignment</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-map-location-dot"></i><span>Tour</span></a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span></a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>EditTourAssignment</h1>
                <p>Đổi guide khi lịch tour thay đổi hoặc guide không khả dụng.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>Quay lại
                </a>
            </div>
        </div>

        <c:if test="${param.error == 'guideBusy'}"><div class="alert alert-danger">Guide mới đang bị trùng lịch. Vui lòng chọn guide khác.</div></c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>${empty assignment.assignmentCode ? assignment.assignmentID : assignment.assignmentCode}</h2>
                    <p>${assignmentDetail.tourName}</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="detail-grid mb-4">
                    <div class="detail-item"><span>Lịch tour</span><strong>#${assignment.tourScheduleID}</strong></div>
                    <div class="detail-item"><span>Tour</span><strong>${assignmentDetail.tourName}</strong></div>
                    <div class="detail-item"><span>Tuyến</span><strong>${assignmentDetail.startPlace} → ${assignmentDetail.endPlace}</strong></div>
                    <div class="detail-item"><span>Khởi hành</span><strong><fmt:formatDate value="${assignmentDetail.departureDate}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/staff/assignment">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                    <input type="hidden" name="tourScheduleID" value="${assignment.tourScheduleID}">
                    <input type="hidden" name="bookingID" value="${assignment.bookingID}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Guide phụ trách</label>
                            <select name="userID" class="form-select" required>
                                <c:forEach var="g" items="${guideList}">
                                    <option value="${g.userID}" ${g.userID == assignment.userID ? 'selected' : ''}>
                                        ${g.firstName} ${g.lastName} - ${g.phone}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Vai trò</label>
                            <select name="roleInTour" class="form-select" required>
                                <option value="Tour Guide" ${assignment.roleInTour == 'Tour Guide' ? 'selected' : ''}>Tour Guide</option>
                                <option value="Lead Guide" ${assignment.roleInTour == 'Lead Guide' ? 'selected' : ''}>Lead Guide</option>
                                <option value="Assistant Guide" ${assignment.roleInTour == 'Assistant Guide' ? 'selected' : ''}>Assistant Guide</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Trạng thái</label>
                            <select name="assignmentStatus" class="form-select" required>
                                <option value="Pending" ${assignment.assignmentStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Accepted" ${assignment.assignmentStatus == 'Accepted' ? 'selected' : ''}>Accepted</option>
                                <option value="Confirmed" ${assignment.assignmentStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="In Progress" ${assignment.assignmentStatus == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                <option value="Completed" ${assignment.assignmentStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                <option value="Cancelled" ${assignment.assignmentStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                <option value="Rejected" ${assignment.assignmentStatus == 'Rejected' ? 'selected' : ''}>Rejected</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Độ ưu tiên</label>
                            <select name="priorityLevel" class="form-select" required>
                                <option value="Normal" ${assignment.priorityLevel == 'Normal' ? 'selected' : ''}>Normal</option>
                                <option value="Low" ${assignment.priorityLevel == 'Low' ? 'selected' : ''}>Low</option>
                                <option value="High" ${assignment.priorityLevel == 'High' ? 'selected' : ''}>High</option>
                                <option value="Urgent" ${assignment.priorityLevel == 'Urgent' ? 'selected' : ''}>Urgent</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Lý do hủy/từ chối</label>
                            <input name="rejectionReason" class="form-control" value="${assignment.rejectionReason}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Điểm đón</label>
                            <input name="meetingPoint" class="form-control" value="${assignment.meetingPoint}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giờ đón</label>
                            <input type="datetime-local" name="pickupTime" class="form-control" value="${pickupTimeValue}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Deadline check-in</label>
                            <input type="datetime-local" name="checkInDeadline" class="form-control" value="${checkInDeadlineValue}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Bắt đầu thực tế</label>
                            <input type="datetime-local" name="actualStartAt" class="form-control" value="${actualStartAtValue}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Kết thúc thực tế</label>
                            <input type="datetime-local" name="actualEndAt" class="form-control" value="${actualEndAtValue}">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú staff</label>
                            <textarea name="staffNote" class="form-control" rows="4">${assignment.staffNote}</textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Ghi chú guide</label>
                            <textarea name="guideNote" class="form-control" rows="4">${assignment.guideNote}</textarea>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Yêu cầu/ghi chú khách</label>
                            <textarea name="customerNote" class="form-control" rows="4">${assignment.customerNote}</textarea>
                        </div>
                    </div>

                    <div class="top-actions mt-4">
                        <button class="top-action-btn btn-primary-action" type="submit">
                            <i class="fa-solid fa-floppy-disk"></i>Cập nhật
                        </button>
                        <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment?action=view&id=${assignment.assignmentID}">Hủy</a>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>
</body>
</html>
