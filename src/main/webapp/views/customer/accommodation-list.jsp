<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Đặt phòng khách sạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light py-5">
<div class="container">
    <div class="mb-5 border-bottom pb-3">
        <p class="text-primary fw-bold m-0 text-uppercase" style="font-size: 0.9rem;">Dịch vụ lưu trú</p>
        <h2 class="fw-bold m-0 text-dark">Khách sạn & Khu nghỉ dưỡng sang trọng</h2>
    </div>

    <div class="row row-cols-1 row-cols-md-3 g-4">
        <c:forEach var="acc" items="${accommodationList}">
            <div class="col">
                <div class="card h-100 shadow-sm border-0 rounded-3 overflow-hidden">
                    <img src="${pageContext.request.contextPath}/${acc.image}" class="card-img-top" alt="${acc.name}" style="height: 200px; object-fit: cover;">

                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="badge bg-primary text-uppercase">${acc.type}</span>
                            <span class="text-warning fw-bold small"><i class="bi bi-star-fill"></i> ${acc.rate} / 5</span>
                        </div>

                        <h4 class="fw-bold text-dark text-truncate mb-2">${acc.name}</h4>
                        <p class="text-muted small mb-1"><i class="bi bi-geo-alt"></i> ${acc.address}</p>
                        <p class="text-muted small mb-3"><i class="bi bi-telephone"></i> ${acc.phone}</p>
                        <p class="text-secondary text-truncate small">${acc.description}</p>
                    </div>

                    <div class="card-footer bg-white border-0 p-4 pt-0 d-flex justify-content-between align-items-center">
                        <span class="badge ${acc.status eq 'Available' ? 'bg-success' : 'bg-danger'}">
                                ${acc.status eq 'Available' ? 'Còn phòng' : 'Hết phòng'}
                        </span>
                        <a href="${pageContext.request.contextPath}/accommodation-detail?id=${acc.serviceID}"
                           class="btn btn-sm btn-primary fw-bold px-3">
                            Xem phòng
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>