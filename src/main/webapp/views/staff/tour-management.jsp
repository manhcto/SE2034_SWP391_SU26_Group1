<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Quản lý Tour</title>
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
            --border: #e2e8f0;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
        }
        body { margin: 0; background: var(--bg); color: var(--text); font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; }
        .admin-layout { display: flex; min-height: 100vh; }
        .admin-main { flex: 1; min-width: 0; padding: 28px; }
        .page-card { background: #fff; border: 1px solid var(--border); border-radius: 24px; box-shadow: var(--shadow); }
        .topbar { padding: 24px; display: flex; align-items: center; justify-content: space-between; gap: 18px; margin-bottom: 22px; }
        .topbar h1 { margin: 0; color: var(--dark); font-size: 28px; font-weight: 900; }
        .topbar p { margin: 6px 0 0; color: var(--muted); font-weight: 600; }
        .btn-main { border: none; border-radius: 14px; background: var(--primary); color: #fff; padding: 12px 18px; font-weight: 800; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-main:hover { background: var(--primary-dark); color: #fff; }
        .toolbar { padding: 18px; margin-bottom: 22px; }
        .form-control, .form-select { border-radius: 13px; border: 1px solid #dbe3ef; min-height: 46px; }
        .table-card { overflow: hidden; }
        .table { margin-bottom: 0; }
        .table thead th { background: #f8fafc; color: #475569; font-size: 13px; text-transform: uppercase; letter-spacing: .04em; border-bottom: 1px solid var(--border); }
        .table td, .table th { vertical-align: middle; padding: 16px; }
        .tour-name { font-weight: 900; color: var(--dark); }
        .tour-code { color: var(--muted); font-size: 13px; font-weight: 700; }
        .status-badge { border-radius: 999px; padding: 7px 11px; font-size: 12px; font-weight: 900; display: inline-flex; }
        .status-Draft { background: #e0f2fe; color: #0369a1; }
        .status-Pending { background: #fef3c7; color: #92400e; }
        .status-Active { background: #dcfce7; color: #166534; }
        .status-Inactive { background: #fee2e2; color: #991b1b; }
        .status-Rejected { background: #ffe4e6; color: #9f1239; }
        .action-link { font-weight: 800; text-decoration: none; margin-right: 10px; }
        .empty-box { padding: 44px; text-align: center; color: var(--muted); }
        .empty-box i { font-size: 42px; color: #94a3b8; margin-bottom: 12px; }
        @media (max-width: 992px) { .admin-layout { display: block; } .admin-main { padding: 18px; } .topbar { display: block; } }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp" />

    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>Quản lý Tour</h1>
                <p>Staff tạo, cập nhật và theo dõi tour nội bộ của công ty.</p>
            </div>
            <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/add">
                <i class="fa-solid fa-plus"></i>
                Thêm tour
            </a>
        </section>

        <c:if test="${messageCode == 'addSuccess'}">
            <div class="alert alert-success fw-bold">Thêm tour thành công.</div>
        </c:if>
        <c:if test="${messageCode == 'updateSuccess'}">
            <div class="alert alert-success fw-bold">Cập nhật tour thành công.</div>
        </c:if>
        <c:if test="${messageCode == 'updateFail'}">
            <div class="alert alert-danger fw-bold">Cập nhật tour thất bại.</div>
        </c:if>
        <c:if test="${messageCode == 'notFound'}">
            <div class="alert alert-warning fw-bold">Không tìm thấy tour cần xử lý.</div>
        </c:if>
        <c:if test="${messageCode == 'noEditPermission'}">
            <div class="alert alert-warning fw-bold">Nháp/Bị từ chối được sửa đầy đủ; Chờ duyệt/Đang bán được bổ sung nội dung, ảnh và lịch trình.</div>
        </c:if>

        <section class="page-card toolbar">
            <form method="get" action="${pageContext.request.contextPath}/staff/tour" class="row g-3">
                <div class="col-lg-4 col-md-6">
                    <label class="form-label fw-bold">Tìm kiếm</label>
                    <input type="text" name="keyword" class="form-control" value="${keyword}" placeholder="Tên tour, mã tour, điểm đi, điểm đến">
                </div>
                <div class="col-lg-2 col-md-6">
                    <label class="form-label fw-bold">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="Draft" ${selectedStatus == 'Draft' ? 'selected' : ''}>Bản nháp</option>
                        <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="Active" ${selectedStatus == 'Active' ? 'selected' : ''}>Đang bán</option>
                        <option value="Inactive" ${selectedStatus == 'Inactive' ? 'selected' : ''}>Ngừng bán</option>
                        <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Bị từ chối</option>
                    </select>
                </div>
                <div class="col-lg-3 col-md-6">
                    <label class="form-label fw-bold">Danh mục</label>
                    <select name="categoryID" class="form-select">
                        <option value="">Tất cả</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.tourCategoryID}" ${selectedCategoryID == category.tourCategoryID ? 'selected' : ''}>
                                ${category.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-lg-2 col-md-6">
                    <label class="form-label fw-bold">Khu vực</label>
                    <select name="regionID" class="form-select">
                        <option value="">Tất cả</option>
                        <c:forEach var="region" items="${regionList}">
                            <option value="${region.regionID}" ${selectedRegionID == region.regionID ? 'selected' : ''}>
                                ${region.regionName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-lg-1 col-md-12 d-flex align-items-end">
                    <button type="submit" class="btn-main w-100 justify-content-center">
                        <i class="fa-solid fa-filter"></i>
                    </button>
                </div>
            </form>
        </section>

        <section class="page-card table-card">
            <c:choose>
                <c:when test="${empty tourList}">
                    <div class="empty-box">
                        <i class="fa-solid fa-map-location-dot"></i>
                        <h5 class="fw-bold">Chưa có tour phù hợp</h5>
                        <p>Tạo tour đầu tiên hoặc thay đổi bộ lọc tìm kiếm.</p>
                        <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/add">Thêm tour</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>Tour</th>
                                <th>Danh mục</th>
                                <th>Tuyến</th>
                                <th>Thời lượng</th>
                                <th>Giá người lớn</th>
                                <th>Lịch</th>
                                <th>Booking</th>
                                <th>Trạng thái</th>
                                <th style="width: 160px;">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="tour" items="${tourList}">
                                <tr>
                                    <td>
                                        <div class="tour-name">${tour.tourName}</div>
                                        <div class="tour-code">${empty tour.tourCode ? 'Chưa sinh mã' : tour.tourCode}</div>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${tour.categoryName}</div>
                                        <small class="text-muted">${empty tour.regionName ? 'Chưa chọn khu vực' : tour.regionName}</small>
                                    </td>
                                    <td>
                                        <div>${tour.startPlace}</div>
                                        <small class="text-muted">→ ${tour.endPlace}</small>
                                    </td>
                                    <td>${tour.numberOfDay}N${tour.numberOfNights}Đ</td>
                                    <td><fmt:formatNumber value="${tour.adultPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                    <td>${tour.scheduleCount}</td>
                                    <td>${tour.bookingCount}</td>
                                    <td>
                                        <span class="status-badge status-${tour.status}">${tour.displayStatus}</span>
                                    </td>
                                    <td>
                                        <a class="action-link" href="${pageContext.request.contextPath}/staff/tour/detail?id=${tour.tourID}">Xem</a>
                                        <a class="action-link" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}">Lịch</a>
                                        <c:if test="${tour.status == 'Draft' || tour.status == 'Rejected' || tour.status == 'Pending' || tour.status == 'Active'}">
                                            <a class="action-link" href="${pageContext.request.contextPath}/staff/tour/edit?id=${tour.tourID}">Sửa</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
</body>
</html>
