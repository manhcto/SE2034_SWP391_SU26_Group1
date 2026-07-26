<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Cập nhật trạng thái hành khách</title>
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
                <h1>Cập nhật trạng thái hành khách</h1>
                <p>Người đặt booking được giữ cố định; các hành khách còn lại có thể cập nhật tên, liên hệ và trạng thái.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}">
                    <i class="fa-solid fa-arrow-left"></i>Quay lại tour
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'passenger'}"><div class="alert alert-success">Đã cập nhật trạng thái khách.</div></c:if>
        <c:if test="${param.error == 'invalidStatus'}"><div class="alert alert-danger">Trạng thái khách không hợp lệ.</div></c:if>
        <c:if test="${param.error == 'notAllowed'}"><div class="alert alert-danger">Bạn không có quyền cập nhật khách này.</div></c:if>

        <section class="panel mb-4">
            <div class="panel-header">
                <div>
                    <h2>${assignment.tourName}</h2>
                    <p><fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy"/> · ${assignment.meetingPoint}</p>
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
                            <th>Liên hệ</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th>Lưu</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="t" items="${travelerList}">
                            <tr>
                                <td>
                                    <form id="passengerForm${t.travelerID}" method="post" action="${pageContext.request.contextPath}/guide/assignment">
                                        <input type="hidden" name="action" value="updatePassengerStatus">
                                        <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                                        <input type="hidden" name="travelerID" value="${t.travelerID}">
                                    </form>
                                    ${t.bookingCode}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.booker}">
                                            <strong>${t.fullName}</strong>
                                            <div class="text-muted small">Người đặt booking</div>
                                        </c:when>
                                        <c:otherwise>
                                            <input class="form-control" name="fullName" value="${t.fullName}"
                                                   placeholder="Họ tên hành khách" form="passengerForm${t.travelerID}" required>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${t.travelerType}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.booker}">
                                            ${empty t.phone ? 'Không có' : t.phone}
                                        </c:when>
                                        <c:otherwise>
                                            <input class="form-control" name="phone" value="${t.phone}"
                                                   placeholder="Số điện thoại nếu có" form="passengerForm${t.travelerID}">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <select class="form-select" name="travelerStatus" form="passengerForm${t.travelerID}">
                                        <option value="Pending" ${t.travelerStatus == 'Pending' ? 'selected' : ''}>Chưa check-in</option>
                                        <option value="Checked-in" ${t.travelerStatus == 'Checked-in' ? 'selected' : ''}>Đã check-in</option>
                                        <option value="Absent" ${t.travelerStatus == 'Absent' ? 'selected' : ''}>Vắng mặt</option>
                                        <option value="Completed" ${t.travelerStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                    </select>
                                </td>
                                <td><input class="form-control" name="note" value="${t.note}" placeholder="Ghi chú" form="passengerForm${t.travelerID}"></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-success" type="submit" form="passengerForm${t.travelerID}">
                                        <i class="fa-solid fa-floppy-disk"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty travelerList}">
                            <tr><td colspan="7" class="text-center text-muted py-5">Chưa có danh sách hành khách để cập nhật.</td></tr>
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
