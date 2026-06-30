<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Chi tiết đánh giá khách hàng</title>
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

    .brand-box {
      padding: 8px 10px 22px;
      margin-bottom: 12px;
      border-bottom: 1px solid rgba(148, 163, 184, 0.25);
    }

    .brand-logo {
      width: 52px;
      height: 52px;
      border-radius: 18px;
      background: linear-gradient(135deg, #7c3aed, #2563eb);
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
      background: linear-gradient(135deg, #7c3aed, #2563eb);
      color: white;
      box-shadow: 0 10px 22px rgba(124, 58, 237, 0.22);
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
      background: linear-gradient(135deg, #7c3aed, #06b6d4);
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

    .top-action-row {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
      justify-content: flex-end;
    }

    .btn-top {
      border: none;
      border-radius: 16px;
      padding: 12px 18px;
      text-decoration: none;
      font-weight: 900;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
      white-space: nowrap;
      font-family: inherit;
      min-height: 46px;
    }

    .btn-back {
      background: #ffffff;
      color: #0f172a;
      border: 1px solid #dbe3ef;
    }

    .btn-back:hover {
      background: #f8fafc;
      color: #0f172a;
    }

    .readonly-note {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 16px;
      border-radius: 999px;
      background: #f1f5f9;
      color: #475569;
      font-size: 14px;
      font-weight: 900;
      white-space: nowrap;
    }

    .error-box {
      background: #fee2e2;
      color: #b91c1c;
      border: 1px solid #f87171;
      border-radius: 18px;
      padding: 16px 20px;
      font-weight: 800;
      margin-bottom: 20px;
    }

    .detail-grid {
      display: grid;
      grid-template-columns: minmax(0, 1fr) 360px;
      gap: 24px;
      align-items: start;
    }

    .detail-card,
    .side-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 26px;
      box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
    }

    .detail-card {
      padding: 28px;
    }

    .side-card {
      padding: 22px;
      position: sticky;
      top: 28px;
    }

    .review-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 18px;
      flex-wrap: wrap;
      padding-bottom: 20px;
      border-bottom: 1px dashed #cbd5e1;
      margin-bottom: 22px;
    }

    .customer-box {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .customer-avatar {
      width: 58px;
      height: 58px;
      border-radius: 50%;
      background: linear-gradient(135deg, #7c3aed, #2563eb);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #ffffff;
      font-weight: 900;
      font-size: 20px;
      flex: 0 0 auto;
    }

    .customer-name {
      font-size: 20px;
      font-weight: 900;
      color: #0f172a;
      margin-bottom: 4px;
    }

    .customer-email {
      color: #64748b;
      font-size: 14px;
      font-weight: 700;
    }

    .rate-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 11px 16px;
      border-radius: 999px;
      background: #fef3c7;
      color: #92400e;
      font-size: 16px;
      font-weight: 900;
      white-space: nowrap;
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 24px;
    }

    .info-box {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 18px;
      padding: 16px;
    }

    .info-label {
      font-size: 12px;
      font-weight: 900;
      color: #64748b;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 6px;
    }

    .info-value {
      color: #0f172a;
      font-size: 16px;
      font-weight: 900;
      word-break: break-word;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      padding: 8px 12px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 900;
      white-space: nowrap;
    }

    .status-visible {
      background: #dcfce7;
      color: #166534;
    }

    .status-hidden {
      background: #fee2e2;
      color: #991b1b;
    }

    .section-title {
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 0 0 18px;
      font-size: 22px;
      font-weight: 900;
      color: #0f172a;
    }

    .section-title i {
      color: #7c3aed;
    }

    .content-box {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 20px;
      padding: 22px;
      color: #334155;
      font-size: 16px;
      font-weight: 600;
      line-height: 1.9;
      white-space: pre-wrap;
      margin-bottom: 24px;
    }

    .feedback-image {
      width: 100%;
      max-width: 680px;
      border-radius: 20px;
      border: 1px solid #e2e8f0;
      display: block;
      box-shadow: 0 12px 28px rgba(15, 23, 42, 0.12);
    }

    .no-image {
      background: #f8fafc;
      border: 1px dashed #cbd5e1;
      border-radius: 18px;
      padding: 24px;
      color: #64748b;
      font-weight: 800;
      text-align: center;
    }

    .service-image {
      width: 100%;
      height: 190px;
      object-fit: cover;
      border-radius: 20px;
      background: #e2e8f0;
      margin-bottom: 16px;
    }

    .side-title {
      font-size: 20px;
      font-weight: 900;
      color: #0f172a;
      line-height: 1.35;
      margin-bottom: 14px;
    }

    .side-info-list {
      display: grid;
      gap: 12px;
    }

    .side-info-item {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 16px;
      padding: 14px;
    }

    .side-label {
      color: #64748b;
      font-size: 12px;
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 5px;
    }

    .side-value {
      color: #0f172a;
      font-size: 15px;
      font-weight: 900;
      word-break: break-word;
    }

    .empty-box {
      background: #ffffff;
      border: 1px dashed #cbd5e1;
      border-radius: 24px;
      padding: 52px 20px;
      text-align: center;
      color: #64748b;
      box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04);
    }

    .empty-box i {
      font-size: 46px;
      color: #94a3b8;
      margin-bottom: 14px;
    }

    .empty-box h3 {
      color: #0f172a;
      margin: 0 0 8px;
      font-size: 24px;
      font-weight: 900;
    }

    .empty-box p {
      margin: 0;
      font-size: 15px;
      line-height: 1.7;
    }

    @media (max-width: 1200px) {
      .detail-grid {
        grid-template-columns: 1fr;
      }

      .side-card {
        position: static;
      }
    }

    @media (max-width: 992px) {
      .sidebar {
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

      .top-action-row {
        justify-content: flex-start;
        margin-top: 16px;
      }

      .info-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 620px) {
      .info-grid {
        grid-template-columns: 1fr;
      }

      .btn-top,
      .readonly-note {
        width: 100%;
        justify-content: center;
      }
    }
  </style>
</head>

<body>
<div class="admin-layout">

  <aside class="sidebar">
    <div class="brand-box">
      <div class="brand-logo">WV</div>
      <h2>WonderVN</h2>
      <p>Admin Dashboard</p>
    </div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/home">
      <i class="fa-solid fa-house"></i>
      <span>Trang chủ Admin</span>
    </a>

    <div class="nav-section-title">Quản trị hệ thống</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
      <i class="fa-solid fa-users"></i>
      <span>Quản lý người dùng</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/booking">
      <i class="fa-solid fa-calendar-check"></i>
      <span>Xem đặt chỗ</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/payment">
      <i class="fa-solid fa-credit-card"></i>
      <span>Xem thanh toán</span>
    </a>

    <div class="nav-section-title">Dịch vụ</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/tour">
      <i class="fa-solid fa-map-location-dot"></i>
      <span>Xem Tour</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/accommodation">
      <i class="fa-solid fa-hotel"></i>
      <span>Xem lưu trú</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/vehicle">
      <i class="fa-solid fa-car-side"></i>
      <span>Xem phương tiện</span>
    </a>

    <div class="nav-section-title">Nội dung & báo cáo</div>

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/feedback">
      <i class="fa-solid fa-comments"></i>
      <span>Xem feedback</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/report">
      <i class="fa-solid fa-chart-line"></i>
      <span>Báo cáo</span>
    </a>

    <div class="admin-user">
      <div class="avatar">AD</div>
      <div>
        <div class="fw-bold">Quản trị viên</div>
        <small>Admin</small>
      </div>
    </div>
  </aside>

  <main class="main-content">
    <div class="topbar">
      <div>
        <h1>Chi tiết đánh giá khách hàng</h1>
      </div>

      <div class="top-action-row">
        <a class="btn-top btn-back"
           href="${pageContext.request.contextPath}/admin/feedback?type=${type}">
          <i class="fa-solid fa-arrow-left"></i>
          Quay lại danh sách
        </a>

        <div class="readonly-note">
          <i class="fa-solid fa-lock"></i>
          Chỉ xem
        </div>
      </div>
    </div>

    <c:choose>
      <c:when test="${not empty feedbackDetail}">
        <div class="detail-grid">
          <div class="detail-card">
            <div class="review-header">
              <div class="customer-box">
                <div class="customer-avatar">
                  <i class="fa-solid fa-user"></i>
                </div>

                <div>
                  <div class="customer-name">${feedbackDetail.customerName}</div>
                  <div class="customer-email">${feedbackDetail.customerEmail}</div>
                </div>
              </div>

              <div class="rate-badge">
                <i class="fa-solid fa-star"></i>
                <fmt:formatNumber value="${feedbackDetail.rate}" maxFractionDigits="0"/> / 5
              </div>
            </div>

            <div class="info-grid">
              <div class="info-box">
                <div class="info-label">Mã đánh giá</div>
                <div class="info-value">#${feedbackDetail.feedbackID}</div>
              </div>

              <div class="info-box">
                <div class="info-label">Ngày tạo</div>
                <div class="info-value">
                  <fmt:formatDate value="${feedbackDetail.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                </div>
              </div>

              <div class="info-box">
                <div class="info-label">Trạng thái</div>

                <c:choose>
                  <c:when test="${feedbackDetail.status == 'Visible'}">
                                        <span class="status-badge status-visible">
                                            <i class="fa-solid fa-circle-check"></i>
                                            Hiển thị
                                        </span>
                  </c:when>

                  <c:otherwise>
                                        <span class="status-badge status-hidden">
                                            <i class="fa-solid fa-eye-slash"></i>
                                            Đang ẩn
                                        </span>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="info-box">
                <div class="info-label">Loại dịch vụ</div>
                <div class="info-value">${feedbackDetail.serviceTypeText}</div>
              </div>

              <div class="info-box">
                <div class="info-label">Tên dịch vụ</div>
                <div class="info-value">${feedbackDetail.serviceName}</div>
              </div>

              <div class="info-box">
                <div class="info-label">Mã đặt chỗ</div>
                <div class="info-value">${feedbackDetail.bookingCode}</div>
              </div>

              <div class="info-box">
                <div class="info-label">Loại đặt chỗ</div>
                <div class="info-value">${feedbackDetail.bookingType}</div>
              </div>

              <div class="info-box">
                <div class="info-label">Số lượng</div>
                <div class="info-value">${feedbackDetail.quantity}</div>
              </div>

              <div class="info-box">
                <div class="info-label">Tổng tiền</div>
                <div class="info-value">
                  <fmt:formatNumber value="${feedbackDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                </div>
              </div>
            </div>

            <h2 class="section-title">
              <i class="fa-solid fa-align-left"></i>
              Nội dung đánh giá
            </h2>

            <div class="content-box">${feedbackDetail.content}</div>

            <h2 class="section-title">
              <i class="fa-solid fa-image"></i>
              Hình ảnh đánh giá
            </h2>

            <c:choose>
              <c:when test="${not empty feedbackDetail.image}">
                <img class="feedback-image"
                     src="${feedbackDetail.image}"
                     alt="Ảnh đánh giá"
                     onerror="this.style.display='none';">
              </c:when>

              <c:otherwise>
                <div class="no-image">
                  Đánh giá này không có hình ảnh.
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <aside class="side-card">
            <c:choose>
              <c:when test="${not empty feedbackDetail.serviceImage}">
                <img class="service-image"
                     src="${feedbackDetail.serviceImage}"
                     alt="${feedbackDetail.serviceName}"
                     onerror="this.src='https://placehold.co/800x500?text=WonderVN';">
              </c:when>

              <c:otherwise>
                <img class="service-image"
                     src="https://placehold.co/800x500?text=WonderVN"
                     alt="WonderVN">
              </c:otherwise>
            </c:choose>

            <div class="side-title">${feedbackDetail.serviceName}</div>

            <div class="side-info-list">
              <div class="side-info-item">
                <div class="side-label">Khách hàng</div>
                <div class="side-value">${feedbackDetail.customerName}</div>
              </div>

              <div class="side-info-item">
                <div class="side-label">Email khách hàng</div>
                <div class="side-value">${feedbackDetail.customerEmail}</div>
              </div>

              <div class="side-info-item">
                <div class="side-label">Loại dịch vụ</div>
                <div class="side-value">${feedbackDetail.serviceTypeText}</div>
              </div>

              <div class="side-info-item">
                <div class="side-label">Mã booking</div>
                <div class="side-value">${feedbackDetail.bookingCode}</div>
              </div>

              <div class="side-info-item">
                <div class="side-label">Trạng thái booking</div>
                <div class="side-value">${feedbackDetail.bookingStatus}</div>
              </div>

              <div class="side-info-item">
                <div class="side-label">Trạng thái feedback</div>
                <div class="side-value">
                  <c:choose>
                    <c:when test="${feedbackDetail.status == 'Visible'}">
                                            <span class="status-badge status-visible">
                                                <i class="fa-solid fa-circle-check"></i>
                                                Hiển thị
                                            </span>
                    </c:when>

                    <c:otherwise>
                                            <span class="status-badge status-hidden">
                                                <i class="fa-solid fa-eye-slash"></i>
                                                Đang ẩn
                                            </span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </aside>
        </div>
      </c:when>

      <c:otherwise>
        <c:if test="${not empty error}">
          <div class="error-box">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>
              ${error}
          </div>
        </c:if>

        <div class="empty-box">
          <i class="fa-regular fa-comment-dots"></i>
          <h3>Không tìm thấy đánh giá</h3>
          <p>Đánh giá này không tồn tại hoặc đã bị xóa khỏi hệ thống.</p>
        </div>
      </c:otherwise>
    </c:choose>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>