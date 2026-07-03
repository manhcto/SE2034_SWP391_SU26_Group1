<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Admin Feedback View</title>
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
            color: #ffffff;
            transform: translateX(4px);
        }

        .sidebar-link.active {
            background: linear-gradient(135deg, #06b6d4, #4e46dc);
            color: #ffffff;
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

        .content-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: #f8fafc;
            color: #334155;
            font-size: 14px;
            font-weight: 900;
            border-bottom: 1px solid #e2e8f0;
            padding: 16px 14px;
            white-space: nowrap;
        }

        .table tbody td {
            padding: 15px 14px;
            vertical-align: middle;
            color: #0f172a;
            font-size: 14px;
        }

        .feedback-id {
            font-weight: 900;
            color: #4e46dc;
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
            max-width: 360px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #475569;
            font-weight: 600;
        }

        .btn-view {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #4e46dc;
            color: #ffffff;
            text-decoration: none;
            font-size: 13px;
            font-weight: 900;
            white-space: nowrap;
        }

        .btn-view:hover {
            background: #3730a3;
            color: #ffffff;
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

        <div class="nav-section-title">Vận hành</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/booking">
            <i class="fa-solid fa-calendar-check"></i>
            <span>Quản lý đặt chỗ</span>
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

        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/feedback">
            <i class="fa-solid fa-comments"></i>
            <span>Xem Feedback</span>
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
                <h1>Admin Feedback View</h1>
                <p>Admin xem danh sách feedback của khách hàng. Admin chỉ có quyền xem, không duyệt hoặc chỉnh sửa feedback.</p>
            </div>

            <a class="top-action-btn" href="${pageContext.request.contextPath}/admin/home">
                <i class="fa-solid fa-arrow-left"></i>
                Về Admin Home
            </a>
        </div>

        <div class="content-card">
            <c:choose>
                <c:when test="${not empty feedbackList}">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>Feedback ID</th>
                                <th>Rate</th>
                                <th>Nội dung</th>
                                <th>Ngày tạo</th>
                                <th>Status</th>
                                <th>User ID</th>
                                <th>Booking ID</th>
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
                                        <span class="rate-badge">
                                            <i class="fa-solid fa-star"></i>
                                            <fmt:formatNumber value="${feedback.rate}" maxFractionDigits="0"/>
                                        </span>
                                    </td>

                                    <td>
                                        <div class="content-preview">
                                                ${feedback.content}
                                        </div>
                                    </td>

                                    <td>
                                        <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${feedback.status == 'Visible'}">
                                                <span class="status-badge status-visible">Visible</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-hidden">Hidden</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>${feedback.userID}</td>

                                    <td>${feedback.bookingID}</td>

                                    <td>
                                        <a class="btn-view"
                                           href="${pageContext.request.contextPath}/admin/feedback-detail?feedbackID=${feedback.feedbackID}">
                                            <i class="fa-solid fa-eye"></i>
                                            Xem
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
                        Chưa có feedback nào trong hệ thống.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
