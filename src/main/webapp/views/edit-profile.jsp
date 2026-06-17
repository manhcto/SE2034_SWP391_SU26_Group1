<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Edit Profile | WonderVN</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <style>

    *{
      margin:0;
      padding:0;
      box-sizing:border-box;
      font-family:"Be Vietnam Pro",sans-serif;
    }

    body{
      background:#f5f7fb;
    }

    .profile-container{
      max-width:900px;
      margin:40px auto;
      padding:0 20px;
    }

    .profile-card{
      background:#fff;
      border-radius:20px;
      overflow:hidden;
      box-shadow:0 15px 35px rgba(0,0,0,.08);
    }

    .profile-header{
      background:linear-gradient(135deg,#2563eb,#3b82f6);
      padding:40px;
      text-align:center;
      color:white;
    }

    .avatar{
      width:120px;
      height:120px;
      border-radius:50%;
      object-fit:cover;
      border:5px solid rgba(255,255,255,.3);
      margin-bottom:15px;
    }

    .profile-header h2{
      font-size:28px;
      margin-bottom:8px;
    }

    .profile-body{
      padding:35px;
    }

    .section-title{
      font-size:22px;
      font-weight:700;
      color:#1e293b;
      margin-bottom:25px;
    }

    .form-grid{
      display:grid;
      grid-template-columns:repeat(2,1fr);
      gap:20px;
    }

    .form-group{
      display:flex;
      flex-direction:column;
    }

    .form-group label{
      margin-bottom:8px;
      color:#64748b;
      font-size:14px;
      font-weight:600;
    }

    .form-group input,
    .form-group select{
      padding:12px;
      border:1px solid #cbd5e1;
      border-radius:10px;
      outline:none;
      transition:.2s;
    }

    .form-group input:focus,
    .form-group select:focus{
      border-color:#2563eb;
      box-shadow:0 0 0 3px rgba(37,99,235,.15);
    }

    .full-width{
      grid-column:1 / -1;
    }

    .action{
      margin-top:30px;
      display:flex;
      justify-content:space-between;
      align-items:center;
    }

    .btn{
      padding:12px 24px;
      border:none;
      border-radius:10px;
      text-decoration:none;
      font-weight:600;
      cursor:pointer;
      transition:.2s;
    }

    .btn-delete{
      background:#ef4444;
      color:white;
    }

    .btn-delete:hover{
      background:#dc2626;
    }

    .btn-save{
      background:#2563eb;
      color:white;
    }

    .btn-save:hover{
      background:#1d4ed8;
    }

    @media(max-width:768px){

      .form-grid{
        grid-template-columns:1fr;
      }

      .action{
        flex-direction:column;
        gap:12px;
      }

      .btn{
        width:100%;
        text-align:center;
      }
    }

  </style>

</head>
<body>

<jsp:include page="/views/common/customer-header.jsp"/>

<div class="profile-container">

  <div class="profile-card">

    <div class="profile-header">

      <img
              class="avatar"
              src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
              alt="Avatar">

      <h2>Edit Profile</h2>

      <p>Cập nhật thông tin cá nhân của bạn</p>

    </div>

    <div class="profile-body">

      <div class="section-title">
        Thông tin cá nhân
      </div>

      <form id="editProfileForm"
            action="${pageContext.request.contextPath}/edit-profile"
            method="post">

        <div class="form-grid">

          <div class="form-group">
            <label>Họ</label>
            <input type="text"
                   name="firstName"
                   value="${sessionScope.user.firstName}"
                   required>
          </div>

          <div class="form-group">
            <label>Tên</label>
            <input type="text"
                   name="lastName"
                   value="${sessionScope.user.lastName}"
                   required>
          </div>

          <div class="form-group">
            <label>Email</label>
            <input type="email"
                   value="${sessionScope.user.email}"
                   readonly>
          </div>

          <div class="form-group">
            <label>Số điện thoại</label>
            <input type="text"
                   name="phone"
                   value="${sessionScope.user.phone}">
          </div>

          <div class="form-group">
            <label>Giới tính</label>

            <select name="gender">

              <option value="Male"
              ${sessionScope.user.gender=='Male'?'selected':''}>
                Nam
              </option>

              <option value="Female"
              ${sessionScope.user.gender=='Female'?'selected':''}>
                Nữ
              </option>

            </select>
          </div>

          <div class="form-group">
            <label>Ngày sinh</label>
            <input type="date"
                   id="dob"
                   name="dob"
                   value="${sessionScope.user.dob}"
                   required>
          </div>

          <div class="form-group full-width">

            <label>Tỉnh / Thành phố</label>

            <select name="address">

              <option value="Hà Nội" ${sessionScope.user.address=='Hà Nội'?'selected':''}>Hà Nội</option>
              <option value="TP. Hồ Chí Minh" ${sessionScope.user.address=='TP. Hồ Chí Minh'?'selected':''}>TP. Hồ Chí Minh</option>
              <option value="Hải Phòng" ${sessionScope.user.address=='Hải Phòng'?'selected':''}>Hải Phòng</option>
              <option value="Đà Nẵng" ${sessionScope.user.address=='Đà Nẵng'?'selected':''}>Đà Nẵng</option>
              <option value="Cần Thơ" ${sessionScope.user.address=='Cần Thơ'?'selected':''}>Cần Thơ</option>

              <option value="An Giang" ${sessionScope.user.address=='An Giang'?'selected':''}>An Giang</option>
              <option value="Bắc Ninh" ${sessionScope.user.address=='Bắc Ninh'?'selected':''}>Bắc Ninh</option>
              <option value="Cà Mau" ${sessionScope.user.address=='Cà Mau'?'selected':''}>Cà Mau</option>
              <option value="Cao Bằng" ${sessionScope.user.address=='Cao Bằng'?'selected':''}>Cao Bằng</option>
              <option value="Đắk Lắk" ${sessionScope.user.address=='Đắk Lắk'?'selected':''}>Đắk Lắk</option>

              <option value="Điện Biên" ${sessionScope.user.address=='Điện Biên'?'selected':''}>Điện Biên</option>
              <option value="Đồng Nai" ${sessionScope.user.address=='Đồng Nai'?'selected':''}>Đồng Nai</option>
              <option value="Đồng Tháp" ${sessionScope.user.address=='Đồng Tháp'?'selected':''}>Đồng Tháp</option>
              <option value="Gia Lai" ${sessionScope.user.address=='Gia Lai'?'selected':''}>Gia Lai</option>
              <option value="Hà Tĩnh" ${sessionScope.user.address=='Hà Tĩnh'?'selected':''}>Hà Tĩnh</option>

              <option value="Hưng Yên" ${sessionScope.user.address=='Hưng Yên'?'selected':''}>Hưng Yên</option>
              <option value="Khánh Hòa" ${sessionScope.user.address=='Khánh Hòa'?'selected':''}>Khánh Hòa</option>
              <option value="Lai Châu" ${sessionScope.user.address=='Lai Châu'?'selected':''}>Lai Châu</option>
              <option value="Lâm Đồng" ${sessionScope.user.address=='Lâm Đồng'?'selected':''}>Lâm Đồng</option>
              <option value="Lạng Sơn" ${sessionScope.user.address=='Lạng Sơn'?'selected':''}>Lạng Sơn</option>

              <option value="Lào Cai" ${sessionScope.user.address=='Lào Cai'?'selected':''}>Lào Cai</option>
              <option value="Nghệ An" ${sessionScope.user.address=='Nghệ An'?'selected':''}>Nghệ An</option>
              <option value="Ninh Bình" ${sessionScope.user.address=='Ninh Bình'?'selected':''}>Ninh Bình</option>
              <option value="Phú Thọ" ${sessionScope.user.address=='Phú Thọ'?'selected':''}>Phú Thọ</option>
              <option value="Quảng Ngãi" ${sessionScope.user.address=='Quảng Ngãi'?'selected':''}>Quảng Ngãi</option>

              <option value="Quảng Ninh" ${sessionScope.user.address=='Quảng Ninh'?'selected':''}>Quảng Ninh</option>
              <option value="Quảng Trị" ${sessionScope.user.address=='Quảng Trị'?'selected':''}>Quảng Trị</option>
              <option value="Sơn La" ${sessionScope.user.address=='Sơn La'?'selected':''}>Sơn La</option>
              <option value="Tây Ninh" ${sessionScope.user.address=='Tây Ninh'?'selected':''}>Tây Ninh</option>
              <option value="Thái Nguyên" ${sessionScope.user.address=='Thái Nguyên'?'selected':''}>Thái Nguyên</option>

              <option value="Thanh Hóa" ${sessionScope.user.address=='Thanh Hóa'?'selected':''}>Thanh Hóa</option>
              <option value="Tuyên Quang" ${sessionScope.user.address=='Tuyên Quang'?'selected':''}>Tuyên Quang</option>
              <option value="Vĩnh Long" ${sessionScope.user.address=='Vĩnh Long'?'selected':''}>Vĩnh Long</option>
              <option value="Huế" ${sessionScope.user.address=='Huế'?'selected':''}>Huế</option>

            </select>

          </div>

        </div>

      </form>

      <div class="action">

        <c:choose>
          <c:when test="${sessionScope.user!=null && sessionScope.user.roleID==4}">
            <form action="${pageContext.request.contextPath}/delete-account"
                  method="post"
                  onsubmit="return confirm('Bạn có chắc muốn xóa tài khoản này?');">

              <button type="submit"
                      class="btn btn-delete">
                Xóa tài khoản
              </button>

            </form>
          </c:when>
          <c:when test="${sessionScope.user != null && (sessionScope.user.roleID == 1 || sessionScope.user.roleID == 2 )}">
            <form action="${pageContext.request.contextPath}/home" method="get">
              <button type="submit" class="btn btn-return">
                <- Quay  lại Trang chủ
              </button>
            </form>
          </c:when>
        </c:choose>

        <button type="submit"
                form="editProfileForm"
                class="btn btn-save">
          Lưu thay đổi
        </button>

      </div>


    </div>

  </div>

</div>
<script>
  document.getElementById("editProfileForm").addEventListener("submit", function(e){

    const dobValue = document.getElementById("dob").value;

    if(!dobValue){
      alert("Vui lòng chọn ngày sinh.");
      e.preventDefault();
      return;
    }

    const dob = new Date(dobValue);
    const today = new Date();

    let age = today.getFullYear() - dob.getFullYear();

    const monthDiff = today.getMonth() - dob.getMonth();

    if (
            monthDiff < 0 ||
            (monthDiff === 0 && today.getDate() < dob.getDate())
    ) {
      age--;
    }

    if(age < 18){
      alert("Bạn phải từ 18 tuổi trở lên.");
      e.preventDefault();
    }

  });
</script>

</body>
</html>