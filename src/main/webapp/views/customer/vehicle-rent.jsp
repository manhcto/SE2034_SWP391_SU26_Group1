<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Thuê xe du lịch</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light py-5">
<div class="container">
    <div class="mb-5 border-bottom pb-3">
        <p class="text-success fw-bold m-0 text-uppercase" style="font-size: 0.9rem;">Dịch vụ di chuyển</p>
        <h2 class="fw-bold m-0 text-dark">Thuê Xe Tự Lái & Xe Đưa Đón Giá Tốt</h2>
    </div>

    <div class="row row-cols-1 row-cols-md-3 g-4">
        <c:forEach var="car" items="${vehicleList}">
            <div class="col">
                <div class="card h-100 shadow-sm border-0 rounded-3 overflow-hidden text-center">
                    <div class="py-4 bg-dark text-white">
                        <span style="font-size: 3rem;">🚗</span>
                        <h4 class="fw-bold m-0 mt-2 text-truncate px-2">${car.vehicleBrand}</h4>
                    </div>

                    <div class="card-body p-4">
                        <p class="text-muted mb-2">Biển kiểm soát: <span class="badge bg-secondary">${car.licensePlate}</span></p>

                        <div class="my-3">
                            <span class="text-muted small">Giá thuê chỉ từ</span><br>
                            <span class="text-danger fw-bold fs-4">
                                <fmt:formatNumber value="${car.pricePerDay}" type="number" maxFractionDigits="0"/>đ
                            </span>
                            <span class="text-muted small">/ Ngày</span>
                        </div>

                        <span class="badge ${car.carAvailability eq 'Available' ? 'bg-success' : 'bg-danger'}">
                                ${car.carAvailability eq 'Available' ? 'Sẵn sàng phục vụ' : 'Đang bận / Bảo dưỡng'}
                        </span>
                    </div>

                    <div class="card-footer bg-white border-0 p-4 pt-0">
                        <a href="${pageContext.request.contextPath}/vehicle-detail?id=${car.vehicleID}"
                           class="btn btn-outline-success w-100 fw-bold py-2 ${car.carAvailability ne 'Available' ? 'disabled' : ''}">
                            Xem chi tiết xe
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>