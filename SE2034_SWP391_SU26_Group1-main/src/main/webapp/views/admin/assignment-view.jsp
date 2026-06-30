<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Chi tiết phân công tour</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <style>

        body{
            background:#f5f6fa;
        }

        .card-custom{
            border:none;
            border-radius:12px;
            box-shadow:0 2px 10px rgba(0,0,0,.08);
        }

    </style>

</head>

<body>

<div class="container mt-4">

    <div class="card card-custom">

        <div class="card-header">

            <h3>
                Chi tiết phân công tour
            </h3>

        </div>

        <div class="card-body">

            <table class="table">

                <tr>
                    <th>Mã phân công</th>
                    <td>${assignment.assignmentID}</td>
                </tr>

                <tr>
                    <th>Mã đặt tour</th>
                    <td>${assignment.bookingID}</td>
                </tr>

                <tr>
                    <th>Tour</th>
                    <td>${assignment.tourName}</td>
                </tr>

                <tr>
                    <th>Hướng dẫn viên</th>
                    <td>${assignment.guideName}</td>
                </tr>

                <tr>
                    <th>Phương tiện</th>
                    <td>${assignment.vehicleName}</td>
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

            <a
                    href="${pageContext.request.contextPath}/staff/assignment"
                    class="btn btn-secondary">

                Quay lại

            </a>

        </div>

    </div>

</div>

</body>
</html>