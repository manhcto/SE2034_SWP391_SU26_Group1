<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

  <title>Sửa hồ sơ</title>

  <style>

    .container{
      width:500px;
      margin:50px auto;
      background:white;
      padding:30px;
      border-radius:15px;
      box-shadow:0 10px 30px rgba(0,0,0,.1);
    }

    h2{
      text-align:center;
    }

    .form-group{
      margin-bottom:15px;
    }

    input,select{
      width:100%;
      padding:10px;
      border:1px solid #ddd;
      border-radius:8px;
    }

    button{
      width:100%;
      background:#2563eb;
      color:white;
      border:none;
      padding:12px;
      border-radius:8px;
      cursor:pointer;
    }

    button:hover{
      background:#1d4ed8;
    }

  </style>

</head>
<body>

<div class="container">

  <h2>Sửa hồ sơ</h2>

  <form action="${pageContext.request.contextPath}/edit-profile"
        method="post">

    <div class="form-group">
      <label>Họ</label>

      <input
              type="text"
              name="firstName"
              value="${sessionScope.user.firstName}"
              required>
    </div>

    <div class="form-group">
      <label>Tên</label>

      <input
              type="text"
              name="lastName"
              value="${sessionScope.user.lastName}"
              required>
    </div>
    <div class="form-group">
      <label>Số điện thoại</label>

      <input
              type="text"
              name="lastName"
              value="${sessionScope.user.phone}"
              required>
    </div>


    <div class="form-group">

      <label>Gender</label>

      <select name="gender">

        <option value="Male"
        ${sessionScope.user.gender=='Male'?'selected':''}>
          Male
        </option>

        <option value="Female"
        ${sessionScope.user.gender=='Female'?'selected':''}>
          Female
        </option>

      </select>

    </div>

    <button type="submit">
      Save Changes
    </button>

  </form>

</div>

</body>
</html>