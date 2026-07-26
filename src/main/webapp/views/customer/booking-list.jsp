<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn booking | WonderVN</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f7fb;
            color: #0f172a;
        }

        .booking-body {
            padding: 24px;
            overflow-x: auto;
        }

        .booking-table {
            width: 100%;
            min-width: 980px;
            border-collapse: separate;
            border-spacing: 0;
        }

        .booking-table th {
            padding: 13px 12px;
            background: #f8fafc;
            border-bottom: 1px solid #e5eaf3;
            color: #475569;
            text-align: left;
            font-size: 11px;
            font-weight: 900;
            letter-spacing: 0.45px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .booking-table td {
            padding: 16px 12px;
            border-bottom: 1px solid #edf2f7;
            color: #0f172a;
            font-size: 13px;
            font-weight: 700;
            vertical-align: middle;
        }

        .booking-table tr:last-child td {
            border-bottom: 0;
        }

        .booking-code {
            color: #1d4ed8;
            font-weight: 900;
            white-space: nowrap;
        }

        .muted {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            margin-top: 4px;
        }

        .status-badge {
            min-height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #fff7ed;
            color: #c2410c;
            font-size: 11px;
            font-weight: 900;
            letter-spacing: 0.35px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .status-badge.confirmed,
        .status-badge.completed {
            background: #ecfdf5;
            color: #047857;
        }

        .status-badge.end,
        .status-badge.ended {
            background: #ede9fe;
            color: #6d28d9;
        }

        .status-badge.cancelled {
            background: #fef2f2;
            color: #dc2626;
        }

        .price-text {
            color: #dc2626;
            font-size: 14px;
            font-weight: 900;
            white-space: nowrap;
        }

        .identity-cell {
            min-width: 150px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .identity-thumb {
            width: 44px;
            height: 32px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid #dbe5f2;
            background: #f8fafc;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-link {
            min-height: 34px;
            padding: 0 12px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #2563eb;
            color: #ffffff;
            font-size: 11px;
            font-weight: 900;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 0.35px;
            white-space: nowrap;
        }

        .action-link:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        .empty-box {
            padding: 54px 24px;
            text-align: center;
        }

        .empty-box i {
            color: #94a3b8;
            font-size: 34px;
            margin-bottom: 14px;
        }

        .empty-box h3 {
            margin: 0;
            color: #0f172a;
            font-size: 20px;
            font-weight: 900;
        }

        .empty-box p {
            margin: 8px 0 0;
            color: #64748b;
            font-size: 14px;
            font-weight: 600;
        }
    </style>
</head>

<body>
<jsp:include page="/views/common/client-header.jsp"/>

<main class="account-page">
    <div class="account-shell">
        <jsp:include page="/views/common/account-sidebar.jsp"/>

        <section class="account-content">
            <article class="account-panel">
                <div class="account-panel-head">
                    <p class="account-kicker">Tài khoản</p>
                    <h1 class="account-title">Đơn booking</h1>
                    <p class="account-subtitle">Theo dõi các đơn tour và lưu trú đã đặt bằng tài khoản của bạn.</p>
                </div>

                <c:choose>
                    <c:when test="${empty bookingList}">
                        <div class="empty-box">
                            <i class="fa-solid fa-receipt"></i>
                            <h3>Chưa có đơn booking</h3>
                            <p>Các đơn tour và lưu trú của bạn sẽ xuất hiện tại đây.</p>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="booking-body">
                            <table class="booking-table">
                                <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Dịch vụ</th>
                                    <th>Khách hàng</th>
                                    <th>CCCD</th>
                                    <th>Ngày đặt</th>
                                    <th>Trạng thái</th>
                                    <th>Tổng tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>

                                <tbody>
                                <c:forEach items="${bookingList}" var="booking">
                                    <tr>
                                        <td>
                                            <div class="booking-code">${booking.bookingCode}</div>
                                            <div class="muted">${booking.displayType}</div>
                                        </td>

                                        <td>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty booking.serviceName}">
                                                        ${booking.serviceName}
                                                    </c:when>
                                                    <c:otherwise>Chưa có dịch vụ</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <c:if test="${not empty booking.serviceStartDate}">
                                                <div class="muted">
                                                    <fmt:formatDate value="${booking.serviceStartDate}" pattern="dd/MM/yyyy"/>
                                                    -
                                                    <fmt:formatDate value="${booking.serviceEndDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </c:if>
                                        </td>

                                        <td>
                                            <div>${booking.firstName} ${booking.lastName}</div>
                                            <div class="muted">${booking.phone}</div>
                                        </td>

                                        <td>
                                            <div class="identity-cell">
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${not empty booking.identityNumber}">
                                                            ${booking.identityNumber}
                                                        </c:when>
                                                        <c:otherwise>Không có</c:otherwise>
                                                    </c:choose>
                                                </span>

                                                <c:if test="${not empty booking.identityImageUrl}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(booking.identityImageUrl, 'http')}">
                                                            <c:set var="identityImageSrc" value="${booking.identityImageUrl}"/>
                                                        </c:when>
                                                        <c:when test="${fn:startsWith(booking.identityImageUrl, '/')}">
                                                            <c:set var="identityImageSrc" value="${pageContext.request.contextPath}${booking.identityImageUrl}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="identityImageSrc" value="${pageContext.request.contextPath}/${booking.identityImageUrl}"/>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <a href="${identityImageSrc}" target="_blank" rel="noopener">
                                                        <img class="identity-thumb" src="${identityImageSrc}" alt="Ảnh CCCD">
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>

                                        <td>
                                            <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>

                                        <td>
                                            <span class="status-badge ${fn:toLowerCase(booking.status)}">
                                                    ${booking.displayStatus}
                                            </span>
                                        </td>

                                        <td>
                                            <span class="price-text">
                                                <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VND
                                            </span>
                                        </td>

                                        <td>
                                            <div class="action-group">
                                                <a class="action-link"
                                                   href="${pageContext.request.contextPath}/booking-summary?bookingID=${booking.bookingID}">
                                                    <i class="fa-solid fa-eye"></i>
                                                    Xem
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </article>
        </section>
    </div>
</main>

<jsp:include page="/views/common/client-footer.jsp"/>
</body>
</html>
