<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | ViewAssignedTour</title>
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
        <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/home"><i class="fa-solid fa-house"></i><span>Guide home</span></a>
        <div class="nav-section-title">Nhiệm vụ tour</div>
        <a class="sidebar-link active guide" href="${pageContext.request.contextPath}/guide/assignment"><i class="fa-solid fa-clipboard-list"></i><span>Assigned tours</span></a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span></a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>ViewAssignedTour</h1>
                <p>Chi tiết tour được phân công gồm itinerary, customer list, pickup time và special requests.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/assignment">
                    <i class="fa-solid fa-arrow-left"></i>Quay lại
                </a>
                <a class="top-action-btn btn-guide-action" href="${pageContext.request.contextPath}/guide/assignment?action=passengers&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-user-check"></i>EditPassengerStatus
                </a>
                <a class="top-action-btn btn-guide-action" href="${pageContext.request.contextPath}/guide/assignment?action=progressLog&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-route"></i>AddTourProgressLog
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'status'}"><div class="alert alert-success">Cập nhật trạng thái assignment thành công.</div></c:if>
        <c:if test="${param.success == 'progressLog'}"><div class="alert alert-success">Đã thêm progress log.</div></c:if>
        <c:if test="${param.error == 'notAllowed'}"><div class="alert alert-danger">Bạn không có quyền cập nhật assignment này.</div></c:if>
        <c:if test="${param.error == 'progressLog'}"><div class="alert alert-danger">Không thêm được progress log.</div></c:if>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>${empty assignment.assignmentCode ? assignment.assignmentID : assignment.assignmentCode}</h2>
                    <p>${assignment.tourName}</p>
                </div>
                <span class="status-pill status-assigned">${assignment.assignmentStatus}</span>
            </div>
            <div class="panel-body">
                <div class="detail-grid mb-4">
                    <div class="detail-item"><span>Tour</span><strong>${assignment.tourName}</strong></div>
                    <div class="detail-item"><span>Tuyến</span><strong>${assignment.startPlace} → ${assignment.endPlace}</strong></div>
                    <div class="detail-item"><span>Thời gian</span><strong><fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy HH:mm"/> - <fmt:formatDate value="${assignment.endDate}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                    <div class="detail-item"><span>Vai trò</span><strong>${assignment.roleInTour}</strong></div>
                    <div class="detail-item"><span>Điểm đón</span><strong>${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</strong></div>
                    <div class="detail-item"><span>Giờ đón/deadline</span><strong><fmt:formatDate value="${assignment.pickupTime}" pattern="dd/MM/yyyy HH:mm"/> / <fmt:formatDate value="${assignment.checkInDeadline}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                    <div class="detail-item"><span>Số khách</span><strong>${assignment.totalGuests} khách từ ${assignment.bookingCount} booking</strong></div>
                    <div class="detail-item"><span>Yêu cầu đặc biệt</span><strong>${empty assignment.customerNote ? 'Không có' : assignment.customerNote}</strong></div>
                    <div class="detail-item"><span>Ghi chú staff</span><strong>${empty assignment.staffNote ? 'Không có' : assignment.staffNote}</strong></div>
                    <div class="detail-item"><span>Ghi chú guide</span><strong>${empty assignment.guideNote ? 'Không có' : assignment.guideNote}</strong></div>
                </div>

                <form class="row g-3" method="post" action="${pageContext.request.contextPath}/guide/assignment">
                    <input type="hidden" name="action" value="updateAssignmentStatus">
                    <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                    <div class="col-md-4">
                        <label class="form-label">Trạng thái assignment</label>
                        <select name="assignmentStatus" class="form-select">
                            <option value="Assigned" ${assignment.assignmentStatus == 'Assigned' ? 'selected' : ''}>Assigned</option>
                            <option value="Pending" ${assignment.assignmentStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Accepted" ${assignment.assignmentStatus == 'Accepted' ? 'selected' : ''}>Accepted</option>
                            <option value="Confirmed" ${assignment.assignmentStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="In Progress" ${assignment.assignmentStatus == 'In Progress' ? 'selected' : ''}>In Progress</option>
                            <option value="Completed" ${assignment.assignmentStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${assignment.assignmentStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                            <option value="Rejected" ${assignment.assignmentStatus == 'Rejected' ? 'selected' : ''}>Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ghi chú guide</label>
                        <input class="form-control" name="guideNote" value="${assignment.guideNote}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button class="top-action-btn btn-guide-action w-100" type="submit">Lưu</button>
                    </div>
                </form>
            </div>
        </section>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>Customer list</h2>
                    <p>Danh sách khách trong tour.</p>
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
                            <th>Điện thoại</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="t" items="${travelerList}">
                            <tr>
                                <td>${t.bookingCode}</td>
                                <td><strong>${t.fullName}</strong></td>
                                <td>${t.travelerType}</td>
                                <td>${empty t.phone ? 'Không có' : t.phone}</td>
                                <td><span class="status-pill status-checked">${t.travelerStatus}</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty travelerList}">
                            <tr><td colspan="5" class="text-center text-muted py-5">Chưa có danh sách khách.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Itinerary progress</h2>
                    <p>Các cập nhật gần nhất của tour.</p>
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
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="log" items="${progressLogs}">
                            <tr>
                                <td><fmt:formatDate value="${log.logTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><span class="status-pill status-progress">${log.progressStatus}</span></td>
                                <td>${empty log.title ? 'Cập nhật tour' : log.title}</td>
                                <td>${empty log.content ? 'Không có nội dung' : log.content}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty progressLogs}">
                            <tr><td colspan="4" class="text-center text-muted py-5">Chưa có progress log.</td></tr>
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
