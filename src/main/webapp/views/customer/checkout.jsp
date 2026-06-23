<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Thanh toán & Đặt Tour</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=1000">

    <style>
        .checkout-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .error-box {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 1px solid #f87171;
        }

        .error-box ul {
            margin: 10px 0 0 0;
            padding-left: 20px;
        }

        .form-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .form-card h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 18px;
            color: #111827;
            border-bottom: 1px solid #f3f4f6;
            padding-bottom: 12px;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 250px;
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
            color: #374151;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-family: inherit;
            font-size: 15px;
            outline: none;
            transition: 0.2s;
            background-color: #ffffff;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-group input.input-error {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12);
        }

        .form-group input.input-error:focus {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.12);
        }

        .form-group input.input-valid:focus {
            border-color: #22c55e;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.12);
        }

        .field-error-message {
            display: none;
            color: #dc2626;
            font-size: 12px;
            font-weight: 500;
            margin-top: 5px;
            line-height: 1.35;
        }

        .field-error-message.show {
            display: block;
        }

        .checkout-btn {
            width: 100%;
            padding: 16px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
        }

        .tour-name {
            font-size: 18px;
            font-weight: bold;
            color: #111827;
            margin-bottom: 10px;
        }

        .price-info {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 14px;
            color: #374151;
            font-weight: 700;
            margin-top: 12px;
        }

        .price-info span {
            color: #2563eb;
            font-weight: 800;
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="section checkout-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 40px;">
            <div>
                <p class="section-kicker">Hoàn tất thủ tục</p>
                <h2>Thông tin Đặt Tour</h2>
                <p>Vui lòng điền đầy đủ thông tin để hệ thống ghi nhận đơn hàng của bạn.</p>
            </div>
        </div>

        <c:if test="${not empty errorList or not empty error}">
            <div class="error-box">
                <strong>⚠️ Vui lòng kiểm tra lại các thông tin sau:</strong>
                <ul>
                    <c:if test="${not empty error}">
                        <li>${error}</li>
                    </c:if>

                    <c:forEach items="${errorList}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/booking" method="POST" novalidate>

            <input type="hidden" name="tourScheduleID" value="${param.tourScheduleID}">
            <input type="hidden" name="tourName" value="${param.tourName}">

            <div class="form-card">
                <h3>Tour đang đặt</h3>

                <c:choose>
                    <c:when test="${not empty param.tourName}">
                        <div class="tour-name">${param.tourName}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="tour-name">Tour đã chọn</div>
                    </c:otherwise>
                </c:choose>

                <p>
                    <strong>Tour Schedule ID:</strong>
                    ${param.tourScheduleID}
                </p>

                <div class="price-info">
                    <span>Giá tour và tổng tiền sẽ được hệ thống tính theo lịch trình và số lượng khách.</span>
                </div>
            </div>

            <div class="form-card">
                <h3>1. Thông tin liên hệ</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">Họ và tên đệm *</label>
                        <input type="text"
                               id="firstName"
                               name="firstName"
                               value="${firstName}"
                               placeholder="VD: Nguyễn Văn">
                        <span class="field-error-message" id="firstNameError"></span>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Tên *</label>
                        <input type="text"
                               id="lastName"
                               name="lastName"
                               value="${lastName}"
                               placeholder="VD: A">
                        <span class="field-error-message" id="lastNameError"></span>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email"
                               id="email"
                               name="email"
                               value="${email}"
                               placeholder="nguyenvana@gmail.com">
                        <span class="field-error-message" id="emailError"></span>
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại *</label>
                        <input type="text"
                               id="phone"
                               name="phone"
                               value="${phone}"
                               placeholder="0987654321">
                        <span class="field-error-message" id="phoneError"></span>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="streetAddress">Số nhà, đường *</label>
                    <input type="text"
                           id="streetAddress"
                           name="streetAddress"
                           value="${streetAddress}"
                           placeholder="VD: Số 10 Nguyễn Trãi">
                    <span class="field-error-message" id="streetAddressError"></span>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="district">Quận / Huyện *</label>
                        <select id="district" name="district">
                            <option value="">-- Chọn quận / huyện --</option>
                            <option value="Quận Ba Đình" ${district == 'Quận Ba Đình' ? 'selected' : ''}>Quận Ba Đình</option>
                            <option value="Quận Hoàn Kiếm" ${district == 'Quận Hoàn Kiếm' ? 'selected' : ''}>Quận Hoàn Kiếm</option>
                            <option value="Quận Tây Hồ" ${district == 'Quận Tây Hồ' ? 'selected' : ''}>Quận Tây Hồ</option>
                            <option value="Quận Long Biên" ${district == 'Quận Long Biên' ? 'selected' : ''}>Quận Long Biên</option>
                            <option value="Quận Cầu Giấy" ${district == 'Quận Cầu Giấy' ? 'selected' : ''}>Quận Cầu Giấy</option>
                            <option value="Quận Đống Đa" ${district == 'Quận Đống Đa' ? 'selected' : ''}>Quận Đống Đa</option>
                            <option value="Quận Hai Bà Trưng" ${district == 'Quận Hai Bà Trưng' ? 'selected' : ''}>Quận Hai Bà Trưng</option>
                            <option value="Quận Hoàng Mai" ${district == 'Quận Hoàng Mai' ? 'selected' : ''}>Quận Hoàng Mai</option>
                            <option value="Quận Thanh Xuân" ${district == 'Quận Thanh Xuân' ? 'selected' : ''}>Quận Thanh Xuân</option>
                            <option value="Quận Nam Từ Liêm" ${district == 'Quận Nam Từ Liêm' ? 'selected' : ''}>Quận Nam Từ Liêm</option>
                            <option value="Quận Bắc Từ Liêm" ${district == 'Quận Bắc Từ Liêm' ? 'selected' : ''}>Quận Bắc Từ Liêm</option>
                            <option value="Quận Hà Đông" ${district == 'Quận Hà Đông' ? 'selected' : ''}>Quận Hà Đông</option>
                            <option value="Huyện Thanh Trì" ${district == 'Huyện Thanh Trì' ? 'selected' : ''}>Huyện Thanh Trì</option>
                            <option value="Huyện Gia Lâm" ${district == 'Huyện Gia Lâm' ? 'selected' : ''}>Huyện Gia Lâm</option>
                            <option value="Huyện Đông Anh" ${district == 'Huyện Đông Anh' ? 'selected' : ''}>Huyện Đông Anh</option>
                            <option value="Huyện Sóc Sơn" ${district == 'Huyện Sóc Sơn' ? 'selected' : ''}>Huyện Sóc Sơn</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="city">Tỉnh / Thành phố *</label>
                        <select id="city" name="city">
                            <option value="">-- Chọn tỉnh / thành phố --</option>
                            <option value="Hà Nội" ${city == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                            <option value="Hồ Chí Minh" ${city == 'Hồ Chí Minh' ? 'selected' : ''}>Hồ Chí Minh</option>
                            <option value="Đà Nẵng" ${city == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                            <option value="Hải Phòng" ${city == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
                            <option value="Cần Thơ" ${city == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                            <option value="Quảng Ninh" ${city == 'Quảng Ninh' ? 'selected' : ''}>Quảng Ninh</option>
                            <option value="Ninh Bình" ${city == 'Ninh Bình' ? 'selected' : ''}>Ninh Bình</option>
                            <option value="Huế" ${city == 'Huế' ? 'selected' : ''}>Huế</option>
                            <option value="Khánh Hòa" ${city == 'Khánh Hòa' ? 'selected' : ''}>Khánh Hòa</option>
                            <option value="Lâm Đồng" ${city == 'Lâm Đồng' ? 'selected' : ''}>Lâm Đồng</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label style="font-weight: normal; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 15px;">
                        <input type="checkbox"
                               name="isBookedForOther"
                        ${not empty param.isBookedForOther ? 'checked' : ''}
                               style="width: 18px; height: 18px; cursor: pointer;">
                        Tôi đang đặt tour hộ cho người khác
                    </label>
                </div>
            </div>

            <div class="form-card">
                <h3>2. Chi tiết số lượng</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="numberAdult">Số người lớn *</label>
                        <input type="text"
                               id="numberAdult"
                               name="numberAdult"
                               value="${not empty param.numberAdult ? param.numberAdult : 1}"
                               inputmode="numeric"
                               pattern="[0-9]*"
                               placeholder="VD: 1">
                        <span class="field-error-message" id="numberAdultError"></span>
                    </div>

                    <div class="form-group">
                        <label for="numberChildren">Số trẻ em</label>
                        <input type="text"
                               id="numberChildren"
                               name="numberChildren"
                               value="${not empty param.numberChildren ? param.numberChildren : 0}"
                               inputmode="numeric"
                               pattern="[0-9]*"
                               placeholder="VD: 0">
                        <span class="field-error-message" id="numberChildrenError"></span>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="note">Ghi chú thêm</label>
                    <textarea id="note"
                              name="note"
                              rows="3"
                              placeholder="Ví dụ: Ăn chay, yêu cầu xe lăn, ghép phòng...">${note}</textarea>
                </div>

                <div class="form-group">
                    <label for="totalPrice">Tổng tiền</label>
                    <input type="text"
                           id="totalPrice"
                           value="Hệ thống sẽ tự động tính sau khi xác nhận đặt tour"
                           readonly
                           style="background-color: #f9fafb; font-weight: bold; color: #111827;">
                </div>
            </div>

            <div style="text-align: center;">
                <button type="submit" class="primary-btn checkout-btn">
                    Xác nhận Thanh toán & Đặt Tour
                </button>
            </div>
        </form>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const checkoutForm = document.querySelector("form[action$='/booking']");

        const fields = {
            firstName: {
                element: document.getElementById("firstName"),
                error: document.getElementById("firstNameError"),
                validate: function (value) {
                    if (value.trim() === "") {
                        return "Vui lòng nhập họ và tên đệm.";
                    }

                    if (value.trim().length < 2) {
                        return "Họ và tên đệm phải có ít nhất 2 ký tự.";
                    }

                    if (value.trim().length > 100) {
                        return "Họ và tên đệm không được vượt quá 100 ký tự.";
                    }

                    if (!/^[A-Za-zÀ-ỹ\s]+$/.test(value.trim())) {
                        return "Họ và tên đệm chỉ được chứa chữ cái và khoảng trắng.";
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

                    if (value.trim().length > 255) {
                        return "Số nhà, đường không được vượt quá 255 ký tự.";
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

            field.element.addEventListener("focus", function () {
                validateField(field);
            });

            field.element.addEventListener("blur", function () {
                validateField(field);
                field.element.classList.remove("input-valid");
            });
        });

        if (checkoutForm) {
            checkoutForm.addEventListener("submit", function (event) {
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