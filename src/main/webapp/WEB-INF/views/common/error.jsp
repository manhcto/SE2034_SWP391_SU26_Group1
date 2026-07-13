<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi hệ thống</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/staff.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/staff-navbar.jsp" />
<main class="container">
    <h1>Lỗi hệ thống</h1>
    <p><c:out value="${systemError}" default="Không thể xử lý yêu cầu." /></p>
    <a class="btn" href="<%= ctx %>/staff/tour/list">Quay về quản lý tour</a>
</main>
<script src="<%= ctx %>/assets/js/staff.js"></script>
</body>
</html>
