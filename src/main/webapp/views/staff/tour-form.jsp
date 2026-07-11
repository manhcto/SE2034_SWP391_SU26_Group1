<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        .page-card { background:#fff; border:1px solid var(--border); border-radius:24px; box-shadow:var(--shadow); margin-bottom:22px; overflow:hidden; }
        .topbar { padding:24px; display:flex; align-items:center; justify-content:space-between; gap:18px; }
        .topbar h1 { margin:0; color:var(--dark); font-size:28px; font-weight:900; }
        .topbar p { margin:6px 0 0; color:var(--muted); font-weight:600; }
        .section-title { padding:20px 22px; border-bottom:1px solid var(--border); display:flex; align-items:center; gap:12px; }
        .section-title h5 { margin:0; font-weight:900; color:var(--dark); }
        .section-body { padding:22px; }
        .form-label { font-weight:800; color:#334155; }
        .form-control,.form-select { border-radius:13px; border:1px solid #dbe3ef; min-height:46px; }
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
        .preview-small { width:100%; max-height:160px; object-fit:cover; border-radius:14px; border:1px solid var(--border); background:#f8fafc; }
        .muted { color:var(--muted); }
        .table thead th { background:#f8fafc; color:#475569; font-size:13px; text-transform:uppercase; letter-spacing:.04em; border-bottom:1px solid var(--border); }
        .table td,.table th { vertical-align:middle; padding:14px 16px; }
        .field-error { color:#dc2626; font-size:13px; font-weight:700; margin-top:6px; }
        .is-invalid { border-color:#dc2626 !important; }
        @media (max-width:992px) { .admin-layout{display:block;} .admin-main{padding:18px;} .topbar{display:block;} }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp" />

    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>${pageTitle}</h1>
                <p>Staff nhập tour gốc, ảnh, thông tin tập trung, lịch trình và lịch khởi hành đầu tiên.</p>
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
                Tour đang ở trạng thái ${tour.displayStatus}. Staff chỉ được bổ sung/chỉnh nội dung mô tả, ảnh, điểm nổi bật và lịch trình. Giá, tuyến, thời lượng, phương tiện và lịch khởi hành đang được khóa để tránh sai lệch dữ liệu bán tour.
            </div>
        </c:if>

        <form method="post" action="${formAction}" enctype="multipart/form-data" id="tourForm" novalidate>
            <c:if test="${mode == 'edit'}"><input type="hidden" name="tourID" value="${tour.tourID}"></c:if>
            <input type="hidden" name="existingImage" value="${tour.image}">
            <input type="hidden" name="existingIntroImage" value="${tour.introImage}">
            <input type="hidden" name="startPlace" id="startPlace" value="${tour.startPlace}">
            <input type="hidden" name="endPlace" id="endPlace" value="${tour.endPlace}">

            <section class="page-card">
                <div class="section-title">
                    <i class="fa-solid fa-circle-info text-primary"></i>
                    <h5>1. Thông tin tour, ảnh và tập trung</h5>
                </div>
                <div class="section-body">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label">Tên tour <span class="text-danger">*</span></label>
                            <input type="text" name="tourName" class="form-control ${not empty fieldErrors.tourName ? 'is-invalid' : ''}" value="${tour.tourName}" required maxlength="255" minlength="5">
                            <c:if test="${not empty fieldErrors.tourName}"><div class="field-error">${fieldErrors.tourName}</div></c:if>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Mã tour</label>
                            <input type="text" class="form-control" value="${empty tour.tourCode ? nextTourCode : tour.tourCode}" readonly>
                            <div class="form-text">Mã dự kiến sẽ được kiểm tra lại khi lưu để tránh trùng.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <select name="tourCategoryID" class="form-select ${not empty fieldErrors.tourCategoryID ? 'is-invalid' : ''}" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${category.tourCategoryID}" ${tour.tourCategoryID == category.tourCategoryID ? 'selected' : ''}>${category.categoryName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.tourCategoryID}"><div class="field-error">${fieldErrors.tourCategoryID}</div></c:if>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Loại tour <span class="text-danger">*</span></label>
                            <select name="tourType" class="form-select ${not empty fieldErrors.tourType ? 'is-invalid' : ''}" required>
                                <option value="Package" ${tour.tourType == 'Package' ? 'selected' : ''}>Tour trọn gói</option>
                                <option value="Private" ${tour.tourType == 'Private' ? 'selected' : ''}>Tour riêng</option>
                                <option value="Combo" ${tour.tourType == 'Combo' ? 'selected' : ''}>Combo</option>
                            </select>
                            <c:if test="${not empty fieldErrors.tourType}"><div class="field-error">${fieldErrors.tourType}</div></c:if>
                        </div>
                        <div class="col-md-4">
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

                        <div class="col-md-3">
                            <label class="form-label">Số ngày <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="numberOfDay" id="numberOfDay" min="1" max="15" class="form-control ${not empty fieldErrors.numberOfDay ? 'is-invalid' : ''}" value="${dayCount}" required ${routeAndScheduleInfoLocked ? 'readonly' : ''}>
                                <button type="button" id="updateItineraryBtn" class="btn-icon" title="Cập nhật lịch trình từng ngày" ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                    <i class="fa-solid fa-rotate"></i>
                                </button>
                            </div>
                            <c:if test="${not empty fieldErrors.numberOfDay}"><div class="field-error">${fieldErrors.numberOfDay}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số đêm <span class="text-danger">*</span></label>
                            <input type="number" name="numberOfNights" id="numberOfNights" min="0" max="15" class="form-control ${not empty fieldErrors.numberOfNights ? 'is-invalid' : ''}" value="${empty tour.numberOfNights ? 0 : tour.numberOfNights}" required ${routeAndScheduleInfoLocked ? 'readonly' : ''}>
                            <c:if test="${not empty fieldErrors.numberOfNights}"><div class="field-error">${fieldErrors.numberOfNights}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <input type="hidden" name="status" value="${mode == 'add' ? 'Draft' : tour.status}">
                            <input type="text" class="form-control" value="${mode == 'add' ? 'Bản nháp' : tour.displayStatus}" readonly>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <div class="form-check fw-bold">
                                <input class="form-check-input" type="checkbox" name="featured" value="true" id="featured" ${tour.featured ? 'checked' : ''}>
                                <label class="form-check-label" for="featured">Tour nổi bật</label>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Điểm khởi hành <span class="text-danger">*</span></label>
                            <select id="startPlaceSelect" class="form-select place-select ${not empty fieldErrors.startPlace ? 'is-invalid' : ''}" data-hidden="startPlace" data-current="${tour.startPlace}" required ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                <option value="">-- Chọn tỉnh/thành --</option>
                                <c:forEach var="unit" items="${administrativeUnitList}">
                                    <option value="${unit.provinceName}" data-region="${unit.regionGroup}" ${tour.startPlace == unit.provinceName ? 'selected' : ''}>${unit.provinceName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.startPlace}"><div class="field-error">${fieldErrors.startPlace}</div></c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Điểm đến <span class="text-danger">*</span></label>
                            <select id="endPlaceSelect" class="form-select place-select ${not empty fieldErrors.endPlace ? 'is-invalid' : ''}" data-hidden="endPlace" data-current="${tour.endPlace}" required ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                <option value="">-- Chọn tỉnh/thành --</option>
                                <c:forEach var="unit" items="${administrativeUnitList}">
                                    <option value="${unit.provinceName}" data-region="${unit.regionGroup}" ${tour.endPlace == unit.provinceName ? 'selected' : ''}>${unit.provinceName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty fieldErrors.endPlace}"><div class="field-error">${fieldErrors.endPlace}</div></c:if>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Phương tiện chính <span class="text-danger">*</span></label>
                            <c:if test="${routeAndScheduleInfoLocked}"><input type="hidden" name="mainTransportType" value="${tour.mainTransportType}"></c:if>
                            <select name="${routeAndScheduleInfoLocked ? 'mainTransportTypeDisplay' : 'mainTransportType'}" id="mainTransportType" class="form-select ${not empty fieldErrors.mainTransportType ? 'is-invalid' : ''}" required ${routeAndScheduleInfoLocked ? 'disabled' : ''}>
                                <option value="Xe Du Lịch" ${tour.mainTransportType == 'Xe Du Lịch' ? 'selected' : ''}>Xe Du Lịch</option>
                                <option value="Xe Khách" ${tour.mainTransportType == 'Xe Khách' ? 'selected' : ''}>Xe Khách</option>
                                <option value="Xe Giường nằm" ${tour.mainTransportType == 'Xe Giường nằm' ? 'selected' : ''}>Xe Giường nằm</option>
                                <option value="Toa tàu hỏa" ${tour.mainTransportType == 'Toa tàu hỏa' ? 'selected' : ''}>Toa tàu hỏa</option>
                            </select>
                            <c:if test="${not empty fieldErrors.mainTransportType}"><div class="field-error">${fieldErrors.mainTransportType}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số ghế / khách tối đa <span class="text-danger">*</span></label>
                            <select name="maxParticipants" id="maxParticipants" class="form-select ${not empty fieldErrors.maxParticipants ? 'is-invalid' : ''}" data-current="${empty initialSchedule ? '' : initialSchedule.maxParticipants}" ${mode == 'edit' ? 'disabled' : 'required'}>
                                <option value="">-- Chọn số ghế --</option>
                            </select>
                            <c:if test="${mode == 'edit'}"><div class="form-text">Sửa lịch khởi hành nên làm ở luồng Schedule riêng.</div></c:if>
                            <c:if test="${not empty fieldErrors.maxParticipants}"><div class="field-error">${fieldErrors.maxParticipants}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số khách tối thiểu</label>
                            <input type="text" id="minParticipantsPreview" class="form-control" value="" readonly>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label">Địa chỉ tập trung</label>
                            <input type="text" name="pickupAddress" class="form-control ${not empty fieldErrors.pickupAddress ? 'is-invalid' : ''}" value="${tour.pickupAddress}" maxlength="500" placeholder="Ví dụ: Cổng chính Nhà hát lớn Hà Nội">
                            <c:if test="${not empty fieldErrors.pickupAddress}"><div class="field-error">${fieldErrors.pickupAddress}</div></c:if>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Điểm nổi bật của tour</label>
                            <textarea name="tourHighlights" class="form-control ${not empty fieldErrors.tourHighlights ? 'is-invalid' : ''}" maxlength="5000" placeholder="Ví dụ: Tham quan danh thắng nổi bật, khách sạn trung tâm, lịch trình tối ưu...">${tour.tourInclude}</textarea>
                            <c:if test="${not empty fieldErrors.tourHighlights}"><div class="field-error">${fieldErrors.tourHighlights}</div></c:if>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Ảnh bìa tour</label>
                            <input type="file" name="coverImageFile" class="form-control image-input ${not empty fieldErrors.coverImage ? 'is-invalid' : ''}" accept="image/*" data-preview="coverPreview">
                            <input type="url" name="coverImageUrl" class="form-control mt-2 image-url-input ${not empty fieldErrors.coverImage ? 'is-invalid' : ''}" data-preview="coverPreview" placeholder="Hoặc dán URL ảnh bìa https://...">
                            <c:if test="${not empty fieldErrors.coverImage}"><div class="field-error">${fieldErrors.coverImage}</div></c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Xem trước ảnh bìa</label>
                            <c:choose>
                                <c:when test="${not empty tour.image}"><img id="coverPreview" class="preview-img" src="${tour.image}" alt="Ảnh bìa"></c:when>
                                <c:otherwise><img id="coverPreview" class="preview-img" alt="Chưa chọn ảnh bìa"></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ảnh giới thiệu</label>
                            <input type="file" name="introImageFile" class="form-control image-input ${not empty fieldErrors.introImage ? 'is-invalid' : ''}" accept="image/*" data-preview="introPreview">
                            <input type="url" name="introImageUrl" class="form-control mt-2 image-url-input ${not empty fieldErrors.introImage ? 'is-invalid' : ''}" data-preview="introPreview" placeholder="Hoặc dán URL ảnh giới thiệu https://...">
                            <c:if test="${not empty fieldErrors.introImage}"><div class="field-error">${fieldErrors.introImage}</div></c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Xem trước ảnh giới thiệu</label>
                            <c:choose>
                                <c:when test="${not empty tour.introImage}"><img id="introPreview" class="preview-img" src="${tour.introImage}" alt="Ảnh giới thiệu"></c:when>
                                <c:otherwise><img id="introPreview" class="preview-img" alt="Chưa chọn ảnh giới thiệu"></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </section>

            <section class="page-card">
                <div class="section-title">
                    <i class="fa-solid fa-money-bill-wave text-primary"></i>
                    <h5>2. Giá và chính sách cơ bản</h5>
                </div>
                <div class="section-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Giá người lớn <span class="text-danger">*</span></label>
                            <input type="number" name="adultPrice" id="adultPrice" min="500001" step="1" class="form-control ${not empty fieldErrors.adultPrice ? 'is-invalid' : ''}" value="${tour.adultPrice}" required ${priceAndScheduleLocked ? 'readonly' : ''}>
                            <div class="form-text"><c:choose><c:when test="${priceAndScheduleLocked}">Giá đang khóa ở trạng thái hiện tại.</c:when><c:otherwise>Giá phải lớn hơn 500.000 đ.</c:otherwise></c:choose></div>
                            <c:if test="${not empty fieldErrors.adultPrice}"><div class="field-error">${fieldErrors.adultPrice}</div></c:if>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Trẻ em 5–10 tuổi</label>
                            <input type="text" id="childPricePreview" class="form-control" value="" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Trẻ em dưới 5 tuổi <small class="text-muted">(trẻ thứ 2)</small></label>
                            <input type="text" id="infantPricePreview" class="form-control" value="" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Trẻ em từ 10 tuổi</label>
                            <input type="text" id="adultVatPreview" class="form-control" value="" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">VAT</label>
                            <input type="text" class="form-control" value="8%" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phụ thu phòng đơn <span class="text-danger">*</span></label>
                            <input type="number" name="singleRoomSurcharge" min="0" step="1" class="form-control ${not empty fieldErrors.singleRoomSurcharge ? 'is-invalid' : ''}" value="${tour.singleRoomSurcharge}" required ${priceAndScheduleLocked ? 'readonly' : ''}>
                            <c:if test="${not empty fieldErrors.singleRoomSurcharge}"><div class="field-error">${fieldErrors.singleRoomSurcharge}</div></c:if>
                        </div>
                    </div>
                </div>
            </section>

            <c:if test="${mode == 'add'}">
                <section class="page-card">
                    <div class="section-title">
                        <i class="fa-solid fa-calendar-check text-primary"></i>
                        <h5>3. Lịch khởi hành đầu tiên</h5>
                    </div>
                    <div class="section-body">
                        <div class="hint-box mb-3">Lịch này dùng để mở bán ban đầu. Sau khi lưu tour, các lịch khác nên triển khai ở luồng Schedule riêng để giá theo tháng/ngày không làm AddTour bị phình to.</div>
                        <fmt:formatDate value="${initialSchedule.startDate}" pattern="yyyy-MM-dd" var="scheduleStartDateValue" />
                        <fmt:formatDate value="${initialSchedule.endDate}" pattern="yyyy-MM-dd" var="scheduleEndDateValue" />
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Ngày xuất phát <span class="text-danger">*</span></label>
                                <input type="date" name="scheduleStartDate" id="scheduleStartDate" class="form-control ${not empty fieldErrors.scheduleStartDate ? 'is-invalid' : ''}" value="${scheduleStartDateValue}" required>
                                <c:if test="${not empty fieldErrors.scheduleStartDate}"><div class="field-error">${fieldErrors.scheduleStartDate}</div></c:if>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                <input type="date" name="scheduleEndDate" id="scheduleEndDate" class="form-control ${not empty fieldErrors.scheduleEndDate ? 'is-invalid' : ''}" value="${scheduleEndDateValue}" required>
                                <c:if test="${not empty fieldErrors.scheduleEndDate}"><div class="field-error">${fieldErrors.scheduleEndDate}</div></c:if>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giờ xuất phát</label>
                                <input type="time" name="departureTime" class="form-control ${not empty fieldErrors.departureTime ? 'is-invalid' : ''}" value="${initialSchedule.departureTime}">
                                <c:if test="${not empty fieldErrors.departureTime}"><div class="field-error">${fieldErrors.departureTime}</div></c:if>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giờ về dự kiến</label>
                                <input type="time" name="expectedReturnTime" class="form-control ${not empty fieldErrors.expectedReturnTime ? 'is-invalid' : ''}" value="${initialSchedule.expectedReturnTime}">
                                <c:if test="${not empty fieldErrors.expectedReturnTime}"><div class="field-error">${fieldErrors.expectedReturnTime}</div></c:if>
                            </div>
                        </div>
                    </div>
                </section>
            </c:if>

            <c:if test="${mode == 'edit'}">
                <section class="page-card">
                    <div class="section-title">
                        <i class="fa-solid fa-calendar-check text-primary"></i>
                        <h5>3. Lịch khởi hành hiện có</h5>
                    </div>
                    <c:choose>
                        <c:when test="${empty tour.scheduleList}">
                            <div class="section-body"><p class="muted mb-0">Tour chưa có lịch khởi hành.</p></div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead><tr><th>Ngày đi</th><th>Ngày về</th><th>Giá người lớn</th><th>Đã đặt/Tối đa</th><th>Trạng thái</th></tr></thead>
                                    <tbody>
                                    <c:forEach var="schedule" items="${tour.scheduleList}">
                                        <tr>
                                            <td><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatNumber value="${empty schedule.adultPrice ? tour.adultPrice : schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                            <td>${schedule.quantity}/${schedule.maxParticipants}</td>
                                            <td>${schedule.scheduleStatus}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </c:if>

            <section class="page-card" id="itinerarySection">
                <div class="section-title">
                    <i class="fa-solid fa-route text-primary"></i>
                    <h5>4. Lịch trình từng ngày</h5>
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
                                    <input type="text" name="itineraryTitle_${day}" class="form-control itinerary-title ${not empty fieldErrors[titleErrorKey] ? 'is-invalid' : ''}" value="${itinerary.title}" required maxlength="255">
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
                                    <textarea name="itineraryDescription_${day}" class="form-control itinerary-description ${not empty fieldErrors[descriptionErrorKey] ? 'is-invalid' : ''}" maxlength="5000" placeholder="Mô tả hoạt động chính, thời gian, điểm tham quan, ăn uống, lưu trú nếu có...">${itinerary.description}</textarea>
                                    <c:if test="${not empty fieldErrors[descriptionErrorKey]}"><div class="field-error">${fieldErrors[descriptionErrorKey]}</div></c:if>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Xem trước ảnh ngày ${day}</label>
                                    <c:choose>
                                        <c:when test="${not empty itinerary.imageUrl}"><img id="itineraryPreview_${day}" class="preview-small" src="${itinerary.imageUrl}" alt="Ảnh ngày ${day}"></c:when>
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
    const transportSeats = {
        'Xe Du Lịch': [4, 7, 16, 29, 45],
        'Xe Khách': [29, 35, 45, 50],
        'Xe Giường nằm': [34, 40, 44],
        'Toa tàu hỏa': [56, 64, 80]
    };

    const regionSelect = document.getElementById('regionSelect');
    const startSelect = document.getElementById('startPlaceSelect');
    const endSelect = document.getElementById('endPlaceSelect');
    const transportSelect = document.getElementById('mainTransportType');
    const seatSelect = document.getElementById('maxParticipants');
    const minPreview = document.getElementById('minParticipantsPreview');
    const numberOfDay = document.getElementById('numberOfDay');
    const numberOfNights = document.getElementById('numberOfNights');
    const updateItineraryBtn = document.getElementById('updateItineraryBtn');
    const itineraryContainer = document.getElementById('itineraryContainer');

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
        });
    }

    function updateSeatOptions() {
        if (!seatSelect || !transportSelect) return;
        const current = seatSelect.value || seatSelect.getAttribute('data-current') || '';
        const seats = transportSeats[transportSelect.value] || [];
        seatSelect.innerHTML = '<option value="">-- Chọn số ghế --</option>';
        seats.forEach(function (seat) {
            const option = document.createElement('option');
            option.value = seat;
            option.textContent = seat + ' ghế';
            if (String(seat) === current) option.selected = true;
            seatSelect.appendChild(option);
        });
        updateMinPreview();
    }

    function updateMinPreview() {
        if (!minPreview || !seatSelect) return;
        const max = parseInt(seatSelect.value || '0', 10);
        minPreview.value = max > 0 ? Math.ceil(max * 0.5) + ' khách' : '';
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
        const previewSrc = data.previewSrc || data.existingImage || '';
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
        updateEndDateByDayCount();
        if (scrollToSection) {
            document.getElementById('itinerarySection').scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    document.querySelectorAll('.place-select').forEach(function (select) {
        select.addEventListener('change', function () { syncPlace(select); });
        syncPlace(select);
    });

    if (regionSelect) regionSelect.addEventListener('change', function () { filterPlaces(true); });
    if (transportSelect) transportSelect.addEventListener('change', updateSeatOptions);
    if (seatSelect) seatSelect.addEventListener('change', updateMinPreview);
    if (updateItineraryBtn) updateItineraryBtn.addEventListener('click', function () { renderItineraryDays(true); });

    const adultPriceInput = document.getElementById('adultPrice');
    const childPricePreview = document.getElementById('childPricePreview');
    const infantPricePreview = document.getElementById('infantPricePreview');
    const adultVatPreview = document.getElementById('adultVatPreview');

    function formatVnd(value) {
        return Math.round(value || 0).toLocaleString('vi-VN') + ' đ';
    }

    function updatePricePreview() {
        const adultPrice = parseFloat((adultPriceInput && adultPriceInput.value) || '0');
        if (childPricePreview) childPricePreview.value = adultPrice > 0 ? formatVnd(adultPrice * 0.75 * 1.08) : '';
        if (infantPricePreview) infantPricePreview.value = adultPrice > 0 ? formatVnd(adultPrice * 0.50 * 1.08) : '';
        if (adultVatPreview) adultVatPreview.value = adultPrice > 0 ? formatVnd(adultPrice) : '';
    }

    if (adultPriceInput) adultPriceInput.addEventListener('input', updatePricePreview);

    const scheduleStartDate = document.getElementById('scheduleStartDate');
    const scheduleEndDate = document.getElementById('scheduleEndDate');

    function formatDateInput(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    function updateDateLimits() {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const todayText = formatDateInput(today);
        if (scheduleStartDate) scheduleStartDate.min = todayText;
        if (scheduleEndDate) scheduleEndDate.min = todayText;
    }

    function updateEndDateByDayCount() {
        if (!scheduleStartDate || !scheduleEndDate || !scheduleStartDate.value) return;
        const days = parseInt((numberOfDay && numberOfDay.value) || '1', 10);
        if (!days || days < 1) return;
        const start = new Date(scheduleStartDate.value + 'T00:00:00');
        if (isNaN(start.getTime())) return;
        start.setDate(start.getDate() + days - 1);
        scheduleEndDate.value = formatDateInput(start);
    }

    if (numberOfDay) {
        numberOfDay.addEventListener('change', function () {
            const days = parseInt(numberOfDay.value || '1', 10);
            if (days > 0) {
                updateEndDateByDayCount();
            }
        });
    }

    if (scheduleStartDate) scheduleStartDate.addEventListener('change', updateEndDateByDayCount);

    updateDateLimits();
    filterPlaces(false);
    updateSeatOptions();
    updatePricePreview();
    attachImageEvents(document);
})();
</script>
</body>
</html>
