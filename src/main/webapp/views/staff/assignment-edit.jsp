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
<fmt:formatDate value="${assignment.pickupTime}" pattern="dd/MM/yyyy HH:mm" var="pickupTimeValue"/>
<fmt:formatDate value="${assignment.checkInDeadline}" pattern="dd/MM/yyyy HH:mm" var="checkInDeadlineValue"/>

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

        <c:if test="${param.error == 'duplicateCustomer'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Booking hoặc khách đặt này đã được phân công cho lịch tour này. Vui lòng xử lý phân công trùng trước.
            </div>
        </c:if>

        <c:if test="${param.error == 'duplicateGuide'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đã được phân công cho lịch tour này. Vui lòng chọn hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'guideScheduleOverlap'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đã có tour khác bị trùng ngày diễn ra. Vui lòng chọn hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'guideUnavailable'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đang có phân công chưa hoàn thành. Vui lòng chọn hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'updateFailed'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Không cập nhật được phân công. Vui lòng tải lại trang và thử lại.
            </div>
        </c:if>

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

                        <div class="col-md-6">
                            <label class="form-label">Điểm hẹn</label>
                            <input type="text" name="meetingPoint" class="form-control"
                                   value="${assignment.meetingPoint}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Giờ đón</label>
                            <input type="text" class="form-control" value="${pickupTimeValue}" readonly>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Hạn check-in</label>
                            <input type="text" class="form-control" value="${checkInDeadlineValue}" readonly>
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
