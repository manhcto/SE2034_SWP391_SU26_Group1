<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Sửa đánh giá</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            font-family: "Be Vietnam Pro", Arial, sans-serif;
            color: #0f172a;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .feedback-page {
            width: min(1080px, calc(100% - 32px));
            margin: 0 auto;
            padding: 32px 0 56px;
        }

        .page-hero {
            position: relative;
            overflow: hidden;
            border-radius: 32px;
            padding: 34px;
            color: #ffffff;
            background:
                    linear-gradient(135deg, rgba(15, 23, 42, 0.94), rgba(30, 64, 175, 0.86)),
                    url("${empty serviceImage ? 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=80' : serviceImage}");
            background-size: cover;
            background-position: center;
            box-shadow: 0 22px 55px rgba(15, 23, 42, 0.20);
            margin-bottom: 24px;
        }

        .page-hero::after {
            content: "";
            position: absolute;
            right: -80px;
            bottom: -110px;
            width: 280px;
            height: 280px;
            border-radius: 999px;
            background: rgba(37, 99, 235, 0.34);
            filter: blur(12px);
        }

        .page-hero > * {
            position: relative;
            z-index: 2;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 15px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.24);
            font-size: 14px;
            font-weight: 900;
            margin-bottom: 16px;
            backdrop-filter: blur(12px);
        }

        .hero-badge i {
            color: #facc15;
        }

        .page-hero h1 {
            margin: 0 0 12px;
            font-size: clamp(30px, 4vw, 48px);
            line-height: 1.15;
            font-weight: 950;
            letter-spacing: -1px;
            max-width: 820px;
        }

        .page-hero p {
            margin: 0;
            max-width: 760px;
            color: rgba(255, 255, 255, 0.92);
            font-size: 16px;
            line-height: 1.7;
            font-weight: 600;
        }

        .hero-info-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 22px;
        }

        .hero-info-pill {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.24);
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
        }

        .hero-info-pill i {
            color: #fde68a;
        }

        .notice-box {
            border-radius: 18px;
            padding: 15px 18px;
            margin-bottom: 18px;
            font-size: 14px;
            font-weight: 800;
            line-height: 1.6;
        }

        .notice-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .notice-info {
            background: #eff6ff;
            color: #1e3a8a;
            border: 1px solid #bfdbfe;
        }

        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .back-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-back {
            min-height: 46px;
            border-radius: 999px;
            padding: 11px 18px;
            font-size: 14px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: #ffffff;
            border: 1px solid #dbe3ef;
            color: #0f172a;
            box-shadow: 0 8px 18px rgba(15, 23, 42, 0.06);
            transition: 0.18s ease;
        }

        .btn-back:hover {
            background: #f8fafc;
            transform: translateY(-1px);
        }

        .layout-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 22px;
            align-items: start;
        }

        .form-card,
        .side-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 28px;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.08);
        }

        .form-card {
            padding: 28px;
        }

        .side-card {
            padding: 22px;
            position: sticky;
            top: 96px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 18px;
            font-size: 22px;
            font-weight: 900;
            color: #0f172a;
        }

        .section-title i {
            color: #2563eb;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            color: #0f172a;
            font-size: 14px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            min-height: 52px;
            border-radius: 16px;
            border: 1px solid #dbe3ef;
            background: #ffffff;
            padding: 0 16px;
            color: #0f172a;
            font-size: 15px;
            font-family: inherit;
            font-weight: 700;
            outline: none;
            transition: 0.18s ease;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.10);
        }

        textarea.form-control {
            min-height: 170px;
            padding: 15px 16px;
            resize: vertical;
            line-height: 1.7;
        }

        .form-note {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.6;
            margin-top: 7px;
        }

        .rating-select-wrap {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            gap: 10px;
        }

        .rating-option input {
            display: none;
        }

        .rating-box {
            min-height: 58px;
            border-radius: 18px;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            color: #64748b;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            font-weight: 900;
            cursor: pointer;
            transition: 0.18s ease;
        }

        .rating-box i {
            color: #facc15;
        }

        .rating-option input:checked + .rating-box {
            background: #fef3c7;
            border-color: #f59e0b;
            color: #92400e;
            box-shadow: 0 10px 22px rgba(245, 158, 11, 0.16);
            transform: translateY(-1px);
        }

        .submit-row {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
            border-top: 1px dashed #cbd5e1;
            padding-top: 22px;
        }

        .btn-submit,
        .btn-cancel {
            min-height: 50px;
            border-radius: 999px;
            padding: 12px 22px;
            font-size: 15px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            font-family: inherit;
        }

        .btn-submit {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border: none;
            cursor: pointer;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.20);
        }

        .btn-submit:hover {
            filter: brightness(0.96);
        }

        .btn-cancel {
            background: #ffffff;
            color: #0f172a;
            border: 1px solid #cbd5e1;
        }

        .service-image {
            width: 100%;
            height: 190px;
            object-fit: cover;
            border-radius: 20px;
            background: #e2e8f0;
            margin-bottom: 16px;
        }

        .side-title {
            font-size: 20px;
            font-weight: 900;
            color: #0f172a;
            line-height: 1.35;
            margin-bottom: 12px;
        }

        .side-info-list {
            display: grid;
            gap: 12px;
        }

        .side-info-item {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 14px;
        }

        .side-label {
            color: #64748b;
            font-size: 12px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .side-value {
            color: #0f172a;
            font-size: 15px;
            font-weight: 900;
            word-break: break-word;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
        }

        .status-visible {
            background: #dcfce7;
            color: #166534;
        }

        .status-hidden {
            background: #fee2e2;
            color: #991b1b;
        }

        .rules-box {
            margin-top: 18px;
            border-top: 1px dashed #cbd5e1;
            padding-top: 16px;
        }

        .rule-item {
            display: flex;
            align-items: flex-start;
            gap: 9px;
            color: #475569;
            font-size: 13px;
            line-height: 1.6;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .rule-item i {
            color: #22c55e;
            margin-top: 3px;
        }

        .empty-box {
            background: #ffffff;
            border: 1px dashed #cbd5e1;
            border-radius: 24px;
            padding: 52px 20px;
            text-align: center;
            color: #64748b;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
        }

        .empty-box i {
            font-size: 46px;
            color: #94a3b8;
            margin-bottom: 14px;
        }

        .empty-box h3 {
            color: #0f172a;
            margin: 0 0 8px;
            font-size: 24px;
            font-weight: 900;
        }

        .empty-box p {
            margin: 0;
            font-size: 15px;
            line-height: 1.7;
        }

        @media (max-width: 920px) {
            .layout-grid {
                grid-template-columns: 1fr;
            }

            .side-card {
                position: static;
            }
        }

        @media (max-width: 620px) {
            .feedback-page {
                width: calc(100% - 20px);
                padding-top: 20px;
            }

            .page-hero {
                padding: 24px;
                border-radius: 24px;
            }

            .rating-select-wrap {
                grid-template-columns: 1fr;
            }

            .top-actions,
            .back-actions,
            .btn-back,
            .btn-submit,
            .btn-cancel {
                width: 100%;
            }

            .submit-row {
                align-items: stretch;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp"/>

<div class="feedback-page">
    <section class="page-hero">
        <div class="hero-badge">
            <i class="fa-solid fa-pen"></i>
            <span>Sửa đánh giá</span>
        </div>

        <c:choose>
            <c:when test="${not empty serviceName}">
                <h1>Sửa đánh giá về ${serviceName}</h1>
                <p>
                    Bạn có thể cập nhật điểm đánh giá, nội dung và hình ảnh minh họa.
                    Sau khi sửa, đánh giá sẽ chuyển về trạng thái chờ nhân viên duyệt lại.
                </p>
            </c:when>

            <c:otherwise>
                <h1>Sửa đánh giá của bạn</h1>
                <p>
                    Cập nhật nội dung đánh giá của bạn trên WonderVN.
                </p>
            </c:otherwise>
        </c:choose>

        <div class="hero-info-row">
            <c:if test="${not empty serviceTypeText}">
                <div class="hero-info-pill">
                    <i class="fa-solid fa-layer-group"></i>
                    <span>${serviceTypeText}</span>
                </div>
            </c:if>

            <c:if test="${not empty serviceName}">
                <div class="hero-info-pill">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>${serviceName}</span>
                </div>
            </c:if>

            <div class="hero-info-pill">
                <i class="fa-solid fa-eye-slash"></i>
                <span>Sau khi sửa sẽ chờ duyệt lại</span>
            </div>
        </div>
    </section>

    <c:if test="${not empty errors}">
        <div class="notice-box notice-error">
            <i class="fa-solid fa-triangle-exclamation"></i>
            Vui lòng kiểm tra lại thông tin:
            <ul style="margin: 8px 0 0 18px; padding: 0;">
                <c:forEach var="err" items="${errors}">
                    <li>${err}</li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="notice-box notice-error">
            <i class="fa-solid fa-triangle-exclamation"></i>
                ${error}
        </div>
    </c:if>

    <div class="top-actions">
        <div class="back-actions">
            <c:choose>
                <c:when test="${serviceID > 0}">
                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/feedback-list?type=${type}&serviceID=${serviceID}">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại đánh giá
                    </a>
                </c:when>

                <c:otherwise>
                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/feedback-list">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại đánh giá
                    </a>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty feedback && feedback.feedbackID > 0}">
                <a class="btn-back"
                   href="${pageContext.request.contextPath}/feedback-detail?feedbackID=${feedback.feedbackID}&type=${type}&serviceID=${serviceID}">
                    <i class="fa-solid fa-eye"></i>
                    Xem chi tiết
                </a>
            </c:if>

            <c:choose>
                <c:when test="${type == 'Accommodation' && serviceID > 0}">
                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/accommodation/detail?id=${serviceID}">
                        <i class="fa-solid fa-hotel"></i>
                        Quay lại khách sạn
                    </a>
                </c:when>

                <c:when test="${type == 'Vehicle' && serviceID > 0}">
                    <a class="btn-back"
                       href="${pageContext.request.contextPath}/vehicle/detail?id=${serviceID}">
                        <i class="fa-solid fa-car-side"></i>
                        Quay lại xe
                    </a>
                </c:when>
            </c:choose>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty feedback}">
            <div class="layout-grid">
                <div class="form-card">
                    <h2 class="section-title">
                        <i class="fa-solid fa-comment-dots"></i>
                        Cập nhật nội dung đánh giá
                    </h2>

                    <form action="${pageContext.request.contextPath}/feedback-edit" method="post">
                        <input type="hidden" name="feedbackID" value="${feedback.feedbackID}">
                        <input type="hidden" name="type" value="${type}">
                        <input type="hidden" name="serviceID" value="${serviceID}">

                        <div class="form-group">
                            <label class="form-label">
                                Điểm đánh giá <span style="color:#dc2626;">*</span>
                            </label>

                            <div class="rating-select-wrap">
                                <label class="rating-option">
                                    <input type="radio" name="rate" value="1" ${feedback.rate == 1 ? 'checked' : ''}>
                                    <span class="rating-box">
                                        <i class="fa-solid fa-star"></i>
                                        1
                                    </span>
                                </label>

                                <label class="rating-option">
                                    <input type="radio" name="rate" value="2" ${feedback.rate == 2 ? 'checked' : ''}>
                                    <span class="rating-box">
                                        <i class="fa-solid fa-star"></i>
                                        2
                                    </span>
                                </label>

                                <label class="rating-option">
                                    <input type="radio" name="rate" value="3" ${feedback.rate == 3 ? 'checked' : ''}>
                                    <span class="rating-box">
                                        <i class="fa-solid fa-star"></i>
                                        3
                                    </span>
                                </label>

                                <label class="rating-option">
                                    <input type="radio" name="rate" value="4" ${feedback.rate == 4 ? 'checked' : ''}>
                                    <span class="rating-box">
                                        <i class="fa-solid fa-star"></i>
                                        4
                                    </span>
                                </label>

                                <label class="rating-option">
                                    <input type="radio" name="rate" value="5" ${feedback.rate == 5 ? 'checked' : ''}>
                                    <span class="rating-box">
                                        <i class="fa-solid fa-star"></i>
                                        5
                                    </span>
                                </label>
                            </div>

                            <div class="form-note">
                                Chọn từ 1 đến 5 sao theo trải nghiệm của bạn.
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="content">
                                Nội dung đánh giá <span style="color:#dc2626;">*</span>
                            </label>

                            <textarea class="form-control"
                                      id="content"
                                      name="content"
                                      maxlength="1000"
                                      placeholder="Hãy chia sẻ cảm nhận của bạn về dịch vụ này..."
                                      required>${feedback.content}</textarea>

                            <div class="form-note">
                                Tối đa 1000 ký tự. Sau khi sửa, đánh giá sẽ cần nhân viên duyệt lại.
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="image">
                                Link hình ảnh minh họa
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="image"
                                   name="image"
                                   maxlength="500"
                                   value="${feedback.image}"
                                   placeholder="VD: https://example.com/image.jpg">

                            <div class="form-note">
                                Không bắt buộc. Nếu nhập, đường dẫn ảnh nên bắt đầu bằng http:// hoặc https://.
                            </div>
                        </div>

                        <div class="notice-box notice-info">
                            <i class="fa-solid fa-circle-info"></i>
                            Khách hàng không được tự đổi trạng thái hiển thị. Sau khi sửa, đánh giá sẽ tự chuyển về trạng thái chờ duyệt.
                        </div>

                        <div class="submit-row">
                            <a class="btn-cancel"
                               href="${pageContext.request.contextPath}/feedback-detail?feedbackID=${feedback.feedbackID}&type=${type}&serviceID=${serviceID}">
                                <i class="fa-solid fa-xmark"></i>
                                Hủy
                            </a>

                            <button type="submit" class="btn-submit">
                                <i class="fa-solid fa-floppy-disk"></i>
                                Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>

                <aside class="side-card">
                    <c:choose>
                        <c:when test="${not empty serviceImage}">
                            <img class="service-image"
                                 src="${serviceImage}"
                                 alt="${serviceName}"
                                 onerror="this.src='https://placehold.co/800x500?text=WonderVN';">
                        </c:when>

                        <c:otherwise>
                            <img class="service-image"
                                 src="https://placehold.co/800x500?text=WonderVN"
                                 alt="WonderVN">
                        </c:otherwise>
                    </c:choose>

                    <div class="side-title">
                        <c:choose>
                            <c:when test="${not empty serviceName}">
                                ${serviceName}
                            </c:when>
                            <c:otherwise>
                                Dịch vụ WonderVN
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="side-info-list">
                        <div class="side-info-item">
                            <div class="side-label">Loại dịch vụ</div>
                            <div class="side-value">
                                <c:choose>
                                    <c:when test="${not empty serviceTypeText}">
                                        ${serviceTypeText}
                                    </c:when>
                                    <c:otherwise>Dịch vụ</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="side-info-item">
                            <div class="side-label">Ngày tạo đánh giá</div>
                            <div class="side-value">
                                <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>

                        <div class="side-info-item">
                            <div class="side-label">Trạng thái hiện tại</div>
                            <div class="side-value">
                                <c:choose>
                                    <c:when test="${feedback.status == 'Visible'}">
                                        <span class="status-badge status-visible">
                                            <i class="fa-solid fa-circle-check"></i>
                                            Hiển thị
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="status-badge status-hidden">
                                            <i class="fa-solid fa-eye-slash"></i>
                                            Đang chờ duyệt
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="rules-box">
                        <div class="rule-item">
                            <i class="fa-solid fa-check-circle"></i>
                            <span>Bạn chỉ được sửa đánh giá do chính mình tạo.</span>
                        </div>

                        <div class="rule-item">
                            <i class="fa-solid fa-check-circle"></i>
                            <span>Sau khi sửa, đánh giá sẽ chuyển về trạng thái chờ duyệt.</span>
                        </div>

                        <div class="rule-item">
                            <i class="fa-solid fa-check-circle"></i>
                            <span>Nội dung nên rõ ràng, lịch sự và đúng trải nghiệm thực tế.</span>
                        </div>
                    </div>
                </aside>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-box">
                <i class="fa-regular fa-comment-dots"></i>
                <h3>Không tìm thấy đánh giá cần sửa</h3>
                <p>Đánh giá này không tồn tại hoặc bạn không có quyền chỉnh sửa.</p>
            </div>

            <div style="margin-top: 18px;">
                <a class="btn-back" href="${pageContext.request.contextPath}/feedback-list">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại danh sách đánh giá
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/views/common/client-footer.jsp"/>

</body>
</html>