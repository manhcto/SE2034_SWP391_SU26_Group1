<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tour | WonderVN Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *{box-sizing:border-box} body{margin:0;background:#f4f7fb;font-family:"Be Vietnam Pro",Arial,sans-serif;color:#0f172a}.admin-layout{display:flex;min-height:100vh}.main-content{margin-left:292px;width:calc(100% - 292px);padding:34px 42px}.topbar{display:flex;justify-content:space-between;align-items:center;gap:18px;margin-bottom:22px}.topbar h1{font-size:32px;font-weight:900;margin:0}.topbar p{color:#64748b;margin:6px 0 0;font-weight:600}.content-card{background:#fff;border:1px solid #e2e8f0;border-radius:24px;box-shadow:0 10px 28px rgba(15,23,42,.08);margin-bottom:22px;overflow:hidden}.section-title{padding:18px 22px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;justify-content:space-between;gap:14px}.section-title h5{margin:0;font-weight:900}.section-body{padding:22px}.btn-main{border:none;border-radius:14px;background:#ea580c;color:#fff;padding:12px 18px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:8px}.btn-main:hover{background:#c2410c;color:#fff}.btn-success-strong{border:none;border-radius:14px;background:#16a34a;color:#fff;padding:12px 18px;font-weight:900}.btn-danger-strong{border:none;border-radius:14px;background:#dc2626;color:#fff;padding:12px 18px;font-weight:900}.btn-soft{border:1px solid #e2e8f0;border-radius:14px;background:#fff;color:#334155;padding:11px 15px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:8px}.info-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px}.info-item{background:#f8fafc;border:1px solid #e2e8f0;border-radius:16px;padding:15px}.info-item small{display:block;color:#64748b;font-weight:800;margin-bottom:5px}.info-item strong{color:#0f172a}.status-badge{display:inline-flex;align-items:center;border-radius:999px;padding:7px 12px;font-size:12px;font-weight:900}.status-Draft{background:#e0f2fe;color:#0369a1}.status-Pending{background:#fef3c7;color:#92400e}.status-Active{background:#dcfce7;color:#166534}.status-Rejected{background:#ffe4e6;color:#9f1239}.status-Inactive{background:#fee2e2;color:#991b1b}.tour-cover{width:100%;height:290px;object-fit:cover;background:#e2e8f0}.intro-img,.day-img{width:100%;max-height:230px;object-fit:cover;border-radius:16px;border:1px solid #e2e8f0}.day-item{border-left:4px solid #ea580c;background:#fbfdff;border-radius:14px;padding:16px;margin-bottom:14px}.table thead th{background:#f8fafc;color:#334155;font-size:13px;font-weight:900;text-transform:uppercase}.table td,.table th{padding:13px 14px;vertical-align:middle}.approval-box{background:#fff7ed;border:1px solid #fed7aa;border-radius:18px;padding:18px}.reject-box{background:#fff1f2;border:1px solid #fecdd3;border-radius:18px;padding:18px}.muted{color:#64748b}@media(max-width:992px){.main-content{margin-left:0;width:100%;padding:24px}.info-grid{grid-template-columns:1fr 1fr}.topbar{display:block}}@media(max-width:700px){.info-grid{grid-template-columns:1fr}}
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
                <h1>${tour.tourName}</h1>
                <p>${empty tour.tourCode ? 'Chưa có mã tour' : tour.tourCode} · ${tour.startPlace} → ${tour.endPlace}</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a class="btn-soft" href="${pageContext.request.contextPath}/admin/tour"><i class="fa-solid fa-list"></i> Quản lý tour</a>
            </div>
        </div>

        <c:if test="${message == 'approved'}"><div class="alert alert-success fw-bold">Duyệt tour thành công.</div></c:if>
        <c:if test="${message == 'rejected'}"><div class="alert alert-success fw-bold">Đã từ chối tour và gửi lý do về Staff.</div></c:if>
        <c:if test="${message == 'notReady'}"><div class="alert alert-warning fw-bold">Tour chưa đủ điều kiện duyệt. Hãy kiểm tra danh sách lỗi bên dưới.</div></c:if>
        <c:if test="${message == 'rejectReasonInvalid'}"><div class="alert alert-danger fw-bold">Lý do từ chối phải từ 10 đến 500 ký tự.</div></c:if>
        <c:if test="${message == 'invalidStatus'}"><div class="alert alert-warning fw-bold">Chỉ tour ở trạng thái Chờ duyệt mới được duyệt hoặc từ chối.</div></c:if>
        <c:if test="${message == 'statusUpdated'}"><div class="alert alert-success fw-bold">Cập nhật trạng thái tour thành công.</div></c:if>
        <c:if test="${message == 'statusFail'}"><div class="alert alert-danger fw-bold">Cập nhật trạng thái tour thất bại.</div></c:if>

        <section class="content-card">
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
                    <div class="info-item"><small>Người tạo</small><strong>${empty tour.createdByName ? '-' : tour.createdByName}</strong></div>
                    <div class="info-item"><small>Người duyệt</small><strong>${empty tour.approvedByName ? '-' : tour.approvedByName}</strong></div>
                    <div class="info-item"><small>Ngày duyệt</small><strong><c:choose><c:when test="${not empty tour.approvedAt}"><fmt:formatDate value="${tour.approvedAt}" pattern="dd/MM/yyyy HH:mm"/></c:when><c:otherwise>-</c:otherwise></c:choose></strong></div>
                    <div class="info-item"><small>Danh mục</small><strong>${tour.categoryName}</strong></div>
                    <div class="info-item"><small>Khu vực</small><strong>${empty tour.regionName ? '-' : tour.regionName}</strong></div>
                    <div class="info-item"><small>Thời lượng</small><strong>${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</strong></div>
                    <div class="info-item"><small>Phương tiện chính</small><strong>${empty tour.mainTransportType ? '-' : tour.mainTransportType}</strong></div>
                    <div class="info-item"><small>Điểm khởi hành</small><strong>${tour.startPlace}</strong></div>
                    <div class="info-item"><small>Điểm đến</small><strong>${tour.endPlace}</strong></div>
                    <div class="info-item"><small>Giá người lớn</small><strong><fmt:formatNumber value="${tour.adultPrice}" type="number" maxFractionDigits="0"/> đ</strong></div>
                    <div class="info-item"><small>Lịch / Booking</small><strong>${tour.scheduleCount} lịch · ${tour.bookingCount} booking</strong></div>
                </div>
            </div>
        </section>

        <section class="content-card">
            <div class="section-title"><h5><i class="fa-solid fa-list-check text-warning me-2"></i>Kiểm tra điều kiện duyệt</h5></div>
            <div class="section-body">
                <c:choose>
                    <c:when test="${empty readinessErrors}">
                        <div class="alert alert-success fw-bold mb-0">Tour đã đủ thông tin cơ bản để duyệt.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning fw-bold">Tour chưa đủ điều kiện duyệt:</div>
                        <ul class="mb-0">
                            <c:forEach var="err" items="${readinessErrors}"><li>${err}</li></c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <c:if test="${tour.status == 'Pending'}">
            <section class="content-card">
                <div class="section-title"><h5><i class="fa-solid fa-user-check text-success me-2"></i>Duyệt / Từ chối tour</h5></div>
                <div class="section-body">
                    <div class="row g-4">
                        <div class="col-lg-6">
                            <div class="approval-box h-100">
                                <h6 class="fw-bold">Duyệt tour</h6>
                                <p class="muted">Sau khi duyệt, tour chuyển sang trạng thái Đang bán. Các lịch Planned hợp lệ có thể được mở bán tự động.</p>
                                <form method="post" action="${pageContext.request.contextPath}/admin/tour/approve">
                                    <input type="hidden" name="tourID" value="${tour.tourID}">
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="checkbox" id="openSchedules" name="openSchedules" checked>
                                        <label class="form-check-label fw-bold" for="openSchedules">Mở bán các lịch Planned hợp lệ</label>
                                    </div>
                                    <button class="btn-success-strong" type="submit" ${empty readinessErrors ? '' : 'disabled'}><i class="fa-solid fa-check"></i> Duyệt tour</button>
                                </form>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="reject-box h-100">
                                <h6 class="fw-bold">Từ chối tour</h6>
                                <p class="muted">Nhập lý do rõ ràng để Staff biết cần sửa phần nào.</p>
                                <form method="post" action="${pageContext.request.contextPath}/admin/tour/reject">
                                    <input type="hidden" name="tourID" value="${tour.tourID}">
                                    <textarea class="form-control mb-3" name="rejectionReason" rows="4" maxlength="500" placeholder="Ví dụ: Lịch trình ngày 2 còn thiếu mô tả, ảnh bìa chưa phù hợp..." required></textarea>
                                    <button class="btn-danger-strong" type="submit"><i class="fa-solid fa-xmark"></i> Từ chối tour</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </c:if>

        <c:if test="${tour.status == 'Active' || tour.status == 'Inactive'}">
            <section class="content-card">
                <div class="section-title"><h5><i class="fa-solid fa-toggle-on text-warning me-2"></i>Quản lý trạng thái bán</h5></div>
                <div class="section-body">
                    <c:choose>
                        <c:when test="${tour.status == 'Active'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/tour/status" class="d-inline">
                                <input type="hidden" name="tourID" value="${tour.tourID}">
                                <input type="hidden" name="action" value="inactive">
                                <button class="btn-danger-strong" type="submit"><i class="fa-solid fa-ban"></i> Ngừng bán tour</button>
                            </form>
                            <span class="text-muted ms-2">Các lịch đang Open sẽ được chuyển sang Closed.</span>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="${pageContext.request.contextPath}/admin/tour/status" class="d-inline">
                                <input type="hidden" name="tourID" value="${tour.tourID}">
                                <input type="hidden" name="action" value="reactivate">
                                <button class="btn-success-strong" type="submit"><i class="fa-solid fa-rotate-left"></i> Kích hoạt lại tour</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </c:if>

        <section class="content-card">
            <div class="section-title"><h5><i class="fa-solid fa-star text-warning me-2"></i>Nội dung tour</h5></div>
            <div class="section-body">
                <div class="row g-4">
                    <div class="col-lg-7">
                        <h6 class="fw-bold">Điểm nổi bật</h6>
                        <p class="muted">${empty tour.tourInclude ? 'Chưa nhập điểm nổi bật.' : tour.tourInclude}</p>
                        <h6 class="fw-bold mt-4">Địa chỉ tập trung</h6>
                        <p class="muted mb-0">${empty tour.pickupAddress ? 'Chưa nhập địa chỉ tập trung.' : tour.pickupAddress}</p>
                    </div>
                    <div class="col-lg-5">
                        <c:choose>
                            <c:when test="${not empty tour.introImage}"><img class="intro-img" src="${tour.introImage}" alt="Ảnh giới thiệu"></c:when>
                            <c:otherwise><div class="p-4 border rounded-4 text-center text-muted fw-bold">Chưa có ảnh giới thiệu</div></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>

        <section class="content-card">
            <div class="section-title"><h5><i class="fa-solid fa-route text-warning me-2"></i>Lịch trình từng ngày</h5></div>
            <div class="section-body">
                <c:choose>
                    <c:when test="${empty tour.itineraryList}"><p class="muted mb-0">Tour chưa có lịch trình.</p></c:when>
                    <c:otherwise>
                        <c:forEach var="itinerary" items="${tour.itineraryList}">
                            <div class="day-item">
                                <h6 class="fw-bold">Ngày ${itinerary.dayNumber}: ${itinerary.title}</h6>
                                <c:if test="${not empty itinerary.imageUrl}"><img class="day-img mb-3" src="${itinerary.imageUrl}" alt="Ngày ${itinerary.dayNumber}"></c:if>
                                <p class="muted mb-0">${empty itinerary.description ? 'Chưa nhập mô tả.' : itinerary.description}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <section class="content-card">
            <div class="section-title"><h5><i class="fa-solid fa-calendar-days text-warning me-2"></i>Lịch khởi hành</h5></div>
            <c:choose>
                <c:when test="${empty tour.scheduleList}"><div class="section-body"><p class="muted mb-0">Tour chưa có lịch khởi hành.</p></div></c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead><tr><th>Ngày đi</th><th>Ngày về</th><th>Phương tiện</th><th>Giá</th><th>Số chỗ</th><th>Đã đặt</th><th>Còn lại</th><th>Trạng thái</th></tr></thead>
                            <tbody>
                            <c:forEach var="schedule" items="${tour.scheduleList}">
                                <tr>
                                    <td><fmt:formatDate value="${schedule.startDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${schedule.endDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${empty schedule.scheduleTransportType ? tour.mainTransportType : schedule.scheduleTransportType}</td>
                                    <td><fmt:formatNumber value="${empty schedule.adultPrice ? tour.adultPrice : schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                    <td>${schedule.maxParticipants}</td>
                                    <td>${schedule.quantity}</td>
                                    <td>${schedule.remainingSeats}</td>
                                    <td>${schedule.scheduleStatus}</td>
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
