<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="currentPath" value="${pageContext.request.servletPath}" />

<style>
    .staff-sidebar {
        width: 292px;
        background: #0f172a;
        color: #ffffff;
        position: sticky;
        top: 0;
        height: 100vh;
        overflow-y: auto;
        padding: 26px 18px;
        box-shadow: 8px 0 26px rgba(15, 23, 42, 0.18);
        flex-shrink: 0;
    }

    .staff-sidebar::-webkit-scrollbar {
        width: 7px;
    }

    .staff-sidebar::-webkit-scrollbar-thumb {
        background: #334155;
        border-radius: 20px;
    }

    .staff-brand-box {
        padding: 8px 10px 22px;
        margin-bottom: 12px;
        border-bottom: 1px solid rgba(148, 163, 184, 0.25);
    }

    .staff-brand-logo {
        width: 52px;
        height: 52px;
        border-radius: 18px;
        background: linear-gradient(135deg, #06b6d4, #4e46dc);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 900;
        font-size: 20px;
        margin-bottom: 12px;
    }

    .staff-brand-box h2 {
        font-size: 26px;
        font-weight: 900;
        margin: 0;
        letter-spacing: -0.6px;
    }

    .staff-brand-box p {
        color: #cbd5e1;
        margin: 5px 0 0;
        font-size: 14px;
    }

    .staff-nav-section-title {
        font-size: 11px;
        text-transform: uppercase;
        color: #94a3b8;
        letter-spacing: 1.2px;
        margin: 22px 12px 10px;
        font-weight: 900;
    }

    .staff-sidebar-link {
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

    .staff-sidebar-link i {
        width: 22px;
        text-align: center;
        font-size: 16px;
    }

    .staff-sidebar-link:hover {
        background: #1e293b;
        color: white;
        transform: translateX(4px);
    }

    .staff-sidebar-link.active {
        background: linear-gradient(135deg, #06b6d4, #4e46dc);
        color: white;
        box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22);
    }

    .staff-sidebar-user {
        margin-top: 26px;
        border-top: 1px solid rgba(148, 163, 184, 0.25);
        padding: 18px 8px 4px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .staff-sidebar-avatar {
        width: 46px;
        height: 46px;
        border-radius: 50%;
        background: linear-gradient(135deg, #06b6d4, #22c55e);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 900;
        color: white;
    }

    .staff-sidebar-user small {
        color: #94a3b8;
    }

    @media (max-width: 992px) {
        .staff-sidebar {
            position: static;
            width: 100%;
            height: auto;
        }
    }
</style>

<aside class="staff-sidebar">
    <div class="staff-brand-box">
        <div class="staff-brand-logo">WV</div>
        <h2>WonderVN</h2>
        <p>Travel ERP System</p>
    </div>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/staff-home.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/home">
        <i class="fa-solid fa-house"></i>
        <span>Trang chủ nhân viên</span>
    </a>

    <div class="staff-nav-section-title">Dịch vụ du lịch</div>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/tour-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/tour">
        <i class="fa-solid fa-map-location-dot"></i>
        <span>Quản lý Tour</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/accommodation-management.jsp' || currentPath == '/views/staff/accommodation-detail.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/accommodation?action=list">
        <i class="fa-solid fa-hotel"></i>
        <span>Quản lý lưu trú</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/vehicle-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/vehicle?action=list">
        <i class="fa-solid fa-car-side"></i>
        <span>Quản lý phương tiện</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/service-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/service">
        <i class="fa-solid fa-briefcase"></i>
        <span>Quản lý dịch vụ</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/ticket-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/external-ticket">
        <i class="fa-solid fa-ticket"></i>
        <span>Vé tham quan bên ngoài</span>
    </a>

    <div class="staff-nav-section-title">Vận hành</div>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/staff-booking-list.jsp' || currentPath == '/views/staff/staff-booking-edit.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/booking">
        <i class="fa-solid fa-calendar-check"></i>
        <span>Quản lý đặt chỗ</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/payment-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/payment">
        <i class="fa-solid fa-credit-card"></i>
        <span>Quản lý thanh toán</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/voucher-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/voucher">
        <i class="fa-solid fa-gift"></i>
        <span>Quản lý Voucher</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/assignment-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/assignment">
        <i class="fa-solid fa-user-tie"></i>
        <span>Điều phối hướng dẫn viên</span>
    </a>

    <div class="staff-nav-section-title">Nội dung & CSKH</div>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/blog-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/blog">
        <i class="fa-solid fa-newspaper"></i>
        <span>Quản lý Blog</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/staff-feedback-list.jsp' || currentPath == '/views/staff/staff-feedback-detail.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/feedback">
        <i class="fa-solid fa-comments"></i>
        <span>Đánh giá khách hàng</span>
    </a>

    <a class="staff-sidebar-link ${currentPath == '/views/staff/notification-management.jsp' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/staff/notification">
        <i class="fa-solid fa-bell"></i>
        <span>Cấu hình thông báo</span>
    </a>

    <div class="staff-sidebar-user">
        <div class="staff-sidebar-avatar">ST</div>
        <div>
            <div style="font-weight: 900;">Nhân viên</div>
            <small>Staff</small>
        </div>
    </div>
</aside>
