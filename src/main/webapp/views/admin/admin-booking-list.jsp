<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Quản lý Booking</title>
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
    .sidebar-link.active { background: linear-gradient(135deg, #f97316, #ea580c); color: #ffffff; box-shadow: 0 10px 22px rgba(234, 88, 12, 0.22); }

    .admin-user { margin-top: 26px; border-top: 1px solid rgba(148, 163, 184, 0.25); padding: 18px 8px 4px; display: flex; align-items: center; gap: 12px; }
    .avatar { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg, #f97316, #22c55e); display: flex; align-items: center; justify-content: center; font-weight: 800; color: white; }
    .admin-user small { color: #94a3b8; }

    .main-content { margin-left: 292px; width: calc(100% - 292px); padding: 34px 42px; }

    .topbar { display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 26px; }
    .topbar h1 { font-size: 34px; font-weight: 900; margin: 0; letter-spacing: -0.8px; }
    .topbar p { color: #64748b; margin: 6px 0 0; font-size: 15px; }

    .top-action-btn { border: none; border-radius: 16px; padding: 12px 18px; text-decoration: none; font-weight: 900; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08); background: #0f172a; color: #ffffff; }
    .top-action-btn:hover { background: #1e293b; color: #ffffff; }

    .summary-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 18px; margin-bottom: 22px; }
    .summary-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 22px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06); padding: 20px; display: flex; align-items: center; gap: 14px; }
    .summary-icon { width: 48px; height: 48px; border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 20px; }
    .summary-label { color: #64748b; font-size: 13px; font-weight: 800; margin-bottom: 3px; }
    .summary-value { color: #0f172a; font-size: 26px; font-weight: 900; line-height: 1; }

    .content-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 24px; padding: 24px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08); }
    .table { margin-bottom: 0; }
    .table thead th { background: #f8fafc; color: #334155; font-size: 14px; font-weight: 900; border-bottom: 1px solid #e2e8f0; padding: 16px 14px; white-space: nowrap; }
    .table tbody td { padding: 15px 14px; vertical-align: middle; color: #0f172a; font-size: 14px; }

    .booking-id { font-weight: 900; color: #ea580c; }

    .status-badge { display: inline-flex; align-items: center; justify-content: center; padding: 6px 12px; border-radius: 999px; font-size: 13px; font-weight: 900; }
    .status-pending { background: #fef3c7; color: #92400e; }
    .status-confirmed { background: #e0f2fe; color: #0369a1; }
    .status-completed { background: #dcfce7; color: #166534; }
    .status-cancelled { background: #fee2e2; color: #991b1b; }
    .status-ended { background: #ede9fe; color: #6d28d9; }

    .btn-view { display: inline-flex; align-items: center; justify-content: center; gap: 7px; padding: 9px 14px; border-radius: 999px; background: #ea580c; color: #ffffff; text-decoration: none; font-size: 13px; font-weight: 900; white-space: nowrap; }
    .btn-view:hover { background: #c2410c; color: #ffffff; }

    .empty-box { background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 18px; padding: 40px; text-align: center; color: #64748b; font-weight: 800; }

    .toolbar {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 22px;
      padding: 18px;
      box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
      margin-bottom: 22px;
      display: grid;
      grid-template-columns: 1fr 220px 220px 120px;
      gap: 14px;
      align-items: center;
    }

    .toolbar .form-control,
    .toolbar .form-select {
      border-radius: 13px;
      border: 1px solid #dbe3ef;
      min-height: 46px;
      font-weight: 600;
    }

    @media (max-width: 1200px) {
      .toolbar { grid-template-columns: 1fr 1fr; }
    }

    @media (max-width: 768px) {
      .toolbar { grid-template-columns: 1fr; }
    }

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

  <jsp:include page="/views/common/admin-sidebar.jsp">
    <jsp:param name="activeAdminMenu" value="booking"/>
    <jsp:param name="sidebarClass" value="sidebar"/>
  </jsp:include>
  <main class="main-content">

    <div class="topbar">
      <div>
        <h1>Quản lý Booking</h1>
      </div>

      <a class="top-action-btn" href="${pageContext.request.contextPath}/admin/home">
        <i class="fa-solid fa-arrow-left"></i>
        Về trang chủ quản trị
      </a>
    </div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon" style="background: #fffbeb; color: #d97706;">
          <i class="fa-solid fa-clock"></i>
        </div>
        <div>
          <div class="summary-label">Đang thanh toán</div>
          <div class="summary-value">${pendingCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon" style="background: #dcfce7; color: #166534;">
          <i class="fa-solid fa-circle-check"></i>
        </div>
        <div>
          <div class="summary-label">Thanh toán thành công</div>
          <div class="summary-value">${completedCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon" style="background: #fee2e2; color: #991b1b;">
          <i class="fa-solid fa-xmark"></i>
        </div>
        <div>
          <div class="summary-label">Đã hủy</div>
          <div class="summary-value">${cancelledCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon" style="background: #ede9fe; color: #6d28d9;">
          <i class="fa-solid fa-flag-checkered"></i>
        </div>
        <div>
          <div class="summary-label">Tour kết thúc</div>
          <div class="summary-value">${endedCount}</div>
        </div>
      </div>
    </div>

    <form class="toolbar" method="get" action="${pageContext.request.contextPath}/admin/booking">
      <input class="form-control" id="bookingSearchInput" type="text" placeholder="Tìm tên, SĐT, email, mã booking...">

      <select class="form-select" name="type" id="typeFilter">
        <option value="">Tất cả loại booking</option>
        <option value="Tour" ${param.type == 'Tour' ? 'selected' : ''}>Tour</option>
        <option value="Accommodation" ${param.type == 'Accommodation' ? 'selected' : ''}>Lưu trú</option>
      </select>

      <select class="form-select" name="status" id="statusFilter">
        <option value="">Tất cả trạng thái</option>
        <option value="Đang thanh toán" ${param.status == 'Đang thanh toán' ? 'selected' : ''}>Đang thanh toán</option>
        <option value="Thanh toán thành công" ${param.status == 'Thanh toán thành công' ? 'selected' : ''}>Thanh toán thành công</option>
        <option value="Đã hủy" ${param.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
        <option value="Tour kết thúc" ${param.status == 'Tour kết thúc' ? 'selected' : ''}>Tour kết thúc</option>
      </select>

      <button class="btn btn-outline-secondary fw-bold" type="submit">
        <i class="fa-solid fa-filter me-1"></i> Lọc
      </button>
    </form>

    <div class="content-card">

      <c:choose>
        <c:when test="${not empty bookingList}">
          <div class="table-responsive">
            <table class="table align-middle" id="bookingTable">
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
                <tr data-status="${booking.displayStatus}"
                    data-type="${booking.bookingType}"
                    data-search-content="${booking.bookingCode} ${booking.firstName} ${booking.lastName} ${booking.email} ${booking.phone} ${booking.serviceName}">
                  <td>
                    <span class="booking-id">#${booking.bookingCode}</span>
                  </td>

                  <td class="fw-bold">${booking.firstName} ${booking.lastName}</td>

                  <td>
                                            <span class="badge ${booking.bookingType == 'Tour' ? 'bg-info text-dark' : 'bg-success'}">
                                                ${booking.bookingType == 'Tour' ? 'Tour' : 'Lưu trú'}
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
                      <c:when test="${booking.displayStatus == 'Đang thanh toán'}">
                        <span class="status-badge status-pending">Đang thanh toán</span>
                      </c:when>
                      <c:when test="${booking.displayStatus == 'Thanh toán thành công'}">
                        <span class="status-badge status-completed">Thanh toán thành công</span>
                      </c:when>
                      <c:when test="${booking.displayStatus == 'Đã hủy'}">
                        <span class="status-badge status-cancelled">Đã hủy</span>
                      </c:when>
                      <c:when test="${booking.displayStatus == 'Tour kết thúc'}">
                        <span class="status-badge status-ended">Tour kết thúc</span>
                      </c:when>
                      <c:otherwise>
                        <span class="status-badge bg-secondary">${booking.displayStatus}</span>
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
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("bookingSearchInput");
    const statusFilter = document.getElementById("statusFilter");
    const typeFilter = document.getElementById("typeFilter");
    const rows = Array.from(document.querySelectorAll("#bookingTable tbody tr"));

    function normalize(value) {
      return (value || "").toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim();
    }

    function filterRows() {
      const keyword = normalize(searchInput ? searchInput.value : "");
      const status = statusFilter ? statusFilter.value : "";
      const type = typeFilter ? typeFilter.value : "";

      rows.forEach(function (row) {
        const matchesKeyword = normalize(row.dataset.searchContent).includes(keyword);
        const matchesStatus = !status || normalize(row.dataset.status) === normalize(status);
        const matchesType = !type || normalize(row.dataset.type) === normalize(type);
        row.style.display = matchesKeyword && matchesStatus && matchesType ? "" : "none";
      });
    }

    if (searchInput) {
      searchInput.addEventListener("input", filterRows);
    }

    if (statusFilter) {
      statusFilter.addEventListener("change", filterRows);
    }

    if (typeFilter) {
      typeFilter.addEventListener("change", filterRows);
    }
  });
</script>
</body>
</html>
