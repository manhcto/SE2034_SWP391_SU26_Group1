<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>${bookingPageTitle} | WonderVN Admin</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <style>
    * { box-sizing: border-box; }

    body {
      margin: 0;
      background: #f4f7fb;
      font-family: "Be Vietnam Pro", Arial, sans-serif;
      color: #0f172a;
    }

    .admin-layout { display: flex; min-height: 100vh; }

    /* -- SIDEBAR GỐC -- */
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
    .sidebar::-webkit-scrollbar { width: 7px; }
    .sidebar::-webkit-scrollbar-thumb { background: #334155; border-radius: 20px; }

    .brand-box { padding: 8px 10px 22px; margin-bottom: 12px; border-bottom: 1px solid rgba(148, 163, 184, 0.25); }
    /* Đã đổi Logo sang gradient Cam */
    .brand-logo { width: 52px; height: 52px; border-radius: 18px; background: linear-gradient(135deg, #f97316, #ea580c); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 20px; margin-bottom: 12px; }
    .brand-box h2 { font-size: 26px; font-weight: 800; margin: 0; letter-spacing: -0.6px; }
    .brand-box p { color: #cbd5e1; margin: 5px 0 0; font-size: 14px; }

    .nav-section-title { font-size: 11px; text-transform: uppercase; color: #94a3b8; letter-spacing: 1.2px; margin: 22px 12px 10px; font-weight: 800; }

    .sidebar-link { display: flex; align-items: center; gap: 12px; padding: 13px 14px; border-radius: 15px; color: #e2e8f0; text-decoration: none; font-size: 14px; font-weight: 700; margin-bottom: 8px; transition: all 0.2s ease; }
    .sidebar-link i { width: 22px; text-align: center; font-size: 16px; }
    .sidebar-link:hover { background: #1e293b; color: #ffffff; transform: translateX(4px); }
    /* Đã đổi trạng thái Active sang gradient Cam */
    .sidebar-link.active { background: linear-gradient(135deg, #f97316, #ea580c); color: #ffffff; box-shadow: 0 10px 22px rgba(234, 88, 12, 0.22); }

    .admin-user { margin-top: 26px; border-top: 1px solid rgba(148, 163, 184, 0.25); padding: 18px 8px 4px; display: flex; align-items: center; gap: 12px; }
    /* Đã đổi Avatar sang gradient Cam */
    .avatar { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg, #f97316, #22c55e); display: flex; align-items: center; justify-content: center; font-weight: 800; color: white; }
    .admin-user small { color: #94a3b8; }

    /* -- MAIN CONTENT GỐC -- */
    .main-content { margin-left: 292px; width: calc(100% - 292px); padding: 34px 42px; }

    .topbar { display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 26px; }
    .topbar h1 { font-size: 34px; font-weight: 900; margin: 0; letter-spacing: -0.8px; }
    .topbar p { color: #64748b; margin: 6px 0 0; font-size: 15px; }

    .top-action-btn { border: none; border-radius: 16px; padding: 12px 18px; text-decoration: none; font-weight: 900; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08); background: #0f172a; color: #ffffff; }
    .top-action-btn:hover { background: #1e293b; color: #ffffff; }

    /* -- STATS CARDS -- */
    .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 18px; margin-bottom: 22px; }
    .summary-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 22px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06); padding: 20px; display: flex; align-items: center; gap: 14px; }
    .summary-icon { width: 48px; height: 48px; border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 20px; }
    .summary-label { color: #64748b; font-size: 13px; font-weight: 800; margin-bottom: 3px; }
    .summary-value { color: #0f172a; font-size: 26px; font-weight: 900; line-height: 1; }

    /* -- BẢNG VÀ CARD NỘI DUNG -- */
    .content-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 24px; padding: 24px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08); }
    .table { margin-bottom: 0; }
    .table thead th { background: #f8fafc; color: #334155; font-size: 14px; font-weight: 900; border-bottom: 1px solid #e2e8f0; padding: 16px 14px; white-space: nowrap; }
    .table tbody td { padding: 15px 14px; vertical-align: middle; color: #0f172a; font-size: 14px; }

    /* Mã đơn hàng màu Cam */
    .booking-id { font-weight: 900; color: #ea580c; }

    .status-badge { display: inline-flex; align-items: center; justify-content: center; padding: 6px 12px; border-radius: 999px; font-size: 13px; font-weight: 900; }
    .status-pending { background: #fef3c7; color: #92400e; }
    .status-confirmed { background: #e0f2fe; color: #0369a1; }
    .status-completed { background: #dcfce7; color: #166534; }
    .status-cancelled { background: #fee2e2; color: #991b1b; }

    /* Nút Xem chi tiết màu Cam */
    .btn-view { display: inline-flex; align-items: center; justify-content: center; gap: 7px; padding: 9px 14px; border-radius: 999px; background: #ea580c; color: #ffffff; text-decoration: none; font-size: 13px; font-weight: 900; white-space: nowrap; }
    .btn-view:hover { background: #c2410c; color: #ffffff; }

    .empty-box { background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 18px; padding: 40px; text-align: center; color: #64748b; font-weight: 800; }

    /* Class màu Cam custom cho Nút Lọc */
    .btn-orange { background-color: #ea580c; color: #fff; border-color: #ea580c; }
    .btn-orange:hover { background-color: #c2410c; color: #fff; border-color: #c2410c; }
    .btn-outline-orange { color: #ea580c; border-color: #ea580c; background-color: transparent; }
    .btn-outline-orange:hover { background-color: #ea580c; color: #fff; }

    @media (max-width: 992px) {
      .sidebar { position: static; width: 100%; height: auto; }
      .admin-layout { display: block; }
      .main-content { margin-left: 0; width: 100%; padding: 24px; }
      .topbar { display: block; }
      .top-action-btn { margin-top: 16px; }
      .summary-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>

<body>
<div class="admin-layout">

  <aside class="sidebar">
    <div class="brand-box">
      <div class="brand-logo">WV</div>
      <h2>WonderVN</h2>
      <p>Travel ERP System</p>
    </div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/home">
      <i class="fa-solid fa-house"></i>
      <span>Trang chủ quản trị</span>
    </a>

    <div class="nav-section-title">Quản trị hệ thống</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">
      <i class="fa-solid fa-chart-line"></i>
      <span>Dashboard</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
      <i class="fa-solid fa-users"></i>
      <span>Quản lý người dùng</span>
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

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/booking">
      <i class="fa-solid fa-calendar-check"></i>
      <span>Đơn đặt</span>
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

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/feedback">
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
        <small>Admin / Staff</small>
      </div>
    </div>
  </aside>

  <main class="main-content">

    <div class="topbar">
      <div>
        <h1>${bookingPageTitle}</h1>
        <p>${bookingPageSubtitle}</p>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/admin/home">
        <i class="fa-solid fa-arrow-left"></i>
        Về Admin Home
      </a>
    </div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon" style="background: #fffbeb; color: #d97706;">
          <i class="fa-solid fa-clock"></i>
        </div>
        <div>
          <div class="summary-label">Đang xử lý / Xác nhận</div>
          <div class="summary-value">${activeBookingCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon" style="background: #dcfce7; color: #166534;">
          <i class="fa-solid fa-circle-check"></i>
        </div>
        <div>
          <div class="summary-label">Đã hoàn thành</div>
          <div class="summary-value">${completedBookingCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon" style="background: #fee2e2; color: #991b1b;">
          <i class="fa-solid fa-xmark"></i>
        </div>
        <div>
          <div class="summary-label">Đã hủy</div>
          <div class="summary-value">${cancelledBookingCount}</div>
        </div>
      </div>
    </div>

    <div class="content-card">

      <div class="mb-4 d-flex gap-3">
        <a href="?type=" class="btn ${empty selectedBookingType ? 'btn-orange' : 'btn-outline-orange'} rounded-pill px-4 fw-bold">Tất cả</a>
        <a href="?type=Tour" class="btn ${selectedBookingType == 'Tour' ? 'btn-orange' : 'btn-outline-orange'} rounded-pill px-4 fw-bold">
          <i class="fa-solid fa-map-location-dot me-1"></i> Tour
        </a>
        <a href="?type=Accommodation" class="btn ${selectedBookingType == 'Accommodation' ? 'btn-orange' : 'btn-outline-orange'} rounded-pill px-4 fw-bold">
          <i class="fa-solid fa-hotel me-1"></i> Khách sạn
        </a>
      </div>

      <c:choose>
        <c:when test="${not empty bookingList}">
          <div class="table-responsive">
            <table class="table align-middle">
              <thead>
              <tr>
                <th>Mã Đơn</th>
                <th>Khách hàng</th>
                <th>Loại dịch vụ</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${bookingList}" var="booking">
                <tr>
                  <td>
                    <span class="booking-id">#${booking.bookingCode}</span>
                  </td>

                  <td class="fw-bold">${booking.firstName} ${booking.lastName}</td>

                  <td>
                                            <span class="badge ${booking.bookingType == 'Tour' ? 'bg-info text-dark' : 'bg-success'}">
                                                ${booking.bookingType == 'Tour' ? 'Tour' : 'Phòng'}
                                            </span>
                  </td>

                  <td>
                    <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm" />
                  </td>

                  <td class="text-danger fw-bold">
                    <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                  </td>

                  <td>
                    <c:choose>
                      <c:when test="${booking.status == 'Pending'}">
                        <span class="status-badge status-pending">Chờ xử lý</span>
                      </c:when>
                      <c:when test="${booking.status == 'Confirmed'}">
                        <span class="status-badge status-confirmed">Đã xác nhận</span>
                      </c:when>
                      <c:when test="${booking.status == 'Completed'}">
                        <span class="status-badge status-completed">Đã hoàn thành</span>
                      </c:when>
                      <c:when test="${booking.status == 'Cancelled'}">
                        <span class="status-badge status-cancelled">Đã hủy</span>
                      </c:when>
                      <c:otherwise>
                        <span class="status-badge bg-secondary">${booking.status}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td>
                    <a class="btn-view" href="${pageContext.request.contextPath}/admin/booking-detail?bookingID=${booking.bookingID}">
                      <i class="fa-solid fa-eye"></i> Xem
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
            <i class="fa-solid fa-folder-open fs-1 text-secondary mb-3"></i>
            <br>Không có đơn đặt nào trong hệ thống.
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>