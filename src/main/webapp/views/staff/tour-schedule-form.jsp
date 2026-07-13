<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | ${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root{--primary:#2563eb;--primary-dark:#1d4ed8;--dark:#0f172a;--muted:#64748b;--bg:#f3f6fb;--border:#e2e8f0;--shadow:0 16px 36px rgba(15,23,42,.08)}
        body{margin:0;background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;color:#1e293b}.admin-layout{display:flex;min-height:100vh}.admin-main{flex:1;min-width:0;padding:28px}.page-card{background:#fff;border:1px solid var(--border);border-radius:24px;box-shadow:var(--shadow);margin-bottom:22px;overflow:hidden}.topbar{padding:24px;display:flex;align-items:center;justify-content:space-between;gap:18px}.topbar h1{margin:0;color:var(--dark);font-size:28px;font-weight:900}.topbar p{margin:6px 0 0;color:var(--muted);font-weight:600}.section-title{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px}.section-title h5{margin:0;font-weight:900;color:var(--dark)}.section-body{padding:22px}.form-label{font-weight:800;color:#334155}.form-control,.form-select{border-radius:13px;border:1px solid #dbe3ef;min-height:46px}.toolbar{display:flex;gap:10px;flex-wrap:wrap}.btn-main,.btn-soft,.btn-outline-soft{border-radius:14px;padding:11px 16px;font-weight:800;text-decoration:none;display:inline-flex;align-items:center;gap:8px;border:0;white-space:nowrap}.btn-main{background:var(--primary);color:#fff}.btn-main:hover{background:var(--primary-dark);color:#fff}.btn-soft{background:#eff6ff;color:#1d4ed8}.btn-soft:hover{background:#dbeafe;color:#1d4ed8}.btn-outline-soft{background:#fff;color:#475569;border:1px solid var(--border)}.btn-outline-soft:hover{background:#f8fafc;color:#0f172a}.hint-box{background:#f8fafc;border:1px solid var(--border);border-radius:16px;padding:14px 16px;color:#475569;font-weight:600}.locked{background:#f8fafc}.footer-actions{display:flex;justify-content:flex-end;gap:12px;padding:20px 22px;border-top:1px solid var(--border);background:#fbfdff}.field-error{color:#dc2626;font-size:13px;font-weight:700;margin-top:6px}.is-invalid{border-color:#dc2626!important}@media(max-width:992px){.admin-layout{display:block}.admin-main{padding:18px}.topbar{display:block}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp" />
    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>${pageTitle}</h1>
                <p>${tour.tourCode} · ${tour.tourName} · ${tour.numberOfDay} ngày ${tour.numberOfNights} đêm</p>
            </div>
            <div class="toolbar">
                <a class="btn-outline-soft" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-list"></i> Danh sách tour</a>
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}"><i class="fa-solid fa-calendar-days"></i> Danh sách lịch</a>
                <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/detail?id=${tour.tourID}"><i class="fa-solid fa-map"></i> Chi tiết tour</a>
            </div>
        </section>

        <c:if test="${not empty errors}">
            <div class="alert alert-danger">
                <div class="fw-bold mb-1">Lỗi chung cần kiểm tra:</div>
                <ul class="mb-0">
                    <c:forEach var="error" items="${errors}"><li>${error}</li></c:forEach>
                </ul>
            </div>
        </c:if>

        <c:if test="${lockedCore}">
            <div class="alert alert-warning fw-bold">Lịch này đã có booking hoặc đã khóa. Hệ thống không cho sửa ngày khởi hành, ngày kết thúc và giá để tránh lệch dữ liệu đặt tour.</div>
        </c:if>

        <c:if test="${!canOpenSchedule}">
            <div class="alert alert-info fw-bold">Tour chưa ở trạng thái Đang bán, nên lịch khởi hành sẽ được giữ ở trạng thái Chưa mở bán.</div>
        </c:if>

        <fmt:formatDate value="${schedule.startDate}" pattern="yyyy-MM-dd" var="startDateValue" />
        <fmt:formatDate value="${schedule.endDate}" pattern="yyyy-MM-dd" var="endDateValue" />
        <fmt:formatDate value="${schedule.bookingDeadline}" pattern="yyyy-MM-dd" var="bookingDeadlineValue" />

        <form method="post" action="${formAction}" id="scheduleForm" novalidate>
            <input type="hidden" name="tourID" value="${tour.tourID}">
            <input type="hidden" name="tourScheduleID" value="${schedule.tourScheduleID}">

            <section class="page-card">
                <div class="section-title"><i class="fa-solid fa-calendar-check text-primary"></i><h5>Thông tin lịch khởi hành</h5></div>
                <div class="section-body">
                    <div class="hint-box mb-3">Mỗi lịch khởi hành là một chuyến bán riêng. Giá có thể thay đổi theo ngày/tháng, nhưng không sửa giá khi lịch đã có booking.</div>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Ngày xuất phát <span class="text-danger">*</span></label>
                            <input type="date" name="startDate" id="startDate" class="form-control ${lockedCore ? 'locked' : ''} ${not empty fieldErrors.startDate ? 'is-invalid' : ''}" value="${startDateValue}" min="${todayIso}" required ${lockedCore ? 'readonly' : ''}>
                            <c:if test="${not empty fieldErrors.startDate}"><div class="field-error">${fieldErrors.startDate}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                            <input type="date" name="endDate" id="endDate" class="form-control ${lockedCore ? 'locked' : ''} ${not empty fieldErrors.endDate ? 'is-invalid' : ''}" value="${endDateValue}" min="${todayIso}" required ${lockedCore ? 'readonly' : ''}>
                            <c:if test="${not empty fieldErrors.endDate}"><div class="field-error">${fieldErrors.endDate}</div></c:if>
                            <div class="form-text">Phải khớp đúng ${tour.numberOfDay} ngày.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giờ xuất phát</label>
                            <input type="time" name="departureTime" class="form-control ${not empty fieldErrors.departureTime ? 'is-invalid' : ''}" value="${schedule.departureTime}">
                            <c:if test="${not empty fieldErrors.departureTime}"><div class="field-error">${fieldErrors.departureTime}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giờ về dự kiến</label>
                            <input type="time" name="expectedReturnTime" class="form-control ${not empty fieldErrors.expectedReturnTime ? 'is-invalid' : ''}" value="${schedule.expectedReturnTime}">
                            <c:if test="${not empty fieldErrors.expectedReturnTime}"><div class="field-error">${fieldErrors.expectedReturnTime}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Ngày chốt bán</label>
                            <input type="date" name="bookingDeadline" id="bookingDeadline" class="form-control ${not empty fieldErrors.bookingDeadline ? 'is-invalid' : ''}" value="${bookingDeadlineValue}" min="${todayIso}">
                            <c:if test="${not empty fieldErrors.bookingDeadline}"><div class="field-error">${fieldErrors.bookingDeadline}</div></c:if>
                            <div class="form-text">Nếu bỏ trống, hệ thống lấy trước ngày đi 1 ngày.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Phương tiện của lịch <span class="text-danger">*</span></label>
                            <c:choose>
                                <c:when test="${lockedCore}">
                                    <input type="hidden" name="scheduleTransportType" value="${selectedTransportType}">
                                    <input type="text" class="form-control locked" value="${selectedTransportType}" readonly>
                                </c:when>
                                <c:otherwise>
                                    <select name="scheduleTransportType" id="scheduleTransportType" class="form-select ${not empty fieldErrors.scheduleTransportType ? 'is-invalid' : ''}" required>
                                        <c:forEach var="transport" items="${transportOptions}">
                                            <option value="${transport}" ${selectedTransportType == transport ? 'selected' : ''}>${transport}</option>
                                        </c:forEach>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                            <div class="form-text">Có thể khác phương tiện chính của tour nếu chuyến này điều xe khác.</div>
                            <c:if test="${not empty fieldErrors.scheduleTransportType}"><div class="field-error">${fieldErrors.scheduleTransportType}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số ghế/tổng khách tối đa <span class="text-danger">*</span></label>
                            <select name="maxParticipants" id="maxParticipants" class="form-select ${not empty fieldErrors.maxParticipants ? 'is-invalid' : ''}" required>
                                <c:forEach var="seat" items="${seatOptions}">
                                    <option value="${seat}" ${schedule.maxParticipants == seat ? 'selected' : ''}>${seat} khách</option>
                                </c:forEach>
                            </select>
                            <c:if test="${bookedSchedule}"><div class="form-text">Không được nhỏ hơn số khách đã đặt: ${schedule.quantity}.</div></c:if>
                            <c:if test="${not empty fieldErrors.maxParticipants}"><div class="field-error">${fieldErrors.maxParticipants}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Số khách tối thiểu</label>
                            <input type="text" id="minParticipantsPreview" class="form-control locked" readonly>
                        </div>
                        <input type="hidden" name="maxParticipantsPerBooking" id="maxParticipantsPerBooking" value="${schedule.maxParticipantsPerBooking <= 0 ? 10 : schedule.maxParticipantsPerBooking}">
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                            <c:choose>
                                <c:when test="${canOpenSchedule}">
                                    <select name="scheduleStatus" class="form-select ${not empty fieldErrors.scheduleStatus ? 'is-invalid' : ''}" required>
                                        <option value="Planned" ${schedule.scheduleStatus == 'Planned' ? 'selected' : ''}>Chưa mở bán</option>
                                        <option value="Open" ${empty schedule.scheduleStatus || schedule.scheduleStatus == 'Open' ? 'selected' : ''}>Mở bán</option>
                                        <option value="Closed" ${schedule.scheduleStatus == 'Closed' ? 'selected' : ''}>Đóng bán</option>
                                        <option value="Completed" ${schedule.scheduleStatus == 'Completed' ? 'selected' : ''}>Hoàn tất</option>
                                        <c:if test="${!bookedSchedule}"><option value="Cancelled" ${schedule.scheduleStatus == 'Cancelled' ? 'selected' : ''}>Hủy lịch</option></c:if>
                                    </select>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="scheduleStatus" value="Planned">
                                    <input type="text" class="form-control locked" value="Chưa mở bán" readonly>
                                    <div class="form-text">Tour chưa được duyệt/đang nháp nên lịch không được mở bán.</div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty fieldErrors.scheduleStatus}"><div class="field-error">${fieldErrors.scheduleStatus}</div></c:if>
                        </div>
                    </div>
                </div>
            </section>

            <section class="page-card">
                <div class="section-title"><i class="fa-solid fa-money-bill-wave text-primary"></i><h5>Giá theo lịch</h5></div>
                <div class="section-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Giá người lớn <span class="text-danger">*</span></label>
                            <input type="number" name="adultPrice" id="adultPrice" min="500001" step="1" inputmode="numeric" class="form-control ${lockedCore ? 'locked' : ''} ${not empty fieldErrors.adultPrice ? 'is-invalid' : ''}" value="${empty schedule.adultPrice ? tour.adultPrice : schedule.adultPrice}" required ${lockedCore ? 'readonly' : ''}>
                            <div class="form-text">Nhập số tiền nguyên, lớn hơn 500.000 đ. Ví dụ: 23000000.</div>
                            <c:if test="${not empty fieldErrors.adultPrice}"><div class="field-error">${fieldErrors.adultPrice}</div></c:if>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trẻ em 5–10 tuổi</label>
                            <input type="text" id="childPricePreview" class="form-control locked" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trẻ em dưới 5 tuổi <small class="text-muted">(trẻ thứ 2)</small></label>
                            <input type="text" id="infantPricePreview" class="form-control locked" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trẻ em từ 10 tuổi</label>
                            <input type="text" id="adultPricePreview" class="form-control locked" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">VAT</label>
                            <input type="text" class="form-control locked" value="8%" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Phụ thu phòng đơn <span class="text-danger">*</span></label>
                            <input type="number" name="singleRoomSurcharge" id="singleRoomSurcharge" min="0" step="1" inputmode="numeric" class="form-control ${lockedCore ? 'locked' : ''} ${not empty fieldErrors.singleRoomSurcharge ? 'is-invalid' : ''}" value="${empty schedule.singleRoomSurcharge ? tour.singleRoomSurcharge : schedule.singleRoomSurcharge}" required ${lockedCore ? 'readonly' : ''}>
                            <c:if test="${not empty fieldErrors.singleRoomSurcharge}"><div class="field-error">${fieldErrors.singleRoomSurcharge}</div></c:if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Chính sách hủy riêng cho lịch</label>
                            <textarea name="cancellationPolicy" class="form-control ${not empty fieldErrors.cancellationPolicy ? 'is-invalid' : ''}" maxlength="2000" rows="3">${empty schedule.cancellationPolicy ? '' : schedule.cancellationPolicy}</textarea>
                            <c:if test="${not empty fieldErrors.cancellationPolicy}"><div class="field-error">${fieldErrors.cancellationPolicy}</div></c:if>
                        </div>
                    </div>
                </div>
                <div class="footer-actions">
                    <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${tour.tourID}">Hủy</a>
                    <button type="submit" class="btn-main"><i class="fa-solid fa-floppy-disk"></i> ${submitLabel}</button>
                </div>
            </section>
        </form>
    </main>
</div>
<script>
(function(){
    const dayCount = ${tour.numberOfDay};
    const todayIso = '${todayIso}';
    const seatMap = {
        'Xe Du Lịch': [4, 7, 16, 29, 45],
        'Xe Khách': [29, 35, 45, 50],
        'Xe Giường nằm': [34, 40, 44],
        'Toa tàu hỏa': [56, 64, 80]
    };
    const form = document.getElementById('scheduleForm');
    const transportInput = document.getElementById('scheduleTransportType');
    const startInput = document.getElementById('startDate');
    const endInput = document.getElementById('endDate');
    const deadlineInput = document.getElementById('bookingDeadline');
    const maxInput = document.getElementById('maxParticipants');
    const minPreview = document.getElementById('minParticipantsPreview');
    const adultInput = document.getElementById('adultPrice');
    const singleRoomInput = document.getElementById('singleRoomSurcharge');
    const maxPerBooking = document.getElementById('maxParticipantsPerBooking');
    const childPreview = document.getElementById('childPricePreview');
    const infantPreview = document.getElementById('infantPricePreview');
    const adultPreview = document.getElementById('adultPricePreview');

    function formatMoney(value){
        if (!isFinite(value)) return '';
        return Math.round(value).toLocaleString('vi-VN') + ' đ';
    }
    function selectedTransport(){
        return transportInput ? transportInput.value : '${selectedTransportType}';
    }
    function updateSeatOptions(){
        if (!maxInput || !transportInput) return;
        const current = maxInput.value;
        const seats = seatMap[selectedTransport()] || seatMap['Xe Du Lịch'];
        maxInput.innerHTML = '';
        seats.forEach(function(seat){
            const option = document.createElement('option');
            option.value = seat;
            option.textContent = seat + ' khách';
            if (String(seat) === String(current)) option.selected = true;
            maxInput.appendChild(option);
        });
        if (!maxInput.value && seats.length) maxInput.value = seats[0];
        updateMin();
    }
    function updateMin(){
        const seats = parseInt(maxInput && maxInput.value ? maxInput.value : '0', 10);
        if (minPreview) minPreview.value = seats > 0 ? Math.ceil(seats * 0.5) + ' khách' : '';
        if (maxPerBooking) maxPerBooking.value = seats > 0 ? Math.min(10, seats) : 1;
    }
    function updatePrices(){
        const adult = parseInt(adultInput && adultInput.value ? adultInput.value : '0', 10);
        if (childPreview) childPreview.value = adult > 0 ? formatMoney(adult * 0.75 * 1.08) : '';
        if (infantPreview) infantPreview.value = adult > 0 ? formatMoney(adult * 0.50 * 1.08) : '';
        if (adultPreview) adultPreview.value = adult > 0 ? formatMoney(adult) : '';
    }
    function updateEndDate(){
        if (!startInput || !endInput || !startInput.value || endInput.readOnly) return;
        const start = new Date(startInput.value + 'T00:00:00');
        if (isNaN(start.getTime())) return;
        start.setDate(start.getDate() + dayCount - 1);
        endInput.value = start.toISOString().slice(0,10);
        endInput.min = startInput.value;
        if (deadlineInput && !deadlineInput.value && startInput.value > todayIso) {
            const deadline = new Date(startInput.value + 'T00:00:00');
            deadline.setDate(deadline.getDate() - 1);
            deadlineInput.value = deadline.toISOString().slice(0,10);
        }
    }
    function daysBetweenInclusive(startValue, endValue){
        const start = new Date(startValue + 'T00:00:00');
        const end = new Date(endValue + 'T00:00:00');
        if (isNaN(start.getTime()) || isNaN(end.getTime())) return null;
        return Math.round((end - start) / 86400000) + 1;
    }
    if (transportInput) transportInput.addEventListener('change', updateSeatOptions);
    if (maxInput) maxInput.addEventListener('change', updateMin);
    if (adultInput) adultInput.addEventListener('input', updatePrices);
    if (startInput) startInput.addEventListener('change', updateEndDate);
    if (startInput && !startInput.readOnly) startInput.min = todayIso;
    if (endInput && !endInput.readOnly) endInput.min = todayIso;
    if (deadlineInput) deadlineInput.min = todayIso;
    updateSeatOptions();
    updateMin();
    updatePrices();
})();
</script>
</body>
</html>
