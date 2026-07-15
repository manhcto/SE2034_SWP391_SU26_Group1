<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .account-page {
        min-height: calc(100vh - 84px);
        background: #f5f7fb;
        padding: 34px 24px 54px;
        font-family: "Be Vietnam Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
    }

    .account-shell {
        max-width: 1240px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: 238px minmax(0, 1fr);
        gap: 22px;
        align-items: start;
    }

    .account-sidebar {
        position: sticky;
        top: 106px;
        background: #ffffff;
        border: 1px solid #e5eaf3;
        border-radius: 18px;
        padding: 14px;
        box-shadow: 0 16px 36px rgba(15, 23, 42, 0.07);
    }

    .account-user {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 10px 14px;
        border-bottom: 1px solid #edf2f7;
        margin-bottom: 10px;
    }

    .account-user-avatar {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #e2e8f0;
        background: #f8fafc;
    }

    .account-user-name {
        color: #0f172a;
        font-size: 13px;
        font-weight: 900;
        line-height: 1.25;
    }

    .account-user-email {
        color: #64748b;
        font-size: 11px;
        font-weight: 600;
        margin-top: 3px;
        max-width: 140px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .account-nav {
        display: grid;
        gap: 6px;
    }

    .account-nav-link {
        min-height: 44px;
        border-radius: 12px;
        padding: 0 12px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #475569;
        text-decoration: none;
        font-size: 12px;
        font-weight: 900;
        letter-spacing: 0.35px;
        text-transform: uppercase;
        transition: 0.18s ease;
    }

    .account-nav-link i {
        width: 18px;
        text-align: center;
        color: #64748b;
    }

    .account-nav-link:hover,
    .account-nav-link.active {
        background: #eef6ff;
        color: #0b63f6;
    }

    .account-nav-link:hover i,
    .account-nav-link.active i {
        color: #0b63f6;
    }

    .account-content {
        min-width: 0;
    }

    .account-panel {
        background: #ffffff;
        border: 1px solid #e5eaf3;
        border-radius: 18px;
        box-shadow: 0 16px 36px rgba(15, 23, 42, 0.07);
        overflow: hidden;
    }

    .account-panel-head {
        padding: 24px 28px;
        border-bottom: 1px solid #edf2f7;
    }

    .account-kicker {
        margin: 0 0 8px;
        color: #2563eb;
        font-size: 11px;
        font-weight: 900;
        letter-spacing: 0.9px;
        text-transform: uppercase;
    }

    .account-title {
        margin: 0;
        color: #0f172a;
        font-size: 26px;
        font-weight: 900;
        letter-spacing: 0;
        line-height: 1.2;
    }

    .account-subtitle {
        margin: 8px 0 0;
        color: #64748b;
        font-size: 14px;
        font-weight: 600;
        line-height: 1.6;
    }

    @media (max-width: 900px) {
        .account-page {
            padding: 22px 14px 40px;
        }

        .account-shell {
            grid-template-columns: 1fr;
        }

        .account-sidebar {
            position: static;
        }

        .account-nav {
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .account-nav-link {
            justify-content: center;
            padding: 0 8px;
            font-size: 10px;
        }

        .account-nav-link i {
            display: none;
        }
    }
</style>

<aside class="account-sidebar">
    <div class="account-user">
        <img class="account-user-avatar"
             src="${pageContext.request.contextPath}/assets/images/default-avatar.jpg"
             alt="Avatar">
        <div>
            <div class="account-user-name">
                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
            </div>
            <div class="account-user-email">${sessionScope.user.email}</div>
        </div>
    </div>

    <nav class="account-nav" aria-label="Tài khoản">
        <a class="account-nav-link ${activeAccountTab == 'profile' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/profile">
            <i class="fa-solid fa-user"></i>
            Hồ sơ
        </a>
        <a class="account-nav-link ${activeAccountTab == 'bookings' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/booking-list">
            <i class="fa-solid fa-receipt"></i>
            Đơn booking
        </a>
        <a class="account-nav-link ${activeAccountTab == 'vouchers' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/my-vouchers">
            <i class="fa-solid fa-ticket"></i>
            Voucher
        </a>
    </nav>
</aside>
