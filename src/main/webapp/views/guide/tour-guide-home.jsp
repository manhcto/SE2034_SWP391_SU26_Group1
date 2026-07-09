<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Tour Guide Home</title>
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

        <a class="sidebar-link active guide" href="${pageContext.request.contextPath}/guide/home">
            <i class="fa-solid fa-house"></i><span>Guide home</span>
        </a>
        <div class="nav-section-title">Nhiệm vụ tour</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/assignment">
            <i class="fa-solid fa-clipboard-list"></i><span>Assigned tours</span>
        </a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span>
        </a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Tour Guide Home</h1>
                <p>Theo dõi nhanh tour được phân công, trạng thái tour và log itinerary gần đây.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-globe"></i>Trang khách hàng
                </a>
                <a class="top-action-btn btn-guide-action" href="${pageContext.request.contextPath}/guide/assignment">
                    <i class="fa-solid fa-clipboard-list"></i>ListAssignedTour
                </a>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <section class="panel">
                    <div class="panel-body">
                        <div class="detail-item">
                            <span>Pending</span>
                            <strong>${pendingCount}</strong>
                        </div>
                    </div>
                </section>
            </div>
            <div class="col-md-3">
                <section class="panel">
                    <div class="panel-body">
                        <div class="detail-item">
                            <span>Confirmed</span>
                            <strong>${confirmedCount}</strong>
                        </div>
                    </div>
                </section>
            </div>
            <div class="col-md-3">
                <section class="panel">
                    <div class="panel-body">
                        <div class="detail-item">
                            <span>In Progress</span>
                            <strong>${inProgressCount}</strong>
                        </div>
                    </div>
                </section>
            </div>
            <div class="col-md-3">
                <section class="panel">
                    <div class="panel-body">
                        <div class="detail-item">
                            <span>Completed</span>
                            <strong>${completedCount}</strong>
                        </div>
                    </div>
                </section>
            </div>
        </div>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>Tour sắp tới</h2>
                    <p>Các assignment đang gắn với guide đăng nhập.</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Tour</th>
                            <th>Thời gian</th>
                            <th>Điểm đón</th>
                            <th>Khách</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${assignmentList}">
                            <tr>
                                <td><strong>${empty a.assignmentCode ? a.assignmentID : a.assignmentCode}</strong></td>
                                <td>${a.tourName}<div class="text-muted small">${a.startPlace} → ${a.endPlace}</div></td>
                                <td><fmt:formatDate value="${a.departureDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>${empty a.meetingPoint ? 'Chưa nhập' : a.meetingPoint}</td>
                                <td>${a.totalGuests} khách</td>
                                <td><span class="status-pill status-assigned">${a.assignmentStatus}</span></td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${a.assignmentID}">
                                        <i class="fa-solid fa-eye me-1"></i>Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty assignmentList}">
                            <tr><td colspan="7" class="text-center text-muted py-5">Chưa có tour nào được phân công.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Progress log gần đây</h2>
                    <p>Các cập nhật itinerary mới nhất.</p>
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
                        <c:forEach var="log" items="${recentLogs}">
                            <tr>
                                <td><fmt:formatDate value="${log.logTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><span class="status-pill status-progress">${log.progressStatus}</span></td>
                                <td>${empty log.title ? 'Cập nhật tour' : log.title}</td>
                                <td>${empty log.content ? 'Không có nội dung' : log.content}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentLogs}">
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
