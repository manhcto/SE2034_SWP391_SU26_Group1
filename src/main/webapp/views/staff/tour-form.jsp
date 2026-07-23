<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | ${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root { --primary:#2563eb; --primary-dark:#1d4ed8; --dark:#0f172a; --text:#1e293b; --muted:#64748b; --bg:#f3f6fb; --border:#e2e8f0; --shadow:0 16px 36px rgba(15,23,42,.08); }
        body { margin:0; background:var(--bg); color:var(--text); font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif; }
        .admin-layout { display:flex; min-height:100vh; }
        .admin-main { flex:1; min-width:0; padding:28px; }
        .page-card { background:#fff; border:1px solid var(--border); border-radius:18px; box-shadow:var(--shadow); margin-bottom:22px; overflow:hidden; }
        .topbar { padding:24px; display:flex; align-items:center; justify-content:space-between; gap:18px; }
        .topbar h1 { margin:0; color:var(--dark); font-size:28px; font-weight:900; }
        .topbar p { margin:6px 0 0; color:var(--muted); font-weight:600; }
        .section-title { padding:20px 22px; border-bottom:1px solid var(--border); display:flex; align-items:center; gap:12px; }
        .section-title h5 { margin:0; font-weight:900; color:var(--dark); }
        .section-body { padding:24px; }
        .form-block { border:1px solid var(--border); border-radius:14px; padding:22px; background:#fbfdff; height:100%; }
        .form-block + .form-block { margin-top:18px; }
        .form-block-title { display:flex; align-items:center; gap:10px; margin:0 0 18px; font-size:15px; font-weight:900; color:var(--dark); }
        .form-block-title i { color:var(--primary); }
        .form-label { font-weight:800; color:#334155; min-height:22px; margin-bottom:8px; }
        .form-control,.form-select { border-radius:12px; border:1px solid #dbe3ef; min-height:46px; }
        .form-control::placeholder { color:#94a3b8; }
        .row.g-3 { --bs-gutter-x: 18px; --bs-gutter-y: 18px; }
        .row.g-3 > [class*="col-"] { display:flex; flex-direction:column; }
        textarea.form-control { min-height:108px; }
        .form-control:focus,.form-select:focus { border-color:var(--primary); box-shadow:0 0 0 4px rgba(37,99,235,.12); }
        .btn-main { border:none; border-radius:14px; background:var(--primary); color:#fff; padding:12px 18px; font-weight:800; display:inline-flex; align-items:center; gap:8px; text-decoration:none; }
        .btn-main:hover { background:var(--primary-dark); color:#fff; }
        .btn-soft { border:1px solid var(--border); border-radius:14px; background:#fff; color:#334155; padding:12px 18px; font-weight:800; display:inline-flex; align-items:center; gap:8px; text-decoration:none; }
        .btn-soft:hover { background:#f8fafc; color:#0f172a; }
        .btn-icon { width:46px; height:46px; border:1px solid var(--border); border-radius:13px; background:#fff; color:#2563eb; display:inline-flex; align-items:center; justify-content:center; font-weight:900; }
        .btn-icon:hover { background:#eff6ff; color:#1d4ed8; }
        .day-card { border:1px solid var(--border); border-radius:18px; padding:18px; margin-bottom:16px; background:#fbfdff; }
        .day-pill { display:inline-flex; align-items:center; justify-content:center; min-width:78px; border-radius:999px; background:#dbeafe; color:#1d4ed8; font-weight:900; padding:7px 12px; margin-bottom:14px; }
        .hint-box { background:#eff6ff; border:1px solid #bfdbfe; color:#1e40af; border-radius:16px; padding:14px 16px; font-weight:700; }
        .preview-img { width:100%; max-height:220px; object-fit:cover; border-radius:16px; border:1px solid var(--border); background:#f8fafc; }
        .preview-small { width:100%; height:118px; object-fit:cover; border-radius:12px; border:1px solid var(--border); background:#f8fafc; }
        .muted { color:var(--muted); }
        .table thead th { background:#f8fafc; color:#475569; font-size:13px; text-transform:uppercase; letter-spacing:.04em; border-bottom:1px solid var(--border); }
        .table td,.table th { vertical-align:middle; padding:14px 16px; }
        .field-error { color:#dc2626; font-size:13px; font-weight:700; margin-top:6px; }
        .is-invalid { border-color:#dc2626 !important; }
        .status-chip { display:inline-flex; align-items:center; gap:8px; border-radius:999px; padding:8px 13px; font-weight:900; background:#eff6ff; color:#1d4ed8; }
        .custom-select-wrap { position:relative; }
        .custom-select-source { display:none; }
        .custom-select-trigger { width:100%; min-height:46px; border:1px solid #dbe3ef; border-radius:13px; background:#fff; color:#1e293b; display:flex; align-items:center; justify-content:space-between; gap:12px; padding:10px 14px; font-weight:600; cursor:default; }
        .custom-select-trigger.placeholder { color:#94a3b8; }
        .custom-select-trigger::after { content:"\f107"; font-family:"Font Awesome 6 Free"; font-weight:900; color:#64748b; }
        .custom-select-menu { position:absolute; z-index:30; top:calc(100% + 6px); left:0; right:0; max-height:240px; overflow:auto; background:#fff; border:1px solid #dbe3ef; border-radius:14px; box-shadow:0 18px 36px rgba(15,23,42,.16); padding:6px; display:none; }
        .custom-select-wrap:hover .custom-select-menu, .custom-select-wrap.open .custom-select-menu { display:block; }
        .custom-select-option { padding:10px 12px; border-radius:10px; font-weight:700; color:#334155; cursor:pointer; }
        .custom-select-option:hover, .custom-select-option.selected { background:#eff6ff; color:#1d4ed8; }
        .custom-select-option[hidden] { display:none; }
        .next-step-note { background:#ecfdf5; border:1px solid #bbf7d0; color:#166534; border-radius:16px; padding:14px 16px; font-weight:800; display:flex; align-items:flex-start; gap:10px; }
        @media (max-width:992px) { .admin-layout{display:block;} .admin-main{padding:18px;} .topbar{display:block;} }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp" />

    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>${pageTitle}</h1>
                <p>Staff nhập hồ sơ tour gốc, ảnh, tuyến đi và lịch trình. Sau khi lưu, hệ thống chuyển sang Lịch tour để nhập ngày khởi hành, số ghế và giá bán theo từng lịch.</p>
                <div class="mt-2">
                    <span class="status-chip"><i class="fa-solid fa-circle-dot"></i> ${mode == 'add' ? 'Bản nháp' : tour.displayStatus}</span>
                </div>
            </div>
            <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour">
                <i class="fa-solid fa-arrow-left"></i> Về danh sách
            </a>
        </section>

        <c:if test="${not empty errors}">
            <div class="alert alert-danger">
                <div class="fw-bold mb-2">Lỗi chung cần kiểm tra:</div>
                <ul class="mb-0">
                    <c:forEach var="error" items="${errors}"><li>${error}</li></c:forEach>
                </ul>
            </div>
        </c:if>

        <c:if test="${priceAndScheduleLocked}">
            <div class="alert alert-warning fw-bold">
                <c:choose>
                    <c:when test="${activeTourContentOnly}">
                        Tour đang mở bán. Staff chỉ được thêm/cập nhật ảnh và sửa điểm nổi bật của tour; lịch đã có không được sửa, chỉ được thêm lịch mới ở phần quản lý lịch của tour.
                    </c:when>
                    <c:otherwise>
                        Tour đang ở trạng thái ${tour.displayStatus}. Staff chỉ được bổ sung/chỉnh nội dung mô tả, ảnh, điểm nổi bật và lịch trình. Giá, tuyến, thời lượng và lịch khởi hành đang được quản lý ở Lịch tour để tránh sai lệch dữ liệu bán tour.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form method="post" action="${formAction}" enctype="multipart/form-data" id="tourForm" novalidate>
            <c:if test="${mode == 'edit'}"><input type="hidden" name="tourID" value="${tour.tourID}"></c:if>
            <input type="hidden" name="existingImage" value="${tour.image}">
            <input type="hidden" name="existingIntroImage" value="${tour.introImage}">
            <input type="hidden" name="startPlace" id="startPlace" value="${tour.startPlace}">
            <input type="hidden" name="endPlace" id="endPlace" value="${tour.endPlace}">
            <input type="hidden" name="status" value="${mode == 'add' ? 'Draft' : tour.status}">
            <input type="hidden" name="mainTransportType" value="${empty tour.mainTransportType ? 'Xe Du Lịch' : tour.mainTransportType}">

            <section class="page-card">
                <div class="section-title">
                    <i class="fa-solid fa-circle-info text-primary"></i>
                    <h5>1. Thông tin tour</h5>
                </div>
                <div class="section-body">
                    <div class="next-step-note mb-3">
                        <i class="fa-solid fa-circle-info mt-1"></i>
                        <span>AddTour chỉ lưu hồ sơ tour. Lịch khởi hành, số ghế và giá bán sẽ nhập ở trang Lịch tour sau bước này.</span>
                    </div>
                    <div class="form-block mb-3">
                        <div class="form-block-title"><i class="fa-solid fa-file-lines"></i>Thông tin định danh</div>
                        <div class="row g-3">
                        <div class="col-lg-6 col-md-12">
                            <label class="form-label">Tên tour <span class="text-danger">*</span></label>
                            <input type="text" name="tourName" class="form-control ${activeTourContentOnly ? 'locked' : ''} ${not empty fieldErrors.tourName ? 'is-invalid' : ''}" value="${tour.tourName}" required maxlength="255" minlength="5" placeholder="Ví dụ: Đà Nẵng - Hội An - Bà Nà 3N2Đ" ${activeTourContentOnly ? 'readonly' : ''}>
                            <c:if test="${not empty fieldErrors.tourName}"><div class="field-error">${fieldErrors.tourName}</div></c:if>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Mã tour</label>
                            <input type="text" class="form-control" value="${empty tour.tourCode ? nextTourCode : tour.tourCode}" readonly>
                            <div class="form-text">Mã dự kiến sẽ được kiểm tra lại khi lưu để tránh trùng.</div>
                        </div>

                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Khu vực <span class="text-danger">*</span></label>
                            <c:if test="${routeAndScheduleInfoLocked}"><input type="hidden" name="regionID" value="${tour.regionID}"></c:if>
                            <select name="${routeAndScheduleInfoLocked ? 'regionIDDisplay' : 'regionID'}" id="regionSelect" class="form-select ${not empty fieldErrors.regionID ? 'is-invalid' : ''}" required ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                <option value="">-- Chọn khu vực --</option>
                                <c:forEach var="region" items="${regionList}">
                                    <option value="${region.regionID}" data-name="${region.regionName}" ${tour.regionID == region.regionID ? 'selected' : ''}>${region.regionName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.regionID}"><div class="field-error">${fieldErrors.regionID}</div></c:if>
                        </div>

                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <c:if test="${activeTourContentOnly}"><input type="hidden" name="tourCategoryID" value="${tour.tourCategoryID}"></c:if>
                            <select name="${activeTourContentOnly ? 'tourCategoryIDDisplay' : 'tourCategoryID'}" class="form-select ${not empty fieldErrors.tourCategoryID ? 'is-invalid' : ''}" required ${activeTourContentOnly ? 'disabled' : ''}>
                                <option value="">Loại tour trọn gói</option>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${category.tourCategoryID}" ${tour.tourCategoryID == category.tourCategoryID ? 'selected' : ''}>${category.categoryName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.tourCategoryID}"><div class="field-error">${fieldErrors.tourCategoryID}</div></c:if>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Ảnh bìa tour</label>
                            <input type="file" name="coverImageFile" class="form-control image-input ${not empty fieldErrors.coverImage ? 'is-invalid' : ''}" accept="image/*" data-preview="coverPreview">
                            <input type="url" name="coverImageUrl" class="form-control mt-2 image-url-input ${not empty fieldErrors.coverImage ? 'is-invalid' : ''}" data-preview="coverPreview" placeholder="Hoặc dán URL ảnh bìa https://...">
                            <c:if test="${not empty fieldErrors.coverImage}"><div class="field-error">${fieldErrors.coverImage}</div></c:if>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Xem trước ảnh bìa</label>
                            <c:choose>
                                <c:when test="${not empty tour.image}">
                                    <c:set var="coverPreviewSrc" value="${tour.image}" />
                                    <c:if test="${not fn:startsWith(coverPreviewSrc, 'http://') and not fn:startsWith(coverPreviewSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(coverPreviewSrc, pageContext.request.contextPath))}">
                                        <c:set var="coverPreviewSrc" value="${pageContext.request.contextPath}${fn:startsWith(coverPreviewSrc, '/') ? '' : '/'}${coverPreviewSrc}" />
                                    </c:if>
                                    <img id="coverPreview" class="preview-small" src="${coverPreviewSrc}" alt="Ảnh bìa">
                                </c:when>
                                <c:otherwise><img id="coverPreview" class="preview-small" alt="Chưa chọn ảnh bìa"></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Ảnh giới thiệu</label>
                            <input type="file" name="introImageFile" class="form-control image-input ${not empty fieldErrors.introImage ? 'is-invalid' : ''}" accept="image/*" data-preview="introPreview">
                            <input type="url" name="introImageUrl" class="form-control mt-2 image-url-input ${not empty fieldErrors.introImage ? 'is-invalid' : ''}" data-preview="introPreview" placeholder="Hoặc dán URL ảnh giới thiệu https://...">
                            <c:if test="${not empty fieldErrors.introImage}"><div class="field-error">${fieldErrors.introImage}</div></c:if>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label">Xem trước ảnh giới thiệu</label>
                            <c:choose>
                                <c:when test="${not empty tour.introImage}">
                                    <c:set var="introPreviewSrc" value="${tour.introImage}" />
                                    <c:if test="${not fn:startsWith(introPreviewSrc, 'http://') and not fn:startsWith(introPreviewSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(introPreviewSrc, pageContext.request.contextPath))}">
                                        <c:set var="introPreviewSrc" value="${pageContext.request.contextPath}${fn:startsWith(introPreviewSrc, '/') ? '' : '/'}${introPreviewSrc}" />
                                    </c:if>
                                    <img id="introPreview" class="preview-small" src="${introPreviewSrc}" alt="Ảnh giới thiệu">
                                </c:when>
                                <c:otherwise><img id="introPreview" class="preview-small" alt="Chưa chọn ảnh giới thiệu"></c:otherwise>
                            </c:choose>
                        </div>

                        </div>
                    </div>

                    <div class="form-block mb-3">
                        <div class="form-block-title"><i class="fa-solid fa-route"></i>Tuyến đi và thời lượng</div>
                        <div class="row g-3">
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label">Số ngày <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="numberOfDay" id="numberOfDay" min="1" max="15" class="form-control ${not empty fieldErrors.numberOfDay ? 'is-invalid' : ''}" value="${dayCount}" required ${routeAndScheduleInfoLocked ? 'readonly' : ''} placeholder="Ví dụ: 3">
                                <button type="button" id="updateItineraryBtn" class="btn-icon" title="Cập nhật lịch trình từng ngày" ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                    <i class="fa-solid fa-rotate"></i>
                                </button>
                            </div>
                            <c:if test="${not empty fieldErrors.numberOfDay}"><div class="field-error">${fieldErrors.numberOfDay}</div></c:if>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label">Số đêm <span class="text-danger">*</span></label>
                            <input type="number" name="numberOfNights" id="numberOfNights" min="0" max="15" class="form-control ${not empty fieldErrors.numberOfNights ? 'is-invalid' : ''}" value="${empty tour.numberOfNights ? 0 : tour.numberOfNights}" required ${routeAndScheduleInfoLocked ? 'readonly' : ''} placeholder="Ví dụ: 2">
                            <c:if test="${not empty fieldErrors.numberOfNights}"><div class="field-error">${fieldErrors.numberOfNights}</div></c:if>
                        </div>
                        <div class="col-lg-4 col-md-12 d-flex align-items-end">
                            <div class="form-check fw-bold">
                                <input class="form-check-input" type="checkbox" name="featured" value="true" id="featured" ${tour.featured ? 'checked' : ''} ${activeTourContentOnly ? 'disabled' : ''}>
                                <label class="form-check-label" for="featured">Tour nổi bật</label>
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12">
                            <label class="form-label">Điểm khởi hành <span class="text-danger">*</span></label>
                            <select id="startPlaceSelect" class="form-select place-select ${not empty fieldErrors.startPlace ? 'is-invalid' : ''}" data-hidden="startPlace" data-current="${tour.startPlace}" required ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                <option value="">-- Chọn tỉnh/thành --</option>
                                <c:forEach var="unit" items="${administrativeUnitList}">
                                    <option value="${unit.provinceName}" data-region="${unit.regionGroup}" ${tour.startPlace == unit.provinceName ? 'selected' : ''}>${unit.provinceName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.startPlace}"><div class="field-error">${fieldErrors.startPlace}</div></c:if>
                        </div>
                        <div class="col-lg-6 col-md-12">
                            <label class="form-label">Điểm đến <span class="text-danger">*</span></label>
                            <select id="endPlaceSelect" class="form-select place-select ${not empty fieldErrors.endPlace ? 'is-invalid' : ''}" data-hidden="endPlace" data-current="${tour.endPlace}" required ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                <option value="">-- Chọn tỉnh/thành --</option>
                                <c:forEach var="unit" items="${administrativeUnitList}">
                                    <option value="${unit.provinceName}" data-region="${unit.regionGroup}" ${tour.endPlace == unit.provinceName ? 'selected' : ''}>${unit.provinceName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.endPlace}"><div class="field-error">${fieldErrors.endPlace}</div></c:if>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Mô tả ngắn</label>
                            <textarea name="tourIntroduce" class="form-control ${not empty fieldErrors.tourIntroduce ? 'is-invalid' : ''}" maxlength="5000" placeholder="Tóm tắt trải nghiệm, phong cách tour hoặc thông điệp ngắn hiển thị cho khách.">${tour.tourIntroduce}</textarea>
                            <c:if test="${not empty fieldErrors.tourIntroduce}"><div class="field-error">${fieldErrors.tourIntroduce}</div></c:if>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Điểm nổi bật của tour</label>
                            <textarea name="tourHighlights" class="form-control ${not empty fieldErrors.tourHighlights ? 'is-invalid' : ''}" maxlength="5000" placeholder="Ví dụ: Tham quan danh thắng nổi bật, khách sạn trung tâm, lịch trình tối ưu...">${tour.tourInclude}</textarea>
                            <c:if test="${not empty fieldErrors.tourHighlights}"><div class="field-error">${fieldErrors.tourHighlights}</div></c:if>
                        </div>
                        </div>
                    </div>

                </div>
            </section>

            <section class="page-card" id="itinerarySection">
                <div class="section-title">
                    <i class="fa-solid fa-route text-primary"></i>
                    <h5>2. Lịch trình từng ngày</h5>
                </div>
                <div class="section-body" id="itineraryContainer">
                    <c:if test="${not empty fieldErrors.itinerary}"><div class="field-error mb-3">${fieldErrors.itinerary}</div></c:if>
                    <c:forEach var="day" begin="1" end="${dayCount}">
                        <c:set var="itinerary" value="${itineraryMap[day]}" />
                        <div class="day-card" data-day="${day}">
                            <input type="hidden" name="existingItineraryImage_${day}" value="${itinerary.imageUrl}">
                            <span class="day-pill">Ngày ${day}</span>
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label">Tiêu đề ngày ${day} <span class="text-danger">*</span></label>
                                    <c:set var="titleErrorKey" value="itineraryTitle_${day}" />
                                    <input type="text" name="itineraryTitle_${day}" class="form-control itinerary-title ${activeTourContentOnly ? 'locked' : ''} ${not empty fieldErrors[titleErrorKey] ? 'is-invalid' : ''}" value="${itinerary.title}" required maxlength="255" ${activeTourContentOnly ? 'readonly' : ''}>
                                    <c:if test="${not empty fieldErrors[titleErrorKey]}"><div class="field-error">${fieldErrors[titleErrorKey]}</div></c:if>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Ảnh mô tả ngày ${day}</label>
                                    <c:set var="imageErrorKey" value="itineraryImage_${day}" />
                                    <input type="file" name="itineraryImageFile_${day}" class="form-control image-input ${not empty fieldErrors[imageErrorKey] ? 'is-invalid' : ''}" accept="image/*" data-preview="itineraryPreview_${day}">
                                    <input type="url" name="itineraryImageUrl_${day}" class="form-control mt-2 image-url-input ${not empty fieldErrors[imageErrorKey] ? 'is-invalid' : ''}" data-preview="itineraryPreview_${day}" placeholder="Hoặc URL ảnh https://...">
                                    <c:if test="${not empty fieldErrors[imageErrorKey]}"><div class="field-error">${fieldErrors[imageErrorKey]}</div></c:if>
                                </div>
                                <div class="col-md-8">
                                    <label class="form-label">Mô tả lịch trình ngày ${day}</label>
                                    <c:set var="descriptionErrorKey" value="itineraryDescription_${day}" />
                                    <textarea name="itineraryDescription_${day}" class="form-control itinerary-description ${activeTourContentOnly ? 'locked' : ''} ${not empty fieldErrors[descriptionErrorKey] ? 'is-invalid' : ''}" maxlength="5000" placeholder="Mô tả hoạt động chính, thời gian, điểm tham quan, ăn uống, lưu trú nếu có..." ${activeTourContentOnly ? 'readonly' : ''}>${itinerary.description}</textarea>
                                    <c:if test="${not empty fieldErrors[descriptionErrorKey]}"><div class="field-error">${fieldErrors[descriptionErrorKey]}</div></c:if>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Xem trước ảnh ngày ${day}</label>
                                    <c:choose>
                                        <c:when test="${not empty itinerary.imageUrl}">
                                            <c:set var="itineraryPreviewSrc" value="${itinerary.imageUrl}" />
                                            <c:if test="${not fn:startsWith(itineraryPreviewSrc, 'http://') and not fn:startsWith(itineraryPreviewSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(itineraryPreviewSrc, pageContext.request.contextPath))}">
                                                <c:set var="itineraryPreviewSrc" value="${pageContext.request.contextPath}${fn:startsWith(itineraryPreviewSrc, '/') ? '' : '/'}${itineraryPreviewSrc}" />
                                            </c:if>
                                            <img id="itineraryPreview_${day}" class="preview-small" src="${itineraryPreviewSrc}" alt="Ảnh ngày ${day}">
                                        </c:when>
                                        <c:otherwise><img id="itineraryPreview_${day}" class="preview-small" alt="Chưa chọn ảnh ngày ${day}"></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>

            <div class="d-flex gap-2 justify-content-end mb-4">
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour">Hủy</a>
                <button type="submit" class="btn-main"><i class="fa-solid fa-floppy-disk"></i> ${submitLabel}</button>
            </div>
        </form>
    </main>
</div>

<script>
(function () {
    const regionSelect = document.getElementById('regionSelect');
    const startSelect = document.getElementById('startPlaceSelect');
    const endSelect = document.getElementById('endPlaceSelect');
    const numberOfDay = document.getElementById('numberOfDay');
    const numberOfNights = document.getElementById('numberOfNights');
    const updateItineraryBtn = document.getElementById('updateItineraryBtn');
    const itineraryContainer = document.getElementById('itineraryContainer');
    const enhancedSelects = [];
    const tourForm = document.getElementById('tourForm');

    function refreshCustomSelect(select) {
        if (!select || !select._customSelect) return;
        const trigger = select._customSelect.trigger;
        const menu = select._customSelect.menu;
        const selected = select.options[select.selectedIndex];
        trigger.textContent = selected ? selected.textContent.trim() : '';
        trigger.classList.toggle('placeholder', !select.value);
        menu.querySelectorAll('.custom-select-option').forEach(function (item) {
            const option = select.options[parseInt(item.getAttribute('data-index') || '-1', 10)];
            const hidden = !option || option.hidden || option.disabled;
            item.hidden = hidden;
            item.classList.toggle('selected', !!option && option.selected);
        });
    }

    function refreshAllCustomSelects() {
        enhancedSelects.forEach(refreshCustomSelect);
    }

    function enhanceHoverSelect(select) {
        if (!select || select.disabled || select._customSelect) return;
        const wrapper = document.createElement('div');
        wrapper.className = 'custom-select-wrap';
        const trigger = document.createElement('div');
        trigger.className = 'custom-select-trigger';
        trigger.setAttribute('tabindex', '0');
        const menu = document.createElement('div');
        menu.className = 'custom-select-menu';

        Array.from(select.options).forEach(function (option, index) {
            const item = document.createElement('div');
            item.className = 'custom-select-option';
            item.setAttribute('data-index', index);
            item.textContent = option.textContent.trim();
            item.addEventListener('click', function () {
                if (option.disabled || option.hidden) return;
                select.value = option.value;
                select.dispatchEvent(new Event('change', { bubbles: true }));
                wrapper.classList.remove('open');
                refreshCustomSelect(select);
            });
            menu.appendChild(item);
        });

        select.parentNode.insertBefore(wrapper, select);
        wrapper.appendChild(select);
        wrapper.appendChild(trigger);
        wrapper.appendChild(menu);
        select.classList.add('custom-select-source');
        select._customSelect = { wrapper: wrapper, trigger: trigger, menu: menu };
        enhancedSelects.push(select);
        trigger.addEventListener('focus', function () { wrapper.classList.add('open'); });
        trigger.addEventListener('blur', function () { setTimeout(function () { wrapper.classList.remove('open'); }, 120); });
        select.addEventListener('change', function () { refreshCustomSelect(select); });
        refreshCustomSelect(select);
    }

    function getSelectedRegionName() {
        if (!regionSelect || regionSelect.selectedIndex < 0) return '';
        const option = regionSelect.options[regionSelect.selectedIndex];
        return option ? option.getAttribute('data-name') || option.textContent.trim() : '';
    }

    function syncPlace(select) {
        if (!select) return;
        const hidden = document.getElementById(select.getAttribute('data-hidden'));
        if (hidden) hidden.value = select.value || '';
    }

    function filterPlaces(resetValue) {
        const regionName = getSelectedRegionName();
        [startSelect, endSelect].forEach(function (select) {
            if (!select) return;
            Array.from(select.options).forEach(function (option) {
                const optionRegion = option.getAttribute('data-region');
                option.hidden = !!optionRegion && !!regionName && optionRegion !== regionName;
            });
            if (resetValue && select.selectedOptions[0] && select.selectedOptions[0].hidden) {
                select.value = '';
            }
            syncPlace(select);
            refreshCustomSelect(select);
        });
    }

    function attachImageEvents(scope) {
        (scope || document).querySelectorAll('.image-input').forEach(function (input) {
            input.onchange = function () {
                const preview = document.getElementById(input.getAttribute('data-preview'));
                if (!preview || !input.files || !input.files[0]) return;
                const reader = new FileReader();
                reader.onload = function (event) { preview.src = event.target.result; };
                reader.readAsDataURL(input.files[0]);
            };
        });

        (scope || document).querySelectorAll('.image-url-input').forEach(function (input) {
            input.onchange = function () {
                const preview = document.getElementById(input.getAttribute('data-preview'));
                if (preview && input.value.trim()) preview.src = input.value.trim();
            };
        });
    }

    function escapeHtml(value) {
        return String(value || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function resolveAssetUrl(value) {
        const path = String(value || '').trim();
        if (!path || /^https?:\/\//i.test(path)) return path;
        const contextPath = '${pageContext.request.contextPath}';
        if (contextPath && path.indexOf(contextPath) === 0) return path;
        return contextPath + (path.charAt(0) === '/' ? '' : '/') + path;
    }

    function collectItineraryValues() {
        const result = {};
        if (!itineraryContainer) return result;
        itineraryContainer.querySelectorAll('.day-card').forEach(function (card) {
            const day = parseInt(card.getAttribute('data-day') || '0', 10);
            if (!day) return;
            const title = card.querySelector('[name="itineraryTitle_' + day + '"]');
            const description = card.querySelector('[name="itineraryDescription_' + day + '"]');
            const imageUrl = card.querySelector('[name="itineraryImageUrl_' + day + '"]');
            const existingImage = card.querySelector('[name="existingItineraryImage_' + day + '"]');
            const preview = document.getElementById('itineraryPreview_' + day);
            result[day] = {
                title: title ? title.value : '',
                description: description ? description.value : '',
                imageUrl: imageUrl ? imageUrl.value : '',
                existingImage: existingImage ? existingImage.value : '',
                previewSrc: preview ? (preview.getAttribute('src') || '') : ''
            };
        });
        return result;
    }

    function buildDayCard(day, data) {
        data = data || {};
        const previewSrc = resolveAssetUrl(data.previewSrc || data.existingImage || '');
        return '' +
            '<div class="day-card" data-day="' + day + '">' +
            '<input type="hidden" name="existingItineraryImage_' + day + '" value="' + escapeHtml(data.existingImage || '') + '">' +
            '<span class="day-pill">Ngày ' + day + '</span>' +
            '<div class="row g-3">' +
            '<div class="col-md-8">' +
            '<label class="form-label">Tiêu đề ngày ' + day + ' <span class="text-danger">*</span></label>' +
            '<input type="text" name="itineraryTitle_' + day + '" class="form-control itinerary-title" value="' + escapeHtml(data.title || '') + '" required maxlength="255">' +
            '</div>' +
            '<div class="col-md-4">' +
            '<label class="form-label">Ảnh mô tả ngày ' + day + '</label>' +
            '<input type="file" name="itineraryImageFile_' + day + '" class="form-control image-input" accept="image/*" data-preview="itineraryPreview_' + day + '">' +
            '<input type="url" name="itineraryImageUrl_' + day + '" class="form-control mt-2 image-url-input" data-preview="itineraryPreview_' + day + '" value="' + escapeHtml(data.imageUrl || '') + '" placeholder="Hoặc URL ảnh https://...">' +
            '</div>' +
            '<div class="col-md-8">' +
            '<label class="form-label">Mô tả lịch trình ngày ' + day + '</label>' +
            '<textarea name="itineraryDescription_' + day + '" class="form-control itinerary-description" maxlength="5000" placeholder="Mô tả hoạt động chính, thời gian, điểm tham quan, ăn uống, lưu trú nếu có...">' + escapeHtml(data.description || '') + '</textarea>' +
            '</div>' +
            '<div class="col-md-4">' +
            '<label class="form-label">Xem trước ảnh ngày ' + day + '</label>' +
            '<img id="itineraryPreview_' + day + '" class="preview-small" ' + (previewSrc ? 'src="' + escapeHtml(previewSrc) + '" ' : '') + 'alt="Chưa chọn ảnh ngày ' + day + '">' +
            '</div>' +
            '</div>' +
            '</div>';
    }

    function renderItineraryDays(scrollToSection) {
        if (!itineraryContainer || !numberOfDay) return;
        let days = parseInt(numberOfDay.value || '1', 10);
        if (!days || days < 1) days = 1;
        if (days > 15) days = 15;
        numberOfDay.value = days;
        const values = collectItineraryValues();
        let html = '';
        for (let day = 1; day <= days; day++) {
            html += buildDayCard(day, values[day]);
        }
        itineraryContainer.innerHTML = html;
        attachImageEvents(itineraryContainer);
        if (scrollToSection) {
            document.getElementById('itinerarySection').scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    function syncNightLimit() {
        if (!numberOfDay || !numberOfNights) return;
        const days = parseInt(numberOfDay.value || '0', 10);
        const nights = parseInt(numberOfNights.value || '0', 10);
        if (days > 0) {
            numberOfNights.max = String(Math.min(15, days));
        }
        if (days > 0 && nights > days) {
            numberOfNights.setCustomValidity('Số đêm không được lớn hơn số ngày của tour.');
        } else {
            numberOfNights.setCustomValidity('');
        }
    }

    document.querySelectorAll('.place-select').forEach(function (select) {
        select.addEventListener('change', function () { syncPlace(select); });
        syncPlace(select);
    });

    document.querySelectorAll('select.form-select').forEach(enhanceHoverSelect);

    if (regionSelect) regionSelect.addEventListener('change', function () { filterPlaces(true); });
    if (updateItineraryBtn) updateItineraryBtn.addEventListener('click', function () { renderItineraryDays(true); });

    if (numberOfDay) {
        numberOfDay.addEventListener('change', function () {
            const days = parseInt(numberOfDay.value || '1', 10);
            if (days > 0) {
                numberOfDay.value = Math.min(15, Math.max(1, days));
            }
            syncNightLimit();
        });
    }
    if (numberOfNights) numberOfNights.addEventListener('input', syncNightLimit);

    if (tourForm) {
        tourForm.addEventListener('submit', function (event) {
            syncNightLimit();
            if (numberOfNights && !numberOfNights.checkValidity()) {
                event.preventDefault();
                numberOfNights.reportValidity();
                return;
            }
            if (tourForm.dataset.confirmed === 'true') return;
            const message = 'Bạn đã kiểm tra kỹ thông tin tour và chắc chắn muốn lưu không?';
            if (!window.confirm(message)) {
                event.preventDefault();
                return;
            }
            tourForm.dataset.confirmed = 'true';
        });
    }

    filterPlaces(false);
    syncNightLimit();
    refreshAllCustomSelects();
    attachImageEvents(document);
})();
</script>
</body>
</html>
