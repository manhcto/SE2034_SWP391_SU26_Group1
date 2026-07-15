<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Danh sách đánh giá</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .feedback-list-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .top-action {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 18px;
        }

        .add-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 44px;
            padding: 0 20px;
            border-radius: 999px;
            background: #2563eb;
            color: #ffffff;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
        }

        .add-link:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        .alert-box {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 22px;
            font-size: 15px;
            line-height: 1.6;
        }

        .alert-success {
            background: #dcfce7;
            border: 1px solid #86efac;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            border: 1px solid #f87171;
            color: #b91c1c;
        }

        .feedback-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 22px 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            margin-bottom: 18px;
        }

        .feedback-card-head {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 10px;
        }

        .feedback-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #dbeafe;
            color: #1d4ed8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 800;
            flex-shrink: 0;
        }

        .feedback-user-name {
            font-size: 15px;
            font-weight: 800;
            color: #111827;
        }

        .feedback-date {
            font-size: 13px;
            color: #6b7280;
        }

        .feedback-stars {
            color: #f59e0b;
            font-size: 18px;
            letter-spacing: 2px;
            margin-bottom: 8px;
        }

        .feedback-stars .star-empty {
            color: #d1d5db;
        }

        .feedback-content {
            font-size: 15px;
            color: #374151;
            line-height: 1.7;
            white-space: pre-line;
            word-break: break-word;
        }

        .feedback-image-box {
            margin-top: 12px;
        }

        .feedback-image-box img {
            max-width: 220px;
            max-height: 160px;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            object-fit: cover;
            cursor: zoom-in;
        }

        .empty-box {
            text-align: center;
            padding: 50px 20px;
            color: #6b7280;
            font-size: 16px;
            background: #ffffff;
            border: 1px dashed #d1d5db;
            border-radius: 14px;
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="feedback-list-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Đánh giá</p>
                <c:choose>
                    <c:when test="${filterType == 'tour'}">
                        <h2>Đánh giá của Tour #${filterID}</h2>
                        <p>Các đánh giá đã được duyệt của khách hàng đã đặt tour này.</p>
                    </c:when>
                    <c:when test="${filterType == 'accommodation'}">
                        <h2>Đánh giá của Nơi lưu trú #${filterID}</h2>
                        <p>Các đánh giá đã được duyệt của khách hàng đã đặt nơi lưu trú này.</p>
                    </c:when>
                    <c:otherwise>
                        <h2>Danh sách đánh giá</h2>
                        <p>Vui lòng chọn tour hoặc nơi lưu trú để xem đánh giá.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${param.success == '1'}">
            <div class="alert-box alert-success">
                ✔ Đã gửi đánh giá thành công! Đánh giá của bạn sẽ hiển thị công khai sau khi được nhân viên duyệt.
            </div>
        </c:if>

        <c:if test="${param.error == 'notCompleted'}">
            <div class="alert-box alert-error">
                ⚠ Bạn chỉ có thể viết đánh giá khi đã có booking ở trạng thái "Hoàn thành"
                cho <c:choose><c:when test="${filterType == 'tour'}">tour</c:when><c:otherwise>nơi lưu trú</c:otherwise></c:choose> này.
            </div>
        </c:if>

        <c:if test="${not empty filterType}">
            <div class="top-action">
                <c:choose>
                    <c:when test="${filterType == 'tour'}">
                        <a class="add-link"
                           href="${pageContext.request.contextPath}/feedback-add?tourID=${filterID}">
                            + Thêm đánh giá
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="add-link"
                           href="${pageContext.request.contextPath}/feedback-add?accommodationID=${filterID}">
                            + Thêm đánh giá
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty feedbackList}">
                <div class="empty-box">
                    Chưa có đánh giá nào. Hãy là người đầu tiên chia sẻ trải nghiệm của bạn!
                </div>
            </c:when>

            <c:otherwise>
                <c:forEach items="${feedbackList}" var="feedback">
                    <div class="feedback-card">
                        <div class="feedback-card-head">
                            <div class="feedback-avatar">
                                    ${fn:toUpperCase(fn:substring(feedback.userName, 0, 1))}
                            </div>
                            <div>
                                <div class="feedback-user-name">${feedback.userName}</div>
                                <div class="feedback-date">
                                    <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <div class="feedback-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= feedback.rate}">★</c:when>
                                    <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>

                        <div class="feedback-content">${feedback.content}</div>

                        <c:if test="${not empty feedback.image}">
                            <div class="feedback-image-box">
                                <a href="${pageContext.request.contextPath}/${feedback.image}" target="_blank">
                                    <img src="${pageContext.request.contextPath}/${feedback.image}"
                                         alt="Ảnh đánh giá">
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>
