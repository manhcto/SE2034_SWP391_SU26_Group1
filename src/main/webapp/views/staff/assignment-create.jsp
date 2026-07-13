<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WonderVN | Thêm phân công tour</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>

<body>
<div class="workspace-layout">
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

        <c:if test="${param.error == 'paymentRequired'}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                Chỉ những booking đã thanh toán mới được phân công tour.
            </div>
        </c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Thông tin phân công</h2>
                    <p>Chỉ hiển thị booking tour đã thanh toán và lưu trực tiếp vào bảng Tour_Assignments.</p>
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
                                    <option value="${b.bookingID}">
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
                                    <option value="${g.userID}">${g.firstName} ${g.lastName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Vai trò</label>
                            <select name="roleInTour" class="form-select" required>
                                <option value="Hướng dẫn viên">Hướng dẫn viên</option>
                                <option value="Trưởng đoàn">Trưởng đoàn</option>
                                <option value="Hướng dẫn viên phụ">Hướng dẫn viên phụ</option>
                                <option value="Điều phối viên tour">Điều phối viên tour</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Trạng thái assignment</label>
                            <select name="assignmentStatus" class="form-select" required>
                                <option value="Pending">Pending</option>
                                <option value="Accepted">Accepted</option>
                                <option value="Confirmed">Confirmed</option>
                                <option value="In Progress">In Progress</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="Rejected">Rejected</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Độ ưu tiên</label>
                            <select name="priorityLevel" class="form-select" required>
                                <option value="Normal">Normal</option>
                                <option value="Low">Low</option>
                                <option value="High">High</option>
                                <option value="Urgent">Urgent</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Điểm hẹn</label>
                            <input type="text" name="meetingPoint" class="form-control"
                                   placeholder="VD: Cổng chính điểm hẹn">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Giờ đón</label>
                            <input type="datetime-local" name="pickupTime" class="form-control">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Deadline check-in</label>
                            <input type="datetime-local" name="checkInDeadline" class="form-control">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú staff</label>
                            <textarea name="staffNote" class="form-control" rows="4"></textarea>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú cho guide</label>
                            <textarea name="guideNote" class="form-control" rows="4"></textarea>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Ghi chú cho khách</label>
                            <textarea name="customerNote" class="form-control" rows="4"></textarea>
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
                                    ${b.departureDate}
                                    <div class="text-muted small">đến ${b.endDate}</div>
                                </td>
                                <td>${b.totalGuests} khách</td>
                                <td>${b.totalPrice}</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty bookingList}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-5">
                                    Chưa có booking tour nào có lịch trình để phân công.
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
</body>
</html>
