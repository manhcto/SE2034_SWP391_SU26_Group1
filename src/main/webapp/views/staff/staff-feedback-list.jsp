<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Quản lý đánh giá khách hàng</title>
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
      white-space: nowrap;
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
      color: #b91c1c;
      border: 1px solid #f87171;
      border-radius: 18px;
      padding: 16px 20px;
      font-weight: 800;
      margin-bottom: 20px;
    }

    .stat-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 16px;
      margin-bottom: 20px;
    }

    .stat-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 22px;
      padding: 18px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
    }

    .stat-icon {
      width: 44px;
      height: 44px;
      border-radius: 16px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: #ffffff;
      margin-bottom: 12px;
      background: linear-gradient(135deg, #2563eb, #1d4ed8);
    }

    .stat-label {
      color: #64748b;
      font-size: 13px;
      font-weight: 800;
      margin-bottom: 4px;
    }

    .stat-value {
      color: #0f172a;
      font-size: 24px;
      font-weight: 900;
    }

    .tab-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 14px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
      margin-bottom: 20px;
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }

    .tab-link {
      min-height: 44px;
      border-radius: 999px;
      padding: 10px 16px;
      text-decoration: none;
      color: #334155;
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      font-size: 14px;
      font-weight: 900;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: 0.18s ease;
    }

    .tab-link:hover {
      color: #1d4ed8;
      background: #eff6ff;
      border-color: #bfdbfe;
    }

    .tab-link.active {
      color: #ffffff;
      background: linear-gradient(135deg, #2563eb, #1d4ed8);
      border-color: transparent;
      box-shadow: 0 10px 20px rgba(37, 99, 235, 0.18);
    }

    .content-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 24px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
    }

    .content-card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 14px;
      margin-bottom: 18px;
    }

    .content-card-header h2 {
      margin: 0;
      font-size: 22px;
      font-weight: 900;
      color: #0f172a;
    }

    .content-card-header p {
      margin: 5px 0 0;
      color: #64748b;
      font-size: 14px;
      font-weight: 700;
    }

    .table {
      margin-bottom: 0;
    }

    .table thead th {
      background: #f8fafc;
      color: #334155;
      font-size: 13px;
      font-weight: 900;
      border-bottom: 1px solid #e2e8f0;
      padding: 15px 12px;
      white-space: nowrap;
    }

    .table tbody td {
      padding: 15px 12px;
      vertical-align: middle;
      color: #0f172a;
      font-size: 13.5px;
    }

    .feedback-id {
      font-weight: 900;
      color: #4e46dc;
      white-space: nowrap;
    }

    .customer-name {
      font-weight: 900;
      color: #0f172a;
      margin-bottom: 3px;
    }

    .customer-email {
      color: #64748b;
      font-size: 12px;
      font-weight: 700;
    }

    .service-name {
      font-weight: 900;
      color: #0f172a;
      max-width: 220px;
    }

    .service-type {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      margin-top: 5px;
      padding: 5px 9px;
      border-radius: 999px;
      background: #eef2ff;
      color: #3730a3;
      font-size: 12px;
      font-weight: 900;
    }

    .rate-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 5px;
      padding: 6px 12px;
      border-radius: 999px;
      background: #fef3c7;
      color: #92400e;
      font-size: 13px;
      font-weight: 900;
      white-space: nowrap;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      padding: 6px 12px;
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

    .content-preview {
      max-width: 330px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: #475569;
      font-weight: 600;
    }

    .action-group {
      display: flex;
      gap: 8px;
      align-items: center;
      flex-wrap: wrap;
      min-width: 220px;
    }

    .btn-action {
      min-height: 36px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      padding: 8px 12px;
      border-radius: 999px;
      color: #ffffff;
      text-decoration: none;
      font-size: 12.5px;
      font-weight: 900;
      white-space: nowrap;
      border: none;
      font-family: inherit;
    }

    .btn-view {
      background: #4e46dc;
    }

    .btn-view:hover {
      background: #3730a3;
      color: #ffffff;
    }

    .btn-approve {
      background: #16a34a;
    }

    .btn-approve:hover {
      background: #15803d;
      color: #ffffff;
    }

    .btn-hide {
      background: #f97316;
    }

    .btn-hide:hover {
      background: #ea580c;
      color: #ffffff;
    }

    .btn-delete {
      background: #dc2626;
    }

    .btn-delete:hover {
      background: #b91c1c;
      color: #ffffff;
    }

    .inline-form {
      display: inline;
      margin: 0;
    }

    .empty-box {
      background: #f8fafc;
      border: 1px dashed #cbd5e1;
      border-radius: 18px;
      padding: 46px 24px;
      text-align: center;
      color: #64748b;
      font-weight: 800;
    }

    .empty-box i {
      font-size: 42px;
      color: #94a3b8;
      margin-bottom: 12px;
    }

    .empty-box h3 {
      margin: 0 0 8px;
      color: #0f172a;
      font-size: 22px;
      font-weight: 900;
    }

    .empty-box p {
      margin: 0;
      color: #64748b;
    }

    @media (max-width: 1200px) {
      .stat-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
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

    @media (max-width: 620px) {
      .stat-grid {
        grid-template-columns: 1fr;
      }

      .tab-link {
        width: 100%;
        justify-content: center;
      }

      .content-card {
        padding: 16px;
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

    <div class="nav-section-title">Vận hành</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
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

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/staff/feedback">
      <i class="fa-solid fa-comments"></i>
      <span>Đánh giá khách hàng</span>
    </a>

    <div class="admin-user">
      <div class="avatar">ST</div>
      <div>
        <div class="fw-bold">Nhân viên</div>
        <small>Staff</small>
      </div>
    </div>
  </aside>

  <main class="main-content">
    <div class="topbar">
      <div>
        <h1>Quản lý đánh giá khách hàng</h1>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/staff/home">
        <i class="fa-solid fa-arrow-left"></i>
        Về Staff Home
      </a>
    </div>

    <c:if test="${param.success == 'status'}">
      <div class="success-box">
        <i class="fa-solid fa-circle-check me-2"></i>
        Cập nhật trạng thái đánh giá thành công.
      </div>
    </c:if>

    <c:if test="${param.success == 'delete'}">
      <div class="success-box">
        <i class="fa-solid fa-circle-check me-2"></i>
        Xóa đánh giá thành công.
      </div>
    </c:if>

    <c:if test="${param.error == 'invalid'}">
      <div class="error-box">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
        Mã đánh giá không hợp lệ.
      </div>
    </c:if>

    <c:if test="${param.error == 'status'}">
      <div class="error-box">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
        Cập nhật trạng thái đánh giá thất bại.
      </div>
    </c:if>

    <c:if test="${param.error == 'notfound'}">
      <div class="error-box">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
        Không tìm thấy đánh giá.
      </div>
    </c:if>

    <c:if test="${param.error == 'delete'}">
      <div class="error-box">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
        Xóa đánh giá thất bại.
      </div>
    </c:if>

    <div class="stat-grid">
      <div class="stat-card">
        <div class="stat-icon">
          <i class="fa-solid fa-comments"></i>
        </div>
        <div class="stat-label">Loại đang xem</div>
        <div class="stat-value">${typeText}</div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">
          <i class="fa-solid fa-layer-group"></i>
        </div>
        <div class="stat-label">Số đánh giá</div>
        <div class="stat-value">${fn:length(feedbackList)}</div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">
          <i class="fa-solid fa-eye"></i>
        </div>
        <div class="stat-label">Đã công khai</div>
        <div class="stat-value">
          <c:set var="visibleCount" value="0"/>
          <c:forEach var="fb" items="${feedbackList}">
            <c:if test="${fb.status == 'Visible'}">
              <c:set var="visibleCount" value="${visibleCount + 1}"/>
            </c:if>
          </c:forEach>
          ${visibleCount}
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">
          <i class="fa-solid fa-eye-slash"></i>
        </div>
        <div class="stat-label">Đang ẩn / chờ duyệt</div>
        <div class="stat-value">
          <c:set var="hiddenCount" value="0"/>
          <c:forEach var="fb" items="${feedbackList}">
            <c:if test="${fb.status != 'Visible'}">
              <c:set var="hiddenCount" value="${hiddenCount + 1}"/>
            </c:if>
          </c:forEach>
          ${hiddenCount}
        </div>
      </div>
    </div>

    <div class="tab-card">
      <a class="tab-link ${type == 'All' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/staff/feedback?type=All">
        <i class="fa-solid fa-border-all"></i>
        Tất cả
      </a>

      <a class="tab-link ${type == 'Tour' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/staff/feedback?type=Tour">
        <i class="fa-solid fa-map-location-dot"></i>
        Tour
      </a>

      <a class="tab-link ${type == 'Accommodation' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/staff/feedback?type=Accommodation">
        <i class="fa-solid fa-hotel"></i>
        Khách sạn
      </a>

    </div>

    <div class="content-card">
      <div class="content-card-header">
        <div>
          <h2>Danh sách đánh giá</h2>
          <p>Hiển thị các đánh giá thuộc tab: ${typeText}</p>
        </div>
      </div>

      <c:choose>
        <c:when test="${not empty feedbackList}">
          <div class="table-responsive">
            <table class="table align-middle">
              <thead>
              <tr>
                <th>Mã</th>
                <th>Khách hàng</th>
                <th>Dịch vụ</th>
                <th>Số sao</th>
                <th style="width: 35%">Nội dung</th>
                <th>Ngày tạo</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
              </tr>
              </thead>

              <tbody>
              <c:forEach items="${feedbackList}" var="feedback">
                <tr>
                  <td>
                    <span class="feedback-id">#${feedback.feedbackID}</span>
                  </td>

                  <td>
                    <div class="customer-name">${feedback.customerName}</div>
                    <div class="customer-email">${feedback.customerEmail}</div>
                  </td>

                  <td>
                    <div class="service-name">${feedback.serviceName}</div>
                    <div class="service-type">
                      <c:choose>
                        <c:when test="${feedback.serviceType == 'Accommodation'}">
                          <i class="fa-solid fa-hotel"></i>
                          Khách sạn
                        </c:when>
                        <c:when test="${feedback.serviceType == 'Tour'}">
                          <i class="fa-solid fa-map-location-dot"></i>
                          Tour
                        </c:when>
                        <c:otherwise>
                          <i class="fa-solid fa-briefcase"></i>
                          Dịch vụ
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </td>

                  <td>
                                        <span class="rate-badge">
                                            <i class="fa-solid fa-star"></i>
                                            <fmt:formatNumber value="${feedback.rate}" maxFractionDigits="0"/> / 5
                                        </span>
                  </td>

                  <td>
                    <div class="text-wrap text-break" style="color: #475569; font-weight: 600; min-width: 200px;">
                        ${feedback.content}
                    </div>
                  </td>

                  <td>
                    <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                  </td>

                  <td>
                    <c:choose>
                      <c:when test="${feedback.status == 'Visible'}">
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
                  </td>

                  <td>
                    <div class="action-group">
                      <c:if test="${feedback.status != 'Visible'}">
                        <form class="inline-form"
                              action="${pageContext.request.contextPath}/staff/feedback-status"
                              method="post">
                          <input type="hidden" name="feedbackID" value="${feedback.feedbackID}">
                          <input type="hidden" name="status" value="Visible">
                          <input type="hidden" name="redirectTo" value="list">
                          <input type="hidden" name="type" value="${type}">

                          <button type="submit" class="btn-action btn-approve">
                            <i class="fa-solid fa-check"></i>
                            Duyệt
                          </button>
                        </form>
                      </c:if>

                      <form class="inline-form"
                            action="${pageContext.request.contextPath}/staff/feedback-delete"
                            method="post"
                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa đánh giá này không?');">
                        <input type="hidden" name="feedbackID" value="${feedback.feedbackID}">
                        <input type="hidden" name="type" value="${type}">

                        <button type="submit" class="btn-action btn-delete">
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
            <i class="fa-regular fa-comment-dots"></i>
            <h3>Chưa có đánh giá nào</h3>
            <p>Hiện chưa có đánh giá thuộc tab ${typeText}.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>