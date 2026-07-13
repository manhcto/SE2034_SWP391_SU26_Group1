<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Danh sách Feedback</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .feedback-list-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .feedback-list-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 24px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
            overflow-x: auto;
        }

        .top-action {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 18px;
        }

        .feedback-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        .feedback-table th,
        .feedback-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            font-size: 14px;
            color: #111827;
            vertical-align: middle;
        }

        .feedback-table th {
            background: #f9fafb;
            color: #374151;
            font-weight: 800;
        }

        .feedback-table tr:hover {
            background: #f9fafb;
        }

        .rate-text {
            color: #f59e0b;
            font-weight: 800;
            white-space: nowrap;
        }

        .content-text {
            max-width: 280px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 999px;
            background: #f3f4f6;
            color: #374151;
            font-size: 13px;
            font-weight: 700;
        }

        .status-visible {
            background: #dcfce7;
            color: #166534;
        }

        .status-hidden {
            background: #fee2e2;
            color: #991b1b;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: nowrap;
        }

        .action-link,
        .add-link {
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

        .action-link:hover,
        .add-link:hover {
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

        .add-link {
            height: 42px;
            padding: 0 18px;
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
    <section class="feedback-list-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Feedback</p>
                <c:choose>
                    <c:when test="${filterType == 'tour'}">
                        <h2>Feedback của Tour #${filterID}</h2>
                        <p>Các đánh giá của khách hàng đã đặt tour này.</p>
                    </c:when>
                    <c:when test="${filterType == 'accommodation'}">
                        <h2>Feedback của Nơi lưu trú #${filterID}</h2>
                        <p>Các đánh giá của khách hàng đã đặt nơi lưu trú này.</p>
                    </c:when>
                    <c:otherwise>
                        <h2>Danh sách Feedback</h2>
                        <p>Danh sách các đánh giá của khách hàng trong hệ thống.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="feedback-list-card">
            <div class="top-action">
                <a class="add-link" href="${pageContext.request.contextPath}/feedback-add">
                    Thêm feedback
                </a>
            </div>

            <c:choose>
                <c:when test="${empty feedbackList}">
                    <div class="empty-box">
                        Chưa có feedback nào.
                    </div>
                </c:when>

                <c:otherwise>
                    <table class="feedback-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Rate</th>
                            <th>Nội dung</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th>User ID</th>
                            <th>Booking ID</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach items="${feedbackList}" var="feedback">
                            <tr>
                                <td>${feedback.feedbackID}</td>

                                <td>
                                    <span class="rate-text">${feedback.rate} / 5</span>
                                </td>

                                <td>
                                    <div class="content-text">
                                        <c:choose>
                                            <c:when test="${not empty feedback.content}">
                                                ${feedback.content}
                                            </c:when>
                                            <c:otherwise>Không có nội dung</c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>

                                <td>
                                    <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>

                                <td>
                                    <span class="status-badge ${feedback.status == 'Visible' ? 'status-visible' : 'status-hidden'}">
                                            ${feedback.status}
                                    </span>
                                </td>

                                <td>${feedback.userID}</td>

                                <td>${feedback.bookingID}</td>

                                <td>
                                    <div class="action-group">
                                        <a class="action-link"
                                           href="${pageContext.request.contextPath}/feedback-detail?feedbackID=${feedback.feedbackID}">
                                            Xem chi tiết
                                        </a>

                                        <a class="action-link edit-link"
                                           href="${pageContext.request.contextPath}/feedback-edit?feedbackID=${feedback.feedbackID}">
                                            Sửa
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