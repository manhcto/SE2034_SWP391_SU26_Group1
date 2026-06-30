<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Xem đặt chỗ</title>
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

    .admin-layout {
      display: flex;
      min-height: 100vh;
    }

    .admin-sidebar {
      width: 292px;
      background: #0f172a;
      color: #ffffff;
      position: fixed;
      inset: 0 auto 0 0;
      overflow-y: auto;
      padding: 26px 18px;
      box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18);
    }

    .admin-sidebar::-webkit-scrollbar {
      width: 7px;
    }

    .admin-sidebar::-webkit-scrollbar-thumb {
      background: #334155;
      border-radius: 20px;
    }

    .brand-box {
      padding: 8px 10px 22px;
      margin-bottom: 12px;
      border-bottom: 1px solid rgba(148, 163, 184, 0.25);
    }

    .brand-logo {
      width: 54px;
      height: 54px;
      border-radius: 18px;
      background: linear-gradient(135deg, #f97316, #ef4444);
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 900;
      font-size: 20px;
      margin-bottom: 12px;
    }

    .brand-box h2 {
      font-size: 26px;
      font-weight: 900;
      margin: 0;
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
      font-weight: 900;
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
      color: #ffffff;
      transform: translateX(4px);
    }

    .sidebar-link.active {
      background: linear-gradient(135deg, #f97316, #ef4444);
      color: #ffffff;
      box-shadow: 0 10px 22px rgba(239, 68, 68, 0.20);
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
      background: linear-gradient(135deg, #f97316, #ef4444);
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 900;
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
      margin-bottom: 24px;
    }

    .topbar h1 {
      font-size: 34px;
      font-weight: 900;
      margin: 0;
      letter-spacing: -0.8px;
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

    .booking-tabs {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 22px;
    }

    .booking-tab {
      min-height: 46px;
      border-radius: 999px;
      padding: 11px 18px;
      text-decoration: none;
      background: #ffffff;
      color: #334155;
      border: 1px solid #dbe3ef;
      font-size: 14px;
      font-weight: 900;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      box-shadow: 0 8px 18px rgba(15, 23, 42, 0.05);
    }

    .booking-tab:hover {
      background: #fff7ed;
      color: #ef4444;
      border-color: #fed7aa;
    }

    .booking-tab.active {
      background: linear-gradient(135deg, #f97316, #ef4444);
      color: #ffffff;
      border-color: transparent;
      box-shadow: 0 12px 24px rgba(239, 68, 68, 0.22);
    }

    .summary-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 18px;
      margin-bottom: 22px;
    }

    .summary-card,
    .filter-card,
    .content-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
    }

    .summary-card {
      border-radius: 22px;
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
      background: #fff7ed;
      color: #ef4444;
      font-size: 20px;
      flex-shrink: 0;
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
      line-height: 1.1;
    }

    .filter-card {
      border-radius: 22px;
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

    .content-card {
      border-radius: 24px;
      padding: 24px;
      width: 100%;
      max-width: 1320px;
      margin: 0 auto;
      overflow: hidden;
    }

    .table-responsive {
      overflow-x: visible;
      width: 100%;
    }

    .table {
      width: 100%;
      margin-bottom: 0;
      table-layout: fixed;
    }

    .table thead th {
      background: #f8fafc;
      color: #334155;
      font-size: 13px;
      font-weight: 900;
      border-bottom: 1px solid #e2e8f0;
      padding: 16px 12px;
      vertical-align: middle;
      text-align: center;
      white-space: normal;
      word-break: break-word;
    }

    .table tbody td {
      padding: 18px 12px;
      vertical-align: middle;
      color: #0f172a;
      font-size: 13px;
      text-align: center;
      word-break: break-word;
      border-bottom: 1px solid #e2e8f0;
    }

    .table tbody tr:last-child td {
      border-bottom: none;
    }

    .col-code {
      width: 13%;
    }

    .col-type {
      width: 12%;
    }

    .col-customer {
      width: 22%;
    }

    .col-service {
      width: 27%;
    }

    .col-status {
      width: 12%;
    }

    .col-money {
      width: 10%;
    }

    .col-action {
      width: 8%;
    }

    .booking-code {
      font-weight: 900;
      color: #ef4444;
      word-break: break-word;
    }

    .customer-cell,
    .service-cell {
      text-align: left !important;
    }

    .customer-name,
    .service-name {
      font-weight: 900;
      color: #0f172a;
      margin-bottom: 4px;
    }

    .customer-meta,
    .service-date {
      color: #64748b;
      font-size: 12px;
      line-height: 1.6;
      font-weight: 650;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 7px 12px;
      border-radius: 999px;
      background: #e0f2fe;
      color: #075985;
      font-size: 12px;
      font-weight: 900;
      white-space: nowrap;
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
      padding: 7px 11px;
      background: #f1f5f9;
      color: #334155;
      font-size: 12px;
      font-weight: 900;
      white-space: nowrap;
    }

    .btn-view {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      padding: 9px 14px;
      border-radius: 999px;
      background: #ef4444;
      color: #ffffff;
      text-decoration: none;
      font-size: 13px;
      font-weight: 900;
      white-space: nowrap;
    }

    .btn-view:hover {
      background: #dc2626;
      color: #ffffff;
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
      .admin-sidebar {
        position: static;
        width: 100%;
        height: auto;
      }

      .admin-layout {
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

      .summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 576px) {
      .summary-grid {
        grid-template-columns: 1fr;
      }

      .booking-tabs {
        flex-direction: column;
      }

      .booking-tab {
        width: 100%;
      }
    }
  </style>
</head>

<body>
<div class="admin-layout">

  <aside class="admin-sidebar">
    <div class="brand-box">
      <div class="brand-logo">QT</div>
      <h2>WonderVN</h2>
      <p>Trung tâm quản trị hệ thống</p>
    </div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/home">
      <i class="fa-solid fa-house"></i>
      <span>Trang chủ quản trị</span>
    </a>

    <div class="nav-section-title">Quản trị hệ thống</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-chart-line"></i>
      <span>Bảng thống kê</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
      <i class="fa-solid fa-users-gear"></i>
      <span>Quản lý người dùng</span>
    </a>

    <div class="nav-section-title">Đặt chỗ</div>

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/booking">
      <i class="fa-solid fa-calendar-check"></i>
      <span>Xem đặt chỗ</span>
    </a>

    <div class="nav-section-title">Khu vực nhân viên</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
      <i class="fa-solid fa-user-tie"></i>
      <span>Trang chủ nhân viên</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
      <i class="fa-solid fa-pen-to-square"></i>
      <span>Quản lý đặt chỗ</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
      <i class="fa-solid fa-comments"></i>
      <span>Đánh giá khách hàng</span>
    </a>

    <div class="admin-user">
      <div class="avatar">QT</div>
      <div>
        <div class="fw-bold">Quản trị viên</div>
        <small>Tài khoản quản trị</small>
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
        <h1>Xem đặt chỗ</h1>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/admin/home">
        <i class="fa-solid fa-arrow-left"></i>
        Về trang chủ quản trị
      </a>
    </div>

    <div class="booking-tabs">
      <a class="booking-tab ${empty selectedBookingType ? 'active' : ''}"
         href="${pageContext.request.contextPath}/admin/booking">
        <i class="fa-solid fa-layer-group"></i>
        Tất cả đặt chỗ
      </a>

      <a class="booking-tab ${selectedBookingType == 'Tour' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/admin/booking?type=Tour">
        <i class="fa-solid fa-map-location-dot"></i>
        Đặt tour
      </a>

      <a class="booking-tab ${selectedBookingType == 'Accommodation' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/admin/booking?type=Accommodation">
        <i class="fa-solid fa-hotel"></i>
        Đặt phòng
      </a>

      <a class="booking-tab ${selectedBookingType == 'Vehicle' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/admin/booking?type=Vehicle">
        <i class="fa-solid fa-car-side"></i>
        Đặt xe
      </a>
    </div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon"><i class="fa-solid fa-calendar-check"></i></div>
        <div>
          <div class="summary-label">Tổng đặt chỗ</div>
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
            <fmt:formatNumber value="${revenueTotal}" type="number" maxFractionDigits="0"/> VNĐ
          </div>
        </div>
      </div>
    </div>

    <div class="filter-card">
      <div class="row g-3 align-items-center justify-content-center">
        <div class="col-lg-7">
          <input type="text"
                 class="form-control"
                 id="bookingSearchInput"
                 placeholder="Tìm mã đặt chỗ, khách hàng, email, SĐT, dịch vụ...">
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
                <th class="col-code">Mã đặt chỗ</th>
                <th class="col-type">Loại</th>
                <th class="col-customer">Khách hàng</th>
                <th class="col-service">Dịch vụ / lịch</th>
                <th class="col-status">Trạng thái</th>
                <th class="col-money">Tổng tiền</th>
                <th class="col-action">Xem</th>
              </tr>
              </thead>

              <tbody>
              <c:forEach items="${bookingList}" var="booking">
                <tr data-booking-search="${booking.bookingCode} ${booking.displayType} ${booking.firstName} ${booking.lastName} ${booking.email} ${booking.phone} ${booking.serviceName} ${booking.address}"
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

                  <td class="customer-cell">
                    <div class="customer-name">${booking.firstName} ${booking.lastName}</div>
                    <div class="customer-meta">${booking.phone}</div>
                    <div class="customer-meta">${booking.email}</div>
                  </td>

                  <td class="service-cell">
                    <div class="service-name">
                      <c:choose>
                        <c:when test="${not empty booking.serviceName}">
                          ${booking.serviceName}
                        </c:when>
                        <c:otherwise>Chưa có dịch vụ</c:otherwise>
                      </c:choose>
                    </div>

                    <div class="service-date">
                      <c:choose>
                        <c:when test="${not empty booking.serviceStartDate || not empty booking.serviceEndDate}">
                          <fmt:formatDate value="${booking.serviceStartDate}" pattern="dd/MM/yyyy"/>
                          <c:if test="${not empty booking.serviceEndDate}">
                            - <fmt:formatDate value="${booking.serviceEndDate}" pattern="dd/MM/yyyy"/>
                          </c:if>
                        </c:when>
                        <c:otherwise>Chưa có lịch</c:otherwise>
                      </c:choose>
                    </div>
                  </td>

                  <td>
                    <span class="status-badge ${fn:toLowerCase(booking.status)}">
                        ${booking.displayStatus}
                    </span>
                  </td>

                  <td>
                    <strong>
                      <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                    </strong>
                  </td>

                  <td>
                    <a class="btn-view"
                       href="${pageContext.request.contextPath}/admin/booking-detail?bookingID=${booking.bookingID}&type=${not empty selectedBookingType ? selectedBookingType : booking.bookingType}">
                      <i class="fa-solid fa-eye"></i>
                      Xem
                    </a>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:when>

        <c:otherwise>
          <div class="empty-box">
            Chưa có đơn đặt chỗ nào trong mục này.
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
    const status = normalizeBookingText(document.getElementById("bookingStatusFilter").value);
    const rows = document.querySelectorAll("#bookingTable tbody tr[data-booking-search]");

    rows.forEach(function (row) {
      const rowText = normalizeBookingText(row.dataset.bookingSearch);
      const rowStatus = normalizeBookingText(row.dataset.bookingStatus);

      const matchKeyword = !keyword || rowText.includes(keyword);
      const matchStatus = !status || rowStatus === status;

      row.style.display = matchKeyword && matchStatus ? "" : "none";
    });
  }

  function resetBookingFilter() {
    document.getElementById("bookingSearchInput").value = "";
    document.getElementById("bookingStatusFilter").value = "";
    filterBookingTable();
  }

  document.addEventListener("DOMContentLoaded", function () {
    ["bookingSearchInput", "bookingStatusFilter"].forEach(function (id) {
      const element = document.getElementById(id);

      if (!element) {
        return;
      }

      element.addEventListener("input", filterBookingTable);
      element.addEventListener("change", filterBookingTable);
    });

    filterBookingTable();
  });
</script>
</body>
</html>