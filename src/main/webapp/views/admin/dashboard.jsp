<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Báo cáo tổng quan</title>
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
            font-weight: 800;
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
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 22px;
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
            white-space: nowrap;
        }

        .filter-card,
        .dashboard-card,
        .stat-card {
            border: 1px solid #e5eaf3;
            border-radius: 18px;
            background: #ffffff;
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.06);
        }

        .filter-card {
            padding: 18px;
            margin-bottom: 22px;
        }

        .filter-card label {
            color: #475569;
            font-size: 13px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .filter-card .form-control {
            min-height: 44px;
            border-radius: 12px;
            border-color: #dbe3ef;
            font-weight: 700;
        }

        .filter-submit {
            min-height: 44px;
            border: 0;
            border-radius: 12px;
            padding: 0 18px;
            background: #ef4444;
            color: #ffffff;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
        }

        .range-note {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            margin-top: 10px;
        }

        .stat-card {
            min-height: 154px;
            padding: 22px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 15px;
        }

        .icon-red {
            background: linear-gradient(135deg, #ef4444, #f97316);
        }

        .icon-blue {
            background: linear-gradient(135deg, #2563eb, #06b6d4);
        }

        .icon-green {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .icon-purple {
            background: linear-gradient(135deg, #7c3aed, #ec4899);
        }

        .stat-card h2 {
            margin: 0;
            color: #0f172a;
            font-size: 28px;
            font-weight: 900;
            letter-spacing: -0.5px;
        }

        .stat-card p {
            margin: 6px 0 0;
            color: #64748b;
            font-size: 13px;
            font-weight: 800;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.55fr) minmax(320px, 0.9fr);
            gap: 22px;
            margin-top: 22px;
        }

        .dashboard-card {
            padding: 22px;
            min-width: 0;
        }

        .card-title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 18px;
        }

        .card-title-row h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 900;
            color: #0f172a;
        }

        .card-title-row p {
            margin: 5px 0 0;
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
        }

        .chart-wrap {
            overflow-x: auto;
            padding-bottom: 6px;
        }

        .booking-value-chart {
            min-width: 720px;
            height: 320px;
            display: flex;
            align-items: flex-end;
            gap: 9px;
            padding: 18px 10px 8px;
            border-radius: 16px;
            background: repeating-linear-gradient(
                    to top,
                    #ffffff 0,
                    #ffffff 61px,
                    #edf2f7 62px
            );
        }

        .chart-column {
            flex: 1;
            min-width: 24px;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
        }

        .chart-bar-shell {
            width: 100%;
            height: 248px;
            display: flex;
            align-items: flex-end;
        }

        .chart-bar {
            width: 100%;
            border-radius: 12px 12px 5px 5px;
            background: linear-gradient(180deg, #f97316, #ef4444);
            box-shadow: 0 10px 18px rgba(239, 68, 68, 0.18);
            transition: height 0.2s ease;
        }

        .chart-label {
            color: #64748b;
            font-size: 11px;
            font-weight: 800;
            white-space: nowrap;
            transform: rotate(-36deg);
            transform-origin: top right;
            min-height: 28px;
        }

        .chart-empty {
            border: 1px dashed #cbd5e1;
            border-radius: 16px;
            padding: 18px;
            color: #64748b;
            font-weight: 800;
            margin-bottom: 14px;
            background: #f8fafc;
        }

        .breakdown-list,
        .service-list {
            display: grid;
            gap: 14px;
        }

        .metric-row {
            display: grid;
            gap: 8px;
        }

        .metric-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            color: #334155;
            font-size: 14px;
            font-weight: 900;
        }

        .metric-count {
            color: #0f172a;
            white-space: nowrap;
        }

        .metric-track {
            height: 11px;
            border-radius: 999px;
            background: #e2e8f0;
            overflow: hidden;
        }

        .metric-fill {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #f97316, #ef4444);
        }

        .secondary-fill {
            background: linear-gradient(90deg, #2563eb, #06b6d4);
        }

        .service-item {
            display: grid;
            grid-template-columns: 42px minmax(0, 1fr);
            gap: 12px;
            align-items: center;
        }

        .service-rank {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: #fff7ed;
            color: #c2410c;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
        }

        .service-name {
            color: #0f172a;
            font-size: 14px;
            font-weight: 900;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .empty-line {
            border: 1px dashed #cbd5e1;
            border-radius: 14px;
            padding: 18px;
            color: #64748b;
            font-weight: 800;
            background: #f8fafc;
        }

        @media (max-width: 1180px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 992px) {
            .admin-layout {
                display: block;
            }

            .admin-sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 24px;
            }

            .topbar {
                flex-direction: column;
            }
        }

        @media (max-width: 640px) {
            .main-content {
                padding: 18px;
            }

            .topbar h1 {
                font-size: 28px;
            }

            .stat-card {
                min-height: auto;
            }
        }
    </style>
</head>

<body>
<div class="admin-layout">
    <aside class="admin-sidebar">
        <div class="brand-box">
            <div class="brand-logo">AD</div>
            <h2>WonderVN</h2>
            <p>Trung tâm quản trị</p>
        </div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/home">
            <i class="fa-solid fa-house"></i>
            <span>Trang quản trị</span>
        </a>

        <div class="nav-section-title">Quản trị hệ thống</div>

        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-chart-line"></i>
            <span>Báo cáo tổng quan</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
            <i class="fa-solid fa-users-gear"></i>
            <span>Quản lý người dùng</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/booking">
            <i class="fa-solid fa-calendar-check"></i>
            <span>Xem Booking</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/feedback">
            <i class="fa-solid fa-comments"></i>
            <span>Xem đánh giá</span>
        </a>

        <div class="nav-section-title">Khu vực vận hành</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/home">
            <i class="fa-solid fa-user-tie"></i>
            <span>Trang nhân viên</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
            <i class="fa-solid fa-pen-to-square"></i>
            <span>Quản lý booking</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/payment">
            <i class="fa-solid fa-credit-card"></i>
            <span>Quản lý thanh toán</span>
        </a>

        <div class="admin-user">
            <div class="avatar">AD</div>
            <div>
                <div class="fw-bold">Quản trị viên</div>
                <small>Quản trị</small>
            </div>
        </div>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <div>
                <h1>Báo cáo tổng quan</h1>
                <p>Tổng hợp tình hình hoạt động của WonderVN.</p>
            </div>

            <a class="top-action-btn" href="${pageContext.request.contextPath}/admin/home">
                <i class="fa-solid fa-arrow-left"></i>
                Về trang quản trị
            </a>
        </div>

        <section class="filter-card">
            <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="row g-3 align-items-end">
                <div class="col-lg-4 col-md-5">
                    <label for="from">Từ ngày</label>
                    <input class="form-control" id="from" type="date" name="from" value="${fromDate}">
                </div>

                <div class="col-lg-4 col-md-5">
                    <label for="to">Đến ngày</label>
                    <input class="form-control" id="to" type="date" name="to" value="${toDate}">
                </div>

                <div class="col-lg-2 col-md-2">
                    <button class="filter-submit" type="submit">
                        <i class="fa-solid fa-filter"></i>
                        Áp dụng
                    </button>
                </div>

                <div class="col-lg-2">
                    <a class="top-action-btn w-100 justify-content-center" href="${pageContext.request.contextPath}/admin/dashboard">
                        Đặt lại
                    </a>
                </div>
            </form>

            <div class="range-note">
                <i class="fa-regular fa-calendar"></i>
                Dữ liệu đang xem từ ${fromDate} đến ${toDate}.
                <c:if test="${isDefaultRange}">
                    Khoảng ngày không hợp lệ hoặc chưa nhập đủ sẽ dùng mặc định 30 ngày gần nhất.
                </c:if>
            </div>
        </section>

        <section class="row g-4">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-red">
                        <i class="fa-solid fa-calendar-days"></i>
                    </div>
                    <h2><fmt:formatNumber value="${summary.totalBookings}" type="number"/></h2>
                    <p>Tổng Booking</p>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-blue">
                        <i class="fa-solid fa-file-invoice-dollar"></i>
                    </div>
                    <h2>
                        <fmt:formatNumber value="${summary.confirmedBookingValue}" type="number" maxFractionDigits="0"/> ₫
                    </h2>
                    <p>Giá trị booking xác nhận</p>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-green">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <h2><fmt:formatNumber value="${summary.completedBookings}" type="number"/></h2>
                    <p>Booking hoàn tất</p>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-purple">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>
                    <h2><fmt:formatNumber value="${summary.newCustomers}" type="number"/></h2>
                    <p>Khách hàng mới</p>
                </div>
            </div>
        </section>

        <section class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-title-row">
                    <div>
                        <h2>Giá trị booking xác nhận theo ngày</h2>
                        <p>Chỉ tính booking có trạng thái Đã xác nhận hoặc Hoàn tất.</p>
                    </div>
                </div>

                <c:if test="${!hasTrendValue}">
                    <div class="chart-empty">
                        Chưa có booking xác nhận trong khoảng thời gian đã chọn.
                    </div>
                </c:if>

                <div class="chart-wrap">
                    <div class="booking-value-chart" aria-label="Giá trị booking xác nhận theo ngày">
                        <c:forEach items="${bookingValueTrend}" var="point">
                            <div class="chart-column"
                                 title="${point.displayDate}: ${point.totalValue}">
                                <div class="chart-bar-shell">
                                    <div class="chart-bar" style="height: ${point.barPercent}%;"></div>
                                </div>
                                <div class="chart-label">${point.displayDate}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="dashboard-card">
                <div class="card-title-row">
                    <div>
                        <h2>Booking theo trạng thái</h2>
                        <p>Đếm theo ngày tạo booking.</p>
                    </div>
                </div>

                <div class="breakdown-list">
                    <c:forEach items="${bookingStatusStats}" var="stat">
                        <div class="metric-row">
                            <div class="metric-head">
                                <span>${stat.displayStatus}</span>
                                <span class="metric-count">
                                    <fmt:formatNumber value="${stat.count}" type="number"/>
                                </span>
                            </div>
                            <div class="metric-track">
                                <div class="metric-fill" style="width: ${stat.percentage}%;"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <section class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-title-row">
                    <div>
                        <h2>Booking theo loại</h2>
                        <p>Phân nhóm theo Tour và Lưu trú.</p>
                    </div>
                </div>

                <div class="breakdown-list">
                    <c:forEach items="${bookingTypeStats}" var="stat">
                        <div class="metric-row">
                            <div class="metric-head">
                                <span>${stat.displayType}</span>
                                <span class="metric-count">
                                    <fmt:formatNumber value="${stat.count}" type="number"/>
                                </span>
                            </div>
                            <div class="metric-track">
                                <div class="metric-fill secondary-fill" style="width: ${stat.percentage}%;"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="dashboard-card">
                <div class="card-title-row">
                    <div>
                        <h2>Ghi chú dữ liệu</h2>
                        <p>Dashboard MVP hiện chỉ đọc từ Booking và User.</p>
                    </div>
                </div>

                <div class="empty-line">
                    Giá trị booking xác nhận không phải số tiền đã thu thực tế. Quy trình thanh toán chưa hoàn chỉnh nên chưa dùng bảng thanh toán để tính tiền đã thu.
                </div>
            </div>
        </section>

        <section class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-title-row">
                    <div>
                        <h2>Tour được đặt nhiều</h2>
                        <p>Top 5 theo số booking đã xác nhận hoặc hoàn tất.</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty topTours}">
                        <div class="empty-line">Chưa có Tour phù hợp trong khoảng thời gian đã chọn.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="service-list">
                            <c:forEach items="${topTours}" var="item" varStatus="loop">
                                <div class="service-item">
                                    <div class="service-rank">${loop.index + 1}</div>
                                    <div class="metric-row">
                                        <div class="metric-head">
                                            <span class="service-name"><c:out value="${item.serviceName}"/></span>
                                            <span class="metric-count">
                                                <fmt:formatNumber value="${item.bookingCount}" type="number"/> booking
                                            </span>
                                        </div>
                                        <div class="metric-track">
                                            <div class="metric-fill" style="width: ${item.percentage}%;"></div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dashboard-card">
                <div class="card-title-row">
                    <div>
                        <h2>Nơi lưu trú được đặt nhiều</h2>
                        <p>Top 5 theo số booking đã xác nhận hoặc hoàn tất.</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty topAccommodations}">
                        <div class="empty-line">Chưa có nơi lưu trú phù hợp trong khoảng thời gian đã chọn.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="service-list">
                            <c:forEach items="${topAccommodations}" var="item" varStatus="loop">
                                <div class="service-item">
                                    <div class="service-rank">${loop.index + 1}</div>
                                    <div class="metric-row">
                                        <div class="metric-head">
                                            <span class="service-name"><c:out value="${item.serviceName}"/></span>
                                            <span class="metric-count">
                                                <fmt:formatNumber value="${item.bookingCount}" type="number"/> booking
                                            </span>
                                        </div>
                                        <div class="metric-track">
                                            <div class="metric-fill secondary-fill" style="width: ${item.percentage}%;"></div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
</div>
</body>
</html>
