<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tour | WonderVN Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *{box-sizing:border-box} body{margin:0;background:#f4f7fb;font-family:"Be Vietnam Pro",Arial,sans-serif;color:#0f172a}.admin-layout{display:flex;min-height:100vh}.main-content{margin-left:292px;width:calc(100% - 292px);padding:34px 42px}.topbar{display:flex;justify-content:space-between;align-items:center;gap:18px;margin-bottom:22px}.topbar h1{font-size:34px;font-weight:900;margin:0}.topbar p{color:#64748b;margin:6px 0 0;font-weight:600}.content-card{background:#fff;border:1px solid #e2e8f0;border-radius:24px;padding:24px;box-shadow:0 10px 28px rgba(15,23,42,.08);margin-bottom:22px}.summary-grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:14px;margin-bottom:22px}.summary-card{background:#fff;border:1px solid #e2e8f0;border-radius:20px;padding:18px;box-shadow:0 10px 22px rgba(15,23,42,.06)}.summary-label{color:#64748b;font-weight:800;font-size:13px}.summary-value{font-size:28px;font-weight:900;margin-top:4px}.filter-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr auto;gap:12px}.form-control,.form-select{border-radius:14px;padding:12px 14px;border-color:#cbd5e1;font-weight:700}.btn-main{border:none;border-radius:14px;background:#ea580c;color:#fff;padding:12px 18px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:8px}.btn-main:hover{background:#c2410c;color:#fff}.btn-soft{border:1px solid #e2e8f0;border-radius:14px;background:#fff;color:#334155;padding:11px 15px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:8px}.btn-soft:hover{background:#f8fafc;color:#0f172a}.tour-thumb{width:76px;height:54px;border-radius:10px;object-fit:cover;border:1px solid #e2e8f0;background:#f8fafc}.tour-thumb-empty{width:76px;height:54px;border-radius:10px;border:1px dashed #cbd5e1;background:#f8fafc;color:#94a3b8;display:flex;align-items:center;justify-content:center}.table thead th{background:#f8fafc;color:#334155;font-size:13px;font-weight:900;text-transform:uppercase;border-bottom:1px solid #e2e8f0;padding:14px;white-space:nowrap}.table tbody td{padding:14px;vertical-align:middle;font-size:14px}.tour-code{font-weight:900;color:#ea580c}.status-badge{display:inline-flex;align-items:center;border-radius:999px;padding:6px 12px;font-size:12px;font-weight:900}.status-Draft{background:#e0f2fe;color:#0369a1}.status-Pending{background:#fef3c7;color:#92400e}.status-Active{background:#dcfce7;color:#166534}.status-Rejected{background:#ffe4e6;color:#9f1239}.status-Inactive{background:#fee2e2;color:#991b1b}.action-link{font-weight:900;text-decoration:none;color:#2563eb;margin-right:10px}.empty-box{border:1px dashed #cbd5e1;background:#f8fafc;border-radius:18px;padding:42px;text-align:center;color:#64748b;font-weight:800}@media(max-width:992px){.main-content{margin-left:0;width:100%;padding:24px}.summary-grid{grid-template-columns:1fr 1fr}.filter-grid{grid-template-columns:1fr}.topbar{display:block}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp">
        <jsp:param name="activeAdminMenu" value="tour"/>
    </jsp:include>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Quản lý tour</h1>
                <p>Theo dõi toàn bộ tour, trạng thái duyệt và xử lý tour Staff gửi lên trong cùng một màn hình.</p>
            </div>
            <a class="btn-soft" href="${pageContext.request.contextPath}/admin/home"><i class="fa-solid fa-arrow-left"></i> Admin Home</a>
        </div>

        <c:if test="${message == 'notFound'}"><div class="alert alert-warning fw-bold">Không tìm thấy tour cần xử lý.</div></c:if>
        <c:if test="${message == 'statusUpdated'}"><div class="alert alert-success fw-bold">Cập nhật trạng thái tour thành công.</div></c:if>

        <div class="summary-grid">
            <div class="summary-card"><div class="summary-label">Nháp</div><div class="summary-value">${statusCounts['Draft']}</div></div>
            <div class="summary-card"><div class="summary-label">Chờ duyệt</div><div class="summary-value text-warning">${statusCounts['Pending']}</div></div>
            <div class="summary-card"><div class="summary-label">Đang bán</div><div class="summary-value text-success">${statusCounts['Active']}</div></div>
            <div class="summary-card"><div class="summary-label">Bị từ chối</div><div class="summary-value text-danger">${statusCounts['Rejected']}</div></div>
            <div class="summary-card"><div class="summary-label">Ngừng bán</div><div class="summary-value text-secondary">${statusCounts['Inactive']}</div></div>
        </div>

        <section class="content-card">
            <form class="filter-grid" method="get" action="${pageContext.request.contextPath}/admin/tour">
                <input class="form-control" type="text" name="keyword" value="${keyword}" placeholder="Tìm theo mã tour, tên tour, điểm đi/đến">
                <select class="form-select" name="categoryID">
                    <option value="0">Tất cả danh mục</option>
                    <c:forEach var="category" items="${categoryList}">
                        <option value="${category.tourCategoryID}" ${selectedCategoryID == category.tourCategoryID ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
                <select class="form-select" name="regionID">
                    <option value="0">Tất cả khu vực</option>
                    <c:forEach var="region" items="${regionList}">
                        <option value="${region.regionID}" ${selectedRegionID == region.regionID ? 'selected' : ''}>${region.regionName}</option>
                    </c:forEach>
                </select>
                <select class="form-select" name="status">
                    <option value="" ${empty selectedStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="Draft" ${selectedStatus == 'Draft' ? 'selected' : ''}>Nháp</option>
                    <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                    <option value="Active" ${selectedStatus == 'Active' ? 'selected' : ''}>Đang bán</option>
                    <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Bị từ chối</option>
                    <option value="Inactive" ${selectedStatus == 'Inactive' ? 'selected' : ''}>Ngừng bán</option>
                </select>
                <button class="btn-main" type="submit"><i class="fa-solid fa-magnifying-glass"></i> Lọc</button>
            </form>
        </section>

        <section class="content-card">
            <c:choose>
                <c:when test="${empty tours}">
                    <div class="empty-box">Không có tour phù hợp với điều kiện tìm kiếm.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>Ảnh</th><th>Mã tour</th><th>Tên tour</th><th>Danh mục</th><th>Khu vực</th><th>Điểm đi/đến</th><th>Lịch</th><th>Booking</th><th>Giá</th><th>Trạng thái</th><th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="tour" items="${tours}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty tour.image}">
                                                <c:set var="coverSrc" value="${tour.image}" />
                                                <c:if test="${not fn:startsWith(coverSrc, 'http://') and not fn:startsWith(coverSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(coverSrc, pageContext.request.contextPath))}">
                                                    <c:set var="coverSrc" value="${pageContext.request.contextPath}${fn:startsWith(coverSrc, '/') ? '' : '/'}${coverSrc}" />
                                                </c:if>
                                                <img class="tour-thumb" src="${coverSrc}" alt="${tour.tourName}">
                                            </c:when>
                                            <c:otherwise><div class="tour-thumb-empty"><i class="fa-solid fa-image"></i></div></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="tour-code">${empty tour.tourCode ? 'Chưa có mã' : tour.tourCode}</td>
                                    <td><strong>${tour.tourName}</strong><br><small class="text-muted">Tạo bởi: ${empty tour.createdByName ? '-' : tour.createdByName}</small></td>
                                    <td>${tour.categoryName}</td>
                                    <td>${empty tour.regionName ? '-' : tour.regionName}</td>
                                    <td>${tour.startPlace}<br><span class="text-muted">→ ${tour.endPlace}</span></td>
                                    <td>${tour.scheduleCount}</td>
                                    <td>${tour.bookingCount}</td>
                                    <td><fmt:formatNumber value="${tour.adultPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                    <td><span class="status-badge status-${tour.status}">${tour.displayStatus}</span></td>
                                    <td>
                                        <a class="action-link" href="${pageContext.request.contextPath}/admin/tour/detail?id=${tour.tourID}">${tour.status == 'Pending' ? 'Xem duyệt' : 'Xem'}</a>
                                        <c:if test="${tour.status == 'Pending'}"><span class="text-warning fw-bold">Cần duyệt</span></c:if>
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
