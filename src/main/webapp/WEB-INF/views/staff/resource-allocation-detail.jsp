<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phân bổ tài nguyên - WonderVN Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-tour.css">
</head>
<body>
<div class="staff-layout">
    <jsp:include page="/WEB-INF/views/staff/layout/staff-navbar.jsp" />

    <main class="staff-main">
        <header class="staff-topbar">🔔 &nbsp; ◎</header>

        <section class="staff-content">
            <div class="breadcrumb">Staff / Phân bổ tài nguyên</div>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Chi tiết phân bổ tài nguyên</h1>
                    <div class="page-subtitle">Gán tài nguyên vận hành cho từng lịch khởi hành cụ thể.</div>
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/staff/resources">← Danh sách lịch</a>
            </div>

            <c:if test="${not empty param.success}"><div class="alert alert-success"><c:out value="${param.success}" /></div></c:if>
            <c:if test="${not empty param.error}"><div class="alert alert-error"><c:out value="${param.error}" /></div></c:if>
            <c:if test="${not empty systemError}"><div class="alert alert-error"><c:out value="${systemError}" /></div></c:if>

            <c:if test="${not empty schedule}">
                <div class="card card-section resource-summary-card">
                    <div>
                        <h2><c:out value="${schedule.tourCode}" /> - <c:out value="${schedule.tourName}" /></h2>
                        <p>
                            Khởi hành <strong><fmt:formatDate value="${schedule.departureDate}" pattern="dd/MM/yyyy" /></strong>
                            · Về <strong><fmt:formatDate value="${schedule.returnDate}" pattern="dd/MM/yyyy" /></strong>
                            · Hạn chót bán
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty schedule.bookingDeadline}"><fmt:formatDate value="${schedule.bookingDeadline}" pattern="dd/MM/yyyy HH:mm" /></c:when>
                                    <c:otherwise>chưa cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>
                    </div>
                    <div class="resource-summary-stats">
                        <div><span>Đã đặt</span><strong><c:out value="${schedule.bookedSeats}" />/<c:out value="${schedule.maxParticipants}" /></strong></div>
                        <div><span>Tối thiểu</span><strong><c:out value="${schedule.minParticipants}" /> khách</strong></div>
                        <div><span>Tài nguyên</span><strong><c:out value="${schedule.resourceCount}" /> mục</strong></div>
                        <div><span>Trạng thái</span><strong><c:out value="${schedule.scheduleStatusText}" /></strong></div>
                    </div>
                </div>

                <div class="resource-page-grid">
                    <form class="card card-section" method="post" action="${pageContext.request.contextPath}/staff/resources/assign">
                        <input type="hidden" name="tourScheduleID" value="${schedule.tourScheduleID}">
                        <h2 class="section-title"><span class="section-index">1</span> Thêm tài nguyên</h2>

                        <div class="form-grid grid-2">
                            <div class="form-group">
                                <label>Loại phân bổ <span class="required">*</span></label>
                                <select class="form-select" name="assignmentCategory" id="assignmentCategory" required>
                                    <option value="">Chọn loại</option>
                                    <option value="Vehicle">Xe/Phương tiện</option>
                                    <option value="Accommodation">Lưu trú</option>
                                    <option value="Room">Phòng</option>
                                    <option value="Restaurant">Nhà hàng</option>
                                    <option value="Meal">Bữa ăn</option>
                                    <option value="Entertainment">Điểm vui chơi</option>
                                    <option value="Insurance">Bảo hiểm</option>
                                    <option value="Guide">Hướng dẫn viên</option>
                                    <option value="Other">Khác</option>
                                </select>
                                <c:if test="${not empty fieldErrors.assignmentCategory}"><small class="field-error"><c:out value="${fieldErrors.assignmentCategory}" /></small></c:if>
                            </div>

                            <div class="form-group">
                                <label>Dịch vụ/tài nguyên <span class="required">*</span></label>
                                <select class="form-select" name="serviceID" required>
                                    <option value="">Chọn dịch vụ</option>
                                    <c:forEach var="service" items="${services}">
                                        <option value="${service.value}" data-type="${service.type}" data-price="${service.price}">
                                            <c:out value="${service.label}" />
                                            <c:if test="${not empty service.type}"> - <c:out value="${service.type}" /></c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.serviceID}"><small class="field-error"><c:out value="${fieldErrors.serviceID}" /></small></c:if>
                            </div>

                            <div class="form-group resource-field resource-vehicle-field">
                                <label>Xe cụ thể</label>
                                <select class="form-select" name="vehicleID">
                                    <option value="">Chọn xe</option>
                                    <c:forEach var="vehicle" items="${vehicles}">
                                        <option value="${vehicle.value}"><c:out value="${vehicle.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.vehicleID}"><small class="field-error"><c:out value="${fieldErrors.vehicleID}" /></small></c:if>
                            </div>

                            <div class="form-group resource-field resource-vehicle-field">
                                <label>Tài xế</label>
                                <select class="form-select" name="driverStaffID">
                                    <option value="">Chọn tài xế</option>
                                    <c:forEach var="driver" items="${drivers}">
                                        <option value="${driver.value}"><c:out value="${driver.label}" /></option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group resource-field resource-room-field">
                                <label>Phòng cụ thể</label>
                                <select class="form-select" name="roomID">
                                    <option value="">Chọn phòng</option>
                                    <c:forEach var="room" items="${rooms}">
                                        <option value="${room.value}"><c:out value="${room.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.roomID}"><small class="field-error"><c:out value="${fieldErrors.roomID}" /></small></c:if>
                            </div>

                            <div class="form-group resource-field resource-meal-field">
                                <label>Gói ăn</label>
                                <select class="form-select" name="mealPackageID">
                                    <option value="">Chọn gói ăn</option>
                                    <c:forEach var="meal" items="${mealPackages}">
                                        <option value="${meal.value}"><c:out value="${meal.label}" /></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty fieldErrors.mealPackageID}"><small class="field-error"><c:out value="${fieldErrors.mealPackageID}" /></small></c:if>
                            </div>

                            <div class="form-group">
                                <label>Ngày dùng dịch vụ</label>
                                <input class="form-control" type="date" name="serviceDate">
                            </div>
                            <div class="form-group">
                                <label>Ngày bắt đầu</label>
                                <input class="form-control" type="date" name="startDate">
                            </div>
                            <div class="form-group">
                                <label>Ngày kết thúc</label>
                                <input class="form-control" type="date" name="endDate">
                                <c:if test="${not empty fieldErrors.endDate}"><small class="field-error"><c:out value="${fieldErrors.endDate}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Số lượng <span class="required">*</span></label>
                                <input class="form-control" type="number" name="quantity" value="1" min="1" required>
                                <c:if test="${not empty fieldErrors.quantity}"><small class="field-error"><c:out value="${fieldErrors.quantity}" /></small></c:if>
                            </div>
                            <div class="form-group">
                                <label>Số khách dự kiến</label>
                                <input class="form-control" type="number" name="participantEstimate" min="0" value="${schedule.bookedSeats}">
                            </div>
                            <div class="form-group">
                                <label>Chi phí dự kiến</label>
                                <input class="form-control" type="number" name="estimatedCost" min="0">
                            </div>
                            <div class="form-group">
                                <label>Chi phí thực tế</label>
                                <input class="form-control" type="number" name="actualCost" min="0">
                            </div>
                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select class="form-select" name="assignmentStatus">
                                    <option value="Planned">Dự kiến</option>
                                    <option value="Confirmed">Đã xác nhận</option>
                                    <option value="InUse">Đang sử dụng</option>
                                    <option value="Completed">Hoàn thành</option>
                                </select>
                            </div>
                            <div class="form-group form-group-full">
                                <label>Ghi chú</label>
                                <textarea name="note" rows="3" placeholder="Ghi chú điều phối, yêu cầu đặc biệt..."></textarea>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button class="btn btn-primary" type="submit">+ Thêm phân bổ</button>
                        </div>
                    </form>

                    <div class="card table-card resource-assignment-card">
                        <div class="card-section table-card-heading">
                            <h2 class="section-title"><span class="section-index">2</span> Tài nguyên đã phân bổ</h2>
                        </div>
                        <table class="tour-table compact-table">
                            <thead>
                            <tr>
                                <th>Loại</th>
                                <th>Dịch vụ</th>
                                <th>Chi tiết</th>
                                <th>SL</th>
                                <th>Chi phí</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty assignments}">
                                    <tr><td colspan="7">Chưa phân bổ tài nguyên nào.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${assignments}">
                                        <tr class="${item.assignmentStatus == 'Cancelled' ? 'muted-row' : ''}">
                                            <td><c:out value="${item.categoryText}" /></td>
                                            <td><strong><c:out value="${item.serviceName}" /></strong><br><small><c:out value="${item.note}" /></small></td>
                                            <td>
                                                <c:if test="${not empty item.vehicleName}">Xe: <c:out value="${item.vehicleName}" /> <c:out value="${item.licensePlate}" /><br></c:if>
                                                <c:if test="${not empty item.driverName}">Tài xế: <c:out value="${item.driverName}" /><br></c:if>
                                                <c:if test="${not empty item.roomName}">Phòng: <c:out value="${item.roomName}" /><br></c:if>
                                                <c:if test="${not empty item.mealPackageName}">Gói ăn: <c:out value="${item.mealPackageName}" /><br></c:if>
                                                <c:if test="${not empty item.startDate}">
                                                    <fmt:formatDate value="${item.startDate}" pattern="dd/MM" /> - <fmt:formatDate value="${item.endDate}" pattern="dd/MM" />
                                                </c:if>
                                            </td>
                                            <td><c:out value="${item.quantity}" /></td>
                                            <td>
                                                <c:if test="${not empty item.estimatedCost}"><fmt:formatNumber value="${item.estimatedCost}" pattern="#,##0" />đ</c:if>
                                            </td>
                                            <td><c:out value="${item.statusText}" /></td>
                                            <td>
                                                <c:if test="${item.assignmentStatus != 'Cancelled'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/staff/resources/status" class="inline-form">
                                                        <input type="hidden" name="tourScheduleID" value="${schedule.tourScheduleID}">
                                                        <input type="hidden" name="assignmentID" value="${item.assignmentID}">
                                                        <input type="hidden" name="assignmentStatus" value="Cancelled">
                                                        <button class="link-button danger-text" type="submit">Hủy</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </section>
    </main>
</div>

<script>
    (function () {
        const category = document.getElementById('assignmentCategory');
        const fields = document.querySelectorAll('.resource-field');

        function updateFields() {
            const value = category ? category.value : '';
            fields.forEach(field => field.style.display = 'none');
            document.querySelectorAll('.resource-vehicle-field').forEach(field => field.style.display = value === 'Vehicle' ? '' : 'none');
            document.querySelectorAll('.resource-room-field').forEach(field => field.style.display = value === 'Room' ? '' : 'none');
            document.querySelectorAll('.resource-meal-field').forEach(field => field.style.display = value === 'Meal' ? '' : 'none');
        }

        if (category) {
            category.addEventListener('change', updateFields);
            updateFields();
        }
    })();
</script>
</body>
</html>
