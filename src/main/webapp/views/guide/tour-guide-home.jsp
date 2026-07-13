<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Tour Guide Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

    <!-- Font tiếng Việt -->
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

        .guide-layout {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
        .guide-sidebar {
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
            background: linear-gradient(135deg, #10b981, #2563eb);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            font-size: 20px;
            margin-bottom: 12px;
            box-shadow: 0 12px 24px rgba(16, 185, 129, 0.22);
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
            background: linear-gradient(135deg, #10b981, #2563eb);
            color: #ffffff;
            box-shadow: 0 10px 22px rgba(37, 99, 235, 0.20);
        }

        .guide-user {
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
            background: linear-gradient(135deg, #10b981, #2563eb);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            color: white;
        }

        .guide-user small {
            color: #94a3b8;
        }

        .sidebar-bottom {
            margin-top: auto;
        }

        /* MAIN */
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

        .btn-logout {
            background: #0f172a;
            color: #ffffff;
        }

        .btn-client:hover {
            background: #f8fafc;
            color: #2563eb;
        }

        .btn-logout:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .hero {
            background:
                    radial-gradient(circle at top right, rgba(16, 185, 129, 0.30), transparent 30%),
                    linear-gradient(135deg, #0f172a, #1d4ed8);
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
            color: #dbeafe;
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

        .icon-blue {
            background: linear-gradient(135deg, #2563eb, #4e46dc);
        }

        .icon-green {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .icon-orange {
            background: linear-gradient(135deg, #f97316, #f59e0b);
        }

        .icon-cyan {
            background: linear-gradient(135deg, #0891b2, #06b6d4);
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

        .tour-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 26px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
            overflow: hidden;
            height: 100%;
            transition: 0.25s ease;
        }

        .tour-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.13);
        }

        .tour-card-header {
            padding: 22px 24px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
        }

        .tour-title {
            margin: 0 0 8px;
            font-size: 20px;
            font-weight: 900;
            color: #0f172a;
        }

        .tour-code {
            color: #64748b;
            font-size: 14px;
            font-weight: 700;
        }

        .status-badge {
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .status-new {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .status-confirmed {
            background: #ecfdf5;
            color: #047857;
        }

        .status-progress {
            background: #fff7ed;
            color: #c2410c;
        }

        .tour-card-body {
            padding: 22px 24px;
        }

        .info-row {
            display: flex;
            gap: 12px;
            margin-bottom: 14px;
            color: #334155;
            font-weight: 600;
        }

        .info-row i {
            width: 20px;
            color: #2563eb;
            margin-top: 3px;
        }

        .tour-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 18px;
        }

        .guide-btn {
            border: none;
            border-radius: 14px;
            padding: 11px 14px;
            font-size: 13px;
            font-weight: 900;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s ease;
            cursor: pointer;
        }

        .guide-btn:hover {
            transform: translateY(-2px);
        }

        .btn-accept {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .btn-confirm {
            background: #ecfdf5;
            color: #047857;
        }

        .btn-update {
            background: #fff7ed;
            color: #c2410c;
        }

        .btn-detail {
            background: #f1f5f9;
            color: #334155;
        }

        .timeline-box {
            background: #ffffff;
            border-radius: 26px;
            border: 1px solid #e2e8f0;
            padding: 26px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.08);
        }

        .timeline-item {
            display: flex;
            gap: 14px;
            padding: 16px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .timeline-item:last-child {
            border-bottom: none;
        }

        .timeline-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: #eef2ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 auto;
        }

        .timeline-content h6 {
            margin: 0 0 4px;
            font-weight: 900;
        }

        .timeline-content p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
        }

        .modal-content {
            border: none;
            border-radius: 24px;
            overflow: hidden;
        }

        .modal-header {
            background: #0f172a;
            color: #ffffff;
            border-bottom: none;
            padding: 20px 24px;
        }

        .modal-title {
            font-weight: 900;
        }

        .modal-body {
            padding: 24px;
        }

        .form-label {
            font-weight: 800;
            color: #0f172a;
        }

        .form-control,
        .form-select {
            min-height: 48px;
            border-radius: 14px;
            border: 1px solid #dbe3f0;
            font-weight: 600;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.10);
        }

        @media (max-width: 992px) {
            .guide-sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .guide-layout {
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
<div class="guide-layout">

    <!-- SIDEBAR -->
    <aside class="guide-sidebar">
        <div class="brand-box">
            <div class="brand-logo">TG</div>
            <h2>WonderVN</h2>
            <p>Tour Guide Workspace</p>
        </div>

        <a class="sidebar-link active" href="${pageContext.request.contextPath}/guide/home">
            <i class="fa-solid fa-house"></i>
            <span>Trang chủ hướng dẫn viên</span>
        </a>

        <div class="nav-section-title">Nhiệm vụ tour</div>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/assignment">
            <i class="fa-solid fa-clipboard-list"></i>
            <span>Tour được phân công</span>
        </a>

        <a class="sidebar-link" href="#confirmedTours">
            <i class="fa-solid fa-circle-check"></i>
            <span>Tour đã xác nhận</span>
        </a>

        <a class="sidebar-link" href="#tourUpdates">
            <i class="fa-solid fa-pen-to-square"></i>
            <span>Cập nhật tour</span>
        </a>

        <div class="sidebar-bottom">
            <div class="nav-section-title">Tài khoản</div>

            <div class="guide-user">
                <div class="avatar">TG</div>
                <div>
                    <div class="fw-bold">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                    <small>Hướng dẫn viên</small>
                </div>
            </div>

            <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/profile">
                <i class="fa-solid fa-user"></i>
                <span>Hồ sơ</span>
            </a>

            <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Đăng xuất</span>
            </a>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main-content">

        <div class="topbar">
            <div>
                <h1>Tour Guide Workspace</h1>
                <p>Quản lý tour được phân công, xác nhận tour và cập nhật tình trạng tour theo thời gian thực.</p>
            </div>

        </div>

        <section class="hero">
            <div class="hero-badge">
                <i class="fa-solid fa-location-dot"></i>
                Tour Guide Operation
            </div>

            <h2>Nhận tour, xác nhận lịch trình và cập nhật tiến độ tour</h2>

            <p>
                Hướng dẫn viên có thể xem các tour được phân công, xác nhận nhận tour,
                cập nhật trạng thái di chuyển, ghi chú tình hình thực tế và báo cáo nhanh cho bộ phận vận hành.
            </p>
        </section>

        <!-- STATS -->
        <div class="row g-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-blue">
                        <i class="fa-solid fa-clipboard-list"></i>
                    </div>
                    <h3>4</h3>
                    <p>Tour được phân công</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-green">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <h3>2</h3>
                    <p>Tour đã xác nhận</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-orange">
                        <i class="fa-solid fa-route"></i>
                    </div>
                    <h3>1</h3>
                    <p>Tour đang diễn ra</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-cyan">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </div>
                    <h3>8</h3>
                    <p>Cập nhật đã gửi</p>
                </div>
            </div>
        </div>

        <h3 class="section-title" id="assignedTours">Tour được phân công</h3>

        <div class="row g-4">
            <!-- TOUR CARD 1 -->
            <div class="col-md-6">
                <div class="tour-card">
                    <div class="tour-card-header">
                        <div>
                            <h5 class="tour-title">Hà Nội - Hạ Long 3N2Đ</h5>
                            <div class="tour-code">TOUR-HL-0326 | 25 khách</div>
                        </div>
                        <span class="status-badge status-new">Chờ nhận tour</span>
                    </div>

                    <div class="tour-card-body">
                        <div class="info-row">
                            <i class="fa-solid fa-calendar-days"></i>
                            <span>Ngày khởi hành: 15/06/2026 - 17/06/2026</span>
                        </div>

                        <div class="info-row">
                            <i class="fa-solid fa-location-dot"></i>
                            <span>Điểm đón: Đại học FPT Hòa Lạc, Hà Nội</span>
                        </div>

                        <div class="info-row">
                            <i class="fa-solid fa-bus"></i>
                            <span>Phương tiện: Xe 45 chỗ | Tài xế: Nguyễn Văn A</span>
                        </div>

                        <div class="info-row">
                            <i class="fa-solid fa-user-group"></i>
                            <span>Trưởng đoàn: Trần Minh Anh | SĐT: 0901 222 333</span>
                        </div>

                        <div class="tour-actions">
                            <button class="guide-btn btn-accept" data-bs-toggle="modal" data-bs-target="#acceptTourModal">
                                <i class="fa-solid fa-handshake"></i>
                                Nhận tour
                            </button>

                            <button class="guide-btn btn-detail" data-bs-toggle="modal" data-bs-target="#tourDetailModal">
                                <i class="fa-solid fa-eye"></i>
                                Xem chi tiết
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TOUR CARD 2 -->
            <div class="col-md-6">
                <div class="tour-card">
                    <div class="tour-card-header">
                        <div>
                            <h5 class="tour-title">Ninh Bình - Tràng An 1 ngày</h5>
                            <div class="tour-code">TOUR-NB-0198 | 18 khách</div>
                        </div>
                        <span class="status-badge status-confirmed">Đã xác nhận</span>
                    </div>

                    <div class="tour-card-body">
                        <div class="info-row">
                            <i class="fa-solid fa-calendar-days"></i>
                            <span>Ngày khởi hành: 20/06/2026</span>
                        </div>

                        <div class="info-row">
                            <i class="fa-solid fa-location-dot"></i>
                            <span>Điểm đón: Cổng Công viên Thống Nhất, Hà Nội</span>
                        </div>

                        <div class="info-row">
                            <i class="fa-solid fa-bus"></i>
                            <span>Phương tiện: Xe 29 chỗ | Tài xế: Lê Văn B</span>
                        </div>

                        <div class="info-row">
                            <i class="fa-solid fa-user-group"></i>
                            <span>Trưởng đoàn: Phạm Thu Hà | SĐT: 0988 111 222</span>
                        </div>

                        <div class="tour-actions">
                            <button class="guide-btn btn-confirm" data-bs-toggle="modal" data-bs-target="#confirmTourModal">
                                <i class="fa-solid fa-circle-check"></i>
                                Xác nhận lịch trình
                            </button>

                            <button class="guide-btn btn-update" data-bs-toggle="modal" data-bs-target="#updateTourModal">
                                <i class="fa-solid fa-pen-to-square"></i>
                                Cập nhật tour
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <h3 class="section-title" id="tourUpdates">Cập nhật tour gần đây</h3>

        <div class="timeline-box">
            <div class="timeline-item">
                <div class="timeline-icon">
                    <i class="fa-solid fa-location-dot"></i>
                </div>
                <div class="timeline-content">
                    <h6>Đã đến điểm đón khách</h6>
                    <p>Tour Ninh Bình - Tràng An | 07:15 | Khách đã có mặt 16/18 người.</p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-icon">
                    <i class="fa-solid fa-bus"></i>
                </div>
                <div class="timeline-content">
                    <h6>Xe bắt đầu di chuyển</h6>
                    <p>Tour Hạ Long 3N2Đ | 08:05 | Xe rời điểm đón, lịch trình đúng giờ.</p>
                </div>
            </div>

            <div class="timeline-item">
                <div class="timeline-icon">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div class="timeline-content">
                    <h6>Xác nhận hoàn thành điểm tham quan</h6>
                    <p>Tour Hà Nội City Tour | 14:30 | Hoàn thành tham quan Văn Miếu - Quốc Tử Giám.</p>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- ACCEPT TOUR MODAL -->
<div class="modal fade" id="acceptTourModal" tabindex="-1" aria-labelledby="acceptTourModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" action="${pageContext.request.contextPath}/guide/tour" method="post">
            <input type="hidden" name="action" value="accept">
            <input type="hidden" name="assignmentID" value="1">

            <div class="modal-header">
                <h5 class="modal-title" id="acceptTourModalLabel">
                    <i class="fa-solid fa-handshake me-2"></i>
                    Nhận tour được phân công
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <p class="mb-3">
                    Bạn xác nhận sẽ nhận phụ trách tour <strong>Hà Nội - Hạ Long 3N2Đ</strong>?
                </p>

                <label class="form-label">Ghi chú nhận tour</label>
                <textarea class="form-control" name="note" rows="4"
                          placeholder="VD: Tôi đã nhận thông tin tour và sẽ liên hệ điều phối nếu cần hỗ trợ."></textarea>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-primary fw-bold">
                    <i class="fa-solid fa-check me-2"></i>
                    Xác nhận nhận tour
                </button>
            </div>
        </form>
    </div>
</div>

<!-- CONFIRM TOUR MODAL -->
<div class="modal fade" id="confirmTourModal" tabindex="-1" aria-labelledby="confirmTourModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form class="modal-content" action="${pageContext.request.contextPath}/guide/tour" method="post">
            <input type="hidden" name="action" value="confirm">
            <input type="hidden" name="assignmentID" value="2">

            <div class="modal-header">
                <h5 class="modal-title" id="confirmTourModalLabel">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    Xác nhận lịch trình tour
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <label class="form-label">Trạng thái xác nhận</label>
                <select class="form-select mb-3" name="confirmStatus">
                    <option value="Confirmed">Xác nhận tham gia hướng dẫn</option>
                    <option value="Need Support">Cần staff hỗ trợ thêm thông tin</option>
                </select>

                <label class="form-label">Ghi chú xác nhận</label>
                <textarea class="form-control" name="note" rows="4"
                          placeholder="VD: Tôi đã kiểm tra lịch trình, điểm đón và thông tin đoàn."></textarea>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-success fw-bold">
                    <i class="fa-solid fa-check me-2"></i>
                    Lưu xác nhận
                </button>
            </div>
        </form>
    </div>
</div>

<!-- UPDATE TOUR MODAL -->
<div class="modal fade" id="updateTourModal" tabindex="-1" aria-labelledby="updateTourModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <form class="modal-content" action="${pageContext.request.contextPath}/guide/tour" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="assignmentID" value="2">

            <div class="modal-header">
                <h5 class="modal-title" id="updateTourModalLabel">
                    <i class="fa-solid fa-pen-to-square me-2"></i>
                    Cập nhật tình trạng tour
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái tour</label>
                        <select class="form-select" name="tourStatus">
                            <option value="At Pickup Point">Đã đến điểm đón</option>
                            <option value="Departed">Đã khởi hành</option>
                            <option value="Arrived Destination">Đã đến điểm tham quan</option>
                            <option value="Lunch Break">Đang nghỉ ăn trưa</option>
                            <option value="Completed Visit">Hoàn thành điểm tham quan</option>
                            <option value="Returning">Đang quay về</option>
                            <option value="Completed">Hoàn thành tour</option>
                            <option value="Issue">Có vấn đề phát sinh</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Thời gian cập nhật</label>
                        <input type="datetime-local" class="form-control" name="updateTime">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Số khách hiện có mặt</label>
                        <input type="number" class="form-control" name="presentGuests" min="0" placeholder="VD: 18">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Vị trí hiện tại</label>
                        <input type="text" class="form-control" name="currentLocation" placeholder="VD: Tràng An, Ninh Bình">
                    </div>

                    <div class="col-12">
                        <label class="form-label">Nội dung cập nhật</label>
                        <textarea class="form-control" name="updateNote" rows="5"
                                  placeholder="VD: Đoàn đã đến điểm tham quan, lịch trình đúng giờ, không có phát sinh."></textarea>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Vấn đề phát sinh nếu có</label>
                        <textarea class="form-control" name="issueNote" rows="3"
                                  placeholder="VD: Có 1 khách đến muộn 10 phút, đã thông báo staff."></textarea>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" class="btn btn-warning fw-bold">
                    <i class="fa-solid fa-floppy-disk me-2"></i>
                    Lưu cập nhật tour
                </button>
            </div>
        </form>
    </div>
</div>

<!-- TOUR DETAIL MODAL -->
<div class="modal fade" id="tourDetailModal" tabindex="-1" aria-labelledby="tourDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="tourDetailModalLabel">
                    <i class="fa-solid fa-eye me-2"></i>
                    Chi tiết tour được phân công
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <h5 class="fw-bold mb-3">Hà Nội - Hạ Long 3N2Đ</h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <strong>Mã tour:</strong>
                        <p>TOUR-HL-0326</p>
                    </div>

                    <div class="col-md-6">
                        <strong>Số khách:</strong>
                        <p>25 khách</p>
                    </div>

                    <div class="col-md-6">
                        <strong>Ngày khởi hành:</strong>
                        <p>15/06/2026 - 17/06/2026</p>
                    </div>

                    <div class="col-md-6">
                        <strong>Điểm đón:</strong>
                        <p>Đại học FPT Hòa Lạc, Hà Nội</p>
                    </div>

                    <div class="col-md-6">
                        <strong>Phương tiện:</strong>
                        <p>Xe 45 chỗ</p>
                    </div>

                    <div class="col-md-6">
                        <strong>Tài xế:</strong>
                        <p>Nguyễn Văn A - 0912 345 678</p>
                    </div>

                    <div class="col-12">
                        <strong>Lịch trình tóm tắt:</strong>
                        <p>
                            Ngày 1: Hà Nội - Hạ Long - Check-in khách sạn.
                            Ngày 2: Tham quan Vịnh Hạ Long.
                            Ngày 3: Tự do mua sắm - Trở về Hà Nội.
                        </p>
                    </div>

                    <div class="col-12">
                        <strong>Ghi chú staff:</strong>
                        <p>
                            Cần có mặt tại điểm đón trước 30 phút, kiểm tra danh sách khách và hỗ trợ khách trong suốt lịch trình.
                        </p>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-dark fw-bold" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
