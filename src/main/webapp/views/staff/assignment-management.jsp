<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý phân công tour</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body{
            background-color:#f5f6fa;
        }

        .card-custom{
            border:none;
            border-radius:12px;
            box-shadow:0 2px 10px rgba(0,0,0,0.08);
        }

        .table th{
            background:#f8f9fa;
        }

        .page-title{
            font-size:28px;
            font-weight:bold;
        }

        .btn-them{
            background:#198754;
            color:white;
        }

        .btn-them:hover{
            background:#157347;
            color:white;
        }

    </style>

</head>
<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h2 class="page-title">
            Quản lý phân công tour
        </h2>

        <a href="${pageContext.request.contextPath}/staff/assignment?action=create"
           class="btn btn-them">

            + Thêm phân công

        </a>

    </div>

    <div class="card card-custom">

        <div class="card-body">

            <table class="table table-bordered table-hover align-middle">

                <thead>

                <tr>

                    <th>Mã phân công</th>

                    <th>Mã đặt tour</th>

                    <th>Tour</th>

                    <th>Hướng dẫn viên</th>

                    <th>Phương tiện</th>

                    <th>Ngày khởi hành</th>

                    <th>Trạng thái</th>

                    <th>Thao tác</th>

                </tr>

                </thead>

                <tbody>

                <c:forEach items="${assignmentList}" var="a">

                    <tr>

                        <td>${a.assignmentID}</td>

                        <td>${a.bookingID}</td>

                        <td>${a.tourName}</td>

                        <td>${a.guideName}</td>

                        <td>${a.vehicleName}</td>

                        <td>${a.departureDate}</td>

                        <td>

                            <span class="badge bg-success">
                                Đã phân công
                            </span>

                        </td>

                        <td>

                            <a href="${pageContext.request.contextPath}/staff/assignment?action=view&id=${a.assignmentID}"
                               class="btn btn-info btn-sm">

                                Xem

                            </a>

                            <a href="${pageContext.request.contextPath}/staff/assignment?action=edit&id=${a.assignmentID}"
                               class="btn btn-warning btn-sm">

                                Sửa

                            </a>

                            <a href="${pageContext.request.contextPath}/staff/assignment?action=delete&id=${a.assignmentID}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa phân công này không? Hành động này không thể hoàn tác.');">
                                Xóa
                            </a>

                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty assignmentList}">

                    <tr>

                        <td colspan="8"
                            class="text-center text-muted">

                            Chưa có dữ liệu phân công tour

                        </td>

                    </tr>

                </c:if>
                <c:if test="${param.success == 'delete'}">
                    <div class="alert alert-success">
                        Xóa phân công thành công.
                    </div>
                </c:if>
                <c:if test="${param.success == 'update'}">
                    <div class="alert alert-success">
                        Cập nhật phân công thành công.
                    </div>
                </c:if>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>