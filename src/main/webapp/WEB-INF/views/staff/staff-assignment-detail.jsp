<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phân công nhân sự - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />

    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>

        <section class="staff-content">
            <div class="breadcrumb">Staff / Phân công nhân sự / Chi tiết</div>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Phân công nhân sự cho lịch khởi hành</h1>
                    <div class="page-subtitle">Nhân sự được phân công sẽ nhận lịch và trạng thái nhiệm vụ trong tour.</div>
                </div>
                <div class="form-actions-right">
                    <a class="btn" href="${pageContext.request.contextPath}/staff/assignments">← Danh sách lịch</a>
                    <c:if test="${not empty schedule}">
                        <a class="btn" href="${pageContext.request.contextPath}/staff/resources/assign?tourScheduleID=${schedule.tourScheduleID}">Tài nguyên tour →</a>
                    </c:if>
                </div>
            </div>

            <c:if test="${not empty param.success}"><div class="alert alert-success"><c:out value="${param.success}" /></div></c:if>
            <c:if test="${not empty param.error}"><div class="alert alert-error"><c:out value="${param.error}" /></div></c:if>
            <c:if test="${not empty systemError}"><div class="alert alert-error"><c:out value="${systemError}" /></div></c:if>
            <c:if test="${not empty fieldErrors.schedule}"><div class="alert alert-error"><c:out value="${fieldErrors.schedule}" /></div></c:if>

            <c:choose>
                <c:when test="${empty schedule}">
                    <div class="card card-section">Không tìm thấy lịch khởi hành.</div>
                </c:when>
                <c:otherwise>
                    <div class="card card-section resource-summary-card">
                        <div>
                            <h2><c:out value="${schedule.tourCode}" /> - <c:out value="${schedule.tourName}" /></h2>
                            <p>
                                <fmt:formatDate value="${schedule.departureDate}" pattern="dd/MM/yyyy" />
                                →
                                <fmt:formatDate value="${schedule.returnDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                        <div class="resource-summary-stats">
                            <div><span>Khách đã đặt</span><strong><c:out value="${schedule.passengerSummary}" /></strong></div>
                            <div><span>Tối thiểu</span><strong><c:out value="${schedule.minParticipants}" /> khách</strong></div>
                            <div><span>Hạn chót bán</span><strong><fmt:formatDate value="${schedule.bookingDeadline}" pattern="dd/MM/yyyy HH:mm" /></strong></div>
                            <div><span>Trạng thái</span><strong><c:out value="${schedule.scheduleStatusText}" /></strong></div>
                        </div>
                    </div>

                    <div class="resource-page-grid staff-assignment-page-grid">
                        <form class="card card-section" method="post" action="${pageContext.request.contextPath}/staff/assignments/detail" id="staffAssignmentForm" novalidate>
                            <input type="hidden" name="tourScheduleID" value="${schedule.tourScheduleID}">
                            <h2 class="section-title"><span class="section-index">1</span> Thêm nhân sự nhận nhiệm vụ</h2>

                            <div class="form-grid grid-2">
                                <div class="form-group">
                                    <label>Nhiệm vụ trong tour <span class="required">*</span></label>
                                    <select class="form-select" name="roleInTour" id="roleInTour" required>
                                        <option value="">-- Chọn nhiệm vụ --</option>
                                        <option value="Guide" ${old.roleInTour == 'Guide' ? 'selected' : ''}>Hướng dẫn viên</option>
                                        <option value="Driver" ${old.roleInTour == 'Driver' ? 'selected' : ''}>Tài xế</option>
                                        <option value="Other" ${old.roleInTour == 'Other' ? 'selected' : ''}>Nhiệm vụ khác</option>
                                    </select>
                                    <c:if test="${not empty fieldErrors.roleInTour}"><small class="field-error"><c:out value="${fieldErrors.roleInTour}" /></small></c:if>
                                </div>

                                <div class="form-group">
                                    <label>Nhân viên nhận nhiệm vụ <span class="required">*</span></label>
                                    <select class="form-select" name="staffID" id="staffID" required>
                                        <option value="">-- Chọn nhân viên --</option>
                                        <c:forEach var="staff" items="${staffOptions}">
                                            <option value="${staff.staffID}"
                                                    data-type="${staff.staffType}"
                                                    ${old.staffID == staff.staffID ? 'selected' : ''}>
                                                <c:out value="${staff.displayName}" /> · <c:out value="${staff.staffType}" /> · <c:out value="${staff.phone}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-hint">Danh sách chỉ gồm nhân viên đang làm việc và tài khoản còn hoạt động.</small>
                                    <c:if test="${not empty fieldErrors.staffID}"><small class="field-error"><c:out value="${fieldErrors.staffID}" /></small></c:if>
                                </div>

                                <div class="form-group">
                                    <label>Trạng thái ban đầu</label>
                                    <select class="form-select" name="assignmentStatus">
                                        <option value="Pending" ${empty old.assignmentStatus || old.assignmentStatus == 'Pending' ? 'selected' : ''}>Chờ nhân viên nhận nhiệm vụ</option>
                                        <option value="Accepted" ${old.assignmentStatus == 'Accepted' ? 'selected' : ''}>Đã xác nhận nhận nhiệm vụ</option>
                                    </select>
                                </div>

                                <div class="form-group form-group-full">
                                    <label>Ghi chú nhiệm vụ</label>
                                    <textarea class="form-control" name="note" maxlength="500" placeholder="Ví dụ: Có mặt tại điểm đón trước 30 phút, liên hệ trưởng đoàn..."><c:out value="${old.note}" /></textarea>
                                    <c:if test="${not empty fieldErrors.note}"><small class="field-error"><c:out value="${fieldErrors.note}" /></small></c:if>
                                </div>
                            </div>

                            <div class="validation-summary" id="staffAssignmentClientError" style="display:none"></div>

                            <div class="form-actions">
                                <button class="btn btn-primary" type="submit" id="saveStaffAssignmentBtn">Lưu phân công</button>
                                <a class="btn" href="${pageContext.request.contextPath}/staff/assignments/detail?tourScheduleID=${schedule.tourScheduleID}">Làm mới</a>
                            </div>
                        </form>

                        <div class="card resource-assignment-card">
                            <div class="card-section table-card-heading">
                                <h2 class="section-title"><span class="section-index">2</span> Danh sách nhân sự đã phân công</h2>
                            </div>
                            <table class="tour-table compact-table">
                                <thead>
                                <tr>
                                    <th>Nhân viên</th>
                                    <th>Nhiệm vụ</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                    <th>Cập nhật</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="a" items="${assignments}">
                                    <tr class="${a.assignmentStatus == 'Cancelled' || a.assignmentStatus == 'Rejected' ? 'muted-row' : ''}">
                                        <td>
                                            <strong><c:out value="${a.staffCode}" /> - <c:out value="${a.staffName}" /></strong><br>
                                            <span class="muted-text"><c:out value="${a.phone}" /> · <c:out value="${a.staffType}" /></span>
                                        </td>
                                        <td><c:out value="${a.roleText}" /></td>
                                        <td><span class="status-pill ${a.statusCssClass}"><c:out value="${a.statusText}" /></span></td>
                                        <td><c:out value="${a.note}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.assignmentStatus == 'Pending' || a.assignmentStatus == 'Accepted'}">
                                                    <form class="inline-form staff-status-form" method="post" action="${pageContext.request.contextPath}/staff/assignments/status">
                                                        <input type="hidden" name="assignmentID" value="${a.assignmentID}">
                                                        <input type="hidden" name="tourScheduleID" value="${schedule.tourScheduleID}">
                                                        <select class="form-select table-input" name="assignmentStatus" required>
                                                            <c:if test="${a.assignmentStatus == 'Pending'}">
                                                                <option value="Accepted">Đã nhận</option>
                                                                <option value="Rejected">Từ chối</option>
                                                                <option value="Cancelled">Hủy</option>
                                                            </c:if>
                                                            <c:if test="${a.assignmentStatus == 'Accepted'}">
                                                                <option value="Completed">Hoàn thành</option>
                                                                <option value="Cancelled">Hủy</option>
                                                            </c:if>
                                                        </select>
                                                        <input class="form-control table-input" name="note" maxlength="500" placeholder="Ghi chú">
                                                        <button class="btn btn-small btn-primary" type="submit">Lưu</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>Đã kết thúc</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty assignments}">
                                    <tr><td colspan="5">Chưa có nhân sự nào được phân công cho lịch này.</td></tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>

<script>
(function () {
    const form = document.getElementById('staffAssignmentForm');
    const roleSelect = document.getElementById('roleInTour');
    const staffSelect = document.getElementById('staffID');
    const errorBox = document.getElementById('staffAssignmentClientError');

    function roleMatchesStaff(role, type) {
        if (!role || !type) return true;
        if (role === 'Guide') return type === 'Guide';
        if (role === 'Driver') return type === 'Driver';
        if (role === 'Coordinator') return ['Coordinator', 'OperationStaff', 'Staff'].includes(type);
        if (role === 'OperationStaff') return ['OperationStaff', 'Coordinator', 'Staff'].includes(type);
        return true;
    }

    function filterStaffOptions() {
        if (!roleSelect || !staffSelect) return;
        const role = roleSelect.value;
        let selectedStillVisible = false;
        Array.from(staffSelect.options).forEach(option => {
            if (!option.value) {
                option.hidden = false;
                return;
            }
            const visible = roleMatchesStaff(role, option.dataset.type);
            option.hidden = !visible;
            if (visible && option.selected) selectedStillVisible = true;
        });
        if (!selectedStillVisible) staffSelect.value = '';
    }

    function showClientErrors(errors) {
        if (!errorBox) return;
        if (!errors.length) {
            errorBox.style.display = 'none';
            errorBox.innerHTML = '';
            return;
        }
        errorBox.style.display = 'block';
        errorBox.innerHTML = '<strong>Vui lòng kiểm tra lại:</strong><ul>' + errors.map(e => '<li>' + e + '</li>').join('') + '</ul>';
    }

    if (roleSelect) roleSelect.addEventListener('change', filterStaffOptions);
    filterStaffOptions();

    if (form) {
        form.addEventListener('submit', function (event) {
            const errors = [];
            if (!roleSelect.value) errors.push('Bạn cần chọn nhiệm vụ trong tour.');
            if (!staffSelect.value) errors.push('Bạn cần chọn nhân viên nhận nhiệm vụ.');
            const selected = staffSelect.options[staffSelect.selectedIndex];
            if (selected && selected.value && !roleMatchesStaff(roleSelect.value, selected.dataset.type)) {
                errors.push('Nhân viên được chọn không phù hợp với nhiệm vụ.');
            }
            if (errors.length) {
                event.preventDefault();
                showClientErrors(errors);
            }
        });
    }
})();
</script>
</body>
</html>
