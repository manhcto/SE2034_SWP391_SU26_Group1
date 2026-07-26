<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Lịch tour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        :root{--primary:#2563eb;--primary-dark:#1d4ed8;--dark:#0f172a;--text:#1e293b;--muted:#64748b;--bg:#f3f6fb;--border:#e2e8f0;--shadow:0 16px 36px rgba(15,23,42,.08)}
        body{margin:0;background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;color:var(--text)}
        .admin-layout{display:flex;min-height:100vh}.admin-main{flex:1;min-width:0;padding:28px}
        .page-card{background:#fff;border:1px solid var(--border);border-radius:18px;box-shadow:var(--shadow);margin-bottom:22px;overflow:hidden}
        .topbar{padding:24px;display:flex;align-items:flex-start;justify-content:space-between;gap:18px}.topbar h1{margin:0;color:var(--dark);font-size:28px;font-weight:900}.topbar p{margin:7px 0 0;color:var(--muted);font-weight:600}
        .toolbar{display:flex;gap:10px;flex-wrap:wrap}.btn-main,.btn-soft,.btn-outline-soft{border-radius:14px;padding:11px 16px;font-weight:800;text-decoration:none;display:inline-flex;align-items:center;gap:8px;border:0;white-space:nowrap}.btn-main{background:var(--primary);color:#fff}.btn-main:hover{background:var(--primary-dark);color:#fff}.btn-soft{background:#eff6ff;color:#1d4ed8}.btn-soft:hover{background:#dbeafe;color:#1d4ed8}.btn-outline-soft{background:#fff;color:#475569;border:1px solid var(--border)}.btn-outline-soft:hover{background:#f8fafc;color:#0f172a}
        .section-head{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:14px}.section-head h5{margin:0;font-size:17px;font-weight:900;color:var(--dark)}.section-body{padding:22px}
        .status-badge{border-radius:999px;padding:7px 11px;font-size:12px;font-weight:900;display:inline-flex;align-items:center;gap:6px}.status-Draft,.status-Planned{background:#e0f2fe;color:#0369a1}.status-Pending,.status-Closed{background:#fef3c7;color:#92400e}.status-Active,.status-Open{background:#dcfce7;color:#166534}.status-Inactive,.status-Cancelled{background:#fee2e2;color:#991b1b}.status-Rejected{background:#ffe4e6;color:#9f1239}.status-Completed{background:#ede9fe;color:#5b21b6}
        .step-strip{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}.step-item{border:1px solid var(--border);border-radius:14px;padding:14px 16px;background:#fbfdff;display:flex;gap:12px;align-items:flex-start}.step-item i{width:34px;height:34px;border-radius:10px;display:inline-flex;align-items:center;justify-content:center;background:#eff6ff;color:#1d4ed8}.step-item strong{display:block;color:var(--dark)}.step-item small{color:var(--muted);font-weight:700}
        .checklist-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}.check-item{border:1px solid var(--border);border-radius:14px;padding:14px 16px;background:#fff;display:flex;gap:12px;align-items:flex-start}.check-item i{width:30px;height:30px;border-radius:10px;display:inline-flex;align-items:center;justify-content:center;flex:0 0 30px}.check-item.ready{border-color:#bbf7d0;background:#f0fdf4}.check-item.ready i{background:#dcfce7;color:#166534}.check-item.missing{border-color:#fed7aa;background:#fff7ed}.check-item.missing i{background:#ffedd5;color:#c2410c}.check-item strong{display:block;color:var(--dark)}.check-item small{display:block;margin-top:4px;color:var(--muted);font-weight:700;line-height:1.45}.calendar-card{border:1px solid var(--border);border-radius:16px;overflow:hidden;background:#fff}.calendar-toolbar{padding:14px 16px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:12px}.calendar-toolbar strong{color:var(--dark);font-size:17px}.calendar-nav{display:flex;gap:8px}.calendar-nav button{min-width:36px;height:36px;border-radius:10px;border:1px solid var(--border);background:#fff;color:#1d4ed8;font-weight:800}.calendar-nav #calendarToday{padding:0 12px}.calendar-grid{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));background:#e2e8f0;gap:1px}.calendar-weekday,.calendar-day{background:#fff;min-height:92px;padding:9px}.calendar-weekday{min-height:auto;background:#f8fafc;color:#64748b;font-size:12px;font-weight:900;text-align:center;text-transform:uppercase}.calendar-day.other-month{background:#f8fafc;color:#94a3b8}.calendar-day.today{box-shadow:inset 0 0 0 2px #93c5fd}.calendar-date{font-weight:900;font-size:13px}.calendar-events{display:grid;gap:5px;margin-top:8px}.calendar-event{border:1px solid #bfdbfe;border-radius:9px;background:#eff6ff;color:#1d4ed8;padding:5px 6px;font-size:11px;font-weight:800;line-height:1.25}.calendar-event.duplicate,.calendar-event.warning{border-color:#fdba74;background:#fff7ed;color:#c2410c}.duplicate-row,.warning-row{background:#fff7ed}.duplicate-chip,.price-warning-chip{display:inline-flex;align-items:center;gap:6px;margin-top:5px;padding:4px 7px;border-radius:999px;background:#ffedd5;color:#c2410c;font-size:11px;font-weight:900}.calendar-source{display:none}
        .table-wrap{overflow:auto}.data-table{margin:0}.data-table thead th{background:#f8fafc;color:#475569;font-size:12px;text-transform:uppercase;letter-spacing:.04em;border-bottom:1px solid var(--border);white-space:nowrap}.data-table td,.data-table th{vertical-align:middle;padding:14px 16px}.strong-cell{font-weight:900;color:var(--dark)}.sub-cell{display:block;color:var(--muted);font-size:13px;font-weight:700;margin-top:3px}.tour-code{color:#ea580c;font-weight:900;font-size:13px;letter-spacing:.02em}.row-action{border-radius:12px;padding:9px 12px;font-weight:900;text-decoration:none;display:inline-flex;align-items:center;gap:7px;white-space:nowrap;background:#eff6ff;color:#1d4ed8;border:1px solid #bfdbfe}.row-action:hover{background:#dbeafe;color:#1d4ed8}.row-action.edit{background:#f0fdfa;color:#0f766e;border-color:#99f6e4}
        .empty-box{padding:44px;text-align:center;color:var(--muted)}.empty-box i{font-size:42px;color:#94a3b8;margin-bottom:12px}.muted{color:var(--muted)}.alert ul{margin-bottom:0}
        @media(max-width:992px){.admin-layout{display:block}.admin-main{padding:18px}.topbar{display:block}.toolbar{margin-top:14px}.step-strip,.checklist-grid{grid-template-columns:1fr}.schedule-info{grid-template-columns:1fr}.calendar-day{min-height:78px;padding:7px}.calendar-event{font-size:10px}}
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp" />
    <main class="admin-main">
        <section class="page-card topbar">
            <div>
                <h1>Lịch tour</h1>
                <c:choose>
                    <c:when test="${allSchedules}">
                        <p>Chọn một tour để nhập nhiều lịch khởi hành, giá bán theo lịch và theo dõi trạng thái bán.</p>
                    </c:when>
                    <c:otherwise>
                        <p>${tour.tourCode} · ${tour.tourName}</p>
                        <div class="mt-2"><span class="status-badge status-${tour.status}">Trạng thái tour: ${tour.displayStatus}</span></div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="toolbar">
                <a class="btn-outline-soft" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-list"></i> Danh sách tour</a>
                <c:if test="${!allSchedules && canManageSchedule}">
                    <a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}"><i class="fa-solid fa-plus"></i> Thêm lịch</a>
                </c:if>
            </div>
        </section>

        <c:if test="${messageCode == 'tourCreated'}"><div class="alert alert-success fw-bold">Tour đã được tạo ở trạng thái Bản nháp. Bước tiếp theo là thêm lịch khởi hành, nhập giá bán rồi gửi Admin duyệt.</div></c:if>
        <c:if test="${messageCode == 'scheduleAddSuccess'}"><div class="alert alert-success fw-bold">Thêm lịch khởi hành thành công.</div></c:if>
        <c:if test="${messageCode == 'scheduleAddFail'}"><div class="alert alert-danger fw-bold">Thêm lịch khởi hành thất bại.</div></c:if>
        <c:if test="${messageCode == 'scheduleUpdateSuccess'}"><div class="alert alert-success fw-bold">Cập nhật lịch khởi hành thành công.</div></c:if>
        <c:if test="${messageCode == 'noSchedulePermission'}"><div class="alert alert-warning fw-bold">Tour đang ngừng bán nên không được thêm/sửa lịch khởi hành.</div></c:if>

        <c:if test="${!allSchedules}">
            <section class="page-card">
                <div class="section-body">
                    <div class="step-strip">
                        <div class="step-item">
                            <i class="fa-solid fa-file-lines"></i>
                            <div><strong>1. Hồ sơ tour</strong><small>Đã tạo trong AddTour</small></div>
                        </div>
                        <div class="step-item">
                            <i class="fa-solid fa-calendar-plus"></i>
                            <div><strong>2. Lịch và giá</strong><small>Mỗi tour có thể có nhiều lịch riêng</small></div>
                        </div>
                        <div class="step-item">
                            <i class="fa-solid fa-paper-plane"></i>
                            <div><strong>3. Gửi Admin duyệt</strong><small>Chỉ bật khi lịch/giá hợp lệ</small></div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <div class="fw-bold mb-2 text-dark">Checklist độ hoàn thiện trước khi gửi duyệt</div>
                        <div class="checklist-grid">
                            <c:forEach var="item" items="${readinessChecklist}">
                                <div class="check-item ${item.ready ? 'ready' : 'missing'}">
                                    <i class="fa-solid ${item.ready ? 'fa-check' : 'fa-triangle-exclamation'}"></i>
                                    <div>
                                        <strong>${item.title}</strong>
                                        <small>${item.detail}</small>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <c:if test="${tour.status == 'Draft' || tour.status == 'Rejected'}">
                        <div class="mt-3 d-flex flex-wrap align-items-start justify-content-between gap-3">
                            <c:choose>
                                <c:when test="${empty readinessErrors}">
                                    <div class="alert alert-success fw-bold mb-0 flex-grow-1">Tour đã đủ lịch và giá để gửi Admin duyệt.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning mb-0 flex-grow-1">
                                        <div class="fw-bold mb-2">Cần bổ sung trước khi gửi duyệt:</div>
                                        <ul>
                                            <c:forEach var="error" items="${readinessErrors}"><li>${error}</li></c:forEach>
                                        </ul>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <form method="post" action="${pageContext.request.contextPath}/staff/tour/submit">
                                <input type="hidden" name="tourID" value="${tour.tourID}">
                                <button class="btn-main" type="submit" ${empty readinessErrors ? '' : 'disabled'}><i class="fa-solid fa-paper-plane"></i> Gửi duyệt</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </section>
        </c:if>

        <c:if test="${allSchedules}">
            <section class="page-card">
                <div class="section-head">
                    <h5>Chọn tour để quản lý lịch</h5>
                </div>
                <div class="section-body">
                    <c:choose>
                        <c:when test="${empty tourList}">
                            <div class="empty-box">
                                <i class="fa-solid fa-map-location-dot"></i>
                                <h5 class="fw-bold">Chưa có tour</h5>
                                <p>Tạo tour trước, sau đó quay lại Lịch tour để thêm lịch và giá bán.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-wrap">
                                <table class="table data-table align-middle">
                                    <thead>
                                    <tr>
                                        <th style="width:126px;">Mã tour</th>
                                        <th>Tour</th>
                                        <th>Tuyến</th>
                                        <th>Lịch</th>
                                        <th>Booking</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${tourList}">
                                        <tr>
                                            <td><span class="tour-code">${empty item.tourCode ? 'Chưa sinh mã' : item.tourCode}</span></td>
                                            <td><span class="strong-cell">${item.tourName}</span><span class="sub-cell">${item.numberOfDay}N${item.numberOfNights}Đ</span></td>
                                            <td><span>${item.startPlace}</span><span class="sub-cell">→ ${item.endPlace}</span></td>
                                            <td class="fw-bold">${item.scheduleCount}</td>
                                            <td class="fw-bold">${item.bookingCount}</td>
                                            <td><span class="status-badge status-${item.status}">${item.displayStatus}</span></td>
                                            <td class="text-end">
                                                <a class="row-action" href="${pageContext.request.contextPath}/staff/tour/schedule?tourID=${item.tourID}"><i class="fa-solid fa-calendar-days"></i> Mở lịch</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </c:if>

        <c:if test="${!allSchedules}">
        <section class="page-card">
            <div class="section-head">
                <h5>Các lịch của tour này</h5>
                <c:if test="${!allSchedules && canManageSchedule}">
                    <a class="btn-soft" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}"><i class="fa-solid fa-calendar-plus"></i> Thêm lịch</a>
                </c:if>
            </div>
            <div class="section-body">
                <c:choose>
                    <c:when test="${empty scheduleList}">
                        <div class="empty-box">
                            <i class="fa-solid fa-calendar-days"></i>
                            <h5 class="fw-bold">${allSchedules ? 'Chưa có lịch tour' : 'Tour chưa có lịch khởi hành'}</h5>
                            <p>${allSchedules ? 'Chọn một tour ở phía trên để thêm lịch khởi hành và giá bán.' : 'Thêm lịch mới để nhập ngày đi, số ghế và giá bán cho tour này.'}</p>
                            <c:if test="${!allSchedules && canManageSchedule}"><a class="btn-main" href="${pageContext.request.contextPath}/staff/tour/schedule/add?tourID=${tour.tourID}">Thêm lịch</a></c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="calendar-card mb-4" id="scheduleCalendar">
                            <div class="calendar-toolbar">
                                <strong id="calendarTitle">Lịch khởi hành</strong>
                                <div class="calendar-nav">
                                    <button type="button" id="calendarPrev" aria-label="Tháng trước"><i class="fa-solid fa-chevron-left"></i></button>
                                    <button type="button" id="calendarToday">Hôm nay</button>
                                    <button type="button" id="calendarNext" aria-label="Tháng sau"><i class="fa-solid fa-chevron-right"></i></button>
                                </div>
                            </div>
                            <div class="calendar-grid" id="calendarGrid"></div>
                            <div class="calendar-source" id="calendarSource">
                                <c:forEach var="schedule" items="${scheduleList}">
                                    <fmt:formatDate value="${schedule.startDate}" pattern="yyyy-MM-dd" var="scheduleDateKey" />
                                    <fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy" var="scheduleDateText" />
                                    <fmt:formatNumber value="${schedule.adultPrice}" type="number" maxFractionDigits="0" var="schedulePriceText" />
                                    <span data-date="${scheduleDateKey}"
                                          data-title="${scheduleDateText}"
                                          data-status="${schedule.displayScheduleStatus}"
                                          data-duplicate="${duplicateStartDateMap[scheduleDateKey] == true}"
                                          data-warning="${not empty schedulePriceWarningMap[schedule.tourScheduleID]}"
                                          data-price="${schedulePriceText} đ"></span>
                                </c:forEach>
                            </div>
                        </div>
                        <c:if test="${not empty duplicateStartDateMap}">
                            <div class="alert alert-warning fw-bold">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                                Có lịch khởi hành bị trùng ngày trong tour này. Staff nên sửa hoặc đóng lịch trùng trước khi gửi duyệt.
                            </div>
                        </c:if>
                        <div class="table-wrap">
                            <table class="table data-table align-middle">
                                <thead>
                                <tr>
                                    <c:if test="${allSchedules}"><th>Tour</th></c:if>
                                    <th>Khởi hành</th>
                                    <th>Kết thúc</th>
                                    <th>Giờ đi</th>
                                    <th>Khách</th>
                                    <th>Giá người lớn</th>
                                    <th>Phương tiện</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="schedule" items="${scheduleList}">
                                    <fmt:formatDate value="${schedule.startDate}" pattern="yyyy-MM-dd" var="scheduleDateKey" />
                                    <tr class="${duplicateStartDateMap[scheduleDateKey] == true ? 'duplicate-row' : ''} ${not empty schedulePriceWarningMap[schedule.tourScheduleID] ? 'warning-row' : ''}">
                                        <c:if test="${allSchedules}"><td><span class="strong-cell">${schedule.tourName}</span><span class="sub-cell">${empty schedule.tourCode ? '' : schedule.tourCode}</span></td></c:if>
                                        <td>
                                            <span class="strong-cell"><fmt:formatDate value="${schedule.startDate}" pattern="dd-MM-yyyy"/></span>
                                            <c:if test="${duplicateStartDateMap[scheduleDateKey] == true}">
                                                <span class="duplicate-chip"><i class="fa-solid fa-triangle-exclamation"></i> Trùng ngày</span>
                                            </c:if>
                                        </td>
                                        <td><fmt:formatDate value="${schedule.endDate}" pattern="dd-MM-yyyy"/></td>
                                        <td>${empty schedule.departureTime ? '-' : schedule.departureTime}</td>
                                        <td><span class="strong-cell">${schedule.quantity}/${schedule.maxParticipants}</span><span class="sub-cell">Tối thiểu ${schedule.minParticipants}</span></td>
                                        <td>
                                            <c:choose><c:when test="${empty schedule.adultPrice}">Chưa nhập</c:when><c:otherwise><fmt:formatNumber value="${schedule.adultPrice}" type="number" maxFractionDigits="0"/> đ</c:otherwise></c:choose>
                                            <c:if test="${not empty schedulePriceWarningMap[schedule.tourScheduleID]}">
                                                <span class="price-warning-chip" title="${schedulePriceWarningMap[schedule.tourScheduleID]}"><i class="fa-solid fa-triangle-exclamation"></i> Giá bất thường</span>
                                            </c:if>
                                        </td>
                                        <td>${empty schedule.scheduleTransportType ? (allSchedules ? schedule.mainTransportType : tour.mainTransportType) : schedule.scheduleTransportType}</td>
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
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${schedule.scheduleStatus != 'Closed' && schedule.scheduleStatus != 'Cancelled' && schedule.scheduleStatus != 'Completed' && ((allSchedules && schedule.tourStatus != 'Inactive' && schedule.tourStatus != 'Active') || (!allSchedules && canEditSchedule))}">
                                                    <a class="row-action edit" href="${pageContext.request.contextPath}/staff/tour/schedule/edit?id=${schedule.tourScheduleID}"><i class="fa-solid fa-pen"></i> Sửa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="row-action" href="${pageContext.request.contextPath}/staff/tour/schedule/detail?id=${schedule.tourScheduleID}"><i class="fa-solid fa-eye"></i> Xem</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
        </c:if>
    </main>
</div>
<script>
(function () {
    const grid = document.getElementById('calendarGrid');
    const source = document.getElementById('calendarSource');
    const title = document.getElementById('calendarTitle');
    if (!grid || !source || !title) return;

    const weekdayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    const events = Array.from(source.querySelectorAll('[data-date]')).map(function (node) {
        return {
            date: node.dataset.date,
            title: node.dataset.title,
            status: node.dataset.status || 'Planned',
            price: node.dataset.price || '',
            duplicate: node.dataset.duplicate === 'true',
            warning: node.dataset.warning === 'true'
        };
    }).filter(function (event) { return event.date; });

    const eventMap = events.reduce(function (map, event) {
        if (!map[event.date]) map[event.date] = [];
        map[event.date].push(event);
        return map;
    }, {});

    const now = new Date();
    const firstEventDate = events.length ? new Date(events[0].date + 'T00:00:00') : now;
    let viewYear = firstEventDate.getFullYear();
    let viewMonth = firstEventDate.getMonth();

    function isoDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    function renderCalendar() {
        grid.innerHTML = '';
        title.textContent = 'Lịch khởi hành tháng ' + String(viewMonth + 1).padStart(2, '0') + '-' + viewYear;
        weekdayLabels.forEach(function (label) {
            const cell = document.createElement('div');
            cell.className = 'calendar-weekday';
            cell.textContent = label;
            grid.appendChild(cell);
        });

        const firstDay = new Date(viewYear, viewMonth, 1);
        const startOffset = (firstDay.getDay() + 6) % 7;
        const cursor = new Date(viewYear, viewMonth, 1 - startOffset);

        for (let i = 0; i < 42; i += 1) {
            const key = isoDate(cursor);
            const dayEvents = eventMap[key] || [];
            const cell = document.createElement('div');
            cell.className = 'calendar-day';
            if (cursor.getMonth() !== viewMonth) cell.classList.add('other-month');
            if (key === isoDate(now)) cell.classList.add('today');

            const dateLabel = document.createElement('div');
            dateLabel.className = 'calendar-date';
            dateLabel.textContent = cursor.getDate();
            cell.appendChild(dateLabel);

            if (dayEvents.length) {
                const wrap = document.createElement('div');
                wrap.className = 'calendar-events';
                dayEvents.forEach(function (event) {
                    const badge = document.createElement('div');
                    badge.className = 'calendar-event' + (event.duplicate ? ' duplicate' : '') + (event.warning ? ' warning' : '');
                    badge.textContent = (event.duplicate ? 'Trùng lịch · ' : '') + (event.warning ? 'Giá cần kiểm tra · ' : '') + event.price + ' · ' + event.status;
                    wrap.appendChild(badge);
                });
                cell.appendChild(wrap);
            }

            grid.appendChild(cell);
            cursor.setDate(cursor.getDate() + 1);
        }
    }

    document.getElementById('calendarPrev')?.addEventListener('click', function () {
        viewMonth -= 1;
        if (viewMonth < 0) {
            viewMonth = 11;
            viewYear -= 1;
        }
        renderCalendar();
    });

    document.getElementById('calendarNext')?.addEventListener('click', function () {
        viewMonth += 1;
        if (viewMonth > 11) {
            viewMonth = 0;
            viewYear += 1;
        }
        renderCalendar();
    });

    document.getElementById('calendarToday')?.addEventListener('click', function () {
        viewYear = now.getFullYear();
        viewMonth = now.getMonth();
        renderCalendar();
    });

    renderCalendar();
})();
</script>
</body>
</html>
