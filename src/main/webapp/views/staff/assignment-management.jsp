<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Điều phối hướng dẫn viên</title>

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
            <p>Travel ERP System</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ nhân viên</span>
        </a>

        <div class="nav-section-title">Dịch vụ du lịch</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
            <i class="fa-solid fa-map-location-dot"></i>
            <span>Quản lý Tour</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
            <i class="fa-solid fa-hotel"></i>
            <span>Quản lý lưu trú</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/vehicle?action=list">
            <i class="fa-solid fa-car-side"></i>
            <span>Quản lý phương tiện</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/service">
            <i class="fa-solid fa-briefcase"></i>
            <span>Quản lý dịch vụ</span>
        </a>

        <div class="nav-section-title">Vận hành</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
            <i class="fa-solid fa-calendar-check"></i>
            <span>Quản lý đặt chỗ</span>
        </a>

        <a class="sidebar-link active staff" href="${pageContext.request.contextPath}/staff/assignment">
            <i class="fa-solid fa-user-tie"></i>
            <span>Điều phối hướng dẫn viên</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/payment">
            <i class="fa-solid fa-credit-card"></i>
            <span>Quản lý thanh toán</span>
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
                <h1>Điều phối hướng dẫn viên</h1>
                <p>Quản lý phân công tour dựa trên bảng Tour_Assignments.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/home">
                    <i class="fa-solid fa-house"></i>
                    Trang staff
                </a>
                <a class="top-action-btn btn-primary-action" href="${pageContext.request.contextPath}/staff/assignment?action=create">
                    <i class="fa-solid fa-plus"></i>
                    Thêm phân công
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'insert'}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check me-2"></i>
                Thêm phân công thành công.
            </div>
        </c:if>

        <c:if test="${param.success == 'delete'}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check me-2"></i>
                Xóa phân công thành công.
            </div>
        </c:if>

        <c:if test="${param.success == 'update'}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check me-2"></i>
                Cập nhật phân công thành công.
            </div>
        </c:if>

        <c:if test="${param.error == 'notFound'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Không tìm thấy phân công cần xử lý.
            </div>
        </c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Danh sách phân công</h2>
                    <p>Theo dõi tour, guide, lịch đón và trạng thái assignment.</p>
                </div>
            </div>

            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Booking</th>
                            <th>Tour</th>
                            <th>Hướng dẫn viên</th>
                            <th>Vai trò</th>
                            <th>Điểm hẹn</th>
                            <th>Ưu tiên</th>
                            <th>Trạng thái</th>
                            <th>Ngày phân công</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach items="${assignmentList}" var="a">
                            <tr>
                                <td>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty a.assignmentCode}">${a.assignmentCode}</c:when>
                                            <c:otherwise>#${a.assignmentID}</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty a.bookingCode}">
                                            ${a.bookingCode}
                                            <div class="text-muted small">ID: ${a.bookingID}</div>
                                        </c:when>
                                        <c:when test="${a.bookingID > 0}">#${a.bookingID}</c:when>
                                        <c:otherwise>Chưa gắn booking</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    ${a.tourName}
                                    <div class="text-muted small">${a.startPlace} → ${a.endPlace}</div>
                                </td>
                                <td>
                                    ${a.guideName}
                                    <div class="text-muted small">${a.guidePhone}</div>
                                </td>
                                <td>${empty a.roleInTour ? 'Hướng dẫn viên' : a.roleInTour}</td>
                                <td>
                                    ${empty a.meetingPoint ? 'Chưa nhập' : a.meetingPoint}
                                    <div class="text-muted small">${empty a.pickupTime ? '' : a.pickupTime}</div>
                                </td>
                                <td>${empty a.priorityLevel ? 'Normal' : a.priorityLevel}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.assignmentStatus == 'Pending'}">
                                            <span class="status-pill status-pending">Pending</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Accepted'}">
                                            <span class="status-pill status-checked">Accepted</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Confirmed'}">
                                            <span class="status-pill status-assigned">Confirmed</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'In Progress'}">
                                            <span class="status-pill status-progress">In Progress</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Completed'}">
                                            <span class="status-pill status-completed">Completed</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Cancelled'}">
                                            <span class="status-pill status-cancelled">Cancelled</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Rejected'}">
                                            <span class="status-pill status-cancelled">Rejected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pill status-assigned">Assigned</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${a.assignedAt}</td>
                                <td>
                                    <div class="row-actions">
                                        <a class="btn btn-sm btn-outline-primary"
                                           href="${pageContext.request.contextPath}/staff/assignment?action=view&id=${a.assignmentID}">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>

                                        <a class="btn btn-sm btn-outline-warning"
                                           href="${pageContext.request.contextPath}/staff/assignment?action=edit&id=${a.assignmentID}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/staff/assignment"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa phân công này không?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${a.assignmentID}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty assignmentList}">
                            <tr>
                                <td colspan="10" class="text-center text-muted py-5">
                                    Chưa có dữ liệu phân công tour.
                                </td>
                            </tr>
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
