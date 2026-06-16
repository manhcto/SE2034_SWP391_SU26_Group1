<%@page contentType="text/html" pageEncoding="UTF-8"%>

<h2>Đặt lại mật khẩu</h2>

<form action="${pageContext.request.contextPath}/reset-password" method="post">

  Mật khẩu mới:
  <input type="password" name="password" required>
  <br><br>

  Xác nhận mật khẩu:
  <input type="password" name="confirmPassword" required>
  <br><br>

  <button type="submit">Đặt lại</button>

</form>

<p style="color:red">${error}</p>