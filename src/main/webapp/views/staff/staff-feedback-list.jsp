<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Quản lý đánh giá</title>
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
      flex: 1;
      min-width: 0;
      width: auto;
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
    }

    .content-card.is-loading {
      opacity: 0.58;
      pointer-events: none;
      transition: opacity 0.18s ease;
    }

    .filter-card {
      display: grid;
      grid-template-columns: minmax(280px, 1fr) 220px 190px auto;
      gap: 12px;
      align-items: center;
      padding: 18px;
      margin-bottom: 18px;
      border: 1px solid #e2e8f0;
      border-radius: 20px;
      background: #ffffff;
      box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
    }

    .filter-card .form-control,
    .filter-card .form-select {
      min-height: 46px;
      border-radius: 13px;
      font-weight: 700;
    }

    .filter-button {
      min-height: 46px;
      border-radius: 13px;
      padding: 0 18px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      font-weight: 900;
      text-decoration: none;
      white-space: nowrap;
    }

    .filter-button {
      border: 0;
      background: #4e46dc;
      color: #ffffff;
    }


    .service-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      border-radius: 999px;
      padding: 5px 10px;
      font-size: 12px;
      font-weight: 900;
      margin-bottom: 5px;
    }

    .service-tour {
      background: #dbeafe;
      color: #1d4ed8;
    }

    .service-accommodation {
      background: #dcfce7;
      color: #166534;
    }

    .service-name {
      display: block;
      max-width: 280px;
      color: #0f172a;
      font-weight: 800;
      text-decoration: none;
      line-height: 1.4;
    }

    .service-name:hover {
      color: #4e46dc;
    }

    .table-responsive {
      overflow-x: visible;
    }

    .table {
      width: 100%;
      table-layout: fixed;
      margin-bottom: 0;
    }

    .table thead th {
      background: #f8fafc;
      color: #334155;
      font-size: 14px;
      font-weight: 900;
      border-bottom: 1px solid #e2e8f0;
      padding: 16px 14px;
      white-space: normal;
    }

    .table tbody td {
      padding: 15px 14px;
      vertical-align: middle;
      color: #0f172a;
      font-size: 14px;
      overflow-wrap: anywhere;
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
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 6px 12px;
      border-radius: 999px;
      font-size: 13px;
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
    }

    .btn-view,
    .btn-approve,
    .btn-hide {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      padding: 9px 14px;
      border-radius: 999px;
      color: #ffffff;
      text-decoration: none;
      font-size: 13px;
      font-weight: 900;
      white-space: nowrap;
      border: none;
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
      background: #dc2626;
    }

    .btn-hide:hover {
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

      .filter-card {
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
        <h1>Quản lý đánh giá</h1>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/staff/tour">
        <i class="fa-solid fa-arrow-left"></i>
        Về quản lý tour
      </a>
    </div>

    <c:if test="${param.success == 'status'}">
      <div class="success-box">
        <i class="fa-solid fa-circle-check me-2"></i>
        Cập nhật trạng thái đánh giá thành công.
      </div>
    </c:if>

    <c:if test="${param.error == 'invalid'}">
      <div class="error-box">
        Mã đánh giá không hợp lệ.
      </div>
    </c:if>

    <c:if test="${param.error == 'status'}">
      <div class="error-box">
        Trạng thái đánh giá không hợp lệ.
      </div>
    </c:if>

    <c:if test="${param.error == 'notfound'}">
      <div class="error-box">
        Không tìm thấy đánh giá.
      </div>
    </c:if>

    <c:if test="${param.error == 'update'}">
      <div class="error-box">
        Cập nhật trạng thái đánh giá thất bại.
      </div>
    </c:if>

    <form id="feedbackFilterForm"
          class="filter-card"
          action="${pageContext.request.contextPath}/staff/feedback"
          method="get">
      <input id="feedbackKeyword"
             class="form-control"
             type="search"
             name="keyword"
             value="${fn:escapeXml(keyword)}"
             placeholder="Tìm tên tour, nơi lưu trú, nội dung, khách hàng hoặc mã đơn...">

      <select id="feedbackServiceType" class="form-select" name="serviceType" aria-label="Lọc loại đánh giá">
        <option value="">Tất cả loại đánh giá</option>
        <option value="Tour" ${selectedServiceType == 'Tour' ? 'selected' : ''}>Đánh giá Tour</option>
        <option value="Accommodation" ${selectedServiceType == 'Accommodation' ? 'selected' : ''}>Đánh giá Lưu trú</option>
      </select>

      <select id="feedbackStatus" class="form-select" name="status" aria-label="Lọc trạng thái">
        <option value="">Tất cả trạng thái</option>
        <option value="Visible" ${selectedStatus == 'Visible' ? 'selected' : ''}>Hiển thị</option>
        <option value="Hidden" ${selectedStatus == 'Hidden' ? 'selected' : ''}>Đã ẩn</option>
      </select>

      <button class="filter-button" type="submit">
        <i class="fa-solid fa-filter"></i>
        Lọc
      </button>
    </form>

    <div id="feedbackResults" class="content-card" aria-live="polite">
      <c:choose>
        <c:when test="${not empty feedbackList}">
          <div class="table-responsive">
            <table class="table align-middle">
              <colgroup>
                <col style="width: 9%;">
                <col style="width: 25%;">
                <col style="width: 25%;">
                <col style="width: 14%;">
                <col style="width: 11%;">
                <col style="width: 16%;">
              </colgroup>
              <thead>
              <tr>
                <th>Số sao</th>
                <th>Nội dung</th>
                <th>Đối tượng đánh giá</th>
                <th>Ngày tạo</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
              </tr>
              </thead>

              <tbody>
              <c:forEach items="${feedbackList}" var="feedback">
                <tr>

                  <td>
                                        <span class="rate-badge">
                                            <i class="fa-solid fa-star"></i>
                                            <fmt:formatNumber value="${feedback.rate}" maxFractionDigits="0"/>
                                        </span>
                  </td>

                  <td>
                    <div class="content-preview">
                      <c:out value="${feedback.content}"/>
                    </div>
                  </td>

                  <td>
                    <c:choose>
                      <c:when test="${feedback.serviceType == 'Tour'}">
                        <span class="service-badge service-tour">
                          <i class="fa-solid fa-map-location-dot"></i> Tour
                        </span>
                        <a class="service-name"
                           href="${pageContext.request.contextPath}/tour-detail?id=${feedback.serviceID}">
                          <c:out value="${feedback.serviceName}"/>
                        </a>
                      </c:when>
                      <c:when test="${feedback.serviceType == 'Accommodation'}">
                        <span class="service-badge service-accommodation">
                          <i class="fa-solid fa-hotel"></i> Lưu trú
                        </span>
                        <a class="service-name"
                           href="${pageContext.request.contextPath}/accommodation/detail?id=${feedback.serviceID}">
                          <c:out value="${feedback.serviceName}"/>
                        </a>
                      </c:when>
                      <c:otherwise>
                        <span class="text-muted">Không xác định</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td>
                    <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                  </td>

                  <td>
                    <c:choose>
                      <c:when test="${feedback.status == 'Visible'}">
                        <span class="status-badge status-visible">Hiển thị</span>
                      </c:when>
                      <c:otherwise>
                        <span class="status-badge status-hidden">Đã ẩn</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td>
                    <div class="action-group">
                      <a class="btn-view"
                         href="${pageContext.request.contextPath}/staff/feedback-detail?feedbackID=${feedback.feedbackID}">
                        <i class="fa-solid fa-eye"></i>
                        Xem
                      </a>

                      <c:choose>
                        <c:when test="${feedback.status == 'Hidden'}">
                          <form class="inline-form"
                                action="${pageContext.request.contextPath}/staff/feedback-status"
                                method="post">
                            <input type="hidden" name="feedbackID" value="${feedback.feedbackID}">
                            <input type="hidden" name="status" value="Visible">
                            <input type="hidden" name="redirectTo" value="list">

                            <button type="submit" class="btn-approve">
                              <i class="fa-solid fa-check"></i>
                              Duyệt
                            </button>
                          </form>
                        </c:when>

                        <c:otherwise>
                          <form class="inline-form"
                                action="${pageContext.request.contextPath}/staff/feedback-status"
                                method="post">
                            <input type="hidden" name="feedbackID" value="${feedback.feedbackID}">
                            <input type="hidden" name="status" value="Hidden">
                            <input type="hidden" name="redirectTo" value="list">

                            <button type="submit" class="btn-hide">
                              <i class="fa-solid fa-eye-slash"></i>
                              Ẩn
                            </button>
                          </form>
                        </c:otherwise>
                      </c:choose>
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
            Không có đánh giá phù hợp với bộ lọc.
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  (() => {
    const form = document.getElementById('feedbackFilterForm');
    const keywordInput = document.getElementById('feedbackKeyword');
    const serviceTypeSelect = document.getElementById('feedbackServiceType');
    const statusSelect = document.getElementById('feedbackStatus');
    const results = document.getElementById('feedbackResults');

    if (!form || !keywordInput || !serviceTypeSelect || !statusSelect || !results) {
      return;
    }

    let debounceTimer = null;
    let activeRequest = null;

    const buildFilterUrl = () => {
      const url = new URL(form.action, window.location.origin);
      const formData = new FormData(form);

      formData.forEach((value, key) => {
        const normalizedValue = String(value).trim();
        if (normalizedValue) {
          url.searchParams.set(key, normalizedValue);
        }
      });

      return url;
    };

    const loadFilteredFeedbacks = async () => {
      const url = buildFilterUrl();

      if (activeRequest) {
        activeRequest.abort();
      }

      const requestController = new AbortController();
      activeRequest = requestController;
      results.classList.add('is-loading');
      results.setAttribute('aria-busy', 'true');

      try {
        const response = await fetch(url.toString(), {
          method: 'GET',
          headers: {
            'X-Requested-With': 'XMLHttpRequest'
          },
          signal: requestController.signal
        });

        if (!response.ok) {
          throw new Error('Không thể tải danh sách đánh giá.');
        }

        const html = await response.text();
        const nextDocument = new DOMParser().parseFromString(html, 'text/html');
        const nextResults = nextDocument.getElementById('feedbackResults');

        if (!nextResults) {
          throw new Error('Không tìm thấy vùng kết quả đánh giá.');
        }

        results.innerHTML = nextResults.innerHTML;
        window.history.replaceState({}, '', url.pathname + url.search);
      } catch (error) {
        if (error.name !== 'AbortError') {
          form.submit();
        }
      } finally {
        if (activeRequest === requestController) {
          activeRequest = null;
          results.classList.remove('is-loading');
          results.removeAttribute('aria-busy');
        }
      }
    };

    keywordInput.addEventListener('input', () => {
      window.clearTimeout(debounceTimer);
      debounceTimer = window.setTimeout(loadFilteredFeedbacks, 350);
    });

    serviceTypeSelect.addEventListener('change', loadFilteredFeedbacks);
    statusSelect.addEventListener('change', loadFilteredFeedbacks);

    form.addEventListener('submit', (event) => {
      event.preventDefault();
      window.clearTimeout(debounceTimer);
      loadFilteredFeedbacks();
    });
  })();
</script>
</body>
</html>
