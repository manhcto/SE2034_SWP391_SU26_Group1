<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Quản lý phương tiện</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
            color: #0f172a;
        }

        .page-header {
            background: linear-gradient(135deg, #0f172a, #2563eb);
            border-radius: 24px;
            padding: 28px;
            color: white;
            box-shadow: 0 18px 42px rgba(15, 23, 42, 0.22);
        }

        .card-custom {
            border: none;
            border-radius: 22px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
            overflow: hidden;
        }

        .vehicle-toolbar {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 22px;
            padding: 18px;
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
            margin-bottom: 22px;
        }

        .vehicle-toolbar .form-control,
        .vehicle-toolbar .form-select {
            border-radius: 13px;
            border: 1px solid #dbe3ef;
            min-height: 46px;
            font-size: 14px;
        }

        .vehicle-toolbar .form-control:focus,
        .vehicle-toolbar .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }

        .table thead th {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #64748b;
            background: #f8fafc;
            padding-top: 16px;
            padding-bottom: 16px;
        }

        .vehicle-img {
            width: 92px;
            height: 64px;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            background: #f1f5f9;
        }

        .badge-soft-success {
            background: #dcfce7;
            color: #166534;
        }

        .badge-soft-danger {
            background: #fee2e2;
            color: #991b1b;
        }

        .badge-soft-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 11px;
        }

        .form-control,
        .form-select {
            border-radius: 13px;
            padding: 10px 12px;
        }

        .modal-content {
            border-radius: 24px;
        }

        .modal-dialog {
            max-height: 94vh;
        }

        .modal-content {
            max-height: 94vh;
            overflow: hidden;
        }

        .modal-body {
            overflow-y: auto;
            max-height: calc(94vh - 145px);
        }

        .spec-pill {
            display: inline-block;
            background: #eef2ff;
            color: #3730a3;
            border-radius: 999px;
            padding: 5px 9px;
            font-size: 12px;
            font-weight: 700;
            margin: 2px;
        }

        .location-text {
            color: #475569;
            font-size: 13px;
            max-width: 220px;
        }

        .empty-box {
            padding: 56px 20px;
        }

        .invalid-feedback {
            font-size: 13px;
            font-weight: 600;
        }

        .section-title {
            font-size: 14px;
            font-weight: 900;
            color: #1e293b;
            margin: 16px 0 8px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e2e8f0;
        }

        @media (max-width: 992px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 18px;
            }

            .page-header .d-flex {
                width: 100%;
                flex-wrap: wrap;
            }

            .page-header .btn {
                flex: 1;
            }
        }
    </style>
</head>

<body>
<div class="container-fluid py-4 px-4">

    <c:if test="${not empty sessionScope.errors}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4 mb-4">
            <div class="fw-bold mb-2">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Dữ liệu nhập vào chưa hợp lệ
            </div>

            <ul class="mb-0">
                <c:forEach var="err" items="${sessionScope.errors}">
                    <li>${err}</li>
                </c:forEach>
            </ul>

            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>

        <c:remove var="errors" scope="session"/>
    </c:if>

    <c:if test="${not empty param.status}">
        <c:choose>
            <c:when test="${param.status == 'addSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-check me-2"></i> Thêm phương tiện thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'updateSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-check me-2"></i> Cập nhật phương tiện thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'deleteSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-trash me-2"></i> Xóa phương tiện thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'validationFail'}"></c:when>

            <c:otherwise>
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> Thao tác thất bại. Vui lòng kiểm tra lại.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <div class="page-header mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1">
                <i class="fa-solid fa-car-side me-2"></i>
                Quản lý phương tiện
            </h2>
            <p class="mb-0 opacity-75">
                Quản lý hãng xe, model xe, địa điểm nhận xe, giá thuê, đặt cọc và thông tin sử dụng.
            </p>
        </div>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/home"
               class="btn btn-light text-primary fw-bold px-4 py-2 shadow-sm">
                <i class="fa-solid fa-house me-2"></i> Admin Home
            </a>

            <button class="btn btn-light text-primary fw-bold px-4 py-2 shadow-sm"
                    data-bs-toggle="modal"
                    data-bs-target="#modalAddVehicle">
                <i class="fa-solid fa-plus me-2"></i> Thêm phương tiện
            </button>
        </div>
    </div>

    <div class="vehicle-toolbar">
        <div class="row g-3">
            <div class="col-lg-3">
                <input type="text"
                       class="form-control"
                       id="vehicleSearchInput"
                       placeholder="Tìm theo tên xe, biển số, tỉnh/thành...">
            </div>

            <div class="col-lg-2">
                <select class="form-select" id="vehicleTypeFilter">
                    <option value="">Tất cả loại xe</option>
                    <option value="Motorbike">Xe máy</option>
                    <option value="Sedan">Sedan</option>
                    <option value="SUV">SUV</option>
                    <option value="Luxury Sedan">Sedan hạng sang</option>
                    <option value="Bus">Xe khách</option>
                    <option value="Limousine">Limousine</option>
                </select>
            </div>

            <div class="col-lg-2">
                <select class="form-select" id="vehicleTransmissionFilter">
                    <option value="">Tất cả hộp số</option>
                    <option value="Automatic">Số tự động</option>
                    <option value="Manual">Số sàn</option>
                </select>
            </div>

            <div class="col-lg-2">
                <select class="form-select" id="vehicleFuelFilter">
                    <option value="">Tất cả nhiên liệu</option>
                    <option value="Gasoline">Xăng</option>
                    <option value="Diesel">Dầu Diesel</option>
                    <option value="Electric">Điện</option>
                    <option value="Hybrid">Hybrid</option>
                </select>
            </div>

            <div class="col-lg-2">
                <select class="form-select" id="vehicleStatusFilter">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Available">Có sẵn</option>
                    <option value="Unavailable">Tạm ngưng</option>
                    <option value="Maintenance">Bảo trì</option>
                </select>
            </div>

            <div class="col-lg-1">
                <button class="btn btn-outline-secondary w-100 h-100"
                        onclick="resetVehicleFilter()"
                        type="button"
                        title="Xóa lọc">
                    <i class="fa-solid fa-rotate-left"></i>
                </button>
            </div>
        </div>
    </div>

    <div class="card card-custom">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="vehicleTable">
                    <thead>
                    <tr>
                        <th class="ps-4">Phương tiện</th>
                        <th>Biển số</th>
                        <th>Thông số</th>
                        <th>Địa điểm nhận xe</th>
                        <th>Giá thuê</th>
                        <th>Trạng thái</th>
                        <th class="text-end pe-4">Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty vehicleList}">
                            <tr>
                                <td colspan="7" class="text-center empty-box">
                                    <i class="fa-solid fa-car-burst fa-3x text-secondary opacity-50 mb-3"></i>
                                    <h6 class="fw-bold text-secondary">Chưa có phương tiện nào</h6>
                                    <p class="text-muted mb-0">Hãy thêm phương tiện đầu tiên vào hệ thống.</p>
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="v" items="${vehicleList}">
                                <tr data-vehicle-search="${v.displayName} ${v.licensePlate} ${v.pickupProvince} ${v.pickupDistrict} ${v.pickupWard} ${v.vehicleType} ${v.transmission} ${v.fuelType} ${v.status}"
                                    data-vehicle-type="${v.vehicleType}"
                                    data-vehicle-transmission="${v.transmission}"
                                    data-vehicle-fuel="${v.fuelType}"
                                    data-vehicle-status="${v.status}">
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <img src="${v.image}"
                                                 class="vehicle-img me-3"
                                                 alt="${v.displayName}"
                                                 onerror="this.src='https://placehold.co/160x100?text=Vehicle';">

                                            <div>
                                                <div class="fw-bold text-dark">${v.displayName}</div>
                                                <small class="text-muted">Service ID: #${v.serviceID}</small>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">
                                                ${v.licensePlate}
                                        </span>
                                    </td>

                                    <td>
                                        <span class="spec-pill">${v.seatCount} chỗ</span>
                                        <span class="spec-pill">${v.vehicleType}</span>

                                        <c:choose>
                                            <c:when test="${v.transmission == 'Automatic'}">
                                                <span class="spec-pill">Số tự động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="spec-pill">Số sàn</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${v.fuelType == 'Gasoline'}">
                                                <span class="spec-pill">Xăng</span>
                                            </c:when>
                                            <c:when test="${v.fuelType == 'Diesel'}">
                                                <span class="spec-pill">Dầu Diesel</span>
                                            </c:when>
                                            <c:when test="${v.fuelType == 'Electric'}">
                                                <span class="spec-pill">Điện</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="spec-pill">Hybrid</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <div class="fw-bold">${v.pickupProvince}</div>
                                        <div class="location-text">
                                                ${v.pickupDistrict}
                                            <c:if test="${not empty v.pickupWard}">
                                                , ${v.pickupWard}
                                            </c:if>
                                        </div>
                                    </td>

                                    <td>
                                        <div class="fw-bold text-primary">
                                            <fmt:formatNumber value="${v.pricePerDay}" type="number" maxFractionDigits="0"/> VND
                                        </div>

                                        <small class="text-muted">
                                            Cọc:
                                            <fmt:formatNumber value="${v.depositAmount}" type="number" maxFractionDigits="0"/> VND
                                        </small>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${v.status == 'Available'}">
                                                <span class="badge badge-soft-success rounded-pill px-3 py-2">
                                                    <i class="fa-solid fa-circle-check me-1"></i>Có sẵn
                                                </span>
                                            </c:when>

                                            <c:when test="${v.status == 'Unavailable'}">
                                                <span class="badge badge-soft-danger rounded-pill px-3 py-2">
                                                    <i class="fa-solid fa-circle-xmark me-1"></i>Tạm ngưng
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-soft-warning rounded-pill px-3 py-2">
                                                    <i class="fa-solid fa-screwdriver-wrench me-1"></i>Bảo trì
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <button class="btn btn-light action-btn text-warning border"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalEditVehicle${v.serviceID}"
                                                title="Sửa">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>

                                        <a href="${pageContext.request.contextPath}/staff/vehicle?action=delete&id=${v.serviceID}"
                                           class="btn btn-light action-btn text-danger border"
                                           onclick="return confirm('Bạn có chắc muốn xóa phương tiện này không?');"
                                           title="Xóa">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>

                                <div class="modal fade" id="modalEditVehicle${v.serviceID}" tabindex="-1">
                                    <div class="modal-dialog modal-xl modal-dialog-centered">
                                        <div class="modal-content border-0 shadow-lg">
                                            <form action="${pageContext.request.contextPath}/staff/vehicle"
                                                  method="POST"
                                                  class="vehicle-form"
                                                  novalidate>
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="serviceID" value="${v.serviceID}">

                                                <div class="modal-header border-0 p-4 pb-2">
                                                    <h5 class="fw-bold mb-0">
                                                        <i class="fa-solid fa-pen-to-square text-warning me-2"></i>
                                                        Cập nhật phương tiện
                                                    </h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>

                                                <div class="modal-body p-4">
                                                    <div class="section-title">Thông tin xe</div>

                                                    <div class="row g-3">
                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Hãng xe</label>
                                                            <select name="brandID" class="form-select" required>
                                                                <option value="">-- Chọn hãng xe --</option>
                                                                <c:forEach var="b" items="${brandList}">
                                                                    <option value="${b.brandID}"
                                                                            <c:if test="${b.brandID == v.brandID}">selected</c:if>>
                                                                            ${b.brandName}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn hãng xe.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Model xe</label>
                                                            <input type="text" name="vehicleModel" class="form-control"
                                                                   value="${v.vehicleModel}" minlength="2" maxlength="255" required>
                                                            <div class="invalid-feedback">Model xe phải từ 2 đến 255 ký tự.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Biển số</label>
                                                            <input type="text" name="licensePlate" class="form-control plate-input"
                                                                   value="${v.licensePlate}"
                                                                   pattern="[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}" required>
                                                            <div class="invalid-feedback">Ví dụ hợp lệ: 29F-1892 hoặc 29K1-9123.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Giá thuê / ngày</label>
                                                            <input type="number" name="pricePerDay" class="form-control"
                                                                   min="1000" max="100000000" step="1000"
                                                                   value="${v.pricePerDay}" required>
                                                            <div class="invalid-feedback">Giá thuê phải từ 1,000 đến 100,000,000 VND/ngày.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Tiền đặt cọc</label>
                                                            <input type="number" name="depositAmount" class="form-control"
                                                                   min="0" max="1000000000" step="1000"
                                                                   value="${v.depositAmount}" required>
                                                            <div class="invalid-feedback">Tiền đặt cọc phải từ 0 đến 1,000,000,000 VND.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" <c:if test="${v.status == 'Available'}">selected</c:if>>Có sẵn</option>
                                                                <option value="Unavailable" <c:if test="${v.status == 'Unavailable'}">selected</c:if>>Tạm ngưng</option>
                                                                <option value="Maintenance" <c:if test="${v.status == 'Maintenance'}">selected</c:if>>Bảo trì</option>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Số chỗ</label>
                                                            <input type="number" name="seatCount" class="form-control"
                                                                   min="1" max="60" value="${v.seatCount}" required>
                                                            <div class="invalid-feedback">Số chỗ không phù hợp với loại xe.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Loại xe</label>
                                                            <select name="vehicleType" class="form-select vehicle-type-select" required>
                                                                <option value="Motorbike" <c:if test="${v.vehicleType == 'Motorbike'}">selected</c:if>>Xe máy</option>
                                                                <option value="Sedan" <c:if test="${v.vehicleType == 'Sedan'}">selected</c:if>>Sedan</option>
                                                                <option value="SUV" <c:if test="${v.vehicleType == 'SUV'}">selected</c:if>>SUV</option>
                                                                <option value="Luxury Sedan" <c:if test="${v.vehicleType == 'Luxury Sedan'}">selected</c:if>>Sedan hạng sang</option>
                                                                <option value="Bus" <c:if test="${v.vehicleType == 'Bus'}">selected</c:if>>Xe khách</option>
                                                                <option value="Limousine" <c:if test="${v.vehicleType == 'Limousine'}">selected</c:if>>Limousine</option>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn loại xe.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Hộp số</label>
                                                            <select name="transmission" class="form-select" required>
                                                                <option value="Automatic" <c:if test="${v.transmission == 'Automatic'}">selected</c:if>>Số tự động</option>
                                                                <option value="Manual" <c:if test="${v.transmission == 'Manual'}">selected</c:if>>Số sàn</option>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn hộp số.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Nhiên liệu</label>
                                                            <select name="fuelType" class="form-select" required>
                                                                <option value="Gasoline" <c:if test="${v.fuelType == 'Gasoline'}">selected</c:if>>Xăng</option>
                                                                <option value="Diesel" <c:if test="${v.fuelType == 'Diesel'}">selected</c:if>>Dầu Diesel</option>
                                                                <option value="Electric" <c:if test="${v.fuelType == 'Electric'}">selected</c:if>>Điện</option>
                                                                <option value="Hybrid" <c:if test="${v.fuelType == 'Hybrid'}">selected</c:if>>Hybrid</option>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn nhiên liệu.</div>
                                                        </div>

                                                        <div class="col-md-8">
                                                            <label class="form-label fw-bold small text-secondary">Link ảnh xe</label>
                                                            <input type="url" name="image" class="form-control"
                                                                   value="${v.image}" required>
                                                            <div class="invalid-feedback">Ảnh xe phải là URL hợp lệ bắt đầu bằng http:// hoặc https://.</div>
                                                        </div>
                                                    </div>

                                                    <div class="section-title">Địa điểm nhận xe</div>

                                                    <div class="row g-3">
                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Tỉnh/thành</label>
                                                            <input type="text" name="pickupProvince" class="form-control"
                                                                   value="${v.pickupProvince}" required>
                                                            <div class="invalid-feedback">Tỉnh/thành phải từ 2 đến 100 ký tự.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Quận/huyện</label>
                                                            <input type="text" name="pickupDistrict" class="form-control"
                                                                   value="${v.pickupDistrict}" required>
                                                            <div class="invalid-feedback">Quận/huyện phải từ 2 đến 100 ký tự.</div>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Phường/xã</label>
                                                            <input type="text" name="pickupWard" class="form-control"
                                                                   value="${v.pickupWard}">
                                                            <div class="invalid-feedback">Phường/xã không được vượt quá 100 ký tự.</div>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label fw-bold small text-secondary">Địa chỉ nhận xe cụ thể</label>
                                                            <input type="text" name="pickupAddress" class="form-control"
                                                                   value="${v.pickupAddress}" maxlength="255" required>
                                                            <div class="invalid-feedback">Địa chỉ nhận xe phải từ 5 đến 255 ký tự.</div>
                                                        </div>
                                                    </div>

                                                    <div class="section-title">Mô tả và lưu ý</div>

                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Mô tả xe</label>
                                                            <textarea name="description" class="form-control"
                                                                      rows="4" required>${v.description}</textarea>
                                                            <div class="invalid-feedback">Mô tả xe phải có ít nhất 10 ký tự.</div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Lưu ý sử dụng</label>
                                                            <textarea name="usageNotes" class="form-control"
                                                                      rows="4" required>${v.usageNotes}</textarea>
                                                            <div class="invalid-feedback">Lưu ý sử dụng phải có ít nhất 10 ký tự.</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer border-0 p-4 pt-0">
                                                    <button type="submit" class="btn btn-primary px-5">
                                                        <i class="fa-solid fa-floppy-disk me-2"></i>Lưu thay đổi
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
    </div>
</div>

<div class="modal fade" id="modalAddVehicle" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <form action="${pageContext.request.contextPath}/staff/vehicle"
                  method="POST"
                  class="vehicle-form"
                  novalidate>
                <input type="hidden" name="action" value="add">

                <div class="modal-header border-0 p-4 pb-2">
                    <h5 class="fw-bold mb-0">
                        <i class="fa-solid fa-car text-primary me-2"></i>
                        Thêm phương tiện mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="section-title">Thông tin xe</div>

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Hãng xe</label>
                            <select name="brandID" class="form-select" required>
                                <option value="">-- Chọn hãng xe --</option>
                                <c:forEach var="b" items="${brandList}">
                                    <option value="${b.brandID}">${b.brandName}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn hãng xe.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Model xe</label>
                            <input type="text" name="vehicleModel" class="form-control"
                                   placeholder="VD: Lead 2025" minlength="2" maxlength="255" required>
                            <div class="invalid-feedback">Model xe phải từ 2 đến 255 ký tự.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Biển số</label>
                            <input type="text" name="licensePlate" class="form-control plate-input"
                                   placeholder="VD: 29K1-9123"
                                   pattern="[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}" required>
                            <div class="invalid-feedback">Ví dụ hợp lệ: 29F-1892 hoặc 29K1-9123.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Giá thuê / ngày</label>
                            <input type="number" name="pricePerDay" class="form-control"
                                   min="1000" max="100000000" step="1000"
                                   placeholder="500000" required>
                            <div class="invalid-feedback">Giá thuê phải từ 1,000 đến 100,000,000 VND/ngày.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Tiền đặt cọc</label>
                            <input type="number" name="depositAmount" class="form-control"
                                   min="0" max="1000000000" step="1000"
                                   value="0" required>
                            <div class="invalid-feedback">Tiền đặt cọc phải từ 0 đến 1,000,000,000 VND.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                            <select name="status" class="form-select" required>
                                <option value="Available">Có sẵn</option>
                                <option value="Unavailable">Tạm ngưng</option>
                                <option value="Maintenance">Bảo trì</option>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Số chỗ</label>
                            <input type="number" name="seatCount" class="form-control"
                                   min="1" max="60" placeholder="2" required>
                            <div class="invalid-feedback">Số chỗ không phù hợp với loại xe.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Loại xe</label>
                            <select name="vehicleType" class="form-select vehicle-type-select" required>
                                <option value="Motorbike">Xe máy</option>
                                <option value="Sedan">Sedan</option>
                                <option value="SUV">SUV</option>
                                <option value="Luxury Sedan">Sedan hạng sang</option>
                                <option value="Bus">Xe khách</option>
                                <option value="Limousine">Limousine</option>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn loại xe.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Hộp số</label>
                            <select name="transmission" class="form-select" required>
                                <option value="Automatic">Số tự động</option>
                                <option value="Manual">Số sàn</option>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn hộp số.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Nhiên liệu</label>
                            <select name="fuelType" class="form-select" required>
                                <option value="Gasoline">Xăng</option>
                                <option value="Diesel">Dầu Diesel</option>
                                <option value="Electric">Điện</option>
                                <option value="Hybrid">Hybrid</option>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhiên liệu.</div>
                        </div>

                        <div class="col-md-8">
                            <label class="form-label fw-bold small text-secondary">Link ảnh xe</label>
                            <input type="url" name="image" class="form-control"
                                   placeholder="https://..." required>
                            <div class="invalid-feedback">Ảnh xe phải là URL hợp lệ bắt đầu bằng http:// hoặc https://.</div>
                        </div>
                    </div>

                    <div class="section-title">Địa điểm nhận xe</div>

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Tỉnh/thành</label>
                            <input type="text" name="pickupProvince" class="form-control"
                                   placeholder="VD: Hà Nội" required>
                            <div class="invalid-feedback">Tỉnh/thành phải từ 2 đến 100 ký tự.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Quận/huyện</label>
                            <input type="text" name="pickupDistrict" class="form-control"
                                   placeholder="VD: Hoàn Kiếm" required>
                            <div class="invalid-feedback">Quận/huyện phải từ 2 đến 100 ký tự.</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Phường/xã</label>
                            <input type="text" name="pickupWard" class="form-control"
                                   placeholder="VD: Hàng Bạc">
                            <div class="invalid-feedback">Phường/xã không được vượt quá 100 ký tự.</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-secondary">Địa chỉ nhận xe cụ thể</label>
                            <input type="text" name="pickupAddress" class="form-control"
                                   placeholder="VD: 25 Hàng Bạc, Hoàn Kiếm, Hà Nội"
                                   maxlength="255" required>
                            <div class="invalid-feedback">Địa chỉ nhận xe phải từ 5 đến 255 ký tự.</div>
                        </div>
                    </div>

                    <div class="section-title">Mô tả và lưu ý</div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Mô tả xe</label>
                            <textarea name="description" class="form-control" rows="4"
                                      placeholder="Mô tả đặc điểm xe, phù hợp cho loại hành trình nào..."
                                      required></textarea>
                            <div class="invalid-feedback">Mô tả xe phải có ít nhất 10 ký tự.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Lưu ý sử dụng</label>
                            <textarea name="usageNotes" class="form-control" rows="4"
                                      placeholder="VD: kiểm tra xe trước khi nhận, hoàn trả đúng giờ..."
                                      required></textarea>
                            <div class="invalid-feedback">Lưu ý sử dụng phải có ít nhất 10 ký tự.</div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="submit" class="btn btn-primary px-5">
                        <i class="fa-solid fa-plus me-2"></i>Thêm phương tiện
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<c:if test="${sessionScope.openModal == 'addVehicle'}">
    <script>
        window.addEventListener("load", function () {
            const modal = new bootstrap.Modal(document.getElementById("modalAddVehicle"));
            modal.show();
        });
    </script>
    <c:remove var="openModal" scope="session"/>
</c:if>

<c:if test="${sessionScope.openModal == 'editVehicle'}">
    <script>
        window.addEventListener("load", function () {
            const modalId = "modalEditVehicle${sessionScope.editServiceID}";
            const modalElement = document.getElementById(modalId);

            if (modalElement) {
                const modal = new bootstrap.Modal(modalElement);
                modal.show();
            }
        });
    </script>
    <c:remove var="openModal" scope="session"/>
    <c:remove var="editServiceID" scope="session"/>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function normalizeVehicleText(value) {
        return (value || "")
            .toString()
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim();
    }

    function filterVehicleTable() {
        const keyword = normalizeVehicleText(document.getElementById("vehicleSearchInput").value);
        const type = normalizeVehicleText(document.getElementById("vehicleTypeFilter").value);
        const transmission = normalizeVehicleText(document.getElementById("vehicleTransmissionFilter").value);
        const fuel = normalizeVehicleText(document.getElementById("vehicleFuelFilter").value);
        const status = normalizeVehicleText(document.getElementById("vehicleStatusFilter").value);

        const rows = document.querySelectorAll("#vehicleTable tbody tr[data-vehicle-search]");

        rows.forEach(function (row) {
            const rowText = normalizeVehicleText(row.dataset.vehicleSearch);
            const rowType = normalizeVehicleText(row.dataset.vehicleType);
            const rowTransmission = normalizeVehicleText(row.dataset.vehicleTransmission);
            const rowFuel = normalizeVehicleText(row.dataset.vehicleFuel);
            const rowStatus = normalizeVehicleText(row.dataset.vehicleStatus);

            const matchKeyword = !keyword || rowText.includes(keyword);
            const matchType = !type || rowType === type;
            const matchTransmission = !transmission || rowTransmission === transmission;
            const matchFuel = !fuel || rowFuel === fuel;
            const matchStatus = !status || rowStatus === status;

            row.style.display =
                matchKeyword &&
                matchType &&
                matchTransmission &&
                matchFuel &&
                matchStatus
                    ? ""
                    : "none";
        });
    }

    function resetVehicleFilter() {
        document.getElementById("vehicleSearchInput").value = "";
        document.getElementById("vehicleTypeFilter").value = "";
        document.getElementById("vehicleTransmissionFilter").value = "";
        document.getElementById("vehicleFuelFilter").value = "";
        document.getElementById("vehicleStatusFilter").value = "";
        filterVehicleTable();
    }

    document.addEventListener("DOMContentLoaded", function () {
        const filterIds = [
            "vehicleSearchInput",
            "vehicleTypeFilter",
            "vehicleTransmissionFilter",
            "vehicleFuelFilter",
            "vehicleStatusFilter"
        ];

        filterIds.forEach(function (id) {
            const element = document.getElementById(id);

            if (!element) {
                return;
            }

            element.addEventListener("input", filterVehicleTable);
            element.addEventListener("change", filterVehicleTable);
        });
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const forms = document.querySelectorAll(".vehicle-form");

        function setValid(input) {
            input.classList.remove("is-invalid");
            input.classList.add("is-valid");
        }

        function setInvalid(input) {
            input.classList.remove("is-valid");
            input.classList.add("is-invalid");
        }

        function isBlank(value) {
            return !value || value.trim().length === 0;
        }

        function validateText(input, min, max, message) {
            if (!input) return true;

            const value = input.value.trim();
            const feedback = getFeedback(input);

            if (feedback && message) {
                feedback.textContent = message;
            }

            if (value.length < min || value.length > max) {
                setInvalid(input);
                return false;
            }

            setValid(input);
            return true;
        }

        function validateRequiredSelect(input) {
            if (!input) return true;

            if (isBlank(input.value)) {
                setInvalid(input);
                return false;
            }

            setValid(input);
            return true;
        }

        function validatePlate(input) {
            if (!input) return true;

            input.value = input.value.toUpperCase();

            const value = input.value.trim();
            const plateRegex = /^[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}$/;

            if (!plateRegex.test(value)) {
                setInvalid(input);
                return false;
            }

            setValid(input);
            return true;
        }

        function validateUrl(input) {
            if (!input) return true;

            const value = input.value.trim();
            const urlRegex = /^https?:\/\/.+/;

            if (!urlRegex.test(value) || value.length > 500) {
                setInvalid(input);
                return false;
            }

            setValid(input);
            return true;
        }

        function validateNumber(input, min, max) {
            if (!input) return true;

            const value = Number(input.value);

            if (input.value === "" || Number.isNaN(value) || value < min || value > max) {
                setInvalid(input);
                return false;
            }

            setValid(input);
            return true;
        }

        function getSeatRangeByVehicleType(vehicleType) {
            switch (vehicleType) {
                case "Motorbike":
                    return {min: 1, max: 2, message: "Xe máy chỉ được nhập từ 1 đến 2 chỗ."};
                case "Sedan":
                    return {min: 4, max: 5, message: "Xe Sedan chỉ được nhập từ 4 đến 5 chỗ."};
                case "SUV":
                    return {min: 5, max: 8, message: "Xe SUV chỉ được nhập từ 5 đến 8 chỗ."};
                case "Luxury Sedan":
                    return {min: 4, max: 5, message: "Xe Sedan hạng sang chỉ được nhập từ 4 đến 5 chỗ."};
                case "Bus":
                    return {min: 16, max: 60, message: "Xe khách chỉ được nhập từ 16 đến 60 chỗ."};
                case "Limousine":
                    return {min: 9, max: 16, message: "Xe Limousine chỉ được nhập từ 9 đến 16 chỗ."};
                default:
                    return {min: 1, max: 60, message: "Số chỗ không phù hợp với loại xe."};
            }
        }

        function validateSeatByVehicleType(seatInput, typeInput) {
            if (!seatInput || !typeInput) return true;

            const range = getSeatRangeByVehicleType(typeInput.value);
            const value = Number(seatInput.value);
            const feedback = getFeedback(seatInput);

            if (feedback) {
                feedback.textContent = range.message;
            }

            if (seatInput.value === "" || Number.isNaN(value) || value < range.min || value > range.max) {
                setInvalid(seatInput);
                return false;
            }

            setValid(seatInput);
            return true;
        }

        function getFeedback(input) {
            const parent = input.closest(".col-md-4, .col-md-6, .col-md-8, .col-12");
            return parent ? parent.querySelector(".invalid-feedback") : null;
        }

        function bindRealtime(input, validateFunction) {
            if (!input) return;

            input.addEventListener("input", function () {
                validateFunction(input);
            });

            input.addEventListener("change", function () {
                validateFunction(input);
            });

            input.addEventListener("blur", function () {
                validateFunction(input);
            });
        }

        forms.forEach(function (form) {
            const brandID = form.querySelector("[name='brandID']");
            const vehicleModel = form.querySelector("[name='vehicleModel']");
            const licensePlate = form.querySelector("[name='licensePlate']");
            const pricePerDay = form.querySelector("[name='pricePerDay']");
            const depositAmount = form.querySelector("[name='depositAmount']");
            const status = form.querySelector("[name='status']");
            const image = form.querySelector("[name='image']");
            const seatCount = form.querySelector("[name='seatCount']");
            const vehicleType = form.querySelector("[name='vehicleType']");
            const transmission = form.querySelector("[name='transmission']");
            const fuelType = form.querySelector("[name='fuelType']");
            const pickupProvince = form.querySelector("[name='pickupProvince']");
            const pickupDistrict = form.querySelector("[name='pickupDistrict']");
            const pickupWard = form.querySelector("[name='pickupWard']");
            const pickupAddress = form.querySelector("[name='pickupAddress']");
            const description = form.querySelector("[name='description']");
            const usageNotes = form.querySelector("[name='usageNotes']");

            bindRealtime(brandID, validateRequiredSelect);

            bindRealtime(vehicleModel, function (input) {
                return validateText(input, 2, 255, "Model xe phải từ 2 đến 255 ký tự.");
            });

            bindRealtime(licensePlate, validatePlate);

            bindRealtime(pricePerDay, function (input) {
                return validateNumber(input, 1000, 100000000);
            });

            bindRealtime(depositAmount, function (input) {
                return validateNumber(input, 0, 1000000000);
            });

            bindRealtime(status, validateRequiredSelect);
            bindRealtime(image, validateUrl);

            bindRealtime(seatCount, function () {
                return validateSeatByVehicleType(seatCount, vehicleType);
            });

            if (vehicleType) {
                vehicleType.addEventListener("change", function () {
                    validateRequiredSelect(vehicleType);
                    validateSeatByVehicleType(seatCount, vehicleType);
                });
            }

            bindRealtime(vehicleType, validateRequiredSelect);
            bindRealtime(transmission, validateRequiredSelect);
            bindRealtime(fuelType, validateRequiredSelect);

            bindRealtime(pickupProvince, function (input) {
                return validateText(input, 2, 100, "Tỉnh/thành phải từ 2 đến 100 ký tự.");
            });

            bindRealtime(pickupDistrict, function (input) {
                return validateText(input, 2, 100, "Quận/huyện phải từ 2 đến 100 ký tự.");
            });

            bindRealtime(pickupWard, function (input) {
                if (!input) return true;

                if (input.value.trim().length > 100) {
                    setInvalid(input);
                    return false;
                }

                input.classList.remove("is-invalid");

                if (input.value.trim().length > 0) {
                    input.classList.add("is-valid");
                } else {
                    input.classList.remove("is-valid");
                }

                return true;
            });

            bindRealtime(pickupAddress, function (input) {
                return validateText(input, 5, 255, "Địa chỉ nhận xe phải từ 5 đến 255 ký tự.");
            });

            bindRealtime(description, function (input) {
                return validateText(input, 10, 5000, "Mô tả xe phải có ít nhất 10 ký tự.");
            });

            bindRealtime(usageNotes, function (input) {
                return validateText(input, 10, 5000, "Lưu ý sử dụng phải có ít nhất 10 ký tự.");
            });

            form.addEventListener("submit", function (event) {
                const checks = [
                    validateRequiredSelect(brandID),
                    validateText(vehicleModel, 2, 255, "Model xe phải từ 2 đến 255 ký tự."),
                    validatePlate(licensePlate),
                    validateNumber(pricePerDay, 1000, 100000000),
                    validateNumber(depositAmount, 0, 1000000000),
                    validateRequiredSelect(status),
                    validateUrl(image),
                    validateSeatByVehicleType(seatCount, vehicleType),
                    validateRequiredSelect(vehicleType),
                    validateRequiredSelect(transmission),
                    validateRequiredSelect(fuelType),
                    validateText(pickupProvince, 2, 100, "Tỉnh/thành phải từ 2 đến 100 ký tự."),
                    validateText(pickupDistrict, 2, 100, "Quận/huyện phải từ 2 đến 100 ký tự."),
                    pickupWard.value.trim().length <= 100,
                    validateText(pickupAddress, 5, 255, "Địa chỉ nhận xe phải từ 5 đến 255 ký tự."),
                    validateText(description, 10, 5000, "Mô tả xe phải có ít nhất 10 ký tự."),
                    validateText(usageNotes, 10, 5000, "Lưu ý sử dụng phải có ít nhất 10 ký tự.")
                ];

                const isValid = checks.every(Boolean);

                if (!isValid) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                form.classList.add("was-validated");
            });
        });
    });
</script>
</body>
</html>