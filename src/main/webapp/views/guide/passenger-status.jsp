<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật trạng thái hành khách</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>

<body style="background:#f5f6fa">

<div class="container mt-4">

    <h2>Cập nhật trạng thái hành khách</h2>

    <div class="card mt-3">
        <div class="card-body">

            <form method="post"
                  action="${pageContext.request.contextPath}/guide/assignment">

                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                <input type="hidden" name="bookingID" value="${assignment.bookingID}">

                <div class="mb-3">
                    <label class="form-label">Mã đặt tour</label>
                    <input type="text" class="form-control"
                           value="${assignment.bookingID}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Tên tour</label>
                    <input type="text" class="form-control"
                           value="${assignment.tourName}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Trạng thái hành khách</label>

                    <select name="status" class="form-select" required>
                        <option value="Pending">Chờ xử lý</option>
                        <option value="Checked In">Đã điểm danh</option>
                        <option value="In Progress">Đang tham gia tour</option>
                        <option value="Completed">Hoàn thành</option>
                        <option value="Cancelled">Đã hủy</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">
                    Cập nhật
                </button>

                <a href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}"
                   class="btn btn-secondary">
                    Hủy
                </a>

            </form>

        </div>
    </div>

</div>

</body>
</html>