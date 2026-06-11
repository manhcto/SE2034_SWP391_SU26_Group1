<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Sửa Feedback</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .feedback-edit-container {
            max-width: 850px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .feedback-edit-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
        }

        .feedback-info {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 24px;
        }

        .feedback-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px 24px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .info-label {
            color: #6b7280;
            font-size: 13px;
        }

        .info-value {
            color: #111827;
            font-size: 15px;
            font-weight: 700;
        }

        .error-box {
            max-width: 850px;
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 20px 24px;
            border-radius: 10px;
            border: 1px solid #f87171;
            margin: 0 auto 34px;
            font-size: 16px;
            line-height: 1.7;
        }

        .error-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 17px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .error-box ul {
            margin: 0;
            padding-left: 24px;
        }

        .single-error {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 16px 20px;
            border-radius: 8px;
            border: 1px solid #f87171;
            margin-bottom: 24px;
            font-weight: 700;
        }

        .feedback-form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 22px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            color: #374151;
            font-size: 14px;
            font-weight: 700;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 12px 14px;
            font-size: 14px;
            color: #111827;
            outline: none;
            box-sizing: border-box;
            background: #ffffff;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .form-group textarea {
            min-height: 130px;
            resize: vertical;
        }

        .hint-text {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        .form-actions {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 14px;
            margin-top: 28px;
            flex-wrap: wrap;
        }

        .btn-submit,
        .btn-back {
            min-width: 170px;
            height: 48px;
            padding: 0 22px;
            border-radius: 999px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
            cursor: pointer;
            transition: 0.2s;
            box-sizing: border-box;
        }

        .btn-submit {
            background: #2563eb;
            color: #ffffff;
            border: 1px solid #2563eb;
        }

        .btn-submit:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
        }

        .btn-back {
            background: #ffffff;
            color: #2563eb;
            border: 1px solid #2563eb;
        }

        .btn-back:hover {
            background: #eff6ff;
        }

        @media (max-width: 768px) {
            .feedback-info-grid,
            .feedback-form-grid {
                grid-template-columns: 1fr;
            }

            .btn-submit,
            .btn-back {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/views/common/client-header.jsp" />

<main>
    <section class="feedback-edit-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Feedback</p>
                <h2>Sửa Feedback</h2>
                <p>Cập nhật nội dung đánh giá. Feedback sau khi sửa vẫn có thể chờ staff duyệt trước khi hiển thị.</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="single-error">
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty errors}">
            <div class="error-box">
                <div class="error-title">
                    <span>⚠</span>
                    <span>Vui lòng kiểm tra lại các thông tin sau:</span>
                </div>

                <ul>
                    <c:forEach items="${errors}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <c:if test="${not empty feedback}">
            <div class="feedback-edit-card">
                <div class="feedback-info">
                    <div class="feedback-info-grid">
                        <div class="info-item">
                            <span class="info-label">Feedback ID</span>
                            <span class="info-value">${feedback.feedbackID}</span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Ngày tạo</span>
                            <span class="info-value">
                                <fmt:formatDate value="${feedback.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">User ID</span>
                            <span class="info-value">${feedback.userID}</span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Booking ID</span>
                            <span class="info-value">${feedback.bookingID}</span>
                        </div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/feedback-edit" method="post" novalidate>
                    <input type="hidden" name="feedbackID" value="${feedback.feedbackID}">

                    <div class="feedback-form-grid">
                        <div class="form-group">
                            <label for="rate">Điểm đánh giá</label>
                            <select id="rate" name="rate">
                                <option value="">-- Chọn điểm đánh giá --</option>
                                <option value="1" ${feedback.rate == 1 ? 'selected' : ''}>1 - Rất không hài lòng</option>
                                <option value="2" ${feedback.rate == 2 ? 'selected' : ''}>2 - Không hài lòng</option>
                                <option value="3" ${feedback.rate == 3 ? 'selected' : ''}>3 - Bình thường</option>
                                <option value="4" ${feedback.rate == 4 ? 'selected' : ''}>4 - Hài lòng</option>
                                <option value="5" ${feedback.rate == 5 ? 'selected' : ''}>5 - Rất hài lòng</option>
                            </select>
                            <span class="hint-text">Chọn điểm đánh giá từ 1 đến 5.</span>
                        </div>

                        <div class="form-group">
                            <label for="status">Trạng thái</label>
                            <select id="status" name="status">
                                <option value="Hidden" ${feedback.status == 'Hidden' ? 'selected' : ''}>Hidden - Chờ duyệt</option>
                                <option value="Visible" ${feedback.status == 'Visible' ? 'selected' : ''}>Visible - Hiển thị</option>
                            </select>
                            <span class="hint-text">Customer thường để Hidden để staff duyệt.</span>
                        </div>

                        <div class="form-group full">
                            <label for="image">Ảnh minh họa</label>
                            <input type="text"
                                   id="image"
                                   name="image"
                                   maxlength="500"
                                   value="${feedback.image}">
                            <span class="hint-text">Có thể để trống hoặc nhập đường dẫn ảnh.</span>
                        </div>

                        <div class="form-group full">
                            <label for="content">Nội dung feedback</label>
                            <textarea id="content"
                                      name="content"
                                      maxlength="1000"
                                      placeholder="Nhập cảm nhận của bạn về tour hoặc dịch vụ...">${feedback.content}</textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            Lưu thay đổi
                        </button>

                        <a href="${pageContext.request.contextPath}/feedback-detail?feedbackID=${feedback.feedbackID}"
                           class="btn-back">
                            Quay lại chi tiết
                        </a>

                        <a href="${pageContext.request.contextPath}/feedback-list"
                           class="btn-back">
                            Danh sách feedback
                        </a>
                    </div>
                </form>
            </div>
        </c:if>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>