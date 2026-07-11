<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Chi tiết Tour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root { --primary:#2563eb; --primary-dark:#1d4ed8; --dark:#0f172a; --text:#1e293b; --muted:#64748b; --bg:#f3f6fb; --border:#e2e8f0; --shadow:0 16px 36px rgba(15,23,42,.08); }
        body { margin:0; background:var(--bg); color:var(--text); font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif; }
        .admin-layout { display:flex; min-height:100vh; }
        .admin-main { flex:1; min-width:0; padding:28px; }
        .page-card { background:#fff; border:1px solid var(--border); border-radius:24px; box-shadow:var(--shadow); margin-bottom:22px; overflow:hidden; }
        .topbar { padding:24px; display:flex; align-items:center; justify-content:space-between; gap:18px; }
        .topbar h1 { margin:0; color:var(--dark); font-size:28px; font-weight:900; }
        .topbar p { margin:6px 0 0; color:var(--muted); font-weight:600; }
        .btn-main { border:none; border-radius:14px; background:var(--primary); color:#fff; padding:12px 18px; font-weight:800; display:inline-flex; align-items:center; gap:8px; text-decoration:none; }
        .btn-main:hover { background:var(--primary-dark); color:#fff; }
        .btn-soft { border:1px solid var(--border); border-radius:14px; background:#fff; color:#334155; padding:12px 18px; font-weight:800; display:inline-flex; align-items:center; gap:8px; text-decoration:none; }
        .btn-soft:hover { background:#f8fafc; color:#0f172a; }
        .section-title { padding:20px 22px; border-bottom:1px solid var(--border); display:flex; align-items:center; gap:12px; }
        .section-title h5 { margin:0; font-weight:900; color:var(--dark); }
        .section-body { padding:22px; }
        .tour-cover { width:100%; height:320px; object-fit:cover; background:#e2e8f0; }
        .intro-img { width:100%; max-height:260px; object-fit:cover; border-radius:18px; border:1px solid var(--border); }
        .info-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; }
        .info-item { background:#f8fafc; border:1px solid var(--border); border-radius:16px; padding:16px; }
        .info-item small { display:block; color:var(--muted); font-weight:800; margin-bottom:5px; }
        .info-item strong { color:var(--dark); }
        .status-badge { border-radius:999px; padding:7px 11px; font-size:12px; font-weight:900; display:inline-flex; }
        .status-Draft { background:#e0f2fe; color:#0369a1; }
        .status-Pending { background:#fef3c7; color:#92400e; }
        .status-Active { background:#dcfce7; color:#166534; }
        .status-Inactive { background:#fee2e2; color:#991b1b; }
        .status-Rejected { background:#ffe4e6; color:#9f1239; }
        .day-item { border-left:4px solid var(--primary); background:#fbfdff; border-radius:14px; padding:18px; margin-bottom:14px; }
        .day-title { font-weight:900; color:var(--dark); margin-bottom:8px; }
        .day-img { width:100%; max-height:220px; object-fit:cover; border-radius:14px; border:1px solid var(--border); margin-bottom:12px; }
        .muted { color:var(--muted); }
        .policy-box { background:#f8fafc; border:1px solid var(--border); border-radius:16px; padding:16px; color:#475569; line-height:1.6; }
        .table { margin-bottom:0; }
        .table thead th { background:#f8fafc; color:#475569; font-size:13px; text-transform:uppercase; letter-spacing:.04em; border-bottom:1px solid var(--border); }
        .table td,.table th { vertical-align:middle; padding:14px 16px; }
        .action-link { font-weight:800; text-decoration:none; }
        @media (max-width:1100px) { .info-grid{grid-template-columns:repeat(2,1fr);} }
        @media (max-width:700px) { .admin-layout{display:block;} .admin-main{padding:18px;} .topbar{display:block;} .info-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp" />

    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>${tour.tourName}</h1>
                <p>${empty tour.tourCode ? 'Chưa có mã tour' : tour.tourCode} · ${tour.startPlace} → ${tour.endPlace}</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-arrow-left"></i> Danh sách</a>
                <c:if test="${tour.status == 'Draft' || tour.status == 'Rejected' || tour.status == 'Pending' || tour.status == 'Active'}">
                    <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/edit?id=${tour.tourID}"><i class="fa-solid fa-pen"></i> Sửa tour</a>
                    <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}"><i class="fa-solid fa-calendar-days"></i> Quản lý lịch</a>
                </c:if>
            </div>
        </section>

        <c:if test="${messageCode == 'addSuccess'}"><div class="alert alert-success fw-bold">Thêm tour thành công. Tour đã có lịch khởi hành đầu tiên nếu bạn nhập hợp lệ.</div></c:if>
        <c:if test="${messageCode == 'updateSuccess'}"><div class="alert alert-success fw-bold">Cập nhật tour thành công.</div></c:if>
        <c:if test="${messageCode == 'updateFail'}"><div class="alert alert-danger fw-bold">Cập nhật tour thất bại.</div></c:if>
        <c:if test="${messageCode == 'noEditPermission'}"><div class="alert alert-warning fw-bold">Tour này không được sửa ở trạng thái hiện tại. Nháp/Bị từ chối được sửa đầy đủ; Chờ duyệt/Đang bán chỉ được bổ sung nội dung, ảnh và lịch trình.</div></c:if>

        <section class="page-card">
            <c:choose>
                <c:when test="${not empty tour.image}"><img class="tour-cover" src="${tour.image}" alt="${tour.tourName}"></c:when>
                <c:otherwise><div class="tour-cover d-flex align-items-center justify-content-center text-muted fw-bold">Chưa có ảnh bìa</div></c:otherwise>
            </c:choose>
            <div class="section-body">
                <div class="info-grid">
                    <div class="info-item"><small>Trạng thái</small><span class="status-badge status-${tour.status}">${tour.displayStatus}</span></div>
                    <div class="info-item"><small>Danh mục</small><strong>${tour.categoryName}</strong></div>
                    <div class="info-item"><small>Khu vực</small><strong>${empty tour.regionName ? 'Chưa chọn' : tour.regionName}</strong></div>
                    <div class="info-item"><small>Loại tour</small><strong>${tour.displayTourType}</strong></div>
                    <div class="info-item"><small>Thời lượng</small><strong>${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</strong></div>
                    <div class="info-item"><small>Phương tiện</small><strong>${empty tour.mainTransportType ? 'Chưa chọn' : tour.mainTransportType}</strong></div>
                    <div class="info-item"><small>Giá người lớn</small><strong><fmt:formatNumber value="${tour.adultPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Trẻ em 5–10 tuổi</small><strong><fmt:formatNumber value="${tour.childrenPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Trẻ em dưới 5 tuổi (trẻ thứ 2)</small><strong><fmt:formatNumber value="${tour.infantPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Trẻ em từ 10 tuổi</small><strong><fmt:formatNumber value="${tour.adultPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Phụ thu phòng đơn</small><strong><fmt:formatNumber value="${tour.singleRoomSurcharge}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Thanh toán / VAT</small><strong>100% / ${tour.vatPercent}%</strong></div>
                    <div class="info-item"><small>Lịch khởi hành</small><strong>${tour.scheduleCount}</strong></div>
                </div>
            </div>
        </section>

        <section class="page-card">
            <div class="section-title"><i class="fa-solid fa-star text-primary"></i><h5>Điểm nổi bật và ảnh giới thiệu</h5></div>
            <div class="section-body">
                <div class="row g-4 align-items-start">
                    <div class="col-md-7">
                        <h6 class="fw-bold">Điểm nổi bật</h6>
                        <p class="muted mb-0">${empty tour.tourInclude ? 'Chưa nhập điểm nổi bật.' : tour.tourInclude}</p>
                    </div>
                    <div class="col-md-5">
                        <c:choose>
                            <c:when test="${not empty tour.introImage}"><img class="intro-img" src="${tour.introImage}" alt="Ảnh giới thiệu"></c:when>
                            <c:otherwise><div class="policy-box text-center fw-bold">Chưa có ảnh giới thiệu</div></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>

        <section class="page-card">
            <div class="section-title"><i class="fa-solid fa-location-dot text-primary"></i><h5>Tập trung</h5></div>
            <div class="section-body">
                <p class="muted mb-1"><strong>Địa chỉ:</strong> ${empty tour.pickupAddress ? 'Chưa nhập địa chỉ tập trung.' : tour.pickupAddress}</p>
            </div>
        </section>

        <section class="page-card">
            <div class="section-title"><i class="fa-solid fa-route text-primary"></i><h5>Lịch trình tour</h5></div>
            <div class="section-body">
                <c:choose>
                    <c:when test="${empty tour.itineraryList}"><p class="muted mb-0">Tour chưa có lịch trình.</p></c:when>
                    <c:otherwise>
                        <c:forEach var="itinerary" items="${tour.itineraryList}">
                            <div class="day-item">
                                <div class="day-title">Ngày ${itinerary.dayNumber}: ${itinerary.title}</div>
                                <c:if test="${not empty itinerary.imageUrl}"><img class="day-img" src="${itinerary.imageUrl}" alt="Ảnh ngày ${itinerary.dayNumber}"></c:if>
                                <strong>Mô tả:</strong>
                                <p class="muted mb-0">${empty itinerary.description ? 'Chưa nhập mô tả.' : itinerary.description}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section class="page-card">
            <div class="section-title d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2"><i class="fa-solid fa-calendar-check text-primary"></i><h5>Lịch khởi hành hiện có</h5></div>
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}"><i class="fa-solid fa-list"></i> Quản lý lịch</a>
            </div>
            <c:choose>
                <c:when test="${empty tour.scheduleList}">
                    <div class="section-body"><p class="muted mb-0">Tour chưa có lịch khởi hành.</p></div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead><tr><th>Ngày đi</th><th>Ngày về</th><th>Giờ đi</th><th>Số khách tối thiểu</th><th>Đã đặt/Tối đa</th><th>Giá người lớn</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                            <tbody>
                            <c:forEach var="schedule" items="${tour.scheduleList}">
                                <tr>
                                    <td><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${empty schedule.departureTime ? '-' : schedule.departureTime}</td>
                                    <td>${schedule.minParticipants}</td>
                                    <td>${schedule.quantity}/${schedule.maxParticipants}</td>
                                    <td><fmt:formatNumber value="${empty schedule.adultPrice ? tour.adultPrice : schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                    <td>${schedule.scheduleStatus}</td>
                                    <td><a class="action-link" href="${pageContext.request.contextPath}/staff/tour/schedule/detail?id=${schedule.tourScheduleID}">Xem</a></td>
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
