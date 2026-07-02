<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Staff Edit Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            font-family: "Be Vietnam Pro", Arial, sans-serif;
            color: #0f172a;
        }

        .staff-layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 292px;
            background: #0f172a;
            color: #ffffff;
            position: fixed;
            inset: 0 auto 0 0;
            overflow-y: auto;
            padding: 26px 18px;
            box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18);
        }

        .sidebar::-webkit-scrollbar {
            width: 7px;
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: #334155;
            border-radius: 20px;
        }

        .brand-box {
            padding: 8px 10px 22px;
            margin-bottom: 12px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
        }

        .brand-logo {
            width: 52px;
            height: 52px;
            border-radius: 18px;
            background: linear-gradient(135deg, #06b6d4, #4e46dc);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 20px;
            margin-bottom: 12px;
        }

        .brand-box h2 {
            font-size: 26px;
            font-weight: 800;
            margin: 0;
            letter-spacing: -0.6px;
        }

        .brand-box p {
            color: #cbd5e1;
            margin: 5px 0 0;
            font-size: 14px;
        }

        .nav-section-title {
            font-size: 11px;
            text-transform: uppercase;
            color: #94a3b8;
            letter-spacing: 1.2px;
            margin: 22px 12px 10px;
            font-weight: 800;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 14px;
            border-radius: 15px;
            color: #e2e8f0;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 8px;
            transition: all 0.2s ease;
        }

        .sidebar-link i {
            width: 22px;
            text-align: center;
            font-size: 16px;
        }

        .sidebar-link:hover {
            background: #1e293b;
            color: white;
            transform: translateX(4px);
        }

        .sidebar-link.active {
            background: linear-gradient(135deg, #06b6d4, #4e46dc);
            color: white;
            box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22);
        }

        .admin-user {
            margin-top: 26px;
            border-top: 1px solid rgba(148, 163, 184, 0.25);
            padding: 18px 8px 4px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #06b6d4, #22c55e);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            color: white;
        }

        .admin-user small {
            color: #94a3b8;
        }

        .main-content {
            margin-left: 292px;
            width: calc(100% - 292px);
            padding: 34px 42px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 26px;
        }

        .topbar h1 {
            font-size: 34px;
            font-weight: 900;
            margin: 0;
            letter-spacing: -0.8px;
        }

        .topbar p {
            color: #64748b;
            margin: 6px 0 0;
            font-size: 15px;
        }

        .top-action-btn {
            border: none;
            border-radius: 16px;
            padding: 12px 18px;
            text-decoration: none;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
            background: #0f172a;
            color: #ffffff;
        }

        .top-action-btn:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .error-box {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #f87171;
            border-radius: 18px;
            padding: 18px 22px;
            margin-bottom: 22px;
            font-weight: 700;
            line-height: 1.7;
        }

        .error-box ul {
            margin: 8px 0 0;
            padding-left: 22px;
        }

        .edit-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 26px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .booking-info {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 18px;
            margin-bottom: 24px;
        }

        .info-label {
            display: block;
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .info-value {
            color: #0f172a;
            font-size: 15px;
            font-weight: 900;
        }

        .form-label {
            font-weight: 800;
            color: #334155;
        }

        .form-control,
        .form-select {
            border-radius: 14px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            font-weight: 600;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #4e46dc;
            box-shadow: 0 0 0 0.2rem rgba(78, 70, 220, 0.12);
        }

        .form-control.input-error,
        .form-select.input-error {
            border-color: #ef4444;
            box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.12);
        }

        .form-control.input-error:focus,
        .form-select.input-error:focus {
            border-color: #ef4444;
            box-shadow: 0 0 0 0.2rem rgba(239, 68, 68, 0.12);
        }

        .form-control.input-valid:focus,
        .form-select.input-valid:focus {
            border-color: #22c55e;
            box-shadow: 0 0 0 0.2rem rgba(34, 197, 94, 0.12);
        }

        .field-error-message {
            display: none;
            color: #dc2626;
            font-size: 12px;
            font-weight: 500;
            margin-top: 6px;
            line-height: 1.35;
        }

        .field-error-message.show {
            display: block;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 26px;
        }

        .btn-save,
        .btn-back {
            min-width: 170px;
            border-radius: 999px;
            padding: 12px 22px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: none;
        }

        .btn-save {
            background: #4e46dc;
            color: #ffffff;
        }

        .btn-save:hover {
            background: #3730a3;
            color: #ffffff;
        }

        .btn-back {
            background: #ffffff;
            color: #4e46dc;
            border: 1px solid #4e46dc;
        }

        .btn-back:hover {
            background: #eef2ff;
            color: #4e46dc;
        }

        @media (max-width: 992px) {
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .staff-layout {
                display: block;
            }

            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .topbar {
                display: block;
            }

            .top-action-btn {
                margin-top: 16px;
            }
        }
    </style>
</head>

<body>
<div class="staff-layout">

    <aside class="sidebar">
        <div class="brand-box">
            <div class="brand-logo">WV</div>
            <h2>WonderVN</h2>
            <p>Travel ERP System</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ nhân viên</span>
        </a>

        <div class="nav-section-title">Dịch vụ du lịch</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
            <i class="fa-solid fa-map-location-dot"></i>
            <span>Quản lý Tour</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
            <i class="fa-solid fa-hotel"></i>
            <span>Quản lý lưu trú</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/vehicle?action=list">
            <i class="fa-solid fa-car-side"></i>
            <span>Quản lý phương tiện</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/service">
            <i class="fa-solid fa-briefcase"></i>
            <span>Quản lý dịch vụ</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/external-ticket">
            <i class="fa-solid fa-ticket"></i>
            <span>Vé tham quan bên ngoài</span>
        </a>

        <div class="nav-section-title">Vận hành</div>

        <a class="sidebar-link active" href="${pageContext.request.contextPath}/staff/booking">
            <i class="fa-solid fa-calendar-check"></i>
            <span>Quản lý đặt chỗ</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/payment">
            <i class="fa-solid fa-credit-card"></i>
            <span>Quản lý thanh toán</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/voucher">
            <i class="fa-solid fa-gift"></i>
            <span>Quản lý Voucher</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/assignment">
            <i class="fa-solid fa-user-tie"></i>
            <span>Điều phối hướng dẫn viên</span>
        </a>

        <div class="nav-section-title">Nội dung & CSKH</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/blog">
            <i class="fa-solid fa-newspaper"></i>
            <span>Quản lý Blog</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
            <i class="fa-solid fa-comments"></i>
            <span>Đánh giá khách hàng</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/notification">
            <i class="fa-solid fa-bell"></i>
            <span>Cấu hình thông báo</span>
        </a>

        <div class="admin-user">
            <div class="avatar">AD</div>
            <div>
                <div class="fw-bold">Quản trị viên</div>
                <small>Staff</small>
            </div>
        </div>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Sửa Booking</h1>
            </div>

            <a class="top-action-btn" href="${pageContext.request.contextPath}/staff/booking">
                <i class="fa-solid fa-arrow-left"></i>
                Quay lại danh sách
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="error-box">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty errors}">
            <div class="error-box">
                <div>
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    Vui lòng kiểm tra lại các thông tin sau:
                </div>

                <ul>
                    <c:forEach items="${errors}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <c:if test="${not empty booking}">
            <div class="edit-card">
                <div class="booking-info">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <span class="info-label">Booking ID</span>
                            <span class="info-value">${booking.bookingID}</span>
                        </div>

                        <div class="col-md-3">
                            <span class="info-label">Mã Booking</span>
                            <span class="info-value">${booking.bookingCode}</span>
                        </div>

                        <div class="col-md-3">
                            <span class="info-label">Ngày đặt</span>
                            <span class="info-value">
                                <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>

                        <div class="col-md-3">
                            <span class="info-label">Tổng tiền</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                            </span>
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-2">
                            <span class="info-label">Loại booking</span>
                            <span class="info-value">${booking.displayType}</span>
                        </div>

                        <div class="col-md-4">
                            <span class="info-label">Dịch vụ</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty booking.serviceName}">
                                        ${booking.serviceName}
                                    </c:when>
                                    <c:otherwise>Chưa có dịch vụ</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="col-md-3">
                            <span class="info-label">Lịch sử dụng</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty booking.serviceStartDate || not empty booking.serviceEndDate}">
                                        <fmt:formatDate value="${booking.serviceStartDate}" pattern="dd/MM/yyyy"/>
                                        <c:if test="${not empty booking.serviceEndDate}">
                                            - <fmt:formatDate value="${booking.serviceEndDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>Chưa có lịch</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="col-md-3">
                            <span class="info-label">Số khách</span>
                            <span class="info-value">${booking.totalGuests} khách (${booking.numberAdult} NL, ${booking.numberChildren} TE)</span>
                        </div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/staff/booking-edit" method="post" novalidate>
                    <input type="hidden" name="bookingID" value="${booking.bookingID}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <span class="info-label">Tên khách hàng</span>
                            <span class="info-value">${booking.firstName} ${booking.lastName}</span>
                        </div>

                        <div class="col-md-6">
                            <span class="info-label">Email</span>
                            <span class="info-value">${booking.email}</span>
                        </div>

                        <div class="col-md-6">
                            <span class="info-label">Số điện thoại</span>
                            <span class="info-value">${booking.phone}</span>
                        </div>

                        <div class="col-md-6">
                            <span class="info-label">Đặt hộ người khác</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${booking.bookedForOther}">Có</c:when>
                                    <c:otherwise>Không</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="col-md-12">
                            <span class="info-label">Địa chỉ liên hệ</span>
                            <span class="info-value">${booking.address}</span>
                        </div>

                        <div class="col-md-6">
                            <span class="info-label">Số người lớn</span>
                            <span class="info-value">${booking.numberAdult}</span>
                        </div>

                        <div class="col-md-6">
                            <span class="info-label">Số trẻ em</span>
                            <span class="info-value">${booking.numberChildren}</span>
                        </div>

                        <div class="col-md-6">
                            <span class="info-label">Ghi chú khách hàng</span>
                            <span class="info-value">${booking.note}</span>
                        </div>

                        <div class="col-md-6">
                            <label for="status" class="form-label">Trạng thái Booking</label>
                            <select class="form-select" id="status" name="status">
                                <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                            </select>
                        </div>

                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-save">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Lưu thay đổi
                        </button>

                        <a href="${pageContext.request.contextPath}/staff/booking"
                           class="btn-back">
                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại danh sách
                        </a>
                    </div>
                </form>
            </div>
        </c:if>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
