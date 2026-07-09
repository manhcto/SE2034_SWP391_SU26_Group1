<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | ListTourAssignment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>
<body>
<div class="workspace-layout">
    <aside class="workspace-sidebar">
        <div class="brand-box">
            <div class="brand-logo staff">WV</div>
            <h2>WonderVN</h2>
            <p>Staff Workspace</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
            <i class="fa-solid fa-house"></i><span>Trang staff</span>
        </a>
        <div class="nav-section-title">Vận hành</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
            <i class="fa-solid fa-calendar-check"></i><span>Booking</span>
        </a>
        <a class="sidebar-link active staff" href="${pageContext.request.contextPath}/staff/assignment">
            <i class="fa-solid fa-user-tie"></i><span>Tour assignment</span>
        </a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
            <i class="fa-solid fa-map-location-dot"></i><span>Tour</span>
        </a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span>
        </a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>ListTourAssignment</h1>
                <p>Xem, tìm kiếm và lọc lịch tour cần phân công hướng dẫn viên.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/home">
                    <i class="fa-solid fa-house"></i>Staff home
                </a>
                <a class="top-action-btn btn-primary-action" href="${pageContext.request.contextPath}/staff/assignment?action=create">
                    <i class="fa-solid fa-plus"></i>AddTourAssignment
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'insert'}"><div class="alert alert-success">Thêm phân công thành công.</div></c:if>
        <c:if test="${param.success == 'update'}"><div class="alert alert-success">Cập nhật phân công thành công.</div></c:if>
        <c:if test="${param.success == 'delete'}"><div class="alert alert-success">Xóa phân công thành công.</div></c:if>
        <c:if test="${param.error == 'notFound'}"><div class="alert alert-danger">Không tìm thấy phân công.</div></c:if>
        <c:if test="${param.error == 'insert' || param.error == 'update' || param.error == 'delete'}">
            <div class="alert alert-danger">Không xử lý được yêu cầu. Vui lòng kiểm tra dữ liệu.</div>
        </c:if>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>Bộ lọc</h2>
                    <p>Tìm theo mã phân công, tên tour, guide hoặc booking.</p>
                </div>
            </div>
            <div class="panel-body">
                <form class="row g-3" method="get" action="${pageContext.request.contextPath}/staff/assignment">
                    <input type="hidden" name="action" value="list">
                    <div class="col-md-7">
                        <label class="form-label">Từ khóa</label>
                        <input class="form-control" name="keyword" value="${keyword}" placeholder="VD: Hạ Long, ASG-000001, guide@wonder.vn">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái assignment</label>
                        <select class="form-select" name="status">
                            <option value="">Tất cả</option>
                            <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Accepted" ${status == 'Accepted' ? 'selected' : ''}>Accepted</option>
                            <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="In Progress" ${status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                            <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button class="top-action-btn btn-primary-action w-100" type="submit">
                            <i class="fa-solid fa-magnifying-glass"></i>Lọc
                        </button>
                    </div>
                </form>
            </div>
        </section>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>Lịch tour cần phân công</h2>
                    <p>Các lịch tour đã sẵn sàng/đã xác nhận nhưng chưa có guide active.</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Lịch</th>
                            <th>Tour</th>
                            <th>Thời gian</th>
                            <th>Booking</th>
                            <th>Số khách</th>
                            <th>Sức chứa</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${scheduleList}" var="s">
                            <tr>
                                <td>#${s.tourScheduleID}<div class="text-muted small">${s.scheduleStatus}</div></td>
                                <td><strong>${s.tourName}</strong><div class="text-muted small">${s.startPlace} → ${s.endPlace}</div></td>
                                <td><fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy HH:mm"/> - <fmt:formatDate value="${s.endDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>${s.bookingCount} booking</td>
                                <td>${s.totalGuests} khách</td>
                                <td>${s.bookedQuantity}/${s.maxParticipants}</td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/staff/assignment?action=create&scheduleID=${s.tourScheduleID}">
                                        <i class="fa-solid fa-user-plus me-1"></i>Phân công
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty scheduleList}">
                            <tr><td colspan="7" class="text-center text-muted py-5">Không có lịch tour nào đang cần phân công.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Assignment đã tạo</h2>
                    <p>Theo dõi guide, lịch tour, trạng thái và thao tác sửa/xem.</p>
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Tour</th>
                            <th>Guide</th>
                            <th>Thời gian</th>
                            <th>Điểm đón</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${assignmentList}" var="a">
                            <tr>
                                <td><strong>${empty a.assignmentCode ? a.assignmentID : a.assignmentCode}</strong></td>
                                <td>${a.tourName}<div class="text-muted small">#${a.tourScheduleID} · ${a.startPlace} → ${a.endPlace}</div></td>
                                <td>${a.guideName}<div class="text-muted small">${a.guidePhone}</div></td>
                                <td><fmt:formatDate value="${a.departureDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>${empty a.meetingPoint ? 'Chưa nhập' : a.meetingPoint}</td>
                                <td><span class="status-pill status-assigned">${a.assignmentStatus}</span></td>
                                <td>
                                    <div class="row-actions">
                                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/staff/assignment?action=view&id=${a.assignmentID}">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>
                                        <a class="btn btn-sm btn-outline-warning" href="${pageContext.request.contextPath}/staff/assignment?action=edit&id=${a.assignmentID}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/staff/assignment" onsubmit="return confirm('Xóa assignment này?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${a.assignmentID}">
                                            <button class="btn btn-sm btn-outline-danger" type="submit"><i class="fa-solid fa-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty assignmentList}">
                            <tr><td colspan="7" class="text-center text-muted py-5">Chưa có assignment phù hợp bộ lọc.</td></tr>
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
