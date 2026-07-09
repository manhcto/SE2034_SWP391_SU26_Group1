<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Danh sách Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .booking-list-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .booking-list-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
            overflow-x: auto;
        }

        .booking-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 980px;
        }

        .booking-table th,
        .booking-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            font-size: 14px;
            color: #111827;
        }

        .booking-table th {
            background: #f9fafb;
            color: #374151;
            font-weight: 800;
        }

        .booking-table tr:hover {
            background: #f9fafb;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 999px;
            background: #fef3c7;
            color: #92400e;
            font-size: 13px;
            font-weight: 700;
        }

        .price-text {
            color: #dc2626;
            font-weight: 800;
            white-space: nowrap;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: nowrap;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 14px;
            border-radius: 999px;
            background: #2563eb;
            color: #ffffff;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
        }

        .action-link:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        .edit-link {
            background: #f59e0b;
        }

        .edit-link:hover {
            background: #d97706;
            color: #ffffff;
        }

        .empty-box {
            text-align: center;
            padding: 40px 20px;
            color: #6b7280;
            font-size: 16px;
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="booking-list-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Booking</p>
                <h2>Danh sách Booking</h2>
                <p>Danh sách các đơn đặt tour đã được ghi nhận trong hệ thống.</p>
            </div>
        </div>

        <div class="booking-list-card">
            <c:choose>
                <c:when test="${empty bookingList}">
                    <div class="empty-box">
                        Chưa có đơn đặt tour nào.
                    </div>
                </c:when>

                <c:otherwise>
                    <table class="booking-table">
                        <thead>
                        <tr>
                            <th>Mã Booking</th>
                            <th>Khách hàng</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach items="${bookingList}" var="booking">
                            <tr>
                                <td>${booking.bookingCode}</td>

                                <td>${booking.firstName} ${booking.lastName}</td>

                                <td>${booking.email}</td>

                                <td>${booking.phone}</td>

                                <td>
                                    <fmt:formatDate value="${booking.bookDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>

                                <td>
                                    <span class="status-badge">
                                        <c:choose>
                                            <c:when test="${booking.status == 'Pending'}">Đang xử lý</c:when>
                                            <c:when test="${booking.status == 'Confirmed'}">Đã duyệt</c:when>
                                            <c:when test="${booking.status == 'Cancelled'}">Đã hủy</c:when>
                                            <c:when test="${booking.status == 'Completed'}">Đã hoàn thành</c:when>
                                            <c:otherwise>${booking.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>

                                <td>
                                    <span class="price-text">
                                        <fmt:formatNumber value="${booking.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                    </span>
                                </td>

                                <td>
                                    <div class="action-group">
                                        <a class="action-link"
                                           href="${pageContext.request.contextPath}/booking-summary?bookingID=${booking.bookingID}">
                                            Xem chi tiết
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>
