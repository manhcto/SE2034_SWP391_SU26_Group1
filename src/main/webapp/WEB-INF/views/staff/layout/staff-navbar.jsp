<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="staff-sidebar">
    <div class="staff-brand">
        <div class="staff-brand-mark">W</div>
        <div>WonderVN <span class="staff-brand-accent">Staff</span></div>
    </div>

    <nav class="staff-menu">
        <a class="${activeMenu == 'tours' || empty activeMenu ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/tours">▣ Quản lý tour</a>
        <a href="${pageContext.request.contextPath}/staff/tours">▣ Lịch khởi hành</a>
        <a class="${activeMenu == 'staffAssignments' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/assignments">▣ Phân công nhân sự</a>
        <a class="${activeMenu == 'resources' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/resources">▣ Phân bổ tài nguyên</a>
        <a href="${pageContext.request.contextPath}/staff/tours">▣ Booking</a>
        <a href="${pageContext.request.contextPath}/staff/tours">▣ Yêu cầu tour riêng</a>
        <a href="${pageContext.request.contextPath}/staff/tours">▣ Báo cáo</a>
    </nav>

    <a class="staff-profile-card ${activeMenu == 'profile' ? 'active-profile-card' : ''}" href="${pageContext.request.contextPath}/staff/profile">
        <div class="staff-profile-avatar">
            <c:choose>
                <c:when test="${not empty profile}"><c:out value="${profile.avatarText}" /></c:when>
                <c:otherwise>S</c:otherwise>
            </c:choose>
        </div>
        <div>
            <div class="staff-profile-name">
                <c:choose>
                    <c:when test="${not empty profile}"><c:out value="${profile.fullName}" /></c:when>
                    <c:otherwise>Hồ sơ cá nhân</c:otherwise>
                </c:choose>
            </div>
            <div class="staff-profile-role">
                <c:choose>
                    <c:when test="${not empty profile}"><c:out value="${profile.staffTypeText}" /></c:when>
                    <c:otherwise>Thông tin tài khoản</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div>›</div>
    </a>
</aside>
