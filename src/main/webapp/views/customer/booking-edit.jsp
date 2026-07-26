<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Sửa Booking</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

  <style>
    .edit-container {
      max-width: 900px;
      margin: 0 auto;
      padding: 40px 20px;
    }

    .edit-card {
      background: #ffffff;
      border: 1px solid #e5e7eb;
      border-radius: 14px;
      padding: 28px;
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
    }

    .booking-info {
      background: #f9fafb;
      border: 1px solid #e5e7eb;
      border-radius: 12px;
      padding: 18px;
      margin-bottom: 24px;
    }

    .booking-info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px 24px;
    }

    .info-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .info-label {
      color: #6b7280;
      font-size: 13px;
    }

    .info-value {
      color: #111827;
      font-size: 15px;
      font-weight: 700;
    }

    .edit-form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px 22px;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .form-group.full {
      grid-column: 1 / -1;
    }

    .form-group label {
      color: #374151;
      font-size: 14px;
      font-weight: 700;
    }

    .form-group input,
    .form-group textarea,
    .form-group select {
      width: 100%;
      border: 1px solid #d1d5db;
      border-radius: 10px;
      padding: 12px 14px;
      font-size: 14px;
      color: #111827;
      outline: none;
      box-sizing: border-box;
      background-color: #ffffff;
    }

    .form-group input:focus,
    .form-group textarea:focus,
    .form-group select:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .form-group input.input-error,
    .form-group select.input-error {
      border-color: #ef4444;
      box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12);
    }

    .form-group input.input-error:focus,
    .form-group select.input-error:focus {
      border-color: #ef4444;
      box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12);
    }

    .form-group input.input-valid:focus,
    .form-group select.input-valid:focus {
      border-color: #22c55e;
      box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.12);
    }

    .field-error-message {
      display: none;
      color: #dc2626;
      font-size: 12px;
      font-weight: 500;
      line-height: 1.35;
      margin-top: -2px;
    }

    .field-error-message.show {
      display: block;
    }

    .form-group textarea {
      min-height: 110px;
      resize: vertical;
    }

    .checkbox-row {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-top: 8px;
    }

    .checkbox-row input {
      width: 18px;
      height: 18px;
    }

    .checkbox-row label {
      color: #374151;
      font-size: 14px;
      font-weight: 700;
    }

    .error-box {
      background-color: #fee2e2;
      color: #b91c1c;
      padding: 16px 20px;
      border-radius: 8px;
      border: 1px solid #f87171;
      margin-bottom: 24px;
    }

    .error-box ul {
      margin: 0;
      padding-left: 20px;
    }

    .single-error {
      background-color: #fee2e2;
      color: #b91c1c;
      padding: 16px 20px;
      border-radius: 8px;
      border: 1px solid #f87171;
      margin-bottom: 24px;
    }

    .form-actions {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 14px;
      margin-top: 28px;
      flex-wrap: wrap;
    }

    .btn-submit,
    .btn-back {
      min-width: 170px;
      height: 48px;
      padding: 0 22px;
      border-radius: 999px;
      font-size: 15px;
      font-weight: 700;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      line-height: 1;
      cursor: pointer;
      transition: 0.2s;
      box-sizing: border-box;
    }

    .btn-submit {
      background: #2563eb;
      color: #ffffff;
      border: 1px solid #2563eb;
    }

    .btn-submit:hover {
      background: #1d4ed8;
      border-color: #1d4ed8;
    }

    .btn-back {
      background: #ffffff;
      color: #2563eb;
      border: 1px solid #2563eb;
    }

    .btn-back:hover {
      background: #eff6ff;
    }

    @media (max-width: 768px) {
      .booking-info-grid,
      .edit-form-grid {
        grid-template-columns: 1fr;
      }

      .btn-submit,
      .btn-back {
        width: 100%;
      }
    }
  </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
  <section class="edit-container">
    <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
      <div>
        <p class="section-kicker">Edit Booking</p>
        <h2>Sửa thông tin Booking</h2>
      </div>
    </div>

    <c:if test="${not empty error}">
      <div class="single-error">
          ${error}
      </div>
    </c:if>

    <c:if test="${not empty errors}">
      <div class="error-box">
        <ul>
          <c:forEach items="${errors}" var="err">
            <li>${err}</li>
          </c:forEach>
        </ul>
      </div>
    </c:if>

    <c:if test="${not empty booking}">
      <div class="edit-card">
        <div class="booking-info">
          <div class="booking-info-grid">
            <div class="info-item">
              <span class="info-label">Mã Booking</span>
              <span class="info-value">${booking.bookingCode}</span>
            </div>

            <div class="info-item">
              <span class="info-label">Loại Booking</span>
              <span class="info-value">${booking.bookingType}</span>
            </div>

            <div class="info-item">
              <span class="info-label">Ngày đặt</span>
              <span class="info-value">
                <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
              </span>
            </div>

            <div class="info-item">
              <span class="info-label">Trạng thái</span>
              <span class="info-value">
                <c:choose>
                  <c:when test="${booking.status == 'Đang xử lý' || booking.status == 'Pending' || booking.status == 'Đang đợi chuyển khoản'}">Chờ xử lý</c:when>
                  <c:when test="${booking.status == 'Đã duyệt' || booking.status == 'Đã xác nhận' || booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                  <c:when test="${booking.status == 'Hoàn thành' || booking.status == 'Completed' || booking.status == 'Đã booking và thanh toán thành công'}">Thanh toán thành công</c:when>
                  <c:when test="${booking.status == 'Đã hủy' || booking.status == 'Cancelled'}">Đã hủy</c:when>
                  <c:when test="${booking.status == 'End' || booking.status == 'Ended' || booking.status == 'Tour kết thúc' || booking.status == 'Đã kết thúc'}">Hoàn tất Tour</c:when>
                  <c:otherwise>${booking.status}</c:otherwise>
                </c:choose>
              </span>
            </div>

            <div class="info-item">
              <span class="info-label">Tổng tiền hiện tại</span>
              <span class="info-value">
                <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
              </span>
            </div>
          </div>
        </div>

        <form action="${pageContext.request.contextPath}/booking-edit" method="post" novalidate>
          <input type="hidden" name="bookingID" value="${booking.bookingID}">

          <div class="edit-form-grid">
            <div class="form-group">
              <label for="firstName">Họ</label>
              <input type="text"
                     id="firstName"
                     name="firstName"
                     value="${booking.firstName}"
                     maxlength="100"
                     required>
              <span class="field-error-message" id="firstNameError"></span>
            </div>

            <div class="form-group">
              <label for="lastName">Tên</label>
              <input type="text"
                     id="lastName"
                     name="lastName"
                     value="${booking.lastName}"
                     maxlength="100"
                     required>
              <span class="field-error-message" id="lastNameError"></span>
            </div>

            <div class="form-group">
              <label for="email">Email</label>
              <input type="email"
                     id="email"
                     name="email"
                     value="${booking.email}"
                     maxlength="255"
                     required>
              <span class="field-error-message" id="emailError"></span>
            </div>

            <div class="form-group">
              <label for="phone">Số điện thoại</label>
              <input type="text"
                     id="phone"
                     name="phone"
                     value="${booking.phone}"
                     maxlength="10"
                     required>
              <span class="field-error-message" id="phoneError"></span>
            </div>

            <div class="form-group full">
              <label for="streetAddress">Số nhà, đường</label>
              <input type="text"
                     id="streetAddress"
                     name="streetAddress"
                     value="${streetAddress}"
                     maxlength="120"
                     placeholder="VD: Số 10 Nguyễn Trãi">
              <span class="field-error-message" id="streetAddressError"></span>
            </div>

            <div class="form-group">
              <label for="provinceSelect">Tỉnh / Thành phố</label>
              <select id="provinceSelect" required>
                <option value="">-- Chọn tỉnh / thành phố --</option>
              </select>
            </div>

            <div class="form-group">
              <label for="administrativeUnitID">Phường / Xã</label>
              <select id="administrativeUnitID" name="administrativeUnitID" required disabled>
                <option value="">-- Chọn phường / xã --</option>
              </select>
              <span class="field-error-message" id="administrativeUnitIDError"></span>
            </div>

            <div class="form-group">
              <label for="numberAdult">Số người lớn</label>
              <input type="text"
                     id="numberAdult"
                     name="numberAdult"
                     value="${booking.numberAdult}"
                     inputmode="numeric"
                     pattern="[0-9]*"
                     required>
              <span class="field-error-message" id="numberAdultError"></span>
            </div>

            <div class="form-group">
              <label for="numberChildren">Số trẻ em</label>
              <input type="text"
                     id="numberChildren"
                     name="numberChildren"
                     value="${booking.numberChildren}"
                     inputmode="numeric"
                     pattern="[0-9]*"
                     required>
              <span class="field-error-message" id="numberChildrenError"></span>
            </div>

            <div class="form-group">
              <label>Đặt hộ người khác</label>
              <div class="checkbox-row">
                <input type="checkbox"
                       id="isBookedForOther"
                       name="isBookedForOther"
                  ${booking.bookedForOther ? 'checked' : ''}>
                <label for="isBookedForOther">Có</label>
              </div>
            </div>

            <div class="form-group full">
              <label for="note">Ghi chú</label>
              <textarea id="note"
                        name="note"
                        maxlength="1000">${booking.note}</textarea>
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn-submit">
              Lưu thay đổi
            </button>

            <a href="${pageContext.request.contextPath}/booking-summary?bookingID=${booking.bookingID}"
               class="btn-back">
              Quay lại chi tiết
            </a>

            <a href="${pageContext.request.contextPath}/booking-list"
               class="btn-back">
              Danh sách booking
            </a>
          </div>
        </form>
      </div>
    </c:if>
  </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

<script>
  const administrativeUnits = [
    <c:forEach var="unit" items="${administrativeUnitList}" varStatus="loop">
    { id: "${unit.administrativeUnitID}", province: "${unit.provinceName}", ward: "${unit.wardName}" }${loop.last ? '' : ','}
    </c:forEach>
  ];

  document.addEventListener("DOMContentLoaded", function () {
    const editBookingForm = document.querySelector("form[action$='/booking-edit']");
    const provinceSelect = document.getElementById("provinceSelect");
    const wardSelect = document.getElementById("administrativeUnitID");
    const selectedUnitID = "${selectedAdministrativeUnitID}";

    [...new Set(administrativeUnits.map(unit => unit.province))].forEach(function (province) {
      const option = document.createElement("option");
      option.value = province;
      option.textContent = province;
      provinceSelect.appendChild(option);
    });

    function fillWards(province, selectedID) {
      wardSelect.innerHTML = '<option value="">-- Chọn phường / xã --</option>';
      administrativeUnits.filter(unit => unit.province === province).forEach(function (unit) {
        const option = document.createElement("option");
        option.value = unit.id;
        option.textContent = unit.ward;
        option.selected = unit.id === selectedID;
        wardSelect.appendChild(option);
      });
      wardSelect.disabled = !province;
    }

    const selectedUnit = administrativeUnits.find(unit => unit.id === selectedUnitID);
    if (selectedUnit) {
      provinceSelect.value = selectedUnit.province;
      fillWards(selectedUnit.province, selectedUnitID);
    }
    provinceSelect.addEventListener("change", function () {
      fillWards(this.value, "");
    });

    const fields = {
      firstName: {
        element: document.getElementById("firstName"),
        error: document.getElementById("firstNameError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập họ.";
          }

          if (value.trim().length < 2) {
            return "Họ phải có ít nhất 2 ký tự.";
          }

          if (value.trim().length > 100) {
            return "Họ không được vượt quá 100 ký tự.";
          }

          if (!/^[A-Za-zÀ-ỹ\s]+$/.test(value.trim())) {
            return "Họ chỉ được chứa chữ cái và khoảng trắng.";
          }

          return "";
        }
      },

      lastName: {
        element: document.getElementById("lastName"),
        error: document.getElementById("lastNameError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập tên.";
          }

          if (value.trim().length > 100) {
            return "Tên không được vượt quá 100 ký tự.";
          }

          if (!/^[A-Za-zÀ-ỹ\s]+$/.test(value.trim())) {
            return "Tên chỉ được chứa chữ cái và khoảng trắng.";
          }

          return "";
        }
      },

      email: {
        element: document.getElementById("email"),
        error: document.getElementById("emailError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập email.";
          }

          if (value.trim().length > 255) {
            return "Email không được vượt quá 255 ký tự.";
          }

          if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim())) {
            return "Email không đúng định dạng. Ví dụ: example@gmail.com.";
          }

          return "";
        }
      },

      phone: {
        element: document.getElementById("phone"),
        error: document.getElementById("phoneError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập số điện thoại.";
          }

          if (!/^0\d{9}$/.test(value.trim())) {
            return "Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.";
          }

          return "";
        }
      },

      streetAddress: {
        element: document.getElementById("streetAddress"),
        error: document.getElementById("streetAddressError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập số nhà, đường.";
          }

          if (value.trim().length > 120) {
            return "Số nhà, đường không được vượt quá 120 ký tự.";
          }

          if (!/^[A-Za-zÀ-ỹ0-9\s,./-]+$/.test(value.trim())) {
            return "Số nhà, đường chỉ được chứa chữ cái, số, khoảng trắng và các ký tự , . / -";
          }

          return "";
        }
      },

      administrativeUnitID: {
        element: wardSelect,
        error: document.getElementById("administrativeUnitIDError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng chọn tỉnh/thành phố và phường/xã.";
          }

          return "";
        }
      },

      numberAdult: {
        element: document.getElementById("numberAdult"),
        error: document.getElementById("numberAdultError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập số người lớn.";
          }

          if (!/^\d+$/.test(value.trim())) {
            return "Số người lớn chỉ được nhập số.";
          }

          if (parseInt(value.trim(), 10) < 1) {
            return "Số người lớn phải lớn hơn hoặc bằng 1.";
          }

          return "";
        }
      },

      numberChildren: {
        element: document.getElementById("numberChildren"),
        error: document.getElementById("numberChildrenError"),
        validate: function (value) {
          if (value.trim() === "") {
            return "Vui lòng nhập số trẻ em.";
          }

          if (!/^\d+$/.test(value.trim())) {
            return "Số trẻ em chỉ được nhập số.";
          }

          if (parseInt(value.trim(), 10) < 0) {
            return "Số trẻ em không được nhỏ hơn 0.";
          }

          return "";
        }
      }
    };

    function showError(field, message) {
      field.element.classList.add("input-error");
      field.element.classList.remove("input-valid");

      field.error.textContent = message;
      field.error.classList.add("show");
    }

    function showValid(field) {
      field.element.classList.remove("input-error");

      if (document.activeElement === field.element) {
        field.element.classList.add("input-valid");
      } else {
        field.element.classList.remove("input-valid");
      }

      field.error.textContent = "";
      field.error.classList.remove("show");
    }

    function validateField(field) {
      const message = field.validate(field.element.value);

      if (message) {
        showError(field, message);
        return false;
      }

      showValid(field);
      return true;
    }

    Object.keys(fields).forEach(function (key) {
      const field = fields[key];

      field.element.addEventListener("input", function () {
        validateField(field);
      });

      field.element.addEventListener("change", function () {
        validateField(field);
      });

      field.element.addEventListener("focus", function () {
        validateField(field);
      });

      field.element.addEventListener("blur", function () {
        validateField(field);
        field.element.classList.remove("input-valid");
      });
    });

    if (editBookingForm) {
      editBookingForm.addEventListener("submit", function (event) {
        let isValid = true;
        let firstInvalidElement = null;

        Object.keys(fields).forEach(function (key) {
          const field = fields[key];
          const valid = validateField(field);

          if (!valid && firstInvalidElement === null) {
            firstInvalidElement = field.element;
          }

          if (!valid) {
            isValid = false;
          }
        });

        if (!isValid) {
          event.preventDefault();

          if (firstInvalidElement) {
            firstInvalidElement.focus();
          }
        }
      });
    }
  });
</script>

</body>
</html>
