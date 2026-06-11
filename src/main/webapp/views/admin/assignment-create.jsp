<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm phân công tour</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f5f6fa;
        }

        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .page-title {
            font-size: 28px;
            font-weight: bold;
        }

        .btn-luu {
            background-color: #198754;
            color: white;
        }

        .btn-luu:hover {
            background-color: #157347;
            color: white;
        }
    </style>
</head>

<body>

<div class="container mt-4">

    <h2 class="page-title mb-4">
        Thêm phân công tour
    </h2>

    <div class="card card-custom">
        <div class="card-body">

            <c:if test="${param.error == 'notFoundSchedule'}">
                <div class="alert alert-danger">
                    Không tìm thấy lịch trình tour cho booking này.
                </div>
            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/staff/assignment">

                <input type="hidden" name="action" value="insert">

                <div class="mb-3">
                    <label class="form-label">
                        Mã đặt tour
                    </label>

                    <select name="bookingID"
                            class="form-select"
                            required>
                        <option value="">
                            -- Chọn mã đặt tour --
                        </option>

                        <c:forEach var="b" items="${bookingList}">
                            <option value="${b.bookingID}">
                                Booking #${b.bookingID} - ${b.tourName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Hướng dẫn viên
                    </label>

                    <select name="userID"
                            class="form-select"
                            required>
                        <option value="">
                            -- Chọn hướng dẫn viên --
                        </option>

                        <c:forEach var="g" items="${guideList}">
                            <option value="${g.userID}">
                                    ${g.firstName} ${g.lastName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Phương tiện
                    </label>

                    <select class="form-select" disabled>
                        <option>
                            Phương tiện được lấy theo tour trong hệ thống
                        </option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Trạng thái
                    </label>

                    <select class="form-select" disabled>
                        <option>
                            Đã phân công
                        </option>
                    </select>
                </div>

                <button type="submit"
                        class="btn btn-luu">
                    Lưu phân công
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