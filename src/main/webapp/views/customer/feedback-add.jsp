<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>WonderVN | Thêm Feedback</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .feedback-form-container {
            max-width: 850px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .feedback-form-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
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

        .error-box li {
            margin-bottom: 4px;
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
    <section class="feedback-form-container">
        <div class="section-head" style="justify-content: center; text-align: center; margin-bottom: 36px;">
            <div>
                <p class="section-kicker">Feedback</p>
                <h2>Thêm Feedback</h2>
                <p>Feedback của bạn sẽ được gửi lên hệ thống và chờ staff duyệt trước khi hiển thị công khai.</p>
            </div>
        </div>

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

        <div class="feedback-form-card">
            <form action="${pageContext.request.contextPath}/feedback-add" method="post" novalidate>
                <div class="feedback-form-grid">
                    <div class="form-group">
                        <label for="rate">Điểm đánh giá</label>
                        <select id="rate" name="rate">
                            <option value="">-- Chọn điểm đánh giá --</option>
                            <option value="1" ${not empty feedback && feedback.rate == 1 ? 'selected' : ''}>
                                1 - Rất không hài lòng
                            </option>
                            <option value="2" ${not empty feedback && feedback.rate == 2 ? 'selected' : ''}>
                                2 - Không hài lòng
                            </option>
                            <option value="3" ${not empty feedback && feedback.rate == 3 ? 'selected' : ''}>
                                3 - Bình thường
                            </option>
                            <option value="4" ${not empty feedback && feedback.rate == 4 ? 'selected' : ''}>
                                4 - Hài lòng
                            </option>
                            <option value="5" ${not empty feedback && feedback.rate == 5 ? 'selected' : ''}>
                                5 - Rất hài lòng
                            </option>
                        </select>
                        <span class="hint-text">Chọn điểm đánh giá từ 1 đến 5.</span>
                    </div>

                    <div class="form-group">
                        <label for="image">Ảnh minh họa</label>
                        <input type="text"
                               id="image"
                               name="image"
                               maxlength="500"
                               value="${not empty feedback ? feedback.image : ''}">
                        <span class="hint-text">Có thể để trống hoặc nhập đường dẫn ảnh.</span>
                    </div>

                    <div class="form-group">
                        <label for="userID">User ID</label>
                        <input type="text"
                               id="userID"
                               name="userID"
                               inputmode="numeric"
                               value="${not empty feedback && feedback.userID > 0 ? feedback.userID : '2'}">
                        <span class="hint-text">Chỉ nhập số. Không nhập chữ hoặc ký tự đặc biệt.</span>
                    </div>

                    <div class="form-group">
                        <label for="bookingID">Booking ID</label>
                        <input type="text"
                               id="bookingID"
                               name="bookingID"
                               inputmode="numeric"
                               value="${not empty feedback && feedback.bookingID > 0 ? feedback.bookingID : (not empty bookingID ? bookingID : '1')}">
                        <span class="hint-text">Chỉ nhập số. Không nhập chữ hoặc ký tự đặc biệt.</span>
                    </div>

                    <div class="form-group full">
                        <label for="content">Nội dung feedback</label>
                        <textarea id="content"
                                  name="content"
                                  maxlength="1000"
                                  placeholder="Nhập cảm nhận của bạn về tour hoặc dịch vụ...">${not empty feedback ? feedback.content : ''}</textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        Gửi feedback
                    </button>

                    <a href="${pageContext.request.contextPath}/feedback-list"
                       class="btn-back">
                        Quay lại danh sách
                    </a>
                </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="/views/common/client-footer.jsp" />

<button class="scroll-top" id="scrollTop" type="button">↑</button>
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>