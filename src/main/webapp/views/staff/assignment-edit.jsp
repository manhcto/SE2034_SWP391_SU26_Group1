<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Sửa phân công tour</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css?v=staff-assignment-left-20260714" rel="stylesheet">
</head>

<body>
<fmt:formatDate value="${assignment.pickupTime}" pattern="yyyy-MM-dd'T'HH:mm" var="pickupTimeValue"/>
<fmt:formatDate value="${assignment.checkInDeadline}" pattern="yyyy-MM-dd'T'HH:mm" var="checkInDeadlineValue"/>
<fmt:formatDate value="${assignment.actualStartAt}" pattern="yyyy-MM-dd'T'HH:mm" var="actualStartAtValue"/>
<fmt:formatDate value="${assignment.actualEndAt}" pattern="yyyy-MM-dd'T'HH:mm" var="actualEndAtValue"/>

<div class="workspace-layout staff-assignment-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Sửa phân công tour</h1>
                <p>Cập nhật thông tin điều phối của phân công tour.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>
        </div>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>
                        <c:choose>
                            <c:when test="${not empty assignment.assignmentCode}">${assignment.assignmentCode}</c:when>
                            <c:otherwise>Phân công #${assignment.assignmentID}</c:otherwise>
                        </c:choose>
                    </h2>
                    <p>${assignmentDetail.tourName}</p>
                </div>
            </div>

            <div class="panel-body">
                <div class="detail-grid mb-4">
                    <div class="detail-item">
                        <span>Booking</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty assignmentDetail.bookingCode}">${assignmentDetail.bookingCode}</c:when>
                                <c:when test="${assignment.bookingID > 0}">#${assignment.bookingID}</c:when>
                                <c:otherwise>Chưa gắn booking</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                    <div class="detail-item">
                        <span>Tour</span>
                        <strong>${assignmentDetail.tourName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Tuyến</span>
                        <strong>${assignmentDetail.startPlace} → ${assignmentDetail.endPlace}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Lịch tour</span>
                        <strong>
                            <fmt:formatDate value="${assignmentDetail.departureDate}" pattern="dd/MM/yyyy"/>
                            <c:if test="${not empty assignmentDetail.endDate}">
                                đến <fmt:formatDate value="${assignmentDetail.endDate}" pattern="dd/MM/yyyy"/>
                            </c:if>
                        </strong>
                    </div>
                    <div class="detail-item">
                        <span>Khách</span>
                        <strong>${assignmentDetail.customerName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Người phân công</span>
                        <strong>${empty assignmentDetail.assignedByName ? 'Chưa lưu' : assignmentDetail.assignedByName}</strong>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/staff/assignment">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                    <input type="hidden" name="tourScheduleID" value="${assignment.tourScheduleID}">
                    <input type="hidden" name="bookingID" value="${assignment.bookingID}">

                    <div class="row g-4">
                        <div class="col-md-12">
                            <label class="form-label">Hướng dẫn viên phụ trách</label>
                            <select name="userID" class="form-select" required>
                                <c:forEach var="g" items="${guideList}">
                                    <option value="${g.userID}" ${g.userID == assignment.userID ? "selected" : ""}>
                                        ${g.firstName} ${g.lastName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Trạng thái phân công</label>
                            <select name="assignmentStatus" class="form-select" required>
                                <option value="Pending" ${assignment.assignmentStatus == 'Pending' ? 'selected' : ''}>Chờ nhận tour</option>
                                <option value="Accepted" ${assignment.assignmentStatus == 'Accepted' ? 'selected' : ''}>Đã nhận tour</option>
                                <option value="Confirmed" ${assignment.assignmentStatus == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="In Progress" ${assignment.assignmentStatus == 'In Progress' ? 'selected' : ''}>Đang diễn ra</option>
                                <option value="Completed" ${assignment.assignmentStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="Cancelled" ${assignment.assignmentStatus == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                <option value="Rejected" ${assignment.assignmentStatus == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Độ ưu tiên</label>
                            <select name="priorityLevel" class="form-select" required>
                                <option value="Normal" ${assignment.priorityLevel == 'Normal' ? 'selected' : ''}>Bình thường</option>
                                <option value="Low" ${assignment.priorityLevel == 'Low' ? 'selected' : ''}>Thấp</option>
                                <option value="High" ${assignment.priorityLevel == 'High' ? 'selected' : ''}>Cao</option>
                                <option value="Urgent" ${assignment.priorityLevel == 'Urgent' ? 'selected' : ''}>Khẩn cấp</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Lý do từ chối/hủy</label>
                            <input type="text" name="rejectionReason" class="form-control"
                                   value="${assignment.rejectionReason}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Điểm hẹn</label>
                            <input type="text" name="meetingPoint" class="form-control"
                                   value="${assignment.meetingPoint}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Giờ đón</label>
                            <input type="datetime-local" name="pickupTime" class="form-control"
                                   value="${pickupTimeValue}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Hạn check-in</label>
                            <input type="datetime-local" name="checkInDeadline" class="form-control"
                                   value="${checkInDeadlineValue}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Bắt đầu thực tế</label>
                            <input type="datetime-local" name="actualStartAt" class="form-control"
                                   value="${actualStartAtValue}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Kết thúc thực tế</label>
                            <input type="datetime-local" name="actualEndAt" class="form-control"
                                   value="${actualEndAtValue}">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú nhân viên</label>
                            <textarea name="staffNote" class="form-control" rows="4">${assignment.staffNote}</textarea>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú hướng dẫn viên</label>
                            <textarea name="guideNote" class="form-control" rows="4">${assignment.guideNote}</textarea>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú khách</label>
                            <textarea name="customerNote" class="form-control" rows="4">${assignment.customerNote}</textarea>
                        </div>
                    </div>

                    <div class="top-actions mt-4">
                        <button type="submit" class="top-action-btn btn-primary-action">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Cập nhật
                        </button>

                        <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>
</body>
</html>
