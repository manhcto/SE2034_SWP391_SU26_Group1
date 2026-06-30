<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Trải Nghiệm | WonderVN Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        .form-label { font-weight: 600; color: #1c2930; margin-bottom: 6px; font-size: 14px; }
        .card-form { background: white; border-radius: 12px; border: none; box-shadow: 0 2px 12px rgba(0,0,0,0.04); padding: 25px; margin-bottom: 20px; }
        .card-title-custom { font-size: 16px; font-weight: 700; color: #1e3a8a; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .preview-img-box { width: 100%; height: 200px; border: 2px dashed #cbd5e1; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; background: #f8fafc; margin-top: 10px; }
        .preview-img-box img { width: 100%; height: 100%; object-fit: cover; }
        .error-feedback { color: #dc3545; font-size: 13px; margin-top: 4px; display: none; font-weight: 500; }

        /* Highlight cho ô ID readonly */
        .readonly-highlight { background-color: #f8fafc; font-weight: 700; color: #475569; border: 1px dashed #cbd5e1; }
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
                    <h2 class="h3 fw-bold text-dark m-0">Cập nhật Trải Nghiệm</h2>
                    <p class="text-muted m-0 mt-1 fs-6 d-flex align-items-center gap-2">
                        Mã định danh hệ thống: <span class="badge bg-secondary fs-6">#${ticket.serviceID}</span>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/external-ticket?action=list" class="btn btn-outline-secondary px-3 fw-bold" style="border-radius: 8px;"><i class="fa-solid fa-xmark"></i> Hủy bỏ</a>
            </div>

            <form id="editTicketForm" action="${pageContext.request.contextPath}/staff/external-ticket?action=edit&id=${ticket.serviceID}" method="POST" onsubmit="return validateForm()">
                <div class="row g-4">

                    <div class="col-md-7">

                        <div class="card-form">
                            <div class="card-title-custom"><i class="fa-solid fa-file-lines"></i> 1. Thông tin chung</div>

                            <div class="mb-3">
                                <label class="form-label">Mã dịch vụ (Service ID)</label>
                                <input type="text" class="form-control readonly-highlight" value="#${ticket.serviceID}" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Tên dịch vụ / Trải nghiệm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" id="ticketName" required maxlength="255" value="${ticket.name}">
                                <div class="error-feedback" id="nameError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mô tả chi tiết <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="description" id="ticketDesc" rows="5" required maxlength="1000">${ticket.description}</textarea>
                                <div class="error-feedback" id="descError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Link Ảnh Thumbnail (URL) <span class="text-danger">*</span></label>
                                <input type="url" class="form-control" name="image" id="imageInput" required value="${ticket.image}">
                                <div class="error-feedback" id="urlError"></div>

                                <div class="preview-img-box">
                                    <span id="previewText" class="text-muted fs-7" style="display: none;"><i class="fa-regular fa-image fs-4 d-block text-center mb-2"></i>Ảnh xem trước sẽ hiển thị ở đây</span>
                                    <img id="imagePreview" src="${ticket.image}" alt="Preview">
                                </div>
                            </div>
                        </div>

                        <div class="card-form">
                            <div class="card-title-custom"><i class="fa-solid fa-clock"></i> 2. Thời gian hoạt động</div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Hoạt động từ thứ <span class="text-danger">*</span></label>
                                    <select class="form-select" name="openDayFrom">
                                        <option value="Thứ 2" ${openDayFrom == 'Thứ 2' ? 'selected' : ''}>Thứ 2</option>
                                        <option value="Thứ 3" ${openDayFrom == 'Thứ 3' ? 'selected' : ''}>Thứ 3</option>
                                        <option value="Thứ 4" ${openDayFrom == 'Thứ 4' ? 'selected' : ''}>Thứ 4</option>
                                        <option value="Thứ 5" ${openDayFrom == 'Thứ 5' ? 'selected' : ''}>Thứ 5</option>
                                        <option value="Thứ 6" ${openDayFrom == 'Thứ 6' ? 'selected' : ''}>Thứ 6</option>
                                        <option value="Thứ 7" ${openDayFrom == 'Thứ 7' ? 'selected' : ''}>Thứ 7</option>
                                        <option value="Chủ Nhật" ${openDayFrom == 'Chủ Nhật' ? 'selected' : ''}>Chủ Nhật</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Hoạt động đến thứ <span class="text-danger">*</span></label>
                                    <select class="form-select" name="openDayTo">
                                        <option value="Chủ Nhật" ${openDayTo == 'Chủ Nhật' ? 'selected' : ''}>Chủ Nhật</option>
                                        <option value="Thứ 7" ${openDayTo == 'Thứ 7' ? 'selected' : ''}>Thứ 7</option>
                                        <option value="Thứ 6" ${openDayTo == 'Thứ 6' ? 'selected' : ''}>Thứ 6</option>
                                        <option value="Thứ 5" ${openDayTo == 'Thứ 5' ? 'selected' : ''}>Thứ 5</option>
                                        <option value="Thứ 4" ${openDayTo == 'Thứ 4' ? 'selected' : ''}>Thứ 4</option>
                                        <option value="Thứ 3" ${openDayTo == 'Thứ 3' ? 'selected' : ''}>Thứ 3</option>
                                        <option value="Thứ 2" ${openDayTo == 'Thứ 2' ? 'selected' : ''}>Thứ 2</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giờ mở cửa <span class="text-danger">*</span></label>
                                    <input type="time" class="form-control" name="timeOpen" id="timeOpen" required value="${ticket.timeOpen}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giờ đóng cửa <span class="text-danger">*</span></label>
                                    <input type="time" class="form-control" name="timeClose" id="timeClose" required value="${ticket.timeClose}">
                                    <div class="error-feedback" id="timeError"></div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="col-md-5">

                        <div class="card-form">
                            <div class="card-title-custom"><i class="fa-solid fa-gears"></i> 3. Thông tin vận hành</div>

                            <div class="mb-4 p-3 rounded-3" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
                                <label class="form-label text-primary"><i class="fa-solid fa-power-off"></i> Trạng thái hoạt động <span class="text-danger">*</span></label>
                                <select class="form-select border-primary fw-bold" name="status" style="color: ${ticket.status == 'Active' ? '#16a34a' : '#475569'};">
                                    <option value="Active" ${ticket.status == 'Active' ? 'selected' : ''}>Cho phép hoạt động (Active)</option>
                                    <option value="Inactive" ${ticket.status == 'Inactive' ? 'selected' : ''}>Tạm khóa lưu kho (Inactive)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Phân loại trải nghiệm <span class="text-danger">*</span></label>
                                <select class="form-select" name="type">
                                    <option value="Attraction" ${ticket.type == 'Attraction' ? 'selected' : ''}>Điểm tham quan (Attraction)</option>
                                    <option value="Activity" ${ticket.type == 'Activity' ? 'selected' : ''}>Tour & Hoạt động (Activity)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Giá vé niêm yết (VND) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="ticketPrice" id="ticketPrice" required min="1" value="<fmt:formatNumber value='${ticket.ticketPrice}' pattern='#'/>">
                                <div class="error-feedback" id="priceError"></div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số Hotline hỗ trợ <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="phone" id="ticketPhone" required value="${ticket.phone}">
                                <div class="error-feedback" id="phoneError"></div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Địa chỉ cụ thể / Địa điểm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="address" id="ticketAddress" required maxlength="500" value="${ticket.address}">
                                <div class="error-feedback" id="addressError"></div>
                            </div>

                            <button type="submit" class="btn btn-warning w-100 py-2.5 fw-bold fs-5 shadow-sm text-dark" style="border-radius: 8px;">
                                <i class="fa-solid fa-floppy-disk"></i> LƯU THAY ĐỔI
                            </button>
                        </div>

                    </div>

                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // 1. Preview Ảnh
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

    imagePreview.addEventListener('error', function() {
        imagePreview.style.display = 'none';
        previewText.style.display = 'block';
        previewText.innerHTML = '<i class="fa-solid fa-triangle-exclamation text-danger fs-4 d-block text-center mb-2"></i><span class="text-danger fw-bold">Link ảnh lỗi hoặc không hiển thị được!</span>';
    });

    // Bắt sự kiện đổi màu Status khi User chọn Select
    document.querySelector('select[name="status"]').addEventListener('change', function() {
        this.style.color = this.value === 'Active' ? '#16a34a' : '#475569';
    });

    // 2. Validate Toàn Diện (Bổ sung check "http")
    function validateForm() {
        let isValid = true;

        document.querySelectorAll('.error-feedback').forEach(el => {
            el.style.display = 'none';
            el.innerHTML = '';
        });
        document.querySelectorAll('.form-control').forEach(el => el.classList.remove('is-invalid'));

        // Validate URL Ảnh bắt đầu bằng http/https
        const urlInput = document.getElementById('imageInput');
        const urlValue = urlInput.value.trim();
        if (!urlValue.startsWith('http://') && !urlValue.startsWith('https://')) {
            showError('urlError', urlInput, 'Đường dẫn ảnh phải bắt đầu bằng http:// hoặc https://');
            isValid = false;
        }

        const name = document.getElementById('ticketName');
        if (name.value.trim().length > 255) {
            showError('nameError', name, 'Tên dịch vụ không vượt quá 255 ký tự!');
            isValid = false;
        }

        const desc = document.getElementById('ticketDesc');
        if (desc.value.trim().length > 1000) {
            showError('descError', desc, 'Mô tả chi tiết không vượt quá 1000 ký tự!');
            isValid = false;
        }

        const address = document.getElementById('ticketAddress');
        if (address.value.trim().length > 500) {
            showError('addressError', address, 'Địa chỉ không vượt quá 500 ký tự!');
            isValid = false;
        }

        const price = document.getElementById('ticketPrice');
        if (isNaN(price.value) || parseFloat(price.value) <= 0) {
            showError('priceError', price, 'Giá vé phải lớn hơn 0!');
            isValid = false;
        }

        // Validate Regex Phone (Đúng 10 hoặc 11 số, bắt đầu bằng 0)
        const phone = document.getElementById('ticketPhone');
        const phoneRegex = /^0[0-9]{9,10}$/;
        if (!phoneRegex.test(phone.value.trim())) {
            showError('phoneError', phone, 'Hotline không hợp lệ! Vui lòng nhập 10-11 số, bắt đầu bằng 0.');
            isValid = false;
        }

        // Validate Thời Gian: Đóng phải sau Mở
        const timeOpen = document.getElementById('timeOpen').value;
        const timeClose = document.getElementById('timeClose').value;
        if (timeOpen && timeClose && timeOpen >= timeClose) {
            showError('timeError', document.getElementById('timeClose'), 'Lỗi logic: Giờ đóng cửa phải sau giờ mở cửa.');
            isValid = false;
        }

        return isValid;
    }

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