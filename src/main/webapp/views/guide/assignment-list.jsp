<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch tour của hướng dẫn viên</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f5f6fa;
        }

        .page-title {
            font-size: 28px;
            font-weight: bold;
        }

        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .table th {
            background-color: #f8f9fa;
        }

        .badge-status {
            background-color: #198754;
        }
    </style>
</head>

<body>

<div class="container mt-4">

    <h2 class="page-title mb-4">
        Lịch tour được phân công
    </h2>

    <div class="card card-custom">
        <div class="card-body">

            <table class="table table-bordered table-hover align-middle">

                <thead>
                <tr>
                    <th>Mã phân công</th>
                    <th>Mã đặt tour</th>
                    <th>Tour</th>
                    <th>Phương tiện</th>
                    <th>Ngày khởi hành</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="a" items="${assignmentList}">
                    <tr>
                        <td>${a.assignmentID}</td>
                        <td>${a.bookingID}</td>
                        <td>${a.tourName}</td>
                        <td>${a.vehicleName}</td>
                        <td>${a.departureDate}</td>
                        <td>
                            <span class="badge badge-status">
                                    ${a.status}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${a.assignmentID}"
                               class="btn btn-info btn-sm">
                                Xem chi tiết
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty assignmentList}">
                    <tr>
                        <td colspan="7" class="text-center text-muted">
                            Chưa có tour nào được phân công
                        </td>
                    </tr>
                </c:if>

                </tbody>

            </table>

        </div>
    </div>

</div>

</body>
</html>