<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="currentPath" value="${pageContext.request.servletPath}" />
<c:set var="requestUri" value="${pageContext.request.requestURI}" />
<c:set var="isTourActive" value="${currentPath eq '/staff/tour' || fn:contains(requestUri, '/staff/tour') || fn:contains(currentPath, 'tour-list.jsp') || fn:contains(currentPath, 'tour-form.jsp') || fn:contains(currentPath, 'tour-detail.jsp') || fn:contains(currentPath, 'tour-schedule-')}" />

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
        display: flex;
        flex-direction: column;
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
        background: linear-gradient(135deg, #06b6d4, #4e46dc);
        color: #ffffff;
        transform: translateX(4px);
        box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22);
    }

    .staff-sidebar-link.active {
        background: linear-gradient(135deg, #06b6d4, #4e46dc);
        color: #ffffff;
        box-shadow: 0 10px 22px rgba(6, 182, 212, 0.22);
    }

    .staff-sidebar-user {
        margin-top: auto;
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
        color: #ffffff;
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
        <div class="staff-brand-logo">ST</div>
        <h2>WonderVN</h2>
        <p>Khu vực nhân viên</p>
    </div>

    <div class="staff-nav-section-title">Dịch vụ du lịch</div>

    <a class="staff-sidebar-link${isTourActive ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/tour">
        <i class="fa-solid fa-map-location-dot"></i>
        <span>Quản lý tour</span>
    </a>

    <a class="staff-sidebar-link${currentPath eq '/staff/accommodation' || fn:contains(requestUri, '/staff/accommodation') ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/accommodation?action=list">
        <i class="fa-solid fa-hotel"></i>
        <span>Quản lý lưu trú</span>
    </a>

    <div class="staff-nav-section-title">Vận hành</div>

    <a class="staff-sidebar-link${currentPath eq '/staff/booking' || fn:contains(requestUri, '/staff/booking') ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/booking">
        <i class="fa-solid fa-calendar-check"></i>
        <span>Quản lý booking</span>
    </a>

    <a class="staff-sidebar-link${currentPath eq '/staff/voucher' || fn:contains(requestUri, '/staff/voucher') ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/voucher">
        <i class="fa-solid fa-gift"></i>
        <span>Quản lý voucher</span>
    </a>

    <a class="staff-sidebar-link${currentPath eq '/staff/assignment' || fn:contains(requestUri, '/staff/assignment') ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/assignment">
        <i class="fa-solid fa-user-tie"></i>
        <span>Điều phối hướng dẫn viên</span>
    </a>

    <div class="staff-nav-section-title">Nội dung và CSKH</div>

    <a class="staff-sidebar-link${currentPath eq '/staff/blog' || fn:contains(requestUri, '/staff/blog') ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/blog">
        <i class="fa-solid fa-newspaper"></i>
        <span>Quản lý blog</span>
    </a>

    <a class="staff-sidebar-link${currentPath eq '/staff/feedback' || fn:contains(requestUri, '/staff/feedback') ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/feedback">
        <i class="fa-solid fa-comments"></i>
        <span>Đánh giá khách hàng</span>
    </a>

    <div class="staff-sidebar-user">
        <div class="staff-sidebar-avatar">ST</div>
        <div>
            <div style="font-weight: 900;">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
            <small>Nhân viên</small>
        </div>
    </div>

    <a class="staff-sidebar-link${currentPath eq '/staff/profile' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/staff/profile">
        <i class="fa-solid fa-user"></i>
        <span>Hồ sơ</span>
    </a>

    <a class="staff-sidebar-link" href="${pageContext.request.contextPath}/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Đăng xuất</span>
    </a>
</aside>
