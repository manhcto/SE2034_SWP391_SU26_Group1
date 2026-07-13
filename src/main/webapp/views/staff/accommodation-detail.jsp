<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết nơi lưu trú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --dark: #0f172a;
            --muted: #64748b;
            --bg: #f3f6fb;
            --border: #e2e8f0;
            --soft: #f8fafc;
            --danger: #dc2626;
            --success: #16a34a;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
            color: #1e293b;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            min-width: 0;
            padding: 28px;
        }

        .back-btn {
            border: 1px solid var(--border);
            background: white;
            border-radius: 999px;
            padding: 10px 16px;
            color: var(--dark);
            text-decoration: none;
            font-weight: 800;
            display: inline-flex;
            gap: 8px;
            align-items: center;
            margin-bottom: 18px;
            box-shadow: var(--shadow);
        }

        .back-btn:hover {
            background: #f8fafc;
            color: var(--primary);
        }

        .hero-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 26px;
            overflow: hidden;
            box-shadow: var(--shadow);
            margin-bottom: 24px;
        }

        .hero-img {
            width: 100%;
            height: 340px;
            object-fit: cover;
            background: #e2e8f0;
        }

        .hero-body {
            padding: 26px;
        }

        .hero-title {
            font-size: 32px;
            font-weight: 900;
            color: var(--dark);
            margin-bottom: 8px;
            letter-spacing: -0.4px;
        }

        .muted {
            color: var(--muted);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-top: 22px;
        }

        .info-card {
            background: var(--soft);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 16px;
        }

        .info-card i {
            color: var(--primary);
            font-size: 20px;
            margin-bottom: 10px;
        }

        .info-label {
            color: var(--muted);
            font-size: 12px;
            font-weight: 900;
            text-transform: uppercase;
        }

        .info-value {
            font-size: 16px;
            font-weight: 900;
            color: var(--dark);
            margin-top: 4px;
        }

        .section-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            box-shadow: var(--shadow);
            padding: 24px;
            margin-bottom: 24px;
        }

        .section-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .section-head h2 {
            font-size: 24px;
            font-weight: 900;
            color: var(--dark);
            margin: 0;
        }

        .btn-main {
            border: none;
            border-radius: 14px;
            background: var(--primary);
            color: white;
            padding: 11px 16px;
            font-weight: 800;
            display: inline-flex;
            gap: 8px;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-main:hover {
            background: var(--primary-dark);
            color: white;
        }

        .room-card {
            border: 1px solid var(--border);
            border-radius: 22px;
            overflow: hidden;
            background: white;
            height: 100%;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.05);
        }

        .room-img {
            height: 180px;
            width: 100%;
            object-fit: cover;
            background: #e2e8f0;
        }

        .room-body {
            padding: 18px;
        }

        .room-title {
            font-size: 20px;
            font-weight: 900;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .room-specs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 12px 0;
        }

        .pill {
            background: #eef2ff;
            color: #3730a3;
            border-radius: 999px;
            padding: 7px 10px;
            font-size: 12.5px;
            font-weight: 800;
        }

        .facility-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .facility-pill {
            background: #ecfeff;
            color: #155e75;
            border-radius: 999px;
            padding: 9px 12px;
            font-weight: 800;
            font-size: 13px;
        }

        .form-control,
        .form-select {
            border-radius: 13px;
            min-height: 46px;
            border: 1px solid #dbe3ef;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        textarea.form-control {
            min-height: 96px;
        }

        .modal-dialog {
            max-height: 94vh;
        }

        .modal-content {
            border: none;
            border-radius: 24px;
            overflow: hidden;
            max-height: 94vh;
        }

        .modal-header {
            flex-shrink: 0;
            background: #0f172a;
            color: white;
            border: none;
            padding: 20px 24px;
        }

        .modal-title {
            font-weight: 900;
        }

        .modal-header .btn-close {
            display: block !important;
            filter: invert(1) grayscale(100%) brightness(200%);
            opacity: 0.9;
        }

        .modal-header .btn-close:hover {
            opacity: 1;
        }

        .modal-body {
            padding: 24px;
            overflow-y: auto;
            max-height: calc(94vh - 145px);
        }

        .modal-footer {
            flex-shrink: 0;
            background: #ffffff;
            border-top: 1px solid #e2e8f0;
            padding: 16px 24px;
        }

        .modal-footer .btn-light,
        .modal-footer [data-bs-dismiss="modal"] {
            display: none !important;
        }

        .facility-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
        }

        .facility-item {
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 10px 12px;
            background: var(--soft);
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #334155;
        }

        .facility-item input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--primary);
        }

        .facility-item i {
            color: var(--primary);
            min-width: 18px;
            text-align: center;
        }

        .facility-pill {
            background: #ecfeff;
            color: #155e75;
            border-radius: 999px;
            padding: 9px 12px;
            font-weight: 800;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }

        .facility-pill i {
            color: var(--primary);
        }

        .input-error {
            border-color: var(--danger) !important;
            box-shadow: 0 0 0 4px rgba(220, 38, 38, 0.10) !important;
        }

        .input-success {
            border-color: var(--success) !important;
            box-shadow: 0 0 0 4px rgba(22, 163, 74, 0.10) !important;
        }

        .live-error {
            display: block;
            color: var(--danger);
            font-size: 12.5px;
            font-weight: 700;
            margin-top: 6px;
        }

        @media (max-width: 992px) {
            .info-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .facility-list {
                grid-template-columns: repeat(2, 1fr);
            }

            .section-head {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 576px) {
            .admin-main {
                padding: 18px;
            }

            .info-grid,
            .facility-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <a class="back-btn" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại danh sách
        </a>

        <c:if test="${not empty sessionScope.errors}">
            <div class="alert alert-danger rounded-4 border-0 mb-4" role="alert">
                <strong>Dữ liệu nhập vào chưa hợp lệ</strong>
                <ul class="mb-0 mt-2">
                    <c:forEach var="err" items="${sessionScope.errors}">
                        <li><c:out value="${err}"/></li>
                    </c:forEach>
                </ul>
            </div>
            <c:remove var="errors" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.fieldErrors}">
            <div id="serverValidation" hidden
                 data-action="<c:out value='${sessionScope.formValues.action}'/>"
                 data-owner-id="<c:out value='${sessionScope.formValues.roomID}'/>">
                <c:forEach var="entry" items="${sessionScope.fieldErrors}">
                    <span data-field="<c:out value='${entry.key}'/>"
                          data-message="<c:out value='${entry.value}'/>"></span>
                </c:forEach>
                <c:forEach var="entry" items="${sessionScope.formValues}">
                    <span data-form-field="<c:out value='${entry.key}'/>"
                          data-value="<c:out value='${entry.value}'/>"></span>
                </c:forEach>
            </div>
            <c:remove var="fieldErrors" scope="session"/>
            <c:remove var="formValues" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${param.status == 'addRoomSuccess' || param.status == 'updateRoomSuccess' || param.status == 'deleteRoomSuccess' || param.status == 'deactivateRoomSuccess' || param.status == 'facilitySuccess' || param.status == 'roomFacilitySuccess'}">
                <div class="alert alert-success rounded-4 border-0 mb-4" role="status">
                    <c:choose>
                        <c:when test="${param.status == 'addRoomSuccess'}">Đã thêm phòng và tiện ích.</c:when>
                        <c:when test="${param.status == 'updateRoomSuccess'}">Đã cập nhật phòng và tiện ích.</c:when>
                        <c:when test="${param.status == 'deleteRoomSuccess'}">Đã xóa phòng.</c:when>
                        <c:when test="${param.status == 'deactivateRoomSuccess'}">Phòng đã có booking nên hệ thống đã chuyển sang ngừng hoạt động.</c:when>
                        <c:otherwise>Đã cập nhật tiện ích.</c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:when test="${param.status == 'addRoomFail' || param.status == 'updateRoomFail' || param.status == 'deleteRoomFail' || param.status == 'facilityFail' || param.status == 'roomFacilityFail'}">
                <div class="alert alert-danger rounded-4 border-0 mb-4" role="alert">Không thể hoàn tất thao tác. Vui lòng kiểm tra dữ liệu và thử lại.</div>
            </c:when>
        </c:choose>

        <article class="hero-card">
            <img class="hero-img" src="${fn:escapeXml(accommodation.image)}" alt="${fn:escapeXml(accommodation.name)}"
                 onerror="this.src='https://placehold.co/1200x600?text=WonderVN+Accommodation';">

            <div class="hero-body">
                <h1 class="hero-title"><c:out value="${accommodation.name}"/></h1>

                <div class="muted">
                    <i class="fa-solid fa-location-dot text-info me-1"></i>
                    <c:out value="${accommodation.fullAddress}"/>
                </div>

                <p class="mt-3 mb-0"><c:out value="${accommodation.description}"/></p>

                <div class="info-grid">
                    <div class="info-card">
                        <i class="fa-solid fa-hotel"></i>
                        <div class="info-label">Loại lưu trú</div>
<div class="info-value"><c:out value="${accommodation.displayType}"/></div>
                    </div>

                    <div class="info-card">
                        <i class="fa-solid fa-star"></i>
                        <div class="info-label">Đánh giá</div>
                        <div class="info-value">${accommodation.rate}/5</div>
                    </div>

                    <div class="info-card">
                        <i class="fa-solid fa-clock"></i>
                        <div class="info-label">Nhận / trả phòng</div>
                        <div class="info-value">${accommodation.checkInText} - ${accommodation.checkOutText}</div>
                    </div>

                    <div class="info-card">
                        <i class="fa-solid fa-phone"></i>
                        <div class="info-label">Liên hệ</div>
<div class="info-value"><c:out value="${accommodation.phone}"/></div>
                    </div>
                </div>
            </div>
        </article>

        <div class="section-card">
            <div class="section-head">
                <h2>Tiện ích nơi lưu trú</h2>

                <button class="btn-main" type="button" data-bs-toggle="modal" data-bs-target="#accommodationFacilityModal">
                    <i class="fa-solid fa-pen"></i>
                    Cập nhật tiện ích
                </button>
            </div>

            <div class="facility-wrap">
                <c:choose>
                    <c:when test="${empty accommodation.facilityList}">
                        <span class="text-muted">Chưa có tiện ích.</span>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="f" items="${accommodation.facilityList}">
    <span class="facility-pill">
<i class="fa-solid ${fn:escapeXml(f.icon)}"></i>
<c:out value="${f.facilityName}"/>
    </span>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="section-card">
            <div class="section-head">
                <h2>Danh sách phòng</h2>

                <button class="btn-main" type="button"
                        data-bs-toggle="modal" data-bs-target="#addRoomModal">
                    <i class="fa-solid fa-plus"></i>
                    Thêm phòng
                </button>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty roomList}">
                        <div class="col-12 text-center text-muted py-4">
                            Chưa có phòng.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="r" items="${roomList}">
                            <div class="col-xl-4 col-lg-6">
                                <div class="room-card">
<img class="room-img" src="${fn:escapeXml(r.image)}" alt="${fn:escapeXml(r.roomType)}"
                                         onerror="this.src='https://placehold.co/800x500?text=WonderVN+Room';">

                                    <div class="room-body">
<div class="room-title"><c:out value="${r.roomType}"/></div>

<div class="text-muted small"><c:out value="${r.description}"/></div>

                                        <div class="room-specs">
                                            <span class="pill">
                                                <i class="fa-solid fa-bed me-1"></i>
                                                ${r.bedCount} ${r.displayBedType}
                                            </span>

                                            <span class="pill">
                                                <i class="fa-solid fa-user me-1"></i>
                                                ${r.maxAdults} NL
                                            </span>

                                            <span class="pill">
                                                <i class="fa-solid fa-child me-1"></i>
                                                ${r.maxChildren} TE
                                            </span>

                                            <span class="pill">
                                                <i class="fa-solid fa-ruler-combined me-1"></i>
                                                ${r.roomSize} m²
                                            </span>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-end mt-3">
                                            <div>
                                                <div class="fw-bold fs-5">
                                                    <fmt:formatNumber value="${r.priceOfRoom}" type="number" maxFractionDigits="0"/> đ
                                                </div>

                                                <div class="text-muted small">
                                                    Còn ${r.roomAvailability}/${r.numberOfRooms} phòng
                                                </div>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-outline-primary" type="button"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#editRoomModal${r.roomID}">
                                                    Sửa
                                                </button>

                                                <form class="m-0 js-confirm-delete"
                                                      action="${pageContext.request.contextPath}/staff/accommodation"
                                                      method="post"
                                                      data-confirm-message="Bạn có chắc muốn xóa phòng này?">
                                                    <input type="hidden" name="action" value="deleteRoom">
                                                    <input type="hidden" name="roomID" value="${r.roomID}">
                                                    <input type="hidden" name="accommodationID"
                                                           value="${accommodation.accommodationID}">
                                                    <button class="btn btn-sm btn-outline-danger" type="submit">
                                                        Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal fade" id="editRoomModal${r.roomID}" tabindex="-1">
                                <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <form class="room-form"
                                              action="${pageContext.request.contextPath}/staff/accommodation"
                                              method="post"
                                              novalidate>
                                            <input type="hidden" name="action" value="updateRoom">
                                            <input type="hidden" name="roomID" value="${r.roomID}">
                                            <input type="hidden" name="accommodationID" value="${accommodation.accommodationID}">

                                            <div class="modal-header">
                                                <h5 class="modal-title">Cập nhật phòng</h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                        data-bs-dismiss="modal" aria-label="Đóng"></button>
                                            </div>

                                            <div class="modal-body">
                                                <div class="row g-3">
                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold">Loại phòng</label>
                                                        <input class="form-control" name="roomType" value="${fn:escapeXml(r.roomType)}" required>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold">Giá phòng</label>
                                                        <input class="form-control" type="number" min="1" step="1000" name="priceOfRoom" value="${r.priceOfRoom}" required>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold">Trạng thái</label>
                                                        <select class="form-select" name="status">
                                                            <option value="Available" ${r.status == 'Available' ? 'selected' : ''}>Còn phòng</option>
                                                            <option value="Unavailable" ${r.status == 'Unavailable' ? 'selected' : ''}>Hết phòng</option>
                                                            <option value="Maintenance" ${r.status == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                                                        </select>
                                                    </div>

                                                    <div class="col-md-3">
                                                        <label class="form-label fw-bold">Tổng số phòng</label>
                                                        <input class="form-control" type="number" min="0" name="numberOfRooms" value="${r.numberOfRooms}" required>
                                                    </div>

                                                    <div class="col-md-3">
                                                        <label class="form-label fw-bold">Phòng còn trống</label>
                                                        <input class="form-control" type="number" min="0" name="roomAvailability" value="${r.roomAvailability}" required>
                                                    </div>

                                                    <div class="col-md-3">
                                                        <label class="form-label fw-bold">Số giường</label>
                                                        <input class="form-control" type="number" min="1" max="20" name="bedCount" value="${r.bedCount}" required>
                                                    </div>

                                                    <div class="col-md-3">
                                                        <label class="form-label fw-bold">Loại giường</label>
                                                        <select class="form-select" name="bedType">
                                                            <option value="Single" ${r.bedType == 'Single' ? 'selected' : ''}>Giường đơn</option>
                                                            <option value="Double" ${r.bedType == 'Double' ? 'selected' : ''}>Giường đôi</option>
                                                            <option value="Queen" ${r.bedType == 'Queen' ? 'selected' : ''}>Queen</option>
                                                            <option value="King" ${r.bedType == 'King' ? 'selected' : ''}>King</option>
                                                        </select>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold">Người lớn tối đa</label>
                                                        <input class="form-control" type="number" min="1" max="50" name="maxAdults" value="${r.maxAdults}" required>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold">Trẻ em tối đa</label>
                                                        <input class="form-control" type="number" min="0" max="50" name="maxChildren" value="${r.maxChildren}" required>
                                                    </div>

                                                    <div class="col-md-4">
                                                        <label class="form-label fw-bold">Diện tích m²</label>
                                                        <input class="form-control" type="number" min="0.1" max="1000" step="0.1" name="roomSize" value="${r.roomSize}">
                                                    </div>

                                                    <div class="col-12">
                                                        <label class="form-label fw-bold">Link ảnh phòng</label>
                                                        <input class="form-control" name="image" value="${fn:escapeXml(r.image)}">
                                                    </div>

                                                    <div class="col-12">
                                                        <label class="form-label fw-bold">Mô tả phòng</label>
                                                        <textarea class="form-control" name="description"><c:out value="${r.description}"/></textarea>
                                                    </div>

                                                    <fieldset class="col-12 border-0 p-0 m-0">
                                                        <legend class="field-title">Tiện ích phòng</legend>
                                                        <div class="facility-list">
                                                            <c:forEach var="f" items="${roomFacilityEditOptions}">
                                                                <c:set var="checked" value="false"/>
                                                                <c:forEach var="rf" items="${r.facilityList}">
                                                                    <c:if test="${rf.facilityID == f.facilityID}">
                                                                        <c:set var="checked" value="true"/>
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:if test="${f.status == 'Active' || checked}">
                                                                    <label class="facility-item">
                                                                        <input type="checkbox" name="facilityIDs"
                                                                               value="${f.facilityID}" ${checked ? 'checked' : ''}>
                                                                        <i class="fa-solid ${fn:escapeXml(f.icon)}"></i>
                                                                        <span><c:out value="${f.facilityName}"/></span>
                                                                        <c:if test="${f.status != 'Active'}"><small>(đã ngừng)</small></c:if>
                                                                    </label>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </fieldset>
                                                </div>
                                            </div>

                                            <div class="modal-footer">
                                                <button class="btn-main" type="submit">
                                                    <i class="fa-solid fa-save"></i>
                                                    Lưu thay đổi
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </main>
</div>

<div class="modal fade" id="addRoomModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <form class="room-form"
                  action="${pageContext.request.contextPath}/staff/accommodation"
                  method="post"
                  novalidate>
                <input type="hidden" name="action" value="addRoom">
                <input type="hidden" name="accommodationID" value="${accommodation.accommodationID}">

                <div class="modal-header">
                    <h5 class="modal-title">Thêm phòng mới</h5>
                    <button type="button" class="btn-close btn-close-white"
                            data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Loại phòng</label>
                            <input class="form-control" name="roomType" placeholder="VD: Deluxe King" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Giá phòng</label>
                            <input class="form-control" type="number" min="1" step="1000" name="priceOfRoom" placeholder="1200000" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="Available">Còn phòng</option>
                                <option value="Unavailable">Hết phòng</option>
                                <option value="Maintenance">Bảo trì</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Tổng số phòng</label>
                            <input class="form-control" type="number" min="0" name="numberOfRooms" value="1" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Phòng còn trống</label>
                            <input class="form-control" type="number" min="0" name="roomAvailability" value="1" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Số giường</label>
                            <input class="form-control" type="number" min="1" max="20" name="bedCount" value="1" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Loại giường</label>
                            <select class="form-select" name="bedType">
                                <option value="Single">Giường đơn</option>
                                <option value="Double">Giường đôi</option>
                                <option value="Queen">Queen</option>
                                <option value="King">King</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Người lớn tối đa</label>
                            <input class="form-control" type="number" min="1" max="50" name="maxAdults" value="2" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Trẻ em tối đa</label>
                            <input class="form-control" type="number" min="0" max="50" name="maxChildren" value="0" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Diện tích m²</label>
                            <input class="form-control" type="number" min="0.1" max="1000" step="0.1" name="roomSize" value="25">
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">Link ảnh phòng</label>
                            <input class="form-control" name="image" placeholder="https://...">
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">Mô tả phòng</label>
                            <textarea class="form-control" name="description" placeholder="Mô tả tiện nghi, view, phong cách phòng..."></textarea>
                        </div>

                        <fieldset class="col-12 border-0 p-0 m-0">
                            <legend class="field-title">Tiện ích phòng</legend>
                            <div class="facility-list">
                                <c:forEach var="f" items="${roomFacilityOptions}">
                                    <label class="facility-item">
                                        <input type="checkbox" name="facilityIDs" value="${f.facilityID}">
                                        <i class="fa-solid ${fn:escapeXml(f.icon)}"></i>
                                        <span><c:out value="${f.facilityName}"/></span>
                                    </label>
                                </c:forEach>
                            </div>
                        </fieldset>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn-main" type="submit">
                        <i class="fa-solid fa-plus"></i>
                        Thêm phòng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="accommodationFacilityModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/staff/accommodation" method="post">
                <input type="hidden" name="action" value="updateAccommodationFacilities">
                <input type="hidden" name="accommodationID" value="${accommodation.accommodationID}">

                <div class="modal-header">
                    <h5 class="modal-title">Cập nhật tiện ích nơi lưu trú</h5>
                    <button type="button" class="btn-close btn-close-white"
                            data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>

                <div class="modal-body">
                    <div class="facility-list">
                        <c:forEach var="f" items="${accommodationFacilityEditOptions}">
                            <c:set var="checked" value="false"/>

                            <c:forEach var="af" items="${accommodation.facilityList}">
                                <c:if test="${af.facilityID == f.facilityID}">
                                    <c:set var="checked" value="true"/>
                                </c:if>
                            </c:forEach>

                            <c:if test="${f.status == 'Active' || checked}">
                                <label class="facility-item">
                                    <input type="checkbox" name="facilityIDs" value="${f.facilityID}" ${checked ? 'checked' : ''}>
                                    <i class="fa-solid ${fn:escapeXml(f.icon)}"></i>
                                    <span><c:out value="${f.facilityName}"/></span>
                                    <c:if test="${f.status != 'Active'}"><small>(đã ngừng)</small></c:if>
                                </label>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn-main" type="submit">
                        <i class="fa-solid fa-save"></i>
                        Lưu tiện ích
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function showFieldError(input, message) {
        clearFieldError(input);

        input.classList.add("input-error");
        input.classList.remove("input-success");

        const error = document.createElement("span");
        error.className = "live-error";
        error.innerText = message;

        input.insertAdjacentElement("afterend", error);
    }

    function showFieldSuccess(input) {
        clearFieldError(input);

        input.classList.remove("input-error");
        input.classList.add("input-success");
    }

    function clearFieldError(input) {
        input.classList.remove("input-error");

        const next = input.nextElementSibling;
        if (next && next.classList.contains("live-error")) {
            next.remove();
        }
    }

    function getInput(form, name) {
        return form.querySelector("[name='" + name + "']");
    }

    function isValidUrl(value) {
        return /^https?:\/\/.+/i.test((value || "").trim());
    }

    function normalizeDecimal(value) {
        return (value || "").trim().replace(",", ".");
    }

    function validateText(input, label, min, max) {
        if (!input) return true;

        const value = input.value.trim();

        if (value.length < min) {
            showFieldError(input, label + " phải có ít nhất " + min + " ký tự.");
            return false;
        }

        if (value.length > max) {
            showFieldError(input, label + " không được vượt quá " + max + " ký tự.");
            return false;
        }

        showFieldSuccess(input);
        return true;
    }

    function validateUrlInput(input, label) {
        if (!input) return true;

        const value = input.value.trim();

        if (value.length === 0) {
            clearFieldError(input);
            input.classList.remove("input-success");
            return true;
        }

        if (!isValidUrl(value)) {
            showFieldError(input, label + " phải bắt đầu bằng http:// hoặc https://.");
            return false;
        }

        showFieldSuccess(input);
        return true;
    }

    function validateNumberRange(input, label, min, max, allowDecimal) {
        if (!input) return true;

        const raw = normalizeDecimal(input.value);
        const number = Number(raw);

        if (raw.length === 0 || Number.isNaN(number)) {
            showFieldError(input, label + " phải là số hợp lệ.");
            return false;
        }

        if (!allowDecimal && !Number.isInteger(number)) {
            showFieldError(input, label + " phải là số nguyên.");
            return false;
        }

        if (number < min || number > max) {
            showFieldError(input, label + " phải nằm trong khoảng " + min + " đến " + max + ".");
            return false;
        }

        input.value = raw;
        showFieldSuccess(input);
        return true;
    }

    function getNumberValue(input) {
        if (!input) return null;

        const raw = normalizeDecimal(input.value);
        const number = Number(raw);

        return Number.isNaN(number) ? null : number;
    }

    function validateRoomAvailability(form) {
        const numberOfRooms = getInput(form, "numberOfRooms");
        const roomAvailability = getInput(form, "roomAvailability");

        if (!numberOfRooms || !roomAvailability) return true;

        const total = getNumberValue(numberOfRooms);
        const available = getNumberValue(roomAvailability);

        if (total === null || available === null) {
            return false;
        }

        if (available > total) {
            showFieldError(roomAvailability, "Phòng còn trống không được lớn hơn tổng số phòng.");
            return false;
        }

        if (available < 0) {
            showFieldError(roomAvailability, "Phòng còn trống không được nhỏ hơn 0.");
            return false;
        }

        showFieldSuccess(roomAvailability);
        return true;
    }

    function validateRoomForm(form) {
        let valid = true;

        const roomType = getInput(form, "roomType");
        const priceOfRoom = getInput(form, "priceOfRoom");
        const numberOfRooms = getInput(form, "numberOfRooms");
        const roomAvailability = getInput(form, "roomAvailability");
        const bedCount = getInput(form, "bedCount");
        const bedType = getInput(form, "bedType");
        const maxAdults = getInput(form, "maxAdults");
        const maxChildren = getInput(form, "maxChildren");
        const roomSize = getInput(form, "roomSize");
        const image = getInput(form, "image");
        const description = getInput(form, "description");

        if (!validateText(roomType, "Loại phòng", 2, 100)) valid = false;
        if (!validateNumberRange(priceOfRoom, "Giá phòng", 1, 1000000000, true)) valid = false;
        if (!validateNumberRange(numberOfRooms, "Tổng số phòng", 0, 1000, false)) valid = false;
        if (!validateNumberRange(roomAvailability, "Phòng còn trống", 0, 1000, false)) valid = false;
        if (!validateRoomAvailability(form)) valid = false;
        if (!validateNumberRange(bedCount, "Số giường", 1, 20, false)) valid = false;
        if (!validateText(bedType, "Loại giường", 2, 50)) valid = false;
        if (!validateNumberRange(maxAdults, "Người lớn tối đa", 1, 50, false)) valid = false;
        if (!validateNumberRange(maxChildren, "Trẻ em tối đa", 0, 50, false)) valid = false;
        if (roomSize && roomSize.value.trim()
                && !validateNumberRange(roomSize, "Diện tích phòng", 0.1, 1000, true)) valid = false;
        if (!validateUrlInput(image, "Link ảnh phòng")) valid = false;
        if (description && description.value.trim()
                && !validateText(description, "Mô tả phòng", 0, 2000)) valid = false;

        return valid;
    }

    function bindLiveValidation(form, validator) {
        connectFormLabels(form);
        form.setAttribute("novalidate", "novalidate");

        form.querySelectorAll("input, textarea, select").forEach(function (input) {
            input.addEventListener("input", function () {
                validator(form);
            });

            input.addEventListener("change", function () {
                validator(form);
            });

            input.addEventListener("blur", function () {
                validator(form);
            });
        });

        form.addEventListener("submit", function (event) {
            if (!validator(form)) {
                event.preventDefault();

                const firstError = form.querySelector(".input-error");
                if (firstError) {
                    firstError.scrollIntoView({
                        behavior: "smooth",
                        block: "center"
                    });

                    setTimeout(function () {
                        firstError.focus();
                    }, 250);
                }
            }
        });
    }

    function connectFormLabels(form) {
        const prefix = (form.closest(".modal")?.id || "roomForm").replace(/[^a-zA-Z0-9_-]/g, "");
        form.querySelectorAll("input:not([type='hidden']):not([type='checkbox']), select, textarea")
                .forEach(function (input, index) {
                    if (!input.id) input.id = prefix + "-" + input.name + "-" + index;
                    const container = input.parentElement;
                    const label = container ? container.querySelector("label.form-label:not([for])") : null;
                    if (label) label.htmlFor = input.id;
                });
    }

    function restoreServerValidation() {
        const state = document.getElementById("serverValidation");
        if (!state) return;

        const selector = state.dataset.action === "updateRoom"
                ? "#editRoomModal" + state.dataset.ownerId + " .room-form"
                : "#addRoomModal .room-form";
        const form = document.querySelector(selector);
        if (!form) return;

        state.querySelectorAll("[data-form-field]").forEach(function (item) {
            const input = getInput(form, item.dataset.formField);
            if (input && input.type !== "checkbox" && input.type !== "hidden") {
                input.value = item.dataset.value || "";
            }
        });
        state.querySelectorAll("[data-field]").forEach(function (item) {
            const input = getInput(form, item.dataset.field);
            if (input) showFieldError(input, item.dataset.message);
        });

        const modal = form.closest(".modal");
        if (modal && window.bootstrap) bootstrap.Modal.getOrCreateInstance(modal).show();
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".room-form").forEach(function (form) {
            bindLiveValidation(form, validateRoomForm);
        });

        restoreServerValidation();

        document.querySelectorAll(".js-confirm-delete").forEach(function (form) {
            form.addEventListener("submit", function (event) {
                if (!window.confirm(form.dataset.confirmMessage)) {
                    event.preventDefault();
                }
            });
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
