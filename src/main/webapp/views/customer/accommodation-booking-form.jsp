<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Xác nhận đặt phòng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --dark: #0f172a;
            --muted: #64748b;
            --border: #e2e8f0;
            --soft: #f8fafc;
            --bg: #eef3f8;
            --shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: #1e293b;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .booking-page {
            padding: 28px 0 56px;
        }

        .page-head {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .page-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #e8f0ff;
            color: #1d4ed8;
            font-weight: 900;
            margin-bottom: 12px;
        }

        .page-title {
            margin: 0;
            color: var(--dark);
            font-size: 32px;
            line-height: 1.18;
            font-weight: 950;
        }

        .page-subtitle {
            color: var(--muted);
            margin: 10px 0 0;
            font-weight: 650;
            line-height: 1.6;
        }

        .booking-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 380px;
            gap: 22px;
            align-items: start;
        }

        .form-card,
        .summary-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        .form-card {
            padding: 26px;
            border-top: 4px solid var(--primary);
        }

        .summary-card {
            position: sticky;
            top: 96px;
            overflow: hidden;
        }

        .summary-image {
            height: 190px;
            background: #e2e8f0;
        }

        .summary-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .summary-body {
            padding: 22px 22px 24px;
        }

        .form-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 18px;
            color: var(--dark);
            font-size: 21px;
            font-weight: 950;
        }

        .form-section-note {
            margin: -8px 0 20px;
            color: var(--muted);
            font-size: 14px;
            font-weight: 650;
        }

        .booking-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            display: block;
            margin-bottom: 7px;
            color: #27364f;
            font-size: 13px;
            font-weight: 900;
        }

        .form-control,
        .form-select {
            height: 50px;
            border-radius: 8px;
            border: 1px solid #dbe3ef;
            background: #ffffff;
            color: var(--dark);
            font-weight: 700;
        }

        input[type="file"].form-control {
            padding: 11px 14px;
        }

        textarea.form-control {
            min-height: 112px;
            padding-top: 14px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #7aa2ff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .summary-title {
            color: var(--dark);
            font-size: 22px;
            font-weight: 950;
            line-height: 1.3;
            margin-bottom: 6px;
        }

        .summary-place {
            color: #16a34a;
            font-weight: 850;
            margin-bottom: 16px;
        }

        .summary-line {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #526079;
            font-weight: 750;
        }

        .summary-line span:first-child {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .summary-line i {
            width: 18px;
            color: var(--primary);
        }

        .summary-line strong {
            color: var(--dark);
            text-align: right;
        }

        .summary-total {
            margin-top: 18px;
            padding: 16px;
            border-radius: 8px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

        .summary-total-label {
            color: #1e3a8a;
            font-weight: 900;
            margin-bottom: 5px;
        }

        .summary-total-value {
            color: #1d4ed8;
            font-size: 28px;
            font-weight: 950;
        }

        .form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .btn-submit-booking,
        .btn-soft-back {
            min-height: 52px;
            border-radius: 8px;
            padding: 13px 20px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
        }

        .btn-submit-booking {
            border: none;
            background: var(--primary);
            color: #ffffff;
            min-width: 180px;
        }

        .btn-submit-booking:hover {
            background: var(--primary-dark);
            color: #ffffff;
        }

        .btn-soft-back {
            border: 1px solid #cbd5e1;
            background: #ffffff;
            color: var(--dark);
        }

        .field-hint {
            display: block;
            margin-top: 7px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 650;
        }

        .booking-alert {
            border-radius: 8px;
            border: 1px solid #fecaca;
            background: #fee2e2;
            color: #7f1d1d;
            font-weight: 750;
        }

        @media (max-width: 992px) {
            .booking-layout {
                grid-template-columns: 1fr;
            }

            .summary-card {
                position: static;
            }
        }

        @media (max-width: 640px) {
            .page-head,
            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .booking-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="container booking-page">
    <div class="page-head">
        <div>
            <div class="page-kicker">
                <i class="fa-solid fa-clipboard-check"></i>
                Xác nhận thông tin
            </div>
            <h1 class="page-title">Hoàn tất thông tin đặt phòng</h1>
            <p class="page-subtitle">
                Thông tin được tự động lấy từ tài khoản của bạn. Bạn có thể chỉnh lại trước khi gửi yêu cầu đặt phòng.
            </p>
        </div>

        <a class="btn-soft-back" href="${detailUrl}">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại phòng
        </a>
    </div>

    <c:if test="${param.status == 'invalidCustomerInfo'}">
        <div class="alert booking-alert shadow-sm">
            <i class="fa-solid fa-circle-exclamation me-2"></i>
            Vui lòng kiểm tra lại thông tin khách lưu trú. CCCD/CMND phải gồm 9 hoặc 12 chữ số; ảnh CCCD hỗ trợ JPG, JPEG, PNG hoặc WEBP và tối đa 5MB.
        </div>
    </c:if>

    <div class="booking-layout">
        <section class="form-card">
            <h2 class="form-section-title">
                <i class="fa-solid fa-user-shield"></i>
                Thông tin khách lưu trú
            </h2>
            <p class="form-section-note">
                Thông tin được lấy từ tài khoản của bạn, có thể chỉnh lại nếu người nhận phòng dùng thông tin khác.
            </p>

            <form action="${pageContext.request.contextPath}/booking/accommodation" method="post" enctype="multipart/form-data">
                <input type="hidden" name="accommodationID" value="${accommodation.accommodationID}">
                <input type="hidden" name="roomID" value="${room.roomID}">
                <input type="hidden" name="checkIn" value="${checkIn}">
                <input type="hidden" name="checkOut" value="${checkOut}">
                <input type="hidden" name="adults" value="${adults}">
                <input type="hidden" name="children" value="${children}">
                <input type="hidden" name="rooms" value="${rooms}">
                <input type="hidden" name="guests" value="${guests}">

                <div class="booking-form-grid">
                    <div class="field">
                        <label for="firstName">Họ</label>
                        <input class="form-control" id="firstName" name="firstName" value="${user.firstName}" placeholder="Nhập họ" autocomplete="family-name" required>
                    </div>

                    <div class="field">
                        <label for="lastName">Tên</label>
                        <input class="form-control" id="lastName" name="lastName" value="${user.lastName}" placeholder="Nhập tên" autocomplete="given-name" required>
                    </div>

                    <div class="field">
                        <label for="email">Email</label>
                        <input class="form-control" id="email" type="email" name="email" value="${user.email}" placeholder="example@gmail.com" autocomplete="email" required>
                    </div>

                    <div class="field">
                        <label for="phone">Số điện thoại</label>
                        <input class="form-control" id="phone" name="phone" value="${user.phone}" placeholder="Nhập số điện thoại" autocomplete="tel" required>
                    </div>

                    <div class="field">
                        <label for="identityNumber">CCCD / CMND</label>
                        <input class="form-control"
                               id="identityNumber"
                               name="identityNumber"
                               inputmode="numeric"
                               minlength="9"
                               maxlength="23"
                               pattern="([0-9][ .-]?){9}|([0-9][ .-]?){12}"
                               placeholder="Nhập 9 hoặc 12 chữ số"
                               required>
                        <span class="field-hint">Có thể nhập liền hoặc có khoảng trắng, hệ thống sẽ tự chuẩn hóa.</span>
                    </div>

                    <div class="field">
                        <label for="identityImage">Ảnh CCCD / CMND</label>
                        <input class="form-control"
                               id="identityImage"
                               name="identityImage"
                               type="file"
                               accept=".jpg,.jpeg,.png,.webp,image/png,image/jpeg,image/webp"
                               required>
                        <span class="field-hint">JPG, JPEG, PNG hoặc WEBP; tối đa 5MB.</span>
                    </div>

                    <div class="field">
                        <label for="streetAddress">Số nhà, đường</label>
                        <input class="form-control"
                               id="streetAddress"
                               name="streetAddress"
                               maxlength="120"
                               pattern="^[\p{L}0-9\s,./-]+$"
                               placeholder="VD: 12 Tràng Tiền"
                               autocomplete="street-address"
                               required>
                        <span class="field-hint">Chỉ nhập chữ, số, khoảng trắng và các ký tự , . / -</span>
                    </div>

                    <div class="field">
                        <label for="city">Tỉnh/Thành phố</label>
                        <select class="form-select" id="city" name="city" required>
                            <option value="">Chọn tỉnh/thành phố</option>
                        </select>
                    </div>

                    <div class="field">
                        <label for="district">Quận/Huyện</label>
                        <select class="form-select" id="district" name="district" required disabled>
                            <option value="">Chọn quận/huyện</option>
                        </select>
                    </div>

                    <div class="field">
                        <label for="ward">Phường/Xã</label>
                        <select class="form-select" id="ward" name="ward" required disabled>
                            <option value="">Chọn phường/xã</option>
                        </select>
                    </div>

                    <div class="field full">
                        <label for="note">Ghi chú cho nơi lưu trú</label>
                        <textarea class="form-control" id="note" name="note" placeholder="Ví dụ: nhận phòng muộn, cần phòng yên tĩnh, hỗ trợ trẻ em..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <a class="btn-soft-back" href="${detailUrl}">
                        Hủy
                    </a>
                    <button class="btn-submit-booking" type="submit">
                        <i class="fa-solid fa-credit-card"></i>
                        Thanh toán
                    </button>
                </div>
            </form>
        </section>

        <aside class="summary-card">
            <div class="summary-image">
                <img src="${room.image}"
                     alt="${room.roomType}"
                     onerror="this.src='https://placehold.co/800x450?text=WonderVN+Room';">
            </div>

            <div class="summary-body">
                <div class="summary-title">${room.roomType}</div>
                <div class="summary-place">
                    <i class="fa-solid fa-location-dot me-1"></i>
                    ${accommodation.name}
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-calendar-check"></i> Nhận phòng</span>
                    <strong>${checkIn}</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-calendar-xmark"></i> Trả phòng</span>
                    <strong>${checkOut}</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-moon"></i> Số đêm</span>
                    <strong>${nights} đêm</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-bed"></i> Số phòng</span>
                    <strong>${rooms} phòng</strong>
                </div>

                <div class="summary-line">
                    <span><i class="fa-solid fa-user-group"></i> Số khách</span>
                    <strong>${adults} người lớn, ${children} trẻ em</strong>
                </div>

                <div class="summary-total">
                    <div class="summary-total-label">Tổng tiền tạm tính</div>
                    <div class="summary-total-value">
                        <fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="0"/> đ
                    </div>
                </div>
            </div>
        </aside>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const citySelect = document.getElementById("city");
        const districtSelect = document.getElementById("district");
        const wardSelect = document.getElementById("ward");

        // Biến lưu trữ dữ liệu gốc từ API
        let provincesData = [];

        // 1. Tải danh sách Tỉnh/Thành phố
        fetch("https://provinces.open-api.vn/api/?depth=3")
            .then(response => response.json())
            .then(data => {
                provincesData = data;

                data.forEach(province => {
                    // Tên gửi về Backend lưu DB (bỏ chữ Tỉnh/Thành phố dư thừa theo ý Backend)
                    let backendValue = province.name.replace("Thành phố ", "").replace("Tỉnh ", "");

                    let option = document.createElement("option");
                    option.value = backendValue;  // Giá trị submit form
                    option.text = province.name;  // Tên hiển thị cho người dùng nhìn
                    option.dataset.code = province.code; // Lưu mã định danh (Ví dụ: Hà Nội = 1)
                    citySelect.appendChild(option);
                });

                // Tự động chọn lại dữ liệu cũ nếu có (Old Value)
                const oldCity = "${city}";
                if (oldCity) {
                    citySelect.value = oldCity;
                    citySelect.dispatchEvent(new Event("change"));
                }
            })
            .catch(error => console.error("Lỗi tải API tỉnh thành:", error));

        // 2. Khi người dùng chọn Tỉnh/Thành phố -> Mở khóa và tải Quận/Huyện
        citySelect.addEventListener("change", function () {
            districtSelect.innerHTML = '<option value="">Chọn quận/huyện</option>';
            wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
            districtSelect.disabled = true;
            wardSelect.disabled = true;

            const selectedOption = citySelect.options[citySelect.selectedIndex];
            if (!selectedOption || !selectedOption.value) return;

            // Lấy mã Code thay vì lấy chữ tiếng Việt để tìm kiếm
            const cityCode = selectedOption.dataset.code;
            const province = provincesData.find(p => p.code == cityCode);

            if (province && province.districts) {
                province.districts.forEach(dist => {
                    let option = document.createElement("option");
                    option.value = dist.name;
                    option.text = dist.name;
                    option.dataset.code = dist.code; // Lưu mã định danh quận huyện
                    districtSelect.appendChild(option);
                });
                districtSelect.disabled = false;

                // Tự động chọn lại dữ liệu cũ nếu có
                const oldDistrict = "${district}";
                if (oldDistrict) {
                    setTimeout(() => {
                        districtSelect.value = oldDistrict;
                        districtSelect.dispatchEvent(new Event("change"));
                    }, 50);
                }
            }
        });

        // 3. Khi người dùng chọn Quận/Huyện -> Mở khóa và tải Phường/Xã
        districtSelect.addEventListener("change", function () {
            wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
            wardSelect.disabled = true;

            const cityOption = citySelect.options[citySelect.selectedIndex];
            const districtOption = districtSelect.options[districtSelect.selectedIndex];

            if (!cityOption || !districtOption || !districtOption.value) return;

            const cityCode = cityOption.dataset.code;
            const districtCode = districtOption.dataset.code;

            // Tìm chính xác cụm dữ liệu dựa trên Code định danh
            const province = provincesData.find(p => p.code == cityCode);
            if (province && province.districts) {
                const district = province.districts.find(d => d.code == districtCode);

                if (district && district.wards) {
                    district.wards.forEach(w => {
                        let option = document.createElement("option");
                        option.value = w.name;
                        option.text = w.name;
                        wardSelect.appendChild(option);
                    });
                    wardSelect.disabled = false;

                    // Tự động chọn lại dữ liệu cũ nếu có
                    const oldWard = "${ward}";
                    if (oldWard) {
                        setTimeout(() => { wardSelect.value = oldWard; }, 50);
                    }
                }
            }
        });
    });
</script>
</body>
</html>