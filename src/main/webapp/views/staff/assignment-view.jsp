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
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css?v=staff-assignment-left-20260714" rel="stylesheet">
</head>

<body>
<div class="workspace-layout staff-assignment-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Chi tiết phân công tour</h1>
                <p>Xem đầy đủ thông tin đã lưu trong phân công tour.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>
                <c:if test="${!staffAssignmentLocked}">
                    <a class="top-action-btn btn-primary-action"
                       href="${pageContext.request.contextPath}/staff/assignment?action=edit&id=${assignment.assignmentID}">
                        <i class="fa-solid fa-pen-to-square"></i>
                        Sửa phân công
                    </a>
                </c:if>
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
                    <p>${assignment.tourName}</p>
                </div>
            </div>

            <div class="panel-body">
                <div class="detail-grid">
                    <div class="detail-item">
                        <span>Mã phân công</span>
                        <strong>${empty assignment.assignmentCode ? assignment.assignmentID : assignment.assignmentCode}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Booking</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty assignment.bookingCode}">${assignment.bookingCode}</c:when>
                                <c:when test="${assignment.bookingID > 0}">#${assignment.bookingID}</c:when>
                                <c:otherwise>Chưa gắn booking</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                    <div class="detail-item">
                        <span>Loại booking</span>
                        <strong>${empty assignment.bookingType ? 'Không có' : assignment.bookingType}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Tour</span>
                        <strong>${assignment.tourName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Tuyến tour</span>
                        <strong>${assignment.startPlace} → ${assignment.endPlace}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Mã lịch trình</span>
                        <strong>#${assignment.tourScheduleID}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Lịch trình</span>
                        <strong>
                            <fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy"/>
                            <c:if test="${not empty assignment.endDate}">
                                đến <fmt:formatDate value="${assignment.endDate}" pattern="dd/MM/yyyy"/>
                            </c:if>
                        </strong>
                    </div>
                    <div class="detail-item">
                        <span>Hướng dẫn viên</span>
                        <strong>${assignment.guideName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Liên hệ hướng dẫn viên</span>
                        <strong>${assignment.guidePhone} - ${assignment.guideEmail}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Người phân công</span>
                        <strong>${empty assignment.assignedByName ? 'Chưa lưu' : assignment.assignedByName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ngày phân công</span>
                        <strong><fmt:formatDate value="${assignment.assignedAt}" pattern="dd/MM/yyyy HH:mm"/></strong>
                    </div>
                    <div class="detail-item">
                        <span>Điểm hẹn</span>
                        <strong>${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Giờ đón / hạn check-in</span>
                        <strong>
                            <c:choose>
                                <c:when test="${empty assignment.pickupTime && empty assignment.checkInDeadline}">
                                    Chưa nhập
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="${assignment.pickupTime}" pattern="dd/MM/yyyy HH:mm"/>
                                    <c:if test="${not empty assignment.checkInDeadline}">
                                        / <fmt:formatDate value="${assignment.checkInDeadline}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                    <div class="detail-item">
                        <span>Khách hàng</span>
                        <strong>${empty assignment.customerName ? 'Chưa có booking' : assignment.customerName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Liên hệ khách</span>
                        <strong>${assignment.customerPhone} - ${assignment.customerEmail}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Số khách</span>
                        <strong>${assignment.totalGuests} khách (${assignment.numberAdult} người lớn, ${assignment.numberChildren} trẻ em)</strong>
                    </div>
                    <div class="detail-item">
                        <span>Sức chứa lịch tour</span>
                        <strong>${assignment.bookedQuantity}/${assignment.maxParticipants} đã đặt, còn ${assignment.remainingSeats} chỗ</strong>
                    </div>
                    <div class="detail-item">
                        <span>Tổng tiền booking</span>
                        <strong><fmt:formatNumber value="${assignment.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ngày đặt</span>
                        <strong><fmt:formatDate value="${assignment.bookDate}" pattern="dd/MM/yyyy HH:mm"/></strong>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
