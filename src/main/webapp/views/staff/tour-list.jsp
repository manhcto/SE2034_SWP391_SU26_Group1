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
        .page-card { background: #fff; border: 1px solid var(--border); border-radius: 18px; box-shadow: var(--shadow); }
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
        .tour-code { color: #ea580c; font-size: 13px; font-weight: 900; letter-spacing: .02em; }
        .status-badge { border-radius: 999px; padding: 7px 11px; font-size: 12px; font-weight: 900; display: inline-flex; }
        .status-Draft { background: #e0f2fe; color: #0369a1; }
        .status-Pending { background: #fef3c7; color: #92400e; }
        .status-Active { background: #dcfce7; color: #166534; }
        .status-Inactive { background: #fee2e2; color: #991b1b; }
        .status-Rejected { background: #ffe4e6; color: #9f1239; }
        .action-buttons { display: flex; align-items: center; gap: 8px; justify-content: flex-end; }
        .icon-action { width: 38px; height: 38px; border-radius: 12px; border: 1px solid var(--border); background: #fff; color: #334155; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; transition: all .18s ease; }
        .icon-action:hover { transform: translateY(-1px); box-shadow: 0 10px 18px rgba(15,23,42,.10); }
        .icon-action.view { color: #2563eb; background: #eff6ff; border-color: #bfdbfe; }
        .icon-action.edit { color: #0f766e; background: #f0fdfa; border-color: #99f6e4; }
        .icon-action.schedule { color: #7c3aed; background: #f5f3ff; border-color: #ddd6fe; }
        .empty-box { padding: 44px; text-align: center; color: var(--muted); }
        .empty-box i { font-size: 42px; color: #94a3b8; margin-bottom: 12px; }
        .pagination-bar { padding: 18px; border-top: 1px solid var(--border); display: flex; align-items: center; justify-content: center; gap: 8px; flex-wrap: wrap; }
        .page-link-soft { min-width: 40px; height: 40px; padding: 0 13px; border: 1px solid #dbe3ef; border-radius: 10px; background: #fff; color: var(--dark); text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 7px; font-weight: 800; }
        .page-link-soft:hover, .page-link-soft.active { background: var(--primary); border-color: var(--primary); color: #fff; }
        .page-link-soft.disabled { pointer-events: none; opacity: .45; background: #f2f4f7; }
        .page-total { color: var(--muted); font-weight: 800; font-size: 13px; }
        @media (max-width: 992px) { .admin-layout { display: block; } .admin-main { padding: 18px; } .topbar { display: block; } }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp" />

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
        <c:if test="${messageCode == 'scheduleAddSuccess'}">
            <div class="alert alert-success fw-bold">Đã lưu lịch khởi hành đầu tiên. Hãy mở chi tiết tour để kiểm tra rồi gửi Admin duyệt.</div>
        </c:if>
        <c:if test="${messageCode == 'scheduleAddFail'}">
            <div class="alert alert-danger fw-bold">Lưu lịch khởi hành thất bại. Vui lòng mở tour và kiểm tra lại lịch.</div>
        </c:if>
        <c:if test="${messageCode == 'notFound'}">
            <div class="alert alert-warning fw-bold">Không tìm thấy tour cần xử lý.</div>
        </c:if>
        <c:if test="${messageCode == 'noEditPermission'}">
            <div class="alert alert-warning fw-bold">Nháp/Bị từ chối được sửa đầy đủ; Chờ duyệt/Đang bán được bổ sung nội dung, ảnh và lịch trình.</div>
        </c:if>

        <section class="page-card toolbar">
            <form method="get" action="${pageContext.request.contextPath}/staff/tour" class="row g-3">
                <div class="col-lg-3 col-md-6">
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
                <div class="col-lg-2 col-md-6">
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
                                <th style="width: 72px;">STT</th>
                                <th style="width: 126px;">Mã tour</th>
                                <th>Tour</th>
                                <th>Danh mục</th>
                                <th>Tuyến</th>
                                <th>Thời lượng</th>
                                <th>Khu vực</th>
                                <th>Lịch</th>
                                <th>Booking</th>
                                <th>Trạng thái</th>
                                <th class="text-end" style="width: 150px;">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="tour" items="${tourList}" varStatus="loop">
                                <tr>
                                    <td class="fw-bold text-muted">${rowNumberStart + loop.index}</td>
                                    <td><span class="tour-code">${empty tour.tourCode ? 'Chưa sinh mã' : tour.tourCode}</span></td>
                                    <td>
                                        <div class="tour-name">${tour.tourName}</div>
                                    </td>
                                    <td>
                                        <div class="fw-bold">${tour.categoryName}</div>
                                    </td>
                                    <td>
                                        <div>${tour.startPlace} → ${tour.endPlace}</div>
                                    </td>
                                    <td>${tour.numberOfDay}N${tour.numberOfNights}Đ</td>
                                    <td>${empty tour.regionName ? 'Chưa chọn' : tour.regionName}</td>
                                    <td>${tour.scheduleCount}</td>
                                    <td>${tour.bookingCount}</td>
                                    <td>
                                        <span class="status-badge status-${tour.status}">${tour.displayStatus}</span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a class="icon-action view" href="${pageContext.request.contextPath}/staff/tour/detail?id=${tour.tourID}" title="Xem chi tiết tour" aria-label="Xem chi tiết tour">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                            <a class="icon-action schedule" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}" title="Lịch tour và giá bán" aria-label="Lịch tour và giá bán">
                                                <i class="fa-solid fa-calendar-days"></i>
                                            </a>
                                            <c:if test="${tour.status == 'Draft' || tour.status == 'Rejected' || tour.status == 'Pending' || tour.status == 'Active'}">
                                                <a class="icon-action edit" href="${pageContext.request.contextPath}/staff/tour/edit?id=${tour.tourID}" title="Sửa tour" aria-label="Sửa tour">
                                                    <i class="fa-solid fa-pen"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${totalPages > 1}">
                        <nav class="pagination-bar" aria-label="Phân trang danh sách tour">
                            <span class="page-total">${totalTourCount} tour</span>
                            <a class="page-link-soft ${hasPreviousPage ? '' : 'disabled'}" href="${pageContext.request.contextPath}/staff/tour?page=${previousPage}${paginationQuery}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                            <c:forEach begin="1" end="${totalPages}" var="pageNo">
                                <a class="page-link-soft ${pageNo == currentPage ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/tour?page=${pageNo}${paginationQuery}">${pageNo}</a>
                            </c:forEach>
                            <a class="page-link-soft ${hasNextPage ? '' : 'disabled'}" href="${pageContext.request.contextPath}/staff/tour?page=${nextPage}${paginationQuery}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
</body>
</html>
