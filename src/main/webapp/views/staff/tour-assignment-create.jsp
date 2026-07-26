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
    <link href="${pageContext.request.contextPath}/assets/css/assignment-workspace.css" rel="stylesheet">
</head>
<body>
<div class="workspace-layout">
    <aside class="workspace-sidebar">
        <div class="brand-box">
            <div class="brand-logo staff">WV</div>
            <h2>WonderVN</h2>
            <p>Khu vực nhân viên</p>
        </div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home"><i class="fa-solid fa-house"></i><span>Trang nhân viên</span></a>
        <div class="nav-section-title">Vận hành</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking"><i class="fa-solid fa-calendar-check"></i><span>Booking</span></a>
        <a class="sidebar-link active staff" href="${pageContext.request.contextPath}/staff/assignment"><i class="fa-solid fa-user-tie"></i><span>Điều phối hướng dẫn viên</span></a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour"><i class="fa-solid fa-map-location-dot"></i><span>Tour</span></a>
        <div class="nav-section-title">Tài khoản</div>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i><span>Đăng xuất</span></a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Thêm phân công tour</h1>
                <p>Phân công hướng dẫn viên còn rảnh cho một lịch tour đã xác nhận.</p>
            </div>
            <div class="top-actions">
                <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">
                    <i class="fa-solid fa-arrow-left"></i>Quay lại
                </a>
            </div>
        </div>

        <c:if test="${param.error == 'guideBusy'}"><div class="alert alert-danger">Hướng dẫn viên đang bận trong thời gian lịch tour này. Vui lòng chọn người khác.</div></c:if>
        <c:if test="${param.error == 'missing'}"><div class="alert alert-danger">Vui lòng chọn lịch tour và hướng dẫn viên.</div></c:if>
        <c:if test="${param.error == 'insert'}"><div class="alert alert-danger">Không thêm được phân công. Kiểm tra database hoặc dữ liệu nhập.</div></c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2>Thông tin phân công</h2>
                    <p>Lưu vào phân công tour và tự tạo mã ASG sau khi thêm.</p>
                </div>
            </div>
            <div class="panel-body">
                <form method="post" action="${pageContext.request.contextPath}/staff/assignment">
                    <input type="hidden" name="action" value="insert">

                    <div class="row g-4">
                        <div class="col-md-7">
                            <label class="form-label">Lịch tour</label>
                            <select name="tourScheduleID" class="form-select" required>
                                <option value="">Chọn lịch tour</option>
                                <c:forEach var="s" items="${scheduleList}">
                                    <option value="${s.tourScheduleID}" ${param.scheduleID == s.tourScheduleID ? 'selected' : ''}>
                                        #${s.tourScheduleID} - ${s.tourName} -
                                        <fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        (${s.bookingCount} booking, ${s.totalGuests} khách)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-5">
                            <label class="form-label">Hướng dẫn viên khả dụng</label>
                            <select name="userID" class="form-select" required>
                                <option value="">Chọn hướng dẫn viên</option>
                                <c:forEach var="g" items="${guideList}">
                                    <option value="${g.userID}">${g.firstName} ${g.lastName} - ${g.phone}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Vai trò</label>
                            <select name="roleInTour" class="form-select" required>
                                <option value="Tour Guide">Hướng dẫn viên</option>
                                <option value="Lead Guide">Trưởng đoàn</option>
                                <option value="Assistant Guide">Hướng dẫn viên phụ</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Điểm đón</label>
                            <input type="text" name="meetingPoint" class="form-control" placeholder="VD: Cổng chính điểm hẹn">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giờ đón</label>
                            <input type="datetime-local" name="pickupTime" class="form-control" readonly>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Hạn check-in</label>
                            <input type="datetime-local" name="checkInDeadline" class="form-control" readonly>
                        </div>
                    </div>

                    <div class="top-actions mt-4">
                        <button class="top-action-btn btn-primary-action" type="submit">
                            <i class="fa-solid fa-floppy-disk"></i>Lưu phân công
                        </button>
                        <a class="top-action-btn btn-light-action" href="${pageContext.request.contextPath}/staff/assignment">Hủy</a>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>
</body>
</html>
