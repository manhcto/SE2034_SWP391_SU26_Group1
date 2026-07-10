<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Chi tiết tour được phân công</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>

<body>
<div class="workspace-layout">
    <aside class="workspace-sidebar">
        <div class="brand-box">
            <div class="brand-logo guide">TG</div>
            <h2>WonderVN</h2>
            <p>Tour Guide Workspace</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/home">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ hướng dẫn viên</span>
        </a>

        <div class="nav-section-title">Nhiệm vụ tour</div>

        <a class="sidebar-link active guide" href="${pageContext.request.contextPath}/guide/assignment">
            <i class="fa-solid fa-clipboard-list"></i>
            <span>Tour được phân công</span>
        </a>

        <div class="nav-section-title">Tài khoản</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Chi tiết tour được phân công</h1>
                <p>Thông tin nhiệm vụ tour đang gán cho bạn.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/assignment">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>

                <a class="top-action-btn btn-guide-action"
                   href="${pageContext.request.contextPath}/guide/assignment?action=editStatus&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-user-check"></i>
                    Cập nhật trạng thái
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'status'}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check me-2"></i>
                Cập nhật trạng thái assignment thành công.
            </div>
        </c:if>

        <c:if test="${param.error == 'invalidStatus'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Trạng thái không hợp lệ.
            </div>
        </c:if>

        <c:if test="${param.error == 'notAllowed'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Bạn không có quyền cập nhật assignment này.
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
                    <p>${assignment.tourName}</p>
                </div>
            </div>

            <div class="panel-body">
                <div class="detail-grid">
                    <div class="detail-item">
                        <span>Trạng thái</span>
                        <strong>${empty assignment.assignmentStatus ? 'Pending' : assignment.assignmentStatus}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Độ ưu tiên</span>
                        <strong>${empty assignment.priorityLevel ? 'Normal' : assignment.priorityLevel}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Tour</span>
                        <strong>${assignment.tourName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Tuyến</span>
                        <strong>${assignment.startPlace} → ${assignment.endPlace}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Lịch tour</span>
                        <strong>${assignment.departureDate} đến ${assignment.endDate}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Vai trò</span>
                        <strong>${assignment.roleInTour}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Điểm hẹn</span>
                        <strong>${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Giờ đón / deadline</span>
                        <strong>${assignment.pickupTime} / ${assignment.checkInDeadline}</strong>
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
                        <span>Khách</span>
                        <strong>${empty assignment.customerName ? 'Chưa có booking' : assignment.customerName}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Liên hệ khách</span>
                        <strong>${assignment.customerPhone} - ${assignment.customerEmail}</strong>
                    </div>
                    <div class="detail-item">
                        <span>Số khách</span>
                        <strong>${assignment.totalGuests} khách</strong>
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
                    <div class="detail-item">
                        <span>Bắt đầu / kết thúc thực tế</span>
                        <strong>${assignment.actualStartAt} / ${assignment.actualEndAt}</strong>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
