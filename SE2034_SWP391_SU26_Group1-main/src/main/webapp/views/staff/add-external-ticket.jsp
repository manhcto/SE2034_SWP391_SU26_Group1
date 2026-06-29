<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Trải Nghiệm Mới | WonderVN Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        .form-label { font-weight: 600; color: #1c2930; margin-bottom: 6px; font-size: 14px; }
        .card-form { background: white; border-radius: 12px; border: none; box-shadow: 0 2px 12px rgba(0,0,0,0.04); padding: 25px; margin-bottom: 20px; }
        .card-title-custom { font-size: 16px; font-weight: 700; color: #1e3a8a; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .preview-img-box { width: 100%; height: 200px; border: 2px dashed #cbd5e1; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; background: #f8fafc; margin-top: 10px; }
        .preview-img-box img { width: 100%; height: 100%; object-fit: cover; display: none; }
        .error-feedback { color: #dc3545; font-size: 13px; margin-top: 4px; display: none; font-weight: 500; }
    </style>
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="h3 fw-bold text-dark m-0">Thêm Trải Nghiệm Mới</h2>
                    <p class="text-muted m-0 fs-6">Tạo mới điểm tham quan hoặc hoạt động giải trí ngoài hệ thống.</p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/external-ticket?action=list" class="btn btn-outline-secondary px-3 fw-bold" style="border-radius: 8px;"><i class="fa-solid fa-xmark"></i> Hủy bỏ</a>
            </div>

            <form id="addTicketForm" action="${pageContext.request.contextPath}/staff/external-ticket?action=add" method="POST" onsubmit="return validateForm()">
                <div class="row g-4">

                    <div class="col-md-7">

                        <div class="card-form">
                            <div class="card-title-custom"><i class="fa-solid fa-file-lines"></i> 1. Thông tin chung</div>

                            <div class="mb-3">
                                <label class="form-label">Tên dịch vụ / Trải nghiệm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" id="ticketName" required maxlength="255" placeholder="Nhập tên điểm tham quan (Tối đa 255 ký tự)">
                                <div class="error-feedback" id="nameError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mô tả chi tiết <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="description" id="ticketDesc" rows="5" required maxlength="1000" placeholder="Mô tả trải nghiệm cho khách hàng biết (Tối đa 1000 ký tự)"></textarea>
                                <div class="error-feedback" id="descError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Link Ảnh Thumbnail (URL) <span class="text-danger">*</span></label>
                                <input type="url" class="form-control" name="image" id="imageInput" required placeholder="https://images.unsplash.com/...">
                                <div class="preview-img-box">
                                    <span id="previewText" class="text-muted fs-7"><i class="fa-regular fa-image fs-4 d-block text-center mb-2"></i>Ảnh xem trước sẽ hiển thị ở đây</span>
                                    <img id="imagePreview" src="" alt="Preview">
                                </div>
                            </div>
                        </div>

                        <div class="card-form">
                            <div class="card-title-custom"><i class="fa-solid fa-clock"></i> 2. Thời gian hoạt động</div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Hoạt động từ thứ <span class="text-danger">*</span></label>
                                    <select class="form-select" name="openDayFrom">
                                        <option value="Thứ 2">Thứ 2</option>
                                        <option value="Thứ 3">Thứ 3</option>
                                        <option value="Thứ 4">Thứ 4</option>
                                        <option value="Thứ 5">Thứ 5</option>
                                        <option value="Thứ 6">Thứ 6</option>
                                        <option value="Thứ 7">Thứ 7</option>
                                        <option value="Chủ Nhật">Chủ Nhật</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Hoạt động đến thứ <span class="text-danger">*</span></label>
                                    <select class="form-select" name="openDayTo">
                                        <option value="Chủ Nhật" selected>Chủ Nhật</option>
                                        <option value="Thứ 7">Thứ 7</option>
                                        <option value="Thứ 6">Thứ 6</option>
                                        <option value="Thứ 5">Thứ 5</option>
                                        <option value="Thứ 4">Thứ 4</option>
                                        <option value="Thứ 3">Thứ 3</option>
                                        <option value="Thứ 2">Thứ 2</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giờ mở cửa <span class="text-danger">*</span></label>
                                    <input type="time" class="form-control" name="timeOpen" id="timeOpen" required value="08:00">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giờ đóng cửa <span class="text-danger">*</span></label>
                                    <input type="time" class="form-control" name="timeClose" id="timeClose" required value="22:00">
                                    <div class="error-feedback" id="timeError"></div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="col-md-5">

                        <div class="card-form">
                            <div class="card-title-custom"><i class="fa-solid fa-gears"></i> 3. Thông tin vận hành</div>

                            <div class="mb-3">
                                <label class="form-label">Phân loại trải nghiệm <span class="text-danger">*</span></label>
                                <select class="form-select" name="type">
                                    <option value="Attraction">Điểm tham quan (Attraction)</option>
                                    <option value="Activity">Tour & Hoạt động (Activity)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Giá vé niêm yết (VND) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="ticketPrice" id="ticketPrice" required min="1" placeholder="VD: 150000 (Phải lớn hơn 0)">
                                <div class="error-feedback" id="priceError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số Hotline hỗ trợ <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="phone" id="ticketPhone" required placeholder="VD: 0912345678 (10-11 số)">
                                <div class="error-feedback" id="phoneError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Địa chỉ cụ thể / Địa điểm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="address" id="ticketAddress" required maxlength="500" placeholder="Số nhà, Tên đường, Quận, Tỉnh thành (Tối đa 500 ký tự)">
                                <div class="error-feedback" id="addressError"></div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Trạng thái hệ thống <span class="text-danger">*</span></label>
                                <select class="form-select border-primary bg-light" name="status">
                                    <option value="Active">Cho phép hoạt động (Active)</option>
                                    <option value="Inactive">Tạm khóa lưu kho (Inactive)</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2.5 fw-bold fs-5 shadow-sm" style="border-radius: 8px;">
                                <i class="fa-solid fa-floppy-disk"></i> LƯU DỮ LIỆU
                            </button>
                        </div>

                    </div>

                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // 1. Logic xử lý Preview ảnh tức thì khi Staff paste hoặc gõ link URL
    const imageInput = document.getElementById('imageInput');
    const imagePreview = document.getElementById('imagePreview');
    const previewText = document.getElementById('previewText');

    imageInput.addEventListener('input', function() {
        const url = this.value.trim();
        if (url) {
            imagePreview.src = url;
            imagePreview.style.display = 'block';
            previewText.style.display = 'none';
        } else {
            imagePreview.src = "";
            imagePreview.style.display = 'none';
            previewText.style.display = 'block';
        }
    });

    // Tự động kiểm tra nếu ảnh lỗi (Link die) thì ẩn đi hiện chữ thông báo
    imagePreview.addEventListener('error', function() {
        imagePreview.style.display = 'none';
        previewText.style.display = 'block';
        previewText.innerHTML = '<i class="fa-solid fa-triangle-exclamation text-danger fs-4 d-block text-center mb-2"></i><span class="text-danger fw-bold">Link ảnh lỗi hoặc không hiển thị được!</span>';
    });


    // 2. Hàm kiểm tra toàn bộ dữ liệu trước khi cho phép submit Form lên Server
    function validateForm() {
        let isValid = true;

        // Reset trạng thái báo lỗi ẩn đi trước khi check mới
        document.querySelectorAll('.error-feedback').forEach(el => {
            el.style.display = 'none';
            el.innerHTML = '';
        });
        document.querySelectorAll('.form-control').forEach(el => el.classList.remove('is-invalid'));

        // A. Validate độ dài chuỗi (Name, Desc, Address)
        const name = document.getElementById('ticketName');
        if (name.value.trim().length > 255) {
            showError('nameError', name, 'Tên dịch vụ không được phép vượt quá 255 ký tự!');
            isValid = false;
        }

        const desc = document.getElementById('ticketDesc');
        if (desc.value.trim().length > 1000) {
            showError('descError', desc, 'Mô tả chi tiết không được phép vượt quá 1000 ký tự!');
            isValid = false;
        }

        const address = document.getElementById('ticketAddress');
        if (address.value.trim().length > 500) {
            showError('addressError', address, 'Địa chỉ không được phép vượt quá 500 ký tự!');
            isValid = false;
        }

        // B. Validate giá vé (> 0 và phải là số)
        const price = document.getElementById('ticketPrice');
        if (isNaN(price.value) || parseFloat(price.value) <= 0) {
            showError('priceError', price, 'Giá vé bắt buộc phải là một số lớn hơn 0!');
            isValid = false;
        }

        // C. Validate Hotline (Chỉ cho phép số, bắt đầu bằng số 0, dài từ 10 - 11 số)
        const phone = document.getElementById('ticketPhone');
        const phoneRegex = /^0[0-9]{9,10}$/;
        if (!phoneRegex.test(phone.value.trim())) {
            showError('phoneError', phone, 'Hotline không hợp lệ! Số điện thoại bắt đầu từ số 0 và phải gồm đúng 10 đến 11 chữ số.');
            isValid = false;
        }

        // D. Validate Logic thời gian (Giờ đóng cửa bắt buộc phải sau giờ mở cửa)
        const timeOpen = document.getElementById('timeOpen').value;
        const timeClose = document.getElementById('timeClose').value;
        if (timeOpen && timeClose && timeOpen >= timeClose) {
            showError('timeError', document.getElementById('timeClose'), 'Vô lý! Giờ đóng cửa phải lớn hơn (sau) giờ mở cửa ít nhất 1 phút.');
            isValid = false;
        }

        return isValid;
    }

    // Hàm phụ trợ hiển thị viền đỏ và dòng cảnh báo
    function showError(errorId, inputEl, message) {
        const errorDiv = document.getElementById(errorId);
        errorDiv.innerHTML = `<i class="fa-solid fa-circle-exclamation"></i> ${message}`;
        errorDiv.style.display = 'block';
        inputEl.classList.add('is-invalid');
        inputEl.focus();
    }
</script>

</body>
</html>