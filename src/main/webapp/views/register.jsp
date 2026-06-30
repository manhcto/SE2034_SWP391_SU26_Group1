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
                        <input class="auth-input" id="firstName" type="text" name="firstName" value="${param.firstName}" placeholder="Nguyễn" required>
                    </div>
                    <div class="auth-field">
                        <label for="lastName">Tên</label>
                        <input class="auth-input" id="lastName" type="text" name="lastName" value="${param.lastName}" placeholder="Minh Anh" required>
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
                            <button class="password-toggle" type="button" data-password-toggle="confirmPassword" aria-label="Hiện mật khẩu">
                                <i class="fa-regular fa-eye"></i>
                            </button>
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
                    <label for="address">Tỉnh / thành</label>
                    <select class="auth-select" id="address" name="address" required>
                        <option value="">-- Chọn tỉnh/thành --</option>
                        <option>Hà Nội</option>
                        <option>TP Hồ Chí Minh</option>
                        <option>Đà Nẵng</option>
                        <option>Cần Thơ</option>
                        <option>Hải Phòng</option>
                        <option>An Giang</option>
                        <option>Bà Rịa - Vũng Tàu</option>
                        <option>Bắc Giang</option>
                        <option>Bắc Kạn</option>
                        <option>Bạc Liêu</option>
                        <option>Bắc Ninh</option>
                        <option>Bến Tre</option>
                        <option>Bình Định</option>
                        <option>Bình Dương</option>
                        <option>Bình Phước</option>
                        <option>Bình Thuận</option>
                        <option>Cà Mau</option>
                        <option>Cao Bằng</option>
                        <option>Đắk Lắk</option>
                        <option>Đắk Nông</option>
                        <option>Điện Biên</option>
                        <option>Đồng Nai</option>
                        <option>Đồng Tháp</option>
                        <option>Gia Lai</option>
                        <option>Hà Giang</option>
                        <option>Hà Nam</option>
                        <option>Hà Tĩnh</option>
                        <option>Hải Dương</option>
                        <option>Hậu Giang</option>
                        <option>Hòa Bình</option>
                        <option>Hưng Yên</option>
                        <option>Khánh Hòa</option>
                        <option>Kiên Giang</option>
                        <option>Kon Tum</option>
                        <option>Lai Châu</option>
                        <option>Lâm Đồng</option>
                        <option>Lạng Sơn</option>
                        <option>Lào Cai</option>
                        <option>Long An</option>
                        <option>Nam Định</option>
                        <option>Nghệ An</option>
                        <option>Ninh Bình</option>
                        <option>Ninh Thuận</option>
                        <option>Phú Thọ</option>
                        <option>Phú Yên</option>
                        <option>Quảng Bình</option>
                        <option>Quảng Nam</option>
                        <option>Quảng Ngãi</option>
                        <option>Quảng Ninh</option>
                        <option>Quảng Trị</option>
                        <option>Sóc Trăng</option>
                        <option>Sơn La</option>
                        <option>Tây Ninh</option>
                        <option>Thái Bình</option>
                        <option>Thái Nguyên</option>
                        <option>Thanh Hóa</option>
                        <option>Thừa Thiên Huế</option>
                        <option>Tiền Giang</option>
                        <option>Trà Vinh</option>
                        <option>Tuyên Quang</option>
                        <option>Vĩnh Long</option>
                        <option>Vĩnh Phúc</option>
                        <option>Yên Bái</option>
                    </select>
                </div>

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
    const selectedAddress = "${param.address}";
    if (selectedAddress) {
        document.querySelectorAll("#address option").forEach(function (option) {
            option.selected = option.value === selectedAddress || option.textContent === selectedAddress;
        });
    }

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
