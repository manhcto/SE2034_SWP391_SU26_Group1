<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>WonderVN | Quản lý đặt chỗ (Staff)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <style>
    * { box-sizing: border-box; }

    body {
      margin: 0;
      background: #f4f7fb;
      font-family: 'Be Vietnam Pro', Arial, sans-serif;
      color: #0f172a;
    }

    .admin-layout { display: flex; min-height: 100vh; }

    /* ================= SIDEBAR TỪ HOME ================= */
    .sidebar {
      width: 292px;
      background: #0f172a;
      color: white;
      position: fixed;
      inset: 0 auto 0 0;
      overflow-y: auto;
      padding: 26px 18px;
      box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18);
    }
    .sidebar::-webkit-scrollbar { width: 7px; }
    .sidebar::-webkit-scrollbar-thumb { background: #334155; border-radius: 20px; }

    .brand-box { padding: 8px 10px 22px; margin-bottom: 12px; border-bottom: 1px solid rgba(148, 163, 184, 0.25); }
    .brand-logo {
      width: 52px; height: 52px; border-radius: 18px;
      background: linear-gradient(135deg, #06b6d4, #4e46dc); /* Màu Xanh theo theme */
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; font-size: 20px; margin-bottom: 12px;
    }
    .brand-box h2 { font-size: 26px; font-weight: 800; margin: 0; letter-spacing: -0.6px; }
    .brand-box p { color: #cbd5e1; margin: 5px 0 0; font-size: 14px; }

    .nav-section-title { font-size: 11px; text-transform: uppercase; color: #94a3b8; letter-spacing: 1.2px; margin: 22px 12px 10px; font-weight: 800; }

    .sidebar-link {
      display: flex; align-items: center; gap: 12px; padding: 13px 14px; border-radius: 15px;
      color: #e2e8f0; text-decoration: none; font-size: 14px; font-weight: 700;
      margin-bottom: 8px; transition: all 0.2s ease;
    }
    .sidebar-link i { width: 22px; text-align: center; font-size: 16px; }
    .sidebar-link:hover { background: #1e293b; color: white; transform: translateX(4px); }
    .sidebar-link.active {
      background: linear-gradient(135deg, #06b6d4, #4e46dc); /* Màu Xanh đang chọn */
      color: white; box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22);
    }

    .admin-user { margin-top: 26px; border-top: 1px solid rgba(148, 163, 184, 0.25); padding: 18px 8px 4px; display: flex; align-items: center; gap: 12px; }
    .avatar { width: 46px; height: 46px; border-radius: 50%; background: linear-gradient(135deg, #06b6d4, #22c55e); display: flex; align-items: center; justify-content: center; font-weight: 800; color: white; }
    .admin-user small { color: #94a3b8; }

    /* ================= MAIN CONTENT ================= */
    .main-content { margin-left: 292px; width: calc(100% - 292px); padding: 34px 42px; }

    .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 26px; }
    .topbar h1 { font-size: 32px; font-weight: 800; margin: 0; letter-spacing: -0.8px; }
    .topbar p { color: #64748b; margin: 6px 0 0; font-size: 15px; }

    .top-action-btn {
      border: none; border-radius: 16px; padding: 12px 18px; text-decoration: none; font-weight: 800;
      display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08); background: #0f172a; color: white;
    }

    /* STATS CARDS */
    .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 18px; margin-bottom: 22px; }
    .summary-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 22px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06); padding: 20px; display: flex; align-items: center; gap: 14px; }
    .summary-icon { width: 48px; height: 48px; border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 20px; }
    .summary-label { color: #64748b; font-size: 13px; font-weight: 800; margin-bottom: 3px; text-transform: uppercase; }
    .summary-value { color: #0f172a; font-size: 26px; font-weight: 900; line-height: 1; }

    .icon-active { background: #fffbeb; color: #d97706; }
    .icon-completed { background: #dcfce7; color: #166534; }
    .icon-cancelled { background: #fee2e2; color: #991b1b; }

    /* BẢNG & CARD NỘI DUNG */
    .content-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 24px; padding: 24px; box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08); }

    .table { margin-bottom: 0; }
    .table thead th { background: #f8fafc; color: #334155; font-size: 14px; font-weight: 900; border-bottom: 1px solid #e2e8f0; padding: 16px 14px; white-space: nowrap; }
    .table tbody td { padding: 15px 14px; vertical-align: middle; color: #0f172a; font-size: 14px; }

    .booking-id { font-weight: 900; color: #4e46dc; } /* Màu ID Xanh */

    .status-badge { display: inline-flex; align-items: center; justify-content: center; padding: 6px 12px; border-radius: 999px; font-size: 13px; font-weight: 900; white-space: nowrap; }
    .status-pending { background: #fef3c7; color: #92400e; }
    .status-confirmed { background: #e0f2fe; color: #0369a1; }
    .status-completed { background: #dcfce7; color: #166534; }
    .status-cancelled { background: #fee2e2; color: #991b1b; }

    /* 3 Nút Thao Tác (Xem, Hoàn thành, Hủy) */
    .action-group { display: flex; gap: 8px; align-items: center; }
    .btn-action { display: inline-flex; align-items: center; justify-content: center; gap: 7px; padding: 9px 14px; border-radius: 999px; text-decoration: none; font-size: 13px; font-weight: 900; white-space: nowrap; border: none; cursor: pointer; transition: 0.2s; }
    .btn-view { background: #4e46dc; color: #ffffff; }
    .btn-view:hover { background: #3730a3; color: #ffffff; }
    .btn-complete { background: #10b981; color: #ffffff; }
    .btn-complete:hover { background: #059669; color: #ffffff; }
    .btn-cancel { background: #ef4444; color: #ffffff; }
    .btn-cancel:hover { background: #dc2626; color: #ffffff; }

    .form-inline { display: inline; margin: 0; }

    /* Nút Lọc Xanh */
    .btn-blue { background-color: #4e46dc; color: #fff; border: 1px solid #4e46dc; }
    .btn-blue:hover { background-color: #4e46dc; color: #fff; border-color: #4e46dc; }
    .btn-outline-blue { color: #4e46dc; border: 1px solid #4e46dc; background-color: transparent; }
    .btn-outline-blue:hover { background-color: #4e46dc; color: #fff; }

    .empty-box { background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 18px; padding: 40px; text-align: center; color: #64748b; font-weight: 800; }

    /* Thanh Tìm Kiếm */
    .search-wrapper { position: relative; max-width: 300px; margin-left: auto; }
    .search-wrapper i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
    .search-wrapper input { width: 100%; padding: 10px 14px 10px 38px; border-radius: 20px; border: 1px solid #e2e8f0; outline: none; font-size: 14px; transition: 0.2s; }
    .search-wrapper input:focus { border-color: #4e46dc; box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1); }
  </style>
</head>

<body>
<div class="admin-layout">

  <aside class="sidebar">
    <div class="brand-box">
      <div class="brand-logo">WV</div>
      <h2>WonderVN</h2>
      <p>Staff Portal</p>
    </div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
      <i class="fa-solid fa-house"></i>
      <span>Trang chủ Staff</span>
    </a>

    <div class="nav-section-title">Nghiệp vụ du lịch</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/tour">
      <i class="fa-solid fa-route"></i>
      <span>Quản lý Tour</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
      <i class="fa-solid fa-hotel"></i>
      <span>Quản lý lưu trú</span>
    </a>

    <a class="sidebar-link active" href="${pageContext.request.contextPath}/staff/booking">
      <i class="fa-solid fa-calendar-check"></i>
      <span>Quản lý Đặt chỗ</span>
    </a>

    <div class="nav-section-title">Chăm sóc khách hàng</div>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
      <i class="fa-solid fa-comments"></i>
      <span>Đánh giá khách hàng</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/voucher">
      <i class="fa-solid fa-ticket"></i>
      <span>Quản lý Voucher</span>
    </a>

    <div class="nav-section-title">Hệ thống</div>

    <a class="sidebar-link text-danger mt-2" href="${pageContext.request.contextPath}/auth/logout" style="color: #ef4444 !important;">
      <i class="fa-solid fa-right-from-bracket"></i>
      <span>Đăng xuất</span>
    </a>

    <div class="admin-user">
      <div class="avatar">ST</div>
      <div>
        <div class="fw-bold">Nhân viên Booking</div>
        <small>Staff Account</small>
      </div>
    </div>
  </aside>

  <c:set var="activeCount" value="0" />
  <c:set var="completedCount" value="0" />
  <c:set var="cancelledCount" value="0" />
  <c:forEach var="bk" items="${bookingList}">
    <c:choose>
      <c:when test="${bk.status == 'Pending' || bk.status == 'Confirmed'}">
        <c:set var="activeCount" value="${activeCount + 1}" />
      </c:when>
      <c:when test="${bk.status == 'Completed'}">
        <c:set var="completedCount" value="${completedCount + 1}" />
      </c:when>
      <c:when test="${bk.status == 'Cancelled'}">
        <c:set var="cancelledCount" value="${cancelledCount + 1}" />
      </c:when>
    </c:choose>
  </c:forEach>

  <main class="main-content">

    <div class="topbar">
      <div>
        <h1>Quản lý Đặt chỗ</h1>
        <p>Theo dõi và xử lý trạng thái các đơn đặt tour, phòng khách sạn.</p>
      </div>
    </div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-icon icon-active"><i class="fa-solid fa-spinner"></i></div>
        <div>
          <div class="summary-label">Đang hoạt động</div>
          <div class="summary-value">${activeCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon icon-completed"><i class="fa-solid fa-check-double"></i></div>
        <div>
          <div class="summary-label">Đã hoàn thành</div>
          <div class="summary-value">${completedCount}</div>
        </div>
      </div>

      <div class="summary-card">
        <div class="summary-icon icon-cancelled"><i class="fa-solid fa-ban"></i></div>
        <div>
          <div class="summary-label">Đã hủy</div>
          <div class="summary-value">${cancelledCount}</div>
        </div>
      </div>
    </div>

    <div class="content-card">

      <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="d-flex gap-3">
          <a href="?type=" class="btn ${empty param.type or param.type == 'all' ? 'btn-blue' : 'btn-outline-blue'} rounded-pill px-4 fw-bold">Tất cả</a>
          <a href="?type=Tour" class="btn ${param.type == 'Tour' ? 'btn-blue' : 'btn-outline-blue'} rounded-pill px-4 fw-bold">
            <i class="fa-solid fa-route me-1"></i> Tour
          </a>
          <a href="?type=Accommodation" class="btn ${param.type == 'Accommodation' ? 'btn-blue' : 'btn-outline-blue'} rounded-pill px-4 fw-bold">
            <i class="fa-solid fa-hotel me-1"></i> Khách sạn
          </a>
        </div>

        <div class="search-wrapper">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="bookingSearchInput" placeholder="Tìm tên, SĐT, mã đơn...">
        </div>
      </div>

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
                <tr data-search-content="${booking.bookingCode} ${booking.email} ${booking.phone} ${booking.firstName} ${booking.lastName}">
                  <td>
                    <span class="booking-id">#${booking.bookingCode}</span>
                  </td>

                  <td>
                    <div class="fw-bold">${booking.firstName} ${booking.lastName}</div>
                    <div class="text-secondary" style="font-size: 13px;">${booking.phone}</div>
                  </td>

                  <td>
                                            <span class="badge ${booking.bookingType == 'Tour' ? 'bg-info text-dark' : 'bg-success'}">
                                                ${booking.bookingType == 'Tour' ? 'Tour' : 'Khách sạn'}
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
                        <span class="status-badge status-completed">Hoàn thành</span>
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
                    <div class="action-group">
                      <a class="btn-action btn-view" href="${pageContext.request.contextPath}/staff/booking-detail?bookingID=${booking.bookingID}">
                        <i class="fa-solid fa-eye"></i> Xem
                      </a>

                      <c:if test="${booking.status == 'Pending' || booking.status == 'Confirmed'}">

                        <form action="${pageContext.request.contextPath}/staff/booking-status" method="POST" class="form-inline" onsubmit="return confirm('Xác nhận ĐÃ HOÀN THÀNH đơn này?');">
                          <input type="hidden" name="bookingID" value="${booking.bookingID}">
                          <input type="hidden" name="status" value="Completed">
                          <input type="hidden" name="type" value="${param.type}">
                          <button type="submit" class="btn-action btn-complete">
                            <i class="fa-solid fa-check"></i>
                          </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/staff/booking-status" method="POST" class="form-inline" onsubmit="return confirm('Bạn có chắc chắn muốn HỦY đơn này?');">
                          <input type="hidden" name="bookingID" value="${booking.bookingID}">
                          <input type="hidden" name="status" value="Cancelled">
                          <input type="hidden" name="type" value="${param.type}">
                          <button type="submit" class="btn-action btn-cancel">
                            <i class="fa-solid fa-xmark"></i>
                          </button>
                        </form>

                      </c:if>
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

    if (searchInput) {
      searchInput.addEventListener("input", function() {
        const keyword = this.value.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim();
        const rows = document.querySelectorAll("#bookingTable tbody tr");

        rows.forEach(row => {
          const content = (row.dataset.searchContent || "").toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
          if (content.includes(keyword)) {
            row.style.display = "";
          } else {
            row.style.display = "none";
          }
        });
      });
    }
  });
</script>
</body>
</html>