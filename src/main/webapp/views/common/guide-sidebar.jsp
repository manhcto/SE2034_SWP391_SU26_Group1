<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="${empty param.sidebarClass ? 'workspace-sidebar' : param.sidebarClass} guide-sidebar-shell">
    <div class="brand-box">
        <div class="brand-logo guide">TG</div>
        <h2>WonderVN</h2>
        <p>Khu vực hướng dẫn viên</p>
    </div>

    <a class="sidebar-link${param.activeGuideMenu eq 'home' ? ' active guide' : ''}"
       href="${pageContext.request.contextPath}/guide/home">
        <i class="fa-solid fa-house"></i>
        <span>Trang chủ hướng dẫn viên</span>
    </a>

    <div class="nav-section-title">Nhiệm vụ tour</div>

    <a class="sidebar-link${param.activeGuideMenu eq 'assignment' ? ' active guide' : ''}"
       href="${pageContext.request.contextPath}/guide/assignment">
        <i class="fa-solid fa-clipboard-list"></i>
        <span>Tour được phân công</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/home#confirmedTours">
        <i class="fa-solid fa-circle-check"></i>
        <span>Tour đã xác nhận</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/guide/home#tourUpdates">
        <i class="fa-solid fa-pen-to-square"></i>
        <span>Cập nhật tour</span>
    </a>

    <div class="sidebar-bottom">
        <div class="nav-section-title">Tài khoản</div>

        <div class="guide-user workspace-user">
            <div class="avatar workspace-avatar guide">TG</div>
            <div>
                <div class="fw-bold">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                        </c:when>
                        <c:otherwise>Hướng dẫn viên</c:otherwise>
                    </c:choose>
                </div>
                <small>Hướng dẫn viên</small>
            </div>
        </div>

        <a class="sidebar-link${param.activeGuideMenu eq 'profile' ? ' active guide' : ''}"
           href="${pageContext.request.contextPath}/guide/profile">
            <i class="fa-solid fa-user"></i>
            <span>Hồ sơ</span>
        </a>

        <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>
