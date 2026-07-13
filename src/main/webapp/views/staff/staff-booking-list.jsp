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

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --dark: #0f172a;
            --text: #1e293b;
            --muted: #64748b;
            --bg: #f3f6fb;
            --soft: #f8fafc;
            --border: #e2e8f0;
            --success: #16a34a;
            --danger: #dc2626;
            --warning: #f59e0b;
            --shadow: 0 16px 36px rgba(15, 23, 42, 0.08);
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            min-width: 0;
            padding: 28px;
        }

        .staff-page-topbar {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 22px 24px;
            box-shadow: var(--shadow);
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .staff-page-topbar h1 {
            margin: 0;
            color: var(--dark);
            font-size: 28px;
            font-weight: 900;
            letter-spacing: -0.4px;
        }

        .staff-page-topbar p {
            margin: 6px 0 0;
            color: var(--muted);
            font-weight: 600;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }

        .stat-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 20px;
            box-shadow: var(--shadow);
        }

        .stat-card .label {
            color: var(--muted);
            font-weight: 800;
            margin-bottom: 8px;
        }

        .stat-card .value {
            font-size: 30px;
            font-weight: 900;
            color: var(--dark);
        }

        .toolbar {
            background: white;
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 18px;
            box-shadow: var(--shadow);
            margin-bottom: 22px;
            display: grid;
            grid-template-columns: 1fr 220px 220px 120px;
            gap: 14px;
            align-items: center;
        }

        .form-control,
        .form-select {
            border-radius: 13px;
            border: 1px solid #dbe3ef;
            min-height: 46px;
            font-weight: 600;
        }

        .table-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: 24px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table {
            margin: 0;
            vertical-align: middle;
        }

        .table thead th {
            background: var(--soft);
            color: #475569;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border-bottom: 1px solid var(--border);
            padding: 15px;
            white-space: nowrap;
        }

        .table tbody td {
            padding: 15px;
            border-bottom: 1px solid #eef2f7;
        }

        .booking-code {
            color: var(--primary);
            font-weight: 900;
        }

        .type-pill,
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 999px;
            padding: 7px 11px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .type-tour {
            background: #e0f2fe;
            color: #0369a1;
        }

        .type-accommodation {
            background: #dcfce7;
            color: #166534;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-completed {
            background: #dcfce7;
            color: #166534;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .icon-btn {
            width: 36px;
            height: 36px;
            border: 1px solid #dbe3ef;
            border-radius: 10px;
            background: white;
            color: #0f172a;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            cursor: pointer;
        }

        .icon-btn:hover {
            background: #eff6ff;
            color: var(--primary);
            border-color: #bfdbfe;
        }

        .icon-btn.primary {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .icon-btn.success {
            background: var(--success);
            color: white;
            border-color: var(--success);
        }

        .icon-btn.warning {
            background: var(--warning);
            color: white;
            border-color: var(--warning);
        }

        .icon-btn.danger {
            background: var(--danger);
            color: white;
            border-color: var(--danger);
        }

        .inline-form {
            display: inline-flex;
            margin: 0;
        }

        .empty-box {
            padding: 44px 24px;
            text-align: center;
            color: var(--muted);
            font-weight: 800;
        }

        @media (max-width: 1200px) {
            .toolbar {
                grid-template-columns: 1fr 1fr;
            }

            .stat-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .admin-layout {
                display: block;
            }

            .admin-main {
                padding: 18px;
            }

            .toolbar,
            .stat-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="admin-layout">
    <jsp:include page="/views/common/staff-sidebar.jsp"/>

    <c:set var="pendingCount" value="0"/>
    <c:set var="confirmedCount" value="0"/>
    <c:set var="completedCount" value="0"/>
    <c:set var="cancelledCount" value="0"/>

    <c:forEach var="bk" items="${bookingList}">
        <c:choose>
            <c:when test="${bk.status == 'Đang xử lý' || bk.status == 'Pending'}">
                <c:set var="pendingCount" value="${pendingCount + 1}"/>
            </c:when>
            <c:when test="${bk.status == 'Đã duyệt' || bk.status == 'Confirmed'}">
                <c:set var="confirmedCount" value="${confirmedCount + 1}"/>
            </c:when>
            <c:when test="${bk.status == 'Hoàn thành' || bk.status == 'Completed'}">
                <c:set var="completedCount" value="${completedCount + 1}"/>
            </c:when>
            <c:when test="${bk.status == 'Đã hủy' || bk.status == 'Cancelled'}">
                <c:set var="cancelledCount" value="${cancelledCount + 1}"/>
            </c:when>
        </c:choose>
    </c:forEach>

    <main class="admin-main">
        <div class="staff-page-topbar">
            <div>
                <h1>Quản lý Booking</h1>
                <p>Theo dõi và duyệt trạng thái booking tour, booking lưu trú.</p>
            </div>
        </div>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="label">Đang xử lý</div>
                <div class="value">${pendingCount}</div>
            </div>
            <div class="stat-card">
                <div class="label">Đã duyệt</div>
                <div class="value">${confirmedCount}</div>
            </div>
            <div class="stat-card">
                <div class="label">Hoàn thành</div>
                <div class="value">${completedCount}</div>
            </div>
            <div class="stat-card">
                <div class="label">Đã hủy</div>
                <div class="value">${cancelledCount}</div>
            </div>
        </div>

        <form class="toolbar" method="get" action="${pageContext.request.contextPath}/staff/booking">
            <input class="form-control" id="bookingSearchInput" type="text" placeholder="Tìm tên, SĐT, email, mã booking...">

            <select class="form-select" name="type">
                <option value="">Tất cả loại booking</option>
                <option value="Tour" ${param.type == 'Tour' ? 'selected' : ''}>Tour</option>
                <option value="Accommodation" ${param.type == 'Accommodation' ? 'selected' : ''}>Lưu trú</option>
            </select>

            <select class="form-select" id="statusFilter">
                <option value="">Tất cả trạng thái</option>
                <option value="Đang xử lý">Đang xử lý</option>
                <option value="Đã duyệt">Đã duyệt</option>
                <option value="Hoàn thành">Hoàn thành</option>
                <option value="Đã hủy">Đã hủy</option>
            </select>

            <button class="btn btn-outline-secondary fw-bold" type="submit">
                <i class="fa-solid fa-filter me-1"></i> Lọc
            </button>
        </form>

        <div class="table-card">
            <c:choose>
                <c:when test="${empty bookingList}">
                    <div class="empty-box">Chưa có booking nào.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table" id="bookingTable">
                            <thead>
                            <tr>
                                <th>Mã booking</th>
                                <th>Khách hàng</th>
                                <th>Dịch vụ</th>
                                <th>Ngày đặt</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${bookingList}" var="booking">
                                <tr data-status="${booking.displayStatus}"
                                    data-search-content="${booking.bookingCode} ${booking.firstName} ${booking.lastName} ${booking.email} ${booking.phone} ${booking.serviceName}">
                                    <td>
                                        <span class="booking-code">${booking.bookingCode}</span>
                                    </td>
                                    <td>
                                        <strong>${booking.firstName} ${booking.lastName}</strong>
                                        <div class="text-muted small">${booking.phone}</div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.bookingType == 'Tour'}">
                                                <span class="type-pill type-tour"><i class="fa-solid fa-route"></i> Tour</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="type-pill type-accommodation"><i class="fa-solid fa-hotel"></i> Lưu trú</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="text-muted small mt-1">${booking.serviceName}</div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="text-danger fw-bold">
                                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.status == 'Đang xử lý' || booking.status == 'Pending'}">
                                                <span class="status-pill status-pending">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'Đã duyệt' || booking.status == 'Confirmed'}">
                                                <span class="status-pill status-confirmed">Đã duyệt</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'Hoàn thành' || booking.status == 'Completed'}">
                                                <span class="status-pill status-completed">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'Đã hủy' || booking.status == 'Cancelled'}">
                                                <span class="status-pill status-cancelled">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pill">${booking.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a class="icon-btn" title="Xem chi tiết"
                                               href="${pageContext.request.contextPath}/staff/booking-detail?bookingID=${booking.bookingID}">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>

                                            <c:if test="${booking.status != 'Đang xử lý' && booking.status != 'Pending'}">
                                                <form class="inline-form" action="${pageContext.request.contextPath}/staff/booking-status" method="post">
                                                    <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                    <input type="hidden" name="status" value="Đang xử lý">
                                                    <input type="hidden" name="type" value="${param.type}">
                                                    <button class="icon-btn warning" type="submit" title="Chuyển về đang xử lý">
                                                        <i class="fa-solid fa-clock"></i>
                                                    </button>
                                                </form>
                                            </c:if>

                                            <c:if test="${booking.status != 'Đã duyệt' && booking.status != 'Confirmed'}">
                                                <form class="inline-form" action="${pageContext.request.contextPath}/staff/booking-status" method="post">
                                                    <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                    <input type="hidden" name="status" value="Đã duyệt">
                                                    <input type="hidden" name="type" value="${param.type}">
                                                    <button class="icon-btn success" type="submit" title="Duyệt booking">
                                                        <i class="fa-solid fa-check"></i>
                                                    </button>
                                                </form>
                                            </c:if>

                                            <c:if test="${booking.status != 'Đã hủy' && booking.status != 'Cancelled'}">
                                                <form class="inline-form" action="${pageContext.request.contextPath}/staff/booking-status" method="post"
                                                      onsubmit="return confirm('Bạn chắc chắn muốn hủy booking này?');">
                                                    <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                    <input type="hidden" name="status" value="Đã hủy">
                                                    <input type="hidden" name="type" value="${param.type}">
                                                    <button class="icon-btn danger" type="submit" title="Hủy booking">
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
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("bookingSearchInput");
        const statusFilter = document.getElementById("statusFilter");
        const rows = Array.from(document.querySelectorAll("#bookingTable tbody tr"));

        function normalize(value) {
            return (value || "").toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim();
        }

        function filterRows() {
            const keyword = normalize(searchInput ? searchInput.value : "");
            const status = statusFilter ? statusFilter.value : "";

            rows.forEach(function (row) {
                const matchesKeyword = normalize(row.dataset.searchContent).includes(keyword);
                const matchesStatus = !status || row.dataset.status === status;
                row.style.display = matchesKeyword && matchesStatus ? "" : "none";
            });
        }

        if (searchInput) {
            searchInput.addEventListener("input", filterRows);
        }

        if (statusFilter) {
            statusFilter.addEventListener("change", filterRows);
        }
    });
</script>
</body>
</html>
