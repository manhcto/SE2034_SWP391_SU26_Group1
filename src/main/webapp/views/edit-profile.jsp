<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
      --theme-main:#2563eb;
      --theme-accent:#3b82f6;
      --theme-dark:#1d4ed8;
      --theme-soft:rgba(37,99,235,.12);
      --theme-surface:#eff6ff;
      background:linear-gradient(180deg,#f8fbff 0%,#eef4ff 100%);
    }

    body.staff-theme{
      --theme-main:#0f766e;
      --theme-accent:#14b8a6;
      --theme-dark:#115e59;
      --theme-soft:rgba(15,118,110,.12);
      --theme-surface:#ecfdf5;
      background:linear-gradient(180deg,#f2fbf9 0%,#e7f8f4 100%);
    }

    body.guide-theme{
      --theme-main:#7c3aed;
      --theme-accent:#a855f7;
      --theme-dark:#5b21b6;
      --theme-soft:rgba(124,58,237,.12);
      --theme-surface:#f5f3ff;
      background:linear-gradient(180deg,#faf7ff 0%,#f2ecff 100%);
    }

    body.admin-theme{
      --theme-main:#dc2626;
      --theme-accent:#f97316;
      --theme-dark:#991b1b;
      --theme-soft:rgba(220,38,38,.12);
      --theme-surface:#fff1f2;
      background:linear-gradient(180deg,#fff7f7 0%,#ffeded 100%);
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
      border:1px solid rgba(148,163,184,.15);
      box-shadow:0 20px 45px rgba(15,23,42,.08);
    }

    .profile-header{
      background:
        radial-gradient(circle at top, rgba(255,255,255,.2), transparent 45%),
        linear-gradient(135deg,var(--theme-dark),var(--theme-main),var(--theme-accent));
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
      background:linear-gradient(180deg,#ffffff 0%,var(--theme-surface) 100%);
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
      background:#fff;
      outline:none;
      transition:.2s;
    }

    .form-group input:focus,
    .form-group select:focus{
      border-color:var(--theme-main);
      box-shadow:0 0 0 3px var(--theme-soft);
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

    .btn-return{
      background:#ffffff;
      color:var(--theme-main);
      border:1px solid rgba(148,163,184,.35);
      box-shadow:0 8px 20px rgba(15,23,42,.06);
    }

    .btn-return:hover{
      background:var(--theme-surface);
      border-color:var(--theme-main);
    }

    .btn-delete{
      background:#ef4444;
      color:white;
    }

    .btn-delete:hover{
      background:#dc2626;
    }

    .btn-save{
      background:linear-gradient(135deg,var(--theme-main),var(--theme-accent));
      color:white;
      box-shadow:0 12px 24px var(--theme-soft);
    }

    .btn-save:hover{
      filter:brightness(.96);
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
<body class="${empty editProfileTheme ? 'customer-theme' : editProfileTheme.concat('-theme')}">

<c:if test="${sessionScope.user.roleID == 4}">
  <jsp:include page="/views/common/client-header.jsp"/>
</c:if>

<c:set var="editProfileHomePath" value="${pageContext.request.contextPath}/home"/>
<c:if test="${sessionScope.user.roleID == 1}">
  <c:set var="editProfileHomePath" value="${pageContext.request.contextPath}/admin/home"/>
</c:if>
<c:if test="${sessionScope.user.roleID == 2}">
  <c:set var="editProfileHomePath" value="${pageContext.request.contextPath}/staff/home"/>
</c:if>
<c:if test="${sessionScope.user.roleID == 3}">
  <c:set var="editProfileHomePath" value="${pageContext.request.contextPath}/guide/home"/>
</c:if>

<div class="profile-container">
  <div class="profile-card">
    <div class="profile-header">
      <img class="avatar"
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
            action="${empty editProfileActionPath ? pageContext.request.contextPath.concat('/edit-profile') : editProfileActionPath}"
            method="post">

        <div class="form-grid">
          <div class="form-group">
            <label>Họ</label>
            <input type="text"
                   name="firstName"
                   value="${empty param.firstName ? sessionScope.user.firstName : param.firstName}"
                   required>
          </div>

          <div class="form-group">
            <label>Tên</label>
            <input type="text"
                   name="lastName"
                   value="${empty param.lastName ? sessionScope.user.lastName : param.lastName}"
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
                   value="${empty param.phone ? sessionScope.user.phone : param.phone}">
          </div>

          <div class="form-group">
            <label>Giới tính</label>
            <select name="gender">
              <c:set var="selectedGender" value="${empty param.gender ? sessionScope.user.gender : param.gender}" />
              <option value="Male" ${selectedGender == 'Male' ? 'selected' : ''}>Nam</option>
              <option value="Female" ${selectedGender == 'Female' ? 'selected' : ''}>Nữ</option>
            </select>
          </div>

          <div class="form-group">
            <label>Ngày sinh</label>
            <input type="date"
                   id="dob"
                   name="dob"
                   value="${empty param.dob ? sessionScope.user.dob : param.dob}"
                   required>
          </div>

          <div class="form-group full-width">
            <label for="addressDetail">Địa chỉ chi tiết</label>
            <input type="text"
                   id="addressDetail"
                   placeholder="Số nhà, tên đường (không bắt buộc)">
          </div>

          <div class="form-group">
            <label for="provinceSelect">Tỉnh / thành</label>
            <select id="provinceSelect" required>
              <option value="">-- Chọn tỉnh/thành --</option>
            </select>
          </div>

          <div class="form-group">
            <label for="wardSelect">Phường / xã</label>
            <select id="wardSelect" required disabled>
              <option value="">-- Chọn phường/xã --</option>
            </select>
          </div>

          <input type="hidden"
                 id="address"
                 name="address"
                 value="${empty param.address ? sessionScope.user.address : param.address}">
        </div>
      </form>

      <div class="action">
        <c:choose>
          <c:when test="${sessionScope.user!=null && sessionScope.user.roleID==4}">
            <form action="${pageContext.request.contextPath}/delete-account"
                  method="post"
                  onsubmit="return confirm('Bạn có chắc muốn xóa tài khoản này?');">
              <button type="submit" class="btn btn-delete">
                Xóa tài khoản
              </button>
            </form>
          </c:when>
          <c:when test="${sessionScope.user != null && (sessionScope.user.roleID == 1 || sessionScope.user.roleID == 2 || sessionScope.user.roleID == 3)}">
            <form action="${editProfileHomePath}" method="get">
              <button type="submit" class="btn btn-return">
                <- Quay lại Trang chủ
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
  const administrativeUnits = [
    <c:forEach var="unit" items="${administrativeUnitList}" varStatus="loop">
    {
      province: "${unit.provinceName}",
      ward: "${unit.wardName}",
      wardType: "${unit.wardType}"
    }${loop.last ? '' : ','}
    </c:forEach>
  ];

  const provinceSelect = document.getElementById("provinceSelect");
  const wardSelect = document.getElementById("wardSelect");
  const addressDetailInput = document.getElementById("addressDetail");
  const addressInput = document.getElementById("address");
  const savedAddress = addressInput.value || "";

  function uniqueProvinces() {
    const seen = new Set();
    return administrativeUnits.filter(function (unit) {
      if (seen.has(unit.province)) {
        return false;
      }
      seen.add(unit.province);
      return true;
    }).map(function (unit) {
      return unit.province;
    });
  }

  function wardsByProvince(province) {
    return administrativeUnits.filter(function (unit) {
      return unit.province === province;
    });
  }

  function formatWard(unit) {
    return (unit.wardType ? unit.wardType + " " : "") + unit.ward;
  }

  function fillSelect(select, options, placeholder, selectedValue) {
    select.innerHTML = "";

    const placeholderOption = document.createElement("option");
    placeholderOption.value = "";
    placeholderOption.textContent = placeholder;
    select.appendChild(placeholderOption);

    options.forEach(function (optionValue) {
      const option = document.createElement("option");
      option.value = optionValue;
      option.textContent = optionValue;
      option.selected = optionValue === selectedValue;
      select.appendChild(option);
    });
  }

  function fillWardSelect(province, selectedWard) {
    const wards = wardsByProvince(province).map(formatWard);
    fillSelect(wardSelect, wards, "-- Chọn phường/xã --", selectedWard);
    wardSelect.disabled = !province;
  }

  function buildAddressText() {
    const parts = [];
    const detail = addressDetailInput.value.trim();
    const ward = wardSelect.value.trim();
    const province = provinceSelect.value.trim();

    if (detail) {
      parts.push(detail);
    }
    if (ward) {
      parts.push(ward);
    }
    if (province) {
      parts.push(province);
    }

    addressInput.value = parts.join(", ");
  }

  function parseSavedAddress(addressText) {
    if (!addressText) {
      return;
    }

    const matchedUnit = administrativeUnits.find(function (unit) {
      const suffix = formatWard(unit) + ", " + unit.province;
      return addressText === suffix || addressText.endsWith(", " + suffix);
    });

    if (!matchedUnit) {
      if (uniqueProvinces().includes(addressText)) {
        provinceSelect.value = addressText;
        fillWardSelect(addressText, "");
      }
      return;
    }

    provinceSelect.value = matchedUnit.province;
    fillWardSelect(matchedUnit.province, formatWard(matchedUnit));

    const suffix = formatWard(matchedUnit) + ", " + matchedUnit.province;
    if (addressText !== suffix) {
      addressDetailInput.value = addressText.slice(0, addressText.length - suffix.length - 2);
    }
  }

  fillSelect(provinceSelect, uniqueProvinces(), "-- Chọn tỉnh/thành --", "");
  fillWardSelect("", "");
  parseSavedAddress(savedAddress);

  provinceSelect.addEventListener("change", function () {
    fillWardSelect(provinceSelect.value, "");
    buildAddressText();
  });

  wardSelect.addEventListener("change", buildAddressText);
  addressDetailInput.addEventListener("input", buildAddressText);

  document.getElementById("editProfileForm").addEventListener("submit", function(e){
    const dobValue = document.getElementById("dob").value;

    buildAddressText();

    if (!provinceSelect.value || !wardSelect.value || !addressInput.value.trim()) {
      alert("Vui lòng chọn đủ tỉnh/thành và phường/xã.");
      e.preventDefault();
      return;
    }

    if(!dobValue){
      alert("Vui lòng chọn ngày sinh.");
      e.preventDefault();
      return;
    }

    const dob = new Date(dobValue);
    const today = new Date();
    let age = today.getFullYear() - dob.getFullYear();
    const monthDiff = today.getMonth() - dob.getMonth();

    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
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
