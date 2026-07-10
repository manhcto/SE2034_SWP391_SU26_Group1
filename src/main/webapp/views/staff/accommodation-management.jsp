<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Quản lý Chỗ ở</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --dark: #0f172a;
            --text: #1e293b;
            --muted: #64748b;
            --bg: #f3f6fb;
            --soft: #f8fafc;
            --border: #e2e8f0;
            --success: #16a34a;
            --danger: #dc2626;
            --warning: #f59e0b;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
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

        .manage-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 100%);
            border-radius: 28px;
            padding: 34px 36px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            margin-bottom: 28px;
            box-shadow: 0 18px 42px rgba(15, 23, 42, 0.16);
        }

        .manage-hero {
            display: none;
        }

        .staff-page-topbar {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 22px 24px;
            box-shadow: var(--shadow);
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .staff-page-topbar h1 {
            margin: 0;
            color: var(--dark);
            font-size: 28px;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .staff-page-topbar p {
            margin: 6px 0 0;
            color: var(--muted);
            font-weight: 600;
        }

        .manage-hero-title {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .manage-hero-title > i {
            font-size: 38px;
            color: white;
        }

        .manage-hero-title h1 {
            color: white;
            font-size: 34px;
            font-weight: 900;
            margin: 0 0 8px;
            letter-spacing: -0.5px;
        }

        .manage-hero-title p {
            color: #cbd5e1;
            font-size: 16px;
            font-weight: 600;
            margin: 0;
        }

        .manage-hero-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-shrink: 0;
        }

        .hero-action-btn {
            border: none;
            border-radius: 10px;
            background: white;
            color: #2563eb;
            padding: 13px 22px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            cursor: pointer;
            min-height: 52px;
        }

        .hero-action-btn:hover {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .btn-main {
            border: none;
            border-radius: 14px;
            background: var(--primary);
            color: white;
            padding: 12px 18px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-main:hover {
            background: var(--primary-dark);
            color: white;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 20px;
            box-shadow: var(--shadow);
        }

        .stat-card .label {
            color: var(--muted);
            font-weight: 700;
            margin-bottom: 8px;
        }

        .stat-card .value {
            font-size: 30px;
            font-weight: 900;
            color: var(--dark);
        }

        .toolbar {
            background: white;
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 18px;
            box-shadow: var(--shadow);
            margin-bottom: 22px;
        }

        .form-control,
        .form-select {
            border-radius: 13px;
            border: 1px solid #dbe3ef;
            min-height: 46px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        textarea.form-control {
            min-height: 96px;
        }

        .table-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table {
            margin: 0;
            vertical-align: middle;
        }

        .table thead th {
            background: var(--soft);
            color: #475569;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border-bottom: 1px solid var(--border);
            padding: 15px;
            white-space: nowrap;
        }

        .table tbody td {
            padding: 15px;
            border-bottom: 1px solid #eef2f7;
        }

        .acc-info {
            display: flex;
            align-items: center;
            gap: 14px;
            min-width: 280px;
        }

        .acc-img {
            width: 74px;
            height: 58px;
            border-radius: 14px;
            object-fit: cover;
            background: #e2e8f0;
        }

        .acc-name {
            font-weight: 900;
            color: var(--dark);
            margin-bottom: 3px;
        }

        .acc-address {
            color: var(--muted);
            font-size: 13.5px;
            line-height: 1.4;
        }

        .badge-soft {
            border-radius: 999px;
            padding: 7px 11px;
            font-size: 12.5px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }

        .badge-type {
            background: #eef2ff;
            color: #3730a3;
        }

        .badge-available {
            background: #dcfce7;
            color: #166534;
        }

        .badge-unavailable {
            background: #fee2e2;
            color: #991b1b;
        }

        .badge-maintenance {
            background: #fef3c7;
            color: #92400e;
        }

        .action-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .btn-icon {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: white;
            color: #334155;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-icon:hover {
            background: #eff6ff;
            color: var(--primary);
        }

        .btn-icon.danger:hover {
            background: #fee2e2;
            color: var(--danger);
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

        .modal-footer .btn-light {
            display: none !important;
        }

        .field-title {
            font-weight: 900;
            color: var(--dark);
            margin: 18px 0 10px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
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
            flex-shrink: 0;
        }

        .facility-item i {
            color: var(--primary);
            min-width: 18px;
            text-align: center;
            flex-shrink: 0;
        }

        .alert {
            border-radius: 16px;
            border: none;
        }

        .input-error {
            border-color: #dc2626 !important;
            box-shadow: 0 0 0 4px rgba(220, 38, 38, 0.10) !important;
        }

        .input-success {
            border-color: #16a34a !important;
            box-shadow: 0 0 0 4px rgba(22, 163, 74, 0.10) !important;
        }

        .live-error {
            display: block;
            color: #dc2626;
            font-size: 12.5px;
            font-weight: 700;
            margin-top: 6px;
        }

        @media (max-width: 1200px) {
            .stat-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .facility-list {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 992px) {
            .staff-page-topbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .manage-hero {
                flex-direction: column;
                align-items: flex-start;
            }

            .manage-hero-actions {
                width: 100%;
                flex-wrap: wrap;
            }

            .hero-action-btn {
                flex: 1;
                justify-content: center;
            }
        }

        @media (max-width: 768px) {
            .admin-main {
                padding: 18px;
            }

            .manage-hero {
                padding: 26px 22px;
                border-radius: 22px;
            }

            .manage-hero-title {
                align-items: flex-start;
            }

            .manage-hero-title h1 {
                font-size: 26px;
            }

            .manage-hero-title p {
                font-size: 14px;
            }

            .stat-grid {
                grid-template-columns: 1fr;
            }

            .facility-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <main class="admin-main">
        <jsp:include page="/views/common/admin-header.jsp"/>

        <div class="manage-hero">
            <div class="manage-hero-left">
                <div class="manage-hero-title">
                    <i class="fa-solid fa-hotel"></i>
                    <div>
                        <h1>Quản lý Chỗ ở & Homestay</h1>
                        <p>Quản lý khách sạn, homestay, resort, căn hộ, phòng, tiện ích và thông tin lưu trú.</p>
                    </div>
                </div>
            </div>

            <div class="manage-hero-actions">
                <a class="hero-action-btn" href="${pageContext.request.contextPath}/staff/home">
                    <i class="fa-solid fa-house"></i>
                    Admin Home
                </a>

                <button class="hero-action-btn" data-bs-toggle="modal" data-bs-target="#addAccommodationModal">
                    <i class="fa-solid fa-plus"></i>
                    Thêm nơi lưu trú
                </button>
            </div>
        </div>

        <div class="staff-page-topbar">
            <div>
                <h1>Quản lý lưu trú</h1>
                <p>Quản lý khách sạn, homestay, resort, căn hộ, phòng và tiện ích.</p>
            </div>

            <button class="btn-main" data-bs-toggle="modal" data-bs-target="#addAccommodationModal">
                <i class="fa-solid fa-plus"></i>
                Thêm nơi lưu trú
            </button>
        </div>

        <c:if test="${not empty sessionScope.errors}">
            <div class="alert alert-danger">
                <strong>Dữ liệu nhập vào chưa hợp lệ</strong>
                <ul class="mb-0 mt-2">
                    <c:forEach var="err" items="${sessionScope.errors}">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
            <c:remove var="errors" scope="session"/>
        </c:if>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="label">Tổng nơi lưu trú</div>
                <div class="value">${empty accommodationList ? 0 : accommodationList.size()}</div>
            </div>

            <div class="stat-card">
                <div class="label">Đang hoạt động</div>
                <div class="value">
                    <c:set var="activeCount" value="0"/>
                    <c:forEach var="a" items="${accommodationList}">
                        <c:if test="${a.status == 'Available' || a.status == 'Active'}">
                            <c:set var="activeCount" value="${activeCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${activeCount}
                </div>
            </div>

            <div class="stat-card">
                <div class="label">Tổng phòng còn trống</div>
                <div class="value">
                    <c:set var="roomAvailable" value="0"/>
                    <c:forEach var="a" items="${accommodationList}">
                        <c:set var="roomAvailable" value="${roomAvailable + a.totalAvailableRooms}"/>
                    </c:forEach>
                    ${roomAvailable}
                </div>
            </div>

            <div class="stat-card">
                <div class="label">Đánh giá trung bình</div>
                <div class="value">
                    <c:set var="totalRate" value="0"/>
                    <c:set var="rateCount" value="0"/>
                    <c:forEach var="a" items="${accommodationList}">
                        <c:set var="totalRate" value="${totalRate + a.rate}"/>
                        <c:set var="rateCount" value="${rateCount + 1}"/>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${rateCount > 0}">
                            <fmt:formatNumber value="${totalRate / rateCount}" maxFractionDigits="1"/>
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="toolbar">
            <div class="row g-3">
                <div class="col-lg-4">
                    <input type="text" class="form-control" id="searchInput"
                           placeholder="Tìm theo tên, địa chỉ, tỉnh/thành...">
                </div>

                <div class="col-lg-3">
                    <select class="form-select" id="typeFilter">
                        <option value="">Tất cả loại lưu trú</option>
                        <option value="hotel">Khách sạn</option>
                        <option value="homestay">Homestay</option>
                        <option value="resort">Resort</option>
                        <option value="apartment">Căn hộ</option>
                        <option value="villa">Villa</option>
                    </select>
                </div>

                <div class="col-lg-3">
                    <select class="form-select" id="statusFilter">
                        <option value="">Tất cả trạng thái</option>
                        <option value="available">Đang hoạt động</option>
                        <option value="unavailable">Tạm ngưng</option>
                        <option value="maintenance">Bảo trì</option>
                    </select>
                </div>

                <div class="col-lg-2">
                    <button class="btn btn-outline-secondary w-100" onclick="resetFilter()" type="button">
                        <i class="fa-solid fa-rotate-left me-1"></i>
                        Xóa lọc
                    </button>
                </div>
            </div>
        </div>

        <div class="table-card">
            <div class="table-responsive">
                <table class="table" id="accommodationTable">
                    <thead>
                    <tr>
                        <th>Nơi lưu trú</th>
                        <th>Loại</th>
                        <th>Đánh giá</th>
                        <th>Phòng trống</th>
                        <th>Giờ nhận/trả</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty accommodationList}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-5">
                                    Chưa có dữ liệu nơi lưu trú.
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="a" items="${accommodationList}">
                                <tr data-name="${a.name} ${a.address} ${a.province} ${a.district}"
                                    data-type="${a.type}"
                                    data-status="${a.status}">
                                    <td>
                                        <div class="acc-info">
                                            <img class="acc-img" src="${a.image}" alt="${a.name}"
                                                 onerror="this.src='https://placehold.co/400x260?text=WonderVN';">
                                            <div>
                                                <div class="acc-name">${a.name}</div>
                                                <div class="acc-address">
                                                        ${a.fullAddress}
                                                    <br>
                                                    <i class="fa-solid fa-phone me-1"></i>${a.phone}
                                                </div>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <span class="badge-soft badge-type">
                                            <i class="fa-solid fa-hotel"></i>${a.displayType}
                                        </span>
                                    </td>

                                    <td>
                                        <strong>${a.rate}</strong>
                                        <span class="text-warning">
                                            <i class="fa-solid fa-star"></i>
                                        </span>
                                    </td>

                                    <td>
                                        <strong>${a.totalAvailableRooms}</strong>
                                        <span class="text-muted">phòng</span>
                                    </td>

                                    <td>
                                        <div><strong>${a.checkInText}</strong> nhận</div>
                                        <div class="text-muted">${a.checkOutText} trả</div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${a.status == 'Available' || a.status == 'Active'}">
                                                <span class="badge-soft badge-available">
                                                    <i class="fa-solid fa-circle-check"></i>Hoạt động
                                                </span>
                                            </c:when>

                                            <c:when test="${a.status == 'Maintenance'}">
                                                <span class="badge-soft badge-maintenance">
                                                    <i class="fa-solid fa-screwdriver-wrench"></i>Bảo trì
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge-soft badge-unavailable">
                                                    <i class="fa-solid fa-circle-xmark"></i>Tạm ngưng
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <div class="action-group justify-content-end">
                                            <a class="btn-icon"
                                               href="${pageContext.request.contextPath}/staff/accommodation?action=detail&id=${a.accommodationID}"
                                               title="Xem chi tiết">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>

                                            <button class="btn-icon"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#editAccommodationModal${a.accommodationID}"
                                                    title="Sửa">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>

                                            <a class="btn-icon danger"
                                               onclick="return confirm('Bạn có chắc muốn xóa nơi lưu trú này?')"
                                               href="${pageContext.request.contextPath}/staff/accommodation?action=delete&id=${a.accommodationID}"
                                               title="Xóa">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>

                                <div class="modal fade" id="editAccommodationModal${a.accommodationID}" tabindex="-1">
                                    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <form class="accommodation-form"
                                                  action="${pageContext.request.contextPath}/staff/accommodation"
                                                  method="post"
                                                  novalidate>
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="accommodationID" value="${a.accommodationID}">

                                                <div class="modal-header">
                                                    <h5 class="modal-title">Cập nhật nơi lưu trú</h5>
                                                    <button type="button" class="btn-close btn-close-white"
                                                            data-bs-dismiss="modal" aria-label="Đóng"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold">Tên nơi lưu trú</label>
                                                            <input class="form-control" name="name" value="${a.name}" required>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <label class="form-label fw-bold">Loại</label>
                                                            <select class="form-select" name="type" required>
                                                                <option value="Hotel" ${a.type == 'Hotel' || a.type == 'Khách sạn' ? 'selected' : ''}>Khách sạn</option>
                                                                <option value="Homestay" ${a.type == 'Homestay' ? 'selected' : ''}>Homestay</option>
                                                                <option value="Resort" ${a.type == 'Resort' ? 'selected' : ''}>Resort</option>
                                                                <option value="Apartment" ${a.type == 'Apartment' || a.type == 'Căn hộ' ? 'selected' : ''}>Căn hộ</option>
                                                                <option value="Villa" ${a.type == 'Villa' ? 'selected' : ''}>Villa</option>
                                                            </select>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <label class="form-label fw-bold">Trạng thái</label>
                                                            <select class="form-select" name="status" required>
                                                                <option value="Available" ${a.status == 'Available' || a.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                                                <option value="Unavailable" ${a.status == 'Unavailable' || a.status == 'Inactive' ? 'selected' : ''}>Tạm ngưng</option>
                                                                <option value="Maintenance" ${a.status == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                                                            </select>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold">Link ảnh</label>
                                                            <input class="form-control" name="image" value="${a.image}" required>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <label class="form-label fw-bold">Số điện thoại</label>
                                                            <input class="form-control" name="phone" value="${a.phone}" required>
                                                        </div>

                                                        <div class="col-md-3">
                                                            <label class="form-label fw-bold">Đánh giá</label>
                                                            <input class="form-control" type="number" step="0.1" min="0" max="5" name="rate" value="${a.rate}" required>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold">Tỉnh/thành</label>
                                                            <select class="form-select js-province-select"
                                                                    name="province"
                                                                    data-selected="${a.province}"
                                                                    required>
                                                                <option value="">-- Chọn tỉnh/thành --</option>
                                                            </select>
                                                            <input type="hidden" name="district" value="">
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold">Phường/xã</label>
                                                            <select class="form-select js-ward-select"
                                                                    name="ward"
                                                                    data-selected="${a.ward}"
                                                                    required>
                                                                <option value="">-- Chọn phường/xã --</option>
                                                            </select>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold">Địa chỉ cụ thể</label>
                                                            <input class="form-control" name="address" value="${a.address}" required>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold">Giờ nhận phòng</label>
                                                            <input class="form-control" type="time" name="checkInTime" value="${a.checkInText}" required>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold">Giờ trả phòng</label>
                                                            <input class="form-control" type="time" name="checkOutTime" value="${a.checkOutText}" required>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label fw-bold">Mô tả</label>
                                                            <textarea class="form-control" name="description" required>${a.description}</textarea>
                                                        </div>
                                                    </div>

                                                    <div class="field-title">Tiện ích nơi lưu trú</div>

                                                    <div class="facility-list">
                                                        <c:forEach var="f" items="${accommodationFacilityOptions}">
                                                            <c:set var="checked" value="false"/>
                                                            <c:forEach var="af" items="${a.facilityList}">
                                                                <c:if test="${af.facilityID == f.facilityID}">
                                                                    <c:set var="checked" value="true"/>
                                                                </c:if>
                                                            </c:forEach>

                                                            <label class="facility-item">
                                                                <input type="checkbox" name="facilityIDs" value="${f.facilityID}" ${checked ? 'checked' : ''}>
                                                                <i class="fa-solid ${f.icon}"></i>
                                                                <span>${f.facilityName}</span>
                                                            </label>
                                                        </c:forEach>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
                                                    <button type="submit" class="btn-main">
                                                        <i class="fa-solid fa-save"></i>Lưu thay đổi
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="addAccommodationModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <form class="accommodation-form"
                  action="${pageContext.request.contextPath}/staff/accommodation"
                  method="post"
                  novalidate>
                <input type="hidden" name="action" value="add">

                <div class="modal-header">
                    <h5 class="modal-title">Thêm nơi lưu trú mới</h5>
                    <button type="button" class="btn-close btn-close-white"
                            data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Tên nơi lưu trú</label>
                            <input class="form-control" name="name" placeholder="VD: Wonder Hotel" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Loại</label>
                            <select class="form-select" name="type" required>
                                <option value="Hotel">Khách sạn</option>
                                <option value="Homestay">Homestay</option>
                                <option value="Resort">Resort</option>
                                <option value="Apartment">Căn hộ</option>
                                <option value="Villa">Villa</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Trạng thái</label>
                            <select class="form-select" name="status" required>
                                <option value="Available">Hoạt động</option>
                                <option value="Unavailable">Tạm ngưng</option>
                                <option value="Maintenance">Bảo trì</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Link ảnh</label>
                            <input class="form-control" name="image" placeholder="https://..." required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Số điện thoại</label>
                            <input class="form-control" name="phone" placeholder="0900000000" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Đánh giá</label>
                            <input class="form-control" type="number" step="0.1" min="0" max="5" name="rate" value="4.5" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Tỉnh/thành</label>
                            <select class="form-select js-province-select"
                                    name="province"
                                    required>
                                <option value="">-- Chọn tỉnh/thành --</option>
                            </select>
                            <input type="hidden" name="district" value="">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Phường/xã</label>
                            <select class="form-select js-ward-select"
                                    name="ward"
                                    required>
                                <option value="">-- Chọn phường/xã --</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Địa chỉ cụ thể</label>
                            <input class="form-control" name="address" placeholder="VD: 25 Hàng Bạc" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Giờ nhận phòng</label>
                            <input class="form-control" type="time" name="checkInTime" value="14:00" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Giờ trả phòng</label>
                            <input class="form-control" type="time" name="checkOutTime" value="12:00" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">Mô tả</label>
                            <textarea class="form-control" name="description" placeholder="Mô tả điểm nổi bật, vị trí, phong cách lưu trú..." required></textarea>
                        </div>
                    </div>

                    <div class="field-title">Tiện ích nơi lưu trú</div>

                    <div class="facility-list">
                        <c:forEach var="f" items="${accommodationFacilityOptions}">
                            <label class="facility-item">
                                <input type="checkbox" name="facilityIDs" value="${f.facilityID}">
                                <i class="fa-solid ${f.icon}"></i>
                                <span>${f.facilityName}</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn-main">
                        <i class="fa-solid fa-plus"></i>Thêm nơi lưu trú
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function normalizeText(value) {
        return (value || '').toLowerCase().trim();
    }

    function filterAccommodationTable() {
        const keyword = normalizeText(document.getElementById('searchInput').value);
        const type = normalizeText(document.getElementById('typeFilter').value);
        const status = normalizeText(document.getElementById('statusFilter').value);

        document.querySelectorAll('#accommodationTable tbody tr[data-name]').forEach(row => {
            const rowName = normalizeText(row.dataset.name);
            const rowType = normalizeText(row.dataset.type);
            const rowStatus = normalizeText(row.dataset.status);

            const matchKeyword = !keyword || rowName.includes(keyword);
            const matchType = !type || rowType.includes(type);
            const matchStatus = !status || rowStatus.includes(status);

            row.style.display = matchKeyword && matchType && matchStatus ? '' : 'none';
        });
    }

    function resetFilter() {
        document.getElementById('searchInput').value = '';
        document.getElementById('typeFilter').value = '';
        document.getElementById('statusFilter').value = '';
        filterAccommodationTable();
    }

    document.getElementById('searchInput').addEventListener('input', filterAccommodationTable);
    document.getElementById('typeFilter').addEventListener('change', filterAccommodationTable);
    document.getElementById('statusFilter').addEventListener('change', filterAccommodationTable);
</script>

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

    function isValidPhone(value) {
        return /^[0-9]{8,15}$/.test((value || "").trim());
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

    function validateOptionalText(input, label, min, max) {
        if (!input) return true;

        const value = input.value.trim();

        if (value.length === 0) {
            clearFieldError(input);
            input.classList.remove("input-success");
            return true;
        }

        return validateText(input, label, min, max);
    }

    function validateUrlInput(input, label) {
        if (!input) return true;

        const value = input.value.trim();

        if (value.length === 0) {
            showFieldError(input, label + " không được để trống.");
            return false;
        }

        if (!isValidUrl(value)) {
            showFieldError(input, label + " phải bắt đầu bằng http:// hoặc https://.");
            return false;
        }

        showFieldSuccess(input);
        return true;
    }

    function validatePhoneInput(input) {
        if (!input) return true;

        const value = input.value.trim();

        if (value.length === 0) {
            showFieldError(input, "Số điện thoại không được để trống.");
            return false;
        }

        if (!isValidPhone(value)) {
            showFieldError(input, "Số điện thoại chỉ gồm 8 đến 15 chữ số.");
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

    function validateTimeInput(input, label) {
        if (!input) return true;

        if (!input.value) {
            showFieldError(input, label + " không được để trống.");
            return false;
        }

        showFieldSuccess(input);
        return true;
    }

    function validateAccommodationForm(form) {
        let valid = true;

        if (!validateText(getInput(form, "name"), "Tên nơi lưu trú", 2, 255)) valid = false;
        if (!validateUrlInput(getInput(form, "image"), "Link ảnh")) valid = false;
        if (!validatePhoneInput(getInput(form, "phone"))) valid = false;
        if (!validateNumberRange(getInput(form, "rate"), "Đánh giá", 0, 5, true)) valid = false;
        if (!validateText(getInput(form, "province"), "Tỉnh/thành", 2, 100)) valid = false;
        if (!validateText(getInput(form, "ward"), "Phường/xã", 2, 150)) valid = false;
        if (!validateText(getInput(form, "address"), "Địa chỉ cụ thể", 3, 255)) valid = false;
        if (!validateTimeInput(getInput(form, "checkInTime"), "Giờ nhận phòng")) valid = false;
        if (!validateTimeInput(getInput(form, "checkOutTime"), "Giờ trả phòng")) valid = false;
        if (!validateText(getInput(form, "description"), "Mô tả", 10, 2000)) valid = false;

        return valid;
    }

    function bindLiveValidation(form, validator) {
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

    const administrativeUnits = [
        <c:forEach var="unit" items="${administrativeUnitList}" varStatus="loop">
        {province: "${unit.provinceName}", ward: "${unit.wardName}"}${loop.last ? '' : ','}
        </c:forEach>
    ];

    function normalizeAdminName(value) {
        return (value || "")
            .trim()
            .toLowerCase()
            .replace(/^tp\.?\s+/, "")
            .replace(/^thành phố\s+/, "")
            .replace(/^tỉnh\s+/, "")
            .replace(/^phường\s+/, "")
            .replace(/^xã\s+/, "")
            .replace(/^đặc khu\s+/, "");
    }

    function resolveOptionValue(options, selected) {
        const raw = (selected || "").trim();

        if (!raw) {
            return "";
        }

        const normalized = normalizeAdminName(raw);

        return options.find(function (value) {
            return value === raw || normalizeAdminName(value) === normalized;
        }) || "";
    }

    function uniqueProvinceList() {
        const seen = new Set();

        return administrativeUnits
            .map(function (unit) {
                return unit.province;
            })
            .filter(function (province) {
                if (seen.has(province)) {
                    return false;
                }

                seen.add(province);
                return true;
            });
    }

    function fillSelect(select, values, placeholder, selected) {
        if (!select) return;

        const resolvedValue = resolveOptionValue(values, selected);

        select.innerHTML = "";
        select.appendChild(new Option(placeholder, ""));

        values.forEach(function (value) {
            select.appendChild(new Option(value, value, false, value === resolvedValue));
        });
    }

    function fillWardSelect(wardSelect, province, selectedWard) {
        const seen = new Set();
        const wardOptions = administrativeUnits
            .filter(function (unit) {
                return unit.province === province;
            })
            .map(function (unit) {
                return unit.ward;
            })
            .filter(function (ward) {
                if (seen.has(ward)) {
                    return false;
                }

                seen.add(ward);
                return true;
            });

        fillSelect(wardSelect, wardOptions, "-- Chọn phường/xã --", selectedWard);
    }

    function setupAdministrativeSelectors(form) {
        const provinceSelect = getInput(form, "province");
        const wardSelect = getInput(form, "ward");

        if (!provinceSelect || !wardSelect) return;

        const provinces = uniqueProvinceList();
        fillSelect(provinceSelect, provinces, "-- Chọn tỉnh/thành --", provinceSelect.dataset.selected);
        fillWardSelect(wardSelect, provinceSelect.value, wardSelect.dataset.selected);

        provinceSelect.addEventListener("change", function () {
            fillWardSelect(wardSelect, provinceSelect.value, "");
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".accommodation-form").forEach(function (form) {
            setupAdministrativeSelectors(form);
            bindLiveValidation(form, validateAccommodationForm);
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
