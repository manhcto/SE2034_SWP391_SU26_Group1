<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Chi tiết phân công tour</h1>
                <p>Xem đầy đủ thông tin đã lưu trong assignment.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>
                <a class="top-action-btn btn-primary-action"
                   href="${pageContext.request.contextPath}/staff/assignment?action=edit&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-pen-to-square"></i>
                    Sửa phân công
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
                        <span>Trạng thái assignment</span>
                        <strong>${empty assignment.assignmentStatus ? 'Pending' : assignment.assignmentStatus}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Độ ưu tiên</span>
                        <strong>${empty assignment.priorityLevel ? 'Normal' : assignment.priorityLevel}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Vai trò trong tour</span>
                        <strong>${assignment.roleInTour}</strong>
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
                        <strong>${assignment.departureDate} đến ${assignment.endDate}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Hướng dẫn viên</span>
                        <strong>${assignment.guideName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Liên hệ guide</span>
                        <strong>${assignment.guidePhone} - ${assignment.guideEmail}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Người phân công</span>
                        <strong>${empty assignment.assignedByName ? 'Chưa lưu' : assignment.assignedByName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ngày phân công</span>
                        <strong>${assignment.assignedAt}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Điểm hẹn</span>
                        <strong>${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Giờ đón / deadline check-in</span>
                        <strong>${assignment.pickupTime} / ${assignment.checkInDeadline}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Bắt đầu / kết thúc thực tế</span>
                        <strong>${assignment.actualStartAt} / ${assignment.actualEndAt}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Mốc trạng thái</span>
                        <strong>Accepted: ${assignment.acceptedAt} | Confirmed: ${assignment.confirmedAt} | Completed: ${assignment.completedAt}</strong>
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
                        <strong>${assignment.totalPrice}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ngày đặt</span>
                        <strong>${assignment.bookDate}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ghi chú booking</span>
                        <strong>${empty assignment.note ? 'Không có ghi chú' : assignment.note}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Lý do từ chối/hủy</span>
                        <strong>${empty assignment.rejectionReason ? 'Không có' : assignment.rejectionReason}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ghi chú staff</span>
                        <strong>${empty assignment.staffNote ? 'Không có' : assignment.staffNote}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ghi chú guide</span>
                        <strong>${empty assignment.guideNote ? 'Không có' : assignment.guideNote}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Ghi chú khách</span>
                        <strong>${empty assignment.customerNote ? 'Không có' : assignment.customerNote}</strong>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
