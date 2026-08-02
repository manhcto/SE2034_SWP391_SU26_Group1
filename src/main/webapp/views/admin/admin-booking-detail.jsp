<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Admin Booking Detail</title>
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

    .detail-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 26px;
      margin-bottom: 22px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
    }

    .detail-card h4 {
      font-size: 20px;
      font-weight: 900;
      margin-bottom: 20px;
      padding-bottom: 13px;
      border-bottom: 1px solid #e2e8f0;
    }

    .detail-item {
      margin-bottom: 18px;
    }

    .detail-label {
      display: block;
      color: #64748b;
      font-size: 13px;
      font-weight: 700;
      margin-bottom: 5px;
    }

    .detail-value {
      color: #0f172a;
      font-size: 16px;
      font-weight: 800;
      word-break: break-word;
    }

    .booking-code {
      color: #ef4444;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 7px 13px;
      border-radius: 999px;
      background: #e0f2fe;
      color: #075985;
      font-size: 13px;
      font-weight: 900;
    }

    .note-box {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 18px;
      padding: 18px;
      color: #0f172a;
      line-height: 1.7;
      white-space: pre-line;
    }

    .error-box {
      background: #fee2e2;
      color: #b91c1c;
      border: 1px solid #f87171;
      border-radius: 18px;
      padding: 18px 22px;
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
    }
  </style>
</head>

<body>
<div class="admin-layout">

  <jsp:include page="/views/common/admin-sidebar.jsp">
    <jsp:param name="activeAdminMenu" value="booking"/>
  </jsp:include>
  <%--
  <aside class="admin-sidebar">
    <div class="brand-box">
      <div class="brand-logo">AD</div>
      <h2>WonderVN</h2>
      <p>Admin Control Center</p>
    </div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/home">
      <i class="fa-solid fa-house"></i>
      <span>Admin Home</span>
    </a>

    <div class="nav-section-title">Quản trị hệ thống</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-chart-line"></i>
      <span>Dashboard</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
      <i class="fa-solid fa-users-gear"></i>
      <span>Quản lý người dùng</span>
    </a>

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/booking">
      <i class="fa-solid fa-calendar-check"></i>
      <span>Xem Booking</span>
    </a>

    <div class="nav-section-title">Xem khu vực Staff</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
      <i class="fa-solid fa-user-tie"></i>
      <span>Staff Home</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
      <i class="fa-solid fa-pen-to-square"></i>
      <span>Staff Booking</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
      <i class="fa-solid fa-comments"></i>
      <span>Đánh giá khách hàng</span>
    </a>

    <div class="admin-user">
      <div class="avatar">AD</div>
      <div>
        <div class="fw-bold">Quản trị viên</div>
        <small>Admin</small>
      </div>
    </div>
  </aside>
  --%>

  <main class="main-content">
    <div class="topbar">
      <div>
        <h1>Chi tiết Booking</h1>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/admin/booking">
        <i class="fa-solid fa-arrow-left"></i>
        Quay lại danh sách
      </a>
    </div>

    <c:if test="${not empty error}">
      <div class="error-box">
          ${error}
      </div>
    </c:if>

    <c:if test="${not empty bookingDetail}">
      <div class="detail-card">
        <h4>1. Thông tin Booking</h4>

        <div class="row">
          <div class="col-md-4 detail-item">
            <span class="detail-label">Booking ID</span>
            <span class="detail-value">${bookingDetail.bookingID}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Mã Booking</span>
            <span class="detail-value booking-code">${bookingDetail.bookingCode}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Loại Booking</span>
            <span class="detail-value">${bookingDetail.bookingType}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Trạng thái</span>
            <span class="status-badge">
              <c:choose>
                <c:when test="${bookingDetail.status == 'Đang xử lý' || bookingDetail.status == 'Pending' || bookingDetail.status == 'Đang thanh toán' || bookingDetail.status == 'Đang đợi chuyển khoản'}">Chờ xử lý</c:when>
                <c:when test="${bookingDetail.status == 'Đã duyệt' || bookingDetail.status == 'Đã xác nhận' || bookingDetail.status == 'Confirmed'}">Đã xác nhận</c:when>
                <c:when test="${bookingDetail.status == 'Hoàn thành' || bookingDetail.status == 'Completed' || bookingDetail.status == 'Thanh toán thành công' || bookingDetail.status == 'Đã booking và thanh toán thành công'}">Thanh toán thành công</c:when>
                <c:when test="${bookingDetail.status == 'Đã hủy' || bookingDetail.status == 'Cancelled'}">Đã hủy</c:when>
                <c:when test="${bookingDetail.status == 'End' || bookingDetail.status == 'Ended' || bookingDetail.status == 'Tour kết thúc' || bookingDetail.status == 'Đã kết thúc'}">Hoàn tất Tour</c:when>
                <c:otherwise>${bookingDetail.status}</c:otherwise>
              </c:choose>
            </span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Ngày đặt</span>
            <span class="detail-value">
                            <fmt:formatDate value="${bookingDetail.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Tổng tiền</span>
            <span class="detail-value">
                            <fmt:formatNumber value="${bookingDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <h4>2. Thông tin khách hàng</h4>

        <div class="row">
          <div class="col-md-4 detail-item">
            <span class="detail-label">Họ tên</span>
            <span class="detail-value">${bookingDetail.firstName} ${bookingDetail.lastName}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Email</span>
            <span class="detail-value">${bookingDetail.email}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Số điện thoại</span>
            <span class="detail-value">${bookingDetail.phone}</span>
          </div>

          <div class="col-md-12 detail-item">
            <span class="detail-label">Địa chỉ</span>
            <span class="detail-value">${bookingDetail.address}</span>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <h4>3. Thông tin Tour</h4>

        <div class="row">
          <div class="col-md-4 detail-item">
            <span class="detail-label">Tour ID</span>
            <span class="detail-value">${bookingDetail.tourID}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Tour Schedule ID</span>
            <span class="detail-value">${bookingDetail.tourScheduleID}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Tên Tour</span>
            <span class="detail-value">${bookingDetail.tourName}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Điểm bắt đầu</span>
            <span class="detail-value">${bookingDetail.startPlace}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Điểm kết thúc</span>
            <span class="detail-value">${bookingDetail.endPlace}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Số lượng</span>
            <span class="detail-value">${bookingDetail.quantity}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Người lớn</span>
            <span class="detail-value">${bookingDetail.numberAdult}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Trẻ em</span>
            <span class="detail-value">${bookingDetail.numberChildren}</span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Đơn giá</span>
            <span class="detail-value">
                            <fmt:formatNumber value="${bookingDetail.unitPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Ngày bắt đầu</span>
            <span class="detail-value">
                            <fmt:formatDate value="${bookingDetail.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Ngày kết thúc</span>
            <span class="detail-value">
                            <fmt:formatDate value="${bookingDetail.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
          </div>

          <div class="col-md-4 detail-item">
            <span class="detail-label">Thành tiền</span>
            <span class="detail-value">
                            <fmt:formatNumber value="${bookingDetail.subTotal}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <h4>4. Ghi chú</h4>

        <div class="note-box">
          <c:choose>
            <c:when test="${not empty bookingDetail.note}">
              ${bookingDetail.note}
            </c:when>
            <c:otherwise>Không có ghi chú.</c:otherwise>
          </c:choose>
        </div>
      </div>
    </c:if>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
