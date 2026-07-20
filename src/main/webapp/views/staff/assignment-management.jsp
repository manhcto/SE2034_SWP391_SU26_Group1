<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Điều phối hướng dẫn viên</title>

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
                <h1>Điều phối hướng dẫn viên</h1>
                <p>Quản lý phân công tour cho hướng dẫn viên.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/home">
                    <i class="fa-solid fa-house"></i>
                    Trang nhân viên
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

        <c:if test="${param.error == 'deleteFailed'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Không xóa được phân công. Vui lòng tải lại trang và thử lại.
            </div>
        </c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Danh sách phân công</h2>
                    <p>Theo dõi tour, hướng dẫn viên, lịch đón và trạng thái phân công.</p>
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
                                </td>
                                <td>
                                    ${a.guideName}
                                    <div class="text-muted small">${a.guidePhone}</div>
                                </td>
                                <td>
                                    ${empty a.meetingPoint ? 'Chưa nhập' : a.meetingPoint}
                                    <c:if test="${not empty a.pickupTime}">
                                        <div class="text-muted small">
                                            <fmt:formatDate value="${a.pickupTime}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </c:if>
                                </td>
                                <td>${a.priorityLevelLabel}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.assignmentStatus == 'Pending'}">
                                            <span class="status-pill status-pending">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Accepted'}">
                                            <span class="status-pill status-checked">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Confirmed'}">
                                            <span class="status-pill status-assigned">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'In Progress'}">
                                            <span class="status-pill status-progress">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Completed'}">
                                            <span class="status-pill status-completed">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Cancelled'}">
                                            <span class="status-pill status-cancelled">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:when test="${a.assignmentStatus == 'Rejected'}">
                                            <span class="status-pill status-cancelled">${a.assignmentStatusLabel}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pill status-assigned">${a.assignmentStatusLabel}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${a.assignedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
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
                                <td colspan="9" class="text-center text-muted py-5">
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
