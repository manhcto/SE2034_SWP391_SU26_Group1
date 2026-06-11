<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVn | Chi tiết lưu trú</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            font-family: Arial, sans-serif;
        }

        .hero-card {
            border: none;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 12px 32px rgba(15, 23, 42, 0.12);
        }

        .hero-img {
            width: 100%;
            height: 260px;
            object-fit: cover;
        }

        .info-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .btn-primary {
            background-color: #4e46dc;
            border-color: #4e46dc;
        }

        .btn-primary:hover {
            background-color: #3b34b6;
            border-color: #3b34b6;
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

        .room-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: linear-gradient(135deg, #4e46dc, #7c3aed);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-control, .form-select {
            border-radius: 12px;
            padding: 10px 12px;
        }

        .modal-content {
            border-radius: 22px;
        }

        .action-btn {
            width: 34px;
            height: 34px;
            border-radius: 10px;
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
            <c:when test="${param.status == 'addRoomSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-check me-2"></i> Thêm phòng thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'updateRoomSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-circle-check me-2"></i> Cập nhật phòng thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>

            <c:when test="${param.status == 'deleteRoomSuccess'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4">
                    <i class="fa-solid fa-trash me-2"></i> Xóa phòng thành công.
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

    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/staff/accommodation?action=list"
           class="btn btn-light border rounded-4 px-4">
            <i class="fa-solid fa-arrow-left me-2"></i> Quay lại danh sách
        </a>
    </div>

    <div class="card hero-card mb-4">
        <div class="row g-0">
            <div class="col-md-4">
                <img src="${accommodation.image}" class="hero-img"
                     onerror="this.src='https://placehold.co/600x400?text=Accommodation';">
            </div>

            <div class="col-md-8">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h2 class="fw-bold mb-2">${accommodation.name}</h2>

                            <p class="text-muted mb-2">
                                <i class="fa-solid fa-location-dot text-danger me-2"></i>
                                ${accommodation.address}
                            </p>

                            <p class="text-muted mb-2">
                                <i class="fa-solid fa-phone me-2"></i>
                                ${accommodation.phone}
                            </p>
                        </div>

                        <c:choose>
                            <c:when test="${accommodation.status == 'Available'}">
                                <span class="badge badge-soft-success rounded-pill px-3 py-2">Available</span>
                            </c:when>

                            <c:when test="${accommodation.status == 'Maintenance'}">
                                <span class="badge badge-soft-warning rounded-pill px-3 py-2">Maintenance</span>
                            </c:when>

                            <c:otherwise>
                                <span class="badge badge-soft-danger rounded-pill px-3 py-2">
                                        ${accommodation.status}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <hr>

                    <div class="row g-3">
                        <div class="col-md-3">
                            <small class="text-muted">Service ID</small>
                            <div class="fw-bold">#${accommodation.serviceID}</div>
                        </div>

                        <div class="col-md-3">
                            <small class="text-muted">Loại hình</small>
                            <div class="fw-bold">${accommodation.type}</div>
                        </div>

                        <div class="col-md-3">
                            <small class="text-muted">Check-in</small>
                            <div class="fw-bold">${accommodation.checkInTime}</div>
                        </div>

                        <div class="col-md-3">
                            <small class="text-muted">Check-out</small>
                            <div class="fw-bold">${accommodation.checkOutTime}</div>
                        </div>

                        <div class="col-md-3">
                            <small class="text-muted">Rate</small>
                            <div class="fw-bold text-warning">
                                <i class="fa-solid fa-star me-1"></i>${accommodation.rate}
                            </div>
                        </div>

                        <div class="col-md-9">
                            <small class="text-muted">Mô tả</small>
                            <div class="fw-semibold">${accommodation.description}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ROOM LIST -->
    <div class="card info-card">
        <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
            <div>
                <h4 class="fw-bold mb-1">
                    <i class="fa-solid fa-bed text-primary me-2"></i>
                    Danh sách phòng
                </h4>
                <p class="text-muted mb-0">Quản lý phòng thuộc cơ sở lưu trú này.</p>
            </div>

            <button class="btn btn-primary px-4 py-2 fw-bold"
                    data-bs-toggle="modal" data-bs-target="#modalAddRoom">
                <i class="fa-solid fa-plus me-2"></i> Thêm phòng
            </button>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th class="ps-4">Phòng</th>
                        <th>Số lượng</th>
                        <th>Giá phòng</th>
                        <th>Còn trống</th>
                        <th>Trạng thái</th>
                        <th class="text-end pe-4">Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${empty roomList}">
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <i class="fa-solid fa-bed fa-3x text-secondary opacity-50 mb-3"></i>
                                    <h6 class="fw-bold text-secondary">Chưa có phòng nào</h6>
                                    <p class="text-muted mb-0">Hãy thêm phòng đầu tiên cho cơ sở này.</p>
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="room" items="${roomList}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="room-icon me-3">
                                                <i class="fa-solid fa-bed"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">${room.roomType}</div>
                                                <small class="text-muted">Room ID: #${room.roomID}</small>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="fw-bold">${room.numberOfRooms}</td>

                                    <td class="fw-bold text-primary">
                                        <fmt:formatNumber value="${room.priceOfRoom}" type="number" maxFractionDigits="0"/> VND
                                    </td>

                                    <td class="fw-bold">${room.roomAvailability}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${room.status == 'Available'}">
                                                <span class="badge badge-soft-success rounded-pill px-3 py-2">Available</span>
                                            </c:when>

                                            <c:when test="${room.status == 'Maintenance'}">
                                                <span class="badge badge-soft-warning rounded-pill px-3 py-2">Maintenance</span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-soft-danger rounded-pill px-3 py-2">
                                                        ${room.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <button class="btn btn-light action-btn text-warning border"
                                                data-bs-toggle="modal"
                                                data-bs-target="#modalEditRoom${room.roomID}">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>

                                        <a href="${pageContext.request.contextPath}/staff/room?action=delete&id=${room.roomID}&serviceID=${accommodation.serviceID}"
                                           class="btn btn-light action-btn text-danger border"
                                           onclick="return confirm('Bạn có chắc muốn xóa phòng này không?');">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>

                                <!-- EDIT ROOM MODAL -->
                                <div class="modal fade" id="modalEditRoom${room.roomID}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow-lg">
                                            <form action="${pageContext.request.contextPath}/staff/room"
                                                  method="POST"
                                                  class="room-form"
                                                  novalidate>
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="serviceID" value="${accommodation.serviceID}">
                                                <input type="hidden" name="roomID" value="${room.roomID}">

                                                <div class="modal-header border-0 p-4 pb-2">
                                                    <h5 class="fw-bold mb-0">
                                                        <i class="fa-solid fa-pen-to-square text-warning me-2"></i>
                                                        Cập nhật phòng
                                                    </h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>

                                                <div class="modal-body p-4">
                                                    <div class="row g-3">
                                                        <div class="col-12">
                                                            <label class="form-label fw-bold small text-secondary">Loại phòng</label>
                                                            <input type="text"
                                                                   name="roomType"
                                                                   class="form-control room-type-input"
                                                                   value="${room.roomType}"
                                                                   minlength="2"
                                                                   maxlength="100"
                                                                   required>
                                                            <div class="invalid-feedback">
                                                                Loại phòng phải từ 2 đến 100 ký tự.
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Số lượng phòng</label>
                                                            <input type="number"
                                                                   name="numberOfRooms"
                                                                   class="form-control room-total-input"
                                                                   min="1"
                                                                   max="1000"
                                                                   value="${room.numberOfRooms}"
                                                                   required>
                                                            <div class="invalid-feedback">
                                                                Số lượng phòng phải từ 1 đến 1000.
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Số phòng còn trống</label>
                                                            <input type="number"
                                                                   name="roomAvailability"
                                                                   class="form-control room-available-input"
                                                                   min="0"
                                                                   max="1000"
                                                                   value="${room.roomAvailability}"
                                                                   required>
                                                            <div class="invalid-feedback">
                                                                Số phòng còn trống phải từ 0 đến tổng số phòng.
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Giá phòng</label>
                                                            <input type="number"
                                                                   name="priceOfRoom"
                                                                   class="form-control room-price-input"
                                                                   min="1000"
                                                                   max="100000000"
                                                                   step="1000"
                                                                   value="${room.priceOfRoom}"
                                                                   required>
                                                            <div class="invalid-feedback">
                                                                Giá phòng phải từ 1,000 đến 100,000,000 VND.
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                                                            <select name="status" class="form-select" required>
                                                                <option value="Available" <c:if test="${room.status == 'Available'}">selected</c:if>>Available</option>
                                                                <option value="Unavailable" <c:if test="${room.status == 'Unavailable'}">selected</c:if>>Unavailable</option>
                                                                <option value="Maintenance" <c:if test="${room.status == 'Maintenance'}">selected</c:if>>Maintenance</option>
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

<!-- ADD ROOM MODAL -->
<div class="modal fade" id="modalAddRoom" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <form action="${pageContext.request.contextPath}/staff/room"
                  method="POST"
                  class="room-form"
                  novalidate>
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="serviceID" value="${accommodation.serviceID}">

                <div class="modal-header border-0 p-4 pb-2">
                    <h5 class="fw-bold mb-0">
                        <i class="fa-solid fa-bed text-primary me-2"></i>
                        Thêm phòng mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold small text-secondary">Loại phòng</label>
                            <input type="text"
                                   name="roomType"
                                   class="form-control room-type-input"
                                   placeholder="VD: Deluxe Double Room"
                                   minlength="2"
                                   maxlength="100"
                                   required>
                            <div class="invalid-feedback">
                                Loại phòng phải từ 2 đến 100 ký tự.
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Số lượng phòng</label>
                            <input type="number"
                                   name="numberOfRooms"
                                   class="form-control room-total-input"
                                   min="1"
                                   max="1000"
                                   value="1"
                                   required>
                            <div class="invalid-feedback">
                                Số lượng phòng phải từ 1 đến 1000.
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Số phòng còn trống</label>
                            <input type="number"
                                   name="roomAvailability"
                                   class="form-control room-available-input"
                                   min="0"
                                   max="1000"
                                   value="1"
                                   required>
                            <div class="invalid-feedback">
                                Số phòng còn trống phải từ 0 đến tổng số phòng.
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Giá phòng</label>
                            <input type="number"
                                   name="priceOfRoom"
                                   class="form-control room-price-input"
                                   min="1000"
                                   max="100000000"
                                   step="1000"
                                   placeholder="500000"
                                   required>
                            <div class="invalid-feedback">
                                Giá phòng phải từ 1,000 đến 100,000,000 VND.
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-secondary">Trạng thái</label>
                            <select name="status" class="form-select" required>
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
                        <i class="fa-solid fa-plus me-2"></i>Thêm phòng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const roomForms = document.querySelectorAll(".room-form");

        roomForms.forEach(function (form) {
            const roomTypeInput = form.querySelector("input[name='roomType']");
            const totalInput = form.querySelector("input[name='numberOfRooms']");
            const availableInput = form.querySelector("input[name='roomAvailability']");
            const priceInput = form.querySelector("input[name='priceOfRoom']");

            function setInvalid(input) {
                input.classList.add("is-invalid");
                input.classList.remove("is-valid");
            }

            function setValid(input) {
                input.classList.remove("is-invalid");
                input.classList.add("is-valid");
            }

            function validateRoomType() {
                if (!roomTypeInput) return true;

                const value = roomTypeInput.value.trim();

                if (value.length < 2 || value.length > 100) {
                    setInvalid(roomTypeInput);
                    return false;
                }

                setValid(roomTypeInput);
                return true;
            }

            function validateTotalRooms() {
                if (!totalInput) return true;

                const total = Number(totalInput.value);

                if (!totalInput.value || total < 1 || total > 1000) {
                    setInvalid(totalInput);
                    return false;
                }

                setValid(totalInput);
                return true;
            }

            function validateAvailableRooms() {
                if (!availableInput || !totalInput) return true;

                const total = Number(totalInput.value);
                const available = Number(availableInput.value);

                if (availableInput.value === "" || available < 0 || available > total || available > 1000) {
                    setInvalid(availableInput);
                    return false;
                }

                setValid(availableInput);
                return true;
            }

            function validateRoomPrice() {
                if (!priceInput) return true;

                const price = Number(priceInput.value);

                if (!priceInput.value || price < 1000 || price > 100000000) {
                    setInvalid(priceInput);
                    return false;
                }

                setValid(priceInput);
                return true;
            }

            if (roomTypeInput) {
                roomTypeInput.addEventListener("input", validateRoomType);
                roomTypeInput.addEventListener("blur", validateRoomType);
            }

            if (totalInput) {
                totalInput.addEventListener("input", function () {
                    validateTotalRooms();
                    validateAvailableRooms();
                });
                totalInput.addEventListener("blur", function () {
                    validateTotalRooms();
                    validateAvailableRooms();
                });
            }

            if (availableInput) {
                availableInput.addEventListener("input", validateAvailableRooms);
                availableInput.addEventListener("blur", validateAvailableRooms);
            }

            if (priceInput) {
                priceInput.addEventListener("input", validateRoomPrice);
                priceInput.addEventListener("blur", validateRoomPrice);
            }

            form.addEventListener("submit", function (event) {
                const okType = validateRoomType();
                const okTotal = validateTotalRooms();
                const okAvailable = validateAvailableRooms();
                const okPrice = validateRoomPrice();

                if (!okType || !okTotal || !okAvailable || !okPrice) {
                    event.preventDefault();
                    event.stopPropagation();
                }
            });
        });
    });
</script>
</body>
</html>