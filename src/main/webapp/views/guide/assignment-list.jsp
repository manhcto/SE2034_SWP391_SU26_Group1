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
                            <th>Ưu tiên</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="a" items="${assignmentList}">
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
                                        <c:otherwise>
                                            <span class="status-pill status-cancelled">${a.assignmentStatusLabel}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary"
                                       href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${a.assignmentID}">
                                        <i class="fa-solid fa-eye me-1"></i>
                                        Chi tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty assignmentList}">
                            <tr>
                                <td colspan="8" class="text-center text-muted py-5">
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
