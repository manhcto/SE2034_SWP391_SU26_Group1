<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVn | Quản lý lưu trú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
        }

        .page-header {
            background: linear-gradient(135deg, #4e46dc, #6c63ff);
            border-radius: 22px;
            padding: 28px;
            color: white;
            box-shadow: 0 12px 30px rgba(78, 70, 220, 0.25);
        }

        .btn-primary {
            background-color: #4e46dc;
            border-color: #4e46dc;
        }

        .btn-primary:hover {
            background-color: #3b34b6;
            border-color: #3b34b6;
        }

        .card-custom {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .table thead th {
            font-size: 12px;
            letter-spacing: 0.6px;
            color: #64748b;
            text-transform: uppercase;
            background: #f8fafc;
        }

        .hotel-img {
            width: 78px;
            height: 54px;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid #e5e7eb;
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
            width: 34px;
            height: 34px;
            border-radius: 10px;
        }

        .form-control, .form-select {
            border-radius: 12px;
            padding: 10px 12px;
        }

        .modal-content {
            border-radius: 22px;
        }

        .empty-box {
            padding: 56px 20px;
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
                    <i class="fa-solid fa-circle-check me-2"></i> Thêm cơ sở lưu trú thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'updateSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-check me-2"></i> Cập nhật cơ sở lưu trú thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'deleteSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-trash me-2"></i> Xóa cơ sở lưu trú thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'validationFail'}"></c:when>

            <c:otherwise>
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> Thao tác thất bại. Vui lòng kiểm tra lại dữ liệu.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <div class="page-header mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1">
                <i class="fa-solid fa-hotel me-2"></i> Quản lý nơi lưu trú
            </h2>
            <p class="mb-0 opacity-75">Quản lý khách sạn, homestay, resort và trạng thái hoạt động.</p>
        </div>

        <button class="btn btn-light text-primary fw-bold px-4 py-2 shadow-sm"
                data-bs-toggle="modal" data-bs-target="#modalAddAccommodation">
            <i class="fa-solid fa-plus me-2"></i> Thêm lưu trú
        </button>
    </div>

    <div class="card card-custom">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th class="ps-4">Thông tin</th>
                        <th>Liên hệ</th>
                        <th>Loại hình</th>
                        <th>Check-in/out</th>
                        <th>Đánh giá</th>
                        <th>Trạng thái</th>
                        <th class="text-end pe-4">Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty accommodationList}">
                            <tr>
                                <td colspan="7" class="text-center empty-box">
                                    <i class="fa-solid fa-hotel fa-3x text-secondary opacity-50 mb-3"></i>
                                    <h6 class="fw-bold text-secondary">Chưa có cơ sở lưu trú nào</h6>
                                    <p class="text-muted mb-0">Hãy thêm khách sạn hoặc homestay đầu tiên.</p>
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="acc" items="${accommodationList}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <img src="${acc.image}" class="hotel-img me-3"
                                                 onerror="this.src='https://placehold.co/120x80?text=Hotel';">
                                            <div>
                                                <div class="fw-bold text-dark">${acc.name}</div>
                                                <small class="text-muted">Service ID: #${acc.serviceID}</small>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <div class="fw-semibold text-dark">
                                            <i class="fa-solid fa-location-dot text-danger me-1"></i>${acc.address}
                                        </div>
                                        <small class="text-muted">
                                            <i class="fa-solid fa-phone me-1"></i>${acc.phone}
                                        </small>
                                    </td>

                                    <td>
                                        <span class="badge rounded-pill bg-light text-dark border px-3 py-2">
                                                ${acc.type}
                                        </span>
                                    </td>

                                    <td>
                                        <small class="d-block text-muted">
                                            <i class="fa-regular fa-clock me-1"></i> In: ${acc.checkInTime}
                                        </small>
                                        <small class="d-block text-muted">
                                            <i class="fa-regular fa-clock me-1"></i> Out: ${acc.checkOutTime}
                                        </small>
                                    </td>

                                    <td>
                                        <span class="fw-bold text-warning">
                                            <i class="fa-solid fa-star me-1"></i>${acc.rate}
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${acc.status == 'Available'}">
                                                <span class="badge badge-soft-success rounded-pill px-3 py-2">Available</span>
                                            </c:when>

                                            <c:when test="${acc.status == 'Maintenance'}">
                                                <span class="badge badge-soft-warning rounded-pill px-3 py-2">Maintenance</span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-soft-danger rounded-pill px-3 py-2">${acc.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/staff/accommodation?action=view&id=${acc.serviceID}"
                                           class="btn btn-light action-btn text-info border"
                                           title="Xem phòng">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>

                                        <button class="btn btn-light action-btn text-warning border"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalEditAccommodation${acc.serviceID}"
                                                title="Sửa">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>

                                        <a href="${pageContext.request.contextPath}/staff/accommodation?action=delete&id=${acc.serviceID}"
                                           class="btn btn-light action-btn text-danger border"
                                           onclick="return confirm('Bạn có chắc muốn xóa cơ sở lưu trú này không? Các phòng thuộc cơ sở này cũng sẽ bị xóa.');"
                                           title="Xóa">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>

                                <div class="modal fade" id="modalEditAccommodation${acc.serviceID}" tabindex="-1">
                                    <div class="modal-dialog modal-lg modal-dialog-centered">
                                        <div class="modal-content border-0 shadow-lg">
                                            <form action="${pageContext.request.contextPath}/staff/accommodation" method="POST">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="serviceID" value="${acc.serviceID}">

                                                <div class="modal-header border-0 p-4 pb-2">
                                                    <h5 class="fw-bold mb-0">
                                                        <i class="fa-solid fa-pen-to-square text-warning me-2"></i>
                                                        Cập nhật lưu trú
                                                    </h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>

                                                <div class="modal-body p-4">
                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Tên lưu trú</label>
                                                            <input type="text"
                                                                   name="accName"
                                                                   class="form-control"
                                                                   value="${acc.name}"
                                                                   minlength="2"
                                                                   maxlength="255"
                                                                   required>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Link ảnh</label>
                                                            <input type="url"
                                                                   name="accImage"
                                                                   class="form-control"
                                                                   value="${acc.image}"
                                                                   required>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label fw-bold small text-secondary">Địa chỉ</label>
                                                            <input type="text"
                                                                   name="accAddress"
                                                                   class="form-control"
                                                                   value="${acc.address}"
                                                                   minlength="5"
                                                                   maxlength="255"
                                                                   required>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Số điện thoại</label>
                                                            <input type="text"
                                                                   name="accPhone"
                                                                   class="form-control"
                                                                   value="${acc.phone}"
                                                                   pattern="[0-9]{8,11}"
                                                                   title="Số điện thoại chỉ gồm 8 đến 11 chữ số"
                                                                   required>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Loại hình</label>
                                                            <select name="accType" class="form-select" required>
                                                                <option value="Khách sạn" <c:if test="${acc.type == 'Khách sạn'}">selected</c:if>>Khách sạn</option>
                                                                <option value="Homestay" <c:if test="${acc.type == 'Homestay'}">selected</c:if>>Homestay</option>
                                                                <option value="Resort" <c:if test="${acc.type == 'Resort'}">selected</c:if>>Resort</option>
                                                                <option value="Apartment" <c:if test="${acc.type == 'Apartment'}">selected</c:if>>Apartment</option>
                                                            </select>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                                                            <select name="accStatus" class="form-select" required>
                                                                <option value="Available" <c:if test="${acc.status == 'Available'}">selected</c:if>>Available</option>
                                                                <option value="Unavailable" <c:if test="${acc.status == 'Unavailable'}">selected</c:if>>Unavailable</option>
                                                                <option value="Maintenance" <c:if test="${acc.status == 'Maintenance'}">selected</c:if>>Maintenance</option>
                                                            </select>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Check-in</label>
                                                            <input type="time"
                                                                   name="accCheckIn"
                                                                   class="form-control"
                                                                   value="${acc.checkInTime}"
                                                                   required>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Check-out</label>
                                                            <input type="time"
                                                                   name="accCheckOut"
                                                                   class="form-control"
                                                                   value="${acc.checkOutTime}"
                                                                   required>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <label class="form-label fw-bold small text-secondary">Rate</label>
                                                            <input type="number"
                                                                   name="accRate"
                                                                   class="form-control"
                                                                   min="0"
                                                                   max="5"
                                                                   step="0.1"
                                                                   value="${acc.rate}"
                                                                   required>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label fw-bold small text-secondary">Mô tả</label>
                                                            <textarea name="accDesc"
                                                                      class="form-control"
                                                                      rows="3"
                                                                      maxlength="2000">${acc.description}</textarea>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="modal-footer border-0 p-4 pt-0">
                                                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Đóng</button>
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

<div class="modal fade" id="modalAddAccommodation" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <form action="${pageContext.request.contextPath}/staff/accommodation" method="POST">
                <input type="hidden" name="action" value="add">

                <div class="modal-header border-0 p-4 pb-2">
                    <h5 class="fw-bold mb-0">
                        <i class="fa-solid fa-circle-plus text-primary me-2"></i>
                        Thêm cơ sở lưu trú mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Tên khách sạn / Homestay</label>
                            <input type="text"
                                   name="accName"
                                   class="form-control"
                                   placeholder="VD: Wonder Hotel"
                                   minlength="2"
                                   maxlength="255"
                                   required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Link ảnh minh họa</label>
                            <input type="url"
                                   name="accImage"
                                   class="form-control"
                                   placeholder="https://..."
                                   required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-secondary">Địa chỉ</label>
                            <input type="text"
                                   name="accAddress"
                                   class="form-control"
                                   placeholder="VD: 46 Hòa Lạc"
                                   minlength="5"
                                   maxlength="255"
                                   required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Số điện thoại</label>
                            <input type="text"
                                   name="accPhone"
                                   class="form-control"
                                   placeholder="19009055"
                                   pattern="[0-9]{8,11}"
                                   title="Số điện thoại chỉ gồm 8 đến 11 chữ số"
                                   required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Loại hình</label>
                            <select name="accType" class="form-select" required>
                                <option value="Khách sạn">Khách sạn</option>
                                <option value="Homestay">Homestay</option>
                                <option value="Resort">Resort</option>
                                <option value="Apartment">Apartment</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                            <select name="accStatus" class="form-select" required>
                                <option value="Available">Available</option>
                                <option value="Unavailable">Unavailable</option>
                                <option value="Maintenance">Maintenance</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Check-in</label>
                            <input type="time" name="accCheckIn" class="form-control" value="14:00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Check-out</label>
                            <input type="time" name="accCheckOut" class="form-control" value="12:00" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold small text-secondary">Rate</label>
                            <input type="number"
                                   name="accRate"
                                   class="form-control"
                                   min="0"
                                   max="5"
                                   step="0.1"
                                   value="5.0"
                                   required>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-secondary">Mô tả</label>
                            <textarea name="accDesc"
                                      class="form-control"
                                      rows="3"
                                      maxlength="2000"
                                      placeholder="Mô tả tiện ích, vị trí, dịch vụ..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary px-5">
                        <i class="fa-solid fa-plus me-2"></i>Thêm lưu trú
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>