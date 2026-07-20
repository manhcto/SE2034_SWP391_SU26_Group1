<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Cập nhật trạng thái phân công</title>

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
            <p>Khu vực hướng dẫn viên</p>
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
                <h1>Cập nhật trạng thái phân công</h1>
                <p>Trạng thái này được lưu trong thông tin phân công tour.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action"
                   href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}">
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
                    <p>${assignment.tourName}</p>
                </div>
            </div>

            <div class="panel-body">
                <form method="post" action="${pageContext.request.contextPath}/guide/assignment">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">

                    <div class="detail-grid mb-4">
                        <div class="detail-item">
                            <span>Tour</span>
                            <strong>${assignment.tourName}</strong>
                        </div>
                        <div class="detail-item">
                            <span>Lịch tour</span>
                            <strong>
                                <fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy"/>
                                <c:if test="${not empty assignment.endDate}">
                                    đến <fmt:formatDate value="${assignment.endDate}" pattern="dd/MM/yyyy"/>
                                </c:if>
                            </strong>
                        </div>
                        <div class="detail-item">
                            <span>Điểm hẹn</span>
                            <strong>${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</strong>
                        </div>
                        <div class="detail-item">
                            <span>Trạng thái hiện tại</span>
                            <strong>${assignment.assignmentStatusLabel}</strong>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Trạng thái phân công</label>
                            <select name="status" class="form-select" required>
                                <option value="Pending" ${assignment.assignmentStatus == 'Pending' ? 'selected' : ''}>Chờ nhận tour</option>
                                <option value="Accepted" ${assignment.assignmentStatus == 'Accepted' ? 'selected' : ''}>Đã nhận tour</option>
                                <option value="Confirmed" ${assignment.assignmentStatus == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="In Progress" ${assignment.assignmentStatus == 'In Progress' ? 'selected' : ''}>Đang diễn ra</option>
                                <option value="Completed" ${assignment.assignmentStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="Cancelled" ${assignment.assignmentStatus == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                <option value="Rejected" ${assignment.assignmentStatus == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Ghi chú hướng dẫn viên</label>
                            <textarea name="guideNote" class="form-control" rows="4">${assignment.guideNote}</textarea>
                        </div>
                    </div>

                    <div class="top-actions mt-4">
                        <button type="submit" class="top-action-btn btn-guide-action">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Lưu cập nhật
                        </button>

                        <a class="top-action-btn btn-light-action"
                           href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}">
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
