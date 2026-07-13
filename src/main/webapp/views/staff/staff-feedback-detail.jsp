<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Staff Feedback Detail</title>
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
      color: #b91c1c;
      border: 1px solid #f87171;
      border-radius: 18px;
      padding: 18px 22px;
      margin-bottom: 22px;
      font-weight: 800;
    }

    .detail-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 24px;
      padding: 28px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
    }

    .section-title {
      font-size: 22px;
      font-weight: 900;
      margin-bottom: 18px;
      color: #0f172a;
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 18px;
      margin-bottom: 26px;
    }

    .info-box {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 18px;
      padding: 18px;
    }

    .info-label {
      display: block;
      color: #64748b;
      font-size: 13px;
      font-weight: 800;
      margin-bottom: 6px;
    }

    .info-value {
      color: #0f172a;
      font-size: 16px;
      font-weight: 900;
      word-break: break-word;
    }

    .rate-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      padding: 8px 15px;
      border-radius: 999px;
      background: #fef3c7;
      color: #92400e;
      font-size: 15px;
      font-weight: 900;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 8px 15px;
      border-radius: 999px;
      font-size: 14px;
      font-weight: 900;
    }

    .status-visible {
      background: #dcfce7;
      color: #166534;
    }

    .status-hidden {
      background: #fee2e2;
      color: #991b1b;
    }

    .content-box {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 18px;
      padding: 20px;
      color: #334155;
      font-size: 16px;
      font-weight: 600;
      line-height: 1.8;
      white-space: pre-wrap;
      margin-bottom: 26px;
    }

    .feedback-image {
      width: 100%;
      max-width: 520px;
      border-radius: 20px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
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

    .divider {
      height: 1px;
      background: #e2e8f0;
      margin: 28px 0;
    }

    .action-row {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      margin-top: 28px;
    }

    .btn-approve,
    .btn-hide,
    .btn-back {
      border-radius: 999px;
      padding: 12px 20px;
      font-weight: 900;
      border: none;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
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
      background: #dc2626;
    }

    .btn-hide:hover {
      background: #b91c1c;
      color: #ffffff;
    }

    .btn-back {
      background: #0f172a;
    }

    .btn-back:hover {
      background: #1e293b;
      color: #ffffff;
    }

    .inline-form {
      display: inline;
      margin: 0;
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

      .info-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>

<body>
<div class="staff-layout">

  <jsp:include page="/views/common/staff-sidebar.jsp"/>

  <main class="main-content">
    <div class="topbar">
      <div>
        <h1>Feedback Detail</h1>
        <p>Staff xem chi tiết feedback và duyệt hoặc ẩn feedback của khách hàng.</p>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/staff/feedback">
        <i class="fa-solid fa-arrow-left"></i>
        Quay lại danh sách
      </a>
    </div>

    <c:if test="${param.success == 'status'}">
      <div class="success-box">
        <i class="fa-solid fa-circle-check me-2"></i>
        Cập nhật trạng thái feedback thành công.
      </div>
    </c:if>

    <c:if test="${param.error == 'update'}">
      <div class="error-box">
        Cập nhật trạng thái feedback thất bại.
      </div>
    </c:if>

    <c:if test="${not empty error}">
      <div class="error-box">
          ${error}
      </div>
    </c:if>

    <c:if test="${not empty feedbackDetail}">
      <div class="detail-card">
        <div class="section-title">
          <i class="fa-solid fa-comment-dots me-2"></i>
          Thông tin Feedback
        </div>

        <div class="info-grid">
          <div class="info-box">
            <span class="info-label">Feedback ID</span>
            <span class="info-value">#${feedbackDetail.feedbackID}</span>
          </div>

          <div class="info-box">
            <span class="info-label">Rate</span>
            <span class="rate-badge">
                            <i class="fa-solid fa-star"></i>
                            <fmt:formatNumber value="${feedbackDetail.rate}" maxFractionDigits="0"/> / 5
                        </span>
          </div>

          <div class="info-box">
            <span class="info-label">Ngày tạo</span>
            <span class="info-value">
                            <fmt:formatDate value="${feedbackDetail.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
          </div>

          <div class="info-box">
            <span class="info-label">Status</span>
            <c:choose>
              <c:when test="${feedbackDetail.status == 'Visible'}">
                <span class="status-badge status-visible">Visible</span>
              </c:when>
              <c:otherwise>
                <span class="status-badge status-hidden">Hidden</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="section-title">
          <i class="fa-solid fa-align-left me-2"></i>
          Nội dung Feedback
        </div>

        <div class="content-box">${feedbackDetail.content}</div>

        <div class="section-title">
          <i class="fa-solid fa-image me-2"></i>
          Hình ảnh Feedback
        </div>

        <c:choose>
          <c:when test="${not empty feedbackDetail.image}">
            <img class="feedback-image"
                 src="${feedbackDetail.image}"
                 alt="Feedback Image">
          </c:when>
          <c:otherwise>
            <div class="no-image">
              Feedback này không có hình ảnh.
            </div>
          </c:otherwise>
        </c:choose>

        <div class="divider"></div>

        <div class="section-title">
          <i class="fa-solid fa-user me-2"></i>
          Thông tin Customer
        </div>

        <div class="info-grid">
          <div class="info-box">
            <span class="info-label">User ID</span>
            <span class="info-value">${feedbackDetail.userID}</span>
          </div>

          <div class="info-box">
            <span class="info-label">Họ tên</span>
            <span class="info-value">${feedbackDetail.firstName} ${feedbackDetail.lastName}</span>
          </div>

          <div class="info-box">
            <span class="info-label">Email</span>
            <span class="info-value">${feedbackDetail.email}</span>
          </div>
        </div>

        <div class="divider"></div>

        <div class="section-title">
          <i class="fa-solid fa-calendar-check me-2"></i>
          Thông tin Booking
        </div>

        <div class="info-grid">
          <div class="info-box">
            <span class="info-label">Booking ID</span>
            <span class="info-value">${feedbackDetail.bookingID}</span>
          </div>

          <div class="info-box">
            <span class="info-label">Booking Code</span>
            <span class="info-value">${feedbackDetail.bookingCode}</span>
          </div>

          <div class="info-box">
            <span class="info-label">Booking Type</span>
            <span class="info-value">${feedbackDetail.bookingType}</span>
          </div>

          <div class="info-box">
            <span class="info-label">Total Price</span>
            <span class="info-value">
                            <fmt:formatNumber value="${feedbackDetail.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </span>
          </div>
        </div>

        <div class="action-row">
          <c:choose>
            <c:when test="${feedbackDetail.status == 'Hidden'}">
              <form class="inline-form"
                    action="${pageContext.request.contextPath}/staff/feedback-status"
                    method="post">
                <input type="hidden" name="feedbackID" value="${feedbackDetail.feedbackID}">
                <input type="hidden" name="status" value="Visible">
                <input type="hidden" name="redirectTo" value="detail">

                <button type="submit" class="btn-approve">
                  <i class="fa-solid fa-check"></i>
                  Approve Feedback
                </button>
              </form>
            </c:when>

            <c:otherwise>
              <form class="inline-form"
                    action="${pageContext.request.contextPath}/staff/feedback-status"
                    method="post">
                <input type="hidden" name="feedbackID" value="${feedbackDetail.feedbackID}">
                <input type="hidden" name="status" value="Hidden">
                <input type="hidden" name="redirectTo" value="detail">

                <button type="submit" class="btn-hide">
                  <i class="fa-solid fa-eye-slash"></i>
                  Hide Feedback
                </button>
              </form>
            </c:otherwise>
          </c:choose>

          <a class="btn-back" href="${pageContext.request.contextPath}/staff/feedback">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại danh sách
          </a>
        </div>
      </div>
    </c:if>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
