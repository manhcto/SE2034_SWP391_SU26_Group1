<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Thêm phân công tour</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css?v=staff-assignment-left-20260714" rel="stylesheet">
</head>

<body>
<div class="workspace-layout staff-assignment-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Thêm phân công tour</h1>
                <p>Chọn booking tour, hướng dẫn viên và thiết lập thông tin điều phối.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>
        </div>

        <c:if test="${param.error == 'notFoundSchedule'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Không tìm thấy lịch trình tour cho booking này.
            </div>
        </c:if>

        <c:if test="${param.error == 'notCompletedBooking' || param.error == 'paymentRequired'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Chỉ booking tour đã thanh toán thành công mới được phân công hướng dẫn viên.
            </div>
        </c:if>

        <c:if test="${param.error == 'unavailable'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-calendar-xmark me-2"></i>
                Không thể phân công: tour đã có hướng dẫn viên hoặc hướng dẫn viên đang bận trong thời gian này.
            </div>
        </c:if>

        <c:if test="${param.error == 'duplicateCustomer'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Booking hoặc khách đặt này đã được phân công cho lịch tour này. Vui lòng chọn booking khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'duplicateGuide'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đã được phân công cho lịch tour này. Vui lòng chọn hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'guideScheduleOverlap'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đã có tour khác bị trùng ngày diễn ra. Vui lòng chọn hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'guideUnavailable'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đang có phân công chưa hoàn thành. Vui lòng chọn hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'guideRejected'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Hướng dẫn viên này đã từ chối tour này. Vui lòng phân công cho hướng dẫn viên khác.
            </div>
        </c:if>

        <c:if test="${param.error == 'insertFailed'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                Không lưu được phân công. Vui lòng tải lại trang và thử lại.
            </div>
        </c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Thông tin phân công</h2>
                    <p>Chỉ hiển thị booking tour đã thanh toán thành công và lưu trực tiếp vào phân công tour.</p>
                </div>
            </div>

            <div class="panel-body">
                <form method="post" action="${pageContext.request.contextPath}/staff/assignment">
                    <input type="hidden" name="action" value="insert">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Booking tour</label>
                            <select name="bookingID" class="form-select" required>
                                <option value="">Chọn booking cần phân công</option>
                                <c:forEach var="b" items="${bookingList}">
                                    <fmt:formatDate value="${b.pickupTime}" pattern="yyyy-MM-dd'T'HH:mm" var="bookingPickupValue"/>
                                    <fmt:formatDate value="${b.checkInDeadline}" pattern="yyyy-MM-dd'T'HH:mm" var="bookingCheckInValue"/>
                                    <option value="${b.bookingID}"
                                            data-pickup-time="${bookingPickupValue}"
                                            data-check-in-deadline="${bookingCheckInValue}"
                                            data-rejected-guide-ids="${b.rejectedGuideIDs}">
                                        <c:choose>
                                            <c:when test="${not empty b.bookingCode}">${b.bookingCode}</c:when>
                                            <c:otherwise>Booking #${b.bookingID}</c:otherwise>
                                        </c:choose>
                                        - ${b.tourName} - ${b.customerName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Hướng dẫn viên</label>
                            <select name="userID" class="form-select" required>
                                <option value="">Chọn hướng dẫn viên</option>
                                <c:forEach var="g" items="${guideList}">
                                    <option value="${g.userID}" data-guide-id="${g.userID}">${g.firstName} ${g.lastName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Điểm hẹn</label>
                            <input type="text" name="meetingPoint" class="form-control"
                                   placeholder="VD: Cổng chính điểm hẹn">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Giờ đón</label>
                            <input type="datetime-local" name="pickupTime" id="pickupTime" class="form-control" readonly>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Hạn check-in</label>
                            <input type="datetime-local" name="checkInDeadline" id="checkInDeadline" class="form-control" readonly>
                        </div>
                    </div>

                    <div class="top-actions mt-4">
                        <button type="submit" class="top-action-btn btn-primary-action">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Lưu phân công
                        </button>

                        <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </section>

        <section class="panel mt-4">
            <div class="panel-header">
                <div>
                    <h2>Booking tour khả dụng</h2>
                    <p>Kiểm tra nhanh khách, tuyến và lịch trước khi phân công.</p>
                </div>
            </div>

            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle data-table">
                        <thead>
                        <tr>
                            <th>Booking</th>
                            <th>Khách</th>
                            <th>Tour</th>
                            <th>Tuyến</th>
                            <th>Lịch</th>
                            <th>Số khách</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${bookingList}">
                            <tr>
                                <td>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty b.bookingCode}">${b.bookingCode}</c:when>
                                            <c:otherwise>#${b.bookingID}</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <div class="text-muted small">ID: ${b.bookingID}</div>
                                </td>
                                <td>
                                    ${b.customerName}
                                    <div class="text-muted small">${b.customerPhone}</div>
                                </td>
                                <td>${b.tourName}</td>
                                <td>${b.startPlace} → ${b.endPlace}</td>
                                <td>
                                    <fmt:formatDate value="${b.departureDate}" pattern="dd/MM/yyyy"/>
                                    <c:if test="${not empty b.endDate}">
                                        <div class="text-muted small">
                                            đến <fmt:formatDate value="${b.endDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </c:if>
                                </td>
                                <td>${b.totalGuests} khách</td>
                                <td><span class="status-pill status-assigned">Đã thanh toán</span></td>
                                <td><fmt:formatNumber value="${b.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty bookingList}">
                            <tr>
                                <td colspan="8" class="text-center text-muted py-5">
                                    Chưa có booking tour đã thanh toán thành công nào có lịch trình để phân công.
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const bookingSelect = document.querySelector('select[name="bookingID"]');
        const guideSelect = document.querySelector('select[name="userID"]');
        const pickupTime = document.getElementById('pickupTime');
        const checkInDeadline = document.getElementById('checkInDeadline');

        function syncAssignmentTimes() {
            const option = bookingSelect?.selectedOptions?.[0];
            pickupTime.value = option?.dataset.pickupTime || '';
            checkInDeadline.value = option?.dataset.checkInDeadline || '';
            filterRejectedGuides(option?.dataset.rejectedGuideIds || '');
        }

        function filterRejectedGuides(rejectedGuideIDs) {
            const rejected = new Set(
                rejectedGuideIDs
                    .split(',')
                    .map(id => id.trim())
                    .filter(Boolean)
            );

            guideSelect?.querySelectorAll('option[data-guide-id]').forEach(option => {
                const rejectedForBooking = rejected.has(option.dataset.guideId);
                option.disabled = rejectedForBooking;
                option.hidden = rejectedForBooking;
            });

            if (guideSelect?.selectedOptions?.[0]?.disabled) {
                guideSelect.value = '';
            }
        }

        bookingSelect?.addEventListener('change', syncAssignmentTimes);
        syncAssignmentTimes();
    });
</script>
</body>
</html>
