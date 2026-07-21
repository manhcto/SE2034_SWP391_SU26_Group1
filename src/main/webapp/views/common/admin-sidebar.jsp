<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
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
        flex-shrink: 0;
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
        color: #ffffff;
    }

    .admin-user small {
        color: #94a3b8;
    }

    .sidebar-bottom {
        margin-top: auto;
    }

    @media (max-width: 992px) {
        .admin-sidebar {
            position: static;
            width: 100%;
            height: auto;
        }
    }
</style>

<aside class="${empty param.sidebarClass ? 'admin-sidebar' : param.sidebarClass}">
    <div class="brand-box">
        <div class="brand-logo${empty param.brandLogoClass ? '' : ' '.concat(param.brandLogoClass)}">AD</div>
        <h2>WonderVN</h2>
        <p>Admin Control Center</p>
    </div>

    <a class="sidebar-link${param.activeAdminMenu eq 'home' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/home">
        <i class="fa-solid fa-house"></i>
        <span>Trang chủ quản trị</span>
    </a>

    <div class="nav-section-title">Quản trị hệ thống</div>

    <a class="sidebar-link${param.activeAdminMenu eq 'dashboard' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="fa-solid fa-chart-line"></i>
        <span>Báo cáo tổng quan</span>
    </a>

    <a class="sidebar-link${param.activeAdminMenu eq 'user' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/user">
        <i class="fa-solid fa-users-gear"></i>
        <span>Quản lí người dùng</span>
    </a>

    <a class="sidebar-link${param.activeAdminMenu eq 'tour' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/tour">
        <i class="fa-solid fa-map-location-dot"></i>
        <span>Quản lý tour</span>
    </a>

    <a class="sidebar-link${param.activeAdminMenu eq 'booking' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/booking">
        <i class="fa-solid fa-calendar-check"></i>
        <span>Quản lý booking</span>
    </a>

    <a class="sidebar-link${param.activeAdminMenu eq 'voucher' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/voucher">
        <i class="fa-solid fa-ticket"></i>
        <span>Duyệt Voucher</span>
    </a>

    <a class="sidebar-link${param.activeAdminMenu eq 'feedback' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/feedback">
        <i class="fa-solid fa-comments"></i>
        <span>Đánh giá khách hàng</span>
    </a>

    <a class="sidebar-link${param.activeAdminMenu eq 'blog' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/admin/blog">
        <i class="fa-solid fa-newspaper"></i>
        <span>Quản lí blog</span>
    </a>

    <div class="sidebar-bottom">
        <div class="nav-section-title">Tài khoản</div>

        <div class="admin-user">
            <div class="avatar">AD</div>
            <div>
                <div class="fw-bold">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                <small>Quản trị viên</small>
            </div>
        </div>

        <a class="sidebar-link${param.activeAdminMenu eq 'profile' ? ' active' : ''}"
           href="${pageContext.request.contextPath}/admin/profile">
            <i class="fa-solid fa-user"></i>
            <span>Hồ sơ</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>
