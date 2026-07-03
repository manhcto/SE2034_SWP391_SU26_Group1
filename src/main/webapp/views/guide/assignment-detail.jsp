<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tour được phân công</title>

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
    </style>
</head>

<body>

<div class="container mt-4">

    <h2 class="page-title mb-4">
        Chi tiết tour được phân công
    </h2>

    <div class="card card-custom">
        <div class="card-body">

            <table class="table table-bordered">

                <tr>
                    <th>Mã phân công</th>
                    <td>${assignment.assignmentID}</td>
                </tr>

                <tr>
                    <th>Mã đặt tour</th>
                    <td>${assignment.bookingID}</td>
                </tr>

                <tr>
                    <th>Tên tour</th>
                    <td>${assignment.tourName}</td>
                </tr>

                <tr>
                    <th>Hướng dẫn viên</th>
                    <td>${assignment.guideName}</td>
                </tr>

                <tr>
                    <th>Ngày khởi hành</th>
                    <td>${assignment.departureDate}</td>
                </tr>

                <tr>
                    <th>Trạng thái</th>
                    <td>${assignment.status}</td>
                </tr>

            </table>

            <a href="${pageContext.request.contextPath}/guide/assignment"
               class="btn btn-secondary">
                Quay lại
            </a>
            <a href="${pageContext.request.contextPath}/guide/assignment?action=editStatus&id=${assignment.assignmentID}"
               class="btn btn-warning">
                Cập nhật trạng thái hành khách
            </a>

        </div>
    </div>

</div>

</body>
</html>
