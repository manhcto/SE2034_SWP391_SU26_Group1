<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Staff Booking Management</title>
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

    .success-box {
      background: #dcfce7;
      color: #166534;
      border: 1px solid #86efac;
      border-radius: 18px;
      padding: 16px 20px;
      font-weight: 800;
      margin-bottom: 20px;
    }

    .error-box {
      background: #fee2e2;
      color: #991b1b;
      border: 1px solid #fca5a5;
      border-radius: 18px;
      padding: 16px 20px;
      font-weight: 800;
      margin-bottom: 20px;
    }

    .content-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 24px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
      width: 100%;
      overflow: hidden;
    }

    .summary-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 18px;
      margin-bottom: 22px;
    }

    .summary-card,
    .filter-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 22px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
    }

    .summary-card {
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .summary-icon {
      width: 48px;
      height: 48px;
      border-radius: 16px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      background: #eef2ff;
      color: #4e46dc;
      font-size: 20px;
    }

    .summary-label {
      color: #64748b;
      font-size: 13px;
      font-weight: 800;
      margin-bottom: 3px;
    }

    .summary-value {
      color: #0f172a;
      font-size: 26px;
      font-weight: 900;
      line-height: 1;
    }

    .filter-card {
      padding: 18px;
      margin-bottom: 22px;
    }

    .filter-card .form-control,
    .filter-card .form-select {
      height: 48px;
      border-radius: 14px;
      border: 1px solid #cbd5e1;
      font-weight: 700;
    }

    .table-responsive {
      overflow-x: auto;
      width: 100%;
    }

    .table {
      width: 100%;
      margin-bottom: 0;
      min-width: 1280px;
    }

    .table-responsive > table:not(#bookingTable) {
      display: none;
    }

    .table thead th {
      background: #f8fafc;
      color: #334155;
      font-size: 13px;
      font-weight: 900;
      border-bottom: 1px solid #e2e8f0;
      padding: 14px 10px;
      white-space: normal;
      vertical-align: middle;
    }

    .table tbody td {
      padding: 14px 10px;
      vertical-align: middle;
      color: #0f172a;
      font-size: 13px;
      word-break: break-word;
    }

    .booking-code {
      font-weight: 900;
      color: #4e46dc;
      word-break: break-word;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 6px 10px;
      border-radius: 999px;
      background: #e0f2fe;
      color: #075985;
      font-size: 12px;
      font-weight: 800;
    }

    .status-badge.pending {
      background: #fef3c7;
      color: #92400e;
    }

    .status-badge.confirmed {
      background: #dbeafe;
      color: #1d4ed8;
    }

    .status-badge.completed {
      background: #dcfce7;
      color: #166534;
    }

    .status-badge.cancelled {
      background: #fee2e2;
      color: #991b1b;
    }

    .type-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      border-radius: 999px;
      padding: 6px 10px;
      background: #f1f5f9;
      color: #334155;
      font-size: 12px;
      font-weight: 900;
      white-space: nowrap;
    }

    .action-group {
      display: flex;
      align-items: center;
      gap: 6px;
      flex-wrap: wrap;
    }

    .btn-edit {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 5px;
      padding: 8px 11px;
      border-radius: 999px;
      background: #4e46dc;
      color: #ffffff;
      text-decoration: none;
      font-size: 12px;
      font-weight: 900;
      white-space: nowrap;
      border: none;
    }

    .btn-edit:hover {
      background: #3730a3;
      color: #ffffff;
    }

    .btn-delete {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 5px;
      padding: 8px 11px;
      border-radius: 999px;
      background: #dc2626;
      color: #ffffff;
      text-decoration: none;
      font-size: 12px;
      font-weight: 900;
      white-space: nowrap;
      border: none;
      cursor: pointer;
    }

    .btn-delete:hover {
      background: #b91c1c;
      color: #ffffff;
    }

    .delete-form {
      margin: 0;
      display: inline;
    }

    .empty-box {
      background: #f8fafc;
      border: 1px dashed #cbd5e1;
      border-radius: 18px;
      padding: 40px;
      text-align: center;
      color: #64748b;
      font-weight: 800;
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

      .table-responsive {
        overflow-x: auto;
      }

      .table {
        min-width: 900px;
      }

      .summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 576px) {
      .summary-grid {
        grid-template-columns: 1fr;
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

  <c:set var="pendingCount" value="0" />
  <c:set var="confirmedCount" value="0" />
  <c:set var="revenueTotal" value="0" />
  <c:forEach items="${bookingList}" var="bookingSummary">
    <c:if test="${bookingSummary.status == 'Pending'}">
      <c:set var="pendingCount" value="${pendingCount + 1}" />
    </c:if>
    <c:if test="${bookingSummary.status == 'Confirmed'}">
      <c:set var="confirmedCount" value="${confirmedCount + 1}" />
    </c:if>
    <c:set var="revenueTotal" value="${revenueTotal + bookingSummary.totalPrice}" />
  </c:forEach>

  <main class="main-content">
    <div class="topbar">
      <div>
        <h1>Quản lý đặt chỗ</h1>
        <p>Theo dõi booking tour, lưu trú và các dịch vụ đã đặt.</p>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/staff/home">
        <i class="fa-solid fa-arrow-left"></i>
        Về Staff Home
      </a>
    </div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon"><i class="fa-solid fa-calendar-check"></i></div>
        <div>
          <div class="summary-label">Tổng booking</div>
          <div class="summary-value">${fn:length(bookingList)}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon"><i class="fa-solid fa-clock"></i></div>
        <div>
          <div class="summary-label">Chờ xử lý</div>
          <div class="summary-value">${pendingCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon"><i class="fa-solid fa-circle-check"></i></div>
        <div>
          <div class="summary-label">Đã xác nhận</div>
          <div class="summary-value">${confirmedCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon"><i class="fa-solid fa-money-bill-wave"></i></div>
        <div>
          <div class="summary-label">Tổng giá trị</div>
          <div class="summary-value" style="font-size: 20px;">
            <fmt:formatNumber value="${revenueTotal}" type="number" maxFractionDigits="0"/> VND
          </div>
        </div>
      </div>
    </div>

    <c:if test="${param.success == 'updated'}">
      <div class="success-box">
        <i class="fa-solid fa-circle-check me-2"></i>
        Cập nhật booking thành công.
      </div>
    </c:if>

    <c:if test="${param.success == 'deleted'}">
      <div class="success-box">
        <i class="fa-solid fa-circle-check me-2"></i>
        Xóa booking thành công.
      </div>
    </c:if>

    <c:if test="${param.error == 'deleteFailed'}">
      <div class="error-box">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
        Xóa booking thất bại. Booking có thể đang liên kết với dữ liệu khác.
      </div>
    </c:if>

    <div class="filter-card">
      <div class="row g-3 align-items-center">
        <div class="col-lg-5">
          <input type="text"
                 class="form-control"
                 id="bookingSearchInput"
                 placeholder="Tìm mã booking, khách hàng, email, SĐT, dịch vụ...">
        </div>

        <div class="col-lg-3">
          <select class="form-select" id="bookingTypeFilter">
            <option value="">Tất cả loại booking</option>
            <option value="Tour">Tour</option>
            <option value="Accommodation">Lưu trú</option>
            <option value="Vehicle">Thuê xe</option>
          </select>
        </div>

        <div class="col-lg-3">
          <select class="form-select" id="bookingStatusFilter">
            <option value="">Tất cả trạng thái</option>
            <option value="Pending">Chờ xử lý</option>
            <option value="Confirmed">Đã xác nhận</option>
            <option value="Completed">Hoàn thành</option>
            <option value="Cancelled">Đã hủy</option>
          </select>
        </div>

        <div class="col-lg-1">
          <button class="btn btn-outline-secondary w-100 h-100"
                  onclick="resetBookingFilter()"
                  type="button"
                  title="Xóa lọc">
            <i class="fa-solid fa-rotate-left"></i>
          </button>
        </div>
      </div>
    </div>

    <div class="content-card">
      <c:choose>
        <c:when test="${not empty bookingList}">
          <div class="table-responsive">
            <table class="table align-middle" id="bookingTable">
              <thead>
              <tr>
                <th>Mã Booking</th>
                <th>Loại</th>
                <th>Khách hàng</th>
                <th>Liên hệ</th>
                <th>Dịch vụ</th>
                <th>Lịch sử dụng</th>
                <th>Số khách</th>
                <th>Địa chỉ</th>
                <th>Email</th>
                <th>Ngày đặt</th>
                <th>Trạng thái</th>
                <th>Tổng tiền</th>
                <th>Thao tác</th>
              </tr>
              </thead>

              <tbody>
              <c:forEach items="${bookingList}" var="booking">
                <tr data-booking-search="${booking.bookingCode} ${booking.displayType} ${booking.firstName} ${booking.lastName} ${booking.email} ${booking.phone} ${booking.serviceName} ${booking.address}"
                    data-booking-type="${booking.bookingType}"
                    data-booking-status="${booking.status}">
                  <td>
                    <span class="booking-code">${booking.bookingCode}</span>
                  </td>
                  <td>
                    <span class="type-pill">
                      <c:choose>
                        <c:when test="${booking.bookingType == 'Tour'}">
                          <i class="fa-solid fa-map-location-dot"></i>
                        </c:when>
                        <c:when test="${booking.bookingType == 'Accommodation'}">
                          <i class="fa-solid fa-hotel"></i>
                        </c:when>
                        <c:when test="${booking.bookingType == 'Vehicle'}">
                          <i class="fa-solid fa-car-side"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="fa-solid fa-briefcase"></i>
                        </c:otherwise>
                      </c:choose>
                      ${booking.displayType}
                    </span>
                  </td>
                  <td>${booking.firstName} ${booking.lastName}</td>
                  <td>${booking.phone}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty booking.serviceName}">
                        ${booking.serviceName}
                      </c:when>
                      <c:otherwise>Chưa có dịch vụ</c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty booking.serviceStartDate || not empty booking.serviceEndDate}">
                        <fmt:formatDate value="${booking.serviceStartDate}" pattern="dd/MM/yyyy"/>
                        <c:if test="${not empty booking.serviceEndDate}">
                          - <fmt:formatDate value="${booking.serviceEndDate}" pattern="dd/MM/yyyy"/>
                        </c:if>
                      </c:when>
                      <c:otherwise>Chưa có lịch</c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <div class="fw-bold">${booking.totalGuests} khách</div>
                    <small class="text-muted">${booking.numberAdult} NL, ${booking.numberChildren} TE</small>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty booking.address}">
                        ${booking.address}
                      </c:when>
                      <c:otherwise>Chưa cập nhật</c:otherwise>
                    </c:choose>
                  </td>
                  <td>${booking.email}</td>
                  <td>
                    <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                  </td>
                  <td>
                    <span class="status-badge ${fn:toLowerCase(booking.status)}">
                      ${booking.displayStatus}
                    </span>
                  </td>
                  <td>
                    <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VND
                  </td>
                  <td>
                    <div class="action-group">
                      <a class="btn-edit"
                         href="${pageContext.request.contextPath}/staff/booking-edit?bookingID=${booking.bookingID}">
                        <i class="fa-solid fa-pen-to-square"></i>
                        Sửa
                      </a>

                      <form class="delete-form"
                            action="${pageContext.request.contextPath}/staff/booking-delete"
                            method="post"
                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa booking này không?');">
                        <input type="hidden" name="bookingID" value="${booking.bookingID}">
                        <button type="submit" class="btn-delete">
                          <i class="fa-solid fa-trash"></i>
                          Xóa
                        </button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>

            <table class="table align-middle">
              <thead>
              <tr>
                <th>Mã Booking</th>
                <th>Khách hàng</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Ngày đặt</th>
                <th>Trạng thái</th>
                <th>Tổng tiền</th>
                <th>Thao tác</th>
              </tr>
              </thead>

              <tbody>
              <c:forEach items="${bookingList}" var="booking">
                <tr>
                  <td>
                    <span class="booking-code">${booking.bookingCode}</span>
                  </td>
                  <td>${booking.firstName} ${booking.lastName}</td>
                  <td>${booking.email}</td>
                  <td>${booking.phone}</td>
                  <td>
                    <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                  </td>
                  <td>
                    <span class="status-badge">
                      <c:choose>
                        <c:when test="${booking.status == 'Pending'}">Chờ xử lý</c:when>
                        <c:when test="${booking.status == 'Confirmed'}">Đã xác nhận</c:when>
                        <c:when test="${booking.status == 'Cancelled'}">Đã hủy</c:when>
                        <c:when test="${booking.status == 'Completed'}">Hoàn thành</c:when>
                        <c:otherwise>${booking.status}</c:otherwise>
                      </c:choose>
                    </span>
                  </td>
                  <td>
                    <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                  </td>
                  <td>
                    <div class="action-group">
                      <a class="btn-edit"
                         href="${pageContext.request.contextPath}/staff/booking-edit?bookingID=${booking.bookingID}">
                        <i class="fa-solid fa-pen-to-square"></i>
                        Sửa
                      </a>

                      <form class="delete-form"
                            action="${pageContext.request.contextPath}/staff/booking-delete"
                            method="post"
                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa booking này không?');">
                        <input type="hidden" name="bookingID" value="${booking.bookingID}">
                        <button type="submit" class="btn-delete">
                          <i class="fa-solid fa-trash"></i>
                          Xóa
                        </button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:when>

        <c:otherwise>
          <div class="empty-box">
            Chưa có booking nào trong hệ thống.
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function normalizeBookingText(value) {
    return (value || "")
      .toString()
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .trim();
  }

  function filterBookingTable() {
    const keyword = normalizeBookingText(document.getElementById("bookingSearchInput").value);
    const type = normalizeBookingText(document.getElementById("bookingTypeFilter").value);
    const status = normalizeBookingText(document.getElementById("bookingStatusFilter").value);
    const rows = document.querySelectorAll("#bookingTable tbody tr[data-booking-search]");

    rows.forEach(function (row) {
      const rowText = normalizeBookingText(row.dataset.bookingSearch);
      const rowType = normalizeBookingText(row.dataset.bookingType);
      const rowStatus = normalizeBookingText(row.dataset.bookingStatus);

      const matchKeyword = !keyword || rowText.includes(keyword);
      const matchType = !type || rowType === type;
      const matchStatus = !status || rowStatus === status;

      row.style.display = matchKeyword && matchType && matchStatus ? "" : "none";
    });
  }

  function resetBookingFilter() {
    document.getElementById("bookingSearchInput").value = "";
    document.getElementById("bookingTypeFilter").value = "";
    document.getElementById("bookingStatusFilter").value = "";
    filterBookingTable();
  }

  document.addEventListener("DOMContentLoaded", function () {
    ["bookingSearchInput", "bookingTypeFilter", "bookingStatusFilter"].forEach(function (id) {
      const element = document.getElementById(id);

      if (!element) {
        return;
      }

      element.addEventListener("input", filterBookingTable);
      element.addEventListener("change", filterBookingTable);
    });
  });
</script>
</body>
</html>
