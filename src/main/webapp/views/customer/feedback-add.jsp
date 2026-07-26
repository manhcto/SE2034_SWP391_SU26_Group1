<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Viết đánh giá</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .feedback-form-container {
            max-width: 700px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .feedback-form-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
        }

        .error-box {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 20px 24px;
            border-radius: 10px;
            border: 1px solid #f87171;
            margin: 0 auto 30px;
            font-size: 15px;
            line-height: 1.7;
        }

        .error-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .error-box ul {
            margin: 0;
            padding-left: 24px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 24px;
        }

        .form-group label {
            color: #374151;
            font-size: 14px;
            font-weight: 700;
        }

        .hint-text {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        .field-error {
            color: #dc2626;
            font-size: 13px;
            font-weight: 600;
            display: none;
        }

        /* ==== Đánh giá sao ==== */
        .star-rating {
            display: flex;
            gap: 6px;
        }

        .star-rating button {
            background: none;
            border: none;
            padding: 0;
            font-size: 38px;
            line-height: 1;
            color: #d1d5db;
            cursor: pointer;
            transition: transform 0.1s, color 0.15s;
        }

        .star-rating button:hover {
            transform: scale(1.15);
        }

        .star-rating button.active {
            color: #f59e0b;
        }

        .star-label-text {
            font-size: 14px;
            font-weight: 700;
            color: #f59e0b;
            min-height: 20px;
        }

        /* ==== Chọn ảnh ==== */
        .image-upload-box input[type="file"] {
            display: none;
        }

        .btn-choose-image {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            height: 44px;
            padding: 0 20px;
            border-radius: 10px;
            border: 2px dashed #93c5fd;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
            width: fit-content;
        }

        .btn-choose-image:hover {
            background: #dbeafe;
            border-color: #2563eb;
        }

        .image-preview-wrap {
            display: none;
            margin-top: 10px;
            position: relative;
            width: fit-content;
        }

        .image-preview-wrap img {
            max-width: 240px;
            max-height: 180px;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            object-fit: cover;
            display: block;
        }

        .btn-remove-image {
            position: absolute;
            top: -10px;
            right: -10px;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            border: none;
            background: #ef4444;
            color: #ffffff;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            line-height: 1;
        }

        .btn-remove-image:hover {
            background: #dc2626;
        }

        .image-file-name {
            font-size: 13px;
            color: #374151;
            margin-top: 6px;
            word-break: break-all;
        }

        /* ==== Textarea ==== */
        .form-group textarea {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 12px 14px;
            font-size: 14px;
            color: #111827;
            outline: none;
            box-sizing: border-box;
            background: #ffffff;
            min-height: 140px;
            resize: vertical;
            font-family: inherit;
        }

        .form-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .char-counter {
            font-size: 12px;
            color: #9ca3af;
            text-align: right;
        }

        /* ==== Nút ==== */
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
    <section class="feedback-form-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Đánh giá</p>
                <h2>Viết đánh giá cho <c:out value="${serviceName}"/></h2>
                <p>Đánh giá của bạn sẽ hiển thị công khai sau khi được nhân viên duyệt.</p>
            </div>
        </div>

        <c:if test="${not empty errors}">
            <div class="error-box">
                <div class="error-title">
                    <span>⚠</span>
                    <span>Vui lòng kiểm tra lại các thông tin sau:</span>
                </div>

                <ul>
                    <c:forEach items="${errors}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <div class="feedback-form-card">
            <c:choose>
                <c:when test="${not empty tourID}">
                    <c:set var="formAction"
                           value="${pageContext.request.contextPath}/feedback-add?tourID=${tourID}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="formAction"
                           value="${pageContext.request.contextPath}/feedback-add?accommodationID=${accommodationID}"/>
                </c:otherwise>
            </c:choose>

            <form id="feedbackForm"
                  action="${formAction}"
                  method="post"
                  enctype="multipart/form-data"
                  novalidate>

                <!-- Ô đánh giá sao -->
                <div class="form-group">
                    <label>Đánh giá sao <span style="color:#dc2626;">*</span></label>

                    <div class="star-rating" id="starRating">
                        <button type="button" data-value="1" aria-label="1 sao">★</button>
                        <button type="button" data-value="2" aria-label="2 sao">★</button>
                        <button type="button" data-value="3" aria-label="3 sao">★</button>
                        <button type="button" data-value="4" aria-label="4 sao">★</button>
                        <button type="button" data-value="5" aria-label="5 sao">★</button>
                    </div>

                    <div class="star-label-text" id="starLabelText"></div>

                    <input type="hidden" id="rate" name="rate" value="${not empty oldRate ? oldRate : ''}">
                    <span class="field-error" id="rateError">Vui lòng chọn số sao đánh giá.</span>
                </div>

                <!-- Nút chọn file ảnh (không bắt buộc) -->
                <div class="form-group image-upload-box">
                    <label>Ảnh minh họa (không bắt buộc)</label>

                    <button type="button" class="btn-choose-image" id="btnChooseImage">
                        📷 Chọn ảnh từ máy
                    </button>

                    <input type="file"
                           id="image"
                           name="image"
                           accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp">

                    <div class="image-preview-wrap" id="imagePreviewWrap">
                        <img id="imagePreview" src="" alt="Ảnh xem trước">
                        <button type="button" class="btn-remove-image" id="btnRemoveImage" aria-label="Xóa ảnh">×</button>
                    </div>

                    <div class="image-file-name" id="imageFileName"></div>

                    <span class="hint-text">Chấp nhận ảnh JPG, JPEG, PNG, WEBP. Dung lượng tối đa 5MB.</span>
                    <span class="field-error" id="imageError"></span>
                </div>

                <!-- Ô ghi đánh giá -->
                <div class="form-group">
                    <label for="content">Ghi đánh giá <span style="color:#dc2626;">*</span></label>

                    <textarea id="content"
                              name="content"
                              maxlength="1000"
                              placeholder="Chia sẻ cảm nhận của bạn (tối thiểu 10 ký tự)...">${not empty oldContent ? oldContent : ''}</textarea>

                    <div class="char-counter"><span id="charCount">0</span>/1000 ký tự</div>
                    <span class="field-error" id="contentError"></span>
                </div>

                <!-- Nút gửi -->
                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        Gửi đánh giá
                    </button>

                    <c:choose>
                        <c:when test="${not empty tourID}">
                            <a href="${pageContext.request.contextPath}/tour-detail?id=${tourID}#danh-gia"
                               class="btn-back">Quay lại đánh giá tour</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/feedback-list?accommodationID=${accommodationID}"
                               class="btn-back">Quay lại danh sách</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

<script>
    (function () {
        // ==== Đánh giá sao ====
        var starButtons = document.querySelectorAll('#starRating button');
        var rateInput = document.getElementById('rate');
        var starLabelText = document.getElementById('starLabelText');
        var rateError = document.getElementById('rateError');

        var starLabels = {
            1: '1 sao - Rất không hài lòng',
            2: '2 sao - Không hài lòng',
            3: '3 sao - Bình thường',
            4: '4 sao - Hài lòng',
            5: '5 sao - Rất hài lòng'
        };

        function renderStars(value) {
            starButtons.forEach(function (btn) {
                var btnValue = parseInt(btn.getAttribute('data-value'), 10);
                btn.classList.toggle('active', btnValue <= value);
            });
            starLabelText.textContent = value > 0 ? starLabels[value] : '';
        }

        starButtons.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var value = parseInt(btn.getAttribute('data-value'), 10);
                rateInput.value = value;
                renderStars(value);
                rateError.style.display = 'none';
            });
        });

        // Giữ lại số sao cũ khi server trả lỗi
        var oldRate = parseInt(rateInput.value, 10);
        if (!isNaN(oldRate) && oldRate >= 1 && oldRate <= 5) {
            renderStars(oldRate);
        }

        // ==== Chọn ảnh từ máy ====
        var btnChooseImage = document.getElementById('btnChooseImage');
        var imageInput = document.getElementById('image');
        var previewWrap = document.getElementById('imagePreviewWrap');
        var previewImg = document.getElementById('imagePreview');
        var btnRemoveImage = document.getElementById('btnRemoveImage');
        var imageFileName = document.getElementById('imageFileName');
        var imageError = document.getElementById('imageError');

        var MAX_SIZE = 5 * 1024 * 1024;
        var ALLOWED_EXT = ['.jpg', '.jpeg', '.png', '.webp'];

        btnChooseImage.addEventListener('click', function () {
            imageInput.click();
        });

        function clearImage() {
            imageInput.value = '';
            previewImg.src = '';
            previewWrap.style.display = 'none';
            imageFileName.textContent = '';
        }

        btnRemoveImage.addEventListener('click', function () {
            clearImage();
            imageError.style.display = 'none';
        });

        imageInput.addEventListener('change', function () {
            imageError.style.display = 'none';

            var file = imageInput.files && imageInput.files[0];
            if (!file) {
                clearImage();
                return;
            }

            var name = file.name.toLowerCase();
            var validExt = ALLOWED_EXT.some(function (ext) {
                return name.endsWith(ext);
            });

            if (!validExt) {
                clearImage();
                imageError.textContent = 'Chỉ chấp nhận ảnh JPG, JPEG, PNG hoặc WEBP.';
                imageError.style.display = 'block';
                return;
            }

            if (file.size > MAX_SIZE) {
                clearImage();
                imageError.textContent = 'Ảnh vượt quá dung lượng tối đa 5MB.';
                imageError.style.display = 'block';
                return;
            }

            var reader = new FileReader();
            reader.onload = function (e) {
                previewImg.src = e.target.result;
                previewWrap.style.display = 'block';
            };
            reader.readAsDataURL(file);

            imageFileName.textContent = file.name;
        });

        // ==== Đếm ký tự + validate nội dung ====
        var contentInput = document.getElementById('content');
        var charCount = document.getElementById('charCount');
        var contentError = document.getElementById('contentError');

        function updateCharCount() {
            charCount.textContent = contentInput.value.length;
        }

        contentInput.addEventListener('input', function () {
            updateCharCount();
            contentError.style.display = 'none';
        });

        updateCharCount();

        // ==== Validate khi submit ====
        document.getElementById('feedbackForm').addEventListener('submit', function (e) {
            var valid = true;

            var rateValue = parseInt(rateInput.value, 10);
            if (isNaN(rateValue) || rateValue < 1 || rateValue > 5) {
                rateError.style.display = 'block';
                valid = false;
            }

            var contentValue = contentInput.value.trim();
            if (contentValue.length === 0) {
                contentError.textContent = 'Vui lòng nhập nội dung đánh giá.';
                contentError.style.display = 'block';
                valid = false;
            } else if (contentValue.length < 10) {
                contentError.textContent = 'Nội dung đánh giá phải có ít nhất 10 ký tự.';
                contentError.style.display = 'block';
                valid = false;
            }

            if (!valid) {
                e.preventDefault();
            }
        });
    })();
</script>

</body>
</html>
