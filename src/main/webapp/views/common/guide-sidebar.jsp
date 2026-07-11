<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="${empty param.sidebarClass ? 'workspace-sidebar' : param.sidebarClass}">
    <div class="brand-box">
        <div class="brand-logo${empty param.brandLogoClass ? '' : ' '.concat(param.brandLogoClass)}">TG</div>
        <h2>WonderVN</h2>
        <p>Tour Guide Workspace</p>
    </div>

    <a class="sidebar-link${param.activeGuideMenu eq 'home' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/guide/home">
        <i class="fa-solid fa-house"></i>
        <span>Trang chu huong dan vien</span>
    </a>

    <div class="nav-section-title">Nhiem vu tour</div>

    <a class="sidebar-link${param.activeGuideMenu eq 'assignment' ? ' active guide' : ''}"
       href="${pageContext.request.contextPath}/guide/assignment">
        <i class="fa-solid fa-clipboard-list"></i>
        <span>Tour duoc phan cong</span>
    </a>

    <c:if test="${param.showGuideWorkspaceLinks eq 'true'}">
        <a class="sidebar-link" href="#confirmedTours">
            <i class="fa-solid fa-circle-check"></i>
            <span>Tour da xac nhan</span>
        </a>

        <a class="sidebar-link" href="#tourUpdates">
            <i class="fa-solid fa-pen-to-square"></i>
            <span>Cap nhat tour</span>
        </a>
    </c:if>

    <div class="nav-section-title">Tai khoan</div>

    <a class="sidebar-link${param.activeGuideMenu eq 'profile' ? ' active' : ''}"
       href="${pageContext.request.contextPath}/guide/profile">
        <i class="fa-solid fa-user"></i>
        <span>Ho so</span>
    </a>

    <a class="sidebar-link" href="${pageContext.request.contextPath}/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Dang xuat</span>
    </a>
</aside>
