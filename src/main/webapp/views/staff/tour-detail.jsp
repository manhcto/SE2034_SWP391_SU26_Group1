<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        .btn-main:disabled { background:#94a3b8; cursor:not-allowed; }
        .btn-soft { border:1px solid var(--border); border-radius:14px; background:#fff; color:#334155; padding:12px 18px; font-weight:800; display:inline-flex; align-items:center; gap:8px; text-decoration:none; }
        .btn-soft:hover { background:#f8fafc; color:#0f172a; }
        .approval-actions { display:flex; gap:12px; flex-wrap:wrap; justify-content:flex-end; }
        .approval-actions .btn-main,.approval-actions .btn-soft { min-height:54px; padding:14px 24px; font-size:15px; }
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
        .status-Open { background:#dcfce7; color:#166534; }
        .status-Planned { background:#e0f2fe; color:#0369a1; }
        .status-Closed { background:#fef3c7; color:#92400e; }
        .status-Cancelled { background:#fee2e2; color:#991b1b; }
        .status-Completed { background:#ede9fe; color:#5b21b6; }
        .day-item { border-left:4px solid var(--primary); background:#fbfdff; border-radius:14px; padding:18px; margin-bottom:14px; }
        .day-title { font-weight:900; color:var(--dark); margin-bottom:8px; }
        .day-img { width:100%; max-height:220px; object-fit:cover; border-radius:14px; border:1px solid var(--border); margin-bottom:12px; }
        .muted { color:var(--muted); }
        .policy-box { background:#f8fafc; border:1px solid var(--border); border-radius:16px; padding:16px; color:#475569; line-height:1.6; }
        .review-grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:12px; }
        .review-item { border:1px solid var(--border); border-radius:14px; padding:14px 16px; background:#fbfdff; font-weight:800; color:#334155; display:flex; gap:10px; align-items:flex-start; }
        .review-item i { color:var(--primary); margin-top:2px; }
        .table { margin-bottom:0; }
        .table thead th { background:#f8fafc; color:#475569; font-size:13px; text-transform:uppercase; letter-spacing:.04em; border-bottom:1px solid var(--border); }
        .table td,.table th { vertical-align:middle; padding:14px 16px; }
        .icon-action { width:38px; height:38px; border-radius:12px; border:1px solid var(--border); background:#eff6ff; color:#2563eb; display:inline-flex; align-items:center; justify-content:center; text-decoration:none; }
        .icon-action:hover { background:#dbeafe; color:#1d4ed8; }
        .duplicate-row { background:#fff7ed; }
        .duplicate-chip { display:inline-flex; align-items:center; gap:6px; margin-top:5px; padding:4px 7px; border-radius:999px; background:#ffedd5; color:#c2410c; font-size:11px; font-weight:900; }
        @media (max-width:1100px) { .info-grid{grid-template-columns:repeat(2,1fr);} }
        @media (max-width:700px) { .admin-layout{display:block;} .admin-main{padding:18px;} .topbar{display:block;} .info-grid,.review-grid{grid-template-columns:1fr;} .approval-actions{justify-content:flex-start;margin-top:14px;} }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp" />

    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>${tour.tourName}</h1>
                <p>${empty tour.tourCode ? 'Chưa có mã tour' : tour.tourCode} · ${tour.startPlace} → ${tour.endPlace}</p>
            </div>
            <div class="approval-actions">
                <c:choose>
                    <c:when test="${tour.status == 'Draft' || tour.status == 'Rejected'}">
                        <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}"><i class="fa-solid fa-arrow-left"></i> Quay lại lịch tour</a>
                        <form method="post" action="${pageContext.request.contextPath}/staff/tour/submit" class="d-inline submit-approval-form">
                            <input type="hidden" name="tourID" value="${tour.tourID}">
                            <button class="btn-main" type="submit" ${empty readinessErrors ? '' : 'disabled'}><i class="fa-solid fa-paper-plane"></i> Gửi duyệt</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-arrow-left"></i> Danh sách</a>
                        <c:if test="${tour.status == 'Pending' || tour.status == 'Active'}">
                            <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/edit?id=${tour.tourID}"><i class="fa-solid fa-pen"></i> Sửa tour</a>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <c:if test="${messageCode == 'addSuccess'}"><div class="alert alert-success fw-bold">Thêm tour thành công. Tour đã có lịch khởi hành đầu tiên nếu bạn nhập hợp lệ.</div></c:if>
        <c:if test="${messageCode == 'scheduleAddSuccess'}"><div class="alert alert-success fw-bold">Đã lưu lịch khởi hành. Vui lòng kiểm tra lại tour trước khi gửi duyệt.</div></c:if>
        <c:if test="${messageCode == 'scheduleAddFail'}"><div class="alert alert-danger fw-bold">Lưu lịch khởi hành thất bại. Vui lòng kiểm tra lại dữ liệu lịch.</div></c:if>
        <c:if test="${messageCode == 'scheduleUpdateSuccess'}"><div class="alert alert-success fw-bold">Đã cập nhật lịch khởi hành. Vui lòng kiểm tra lại tour trước khi gửi duyệt.</div></c:if>
        <c:if test="${messageCode == 'scheduleUpdateFail'}"><div class="alert alert-danger fw-bold">Cập nhật lịch khởi hành thất bại. Vui lòng thử lại.</div></c:if>
        <c:if test="${messageCode == 'updateSuccess'}"><div class="alert alert-success fw-bold">Cập nhật tour thành công.</div></c:if>
        <c:if test="${messageCode == 'updateFail'}"><div class="alert alert-danger fw-bold">Cập nhật tour thất bại.</div></c:if>
        <c:if test="${messageCode == 'noEditPermission'}"><div class="alert alert-warning fw-bold">Tour này không được sửa ở trạng thái hiện tại. Nháp/Bị từ chối được sửa đầy đủ; Chờ duyệt/Đang bán chỉ được bổ sung nội dung, ảnh và lịch trình.</div></c:if>
        <c:if test="${messageCode == 'submitted'}"><div class="alert alert-success fw-bold">Đã gửi tour cho Admin duyệt.</div></c:if>
        <c:if test="${messageCode == 'submitInvalidStatus'}"><div class="alert alert-warning fw-bold">Chỉ tour Nháp hoặc Bị từ chối mới được gửi duyệt.</div></c:if>
        <c:if test="${messageCode == 'submitFail'}"><div class="alert alert-danger fw-bold">Gửi duyệt thất bại. Vui lòng thử lại.</div></c:if>

        <c:if test="${tour.status == 'Draft' || tour.status == 'Rejected'}">
            <section class="page-card">
                <div class="section-title"><i class="fa-solid fa-clipboard-check text-primary"></i><h5>Các phần cần kiểm tra trước khi gửi duyệt</h5></div>
                <div class="section-body">
                    <div class="review-grid mb-3">
                        <div class="review-item"><i class="fa-solid fa-circle-check"></i><span>Thông tin định danh: tên tour, mã tour, danh mục, khu vực, tuyến đi và thời lượng.</span></div>
                        <div class="review-item"><i class="fa-solid fa-circle-check"></i><span>Ảnh hiển thị: ảnh bìa, ảnh giới thiệu và ảnh lịch trình từng ngày.</span></div>
                        <div class="review-item"><i class="fa-solid fa-circle-check"></i><span>Nội dung tour: điểm nổi bật, mô tả ngắn và lịch trình theo đúng số ngày.</span></div>
                        <div class="review-item"><i class="fa-solid fa-circle-check"></i><span>Lịch khởi hành: ngày đi/ngày về, số chỗ, giá người lớn, giá trẻ em và trạng thái lịch.</span></div>
                    </div>
                    <c:choose>
                        <c:when test="${empty readinessErrors}">
                            <div class="alert alert-success fw-bold mb-0">Tour đã đủ điều kiện cơ bản. Staff kiểm tra lại nội dung hiển thị bên dưới rồi bấm Gửi duyệt.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning mb-0">
                                <div class="fw-bold mb-2">Cần sửa trước khi gửi duyệt:</div>
                                <ul class="mb-0">
                                    <c:forEach var="error" items="${readinessErrors}"><li>${error}</li></c:forEach>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </c:if>

        <section class="page-card">
            <c:choose>
                <c:when test="${not empty tour.image}">
                    <c:set var="coverSrc" value="${tour.image}" />
                    <c:if test="${not fn:startsWith(coverSrc, 'http://') and not fn:startsWith(coverSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(coverSrc, pageContext.request.contextPath))}">
                        <c:set var="coverSrc" value="${pageContext.request.contextPath}${fn:startsWith(coverSrc, '/') ? '' : '/'}${coverSrc}" />
                    </c:if>
                    <img class="tour-cover" src="${coverSrc}" alt="${tour.tourName}">
                </c:when>
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
                    <div class="info-item"><small>Giá người lớn</small><strong>Theo lịch</strong></div>
                    <div class="info-item"><small>Trẻ em 5–10 tuổi</small><strong>Theo lịch</strong></div>
                    <div class="info-item"><small>Trẻ em dưới 5 tuổi</small><strong>Miễn phí</strong></div>
                    <div class="info-item"><small>Trẻ em từ 10 tuổi</small><strong>Theo lịch</strong></div>
                    <div class="info-item"><small>Phụ thu phòng đơn</small><strong>Theo lịch</strong></div>
                    <div class="info-item"><small>Thanh toán</small><strong>100% theo booking</strong></div>
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
                            <c:when test="${not empty tour.introImage}">
                                <c:set var="introSrc" value="${tour.introImage}" />
                                <c:if test="${not fn:startsWith(introSrc, 'http://') and not fn:startsWith(introSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(introSrc, pageContext.request.contextPath))}">
                                    <c:set var="introSrc" value="${pageContext.request.contextPath}${fn:startsWith(introSrc, '/') ? '' : '/'}${introSrc}" />
                                </c:if>
                                <img class="intro-img" src="${introSrc}" alt="Ảnh giới thiệu">
                            </c:when>
                            <c:otherwise><div class="policy-box text-center fw-bold">Chưa có ảnh giới thiệu</div></c:otherwise>
                        </c:choose>
                    </div>
                </div>
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
                                <c:if test="${not empty itinerary.imageUrl}">
                                    <c:set var="dayImageSrc" value="${itinerary.imageUrl}" />
                                    <c:if test="${not fn:startsWith(dayImageSrc, 'http://') and not fn:startsWith(dayImageSrc, 'https://') and (empty pageContext.request.contextPath or not fn:startsWith(dayImageSrc, pageContext.request.contextPath))}">
                                        <c:set var="dayImageSrc" value="${pageContext.request.contextPath}${fn:startsWith(dayImageSrc, '/') ? '' : '/'}${dayImageSrc}" />
                                    </c:if>
                                    <img class="day-img" src="${dayImageSrc}" alt="Ảnh ngày ${itinerary.dayNumber}">
                                </c:if>
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
            </div>
            <c:choose>
                <c:when test="${empty tour.scheduleList}">
                    <div class="section-body">
                        <p class="muted mb-3">Tour chưa có lịch khởi hành.</p>
                        <c:if test="${tour.status != 'Inactive'}">
                            <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}">
                                <i class="fa-solid fa-plus"></i> Thêm lịch
                            </a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead><tr><th style="width:72px;">STT</th><th>Ngày đi</th><th>Ngày về</th><th>Giờ đi</th><th>Số khách tối thiểu</th><th>Đã đặt/Tối đa</th><th>Giá người lớn</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                            <tbody>
                            <c:forEach var="schedule" items="${tour.scheduleList}" varStatus="loop">
                                <fmt:formatDate value="${schedule.startDate}" pattern="yyyy-MM-dd" var="scheduleDateKey" />
                                <tr class="${duplicateStartDateMap[scheduleDateKey] == true ? 'duplicate-row' : ''}">
                                    <td class="fw-bold text-muted">${loop.count}</td>
                                    <td>
                                        <fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy"/>
                                        <c:if test="${duplicateStartDateMap[scheduleDateKey] == true}">
                                            <span class="duplicate-chip"><i class="fa-solid fa-triangle-exclamation"></i> Trùng ngày</span>
                                        </c:if>
                                    </td>
                                    <td><fmt:formatDate value="${schedule.endDate}" pattern="dd-MM-yyyy"/></td>
                                    <td>${empty schedule.departureTime ? '-' : schedule.departureTime}</td>
                                    <td>${schedule.minParticipants}</td>
                                    <td>${schedule.quantity}/${schedule.maxParticipants}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty schedule.adultPrice}">Chưa nhập</c:when>
                                            <c:otherwise><fmt:formatNumber value="${schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${schedule.upcomingSoon}"><span class="status-badge status-Pending">Sắp khởi hành</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Open'}"><span class="status-badge status-Open">Mở bán</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Closed'}"><span class="status-badge status-Closed">Đóng bán</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Cancelled'}"><span class="status-badge status-Cancelled">Đã hủy</span></c:when>
                                            <c:when test="${schedule.scheduleStatus == 'Completed'}"><span class="status-badge status-Completed">Hoàn tất</span></c:when>
                                            <c:otherwise><span class="status-badge status-Planned">Chưa mở bán</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><a class="icon-action" href="${pageContext.request.contextPath}/staff/tour/schedule/detail?id=${schedule.tourScheduleID}" title="Xem lịch" aria-label="Xem lịch"><i class="fa-solid fa-eye"></i></a></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="section-body pt-3">
                        <c:if test="${tour.status != 'Inactive'}">
                            <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}">
                                <i class="fa-solid fa-plus"></i> Thêm lịch
                            </a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
<script>
document.querySelectorAll('.submit-approval-form').forEach(function (form) {
    form.addEventListener('submit', function (event) {
        if (!window.confirm('Bạn đang ở trang chi tiết tour. Bạn đã kiểm tra kỹ và chắc chắn muốn gửi Admin duyệt không?')) {
            event.preventDefault();
        }
    });
});
</script>
</body>
</html>
