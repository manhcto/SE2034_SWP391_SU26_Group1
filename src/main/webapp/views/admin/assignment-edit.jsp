<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa phân công tour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body style="background:#f5f6fa">

<div class="container mt-4">
    <h2>Sửa phân công tour</h2>

    <div class="card mt-3">
        <div class="card-body">

            <form method="post" action="${pageContext.request.contextPath}/staff/assignment">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                <input type="hidden" name="tourScheduleID" value="${assignment.tourScheduleID}">

                <div class="mb-3">
                    <label class="form-label">Mã phân công</label>
                    <input type="text" class="form-control" value="${assignment.assignmentID}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mã lịch trình tour</label>
                    <input type="text" class="form-control" value="${assignment.tourScheduleID}" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tour</label>
                    <input type="text" class="form-control"
                           value="${assignmentDetail.tourName}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ngày khởi hành</label>
                    <input type="text" class="form-control"
                           value="${assignmentDetail.departureDate}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <input type="text" class="form-control"
                           value="${assignmentDetail.status}" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hướng dẫn viên</label>
                    <select name="userID" class="form-select" required>
                        <c:forEach var="g" items="${guideList}">
                            <option value="${g.userID}"
                                ${g.userID == assignment.userID ? "selected" : ""}>
                                    ${g.firstName} ${g.lastName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">
                    Cập nhật
                </button>

                <a href="${pageContext.request.contextPath}/staff/assignment"
                   class="btn btn-secondary">
                    Hủy
                </a>
            </form>

        </div>
    </div>
</div>

</body>
</html>
