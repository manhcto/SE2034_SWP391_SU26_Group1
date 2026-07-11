<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Admin Home</title>
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
            display: flex;
            flex-direction: column;
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
            box-shadow: 0 12px 24px rgba(239, 68, 68, 0.22);
        }

        .brand-box h2 {
            font-size: 26px;
            font-weight: 900;
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

        .sidebar-bottom {
            margin-top: auto;
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

        .top-actions {
            display: flex;
            gap: 12px;
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
            white-space: nowrap;
        }

        .btn-client {
            background: #ffffff;
            color: #0f172a;
        }

        .btn-staff {
            background: #0f172a;
            color: #ffffff;
        }

        .btn-client:hover {
            background: #f8fafc;
            color: #ef4444;
        }

        .btn-staff:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .hero {
            background:
                    radial-gradient(circle at top right, rgba(249, 115, 22, 0.28), transparent 30%),
                    linear-gradient(135deg, #0f172a, #991b1b);
            color: white;
            border-radius: 30px;
            padding: 36px;
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.18);
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 8px 13px;
            border-radius: 999px;
            font-weight: 800;
            margin-bottom: 16px;
        }

        .hero h2 {
            font-size: 38px;
            font-weight: 900;
            margin-bottom: 12px;
            letter-spacing: -0.8px;
        }

        .hero p {
            color: #fee2e2;
            margin-bottom: 0;
            max-width: 850px;
            line-height: 1.8;
            font-weight: 500;
        }

        .stat-card {
            border: none;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            height: 100%;
            background: white;
            transition: all 0.25s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.12);
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: white;
            margin-bottom: 16px;
        }

        .icon-red {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        .icon-orange {
            background: linear-gradient(135deg, #f97316, #f59e0b);
        }

        .icon-blue {
            background: linear-gradient(135deg, #2563eb, #4e46dc);
        }

        .icon-green {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .stat-card h3 {
            font-size: 28px;
            font-weight: 900;
            margin-bottom: 4px;
        }

        .stat-card p {
            color: #64748b;
            margin-bottom: 0;
            font-weight: 600;
        }

        .section-title {
            font-weight: 900;
            margin: 34px 0 18px;
            font-size: 24px;
        }

        .module-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 24px;
            min-height: 210px;
            height: 100%;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            transition: all 0.25s ease;
            text-decoration: none;
            color: #0f172a;
            display: block;
            position: relative;
            overflow: hidden;
        }

        .module-card::after {
            content: "";
            position: absolute;
            right: -35px;
            bottom: -35px;
            width: 110px;
            height: 110px;
            border-radius: 50%;
            background: rgba(239, 68, 68, 0.08);
        }

        .module-card:hover {
            transform: translateY(-7px);
            border-color: #ef4444;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.14);
            color: #0f172a;
        }

        .module-icon {
            width: 62px;
            height: 62px;
            border-radius: 20px;
            background: #fef2f2;
            color: #ef4444;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 18px;
        }

        .module-card h5 {
            font-weight: 900;
            margin-bottom: 9px;
            font-size: 18px;
        }

        .module-card p {
            color: #64748b;
            margin-bottom: 18px;
            font-size: 14px;
            line-height: 1.6;
        }

        .module-open {
            font-weight: 900;
            color: #ef4444;
            font-size: 14px;
        }

        .admin-card {
            border: 2px solid rgba(239, 68, 68, 0.22);
            background:
                    radial-gradient(circle at top right, rgba(239, 68, 68, 0.10), transparent 30%),
                    white;
        }

        .staff-view-card {
            border: 2px solid rgba(37, 99, 235, 0.18);
            background:
                    radial-gradient(circle at top right, rgba(37, 99, 235, 0.08), transparent 30%),
                    white;
        }

        @media (max-width: 992px) {
            .admin-sidebar {
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

            .top-actions {
                margin-top: 16px;
                flex-wrap: wrap;
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
            <p>Admin Control Center</p>
        </div>

        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/home">
            <i class="fa-solid fa-house"></i>
            <span>Admin Home</span>
        </a>

        <div class="nav-section-title">Quản trị hệ thống</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-chart-line"></i>
            <span>Dashboard</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/user">
            <i class="fa-solid fa-users-gear"></i>
            <span>Quản lý người dùng</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/tour-approval">
            <i class="fa-solid fa-circle-check"></i>
            <span>Phê duyệt Tour</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/booking">
            <i class="fa-solid fa-calendar-check"></i>
            <span>Xem Booking</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/feedback">
            <i class="fa-solid fa-comments"></i>
            <span>Xem Feedback</span>
        </a>

        <div class="sidebar-bottom">
            <div class="nav-section-title">Tai khoan</div>

            <div class="admin-user">
                <div class="avatar">AD</div>
                <div>
                    <div class="fw-bold">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                    <small>Quản trị viên</small>
                </div>
            </div>

            <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/profile">
                <i class="fa-solid fa-user"></i>
                <span>Ho so</span>
            </a>

            <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Dang xuat</span>
            </a>
        </div>
    </aside>

    <main class="main-content">

        <div class="topbar">
            <div>
                <h1>Trung tâm quản trị WonderVN</h1>
                <p>Quản lý hệ thống, người dùng, dashboard và theo dõi toàn bộ hoạt động vận hành của staff.</p>
            </div>

        </div>

        <section class="hero">
            <div class="hero-badge">
                <i class="fa-solid fa-shield-halved"></i>
                Admin Workspace
            </div>

            <h2>Quản trị hệ thống và giám sát toàn bộ hoạt động của WonderVN</h2>

            <p>
                Admin chịu trách nhiệm quản lý người dùng, theo dõi dashboard, phê duyệt tour và có quyền xem
                toàn bộ các module vận hành của staff như lưu trú, phương tiện, booking, payment, voucher và nội dung.
            </p>
        </section>

        <div class="row g-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-red">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3>1,234</h3>
                    <p>Người dùng hệ thống</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-orange">
                        <i class="fa-solid fa-route"></i>
                    </div>
                    <h3>45</h3>
                    <p>Tour đang hoạt động</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-blue">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <h3>23</h3>
                    <p>Booking chờ xử lý</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-green">
                        <i class="fa-solid fa-money-bill-wave"></i>
                    </div>
                    <h3>3.06B</h3>
                    <p>Doanh thu tổng quan</p>
                </div>
            </div>
        </div>

        <h3 class="section-title">Chức năng chính của Admin</h3>

        <div class="row g-4">
            <div class="col-md-4">
                <a class="module-card admin-card" href="${pageContext.request.contextPath}/admin/dashboard">
                    <div class="module-icon">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>
                    <h5>Dashboard hệ thống</h5>
                    <p>Xem tổng quan doanh thu, booking, người dùng, tour và hoạt động vận hành.</p>
                    <span class="module-open">Mở Dashboard <i class="fa-solid fa-arrow-right ms-1"></i></span>
                </a>
            </div>

            <div class="col-md-4">
                <a class="module-card admin-card" href="${pageContext.request.contextPath}/admin/user">
                    <div class="module-icon">
                        <i class="fa-solid fa-users-gear"></i>
                    </div>
                    <h5>Quản lý người dùng</h5>
                    <p>Quản lý tài khoản khách hàng, staff, tour guide, trạng thái và phân quyền.</p>
                    <span class="module-open">Mở Manage User <i class="fa-solid fa-arrow-right ms-1"></i></span>
                </a>
            </div>

            <div class="col-md-4">
                <a class="module-card admin-card" href="${pageContext.request.contextPath}/admin/tour-approval">
                    <div class="module-icon">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <h5>Phê duyệt Tour</h5>
                    <p>Xem và phê duyệt các tour trước khi công khai cho khách hàng đặt.</p>
                    <span class="module-open">Mở Tour Approval <i class="fa-solid fa-arrow-right ms-1"></i></span>
                </a>
            </div>

            <div class="col-md-4">
                <a class="module-card admin-card" href="${pageContext.request.contextPath}/admin/booking">
                    <div class="module-icon">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <h5>Xem Booking</h5>
                    <p>Admin xem danh sách booking và chi tiết booking, không chỉnh sửa dữ liệu booking.</p>
                    <span class="module-open">Mở Booking View <i class="fa-solid fa-arrow-right ms-1"></i></span>
                </a>
            </div>

            <div class="col-md-4">
                <a class="module-card admin-card" href="${pageContext.request.contextPath}/admin/feedback">
                    <div class="module-icon">
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <h5>Xem Feedback</h5>
                    <p>Admin xem danh sách feedback và chi tiết feedback của khách hàng, không duyệt hoặc chỉnh sửa.</p>
                    <span class="module-open">Mở Feedback View <i class="fa-solid fa-arrow-right ms-1"></i></span>
                </a>
            </div>
        </div>

        <h3 class="section-title">Xem các module vận hành của Staff</h3>

        <div class="row g-4">
            <div class="col-md-3">
                <a class="module-card staff-view-card" href="${pageContext.request.contextPath}/staff/accommodation?action=list">
                    <div class="module-icon">
                        <i class="fa-solid fa-hotel"></i>
                    </div>
                    <h5>View Accommodation</h5>
                    <p>Xem danh sách lưu trú, phòng và tiện ích đang được staff quản lý.</p>
                    <span class="module-open">Xem module</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card staff-view-card" href="${pageContext.request.contextPath}/staff/tour">
                    <div class="module-icon">
                        <i class="fa-solid fa-map-location-dot"></i>
                    </div>
                    <h5>View Tour</h5>
                    <p>Xem tour, lịch trình, giá và trạng thái mà staff đang quản lý.</p>
                    <span class="module-open">Xem module</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card staff-view-card" href="${pageContext.request.contextPath}/staff/payment">
                    <div class="module-icon">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h5>View Payment</h5>
                    <p>Xem giao dịch, trạng thái thanh toán và dữ liệu đối soát.</p>
                    <span class="module-open">Xem module</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card staff-view-card" href="${pageContext.request.contextPath}/staff/voucher">
                    <div class="module-icon">
                        <i class="fa-solid fa-gift"></i>
                    </div>
                    <h5>View Voucher</h5>
                    <p>Xem voucher, ưu đãi và chiến dịch giảm giá đang hoạt động.</p>
                    <span class="module-open">Xem module</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card staff-view-card" href="${pageContext.request.contextPath}/staff/feedback">
                    <div class="module-icon">
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <h5>View Staff Feedback</h5>
                    <p>Xem khu vực staff xử lý feedback, duyệt hoặc ẩn đánh giá khách hàng.</p>
                    <span class="module-open">Xem module</span>
                </a>
            </div>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
