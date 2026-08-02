<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Trang chủ hướng dẫn viên</title>
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

        .status-completed {
            background: #f1f5f9;
            color: #334155;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #b91c1c;
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

        .btn-reject {
            background: #fef2f2;
            color: #b91c1c;
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

        .timeline-icon-pickup {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .timeline-icon-moving {
            background: #fff7ed;
            color: #c2410c;
        }

        .timeline-icon-arrived {
            background: #ecfeff;
            color: #0e7490;
        }

        .timeline-icon-completed {
            background: #dcfce7;
            color: #166534;
        }

        .timeline-icon-issue {
            background: #fee2e2;
            color: #b91c1c;
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

    <jsp:include page="/views/common/guide-sidebar.jsp">
        <jsp:param name="sidebarClass" value="guide-sidebar"/>
        <jsp:param name="activeGuideMenu" value="home"/>
    </jsp:include>

    <!-- MAIN -->
    <main class="main-content">

        <div class="topbar">
            <div>
                <h1>Khu vực hướng dẫn viên</h1>
                <p>Quản lý tour được phân công, xác nhận tour và cập nhật tình trạng tour theo thời gian thực.</p>
            </div>

        </div>

        <section class="hero">
            <div class="hero-badge">
                <i class="fa-solid fa-location-dot"></i>
                Vận hành tour
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
                    <h3>${assignedTourCount}</h3>
                    <p>Tour được phân công</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-green">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <h3>${confirmedTourCount}</h3>
                    <p>Tour đã xác nhận</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-orange">
                        <i class="fa-solid fa-route"></i>
                    </div>
                    <h3>${inProgressTourCount}</h3>
                    <p>Tour đang diễn ra</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-icon icon-cyan">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </div>
                    <h3>${completedTourCount}</h3>
                    <p>Tour hoàn thành</p>
                </div>
            </div>
        </div>

        <h3 class="section-title" id="assignedTours">Tour được phân công</h3>

        <div class="row g-4">
            <c:forEach var="assignment" items="${assignedTours}">
                <c:set var="assignmentStatus" value="${empty assignment.assignmentStatus ? 'Pending' : assignment.assignmentStatus}"/>
                <c:set var="showConfirmButton" value="${assignmentStatus == 'Pending' || assignmentStatus == 'Assigned'}"/>
                <c:set var="showTourActions" value="${assignmentStatus == 'Accepted' || assignmentStatus == 'Confirmed' || assignmentStatus == 'In Progress'}"/>

                <c:choose>
                    <c:when test="${assignmentStatus == 'Pending' || assignmentStatus == 'Assigned'}">
                        <c:set var="statusClass" value="status-new"/>
                        <c:set var="statusLabel" value="Chờ nhận tour"/>
                    </c:when>
                    <c:when test="${assignmentStatus == 'Accepted'}">
                        <c:set var="statusClass" value="status-confirmed"/>
                        <c:set var="statusLabel" value="Đã xác nhận"/>
                    </c:when>
                    <c:when test="${assignmentStatus == 'Confirmed'}">
                        <c:set var="statusClass" value="status-confirmed"/>
                        <c:set var="statusLabel" value="Đã xác nhận"/>
                    </c:when>
                    <c:when test="${assignmentStatus == 'In Progress'}">
                        <c:set var="statusClass" value="status-progress"/>
                        <c:set var="statusLabel" value="Đang diễn ra"/>
                    </c:when>
                    <c:when test="${assignmentStatus == 'Completed'}">
                        <c:set var="statusClass" value="status-completed"/>
                        <c:set var="statusLabel" value="Hoàn thành"/>
                    </c:when>
                    <c:when test="${assignmentStatus == 'Cancelled' || assignmentStatus == 'Rejected'}">
                        <c:set var="statusClass" value="status-cancelled"/>
                        <c:set var="statusLabel" value="${assignment.assignmentStatusLabel}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="statusClass" value="status-new"/>
                        <c:set var="statusLabel" value="${assignment.assignmentStatusLabel}"/>
                    </c:otherwise>
                </c:choose>

                <div class="col-md-6">
                    <div class="tour-card">
                        <div class="tour-card-header">
                            <div>
                                <h5 class="tour-title">${assignment.tourName}</h5>
                                <div class="tour-code">
                                    <c:choose>
                                        <c:when test="${not empty assignment.assignmentCode}">${assignment.assignmentCode}</c:when>
                                        <c:otherwise>ASG-${assignment.assignmentID}</c:otherwise>
                                    </c:choose>
                                    | ${assignment.totalGuests} khách
                                </div>
                            </div>
                            <span class="status-badge ${statusClass}">${statusLabel}</span>
                        </div>

                        <div class="tour-card-body">
                            <div class="info-row">
                                <i class="fa-solid fa-calendar-days"></i>
                                <span>
                                    Ngày khởi hành:
                                    <fmt:formatDate value="${assignment.departureDate}" pattern="dd/MM/yyyy"/>
                                    <c:if test="${not empty assignment.endDate}">
                                        - <fmt:formatDate value="${assignment.endDate}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                </span>
                            </div>

                            <div class="info-row">
                                <i class="fa-solid fa-location-dot"></i>
                                <span>Điểm đón: ${empty assignment.meetingPoint ? 'Chưa nhập' : assignment.meetingPoint}</span>
                            </div>

                            <div class="info-row">
                                <i class="fa-solid fa-route"></i>
                                <span>Tuyến: ${assignment.startPlace} → ${assignment.endPlace}</span>
                            </div>

                            <div class="info-row">
                                <i class="fa-solid fa-user-group"></i>
                                <span>
                                    Khách:
                                    <c:choose>
                                        <c:when test="${not empty assignment.customerName}">
                                            ${assignment.customerName}
                                            <c:if test="${not empty assignment.customerPhone}">
                                                - ${assignment.customerPhone}
                                            </c:if>
                                        </c:when>
                                        <c:when test="${not empty assignment.customerPhone}">
                                            ${assignment.customerPhone}
                                        </c:when>
                                        <c:otherwise>Chưa có thông tin khách</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="tour-actions">
                                <a class="guide-btn btn-detail"
                                   href="${pageContext.request.contextPath}/guide/assignment?action=detail&id=${assignment.assignmentID}">
                                    <i class="fa-solid fa-eye"></i>
                                    Xem chi tiết
                                </a>

                                <c:if test="${showConfirmButton}">
                                    <form method="post" action="${pageContext.request.contextPath}/guide/assignment" class="m-0">
                                        <input type="hidden" name="action" value="confirmAssignment">
                                        <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                                        <button class="guide-btn btn-confirm" type="submit">
                                            <i class="fa-solid fa-circle-check"></i>
                                            Xác nhận tour
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/guide/assignment" class="m-0"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn từ chối tour này không?');">
                                        <input type="hidden" name="action" value="rejectAssignment">
                                        <input type="hidden" name="assignmentID" value="${assignment.assignmentID}">
                                        <button class="guide-btn btn-reject" type="submit">
                                            <i class="fa-solid fa-circle-xmark"></i>
                                            Từ chối tour
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${showTourActions}">
                                    <a class="guide-btn btn-update"
                                       href="${pageContext.request.contextPath}/guide/assignment?action=editPassengerStatus&id=${assignment.assignmentID}">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                        Cập nhật hành khách
                                    </a>

                                    <a class="guide-btn btn-confirm"
                                       href="${pageContext.request.contextPath}/guide/assignment?action=progressLog&id=${assignment.assignmentID}">
                                        <i class="fa-solid fa-route"></i>
                                        Nhật ký tiến độ
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty assignedTours}">
                <div class="col-12">
                    <div class="tour-card">
                        <div class="tour-card-body text-center py-5">
                            <i class="fa-solid fa-clipboard-list fs-2 text-primary mb-3"></i>
                            <h5 class="tour-title">Chưa có tour được phân công</h5>
                            <p class="mb-0 text-muted">Khi nhân viên phân công tour cho bạn, danh sách sẽ hiển thị tại đây.</p>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <h3 class="section-title" id="tourUpdates">Cập nhật tour gần đây</h3>

        <div class="timeline-box">
            <c:forEach var="log" items="${recentProgressLogs}">
                <c:choose>
                    <c:when test="${log.progressStatus == 'Completed'}">
                        <c:set var="timelineIconClass" value="timeline-icon-completed"/>
                    </c:when>
                    <c:when test="${log.progressStatus == 'Issue'}">
                        <c:set var="timelineIconClass" value="timeline-icon-issue"/>
                    </c:when>
                    <c:when test="${log.progressStatus == 'Pickup Completed' || log.progressStatus == 'At Pickup Point'}">
                        <c:set var="timelineIconClass" value="timeline-icon-pickup"/>
                    </c:when>
                    <c:when test="${log.progressStatus == 'Arrived' || log.progressStatus == 'Arrived Destination'}">
                        <c:set var="timelineIconClass" value="timeline-icon-arrived"/>
                    </c:when>
                    <c:when test="${log.progressStatus == 'Departed' || log.progressStatus == 'Returning' || log.progressStatus == 'Lunch Break' || log.progressStatus == 'Activity Completed' || log.progressStatus == 'Completed Visit'}">
                        <c:set var="timelineIconClass" value="timeline-icon-moving"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="timelineIconClass" value="timeline-icon-pickup"/>
                    </c:otherwise>
                </c:choose>
                <div class="timeline-item">
                    <div class="timeline-icon ${timelineIconClass}">
                        <c:choose>
                            <c:when test="${log.progressStatus == 'Pickup Completed' || log.progressStatus == 'At Pickup Point'}">
                                <i class="fa-solid fa-user-check"></i>
                            </c:when>
                            <c:when test="${log.progressStatus == 'Departed' || log.progressStatus == 'Returning' || log.progressStatus == 'Lunch Break' || log.progressStatus == 'Activity Completed' || log.progressStatus == 'Completed Visit'}">
                                <i class="fa-solid fa-bus"></i>
                            </c:when>
                            <c:when test="${log.progressStatus == 'Completed'}">
                                <i class="fa-solid fa-circle-check"></i>
                            </c:when>
                            <c:when test="${log.progressStatus == 'Issue'}">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-location-dot"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="timeline-content">
                        <h6>${empty log.title ? 'Cập nhật tour' : log.title}</h6>
                        <p>
                            ${log.tourName}
                            |
                            <fmt:formatDate value="${log.logTime}" pattern="dd/MM/yyyy HH:mm"/>
                            |
                            ${empty log.content ? log.progressStatusLabel : log.content}
                        </p>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty recentProgressLogs}">
                <div class="timeline-item">
                    <div class="timeline-icon">
                        <i class="fa-solid fa-clipboard-list"></i>
                    </div>
                    <div class="timeline-content">
                        <h6>Chưa có cập nhật tour</h6>
                        <p>Khi bạn thêm nhật ký tiến độ cho tour được phân công, các cập nhật mới nhất sẽ hiển thị tại đây.</p>
                    </div>
                </div>
            </c:if>
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
                    <option value="Need Support">Cần nhân viên hỗ trợ thêm thông tin</option>
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
                                  placeholder="VD: Có 1 khách đến muộn 10 phút, đã thông báo nhân viên."></textarea>
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
                            <strong>Ghi chú nhân viên:</strong>
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
