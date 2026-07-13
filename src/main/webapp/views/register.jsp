<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - WonderVN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body class="auth-body">
<main class="auth-page">
    <section class="auth-brand" aria-label="WonderVN">
        <div class="auth-logo">
            <span>Wonder</span><span>VN</span><span class="auth-flag"><i class="fa-solid fa-star"></i></span>
        </div>
        <h1>Bắt đầu chuyến đi theo cách của bạn</h1>
        <p>Tạo tài khoản để lưu thông tin cá nhân, đặt dịch vụ nhanh hơn và theo dõi toàn bộ lịch trình dễ dàng.</p>
    </section>

    <section class="auth-panel">
        <div class="auth-card">
            <h2>Đăng ký tài khoản</h2>
            <p class="auth-subtitle">Điền thông tin chính xác để WonderVN hỗ trợ bạn tốt hơn khi đặt phòng, tour và phương tiện.</p>

            <c:if test="${not empty error}">
                <div class="auth-alert error">${error}</div>
            </c:if>

            <form class="auth-form" action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateRegisterForm()">
                <div class="auth-grid">
                    <div class="auth-field">
                        <label for="firstName">Họ</label>
                        <input class="auth-input" id="firstName" type="text" name="firstName" value="${param.firstName}" required>
                    </div>
                    <div class="auth-field">
                        <label for="lastName">Tên</label>
                        <input class="auth-input" id="lastName" type="text" name="lastName" value="${param.lastName}" required>
                    </div>
                </div>

                <div class="auth-grid">
                    <div class="auth-field">
                        <label for="email">Email</label>
                        <input class="auth-input" id="email" type="email" name="email" value="${param.email}" placeholder="you@example.com" required>
                    </div>
                    <div class="auth-field">
                        <label for="phone">Số điện thoại</label>
                        <input class="auth-input" id="phone" type="text" name="phone" value="${param.phone}" placeholder="10 chữ số" pattern="^[0-9]{10}$" maxlength="10" required>
                    </div>
                </div>

                <div class="auth-grid">
                    <div class="auth-field">
                        <label for="password">Mật khẩu</label>
                        <div class="password-wrap">
                            <input class="auth-input" id="password" type="password" name="password" placeholder="Tạo mật khẩu" required>
                            <button class="password-toggle" type="button" data-password-toggle="password" aria-label="Hiện mật khẩu">
                                <i class="fa-regular fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div class="auth-field">
                        <label for="confirmPassword">Nhập lại mật khẩu</label>
                        <div class="password-wrap">
                            <input class="auth-input" id="confirmPassword" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                        </div>
                    </div>
                </div>

                <div class="auth-grid">
                    <div class="auth-field">
                        <label for="gender">Giới tính</label>
                        <select class="auth-select" id="gender" name="gender">
                            <option value="">-- Chọn giới tính --</option>
                            <option value="Nam" ${param.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${param.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${param.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                    <div class="auth-field">
                        <label for="dob">Ngày sinh</label>
                        <input class="auth-input" id="dob" type="date" name="dob" value="${param.dob}" required>
                    </div>
                </div>

                <div class="auth-field">
                    <label for="addressDetail">Địa chỉ chi tiết</label>
                    <input class="auth-input" id="addressDetail" name="streetAddress" type="text" value="${param.streetAddress}" placeholder="Số nhà, tên đường (không bắt buộc)">
                </div>

                <div class="auth-grid">
                    <div class="auth-field">
                        <label for="provinceSelect">Tỉnh / thành</label>
                        <select class="auth-select" id="provinceSelect" required>
                            <option value="">-- Chọn tỉnh/thành --</option>
                        </select>
                    </div>
                    <div class="auth-field">
                        <label for="wardSelect">Phường / xã</label>
                        <select class="auth-select" id="wardSelect" required disabled>
                            <option value="">-- Chọn phường/xã --</option>
                        </select>
                    </div>
                </div>

                <input type="hidden" id="address" name="address" value="${param.address}">
                <input type="hidden" id="administrativeUnitID" name="administrativeUnitID" value="${param.administrativeUnitID}">
                <input type="hidden" name="roleID" value="4">
                <button class="auth-button" type="submit">Tạo tài khoản</button>
            </form>

            <div class="auth-links center">
                <span>Đã có tài khoản? <a class="auth-link" href="${pageContext.request.contextPath}/login">Đăng nhập</a></span>
            </div>
        </div>
    </section>
</main>

<script>
    const administrativeUnits = [
        <c:forEach var="unit" items="${administrativeUnitList}" varStatus="loop">
        {
            id: "${unit.administrativeUnitID}",
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
    const administrativeUnitIDInput = document.getElementById("administrativeUnitID");
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
        return unit.ward;
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
        const selectedUnit = administrativeUnits.find(function (unit) {
            return unit.province === province && formatWard(unit) === ward;
        });

        administrativeUnitIDInput.value = selectedUnit ? selectedUnit.id : "";

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
        administrativeUnitIDInput.value = matchedUnit.id;

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

    document.querySelectorAll("[data-password-toggle]").forEach(function (button) {
        button.addEventListener("click", function () {
            const input = document.getElementById(button.dataset.passwordToggle);
            const icon = button.querySelector("i");
            const isHidden = input.type === "password";
            input.type = isHidden ? "text" : "password";
            icon.className = isHidden ? "fa-regular fa-eye-slash" : "fa-regular fa-eye";
            button.setAttribute("aria-label", isHidden ? "Ẩn mật khẩu" : "Hiện mật khẩu");
        });
    });

    function validateRegisterForm() {
        const dobValue = document.getElementById("dob").value;
        const phone = document.getElementById("phone").value;
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        buildAddressText();

        if (!provinceSelect.value || !wardSelect.value || !addressInput.value.trim()) {
            alert("Vui lòng chọn đủ tỉnh/thành và phường/xã.");
            return false;
        }

        if (!/^[0-9]{10}$/.test(phone)) {
            alert("Số điện thoại phải đúng 10 chữ số.");
            return false;
        }

        if (password !== confirmPassword) {
            alert("Mật khẩu nhập lại không khớp.");
            return false;
        }

        const dob = new Date(dobValue);
        const today = new Date();
        let age = today.getFullYear() - dob.getFullYear();
        const monthDiff = today.getMonth() - dob.getMonth();

        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
            age--;
        }

        if (age < 18) {
            alert("Bạn phải đủ 18 tuổi để đăng ký.");
            return false;
        }

        return true;
    }
</script>
</body>
</html>
