<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Admin Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <!-- Font tiếng Việt đẹp -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            font-family: 'Be Vietnam Pro', Arial, sans-serif;
            color: #0f172a;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
        .sidebar {
            display: none;
            width: 292px;
            background: #0f172a;
            color: white;
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

        /* MAIN */
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
            margin-bottom: 26px;
        }

        .topbar h1 {
            font-size: 32px;
            font-weight: 800;
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
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
        }

        .btn-home {
            background: white;
            color: #0f172a;
        }

        .btn-logout {
            background: #0f172a;
            color: white;
        }

        .hero {
            background:
                    radial-gradient(circle at top right, rgba(6, 182, 212, 0.34), transparent 28%),
                    linear-gradient(135deg, #0f172a, #4e46dc);
            color: white;
            border-radius: 30px;
            padding: 34px;
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.18);
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
        }

        .hero h2 {
            font-size: 34px;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .hero p {
            color: #dbeafe;
            margin-bottom: 0;
            max-width: 760px;
            line-height: 1.7;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 8px 13px;
            border-radius: 999px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        /* STAT */
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

        .icon-blue {
            background: linear-gradient(135deg, #2563eb, #4e46dc);
        }

        .icon-cyan {
            background: linear-gradient(135deg, #0891b2, #06b6d4);
        }

        .icon-green {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .icon-orange {
            background: linear-gradient(135deg, #f97316, #f59e0b);
        }

        .stat-card h3 {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .stat-card p {
            color: #64748b;
            margin-bottom: 0;
            font-weight: 600;
        }

        .section-title {
            font-weight: 800;
            margin: 34px 0 18px;
            font-size: 24px;
        }

        /* MODULE */
        .module-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 24px;
            min-height: 205px;
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
            background: rgba(78, 70, 220, 0.08);
        }

        .module-card:hover {
            transform: translateY(-7px);
            border-color: #4e46dc;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.14);
            color: #0f172a;
        }

        .module-icon {
            width: 62px;
            height: 62px;
            border-radius: 20px;
            background: #eef2ff;
            color: #4e46dc;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 18px;
        }

        .module-card h5 {
            font-weight: 800;
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
            font-weight: 800;
            color: #4e46dc;
            font-size: 14px;
        }

        .highlight-card {
            border: 2px solid rgba(6, 182, 212, 0.35);
            background:
                    radial-gradient(circle at top right, rgba(6, 182, 212, 0.12), transparent 30%),
                    white;
        }

        .quick-card {
            background: white;
            border-radius: 24px;
            border: 1px solid #e2e8f0;
            padding: 26px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .quick-btn {
            border-radius: 17px;
            padding: 17px;
            font-weight: 800;
            text-decoration: none;
            display: block;
            text-align: center;
            transition: all 0.2s ease;
        }

        .quick-btn:hover {
            transform: translateY(-3px);
            opacity: 0.92;
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

            .top-actions {
                margin-top: 16px;
                flex-wrap: wrap;
            }
        }
    </style>
</head>

<body>
<div class="admin-layout">
    <jsp:include page="/views/common/admin-sidebar.jsp"/>

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="brand-box">
            <div class="brand-logo">WV</div>
            <h2>WonderVN</h2>
            <p>Travel ERP System</p>
        </div>

        <a class="sidebar-link active" href="${pageContext.request.contextPath}/staff/home">
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

        <a class="sidebar-link" href="${pageContext.request.contextPath}/staff/feedback">
            <i class="fa-solid fa-comments"></i>
            <span>Đánh giá khách hàng</span>
        </a>

        <div class="admin-user">
            <div class="avatar">AD</div>
            <div>
                <div class="fw-bold">Nhân viên</div>
                <small>Staff</small>
            </div>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main-content">

        <div class="topbar">
            <div>
                <h1>Bảng điều khiển WonderVN</h1>
                <p>Chào mừng bạn quay lại hệ thống quản trị du lịch.</p>
            </div>

            <div class="top-actions">
                <a class="top-action-btn btn-home" href="${pageContext.request.contextPath}/home">
                    <i class="fa-solid fa-globe"></i>
                    Trang khách hàng
                </a>

                <a class="top-action-btn btn-logout" href="${pageContext.request.contextPath}/logout">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    Đăng xuất
                </a>
            </div>
        </div>

        <section class="hero">
            <div class="hero-badge">
                <i class="fa-solid fa-sparkles"></i>
                Admin Workspace
            </div>
            <h2>Quản lý toàn bộ dịch vụ du lịch trong một màn hình</h2>
            <p>
                Theo dõi tour, nơi lưu trú, phương tiện, booking, thanh toán và các hoạt động vận hành của WonderVN.
                Hai module lưu trú và phương tiện đã được liên kết trực tiếp để thao tác nhanh.
            </p>
        </section>

        <!-- STATS -->
        <div class="row g-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-blue">
                        <i class="fa-solid fa-sack-dollar"></i>
                    </div>
                    <h3>3.060.600.000đ</h3>
                    <p>Tổng doanh thu</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-cyan">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3>1,234</h3>
                    <p>Người dùng hoạt động</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-green">
                        <i class="fa-solid fa-route"></i>
                    </div>
                    <h3>45</h3>
                    <p>Tour đang hoạt động</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-orange">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <h3>23</h3>
                    <p>Booking chờ xử lý</p>
                </div>
            </div>
        </div>

        <h3 class="section-title">Module ưu tiên</h3>

        <div class="row g-4">
            <div class="col-md-6">
                <a class="module-card highlight-card"
                   href="${pageContext.request.contextPath}/staff/accommodation?action=list">
                    <div class="module-icon">
                        <i class="fa-solid fa-hotel"></i>
                    </div>
                    <h5>Quản lý lưu trú & phòng</h5>
                    <p>
                        Quản lý khách sạn, homestay, resort, trạng thái hoạt động và danh sách phòng thuộc từng cơ sở lưu trú.
                    </p>
                    <span class="module-open">
                        Mở màn quản lý lưu trú <i class="fa-solid fa-arrow-right ms-1"></i>
                    </span>
                </a>
            </div>

        </div>

        <h3 class="section-title">Tất cả chức năng quản lý</h3>

        <div class="row g-4">
            <div class="col-md-3">
                <a class="module-card" href="${pageContext.request.contextPath}/staff/tour">
                    <div class="module-icon">
                        <i class="fa-solid fa-map-location-dot"></i>
                    </div>
                    <h5>Quản lý Tour</h5>
                    <p>Tạo, cập nhật tour, lịch trình, giá bán và trạng thái tour.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card" href="${pageContext.request.contextPath}/staff/booking">
                    <div class="module-icon">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <h5>Quản lý Booking</h5>
                    <p>Theo dõi đơn đặt chỗ, trạng thái xử lý và lịch sử đặt dịch vụ.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card" href="${pageContext.request.contextPath}/staff/payment">
                    <div class="module-icon">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h5>Quản lý Payment</h5>
                    <p>Kiểm tra thanh toán, trạng thái giao dịch và đối soát.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card" href="${pageContext.request.contextPath}/staff/voucher">
                    <div class="module-icon">
                        <i class="fa-solid fa-gift"></i>
                    </div>
                    <h5>Quản lý Voucher</h5>
                    <p>Tạo mã giảm giá, chiến dịch ưu đãi và điều kiện áp dụng.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>

                    <p>Quản lý vé tham quan, vé vui chơi và dịch vụ bên ngoài.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card" href="${pageContext.request.contextPath}/staff/blog">
                    <div class="module-icon">
                        <i class="fa-solid fa-newspaper"></i>
                    </div>
                    <h5>Quản lý Blog</h5>
                    <p>Đăng bài viết, tin tức du lịch và nội dung truyền thông.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>

            <div class="col-md-3">
                <a class="module-card" href="${pageContext.request.contextPath}/staff/feedback">
                    <div class="module-icon">
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <h5>Feedback</h5>
                    <p>Xem đánh giá, phản hồi khách hàng và chất lượng dịch vụ.</p>
                    <span class="module-open">Mở chức năng</span>
                </a>
            </div>
        </div>

        <h3 class="section-title">Thao tác nhanh</h3>

        <div class="quick-card">
            <div class="row g-3">
                <div class="col-md-3">
                    <a class="quick-btn bg-dark text-white"
                       href="${pageContext.request.contextPath}/staff/accommodation?action=list">
                        <i class="fa-solid fa-hotel me-2"></i>
                        Thêm lưu trú
                    </a>
                </div>

                <div class="col-md-3">
                    <a class="quick-btn bg-info text-white"
                       href="${pageContext.request.contextPath}/staff/booking">
                        <i class="fa-solid fa-calendar-check me-2"></i>
                        Quản lý booking
                    </a>
                </div>

                <div class="col-md-3">
                    <a class="quick-btn bg-primary text-white"
                       href="${pageContext.request.contextPath}/staff/tour">
                        <i class="fa-solid fa-route me-2"></i>
                        Quản lý tour
                    </a>
                </div>

                <div class="col-md-3">
                    <a class="quick-btn bg-secondary text-white"
                       href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-globe me-2"></i>
                        Về trang chủ
                    </a>
                </div>
            </div>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
