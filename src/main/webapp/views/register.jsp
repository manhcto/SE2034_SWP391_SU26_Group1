<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng kí - WonderVN</title>

    <style>
        * {
            box-sizing: border-box;
        }

        select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
        }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #e0f2fe, #f8fafc);
            min-height: 100vh;

            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            width: 460px;
            background: #ffffff;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 20px 50px rgba(2, 132, 199, 0.15);
            border: 1px solid #e0f2fe;
        }

        h2 {
            text-align: center;
            color: #0284c7;
            margin-bottom: 6px;
            font-weight: 800;
        }

        .title-line {
            width: 60px;
            height: 4px;
            margin: 0 auto 18px auto;
            border-radius: 999px;
            background: linear-gradient(90deg, #2563eb, #0ea5e9);
        }

        .error {
            color: #ef4444;
            text-align: center;
            margin-bottom: 10px;
            font-weight: 600;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        input, select {
            width: 100%;
            height: 44px;
            padding: 0 12px;
            border-radius: 10px;
            border: 1px solid #dbeafe;
            background: #f8fafc;
            font-size: 14px;
            outline: none;
            transition: 0.2s;
        }

        input:focus, select:focus {
            border-color: #3b82f6;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.15);
        }

        button {
            width: 100%;
            height: 46px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #2563eb, #0ea5e9);
            color: white;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        button:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(37,99,235,0.25);
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Đăng ký tài khoản</h2>
    <div class="title-line"></div>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <form action="register" method="post" onsubmit="return validateAge()">

        <input type="text" name="firstName" placeholder="Họ" required />
        <input type="text" name="lastName" placeholder="Tên" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Mật khẩu" required />
        <input
                type="text"
                name="phone"
                id="phone"
                placeholder="Số điện thoai (10 ký tự)"
                pattern="^[0-9]{10}$"
                maxlength="10"
                required
        />

        <select name="gender">
            <option value="">-- Giới tính --</option>
            <option>Nam</option>
            <option>Nữ</option>
            <option>Khác</option>
        </select>

        <input type="date" name="dob" id="dob" required />

        <select name="address" required>
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

        <input type="hidden" name="roleID" value="4" />

        <button type="submit">Tạo tài khoản</button>
    </form>
</div>

<script>
    function validateAge() {
        const dob = new Date(document.getElementById("dob").value);
        const today = new Date();

        let age = today.getFullYear() - dob.getFullYear();
        const m = today.getMonth() - dob.getMonth();

        if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) {
            age--;
        }

        if (age < 18) {
            alert("Bạn phải đủ 18 tuổi để đăng ký!");
            return false;
        }

        const phone = document.getElementById("phone").value;

        if (!/^[0-9]{10}$/.test(phone)) {
            alert("Số điện thoại phải đúng 10 chữ số!");
            return false;
        }

        return true;
    }

</script>

</body>
</html>