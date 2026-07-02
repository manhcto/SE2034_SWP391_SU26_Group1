<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Chi tiết đơn đặt</title>
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
      box-shadow: 0 12px 24px rgba(239, 68, 68, 0.22);
    }

    .brand-box h2 {
      font-size: 26px;
      font-weight: 900;
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
      margin: 8px 0 0;
      font-size: 14px;
      font-weight: 700;
      line-height: 1.6;
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
      color: #991b1b;
      border: 1px solid #fca5a5;
      border-radius: 18px;
      padding: 18px 22px;
      font-weight: 800;
      margin-bottom: 22px;
    }

    .detail-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 26px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
      margin-bottom: 24px;
    }

    .detail-card h3 {
      font-size: 21px;
      font-weight: 900;
      margin: 0 0 18px;
      padding-bottom: 14px;
      border-bottom: 1px solid #e2e8f0;
      color: #0f172a;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .detail-card h3 i {
      color: #ef4444;
    }

    .detail-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 18px 26px;
    }

    .detail-item {
      display: flex;
      flex-direction: column;
      gap: 5px;
    }

    .detail-label {
      color: #64748b;
      font-size: 13px;
      font-weight: 800;
    }

    .detail-value {
      color: #0f172a;
      font-size: 15px;
      font-weight: 800;
      word-break: break-word;
      line-height: 1.6;
    }

    .booking-code {
      color: #ef4444;
      font-size: 18px;
      font-weight: 900;
    }

    .status-badge,
    .type-pill {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: fit-content;
      border-radius: 999px;
      padding: 7px 12px;
      font-size: 13px;
      font-weight: 900;
    }

    .type-pill {
      gap: 7px;
      background: #f1f5f9;
      color: #334155;
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

    .total-price {
      color: #dc2626;
      font-size: 24px;
      font-weight: 950;
    }

    .bottom-actions {
      display: flex;
      justify-content: center;
      gap: 14px;
      flex-wrap: wrap;
      margin-top: 8px;
    }

    .btn-back,
    .btn-home {
      min-width: 190px;
      border-radius: 999px;
      padding: 13px 22px;
      text-decoration: none;
      font-weight: 900;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 9px;
    }

    .btn-back {
      background: #ef4444;
      color: #ffffff;
    }

    .btn-back:hover {
      background: #dc2626;
      color: #ffffff;
    }

    .btn-home {
      background: #ffffff;
      color: #ef4444;
      border: 1px solid #ef4444;
    }

    .btn-home:hover {
      background: #fff1f2;
      color: #ef4444;
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

      .detail-grid {
        grid-template-columns: 1fr;
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

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/tour-approval">
      <i class="fa-solid fa-circle-check"></i>
      <span>Phê duyệt tour</span>
    </a>

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/booking">
      <i class="fa-solid fa-calendar-check"></i>
      <span>Đơn đặt</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/feedback">
      <i class="fa-solid fa-comments"></i>
      <span>Đánh giá khách hàng</span>
    </a>

    <div class="nav-section-title">Khu vực nhân viên</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
      <i class="fa-solid fa-user-tie"></i>
      <span>Trang nhân viên</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
      <i class="fa-solid fa-hotel"></i>
      <span>Lưu trú</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/vehicle?action=list">
      <i class="fa-solid fa-car-side"></i>
      <span>Phương tiện</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
      <i class="fa-solid fa-map-location-dot"></i>
      <span>Tour</span>
    </a>

    <div class="admin-user">
      <div class="avatar">QT</div>
      <div>
        <div class="fw-bold">Quản trị viên</div>
        <small>Tài khoản quản trị</small>
      </div>
    </div>
  </aside>

  <c:choose>
    <c:when test="${not empty backToBookingListUrl}">
      <c:set var="backUrl" value="${backToBookingListUrl}" />
    </c:when>
    <c:when test="${not empty selectedBookingType}">
      <c:set var="backUrl" value="${pageContext.request.contextPath}/admin/booking?type=${selectedBookingType}" />
    </c:when>
    <c:otherwise>
      <c:set var="backUrl" value="${pageContext.request.contextPath}/admin/booking" />
    </c:otherwise>
  </c:choose>

  <main class="main-content">
    <div class="topbar">
      <div>
        <h1>Chi tiết đơn đặt</h1>
        <p>Quản trị viên chỉ xem thông tin đơn đặt, không sửa, không hủy và không xóa dữ liệu.</p>
      </div>

      <a class="top-action-btn" href="${backUrl}">
        <i class="fa-solid fa-arrow-left"></i>
        Quay lại danh sách
      </a>
    </div>

    <c:if test="${not empty error}">
      <div class="error-box">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
          ${error}
      </div>
    </c:if>

    <c:if test="${not empty bookingDetail}">
      <c:set var="statusClass" value="confirmed" />
      <c:set var="statusText" value="Đang diễn ra" />

      <c:if test="${bookingDetail.status == 'Cancelled'}">
        <c:set var="statusClass" value="cancelled" />
        <c:set var="statusText" value="Đã hủy" />
      </c:if>

      <c:if test="${bookingDetail.status == 'Completed'}">
        <c:set var="statusClass" value="completed" />
        <c:set var="statusText" value="Đã hoàn thành" />
      </c:if>

      <c:if test="${not empty bookingDetail.displayStatusVietnamese}">
        <c:set var="statusText" value="${bookingDetail.displayStatusVietnamese}" />
      </c:if>

      <div class="detail-card">
        <h3>
          <i class="fa-solid fa-receipt"></i>
          1. Thông tin đơn đặt
        </h3>

        <div class="detail-grid">
          <div class="detail-item">
            <span class="detail-label">Mã đơn</span>
            <span class="detail-value">${bookingDetail.bookingID}</span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Mã đặt chỗ</span>
            <span class="detail-value booking-code">${bookingDetail.bookingCode}</span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Loại đơn đặt</span>
            <span class="detail-value">
              <span class="type-pill">
                <c:choose>
                  <c:when test="${bookingDetail.bookingType == 'Tour'}">
                    <i class="fa-solid fa-map-location-dot"></i>
                    Đặt tour
                  </c:when>
                  <c:when test="${bookingDetail.bookingType == 'Accommodation'}">
                    <i class="fa-solid fa-hotel"></i>
                    Đặt phòng
                  </c:when>
                  <c:when test="${bookingDetail.bookingType == 'Vehicle'}">
                    <i class="fa-solid fa-car-side"></i>
                    Đặt xe
                  </c:when>
                  <c:otherwise>
                    <i class="fa-solid fa-briefcase"></i>
                    Đơn đặt
                  </c:otherwise>
                </c:choose>
              </span>
            </span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Trạng thái</span>
            <span class="detail-value">
              <span class="status-badge ${statusClass}">
                  ${statusText}
              </span>
            </span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Ngày đặt</span>
            <span class="detail-value">
              <fmt:formatDate value="${bookingDetail.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
            </span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Đặt hộ người khác</span>
            <span class="detail-value">
              <c:choose>
                <c:when test="${bookingDetail.isBookedForOther == true || bookingDetail.bookedForOther == true}">
                  Có
                </c:when>
                <c:otherwise>Không</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <h3>
          <i class="fa-solid fa-user"></i>
          2. Thông tin khách hàng
        </h3>

        <div class="detail-grid">
          <div class="detail-item">
            <span class="detail-label">Họ tên</span>
            <span class="detail-value">${bookingDetail.firstName} ${bookingDetail.lastName}</span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Email</span>
            <span class="detail-value">${bookingDetail.email}</span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Số điện thoại</span>
            <span class="detail-value">${bookingDetail.phone}</span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Địa chỉ</span>
            <span class="detail-value">
              <c:choose>
                <c:when test="${not empty bookingDetail.address}">
                  ${bookingDetail.address}
                </c:when>
                <c:otherwise>Chưa cập nhật</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <c:choose>
          <c:when test="${bookingDetail.bookingType == 'Vehicle'}">
            <h3>
              <i class="fa-solid fa-car-side"></i>
              3. Thông tin đặt xe
            </h3>

            <div class="detail-grid">
              <div class="detail-item">
                <span class="detail-label">Tên xe</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.itemName}">
                      ${bookingDetail.itemName}
                    </c:when>
                    <c:when test="${not empty bookingDetail.vehicleModel}">
                      ${bookingDetail.vehicleModel}
                    </c:when>
                    <c:otherwise>${bookingDetail.serviceName}</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Hãng xe</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.brandName}">
                      ${bookingDetail.brandName}
                    </c:when>
                    <c:otherwise>Chưa cập nhật</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Biển số</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.licensePlate}">
                      ${bookingDetail.licensePlate}
                    </c:when>
                    <c:otherwise>Chưa cập nhật</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Mã dịch vụ</span>
                <span class="detail-value">${bookingDetail.serviceID}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Địa điểm nhận xe</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.pickupAddress}">
                      ${bookingDetail.pickupAddress}
                    </c:when>
                    <c:when test="${not empty bookingDetail.pickupDistrict || not empty bookingDetail.pickupProvince}">
                      ${bookingDetail.pickupDistrict}, ${bookingDetail.pickupProvince}
                    </c:when>
                    <c:otherwise>Chưa cập nhật</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Ngày nhận xe</span>
                <span class="detail-value">
                  <fmt:formatDate value="${bookingDetail.startDate}" pattern="dd/MM/yyyy"/>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Ngày trả xe</span>
                <span class="detail-value">
                  <fmt:formatDate value="${bookingDetail.endDate}" pattern="dd/MM/yyyy"/>
                </span>
              </div>
            </div>
          </c:when>

          <c:when test="${bookingDetail.bookingType == 'Accommodation'}">
            <h3>
              <i class="fa-solid fa-hotel"></i>
              3. Thông tin đặt phòng
            </h3>

            <div class="detail-grid">
              <div class="detail-item">
                <span class="detail-label">Nơi lưu trú</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.accommodationName}">
                      ${bookingDetail.accommodationName}
                    </c:when>
                    <c:when test="${not empty bookingDetail.itemName}">
                      ${bookingDetail.itemName}
                    </c:when>
                    <c:otherwise>${bookingDetail.serviceName}</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Mã dịch vụ</span>
                <span class="detail-value">${bookingDetail.serviceID}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Ngày nhận phòng</span>
                <span class="detail-value">
                  <fmt:formatDate value="${bookingDetail.startDate}" pattern="dd/MM/yyyy"/>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Ngày trả phòng</span>
                <span class="detail-value">
                  <fmt:formatDate value="${bookingDetail.endDate}" pattern="dd/MM/yyyy"/>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Số phòng</span>
                <span class="detail-value">${bookingDetail.quantity}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Số khách</span>
                <span class="detail-value">
                  ${bookingDetail.numberAdult} người lớn, ${bookingDetail.numberChildren} trẻ em
                </span>
              </div>
            </div>
          </c:when>

          <c:otherwise>
            <h3>
              <i class="fa-solid fa-map-location-dot"></i>
              3. Thông tin tour
            </h3>

            <div class="detail-grid">
              <div class="detail-item">
                <span class="detail-label">Tên tour</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.tourName}">
                      ${bookingDetail.tourName}
                    </c:when>
                    <c:otherwise>${bookingDetail.serviceName}</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Mã lịch tour</span>
                <span class="detail-value">${bookingDetail.tourScheduleID}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Điểm khởi hành</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.startPlace}">
                      ${bookingDetail.startPlace}
                    </c:when>
                    <c:otherwise>Chưa cập nhật</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Điểm đến</span>
                <span class="detail-value">
                  <c:choose>
                    <c:when test="${not empty bookingDetail.endPlace}">
                      ${bookingDetail.endPlace}
                    </c:when>
                    <c:otherwise>Chưa cập nhật</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Ngày bắt đầu</span>
                <span class="detail-value">
                  <fmt:formatDate value="${bookingDetail.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Ngày kết thúc</span>
                <span class="detail-value">
                  <fmt:formatDate value="${bookingDetail.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Số khách</span>
                <span class="detail-value">
                  ${bookingDetail.numberAdult} người lớn, ${bookingDetail.numberChildren} trẻ em
                </span>
              </div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="detail-card">
        <h3>
          <i class="fa-solid fa-money-bill-wave"></i>
          4. Chi tiết thanh toán
        </h3>

        <div class="detail-grid">
          <c:choose>
            <c:when test="${bookingDetail.bookingType == 'Vehicle'}">
              <div class="detail-item">
                <span class="detail-label">Số ngày thuê</span>
                <span class="detail-value">${bookingDetail.quantity}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Đơn giá mỗi ngày</span>
                <span class="detail-value">
                  <fmt:formatNumber value="${bookingDetail.unitPrice}" type="number" maxFractionDigits="0"/> VNĐ
                </span>
              </div>
            </c:when>

            <c:when test="${bookingDetail.bookingType == 'Accommodation'}">
              <div class="detail-item">
                <span class="detail-label">Số phòng</span>
                <span class="detail-value">${bookingDetail.quantity}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Đơn giá mỗi phòng / đêm</span>
                <span class="detail-value">
                  <fmt:formatNumber value="${bookingDetail.unitPrice}" type="number" maxFractionDigits="0"/> VNĐ
                </span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Số người lớn</span>
                <span class="detail-value">${bookingDetail.numberAdult}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Số trẻ em</span>
                <span class="detail-value">${bookingDetail.numberChildren}</span>
              </div>
            </c:when>

            <c:otherwise>
              <div class="detail-item">
                <span class="detail-label">Số người lớn</span>
                <span class="detail-value">${bookingDetail.numberAdult}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Số trẻ em</span>
                <span class="detail-value">${bookingDetail.numberChildren}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Tổng số khách</span>
                <span class="detail-value">${bookingDetail.quantity}</span>
              </div>

              <div class="detail-item">
                <span class="detail-label">Đơn giá trung bình</span>
                <span class="detail-value">
                  <fmt:formatNumber value="${bookingDetail.unitPrice}" type="number" maxFractionDigits="0"/> VNĐ
                </span>
              </div>
            </c:otherwise>
          </c:choose>

          <div class="detail-item">
            <span class="detail-label">Tạm tính</span>
            <span class="detail-value">
              <fmt:formatNumber value="${bookingDetail.subTotal}" type="number" maxFractionDigits="0"/> VNĐ
            </span>
          </div>

          <div class="detail-item">
            <span class="detail-label">Tổng tiền</span>
            <span class="detail-value total-price">
              <fmt:formatNumber value="${bookingDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
            </span>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <h3>
          <i class="fa-solid fa-note-sticky"></i>
          5. Ghi chú
        </h3>

        <div class="detail-value">
          <c:choose>
            <c:when test="${not empty bookingDetail.note}">
              ${bookingDetail.note}
            </c:when>
            <c:otherwise>Không có ghi chú.</c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="bottom-actions">
        <a href="${backUrl}" class="btn-back">
          <i class="fa-solid fa-arrow-left"></i>
          Quay lại danh sách
        </a>

        <a href="${pageContext.request.contextPath}/admin/home" class="btn-home">
          <i class="fa-solid fa-house"></i>
          Về trang chủ quản trị
        </a>
      </div>
    </c:if>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>