<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Tour được phân công</title>
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
        <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/home"><i class="fa-solid fa-house"></i><span>Trang chủ hướng dẫn viên</span></a>
        <div class="nav-section-title">Nhiệm vụ tour</div>
        <a class="sidebar-link active guide" href="${pageContext.request.contextPath}/guide/assignment"><i class="fa-solid fa-clipboard-list"></i><span>Tour được phân công</span></a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span></a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Tour được phân công</h1>
                <p>Xem các tour được phân công theo ngày hoặc trạng thái.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/home">
                    <i class="fa-solid fa-house"></i>Trang chủ hướng dẫn viên
                </a>
            </div>
        </div>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>Bộ lọc</h2>
                    <p>Lọc phân công theo trạng thái và khoảng ngày khởi hành.</p>
                </div>
            </div>
            <div class="panel-body">
                <form class="row g-3" method="get" action="${pageContext.request.contextPath}/guide/assignment">
                    <input type="hidden" name="action" value="list">
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status">
                            <option value="">Tất cả</option>
                            <option value="Assigned" ${status == 'Assigned' ? 'selected' : ''}>Đã phân công</option>
                            <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Chờ nhận tour</option>
                            <option value="Accepted" ${status == 'Accepted' ? 'selected' : ''}>Đã nhận tour</option>
                            <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="In Progress" ${status == 'In Progress' ? 'selected' : ''}>Đang diễn ra</option>
                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Từ ngày</label>
                        <input class="form-control" type="date" name="dateFrom" value="${dateFrom}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Đến ngày</label>
                        <input class="form-control" type="date" name="dateTo" value="${dateTo}">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button class="top-action-btn btn-guide-action w-100" type="submit">
                            <i class="fa-solid fa-filter"></i>Lọc tour
                        </button>
                    </div>
                </form>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Tour được phân công</h2>
                    <p>Danh sách phân công gắn với tài khoản hướng dẫn viên đang đăng nhập.</p>
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
                                <td><span class="status-pill status-assigned">${a.assignmentStatusLabel}</span></td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${a.assignmentID}">
                                        <i class="fa-solid fa-eye me-1"></i>Xem chi tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty assignmentList}">
                            <tr><td colspan="7" class="text-center text-muted py-5">Bạn chưa có tour nào theo bộ lọc này.</td></tr>
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
