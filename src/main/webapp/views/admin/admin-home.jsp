<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Admin Home</title>
</head>
<body>
<h1>Admin Home</h1>

<ul>
    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
    <li><a href="${pageContext.request.contextPath}/manage-user">Quản lý người dùng</a></li>
    <li><a href="${pageContext.request.contextPath}/admin/tour-approval">Phê duyệt tour</a></li>
</ul>
</body>
</html>