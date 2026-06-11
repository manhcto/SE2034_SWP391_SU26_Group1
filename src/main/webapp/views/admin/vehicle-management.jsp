<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVn | Quản lý phương tiện</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
        }

        .page-header {
            background: linear-gradient(135deg, #0f172a, #4e46dc);
            border-radius: 22px;
            padding: 28px;
            color: white;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.25);
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

        .vehicle-icon {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            background: linear-gradient(135deg, #4e46dc, #7c3aed);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
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

        .plate-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 7px 12px;
            font-weight: 700;
            color: #334155;
            display: inline-block;
        }

        .invalid-feedback {
            font-size: 13px;
            font-weight: 600;
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
                    <i class="fa-solid fa-circle-exclamation me-2"></i> Thao tác thất bại. Vui lòng kiểm tra lại dữ liệu.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <div class="page-header mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1">
                <i class="fa-solid fa-car-side me-2"></i> Quản lý phương tiện
            </h2>
            <p class="mb-0 opacity-75">Quản lý xe cho thuê, biển số, giá thuê và trạng thái sử dụng.</p>
        </div>

        <button class="btn btn-light text-primary fw-bold px-4 py-2 shadow-sm"
                data-bs-toggle="modal" data-bs-target="#modalAddVehicle">
            <i class="fa-solid fa-plus me-2"></i> Thêm phương tiện
        </button>
    </div>

    <div class="card card-custom">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th class="ps-4">Dịch vụ</th>
                        <th>Hãng xe / Tên xe</th>
                        <th>Biển số</th>
                        <th>Giá thuê</th>
                        <th>Trạng thái</th>
                        <th class="text-end pe-4">Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty vehicleList}">
                            <tr>
                                <td colspan="6" class="text-center empty-box">
                                    <i class="fa-solid fa-car-burst fa-3x text-secondary opacity-50 mb-3"></i>
                                    <h6 class="fw-bold text-secondary">Chưa có phương tiện nào</h6>
                                    <p class="text-muted mb-0">Hãy thêm xe đầu tiên vào hệ thống.</p>
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="v" items="${vehicleList}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-secondary">#V-${v.serviceID}</div>
                                        <small class="text-muted">
                                                ${v.serviceDetails.serviceType} - ${v.serviceDetails.fulfillmentType}
                                        </small>
                                    </td>

                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="vehicle-icon me-3">
                                                <i class="fa-solid fa-car"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark">${v.vehicleBrand}</div>
                                                <small class="text-muted">${v.serviceDetails.serviceName}</small>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <span class="plate-box">${v.licensePlate}</span>
                                    </td>

                                    <td>
                                        <div class="fw-bold text-primary">
                                            <fmt:formatNumber value="${v.pricePerDay}" type="number" maxFractionDigits="0"/> VND
                                        </div>
                                        <small class="text-muted">/ ngày</small>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${v.status == 'Available'}">
                                                <span class="badge badge-soft-success rounded-pill px-3 py-2">
                                                    <i class="fa-solid fa-circle-check me-1"></i>Available
                                                </span>
                                            </c:when>

                                            <c:when test="${v.status == 'Unavailable'}">
                                                <span class="badge badge-soft-danger rounded-pill px-3 py-2">
                                                    <i class="fa-solid fa-circle-xmark me-1"></i>Unavailable
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-soft-warning rounded-pill px-3 py-2">
                                                    <i class="fa-solid fa-screwdriver-wrench me-1"></i>${v.status}
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
                                    <div class="modal-dialog modal-dialog-centered">
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
                                                    <div class="row g-3">
                                                        <div class="col-12">
                                                            <label class="form-label fw-bold small text-secondary">Hãng xe & tên xe</label>
                                                            <input type="text"
                                                                   name="vBrand"
                                                                   class="form-control vehicle-brand-input"
                                                                   value="${v.vehicleBrand}"
                                                                   minlength="2"
                                                                   maxlength="255"
                                                                   required>
                                                            <div class="invalid-feedback">
                                                                Tên xe phải từ 2 đến 255 ký tự.
                                                            </div>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label fw-bold small text-secondary">Biển số xe</label>
                                                            <input type="text"
                                                                   name="vPlate"
                                                                   class="form-control vehicle-plate-input"
                                                                   value="${v.licensePlate}"
                                                                   maxlength="20"
                                                                   pattern="[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}"
                                                                   required>
                                                            <div class="invalid-feedback">
                                                                Biển số xe không đúng định dạng. Ví dụ: 29F-1892 hoặc 29K1-9123.
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Giá thuê / ngày</label>
                                                            <div class="input-group">
                                                                <input type="number"
                                                                       name="vPrice"
                                                                       class="form-control vehicle-price-input"
                                                                       min="1000"
                                                                       max="100000000"
                                                                       step="1000"
                                                                       value="${v.pricePerDay}"
                                                                       required>
                                                                <span class="input-group-text">VND</span>
                                                                <div class="invalid-feedback">
                                                                    Giá thuê xe phải từ 1,000 đến 100,000,000 VND/ngày.
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                                                            <select name="vStatus" class="form-select" required>
                                                                <option value="Available" <c:if test="${v.status == 'Available'}">selected</c:if>>Available</option>
                                                                <option value="Unavailable" <c:if test="${v.status == 'Unavailable'}">selected</c:if>>Unavailable</option>
                                                                <option value="Maintenance" <c:if test="${v.status == 'Maintenance'}">selected</c:if>>Maintenance</option>
                                                            </select>
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

<div class="modal fade" id="modalAddVehicle" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
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
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold small text-secondary">Hãng xe & tên xe</label>
                            <input type="text"
                                   name="vBrand"
                                   class="form-control vehicle-brand-input"
                                   placeholder="VD: Honda Civic"
                                   minlength="2"
                                   maxlength="255"
                                   required>
                            <div class="invalid-feedback">
                                Tên xe phải từ 2 đến 255 ký tự.
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-secondary">Biển số xe</label>
                            <input type="text"
                                   name="vPlate"
                                   class="form-control vehicle-plate-input"
                                   placeholder="VD: 29K1-9123"
                                   maxlength="20"
                                   pattern="[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}"
                                   required>
                            <div class="invalid-feedback">
                                Biển số xe không đúng định dạng. Ví dụ: 29F-1892 hoặc 29K1-9123.
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Giá thuê / ngày</label>
                            <div class="input-group">
                                <input type="number"
                                       name="vPrice"
                                       class="form-control vehicle-price-input"
                                       min="1000"
                                       max="100000000"
                                       step="1000"
                                       placeholder="500000"
                                       required>
                                <span class="input-group-text">VND</span>
                                <div class="invalid-feedback">
                                    Giá thuê xe phải từ 1,000 đến 100,000,000 VND/ngày.
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                            <select name="vStatus" class="form-select" required>
                                <option value="Available">Available</option>
                                <option value="Unavailable">Unavailable</option>
                                <option value="Maintenance">Maintenance</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary px-5">
                        <i class="fa-solid fa-plus me-2"></i>Thêm phương tiện
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const vehicleForms = document.querySelectorAll(".vehicle-form");

        vehicleForms.forEach(function (form) {
            const brandInput = form.querySelector("input[name='vBrand']");
            const plateInput = form.querySelector("input[name='vPlate']");
            const priceInput = form.querySelector("input[name='vPrice']");

            function setInvalid(input) {
                input.classList.add("is-invalid");
                input.classList.remove("is-valid");
            }

            function setValid(input) {
                input.classList.remove("is-invalid");
                input.classList.add("is-valid");
            }

            function validateBrand() {
                if (!brandInput) return true;

                const value = brandInput.value.trim();

                if (value.length < 2 || value.length > 255) {
                    setInvalid(brandInput);
                    return false;
                }

                setValid(brandInput);
                return true;
            }

            function validatePlate() {
                if (!plateInput) return true;

                plateInput.value = plateInput.value.toUpperCase();

                const value = plateInput.value.trim();
                const plateRegex = /^[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}$/;

                if (!plateRegex.test(value)) {
                    setInvalid(plateInput);
                    return false;
                }

                setValid(plateInput);
                return true;
            }

            function validatePrice() {
                if (!priceInput) return true;

                const price = Number(priceInput.value);

                if (!priceInput.value || price < 1000 || price > 100000000) {
                    setInvalid(priceInput);
                    return false;
                }

                setValid(priceInput);
                return true;
            }

            if (brandInput) {
                brandInput.addEventListener("input", validateBrand);
                brandInput.addEventListener("blur", validateBrand);
            }

            if (plateInput) {
                plateInput.addEventListener("input", validatePlate);
                plateInput.addEventListener("blur", validatePlate);
            }

            if (priceInput) {
                priceInput.addEventListener("input", validatePrice);
                priceInput.addEventListener("blur", validatePrice);
            }

            form.addEventListener("submit", function (event) {
                const okBrand = validateBrand();
                const okPlate = validatePlate();
                const okPrice = validatePrice();

                if (!okBrand || !okPlate || !okPrice) {
                    event.preventDefault();
                    event.stopPropagation();
                }
            });
        });
    });
</script>
</body>
</html>