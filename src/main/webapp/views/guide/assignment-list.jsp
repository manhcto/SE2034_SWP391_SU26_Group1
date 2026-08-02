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
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css?v=guide-sidebar-bottom-20260723" rel="stylesheet">
</head>

<body>
<div class="workspace-layout">
    <jsp:include page="/views/common/guide-sidebar.jsp">
        <jsp:param name="activeGuideMenu" value="assignment"/>
    </jsp:include>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Tour được phân công</h1>
                <p>Theo dõi nhiệm vụ tour và trạng thái phân công của bạn.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/home">
                    <i class="fa-solid fa-house"></i>
                    Trang hướng dẫn viên
                </a>
            </div>
        </div>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Danh sách nhiệm vụ</h2>
                    <p>Các tour đang được gán cho tài khoản hướng dẫn viên hiện tại.</p>
                </div>
            </div>

            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Tour</th>
                            <th>Lịch tour</th>
                            <th>Tuyến</th>
                            <th>Điểm hẹn</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="a" items="${assignmentList}">
                            <c:set var="currentAssignmentStatus" value="${empty a.assignmentStatus ? 'Pending' : a.assignmentStatus}"/>
                            <c:set var="showConfirmButton" value="${currentAssignmentStatus == 'Pending' || currentAssignmentStatus == 'Assigned'}"/>
                            <c:choose>
                                <c:when test="${currentAssignmentStatus == 'Pending' || currentAssignmentStatus == 'Assigned'}">
                                    <c:set var="assignmentStatusClass" value="status-pending"/>
                                </c:when>
                                <c:when test="${currentAssignmentStatus == 'Accepted' || currentAssignmentStatus == 'Confirmed'}">
                                    <c:set var="assignmentStatusClass" value="status-checked"/>
                                </c:when>
                                <c:when test="${currentAssignmentStatus == 'In Progress'}">
                                    <c:set var="assignmentStatusClass" value="status-progress"/>
                                </c:when>
                                <c:when test="${currentAssignmentStatus == 'Completed'}">
                                    <c:set var="assignmentStatusClass" value="status-completed"/>
                                </c:when>
                                <c:when test="${currentAssignmentStatus == 'Cancelled' || currentAssignmentStatus == 'Rejected'}">
                                    <c:set var="assignmentStatusClass" value="status-cancelled"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="assignmentStatusClass" value="status-assigned"/>
                                </c:otherwise>
                            </c:choose>
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
                                    ${a.tourName}
                                </td>
                                <td>
                                    <fmt:formatDate value="${a.departureDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>${a.startPlace} → ${a.endPlace}</td>
                                <td>
                                    ${empty a.meetingPoint ? 'Chưa nhập' : a.meetingPoint}
                                    <c:if test="${not empty a.pickupTime}">
                                        <div class="text-muted small">
                                            <fmt:formatDate value="${a.pickupTime}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </c:if>
                                </td>
                                <td><span class="status-pill ${assignmentStatusClass}">${a.assignmentStatusLabel}</span></td>
                                <td>
                                    <div class="row-actions">
                                        <a class="btn btn-sm btn-outline-primary"
                                           href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${a.assignmentID}">
                                            <i class="fa-solid fa-eye me-1"></i>
                                            Chi tiết
                                        </a>
                                        <c:if test="${showConfirmButton}">
                                            <form method="post" action="${pageContext.request.contextPath}/guide/assignment" class="m-0">
                                                <input type="hidden" name="action" value="confirmAssignment">
                                                <input type="hidden" name="assignmentID" value="${a.assignmentID}">
                                                <button class="btn btn-sm btn-outline-success" type="submit">
                                                    <i class="fa-solid fa-circle-check me-1"></i>
                                                    Xác nhận
                                                </button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/guide/assignment" class="m-0"
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn từ chối tour này không?');">
                                                <input type="hidden" name="action" value="rejectAssignment">
                                                <input type="hidden" name="assignmentID" value="${a.assignmentID}">
                                                <button class="btn btn-sm btn-outline-danger" type="submit">
                                                    <i class="fa-solid fa-circle-xmark me-1"></i>
                                                    Từ chối
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty assignmentList}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-5">
                                    Chưa có tour nào được phân công cho bạn.
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
